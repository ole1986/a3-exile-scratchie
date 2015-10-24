/**
 * Scratchies for Exile Mod v0.1
 * © 2015 ole
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_payload", "_request", "_sessionId", "_number", "_player", "_result", "_hasBet", "_prize", "_scratchie","_scratchieCost", "_playerMoney", "_vehicleObject", "_safepos", "_clientId"];
_payload = _this;
// YOU CAN SET THE PRICE FOR A SCRATCHIE HERE
_scratchieCost = 200;
_scratchie = 0;
_result = true;
try 
{
    _request = _payload select 0; // what to do
    _sessionId = _payload select 1; // Exile session
    _player = _payload select 2; // player
    _number = _payload select 3; // lottery number
    
    if (_number == "") then 
    {
        _number = format ["%1%2%3", round(random 3) , round(random 3) , round(random 3) ];
    };
    
    format ["DEBUG: ExileServer_lottery_network_request called - Request: %1 SessionId: %2 Number: %3", _request,_sessionId, _number] call ExileServer_util_log;
    
    // check if the player has already participated a lottery for this round
    _hasBet = format ["playerInLottery:%1", getPlayerUID _player] call ExileServer_system_database_query_selectSingle;          
    if !(isNil "_hasBet") then {
        // number of scratchies from database
        _scratchie = _hasBet select 0;
    };
    if(isNil "_hasBet") then {
        // insert new player for the game
        _result = format["playerAddLottery:%1",getPlayerUID _player] call ExileServer_system_database_query_insertSingle;
    };
    
    switch (_request) do {
        case "get": {
            // check if the player has already participated a lottery for this round
            _prize = format ["getLotteryPrize:%1", getPlayerUID _player] call ExileServer_system_database_query_selectSingleField;
            
            if !(isNil "_prize") then 
            {
                format ["setPrizeDelivered:%1", getPlayerUID _player] call ExileServer_system_database_query_fireAndForget;
                _safepos = [position _player, 5, 150, 3, 0, 20, 0] call BIS_fnc_findSafePos;
                
                _number = format["1%1",_number];
                
                _vehicleObject = [_prize, [0,0,1000], (random 360), true, _number] call ExileServer_object_vehicle_createPersistentVehicle;
                _vehicleObject allowDamage false;
                _vehicleObject removeAllEventHandlers "HandleDamage";
                _vehicleObject addEventHandler["HandleDamage",{false}];
                _safepos set [2,0.1];
                _vehicleObject setPosATL _safepos;
                _vehicleObject setVariable ["ExileOwnerUID", (getPlayerUID _player)];
                _vehicleObject setVariable ["ExileIsLocked",0];
                _vehicleObject lock 0;
                _vehicleObject call ExileServer_object_vehicle_database_insert;
                _vehicleObject call ExileServer_object_vehicle_database_update;
                
                _playerMoney = _player getVariable ["ExileMoney", 0];
                [_sessionId, "purchaseVehicleResponse", [0, netId _vehicleObject,  str _playerMoney]] call ExileServer_system_network_send_to;
                _vehicleObject allowDamage true;
                _vehicleObject removeAllEventHandlers "HandleDamage";
                
                [_player, "dynamicTextRequest", [format ["UNLOCK PIN: %1<br/><br/>DO NOT FORGET", _number], 0, 2, "#ffffff"]] call ExileServer_system_network_send_to;
                
            } else {
                [_player, "notificationRequest", ["LockKickWarning", ["No prize for you :-("]]] call ExileServer_system_network_send_to;
            };
        };
        case "buy": {
            _playerMoney = _player getVariable ["ExileMoney", 0];
            if (_playerMoney >= _scratchieCost) then {
                _playerMoney = _playerMoney - _scratchieCost;
                _player setVariable ["ExileMoney", _playerMoney];
                
                format["setAccountMoney:%1:%2", _playerMoney, (getPlayerUID _player)] call ExileServer_system_database_query_fireAndForget;
                format["playerAddScratchie:%1", getPlayerUID _player] call ExileServer_system_database_query_fireAndForget;
                [_player, "notificationRequest", ["PartyInviteMessage", ["You just bought a scratchie"]]] call ExileServer_system_network_send_to;
                _scratchie = _scratchie + 1;
                [_sessionID, "moneySentRequest", [str _playerMoney, "Scratchie"]] call ExileServer_system_network_send_to;
            };
        };
        case "use": {            
            // player is already participating
            if ((_hasBet select 1) != "") then {
                // notify the player that he/she is already participating
                [_player, "notificationRequest", ["PartyInviteMessage", ["You already participating"]]] call ExileServer_system_network_send_to;
            } else {
                if (_scratchie > 0) then
                {
                    // row exist and number is empty, soo allow player to participate
                    _result = format["playerBetLottery:%1:%2", _number, getPlayerUID _player] call ExileServer_system_database_query_insertSingle;
                    _scratchie = _scratchie - 1;
                    [_player, "notificationRequest", ["PartyInviteMessage", [format["Your lucky number: %1", _number]]]] call ExileServer_system_network_send_to;
                } else {
                    [_player, "notificationRequest", ["LockKickWarning", ["No more scratchies :("]]] call ExileServer_system_network_send_to;
                };
            };
        };
    }; 
    
    // send the updated scratchieCount
    scratchieCount = _scratchie;
    _clientId = owner _player;
    _clientId publicVariableClient "scratchieCount";
}
catch
{
    format["Lottery Error: %1", _exception]  call ExileServer_util_log;
};
_result