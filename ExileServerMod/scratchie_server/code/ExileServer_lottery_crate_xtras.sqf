/**
 * Scratchie - Lottery like minigame for Exile Mod
 * @author ole1986 - https://github.com/ole1986/a3-exile-scratchie
 * @version 0.3
 */

private["_crate","_item"];
_crate = _this select 0;
_item = _this select 1;

switch (_item) do
{
    case "LMG_Zafir_F": {
        // add ammo for the zafir
        _crate addMagazineCargoGlobal ["150Rnd_762x54_Box", 3];
    };
    case "launch_NLAW_F": {
        _crate addMagazineCargoGlobal ["NLAW_F", 2];
    };
    
    case "LMG_Mk200_MRCO_F": {
         _crate addMagazineCargoGlobal ["200Rnd_65x39_cased_Box", 3];
    };
    case "srifle_GM6_LRPS_F": {
        _crate addMagazineCargoGlobal ["5Rnd_127x108_Mag", 4];
    };
   
    default { };
};
true