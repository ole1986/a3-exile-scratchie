## Scratchies (*lottery like* minigame for Exile Mod)
<sub>Version: 1.4 | Author: ole1986 | This extension is licensed under the Arma Public Licence</sub>

[![Arma 1.76](https://img.shields.io/badge/Arma-1.76-blue.svg)](https://dev.arma3.com/post/sitrep-00203) [![Exile 1.0.3 Lemon](https://img.shields.io/badge/Exile-1.0.3%20Lemon-C72651.svg)](http://www.exilemod.com/devblog/103-update-lemon-r34/)

<p align="center">
    <img src="images/buyget.jpg" width="250" title="Buy a scratch, get the prize">
    <img src="images/usexm8.jpg" width="250" title="Use the scratchie in XM8">
</p>
<p align="center">
    <img src="images/prize-vehicle.jpg" width="250" title="Prize Vehicle">
    <img src="images/prize-poptabs.jpg" width="250" title="Prize Poptabs">
    <img src="images/prize-weapon.jpg" width="250" title="Prize Weapons">
</p>

Videos: [PART #1](https://www.youtube.com/watch?v=zVPXYhhYrbU) [PART #2](https://www.youtube.com/watch?v=2MC45ycnOkc) - thanks to Rythron

## Requirements

+ Arma 3 Tools (installed through Steam - https://community.bistudio.com/wiki/Arma_3_Tools_Installation)

## Build

You can either use Visual Studio code or the powershell to build and patch all necessary files

Use the below command to build server pbo

```
PS> .\setup.ps1 -Build
```

Use the below command to patch your mission file (a dialog will be prompted to select the mission pbo)

```
PS> .\setup.ps1 -PatchMission
```

## Install

After you have followed the steps from the **Build** chapter, the below files are being generated.
Copy these files to your server into the **correct** destination directory

Location                                 | Destination Folder
---------------------------------------- | ----------------------
@MissionFile\<Your.Mission.pbo>          | mpmission
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

## Finish

After all the below steps are properly done, please RESTART the Arma 3 server and log into the game.
You should see three additional "apps" when opening XM8

## Advanced Setup

### Buy Scratchies from Traders

*The below code can be used to buy a scratchie from any object you decide*

`["buy",ExileClientSessionId, player, ""] remoteExecCall ["ExileServer_lottery_network_request", 2];`

*The below code can be used to get the prize, when player has won*

`["get",ExileClientSessionId, player, ""] remoteExecCall ["ExileServer_lottery_network_request", 2];`

**Example implementation to Buy/Get Prize from the office (&lt;MissionFile&gt;\initPlayerLocal.sqf)**
```
_officeTrader = [
    "Exile_Trader_Office",
    "GreekHead_A3_04",
    ["InBaseMoves_SittingRifle1"],
    [0, -0.15, -0.45],
    180.008,
    _chair
]
call ExileClient_object_trader_create;
// add the buy scratchie and get prize as action menu to the office trader
_officeTrader addAction ["<t color='#FFFFFF'>Buy Scratchie(200,-)</t>", { ["buy",ExileClientSessionId, player, ""] remoteExecCall ["ExileServer_lottery_network_request", 2]; }];
_officeTrader addAction ["<t color='#c72651'>Get Prize!</t>", { ["get",ExileClientSessionId, player, ""] remoteExecCall ["ExileServer_lottery_network_request", 2]; }];
```

### Developer Hints

This project was developed using Visual Studio Code and uses git to manage the source code.
Feel free to Pull Request your changes.

Thank you
