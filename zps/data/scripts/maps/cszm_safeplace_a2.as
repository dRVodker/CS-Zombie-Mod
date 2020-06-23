#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"

const int TEAM_LOBBYGUYS = 0;

array<array<CSpawnPoint@>> SP_HumanSpawns = 
{
	{
		CSpawnPoint(Vector(83.9293, 1712.74, -127.969), QAngle(14.1933, 33.8459, 0)),
		CSpawnPoint(Vector(65.0328, 1855.63, -127.969), QAngle(16.5891, 2.41006, 0)),
		CSpawnPoint(Vector(47.0346, 2001.59, -127.969), QAngle(1.4157, -44.5986, 0)),
		CSpawnPoint(Vector(-1.47794, 1450.64, 0.03125), QAngle(7.7319, 56.388, 0)),
		CSpawnPoint(Vector(344.078, 1478.25, 0.03125), QAngle(16.2261, 118.401, 0)),
		CSpawnPoint(Vector(533.092, 1544.68, 0.03125), QAngle(-1.99648, 140.217, 0)),
		CSpawnPoint(Vector(584.942, 1736.7, 0.03125), QAngle(5.88061, 177.498, 0)),
		CSpawnPoint(Vector(572.028, 1923.05, 0.03125), QAngle(11.8701, -166.24, 0)),
		CSpawnPoint(Vector(457.882, 2086.31, 0.03125), QAngle(12.7413, -120.538, 0)),
		CSpawnPoint(Vector(255.853, 2131.17, 0.03125), QAngle(13.2858, -92.6235, 0)),
		CSpawnPoint(Vector(48.1913, 2109.02, 0.03125), QAngle(8.63944, -84.7831, 0)),
		CSpawnPoint(Vector(-112.008, 1962.66, 0.03125), QAngle(8.02235, -7.21012, 0)),
		CSpawnPoint(Vector(-95.6139, 1713.85, 0.03125), QAngle(7.22377, 2.77242, 0)),
		CSpawnPoint(Vector(337.094, 1981.91, -127.969), QAngle(2.46846, -131.138, 0)),
		CSpawnPoint(Vector(408.399, 1684.42, -127.969), QAngle(4.17455, 166.752, 0)),
		CSpawnPoint(Vector(-201.017, 1451.79, 64.0313), QAngle(4.31974, 32.9016, 0)),
		CSpawnPoint(Vector(-250.297, 1671.14, 64.0313), QAngle(6.93334, -0.603345, 0)),
		CSpawnPoint(Vector(-250.062, 1935.44, 64.0313), QAngle(10.2003, -24.271, 0)),
		CSpawnPoint(Vector(-121.034, 2114.17, 128.031), QAngle(25.9545, -42.5299, 0)),
		CSpawnPoint(Vector(155.214, 2215.56, 128.031), QAngle(23.0868, -82.8955, 0)),
		CSpawnPoint(Vector(484.463, 2203.53, 128.031), QAngle(21.1266, -113.315, 0)),
		CSpawnPoint(Vector(685.893, 1974.78, 128.031), QAngle(18.5856, -164.329, 0)),
		CSpawnPoint(Vector(698.794, 1758, 128.031), QAngle(23.8128, 170.66, -0)),
		CSpawnPoint(Vector(680.001, 1574.53, 128.031), QAngle(16.9158, 161.658, -0)),
		CSpawnPoint(Vector(891.573, 1857.49, 128.031), QAngle(-0.798621, -176.054, 0)),
		CSpawnPoint(Vector(978.014, 1698.01, 128.031), QAngle(-0.907521, 161.186, 0))
	},
	{
		CSpawnPoint(Vector(300.194, 1961.03, -127.969), QAngle(0.0363, -120.634, 0)),
		CSpawnPoint(Vector(160.457, 1696.33, -127.969), QAngle(0, 77.6769, 0)),
		CSpawnPoint(Vector(690.753, 1688.37, 128.031), QAngle(16.6254, 151.363, 0)),
		CSpawnPoint(Vector(1308.64, 2123.05, 128.031), QAngle(8.1312, 162.335, 0)),
		CSpawnPoint(Vector(365.703, 2210.11, 128.031), QAngle(13.6125, -119.075, 0)),
		CSpawnPoint(Vector(894.841, 2723.55, 128.031), QAngle(1.05271, 121.594, 0)),
		CSpawnPoint(Vector(-509.593, 2130.96, 128.031), QAngle(3.59372, -32.4036, 0)),
		CSpawnPoint(Vector(-418.304, 934.677, 128.031), QAngle(0.943818, 128.927, 0)),
		CSpawnPoint(Vector(-928.48, 831.887, 128.031), QAngle(6.96961, -110.666, 0)),
		CSpawnPoint(Vector(-923.831, 1395.38, 128.031), QAngle(9.83728, -112.844, 0)),
		CSpawnPoint(Vector(-1645.67, 2077.61, 128.031), QAngle(1.77867, -45.096, 0)),
		CSpawnPoint(Vector(-1624.04, 1351.57, 256.031), QAngle(5.98943, 23.6563, 0)),
		CSpawnPoint(Vector(-1501.52, 2349.32, 256.031), QAngle(8.89344, 141.631, 0)),
		CSpawnPoint(Vector(-730.189, 3131.59, 128.031), QAngle(5.40863, -140.287, 0)),
		CSpawnPoint(Vector(-543.939, 2467.68, 128.031), QAngle(7.84068, 137.638, 0)),
		CSpawnPoint(Vector(331.041, 3697.1, 128.031), QAngle(24.5387, -111.162, 0)),
		CSpawnPoint(Vector(-216.838, 2951.59, 128.031), QAngle(23.014, -171.892, 0)),
		CSpawnPoint(Vector(362.953, 1131.1, 64.0313), QAngle(-38.8412, -135.864, -0)),
		CSpawnPoint(Vector(794.58, 624.233, 141.031), QAngle(21.7435, 149.708, 0)),
		CSpawnPoint(Vector(-160.949, 193.793, 141.031), QAngle(13.8664, 123.681, 0)),
		CSpawnPoint(Vector(-1230.53, 280.371, 128.031), QAngle(36.0094, 159.871, 0)),
		CSpawnPoint(Vector(-1238.48, 1713.81, 192.031), QAngle(24.0303, 147.675, 0)),
		CSpawnPoint(Vector(-237.732, 1465.6, 64.0313), QAngle(12.4869, 40.7582, 0)),
		CSpawnPoint(Vector(-1358.13, 935.003, 128.031), QAngle(16.4799, 56.4033, 0)),
		CSpawnPoint(Vector(39.726, 2004.33, -127.969), QAngle(2.21409, -49.3983, 0))
	},
	{
		CSpawnPoint(Vector(-1613.67, 1772.86, 128.031), QAngle(8.09468, 32.5801, 0)),
		CSpawnPoint(Vector(-1608.8, 2048.55, 128.031), QAngle(-16.6256, -34.2119, 0)),
		CSpawnPoint(Vector(-1522.52, 1829.07, 128.031), QAngle(1.74212, 25.0181, 0)),
		CSpawnPoint(Vector(-1505.13, 2006.18, 128.031), QAngle(-0.218092, -9.99961, 0)),
		CSpawnPoint(Vector(-1553.81, 1915.38, 128.031), QAngle(-0.762613, 0.0193614, 0)),
		CSpawnPoint(Vector(-1401.53, 1988.66, 128.031), QAngle(-0.835238, -10.2898, 0)),
		CSpawnPoint(Vector(-1398.42, 1827.55, 128.031), QAngle(-0.653734, 9.20322, 0)),
		CSpawnPoint(Vector(-1465.5, 1913.32, 128.031), QAngle(-0.653756, -0.634356, 0)),
		CSpawnPoint(Vector(-1322.86, 1905.51, 128.031), QAngle(-1.23457, -15.3359, 0)),
		CSpawnPoint(Vector(-1276.57, 2002.13, 128.031), QAngle(-2.28728, -11.8511, 0)),
		CSpawnPoint(Vector(-1263.4, 1832.99, 128.031), QAngle(-1.85166, 11.4172, 0)),
		CSpawnPoint(Vector(-978.28, 1831.18, 139.63), QAngle(6.53362, 165.837, 0)),
		CSpawnPoint(Vector(-967.437, 2007.32, 140.688), QAngle(12.0149, -164.324, 0)),
		CSpawnPoint(Vector(-1097.07, 1830.6, 128.031), QAngle(3.95632, 161.264, 0)),
		CSpawnPoint(Vector(-1080.47, 2010.92, 128.031), QAngle(3.557, -160.767, 0)),
		CSpawnPoint(Vector(-1008.16, 1922.32, 143.732), QAngle(10.9985, -179.897, 0)),
		CSpawnPoint(Vector(-1203.27, 1738.82, 192.031), QAngle(-4.28385, 134.715, 0)),
		CSpawnPoint(Vector(-1635.55, 1696.08, 256.031), QAngle(15.8263, 32.5667, 0)),
		CSpawnPoint(Vector(-1255.87, 2096.47, 192.031), QAngle(16.8428, -53.0649, 0)),
		CSpawnPoint(Vector(-1635.77, 2164.13, 256.031), QAngle(12.7409, -32.5916, 0)),
		CSpawnPoint(Vector(-1322.03, 2229.3, 256.031), QAngle(14.8826, -98.5124, 0)),
		CSpawnPoint(Vector(-1276.46, 1605.33, 256.031), QAngle(16.5161, 97.3988, 0)),
		CSpawnPoint(Vector(-945.213, 2146.29, 128.042), QAngle(3.08506, -115.029, 0)),
		CSpawnPoint(Vector(-997.486, 1714.76, 128.031), QAngle(1.27006, 122.314, 0))
	}
};

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");

	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);
}

void OnNewRound()
{	
	Schedule::Task(0.05f, "SetUpStuff");
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	Engine.Ent_Fire("SND-Ambient", "Volume", "10");

	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_zombie");
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SP_HumanSpawns, true);
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