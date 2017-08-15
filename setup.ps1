Param(
    [switch]$Build = $false,
    [switch]$PatchMission = $false
)

function Get-SteamPath()
{
    $regItem = (Get-ItemProperty -Path Registry::HKEY_CURRENT_USER\Software\Valve\Steam -Name SteamPath -EA SilentlyContinue)
    if(!$regItem) {
        Write-Error  "No registry item found for Steam"
        Exit
    }

    $steamPath = (Get-ItemProperty -Path Registry::HKEY_CURRENT_USER\Software\Valve\Steam -Name SteamPath).SteamPath
    if(!$steamPath) {
        Write-Error  "No Steam installation found"
        Exit
    }
    return $steamPath
}

function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "PBO (*.pbo)| *.pbo"
    $OpenFileDialog.ShowDialog() | Out-Null
    return $OpenFileDialog.filename
}

function Get-CodeBlockLastLineNumber($content, $FuncName) 
{
    $openBracket = 0
    $startLine = ($content | Select-String -Pattern "class $FuncName").LineNumber

    if(!$startLine) { return }

    for ($i = $startLine; $i -lt $content.Count; $i++) {
        $c = $content[$i] -replace """.*?""", ""
        $c = $c -replace "'.*?'", ""
        for ($j = 0; $j -lt $c.Length; $j++) {
            if($c[$j] -eq "{") {
                $openBracket += 1
            } elseif($c[$j] -eq "}") {
                $openBracket -= 1
            }
        }
        if($openBracket -le 0) {
            break
        }
    }
    return $i - 1
}

$steamPath = Get-SteamPath
$AddonBuilder = "$steamPath/steamapps/common/Arma 3 Tools/AddonBuilder/AddonBuilder.exe"
$BankRev = "$steamPath/steamapps/common/Arma 3 Tools/BankRev/BankRev.exe"

if(!(Test-Path $AddonBuilder)) {
    Write-Host -ForegroundColor Red "Addon Builder from Arma 3 Tools not found"
    Write-Host "You can install it through Steam - https://community.bistudio.com/wiki/Arma_3_Tools_Installation"
    Exit
}

if($Build) {
    Write-Host -ForegroundColor DarkYellow "AddonBuilder: Building Server PBO"
    & "$AddonBuilder" "$PSScriptRoot\\source\\scratchie_server" "$PSScriptRoot\\@ExileServer\\addons" -packonly
    Write-Host "###################"
    Write-Host "# BUILD COMPLETED #"
    Write-Host "###################"
}

if($PatchMission) {
    Write-Host -ForegroundColor Green "Please select your mission file from the dialog:"
    $missionFile = Get-FileName($PSScriptRoot)

    if(!$missionFile) {
        Write-Host "Canceled by user action"
        Exit
    }

    $extractedFolder = (Get-Item $missionFile).Basename
    New-Item "$env:TEMP\build" -ItemType Directory -Force | Out-Null
    $extractedPath = "$env:TEMP\build\$extractedFolder"
    & "$BankRev" -f "$env:TEMP\build" "$missionFile"
    Write-Host "Copying mission related files into $extractedPath"
    Copy-Item "$PSScriptRoot\source\MissionFile\*" -Destination "$extractedPath" -Recurse -Force

    $content = Get-Content "$extractedPath\config.cpp"

    if(!$content) {
        Write-Host -ForegroundColor Red "The config.cpp could not be found in the mission file $extractedFolder - Canceled"
        Exit
    }

    Write-Host -NoNewline "Trying to patch file $extractedPath\config.cpp..."
    if(!($content -match "ExileClient_gui_xm8_slide_apps_onOpen")) {
        
        $lastLineNumber = Get-CodeBlockLastLineNumber $content -FuncName "CfgExileCustomCode"

        if(!$lastLineNumber) {
            Write-Host -ForegroundColor Red "FAILED (User action required - Sorry)"
            Exit
        }
        
        $content[$lastLineNumber] += "`n    ExileClient_gui_xm8_slide_apps_onOpen = ""overrides\ExileClient_gui_xm8_slide_apps_onOpen.sqf"";"
        $content | Set-Content "$extractedPath\config.cpp"
    } else {
        Write-Host -ForegroundColor Yellow "Already patched"
    }
    
    Write-Host ""
    $content = Get-Content "$extractedPath\description.ext"

    if(!$content) {
        Write-Host -ForegroundColor Red "The description.ext could not be found in the mission file $extractedFolder - Very Strange! - Canceled"
        Exit
    }

    Write-Host -NoNewline "Trying to patch file $extractedPath\description.ext..."

    if(!($content -match "class ExileServer_lottery_network_request")) {
        $lastLineNumber = Get-CodeBlockLastLineNumber $content -FuncName "Functions"
        if(!$lastLineNumber) {
            Write-Host -ForegroundColor Red "FAILED (User action required - Sorry)"
            Exit
        }

        $content[$lastLineNumber] += "`n        class ExileServer_lottery_network_request { allowedTargets=2; };"
        $content | Set-Content "$extractedPath\description.ext"
    } else {
        Write-Host -ForegroundColor Yellow "Already patched"
    }

    Write-Host "Building mission file '$extractedFolder'..."
    $ERR = & "$AddonBuilder" "$extractedPath" "$PSScriptRoot\\@MissionFile" -packonly
    $ERR.GetType()
    Write-Output $ERR
    Write-Host
    if($ERR -match "\[FATAL\]") {
        Write-Host -ForegroundColor Red "An error occured while executing the Arma 3 Tools."
        Write-Host -ForegroundColor Red "Please make sure STEAM is running"
        Exit
    }

    Write-Host -ForegroundColor Green "############"
    Write-Host -ForegroundColor Green "### DONE ###"
    Write-Host -ForegroundColor Green "############"
    Write-Host -ForegroundColor Green ""
    Write-Host -ForegroundColor Green "Patched MissionFile: $PSScriptRoot\@MissionFile\$extractedFolder.pbo"
}



