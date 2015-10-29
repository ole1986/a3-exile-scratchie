/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_health","_popTabsValue","_popTabs","_respectValue","_respect", "_serverInfo", "_newControl"];
disableSerialization;

_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
_health = _display displayCtrl 4057;
_health ctrlSetStructuredText parseText (format ["<t color='#00b2cd' font='OrbitronLight' size='1.6' valign='middle' align='center' shadow='0'><br/><br/><br/><t font='OrbitronMedium' size='3.5' color='#ffffff'>%1%2</t><br/>HEALTH</t>", round ((1 - damage player) * 100), "%"]);
_popTabsValue = ExileClientPlayerMoney;
if (_popTabsValue > 999) then
{
	_popTabsValue = format ["%1k", floor (_popTabsValue / 1000)];
};
_popTabs = _display displayCtrl 4058;
_popTabs ctrlSetTooltip format["%1", ExileClientPlayerMoney];
_popTabs ctrlSetStructuredText parseText (format ["<t color='#00b2cd' font='OrbitronLight' size='1.6' valign='middle' align='center' shadow='0'><br/><br/><br/><t font='OrbitronMedium' size='3.5' color='#ffffff'>%1</t><br/>POP TABS</t>", _popTabsValue]);
_respectValue = ExileClientPlayerScore;
if (_respectValue > 999) then
{
	_respectValue = format ["%1k", floor (_respectValue / 1000)];
};
_respect = _display displayCtrl 4059;
_respect ctrlSetTooltip format["%1", ExileClientPlayerScore];
_respect ctrlSetStructuredText parseText (format ["<t color='#00b2cd' font='OrbitronLight' size='1.6' valign='middle' align='center' shadow='0'><br/><br/><br/><t font='OrbitronMedium' size='3.5' color='#ffffff'>%1</t><br/>RESPECT</t>", _respectValue]);

// clear server info button text
_serverInfo = _display displayCtrl 1107;
_serverInfo ctrlSetText " ";

updateScratchieText = {
	_txt = "<t size='0.9'><img image='addons\lottery\scratchie.paa' size='3.5' shadow='true' /><br/>%1 %2</t>";
	_this ctrlSetStructuredText parseText (format [_txt, "", "counting..."]);
	[_this, _txt] spawn {
		sleep 5;
		_this select 0 ctrlSetStructuredText parseText (format [_this select 1, missionNamespace getVariable ["scratchieCount", 0], "Scratchies"]);
	};
};

_newControl = _display ctrlCreate ["RscExileXM8ButtonMenu", 9898, _display displayCtrl 4040];
_newControl ctrlSetPosition [(23.5 - 3) * (0.025), (15 - 2) * (0.04)];
_newControl ctrlCommit 0.01;
_newControl ctrlSetEventHandler ["ButtonClick", "['use',ExileClientSessionId, player, ''] remoteExecCall ['ExileServer_lottery_network_request', 2]; _this select 0 call updateScratchieText"];

['',ExileClientSessionId, player, ''] remoteExecCall ['ExileServer_lottery_network_request', 2];
_newControl call updateScratchieText;