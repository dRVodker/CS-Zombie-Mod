#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"
#include "cszm_modules/cashmaker"

const int TEAM_LOBBYGUYS = 0;

array<array<CSpawnPoint@>> Office_HumanSpawns = 
{
	{
		CSpawnPoint(Vector(-768, -1920, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-824, -1834, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-1184, -1456, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1249, -1846, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1112, -1552, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1417, -1946, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1170, -1791, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1172, -1660, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1088, -2004, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-1272, -1584, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1277, -1732, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1300, -1976, -334.43), QAngle(0, 33.9972, 0)),
		CSpawnPoint(Vector(-920, -1930, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-780, -2002, -334.308), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-920, -2026, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-928, -1856, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-1180, -1925, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-929, -2101, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-1280, -1468, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-752, -1744, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-928, -1782, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-1345, -1846, -334.43), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-664, -1876, -334.43), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-1056, -1856, -334.43), QAngle(0, 0, 0))
	},
	{
		CSpawnPoint(Vector(1484, 508, -159.167), QAngle(0, 152.996, 0)),
		CSpawnPoint(Vector(1332, 116, -159.167), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(1808, 160, -159.167), QAngle(0, -177.001, 0)),
		CSpawnPoint(Vector(1472, 248, -159.167), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(1020, 180, -159.167), QAngle(0, -67.0001, 0)),
		CSpawnPoint(Vector(1516, 289, -159.167), QAngle(0, -137.005, 0)),
		CSpawnPoint(Vector(1052, 68, -159.167), QAngle(0, -103.002, 0)),
		CSpawnPoint(Vector(1728, 528, -159.167), QAngle(0, 152.996, 0)),
		CSpawnPoint(Vector(1804, -472, -159.167), QAngle(0, -177.001, 0)),
		CSpawnPoint(Vector(1336, 732, -159.167), QAngle(0, -53.0035, 0)),
		CSpawnPoint(Vector(1596, 560, -159.167), QAngle(0, 152.996, 0)),
		CSpawnPoint(Vector(1636, 728, -159.167), QAngle(0, -87.0007, 0)),
		CSpawnPoint(Vector(1536, 76, -159.167), QAngle(0, 127.996, 0)),
		CSpawnPoint(Vector(1440, 184, -159.167), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(1228, 188, -159.167), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(1472, 120, -159.167), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(1328, 268, -159.167), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(1504, 184, -159.167), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(1356, 484, -159.167), QAngle(0, 50.9985, 0)),
		CSpawnPoint(Vector(1500, 632, -159.167), QAngle(0, 119.998, 0)),
		CSpawnPoint(Vector(1160, 296, -159.167), QAngle(0, -67.0001, 0)),
		CSpawnPoint(Vector(1376, 576, -159.167), QAngle(0, -41.001, 0)),
		CSpawnPoint(Vector(1500, 728, -159.167), QAngle(0, -135, 0)),
		CSpawnPoint(Vector(900, 56, -159.167), QAngle(0, -79.0027, 0)),
		CSpawnPoint(Vector(1420, 624, -159.167), QAngle(0, 93.999, 0))
	},
	{
		CSpawnPoint(Vector(-129.555, -1097.62, -223.969), QAngle(23.5585, 76.0119, 0)),
		CSpawnPoint(Vector(111.745, -1048.07, -223.969), QAngle(-4.93704, 92.5648, 0)),
		CSpawnPoint(Vector(-585.943, -971.631, -287.881), QAngle(8.53023, 128.539, 0)),
		CSpawnPoint(Vector(-398.613, -437.597, -246.525), QAngle(15.3183, -148.661, 0)),
		CSpawnPoint(Vector(-1348.63, 293.407, -303.279), QAngle(-7.00622, -48.3289, 0)),
		CSpawnPoint(Vector(-1075.84, 304.468, -294.977), QAngle(9.00208, -97.4427, 0)),
		CSpawnPoint(Vector(-1382.68, 1230.61, -335.969), QAngle(-6.31651, -43.6824, 0)),
		CSpawnPoint(Vector(-1239.63, 471.893, -326.674), QAngle(-13.7943, 30.8414, 0)),
		CSpawnPoint(Vector(-796.178, 1244.56, -279.914), QAngle(5.88025, -137.785, 0)),
		CSpawnPoint(Vector(-1349.5, -1076.24, -296.383), QAngle(12.378, 41.6821, 0)),
		CSpawnPoint(Vector(-1198.9, -1975.94, -335.969), QAngle(21.1988, -122.249, 0)),
		CSpawnPoint(Vector(-537.169, -1612.19, -335.969), QAngle(2.64954, -124.645, 0)),
		CSpawnPoint(Vector(-742.255, -1697.88, -335.969), QAngle(2.25021, -39.4121, 0)),
		CSpawnPoint(Vector(-9.72233, -2146.63, -335.969), QAngle(5.1905, 55.2584, 0)),
		CSpawnPoint(Vector(-12.1432, -1601.9, -335.969), QAngle(5.33569, -45.6917, 0)),
		CSpawnPoint(Vector(928.968, -1415.11, -332.042), QAngle(-0.50858, -41.5174, 0)),
		CSpawnPoint(Vector(1318.31, -1498.48, -327.845), QAngle(2.21393, -171.217, 0)),
		CSpawnPoint(Vector(1055.32, -2042.57, -297.532), QAngle(13.2129, 102.934, 0)),
		CSpawnPoint(Vector(816.801, -1918.99, -316.685), QAngle(-9.03903, 167.548, 0)),
		CSpawnPoint(Vector(304.655, -1318.3, -279.969), QAngle(10.0185, -29.5246, 0)),
		CSpawnPoint(Vector(380.284, -878.776, -223.969), QAngle(-0.907827, -13.952, 0)),
		CSpawnPoint(Vector(-1738.36, -1493.77, -327.969), QAngle(12.8861, 36.8674, 0)),
		CSpawnPoint(Vector(-1500.47, -1424.82, -327.969), QAngle(-2.97696, 115.384, 0)),
		CSpawnPoint(Vector(-746.058, -2144.51, -335.969), QAngle(12.7046, 133.075, 0))
	}
};

array<array<CSpawnPoint@>> Office_ZombieSpawns = 
{
	{
		CSpawnPoint(Vector(1724.14, 741.003, -159.969), QAngle(4.21082, -148.446, 0)),
		CSpawnPoint(Vector(1397.63, 519.281, -159.969), QAngle(4.97313, 35.2816, 0)),
		CSpawnPoint(Vector(1504.06, 995.987, -159.969), QAngle(0.943835, -172.875, 0)),
		CSpawnPoint(Vector(1485.79, 896.836, -159.969), QAngle(4.39233, 166.651, 0)),
		CSpawnPoint(Vector(877.497, 1033.88, -159.969), QAngle(3.26702, -16.9301, 0)),
		CSpawnPoint(Vector(894.162, 888.003, -159.969), QAngle(2.50471, 14.9413, 0)),
		CSpawnPoint(Vector(568.042, 635.788, -159.969), QAngle(3.19444, -43.7919, 0)),
		CSpawnPoint(Vector(575.828, 411.323, -159.969), QAngle(5.44504, 17.7003, 0)),
		CSpawnPoint(Vector(704.365, 608.19, -159.969), QAngle(8.16755, -157.955, 0)),
		CSpawnPoint(Vector(722.738, 394.815, -159.969), QAngle(10.2367, 139.79, 0)),
		CSpawnPoint(Vector(637.793, -128.505, -159.969), QAngle(1.52467, -69.6009, 0)),
		CSpawnPoint(Vector(696.51, -273.331, -159.969), QAngle(7.65936, 108.536, 0)),
		CSpawnPoint(Vector(1023.19, 144.201, -159.969), QAngle(2.94037, -30.506, -0)),
		CSpawnPoint(Vector(938.115, 17.6343, -159.969), QAngle(4.50127, -13.8178, 0)),
		CSpawnPoint(Vector(964.245, -193.39, -159.969), QAngle(3.04927, 2.09252, -0)),
		CSpawnPoint(Vector(1167.13, 188.324, -159.969), QAngle(3.77528, -95.4868, 0)),
		CSpawnPoint(Vector(1479.85, 323.522, -159.969), QAngle(5.19097, 67.3226, 0)),
		CSpawnPoint(Vector(1812.35, 185.577, -159.969), QAngle(4.53757, -160.278, 0)),
		CSpawnPoint(Vector(1622.09, -154.88, -159.969), QAngle(4.13827, 9.69258, 0)),
		CSpawnPoint(Vector(1797.13, -484.378, -159.969), QAngle(1.63357, 71.352, -0)),
		CSpawnPoint(Vector(2286.46, 63.6064, -159.969), QAngle(3.41224, -158.246, 0)),
		CSpawnPoint(Vector(2285.76, -346.548, -159.969), QAngle(2.90405, 138.592, 0)),
		CSpawnPoint(Vector(1362.04, -602.987, -159.969), QAngle(2.90402, 55.4292, 0)),
		CSpawnPoint(Vector(1559.8, -482.209, -159.969), QAngle(6.49771, -178.138, 0)),
		CSpawnPoint(Vector(1414.5, -172.394, -159.969), QAngle(-0.725991, 172.097, 0)),
		CSpawnPoint(Vector(1151.34, -163.791, -159.969), QAngle(2.83141, 44.7207, 0)),
		CSpawnPoint(Vector(1022.34, -620.566, -159.969), QAngle(3.63, 143.433, 0)),
		CSpawnPoint(Vector(1145.28, -816.031, -159.969), QAngle(6.89699, -131.262, 0)),
		CSpawnPoint(Vector(1250.48, -1176.16, -274.916), QAngle(2.9403, -130.245, 0)),
		CSpawnPoint(Vector(1350.24, -1527.54, -329.562), QAngle(2.06911, 169.351, 0)),
		CSpawnPoint(Vector(1170.74, -2034.58, -291.616), QAngle(0.108911, 132.289, 0)),
		CSpawnPoint(Vector(1033.26, -1744.17, -308.09), QAngle(1.16161, -169.303, 0)),
		CSpawnPoint(Vector(854.861, -1880.33, -314.892), QAngle(3.5211, 40.5599, 0)),
		CSpawnPoint(Vector(755.875, -1138.86, -251.71), QAngle(9.6195, -50.8794, 0)),
		CSpawnPoint(Vector(674.2, -1442.49, -279.969), QAngle(7.55046, 0.412412, 0)),
		CSpawnPoint(Vector(310.87, -1343.52, -279.969), QAngle(5.15465, 4.96277, 0)),
		CSpawnPoint(Vector(420.983, -946.605, -223.969), QAngle(-1.99645, 16.5778, 0)),
		CSpawnPoint(Vector(423.867, -1767.7, -335.969), QAngle(-7.44143, 92.3134, 0)),
		CSpawnPoint(Vector(-7.13005, -1650.59, -335.969), QAngle(3.41225, -61.2847, 0)),
		CSpawnPoint(Vector(404.889, -2097.86, -335.969), QAngle(-2.94026, 131.626, 0)),
		CSpawnPoint(Vector(26.6075, -2122.65, -335.969), QAngle(4.35604, 97.5985, 0)),
		CSpawnPoint(Vector(-214.57, -1749.28, -335.969), QAngle(2.72238, 179.651, 0)),
		CSpawnPoint(Vector(-428.62, -1977.79, -335.969), QAngle(0.616967, 163.534, 0)),
		CSpawnPoint(Vector(-596.251, -1615.23, -335.969), QAngle(-0.907646, -137.986, 0)),
		CSpawnPoint(Vector(-731.063, -1913.6, -335.969), QAngle(4.31955, 68.9004, 0)),
		CSpawnPoint(Vector(-944.885, -1605.02, -335.969), QAngle(-1.34325, -45.1179, 0)),
		CSpawnPoint(Vector(-1133.86, -2131.85, -335.969), QAngle(0.943644, 57.6239, 0)),
		CSpawnPoint(Vector(-802.446, -2112.68, -335.969), QAngle(-2.10556, 111.493, 0)),
		CSpawnPoint(Vector(-1432.47, -1982.52, -335.969), QAngle(-1.30694, 22.7761, 0)),
		CSpawnPoint(Vector(-1448.43, -1691.2, -335.969), QAngle(1.63336, -17.2265, 0)),
		CSpawnPoint(Vector(-878.657, -1388.12, -327.969), QAngle(9.22006, -169.844, 0)),
		CSpawnPoint(Vector(-521.577, -1154.17, -239.969), QAngle(0.544359, 137.448, 0)),
		CSpawnPoint(Vector(-862.862, -1121.21, -239.969), QAngle(0.544408, 52.107, 0)),
		CSpawnPoint(Vector(-1719.78, -1549.68, -327.969), QAngle(-4.42871, 59.7425, 0)),
		CSpawnPoint(Vector(-1526.77, -1570.03, -327.969), QAngle(-1.16171, 104.718, 0)),
		CSpawnPoint(Vector(-1444.81, -1333.06, -327.969), QAngle(-1.85142, -149.54, 0)),
		CSpawnPoint(Vector(-1703.45, -1386.35, -327.969), QAngle(-1.52472, 45.6217, 0)),
		CSpawnPoint(Vector(-1610.93, -903.482, -239.969), QAngle(18.041, -90.5033, 0)),
		CSpawnPoint(Vector(-1557.92, -674.743, -239.969), QAngle(2.90388, 39.1604, 0)),
		CSpawnPoint(Vector(-1544.93, -495.188, -239.969), QAngle(6.38867, -25.2676, 0)),
		CSpawnPoint(Vector(-1653.26, -130.05, -239.969), QAngle(4.02917, -24.1659, 0)),
		CSpawnPoint(Vector(-1564.81, -292.607, -239.969), QAngle(2.46827, 26.8547, 0)),
		CSpawnPoint(Vector(-1301.48, 265.424, -301.474), QAngle(1.8149, -83.3157, 0)),
		CSpawnPoint(Vector(-1180.34, 167.442, -326.854), QAngle(2.75869, -91.4432, 0)),
		CSpawnPoint(Vector(-1072.71, 252.431, -296.564), QAngle(7.33249, -109.996, 0)),
		CSpawnPoint(Vector(-691.419, -50.3113, -367.969), QAngle(0.798497, 139.748, 0)),
		CSpawnPoint(Vector(-735.149, 310.182, -367.969), QAngle(4.31959, -63.3868, 0)),
		CSpawnPoint(Vector(-683.19, 547.421, -367.969), QAngle(0.798488, -149.503, 0)),
		CSpawnPoint(Vector(-1344.22, 581.263, -314.089), QAngle(12.3419, -15.5072, -0)),
		CSpawnPoint(Vector(-1264.61, 825.89, -321.318), QAngle(16.0445, -55.9296, 0)),
		CSpawnPoint(Vector(-806.509, 1014.83, -273.158), QAngle(21.0902, -149.031, 0)),
		CSpawnPoint(Vector(-811.054, 1249.8, -281.657), QAngle(20.6909, -145.873, 0)),
		CSpawnPoint(Vector(-1387.16, 1194.42, -331.035), QAngle(11.9063, -56.6348, 0)),
		CSpawnPoint(Vector(-806.966, 575.6, -159.969), QAngle(-2.72262, -45.2683, 0)),
		CSpawnPoint(Vector(-647.506, 705.274, -159.969), QAngle(3.66618, -166.37, 0)),
		CSpawnPoint(Vector(-375.279, 732.528, -159.969), QAngle(6.02567, -140.088, 0)),
		CSpawnPoint(Vector(-356.989, 435.142, -159.969), QAngle(4.13808, 163.61, 0)),
		CSpawnPoint(Vector(-842.213, 256.269, -159.969), QAngle(4.17436, -14.1997, 0)),
		CSpawnPoint(Vector(-817.609, 36.3202, -159.969), QAngle(3.23056, 0.937215, 0)),
		CSpawnPoint(Vector(-825.81, -226.834, -159.969), QAngle(4.02915, 26.4561, -0)),
		CSpawnPoint(Vector(-355.794, -147.274, -159.969), QAngle(-2.61379, 93.6473, 0)),
		CSpawnPoint(Vector(-492.843, 207.478, -159.969), QAngle(0.471707, -40.7353, 0)),
		CSpawnPoint(Vector(86.2468, 249.393, -159.969), QAngle(0.36276, -80.5927, 0)),
		CSpawnPoint(Vector(115.549, -1060.65, -223.969), QAngle(-6.35276, 92.4987, 0)),
		CSpawnPoint(Vector(-110.45, -867.198, -279.969), QAngle(-16.4805, 27.9573, 0)),
		CSpawnPoint(Vector(-330.54, -795.08, -279.969), QAngle(11.3253, 175.953, 0)),
		CSpawnPoint(Vector(-440.031, -975.969, -276.633), QAngle(7.04195, 150.325, 0)),
		CSpawnPoint(Vector(-428.3, -465.6, -250.206), QAngle(22.6147, -138.455, -0)),
		CSpawnPoint(Vector(-936.545, -886.135, -318.081), QAngle(1.77846, 51.8062, 0)),
		CSpawnPoint(Vector(300.133, -517.358, -159.969), QAngle(-1.74264, 15.724, 0))
	}
};

void OnMapInit() 
{
	MaxRandomCash = 16;
	MinRandomCash = 9;

	MaxMoneyPerItem = 95.0f;
	MinMoneyPerItem = 25.0f;

	InsertToArray(1398.82, 55.4421, -128.969);
	InsertToArray(1876.26, 246.919, -138.81);
	InsertToArray(2178.13, -159.937, -158.969);
	InsertToArray(1407.23, -657.945, -79.4419);
	InsertToArray(1165.1, -233.455, -74.8412);
	InsertToArray(761.026, -118.686, -126.969);
	InsertToArray(456.185, 610.667, -158.969);
	InsertToArray(161.006, -193.455, -158.969);
	InsertToArray(22.2357, -827.812, -278.969);
	InsertToArray(-270.229, 391.343, -158.969);
	InsertToArray(-700.003, 876.362, -174.969);
	InsertToArray(-859.672, 213.707, -366.969);
	InsertToArray(-888.778, -374.942, -174.969);
	InsertToArray(-1529.09, -39.4409, -238.969);
	InsertToArray(-1678.22, -584.44, -238.969);
	InsertToArray(-1488, -1535.49, -326.969);
	InsertToArray(-774.8, -1204.56, -174.49);
	InsertToArray(-1326.02, -2166.26, -334.969);
	InsertToArray(-331.708, -1903.93, -208.969);
	InsertToArray(290.433, -1474.02, -214.49);
	InsertToArray(1400.52, -1270.91, -174.969);
	InsertToArray(648.638, -1632.41, -174.969);
	InsertToArray(-454.314, -107.224, -128.969);
	InsertToArray(-672.879, -120.148, -158.969);
	InsertToArray(-729.401, -35.4573, -128.969);

	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);

	CNetworked@ pNetworked = Network::Get("cszm_spawnsist");
	if (pNetworked !is null)
	{
		pNetworked.Save("distvalue", 1200.0f);
	}

	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void SetUpStuff() 
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	
	Engine.Ent_Fire("tonemap", "SetBloomScale", "0.475");
	Engine.Ent_Fire("extinguisher", "Addoutput", "damagetoenablemotion 500");

	VMSkins();
	OpenDoors();
	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_human");
	RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(Office_HumanSpawns, true);
}

void OnMatchBegin()
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(Office_ZombieSpawns, false);
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

void VMSkins() 
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null) 
	{
		if(Utils.StrContains("vending_machine", pEntity.GetModelName())) 
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", ""+Math::RandomInt(0, 2));
		}
	}
}