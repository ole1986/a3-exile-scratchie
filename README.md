## Scratchies (*lottery like* minigame for Exile Mod)
[![Version](https://img.shields.io/badge/Version-1.5-green.svg)](https://github.com/ole1986/a3-exile-scratchie/releasese)
[![Author](https://img.shields.io/badge/Author-ole1986-green.svg)](https://github.com/ole1986)
[![Exile](https://img.shields.io/badge/Exile-1.0.4%20Pineapple-C72651.svg)](http://www.exilemod.com/downloads/)
![Arma](https://img.shields.io/badge/Arma-1.80-blue.svg)
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

* Arma 3 with [ExileMod 1.0.4](http://www.exilemod.com/downloads/)

## Installation

By default this package is shipped with a `build` folder containing all neccessary file to be copied. Please follow the below steps to install the required server and mission files

* Copy the folder `build\@ScratchieServer` into your Arma 3 server directory
* Copy the mission file located in `build\@MissionFile` into your Arma 3 serer `mpmission` directory

To allow the scratchie mod using some database commands it is important replace the `@ExileServer\extDB\sql_custom_v2\exile.ini` with its `mysql\exile.ini` and overwrite it

## Database Setup

The Scratchie mod requires some database tables being installed onto your database server (similar to the ExileMod).
In the below example, we use the **mysql client from command line** install the `mysql\scratchie.sql` file

```
C:\User\xxx\Downloads\a3-exile-scratchie> mysql -uexile -p exile
mysql> source mysql\scratchie.sql
```

## Battleye

When you use Battleye, please amend the below BE files to allow remote calls

**scripts.txt**

+ add the below to the end of line `7 remoteexec`

 `!="remoteExecCall [\"ExileServer_lottery_network_request\"," !="remoteExecCall ['ExileServer_lottery_network_request',"`
 
**remoteexec.txt**

+ add the below to the end of line `7 ""`

 `!"ExileServer_lottery_network_request"`

## Run Arma 3

### Server

Once all steps are properly done (without errors) it is time to restart the server. Most important here is to include the `@ScratchieServer` mod into the startup parameter. See below example

`arma3server.exe -autoInit  "-profiles=xxx" "-config=xxx\server.cfg" -serverMod=@ScratchieServer;@ExileServer -mod=@Exile`

### Client

Make sure `@Exile` mod is enabled when running Arma 3

# Advanced User / Developer

As this project uses the ArmaDev extension for Visual Studio Code (vscode). The instruction will strongly focus on the use of this extension.

## Requirements

* All requirements from the **Installation** chapter
* [Arma 3 Tools](https://community.bistudio.com/wiki/Arma_3_Tools_Installation)
* [Visual Studio Code](https://code.visualstudio.com/)
* [ArmaDev extension](https://marketplace.visualstudio.com/items?itemName=ole1986.arma-dev)

**PLEASE NOTE:** This guide is addressed to advanced users and developers

## Configure Scratchie

You can configure several settings for the Scratchies mod in the configuration file `source\scratchie_server\config.cpp`. To name a few

* Setup the `Interval` on how often player can win
* Customize the `Price` how much a scratchie cost
* Define what prizes a player can win through the `PrizeType[]` setting (vehicle, poptab or weapon)
* and much more...

All changes made in this files requires to repack the scratchie_server.pbo and upload to the server.
You can use the ArmaDev extension from vscode with the command `Arma 3: Build` to repack it.

## Patch mission file

The below patched mission files are available in `build\MissionFile` and can be used as is to make Scratchie buttons available in XM8.

* Exile.Altis
* Exile.Malden
* Exile.Namalsk
* Exile.Tanoa

If you have a custom mission (which most of you have I guess), please continue reading

#### Edit description.ext

Add the below line at the bottom of `CfgRemoteExec -> Functions` (see animation)

```
class ExileServer_lottery_network_request { allowedTargets = 2; }
```

![Mission description.ext](images/guide-mission-description.gif)

#### Edit config.cpp

Customize the buttons for XM8 by adding the below lines into the predefined `XM8_AppXX_Button` class.
In this example button 06 - 08 are being used

```c
/* play button */
textureNoShortcut = "scratchie\icons\scratchie.paa";
text = "Play Scratchie";
onButtonClick = "['use',ExileClientSessionId, player, ''] remoteExecCall ['ExileServer_lottery_network_request', 2];";
resource = "";
```

```c
/* buy button */
textureNoShortcut = "scratchie\icons\scratchie-buy.paa";
text = "Buy Scratchie";
onButtonClick = "['buy',ExileClientSessionId, player, ''] remoteExecCall ['ExileServer_lottery_network_request', 2];";
resource = "";
```

```c
/* get prize */
textureNoShortcut = "scratchie\icons\scratchie-prize.paa";
text = "Get Prize";
onButtonClick = "['get',ExileClientSessionId, player, ''] remoteExecCall ['ExileServer_lottery_network_request', 2];";
resource = "";
```

![Mission config.cpp](images/guide-mission-config.gif)

#### Copy Button Images

Copy the `source\MissionFile\Scratchie` folder into the root of your mission file to make the button images available