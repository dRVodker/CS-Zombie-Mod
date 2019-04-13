void OverrideLimits()
{
	RoundManager.Limit_Enable(true);
	RoundManager.Limit_Override(random_def, true);
	
	RoundManager.Limit_Random("item_ammo_revolver", 5);
	RoundManager.Limit_Random("item_ammo_shotgun", 25);
	RoundManager.Limit_Random("item_ammo_pistol", 15);
	RoundManager.Limit_Random("item_ammo_rifle", 25);

	RoundManager.Limit_Random("item_armor", 0);

	RoundManager.Limit_Random("item_healthkit", 0);
	RoundManager.Limit_Random("item_pills", 3);
	
	RoundManager.Limit_Random("weapon_inoculator", 0);
	RoundManager.Limit_Random("weapon_inoculator_delay", 0);
	RoundManager.Limit_Random("weapon_inoculator_full", 0);
	
	RoundManager.Limit_Random("weapon_frag", 5);
	RoundManager.Limit_Random("weapon_ied", 2);

	RoundManager.Limit_Random("weapon_glock", 2);
	RoundManager.Limit_Random("weapon_ppk", 0);
	RoundManager.Limit_Random("weapon_usp", 2);

	RoundManager.Limit_Random("weapon_glock18c", 5);
	RoundManager.Limit_Random("weapon_mp5", 5);

	RoundManager.Limit_Random("weapon_ak47", 10);
	RoundManager.Limit_Random("weapon_m4", 10);

	RoundManager.Limit_Random("weapon_870", 10);
	RoundManager.Limit_Random("weapon_supershorty", 5);
	RoundManager.Limit_Random("weapon_winchester", 1);

	RoundManager.Limit_Random("weapon_revolver", 3);

	RoundManager.Limit_Random("weapon_barricade", 10);
	RoundManager.Limit_Random("item_ammo_barricade", 5);
	
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