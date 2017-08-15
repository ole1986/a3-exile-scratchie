/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
private ['_code', '_function', '_file'];

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;
	
    _code = compileFinal (preprocessFileLineNumbers _file);

    missionNamespace setVariable [_function, _code];
}
forEach 
[
	['ExileServer_lottery_network_request', 'scratchie_server\code\ExileServer_lottery_network_request.sqf'],
	['ExileServer_lottery_network_winner', 'scratchie_server\code\ExileServer_lottery_network_winner.sqf'],
    ['ExileServer_lottery_crate_xtras', 'scratchie_server\code\ExileServer_lottery_crate_xtras.sqf'],
    ['ExileServer_lottery_generate', 'scratchie_server\code\ExileServer_lottery_generate.sqf']
];

diag_log "[SCRATCHIE] Loading Scratchie addon...";

true