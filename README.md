## Scratchies (*lottery like* MINIGAME for Exile Mod) v0.2

This extension is licensed under the Arma Public Licence (APL)

Author: ole1986

### Required Tools

+ PBO Manager (I use cpbo from http://www.kegetys.fi/category/gaming/armamods/)
+ Notepad++ or any other Text Editor (https://notepad-plus-plus.org/)

### Prerequisite

Before you can start it is necessary to **unpack** the &lt;MissionFile&gt; and the &lt;ExileServer&gt; using your favorite pbo manager

Placeholder         | File
------------------- | -------------
&lt;MissionFile&gt; | Exile.&lt;Mapname&gt;.pbo (E.g. Exile.Altis.pbo )
&lt;ExileServer&gt; | exile_server.pbo

### Exile Mission modifications

+ Copy the overrides folder into your extracted &lt;MissionFile&gt;

+ Modify the &lt;MissionFile&gt;\config.cpp and add the below line inside `class CfgExileCustomCode`

```
	ExileClient_gui_xm8_slide_apps_onOpen = "overrides\ExileClient_gui_xm8_slide_apps_onOpen.sqf";
```

+ Modify the &lt;MissionFile&gt;\description.ext and add he below line inside  `class CfgRemoteExec -> class Functions`

```
class ExileServer_lottery_network_request { allowedTargets=2; };
```

### Exile Server modifications (exile_server.pbo - not exile_server_config.pbo)

*For some reason it does not allow me to use new files in exile_server_config.pbo. thats why its located in exile_server.pbo*

+ Copy the code folder into the extracted &lt;ExileServer&gt; directory

```
ExileServer_lottery_network_request.sqf
ExileServer_lottery_network_winner.sqf
```

+ Open exile_server.pbo\bootstrap\fn_preInit.sqf and insert the below two lines

```
['ExileServer_lottery_network_request', 'exile_server\code\ExileServer_lottery_network_request.sqf'],
['ExileServer_lottery_network_winner', 'exile_server\code\ExileServer_lottery_network_winner.sqf'],
```

*right after `forEach [` and before `['ExileServer_object_construction_database_delete...`*

### Buy / Get Prize code line

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

### Battleye (let the fun begin)

+ add the below to the end of line `7 remoteexec` (line number 19?!) in your scripts.txt

 `!="remoteExecCall ["ExileServer_lottery_network_request\","`

+ add the below to the end of line `7 ""` in your remoteexec.txt

 `!"ExileServer_lottery_network_request"`
