void OverrideLimits()
{
	if (bIsCSZM)
	{
		RoundManager.Limit_Enable(true);
		RoundManager.Limit_Override(random_def, true);

		array<string> pClassName =
		{
			"weapon_870",
			"weapon_ak47",
			"weapon_axe",
			"weapon_baguette",
			"weapon_barricade",
			"weapon_bat_aluminum",
			"weapon_bat_wood",
			"weapon_broom",
			"weapon_bugbait",
			"weapon_chair",
			"weapon_crowbar",
			"weapon_frag",
			"weapon_fryingpan",
			"weapon_glock",
			"weapon_glock18c",
			"weapon_golf",
			"weapon_ied",
			"weapon_inoculator",
			"weapon_inoculator_delay",
			"weapon_inoculator_full",
			"weapon_keyboard",
			"weapon_m4",
			"weapon_machete",
			"weapon_meatcleaver",
			"weapon_mp5",
			"weapon_pipe",
			"weapon_pipewrench",
			"weapon_plank",
			"weapon_pot",
			"weapon_ppk",
			"weapon_racket",
			"weapon_revolver",
			"weapon_shovel",
			"weapon_sledgehammer",
			"weapon_snowball",
			"weapon_spanner",
			"weapon_supershorty",
			"weapon_tennisball",
			"weapon_tireiron",
			"weapon_usp",
			"weapon_winchester",
			"weapon_wrench",
			"item_pills",
			"item_healthkit",
			"item_ammo_pistol",
			"item_ammo_revolver",
			"item_ammo_shotgun",
			"item_ammo_rifle",
			"item_ammo_barricade",
			"item_armor"
		};

		int length = int(pClassName.length());

		for (int i = 0; i < length;i++)
		{
			RoundManager.Limit_Random(pClassName[i], 0);
		}
	}
}