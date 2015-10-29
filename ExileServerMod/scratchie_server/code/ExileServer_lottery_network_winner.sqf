/**
 * Scratchie - Lottery like minigame for Exile Mod v0.2
 * Author: ole1986
 * Date: 2015-10-29
 */

private["_playerList", "_number", "_prizes", "_curPrice", "_winners", "_count", "_currentPlayer", "_rand"];
_winners = [];
_playerList = nil;
_number = "111";
_prizes = [];
_rand = getNumber(configFile >> "CfgSettings" >> "ScratchieSettings" >> "ChanceToWin");

try 
{
	_number = format ["%1%2%3", round(random _rand) + 1, round(random _rand) + 1, round(random _rand) + 1];

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
				[_x,"notificationRequest",["LockKickWarning",[format["The lucky number: %1<br/>You had %2", _number, _currentPlayer select 2]]]] call ExileServer_system_network_send_to;
			};
		};
		
	} forEach allPlayers;

	if (count _winners > 0) then 
	{
		_prizes = getArray(configFile >> "CfgSettings" >> "ScratchieSettings" >> "VehiclePrize"); // + getArray(configFile >> "CfgSettings" >> "ScratchieSettings" >> "PoptabPrize");
		
		// GET A RANDOM PRIZE FOR EACH WINNER
		_curPrice = _prizes call BIS_fnc_selectRandom;
	
		// inform the players about the prize
		{
			// Debug info
			format["DEBUG: Scratchie Winner is %1 - Price: %2", name vehicle _x, _curPrice]  call ExileServer_util_log;
			// Save prize into database
			format["saveLotteryWinner:%1:%2", getPlayerUID _x, _curPrice] call ExileServer_system_database_query_insertSingle;
			
			// show winner message
			[_x, "notificationRequest", ["Success", ["YOU WON A PRIZE"]]] call ExileServer_system_network_send_to;
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