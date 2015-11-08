/**
 * Scratchie - Lottery like minigame for Exile Mod
 * @author ole1986 - https://github.com/ole1986/a3-exile-scratchie
 * @version 0.5
 */

private['_no', '_max', '_result'];
_no = getNumber(configFile >> "CfgSettings" >> "ScratchieSettings" >> "ChanceToWin");
_result = "";
// everything between 51 - 99 does not really make sense
if (_no > 100) then { _no = 100; };
if (_no <= 0) then { _no = 1; };

_max = 1 / (_no / 100);
_max = ceil _max;

// something to make the number special - add A or B and the zero for lower then 10
_no = floor(random _max);

if ( (_no % 3) == 0 ) then {
    _result = 'A';
} else {
    _result = 'B';
};

if (_no < 10) then { _result = _result + '0'; };
_result = _result + str _no;
_result