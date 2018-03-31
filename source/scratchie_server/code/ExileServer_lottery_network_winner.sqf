/**
 * Scratchie - Lottery like minigame for Exile Mod
 * @author ole1986 - https://github.com/ole1986/a3-exile-scratchie
 */

private["_playerList", "_number", "_prizes", "_curPrize", "_source","_text","_winners", "_count", "_currentPlayer"];
_winners = [];
_playerList = nil;
_number = "";
_prizes = [];

try 
{
    _number = call ExileServer_lottery_generate;

    // receive a list of all players who are participating (only those where its lucky number is not empty)
    _playerList = "getLotteryPlayers" call ExileServer_system_database_query_selectFull;
    _count = count _playerList;

    {
        _currentPlayer = nil;
        if (_count > 0) then {
            for "_i" from 0 to _count - 1 do 
            {
                // skip second loop when uid does not match
                if ((_playerList select _i) select 0 == getPlayerUid _x) exitWith {
                    _currentPlayer = _playerList select _i;
                };
            };
        };
        
        if !(isNil "_currentPlayer")  then {
            format ["DEBUG: - Checking %1 with number %2", _currentPlayer select 0, _currentPlayer select 2] call ExileServer_util_log;
            // COLLECT PLAYERS WHO HAVE THE LUCKY NUMBER - MULTIPLE
            if (_currentPlayer select 2 == _number) then {
                _winners pushBack _x;
            } else {
                [_x, "toastRequest", ["InfoTitleAndText", ["Scratchies: No luck this time!", format["The lucky number: %1<br/>You had %2", _number, _currentPlayer select 2]]]] call ExileServer_system_network_send_to;
            };
        };
        
    } forEach allPlayers;

    if (count _winners > 0) then 
    {
        // random chance to win either vehicle, poptabs or item (like guns)
        _prizes = getArray(configFile >> "CfgSettings" >> "ScratchieSettings" >> "PrizeType");
        // random prize type
        _source = _prizes call BIS_fnc_selectRandom;
                
        _prizes = getArray(configFile >> "CfgSettings" >> "ScratchieSettings" >> _source);
        // the prize itself (can be either Vehicle, Poptab or Weapon)
        _curPrize = _prizes call BIS_fnc_selectRandom;
        
        switch (_source) do {
            case "VehiclePrize": { 
                _text = "%1 won " + getText(configFile >> "CfgVehicles" >> _curPrize >> "displayName"); 
            };
            case "PoptabPrize": {
                _text = "%1 won " + (str _curPrize) + " poptabs";
            };
            case "WeaponPrize": {
                _text = "%1 won " + getText(configFile >> "CfgVehicles" >> _curPrize >> "displayName") + " crate";
            };
            default { _text = "%1 won a prize"; };
        };
        
        _text = _text + "<br /><t shadow='0' size='1.0'>in the addictive game called Scratchies</t>";
                
        // inform the players about the prize
        {
            format["SCRATCHIE: Winner is %1 - Price: %2 from %3", name vehicle _x, _curPrize, _source]  call ExileServer_util_log;
            // Save prize into database
            format["saveLotteryWinner:%1:%2:%3", getPlayerUID _x, _curPrize, _source] call ExileServer_system_database_query_insertSingle;
            
            // broadcast the winner to everyone
            if(getNumber(configFile >> "CfgSettings" >> "ScratchieSettings" >> "AnnounceWinner") > 0) then { 
                ["dynamicTextRequest", [format [_text, name _x], 0, 2, "#ffffff"]] call ExileServer_system_network_send_broadcast;
            };
            // tell it to the winner explicitly
            [_x, "dynamicTextRequest", [format [_text, "You "], 0, 2, "#ffffff"]] call ExileServer_system_network_send_to;
        } forEach _winners;
    };
    
    // Free the player, so they can participate again
    "freePlayersFromLottery" call ExileServer_system_database_query_fireAndForget;
}
catch
{
    format["ERROR: Scratchie Error: %1", _exception]  call ExileServer_util_log;
};
true