## Scratchies (*lottery like* minigame for Exile Mod)
<sub>Version: 1.0.1 ExAd | Author: ole1986 | This extension is licensed under the Arma Public Licence</sub>

PLEASE NOTE: This is the ExAd version - Scratchies without ExAd can be found [here](https://github.com/ole1986/a3-exile-scratchie)

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

## ExAd Implementation

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

Copy the below files into the same destination folder of the server Arma 3 root directory

Location                                 | Destination Folder
---------------------------------------- | ----------------------
@ExileServer\addons\scratchie_server.pbo | @ExileServer\addons\

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

