/**
 * Scratchie - Lottery like minigame for Exile Mod v0.2
 * Author: ole1986
 * Date: 2015-10-29
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
		 * @var integer set the price per scratchie (default: 200)
		 */
		Price = 200;
		
		/**
		 * @var integer Chance a player can win the prize - MIN: 0 = always winner MAX: 9 = VERY VERY LUCKY
		 * CHECK OUT http://www.unknown-sanctuary.tk/scratchie.php TO ROUGHLY SEE HOW IT EFFECTS ALL PARTICIPANTS
		 */ 
		ChanceToWin = 3;
		
		/**
		 * @var array list of vehicle prizes
		 */
		VehiclePrize[] = {"Exile_Chopper_Hummingbird_Green",
					 "Exile_Chopper_Hummingbird_Civillian_Jeans",
					 "Exile_Car_HEMMT", 
					 "Exile_Car_Ifrit", 
					 "Exile_Car_Offroad_Repair_Guerilla12", 
					 "Exile_Car_Kart_Green", 
					 "Exile_Car_Offroad_Armed_Guerilla08"};
		/**
		 * @var array list of pop tab prizes (NOT YET IMPLEMENTED)
		 */
		PoptabPrize[] = {	 5000, 
							10000,
							15000,
							50000, 
						   100000};
	};
};
