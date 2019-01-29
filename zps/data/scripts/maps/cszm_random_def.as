void OverrideLimits()
{
	RoundManager.Limit_Enable(true);
	RoundManager.Limit_Override(random_def, true);
	
	RoundManager.Limit_Random("item_ammo_revolver", 10);
	RoundManager.Limit_Random("item_ammo_shotgun", 15);
	RoundManager.Limit_Random("item_ammo_pistol", 45);
	RoundManager.Limit_Random("item_ammo_rifle", 25);
	RoundManager.Limit_Random("item_armor", 5);
	RoundManager.Limit_Random("item_healthkit", 0);
	RoundManager.Limit_Random("item_pills", 0);
	
	RoundManager.Limit_Random("weapon_inoculator", 0);
	RoundManager.Limit_Random("weapon_inoculator_delay", 10);
	RoundManager.Limit_Random("weapon_inoculator_full", 0);
	
	RoundManager.Limit_Random("weapon_frag", 5);
	RoundManager.Limit_Random("weapon_ied", 2);
	RoundManager.Limit_Random("weapon_glock", 3);
	RoundManager.Limit_Random("weapon_ppk", 2);
	RoundManager.Limit_Random("weapon_usp", 3);
	RoundManager.Limit_Random("weapon_ak47", 8);
	RoundManager.Limit_Random("weapon_m4", 8);
	RoundManager.Limit_Random("weapon_mp5", 6);
	RoundManager.Limit_Random("weapon_glock18c", 5);
	RoundManager.Limit_Random("weapon_870", 8);
	RoundManager.Limit_Random("weapon_supershorty", 5);
	RoundManager.Limit_Random("weapon_winchester", 3);
	RoundManager.Limit_Random("weapon_revolver", 2);

	RoundManager.Limit_Random("weapon_barricade", 15);
	RoundManager.Limit_Random("item_ammo_barricade", 10);
	
	RoundManager.Limit_Random("weapon_axe", 0);
	RoundManager.Limit_Random("weapon_bat_aluminum", 0);
	RoundManager.Limit_Random("weapon_bat_wood", 0);
	RoundManager.Limit_Random("weapon_broom", 0);
	RoundManager.Limit_Random("weapon_chair", 0);
	RoundManager.Limit_Random("weapon_crowbar", 0);
	RoundManager.Limit_Random("weapon_fryingpan", 0);
	RoundManager.Limit_Random("weapon_golf", 0);
	RoundManager.Limit_Random("weapon_keyboard", 0);
	RoundManager.Limit_Random("weapon_machete", 0);
	RoundManager.Limit_Random("weapon_pipe", 0);
	RoundManager.Limit_Random("weapon_pipewrench", 0);
	RoundManager.Limit_Random("weapon_plank", 0);
	RoundManager.Limit_Random("weapon_pot", 0);
	RoundManager.Limit_Random("weapon_racket", 0);
	RoundManager.Limit_Random("weapon_shovel", 0);
	RoundManager.Limit_Random("weapon_sledgehammer", 0);
	RoundManager.Limit_Random("weapon_spanner", 0);
	RoundManager.Limit_Random("weapon_tireiron", 0);
	RoundManager.Limit_Random("weapon_torque", 0);
	RoundManager.Limit_Random("weapon_wrench", 0);
	RoundManager.Limit_Random("weapon_meatcleaver", 0);
}