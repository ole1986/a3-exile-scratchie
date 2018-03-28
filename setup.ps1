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

function Pack-Pbo($SourcePath, $DestinationPath, $PrivateKeyPath)
{
    $AddonBuilder = "$(Get-SteamPath)/steamapps/common/Arma 3 Tools/AddonBuilder/AddonBuilder.exe"
    if(!(Test-Path $AddonBuilder)) {
        Write-Host -ForegroundColor Red "Addon Builder from Arma 3 Tools not found"
        Write-Host "You can install it through Steam - https://community.bistudio.com/wiki/Arma_3_Tools_Installation"
        Exit
    }
    $SourcePath = [System.IO.Path]::GetFullPath($SourcePath)
    $DestinationPath = [System.IO.Path]::GetFullPath($DestinationPath)
    $TempPath = "$env:TEMP\$([System.IO.Path]::GetFileName($SourcePath))"
    
    # Cleanup AddonBuilder temp path
    Remove-Item $TempPath -Recurse -Force -ErrorAction SilentlyContinue

    if(($PrivateKeyPath) -and (Test-Path $PrivateKeyPath)) {
        $PrivateKeyPath = [System.IO.Path]::GetFullPath($PrivateKeyPath)
        $ERR = & "$AddonBuilder" "$SourcePath" "$DestinationPath" -packonly -sign="$PrivateKeyPath"
    } else {
        $ERR = & "$AddonBuilder" "$SourcePath" "$DestinationPath" -packonly
    }
    Write-Output $ERR
    if($ERR -match "\[FATAL\]") {
        Write-Host -ForegroundColor Red "An error occured while executing the Arma 3 Tools."
        Write-Host -ForegroundColor Red "Please make sure STEAM is running"
        return $false
    }
    return $true
}

function Unpack-Pbo($SourceFile, $DestinationPath)
{
    $BankRev = "$(Get-SteamPath)/steamapps/common/Arma 3 Tools/BankRev/BankRev.exe"
    & "$BankRev" -f "$DestinationPath" "$SourceFile"
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

if($Build) {
    Write-Host "Building Server PBO"
    if(!(Pack-Pbo "source\scratchie_server" "@ExileServer\addons")) {
        Exit
    }
    Write-Host "###################"
    Write-Host "# BUILD COMPLETED #"
    Write-Host "###################"
}

if($PatchMission) {
    Write-Host -ForegroundColor Green "Please select your mission containing ExAd:"
    $missionFile = Get-FileName($PSScriptRoot)

    if(!$missionFile) {
        Write-Host "Canceled by user action"
        Exit
    }

    $extractedFolder = (Get-Item $missionFile).Basename
    New-Item "$env:TEMP\build" -ItemType Directory -Force | Out-Null
    $extractedPath = "$env:TEMP\build\$extractedFolder"

    # Cleanup existing folder
    Write-Host "Cleanup previous temp folder.."
    Remove-Item -Recurse -Force "$extractedPath\*" -ErrorAction SilentlyContinue

    # Unpack the mission file
    Unpack-Pbo "$missionFile" "$env:TEMP\build"

    $content = Get-Content "$extractedPath\config.cpp" -ErrorAction SilentlyContinue
    
    if(!$content) {
        Write-Host -ForegroundColor Red "The config.cpp could not be found in the mission file $extractedFolder - Canceled"
        Exit
    }

    $ExAdConfig = Get-Content "$extractedPath\ExAdClient\CfgFunctions.cpp" -ErrorAction SilentlyContinue

    if(!$ExAdConfig) {
        Write-Host -ForegroundColor Red "The ExAdClient could not be found in $extractedFolder - Please install ExAd first (incl. XM8 plugin)"
        Exit;
    }

    if(!(Test-Path "$extractedPath\ExAdClient\XM8" -PathType Container)) {
        Write-Host -ForegroundColor Red "The XM8 plugin is not installed in ExAdClient - Please install the XM8 plugin (copying the floder is NOT enough)"
        Exit;
    }

    Write-Host "Copying mission related files into $extractedPath"
    Copy-Item "source\ExAdClient\*" -Destination "$extractedPath\ExAdClient" -Recurse -Force

    Write-Host -NoNewline "Trying to patch ExAdClient\CfgFunctions.cpp..."

    if(!($ExAdConfig -match "\s+?#include ""Scratchie\\CfgFunctions.cpp""")) {
        $lastLineNumber = Get-CodeBlockLastLineNumber $ExAdConfig -FuncName "ExAd"
        if(!$lastLineNumber) {
            Write-Host -ForegroundColor Red "FAILED (ExAd class not found)"
            Exit
        }

        $ExAdConfig[$lastLineNumber] += "`n`t#include ""Scratchie\CfgFunctions.cpp"""
        $ExAdConfig | Set-Content "$extractedPath\ExAdClient\CfgFunctions.cpp"
        Write-Host -ForegroundColor Green "OK"
    } else {
        Write-Host -ForegroundColor Yellow "Already patched"
    }

    $content = Get-Content "$extractedPath\description.ext" -ErrorAction SilentlyContinue

    if(!$content) {
        Write-Host -ForegroundColor Red "The description.ext could not be found in the mission file $extractedFolder - Very Strange! - Canceled"
        Exit
    }

    Write-Host -NoNewline "Trying to patch description.ext..."

    if(!($content -match "class ExileServer_lottery_network_request")) {
        $lastLineNumber = Get-CodeBlockLastLineNumber $content -FuncName "Functions"
        if(!$lastLineNumber) {
            Write-Host -ForegroundColor Red "FAILED (User action required - Sorry)"
            Exit
        }

        $content[$lastLineNumber] += "`n        class ExileServer_lottery_network_request { allowedTargets=2; };"
        $content | Set-Content "$extractedPath\description.ext"
        Write-Host -ForegroundColor Green "OK"
    } else {
        Write-Host -ForegroundColor Yellow "Already patched"
    }

    $content = Get-Content "$extractedPath\config.cpp" -ErrorAction SilentlyContinue

    if(!$content) {
        Write-Host -ForegroundColor Red "The config.cpp could not be found in the mission file $extractedFolder - Canceled"
        Exit
    }

    Write-Host -NoNewline "Trying to patch config.cpp (CfgXM8)..."

    $lastLineNumber = Get-CodeBlockLastLineNumber $content -FuncName "CfgXM8"
    if(!$lastLineNumber) {
        Write-Host -ForegroundColor Red "FAILED (CfgXM8 is missing in the config.cpp)"
        Exit
    }

    $scratchieLine = Get-CodeBlockLastLineNumber $content -FuncName "ExAd_Scratchie"

    if(!$scratchieLine) {
        $content[$lastLineNumber] += "
    class ExAd_Scratchie
    {
        title = ""Play Scratchie"";
        controlID = 80000;
        logo = ""ExAdClient\Scratchie\icons\scratchie.paa"";
        onLoad = ""ExAdClient\Scratchie\onLoad.sqf"";
        onOpen = ""ExAdClient\Scratchie\onOpen.sqf"";
        onClose = ""ExAdClient\Scratchie\onClose.sqf"";
    };"
    
        $extraApps = $content | Select-String -Pattern "extraApps\[\]"

        if($extraApps) {
            $content[$extraApps.LineNumber - 1] = $extraApps.Line -replace "\};", ",""ExAd_Scratchie""};"
        }

        $content | Set-Content "$extractedPath\config.cpp"
        Write-Host -ForegroundColor Green "OK"
    } else {
        Write-Host -ForegroundColor Yellow "Already patched"
    }
    

    Write-Host "Building mission file '$extractedFolder'..."
    if(! (Pack-Pbo "$extractedPath" "@MissionFile")) {
        Exit
    }

    Write-Host -ForegroundColor Green "############"
    Write-Host -ForegroundColor Green "### DONE ###"
    Write-Host -ForegroundColor Green "############"
    Write-Host -ForegroundColor Green ""
    Write-Host -ForegroundColor Green "Patched MissionFile: $PSScriptRoot\@MissionFile\$extractedFolder.pbo"
}



