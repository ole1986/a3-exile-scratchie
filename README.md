## Scratchies (*lottery like* MINIGAME for Exile Mod) v0.2

This extension is licensed under th Arma Public Licence (APL)

Author: ole1986

### Required Tools

+ Pbo Manager (I use cpbo from http://www.kegetys.fi/category/gaming/armamods/)
+ Notepad++ or any other Text Editor (https://notepad-plus-plus.org/)

### Prerequisite

Before you can start it is necessary to **unpack** the &lt;MissionFile&gt; and the &lt;ExileServer&gt;

Placeholder         | File
------------------- | -------------
&lt;MissionFile&gt; | Exile.&lt;Mapname&gt;.pbo (E.g. Exile.Altis.pbo )
&lt;ExileServer&gt; | exile_server.pbo

### Exile Mission modifications

**&lt;MissionFile&gt;\overrides\ExileClient_gui_xm8_slide_apps_onOpen.sqf**

This ExileClient file has been overwritten to display the Scratchie "button" inside of XM8

**&lt;MissionFile&gt;\config.cpp**

Add the below line inside `class CfgExileCustomCode`

```
	ExileClient_gui_xm8_slide_apps_onOpen = "overrides\ExileClient_gui_xm8_slide_apps_onOpen.sqf";
```

**&lt;MissionFile&gt;\description.ext**

Add the below line inside  `class CfgRemoteExec -> class Functions`

```
class ExileServer_lottery_network_request { allowedTargets=2; };
```

### Exile Server modifications (exile_server.pbo - not exile_server_config.pbo)

*For some reason it does not allow me to use new files in exile_server_config.pbo. thats why its located in exile_server.pbo*

**Copy the code folder into the extracted &lt;ServerFile&gt; directory**

```
ExileServer_lottery_network_request.sqf
ExileServer_lottery_network_winner.sqf
```

**Open exile_server.pbo\bootstrap\fn_preInit.sqf and insert the below two lines**

```
['ExileServer_lottery_network_request', 'exile_server\code\ExileServer_lottery_network_request.sqf'],
['ExileServer_lottery_network_winner', 'exile_server\code\ExileServer_lottery_network_winner.sqf'],
```

*right after `forEach [` and before `['ExileServer_object_construction_database_delete...`*

### Buy / Get Prize code line

*The below code can be used to buy a scratch from any object you decide*

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
