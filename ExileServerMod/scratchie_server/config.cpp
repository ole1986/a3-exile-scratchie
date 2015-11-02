/**
 * Scratchie - Lottery like minigame for Exile Mod
 * @author ole1986 - https://github.com/ole1986/a3-exile-scratchie
 * @version 0.3
 */
 
class CfgPatches {
    class scratchie_server {
        requiredVersion = 0.1;
        requiredAddons[]=
        {
            "exile_client",
            "exile_server_config"
        };
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class ScratchieServer {
        class main {
            file="scratchie_server\bootstrap";
            class preInit { 
                preInit = 1;
            };
            class postInit {
                postInit = 1;
            };
        };
    };
};

class CfgSettings
{
    /**
     * Scratchie Settings
     * customizable settings all around the scratchie
     */
    class ScratchieSettings {
        /**
         * @var integer How often the number should be drawn (in seconds) - MIN: 60 = 1min MAX: 65435 = 18days XD
         * @version 0.3
         */
        Interval = 60;
        
        /**
         * @var integer set the price per scratchie (default: 200)
         * @version 0.2
         */
        Price = 200;
        
        /**
         * @var integer Chance a player can win the prize - MIN: 0 = always winner MAX: 9 = VERY VERY LUCKY
         *              CHECK OUT http://www.unknown-sanctuary.tk/scratchie.php TO ROUGHLY SEE HOW IT EFFECTS ALL PARTICIPANTS
         * @version 0.2
         */ 
        ChanceToWin = 2;
        
        /**
         * @var array list of vehicle prizes
         * @version 0.2
         */
        VehiclePrize[] = {
            "Exile_Chopper_Hummingbird_Green",
            "Exile_Chopper_Hummingbird_Civillian_Jeans",
            "Exile_Car_HEMMT", 
            "Exile_Car_Ifrit", 
            "Exile_Car_Offroad_Repair_Guerilla12", 
            "Exile_Car_Kart_Green", 
            "Exile_Car_Offroad_Armed_Guerilla08"
        };
        /**
         * @var array list of pop tab prizes
         * @version 0.3
         */
        PoptabPrize[] = {
            5000, 
            10000,
            15000,
            50000, 
            100000
        };
        
        /**
         * @var int ItemPrize lifetime - How long is the crate available for item prizes (default: 120 sec = 2 minutes)
         * @version 0.3
         */
        CrateLifetime = 120;
        
        /**
         * @var array list of Item prizes - Check out the ExileServer_lottery_crate_xtras.sqf for a proper ammunation
         * @version 0.3
         */
        WeaponPrize[] = {
            "LMG_Zafir_F",
            "launch_NLAW_F",
            "LMG_Mk200_MRCO_F",
            "srifle_GM6_LRPS_F"
        };
    };
};
