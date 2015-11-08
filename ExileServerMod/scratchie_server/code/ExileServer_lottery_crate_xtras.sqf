/**
 * Scratchie - Lottery like minigame for Exile Mod
 * @author ole1986 - https://github.com/ole1986/a3-exile-scratchie
 * @version 0.5
 */

private["_crate", "_item", "_magazines", "_mag"];
_crate = _this select 0;
_item = _this select 1;

// fetch compatible magazines from configFile
_magazines = getArray (configFile >> "CfgWeapons" >> _item >> "magazines");
// take the first from the magazine list
_mag = _magazines select 0;

// magazine available? add it to the crate (two magazines are added)
if (_mag != "") then {
    _crate addMagazineCargoGlobal [_mag, 2];
};

// optional add additional stuff dependent on the item the player has won
switch (_item) do
{
    // Example to add two more magazines for the GM6
    case "srifle_GM6_LRPS_F": {
        _crate addMagazineCargoGlobal [_mag, 2];
    };
   
    default { };
};
true