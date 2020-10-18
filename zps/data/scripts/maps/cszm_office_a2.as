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

void OnMapInit() 
{
	MaxRandomCash = 16;
	MinRandomCash = 8;

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