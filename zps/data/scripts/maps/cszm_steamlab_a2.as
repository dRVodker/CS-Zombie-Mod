#include "cszm_modules/spawncrates"
#include "cszm_modules/newspawn"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

array<array<CSpawnPoint@>> SL_HumanSpawns = 
{
	{
		CSpawnPoint(Vector(-2152, 1536, 1033), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-2120, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-1896, 1536, 1033), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-2376, 1856, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-1960, 1600, 1033), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1864, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2248, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2056, 1920, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2216, 1600, 1033), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-2376, 1920, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2440, 1856, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2152, 1600, 1033), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1992, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2184, 1920, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2312, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2440, 1920, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-1928, 1920, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2376, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2248, 1856, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2024, 1600, 1033), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-1928, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-2248, 1920, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-1800, 1984, 1033), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-1960, 1536, 1033), QAngle(0, 90, 0))
	},
	{
		CSpawnPoint(Vector(-3269.53, 2554.27, 888.031), QAngle(0.907463, -25.1319, 0)),
		CSpawnPoint(Vector(-2844.23, 2538.62, 889.262), QAngle(4.24705, -158.099, 0)),
		CSpawnPoint(Vector(-2797.08, 1869.34, 888.031), QAngle(5.19086, -51.5948, 0)),
		CSpawnPoint(Vector(-3318.07, 1920.92, 775.279), QAngle(3.15803, -112.01, 0)),
		CSpawnPoint(Vector(-3679.51, 1605.03, 780.031), QAngle(0.0362612, -15.0542, 0)),
		CSpawnPoint(Vector(-3140.97, 1603.94, 780.031), QAngle(6.42507, -152.413, 0)),
		CSpawnPoint(Vector(-2594.15, 1528.83, 720.031), QAngle(1.41582, -30.7962, 0)),
		CSpawnPoint(Vector(-1837.75, 1561.16, 800.031), QAngle(18.0412, -150.853, 0)),
		CSpawnPoint(Vector(-1987.87, 2016.42, 848.031), QAngle(2.83149, 173.682, 0)),
		CSpawnPoint(Vector(-1409.11, 1631.37, 903.782), QAngle(10.5633, 88.7401, 0)),
		CSpawnPoint(Vector(-1326.75, 2159.31, 888.031), QAngle(1.52465, 27.4294, 0)),
		CSpawnPoint(Vector(-1150.39, 2876.44, 888.031), QAngle(2.72254, -78.8698, 0)),
		CSpawnPoint(Vector(-1392.44, 2189.57, 1016.03), QAngle(20.2554, 12.1711, 0)),
		CSpawnPoint(Vector(-1914.75, 1575.08, 1032.03), QAngle(3.84779, 128.742, 0)),
		CSpawnPoint(Vector(-2006.56, 1778.97, 1043.03), QAngle(18.15, -138.003, 0)),
		CSpawnPoint(Vector(-2252.96, 1898.61, 1032.03), QAngle(3.88407, -55.2755, 0)),
		CSpawnPoint(Vector(-2474.91, 1548.73, 1032.03), QAngle(-1.01645, 34.3134, 0)),
		CSpawnPoint(Vector(-2504.77, 2158.64, 1032.03), QAngle(3.01286, -46.2726, 0)),
		CSpawnPoint(Vector(-1607.01, 2161.93, 1032.03), QAngle(3.08546, -136.986, 0)),
		CSpawnPoint(Vector(-1949.8, 2269.29, 824.031), QAngle(4.02938, 134.211, 0)),
		CSpawnPoint(Vector(-2663.79, 3285.82, 888.031), QAngle(4.46499, -133.768, 0)),
		CSpawnPoint(Vector(-1710.36, 3155.55, 1056.03), QAngle(24.8656, -136.889, 0)),
		CSpawnPoint(Vector(-1493.23, 3386.74, 1016.03), QAngle(7.18752, -81.4467, 0))
	},
	{
		CSpawnPoint(Vector(-1380.99, 2800.77, 888.031), QAngle(5.08213, 64.6608, 0)),
		CSpawnPoint(Vector(-1249.97, 2720, 895.059), QAngle(0.943884, 3.0235, 0)),
		CSpawnPoint(Vector(-834.367, 2251.24, 888.031), QAngle(6.20735, 158.823, 0)),
		CSpawnPoint(Vector(-1383.19, 1866.15, 888.031), QAngle(12.2331, -118.993, 0)),
		CSpawnPoint(Vector(-2455.68, 2067.97, 848.031), QAngle(-1.27044, -130.282, 0)),
		CSpawnPoint(Vector(-1937.78, 1294.71, 808.031), QAngle(16.8433, 136.716, 0)),
		CSpawnPoint(Vector(-2591.71, 1288.42, 812.031), QAngle(-9.07495, 109.019, 0)),
		CSpawnPoint(Vector(-3114.75, 1867.24, 888.031), QAngle(3.33962, 64.5517, 0)),
		CSpawnPoint(Vector(-3341.89, 1536.47, 781.219), QAngle(-13.5036, 113.63, 0)),
		CSpawnPoint(Vector(-3272.19, 2199.49, 888.031), QAngle(7.91345, 17.9072, 0)),
		CSpawnPoint(Vector(-2754.39, 2727.72, 888.031), QAngle(14.5564, -146.858, 0)),
		CSpawnPoint(Vector(-3054.38, 3506.6, 888.031), QAngle(4.21092, -117.092, 0)),
		CSpawnPoint(Vector(-2655.24, 2995.56, 888.031), QAngle(7.65944, 143.179, 0)),
		CSpawnPoint(Vector(-2397.38, 3085.68, 888.031), QAngle(4.57399, -38.2488, 0)),
		CSpawnPoint(Vector(-2241.85, 2628.03, 824.031), QAngle(0.689866, 14.8582, 0)),
		CSpawnPoint(Vector(-1739.31, 3099.74, 888.031), QAngle(10.1642, -139.49, 0)),
		CSpawnPoint(Vector(-2099.14, 2125.67, 1032.03), QAngle(14.5201, -49.8407, 0)),
		CSpawnPoint(Vector(-1612.06, 1470.67, 1030.03), QAngle(1.37947, 146.761, 0)),
		CSpawnPoint(Vector(-1474.89, 2019.41, 1016.03), QAngle(3.12188, 71.9827, 0)),
		CSpawnPoint(Vector(-1916.76, 2106.32, 1164.03), QAngle(21.4897, -114.527, 0)),
		CSpawnPoint(Vector(-1662.54, 1836.53, 1142.79), QAngle(18.0048, -166.182, 0)),
		CSpawnPoint(Vector(-1762.92, 1463.9, 1146.03), QAngle(12.9955, 102.124, 0)),
		CSpawnPoint(Vector(-2313.27, 1457.64, 1032.03), QAngle(-0.217701, 49.6707, 0)),
		CSpawnPoint(Vector(-2668.05, 1520.52, 1032.62), QAngle(6.49781, 144.51, 0))
	}
};

void OnMapInit()
{	
	Schedule::Task(0.05f, "SetUpStuff");

	iMinCrates = 0;
	iMaxCrates = 4;

	g_PICOrigin.insertLast(Vector(-3260.25, 1504.83, 780.466));
	g_PICAngles.insertLast(QAngle(0, -37.24, 0));

	g_PICOrigin.insertLast(Vector(-2807.68, 2142.01, 969.004));
	g_PICAngles.insertLast(QAngle(-0.0368034, -27.3475, 0.0120844));

	g_PICOrigin.insertLast(Vector(-1755.55, 1475.33, 1261.0));
	g_PICAngles.insertLast(QAngle(0, 57.6366, 0));

	g_PICOrigin.insertLast(Vector(-972.825, 1840.93, 888.455));
	g_PICAngles.insertLast(QAngle(0, -33.8835, 0));

	g_PICOrigin.insertLast(Vector(-2612.6, 1289.8, 720.479));
	g_PICAngles.insertLast(QAngle(0, 31.2687, 0));

	g_PICOrigin.insertLast(Vector(-1695.06, 3252.04, 1097.11));
	g_PICAngles.insertLast(QAngle(0, 40.387, 0));

	g_PICOrigin.insertLast(Vector(-1858.55, 2268.52, 1032.42));
	g_PICAngles.insertLast(QAngle(0, 127.438, 0));

	g_PICOrigin.insertLast(Vector(-3250.75, 2402.12, 912.5));
	g_PICAngles.insertLast(QAngle(0, -131.857, -180));
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnCrates");
}

void SetUpStuff()
{
	int iRNDPitch = Math::RandomInt(65, 135);
	
	Engine.Ent_Fire("teleport_ambient", "Pitch", ""+iRNDPitch);
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitchstart "+iRNDPitch);
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitch "+iRNDPitch);
	
	Engine.Ent_Fire("teleport_ambient", "PlaySound");
	Engine.Ent_Fire("teleport_ambient", "Volume", "10");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	Engine.Ent_Fire("HumanSpawn*", "AddOutput", "OnPlayerSpawn !self:kill:0:0:1");
	
	CreatedByColors();

	RemoveNativeSpawns("info_player_zombie");
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SL_HumanSpawns);
}

void CreatedByColors()
{
	float flFireTime = Math::RandomFloat(0.10f, 1.20f);
	
	Schedule::Task(flFireTime, "CreatedByColors");
	
	int iR = Math::RandomInt(32, 255);
	int iG = Math::RandomInt(32, 255);
	int iB = Math::RandomInt(32, 255);
	
	Engine.Ent_Fire("created_by", "color", ""+iR+" "+iG+" "+iB);
}