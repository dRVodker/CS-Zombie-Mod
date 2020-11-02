#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"

const int TEAM_LOBBYGUYS = 0;

array<array<CSpawnPoint@>> PrimaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(-1478.02, 2210.76, -215.969), QAngle(-1.92386, -18.6582, 0)),
		CSpawnPoint(Vector(-1465.67, 2059.49, -215.969), QAngle(3.12183, 19.5294, 0)),
		CSpawnPoint(Vector(-1388.63, 2144.01, -215.969), QAngle(-0.0725655, -32.3433, 0)),
		CSpawnPoint(Vector(-1268.53, 2181.46, -215.969), QAngle(-2.97657, -65.2311, 0)),
		CSpawnPoint(Vector(-1372.62, 2047.18, -215.969), QAngle(1.74243, 3.66628, 0)),
		CSpawnPoint(Vector(-1298.52, 1989.17, -215.969), QAngle(-2.94027, 4.31968, 0)),
		CSpawnPoint(Vector(-1275.44, 2083.91, -215.969), QAngle(0.653437, -8.13122, 0)),
		CSpawnPoint(Vector(-1492.02, 1958.49, -215.969), QAngle(0.834913, 27.2976, 0)),
		CSpawnPoint(Vector(-1378.03, 2217.18, -215.969), QAngle(0.363015, -24.7567, 0)),
		CSpawnPoint(Vector(-1227.68, 1991.78, -215.969), QAngle(-1.45198, 9.03867, 0)),
		CSpawnPoint(Vector(-1220.31, 2203.33, -215.969), QAngle(-8.53048, -24.9018, 0)),
		CSpawnPoint(Vector(882.217, 2197.89, -215.969), QAngle(0.943807, -177.652, -0)),
		CSpawnPoint(Vector(886.314, 2005.79, -215.969), QAngle(0.943807, -177.652, -0)),
		CSpawnPoint(Vector(968.31, 2070.75, -215.969), QAngle(0.943807, -177.652, -0)),
		CSpawnPoint(Vector(1010.45, 2178.69, -215.969), QAngle(-4.13819, -177.652, 0)),
		CSpawnPoint(Vector(1061.15, 1997.24, -215.969), QAngle(-5.98949, 150.331, 0)),
		CSpawnPoint(Vector(1070.03, 2101.52, -215.969), QAngle(-3.62999, -163.894, 0)),
		CSpawnPoint(Vector(1081.4, 2209.73, -215.969), QAngle(-2.8314, -151.335, 0)),
		CSpawnPoint(Vector(1088.97, 1359.64, -215.969), QAngle(0.399307, 167.247, 0)),
		CSpawnPoint(Vector(1043.9, 1439.65, -215.969), QAngle(-3.12179, -160.664, 0)),
		CSpawnPoint(Vector(1099.98, 1549.36, -215.969), QAngle(-1.08899, -171.517, 0)),
		CSpawnPoint(Vector(1015.3, 1578.83, -215.969), QAngle(-1.96019, -136.379, 0)),
		CSpawnPoint(Vector(1027.16, 1350.22, -215.969), QAngle(0.290415, 160.641, 0)),
		CSpawnPoint(Vector(1124.69, 1413.82, -215.969), QAngle(-1.8513, 166.412, 0)),
		CSpawnPoint(Vector(991.56, 1487.48, -215.969), QAngle(-4.86422, -174.929, 0)),

		CSpawnPoint(Vector(276.738, -301.631, 136.031), QAngle(-4.35604, 120.045,  0), "info_player_start"),
		CSpawnPoint(Vector(440.109, 157.718, 136.031), QAngle(-5.04573, 141.897,   0), "info_player_start"),
		CSpawnPoint(Vector(-633.054, -134.401, 8.03125), QAngle(-4.68274, 47.3722, 0), "info_player_start")
	}
};

array<array<CSpawnPoint@>> SecondaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(-1456.56, 2194.33, -215.969), QAngle(-7.81001, -23.234, 0)),
		CSpawnPoint(Vector(-1197.89, 2193.82, -215.969), QAngle(-15.6145, -47.6639, 0)),
		CSpawnPoint(Vector(-1238, 2022.64, -215.969), QAngle(-17.2117, -17.2445, -0)),
		CSpawnPoint(Vector(-1487.89, 1587.02, -215.969), QAngle(-13.9447, -19.1683, 0)),
		CSpawnPoint(Vector(-1100.69, 1590.46, -215.969), QAngle(-5.26903, -70.0972, -0)),
		CSpawnPoint(Vector(-1265.45, 1389.81, -215.969), QAngle(-10.9681, 2.17618, 0)),
		CSpawnPoint(Vector(-1327.97, 1000.7, -215.969), QAngle(-7.15661, 33.975, 0)),
		CSpawnPoint(Vector(-900.534, 1128.49, -191.895), QAngle(-13.1824, 39.2022, 0)),
		CSpawnPoint(Vector(-510.416, 1267.06, -215.969), QAngle(-1.60272, 47.2971, -0)),
		CSpawnPoint(Vector(-264.453, 1541.21, -215.969), QAngle(0.430074, 3.12007, 0)),
		CSpawnPoint(Vector(-346.09, 1969.63, -215.969), QAngle(2.13617, 151.769, 0)),
		CSpawnPoint(Vector(-653.222, 2113.98, -215.969), QAngle(-0.586329, -16.8087, 0)),
		CSpawnPoint(Vector(-184.401, 2208.18, -215.969), QAngle(-1.96573, -127.415, 0)),
		CSpawnPoint(Vector(183.161, 1834.63, -210.944), QAngle(-6.61213, -82.6205, 0)),
		CSpawnPoint(Vector(374.779, 1713.64, -213.377), QAngle(-6.28542, -178.525, 0)),
		CSpawnPoint(Vector(253.661, 1577.48, -215.969), QAngle(-9.22573, 176.356, 0)),
		CSpawnPoint(Vector(-42.8165, 1389.1, -215.969), QAngle(3.22518, 56.3848, -0)),
		CSpawnPoint(Vector(397.566, 1367.72, -215.969), QAngle(-1.82052, 38.4163, -0)),
		CSpawnPoint(Vector(825.279, 1331.69, -215.969), QAngle(1.19237, 125.645, 0)),
		CSpawnPoint(Vector(766.094, 1577.4, -215.969), QAngle(-1.82053, -178.961, 0)),
		CSpawnPoint(Vector(1266.95, 1381.5, -215.969), QAngle(-4.25262, 169.423, 0)),
		CSpawnPoint(Vector(1226.88, 1511.09, -215.969), QAngle(-3.45402, -174.749, -0)),
		CSpawnPoint(Vector(1337.63, 994.204, -199.951), QAngle(-12.2023, 149.749, 0)),
		CSpawnPoint(Vector(1123.11, 1679.15, -215.969), QAngle(-14.9248, -175.439, 0)),
		CSpawnPoint(Vector(965.705, 1825.52, -215.969), QAngle(-15.1063, -170.103, 0)),
		CSpawnPoint(Vector(1114.58, 2175.61, -215.969), QAngle(-8.79014, -165.892, 0)),
		CSpawnPoint(Vector(983.041, 2022.74, -215.969), QAngle(-11.1133, 156.973, 0)),
		CSpawnPoint(Vector(780.472, 2337.58, -215.969), QAngle(-1.56645, -138.413, 0)),
		CSpawnPoint(Vector(520.394, 2190.08, -215.969), QAngle(4.16894, -159.903, 0)),
		CSpawnPoint(Vector(210.731, 1985.8, -215.969), QAngle(-1.56646, 41.8971, -0)),
		CSpawnPoint(Vector(150.441, 2511.98, -135.969), QAngle(1.66425, 9.84878, 0)),
		CSpawnPoint(Vector(377.677, 2434.28, -133.969), QAngle(-0.223336, -161.088, 0)),
		CSpawnPoint(Vector(213.869, 2583.33, 0.03125), QAngle(2.57178, -58.2731, 0)),
		CSpawnPoint(Vector(213.882, 2126.76, 2.03125), QAngle(2.02728, -35.1137, 0)),
		CSpawnPoint(Vector(219.051, 1447.75, 2.03125), QAngle(0.0670724, 5.76003, 0)),
		CSpawnPoint(Vector(404.529, 1088.59, 0.03125), QAngle(2.57177, 100.648, 0)),
		CSpawnPoint(Vector(73.9626, 800.723, -39.9688), QAngle(-3.23623, 16.5406, 0)),
		CSpawnPoint(Vector(613.488, 775.008, 0.03125), QAngle(0.502663, 130.994, 0)),
		CSpawnPoint(Vector(927.458, 429.623, 0.03125), QAngle(0.212278, 145.755, 0)),
		CSpawnPoint(Vector(958.426, 646.638, -79.9688), QAngle(-1.276, 135.99, 0)),
		CSpawnPoint(Vector(-106.091, -368.532, 1.92782), QAngle(-3.7444, 113.884, 0)),
		CSpawnPoint(Vector(-151.43, 226.921, 3.38239), QAngle(-1.0945, 125.9, 0)),
		CSpawnPoint(Vector(-153.403, 689.337, 4.37443), QAngle(-0.840396, 133.995, 0)),
		CSpawnPoint(Vector(-178.814, 1111.56, 11.0777), QAngle(6.49221, 58.1642, 0)),
		CSpawnPoint(Vector(-710.985, 778.622, 8.03125), QAngle(-5.30528, 60.1968, 0)),
		CSpawnPoint(Vector(-666.116, -51.7643, 8.03125), QAngle(-1.82047, 74.7171, 0)),
		CSpawnPoint(Vector(-417.377, -25.3486, 8.03125), QAngle(-0.114378, 99.7279, 0)),
		CSpawnPoint(Vector(-973.128, -207.146, 33.9486), QAngle(7.94422, 55.3331, 0)),
		CSpawnPoint(Vector(-831.817, 285.025, -43.8872), QAngle(7.87161, 74.3905, 0)),
		CSpawnPoint(Vector(-948.858, 652.416, -105.629), QAngle(9.97702, 71.5954, 0)),
		CSpawnPoint(Vector(-1204.7, 636.761, -71.9688), QAngle(-0.840427, 58.8415, 0)),
		CSpawnPoint(Vector(-1423.85, 896.258, -71.9688), QAngle(1.66427, 35.9724, 0)),
		CSpawnPoint(Vector(385.977, -283.241, 136.031), QAngle(-0.876742, 94.4879, 0)),
		CSpawnPoint(Vector(140.611, -278.864, 136.031), QAngle(0.35745, 75.0672, 0)),
		CSpawnPoint(Vector(398.176, 135.054, 136.031), QAngle(1.15605, 101.058, 0)),
		CSpawnPoint(Vector(139.273, 305.05, 136.031), QAngle(-0.622651, 61.7761, -0)),
		CSpawnPoint(Vector(380.313, 569.729, 136.031), QAngle(-0.18705, 96.4118, 0)),
		CSpawnPoint(Vector(210.446, 921.832, 176.432), QAngle(1.19234, -121.642, 0)),
		CSpawnPoint(Vector(967.748, 530.6, 144.031), QAngle(1.37383, 119.716, 0)),
		CSpawnPoint(Vector(696.203, 577.928, 144.031), QAngle(4.35044, 107.774, 0)),
		CSpawnPoint(Vector(430.019, 1025.81, 136.031), QAngle(1.51904, -138.825, -0)),
		CSpawnPoint(Vector(106.65, 1174.63, 136.031), QAngle(-2.29246, 61.7449, 0)),
		CSpawnPoint(Vector(381.142, 1495.18, 136.031), QAngle(1.51905, -112.64, -0)),
		CSpawnPoint(Vector(145.831, 1873.64, 136.031), QAngle(-0.76785, -69.0439, 0)),
		CSpawnPoint(Vector(332.32, 2000.03, 136.031), QAngle(-0.0418488, 161.583, 0)),
		CSpawnPoint(Vector(378.448, 2422.95, 136.031), QAngle(2.28135, 138.605, 0)),
		CSpawnPoint(Vector(315.417, 2736.91, 175.432), QAngle(6.20174, -103.855, 0)),
		CSpawnPoint(Vector(340.566, 2669.97, 175.432), QAngle(9.57765, -134.638, 0)),
		CSpawnPoint(Vector(175.819, 2362.5, 136.031), QAngle(8.12566, 110.836, 0)),
		CSpawnPoint(Vector(-144.76, 2868.9, 0.03125), QAngle(-3.99854, -117.613, 0)),
		CSpawnPoint(Vector(-254.628, 2883.71, 0.670982), QAngle(-2.65544, -72.7824, 0)),
		CSpawnPoint(Vector(-206.974, 2401.39, 11.8383), QAngle(-1.92944, 86.6835, 0)),
		CSpawnPoint(Vector(-679.612, 2829.5, 8.03125), QAngle(-1.34864, -47.8933, 0)),
		CSpawnPoint(Vector(-410.86, 2782.43, 8.03125), QAngle(1.55536, -113.451, -0)),
		CSpawnPoint(Vector(-608.057, 2397.55, 8.03125), QAngle(2.06356, -98.9309, 0)),
		CSpawnPoint(Vector(-719.346, 1990.3, 8.03125), QAngle(2.09986, -70.9071, 0)),
		CSpawnPoint(Vector(-502.554, 1860.67, 8.03125), QAngle(4.24156, -94.3812, -0)),
		CSpawnPoint(Vector(-508.87, 1547.81, 8.03125), QAngle(2.60806, 106.6, 0)),
		CSpawnPoint(Vector(-598.677, 1370.51, 8.03125), QAngle(6.49216, 75.1276, 0)),
		CSpawnPoint(Vector(-436.32, 1200.42, 8.03125), QAngle(3.69706, 107.215, 0)),
		CSpawnPoint(Vector(-509.203, 861.369, 8.03125), QAngle(7.61745, -109.175, 0))
	}
};

void OnMapInit()
{
	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);
	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SecondaryHumanSpawns, false);
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	
	PropSkins();
	OpenDoors();
	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_human");
	RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(PrimaryHumanSpawns, true);
}

HookReturnCode OnPlrSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
	{
		PlayLobbyAmbient();
	}

	return HOOK_HANDLED;
}

void OpenDoors()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "FireUser1");
	}
	
	Engine.Ent_Fire("H-OF*", "Kill", "0", "0.85");
}

void PropSkins()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("vending_machine", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", formatInt(Math::RandomInt(0, 2)));
		}

		else if(Utils.StrContains("oildrum001", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", formatInt(Math::RandomInt(0, 5)));
		}
	}
}