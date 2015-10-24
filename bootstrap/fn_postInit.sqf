/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 

call ExileServer_system_process_postInit;
// Lottery every x seconds (300 = 5min, 900 = 15min)
[60, ExileServer_lottery_network_winner, [], true] call ExileServer_system_thread_addTask;

true