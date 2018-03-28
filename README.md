## Scratchies (*lottery like* minigame for Exile Mod)
[![Version](https://img.shields.io/badge/Version-1.4-green.svg)](https://github.com/ole1986/a3-exile-scratchie/releasese)
[![Author](https://img.shields.io/badge/Author-ole1986-green.svg)](https://github.com/ole1986)
[![Exile](https://img.shields.io/badge/Exile-1.0.4%20Pineapple-C72651.svg)](http://www.exilemod.com/downloads/)
[![Arma](https://img.shields.io/badge/Arma-1.80-blue.svg)]
[![License](https://img.shields.io/badge/License-APL-blue.svg)](https://www.bistudio.com/community/licenses/arma-public-license)

<p align="center">
    <img src="images/scratchie-xm8apps.PNG" width="250" title="Buy a scratch, get the prize">
    <img src="images/scratchie-xm8apps-inside.PNG" width="250" title="Use the scratchie in XM8">
</p>
<p align="center">
    <img src="images/prize-vehicle.jpg" width="250" title="Prize Vehicle">
    <img src="images/prize-poptabs.jpg" width="250" title="Prize Poptabs">
    <img src="images/winner-message.png" width="250" title="Prize Weapons">
</p>

Videos: [PART #1](https://www.youtube.com/watch?v=zVPXYhhYrbU) [PART #2](https://www.youtube.com/watch?v=2MC45ycnOkc) - thanks to Rythron

## Requirements

+ Arma 3 Tools (installed through Steam - https://community.bistudio.com/wiki/Arma_3_Tools_Installation)
+ ExAd mod (https://github.com/Bjanski/ExAd)

## Build

You can either use Visual Studio code or the powershell to build from source
Use the below command to build server pbo

```
PS> .\setup.ps1 -Build
```

Use the below command to patch your mission file (a dialog will be prompted to select the mission pbo).
PLEASE NOTE: Your mission file must contain the ExAd files. Otherwise an error will appear

```
PS> .\setup.ps1 -PatchMission
```

## ExAd Implementation (manually)

If for some reason the command `setup.ps1 -PatchMission` does not work for you, the below steps are required to become the Scratchies available in XM8

**Requirements**

Please note that the Scratchie plugin has the following ExAd dependencies

* Core
* XM8

**Installation**

* Copy the folder "source\ExAdClient\Scratchie" into "mpmissions\exile.\ExAdClient"

* Open the "mpmissions\exile.\ExAdClient\CfgFunctions.cpp" and add the following line inside `class ExAd`

```
#include "Scratchie\CfgFunctions.cpp"
```

* Amend the `class CfgXM8` from "mpmissions\exile.\config.cpp" the following (to make Scratchie app available in XM8)

```
class CfgXM8 {
    extraApps[] = {"ExAd_Scratchie"};

    class ExAd_Scratchie
	{
		title = "Play Scratchie";
		controlID = 80000;
        logo = "ExAdClient\Scratchie\icons\scratchie.paa";
        onLoad = "ExAdClient\Scratchie\onLoad.sqf";
		onOpen = "ExAdClient\Scratchie\onOpen.sqf";
		onClose = "ExAdClient\Scratchie\onClose.sqf";
	};
}
```

* Customize the "mpmissions\exile.\description.ext" by adding the below line into `class CfgRemoteExec` -> `class Functions`

```
class ExileServer_lottery_network_request { allowedTargets = 2; }
```

## Server Installation

Copy the below files into the destination folder of the Arma 3 server root directory

Location                                 | Server Directory
---------------------------------------- | ----------------------
@ExileServer\addons\scratchie_server.pbo | @ExileServer\addons\
@MissionFile\Exile.&lt;Map&gt;.pbo       | mpmissions

## Database setup

+ Import the mysql file `mysql\lottery.sql` into your exile database (either through mysql or phpmyadmin).
+ Copy and repalce the `mysql\exile.ini` with the file located in `<ExileServerMod>\extDB\sql_custom_v2\exile.ini`

## Battleye

When you use Battleye, please amend the below BE files to allow remote calls

**scripts.txt**

+ add the below to the end of line `7 remoteexec`

 `!="remoteExecCall [\"ExileServer_lottery_network_request\"," !="remoteExecCall ['ExileServer_lottery_network_request',"`
 
**remoteexec.txt**

+ add the below to the end of line `7 ""`

 `!"ExileServer_lottery_network_request"`

## Finalize

Once all the steps are done, a restart of the Arma 3 server is necessary.

