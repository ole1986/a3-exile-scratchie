/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private ['_interval'];
 
// Lottery every x seconds (300 = 5min, 900 = 15min)
_interval = getNumber(configFile >> "CfgSettings" >> "ScratchieSettings" >> "Interval");
// min 60 seconds
if (_interval < 60) then { _interval = 60 };
diag_log format["[SCRATCHIE] Initialize the Scratchie thread (every %1 seconds)", _interval];
[_interval, ExileServer_lottery_network_winner, [], true] call ExileServer_system_thread_addTask;

true