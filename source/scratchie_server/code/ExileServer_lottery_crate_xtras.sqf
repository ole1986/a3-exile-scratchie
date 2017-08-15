/**
 * Scratchie - Lottery like minigame for Exile Mod
 * @author ole1986 - https://github.com/ole1986/a3-exile-scratchie
 */

private["_crate", "_weapon", "_magazines", "_mag", "_items", "_item", "_maxItems"];
_crate = _this select 0;
_weapon = _this select 1;

// fetch compatible magazines from configFile
_magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
// take the first from the magazine list
_mag = _magazines select 0;

// magazine available? add it to the crate (two magazines are added)
if (_mag != "") then {
    _crate addMagazineCargoGlobal [_mag, 2];
};

// optional add additional stuff dependent on the item the player has won
switch (_weapon) do
{
    // Example to add two more magazines for the GM6
    case "srifle_GM6_LRPS_F": {
        _crate addMagazineCargoGlobal [_mag, 2];
    };
   
    default { };
};

// additional items to spawn from ItemPrize[] list
_items = getArray (configFile >> "CfgSettings" >> "ScratchieSettings" >> "ItemPrize");
_maxItems = getNumber(configFile >> "CfgSettings" >> "ScratchieSettings" >> "ItemsPerCrate");

for "_i" from 1 to _maxItems do {
    _item = _items call BIS_fnc_selectRandom;
    _crate addItemCargoGlobal [_item, 1];
};

true;