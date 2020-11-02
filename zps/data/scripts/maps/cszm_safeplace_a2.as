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

array<array<CSpawnPoint@>> SP_ZombieSpawns = 
{
	{
		CSpawnPoint(Vector(-1603.61, 1770.15, 128.031), QAngle(0.616807, 30.6416, 0)),
		CSpawnPoint(Vector(-1622.47, 2065.16, 128.031), QAngle(1.37911, -35.2066, 0)),
		CSpawnPoint(Vector(-1443.8, 2007.29, 128.031), QAngle(5.29951, -5.15018, -0)),
		CSpawnPoint(Vector(-1414.29, 1843.42, 128.031), QAngle(3.77491, 13.4199, 0)),
		CSpawnPoint(Vector(-1212.95, 1746.78, 192.031), QAngle(15.3909, 139.578, 0)),
		CSpawnPoint(Vector(-1634.35, 1579.28, 256.031), QAngle(10.8534, 43.5288, 0)),
		CSpawnPoint(Vector(-1605.27, 1365.07, 256.031), QAngle(6.0255, 46.3567, 0)),
		CSpawnPoint(Vector(-1236.71, 1481.48, 256.031), QAngle(7.3323, 91.0084, 0)),
		CSpawnPoint(Vector(-1234.2, 2129.14, 192.031), QAngle(9.54664, -145.087, 0)),
		CSpawnPoint(Vector(-1629.64, 2249.42, 256.031), QAngle(18.2223, -44.3542, 0)),
		CSpawnPoint(Vector(-1374.2, 2328.03, 256.031), QAngle(19.275, -67.2593, 0)),
		CSpawnPoint(Vector(-1538.53, 2468.4, 256.031), QAngle(11.8335, -77.7862, 0)),
		CSpawnPoint(Vector(-912.031, 1967.97, 154.317), QAngle(7.40498, -144.36, 0)),
		CSpawnPoint(Vector(-912.029, 1872.03, 156.544), QAngle(4.21057, 132.815, 0)),
		CSpawnPoint(Vector(-962.372, 2162.21, 128.031), QAngle(1.95997, -96.0084, 0)),
		CSpawnPoint(Vector(-969.198, 2486.24, 128.031), QAngle(4.53725, 10.4723, 0)),
		CSpawnPoint(Vector(-656.031, 3183.97, 128.031), QAngle(8.56657, -119.01, 0)),
		CSpawnPoint(Vector(-879.969, 3183.97, 128.031), QAngle(6.06188, -70.6218, 0)),
		CSpawnPoint(Vector(-879.969, 3039.97, 128.031), QAngle(9.25627, -61.3653, 0)),
		CSpawnPoint(Vector(-656.031, 3039.97, 128.031), QAngle(13.7575, -80.8947, 0)),
		CSpawnPoint(Vector(-879.969, 2911.97, 128.031), QAngle(4.8277, -64.2331, 0)),
		CSpawnPoint(Vector(-656.031, 2911.97, 128.031), QAngle(10.4542, -111.35, 0)),
		CSpawnPoint(Vector(-528.031, 2448.03, 128.031), QAngle(4.0291, 139.797, 0)),
		CSpawnPoint(Vector(-103.236, 3196.49, 128.031), QAngle(7.87691, -68.9518, 0)),
		CSpawnPoint(Vector(248.389, 3659.89, 128.031), QAngle(3.88391, -78.9345, 0)),
		CSpawnPoint(Vector(332.779, 3670.57, 128.031), QAngle(14.0479, -108.483, 0)),
		CSpawnPoint(Vector(301.924, 3567.18, 128.031), QAngle(7.768, -91.4854, 0)),
		CSpawnPoint(Vector(830.61, 2875.95, 128.031), QAngle(4.53733, 120.002, 0)),
		CSpawnPoint(Vector(461.114, 2892.83, 128.031), QAngle(-1.27067, -25.7549, 0)),
		CSpawnPoint(Vector(900.328, 2753.87, 128.031), QAngle(6.96943, -159.811, 0)),
		CSpawnPoint(Vector(484.655, 2739.91, 128.031), QAngle(5.73523, -101.223, 0)),
		CSpawnPoint(Vector(456.42, 2262.87, 128.031), QAngle(5.33594, -158.864, -0)),
		CSpawnPoint(Vector(31.3291, 2250.84, 128.031), QAngle(7.76804, -60.6023, 0)),
		CSpawnPoint(Vector(-447.452, 2127.8, 128.031), QAngle(11.6521, -37.3701, -0)),
		CSpawnPoint(Vector(-547.42, 2113.47, 128.031), QAngle(11.4706, -37.1886, 0)),
		CSpawnPoint(Vector(-576.098, 1989.75, 128.031), QAngle(5.95304, -46.0806, 0)),
		CSpawnPoint(Vector(1247.97, 2287.97, 128.031), QAngle(0.834745, -178.105, 0)),
		CSpawnPoint(Vector(1247.97, 2064.03, 128.031), QAngle(1.48815, 150.822, 0)),
		CSpawnPoint(Vector(1375.97, 2064.03, 128.031), QAngle(1.05254, 148.027, 0)),
		CSpawnPoint(Vector(1375.97, 2287.97, 128.031), QAngle(0.76214, -163.113, 0)),
		CSpawnPoint(Vector(1519.97, 2287.97, 128.031), QAngle(5.29963, -155.635, 0)),
		CSpawnPoint(Vector(1465.97, 2064.03, 128.031), QAngle(4.35581, 138.879, 0)),
		CSpawnPoint(Vector(1519.97, 2181.99, 128.031), QAngle(7.22352, -178.359, 0)),
		CSpawnPoint(Vector(1392.96, 2183.09, 128.031), QAngle(5.40852, -177.851, 0)),
		CSpawnPoint(Vector(1222.59, 2177.41, 128.031), QAngle(5.80782, -179.013, -0)),
		CSpawnPoint(Vector(853.139, 1874.32, 128.031), QAngle(20.6182, -174.189, 0)),
		CSpawnPoint(Vector(726.861, 1577.18, 128.031), QAngle(22.7599, 146.503, 0)),
		CSpawnPoint(Vector(712.586, 1986.01, 128.031), QAngle(18.295, -149.862, 0)),
		CSpawnPoint(Vector(948.277, 1445.23, 143.628), QAngle(5.00918, -90.8759, 0)),
		CSpawnPoint(Vector(891.286, 1090.08, 141.031), QAngle(2.64968, -120.424, 0)),
		CSpawnPoint(Vector(831.572, 656.294, 140.943), QAngle(16.2985, -131.786, -0)),
		CSpawnPoint(Vector(567.35, 571.633, 142.05), QAngle(8.74807, -174.075, 0)),
		CSpawnPoint(Vector(367.969, 1135.97, 64.0313), QAngle(-55.1762, -133.987, 0)),
		CSpawnPoint(Vector(144.031, 912.031, 208.031), QAngle(30.637, 47.0539, 0)),
		CSpawnPoint(Vector(-238.968, 1041.03, 64.0059), QAngle(2.25037, 65.6394, 0)),
		CSpawnPoint(Vector(-132.183, 1082.62, 64.0313), QAngle(1.63327, 5.70814, 0)),
		CSpawnPoint(Vector(-189.889, 1221.61, 64.0313), QAngle(1.08876, 90.8317, -0)),
		CSpawnPoint(Vector(194.695, 959.23, 64.0313), QAngle(2.21407, 45.0574, 0)),
		CSpawnPoint(Vector(188.064, 230.616, 141.031), QAngle(3.33937, -163.558, 0)),
		CSpawnPoint(Vector(-147.863, 192.012, 142.292), QAngle(1.92368, 155.096, 0)),
		CSpawnPoint(Vector(-641.246, 300.621, 145.468), QAngle(3.08528, 178.909, 0)),
		CSpawnPoint(Vector(-1263.97, 264.031, 128.031), QAngle(-0.472106, 33.8544, 0)),
		CSpawnPoint(Vector(-1263.97, 487.969, 128.031), QAngle(1.41545, 0.543205, 0)),
		CSpawnPoint(Vector(-1124.39, 844.999, 128.031), QAngle(-0.109156, -43.537, 0)),
		CSpawnPoint(Vector(-1033.48, 869.2, 128.031), QAngle(1.23393, -93.7037, 0)),
		CSpawnPoint(Vector(-941.989, 820.567, 128.031), QAngle(1.59693, -123.942, -0)),
		CSpawnPoint(Vector(-1391.29, 679.061, 128.031), QAngle(4.24684, 34.2304, 0)),
		CSpawnPoint(Vector(-1351.46, 966.626, 128.031), QAngle(14.8827, 21.5254, 0)),
		CSpawnPoint(Vector(-474.898, 648.031, 128.031), QAngle(10.4178, 139.246, 0)),
		CSpawnPoint(Vector(-411.175, 923.749, 128.031), QAngle(4.53723, 136.306, 0)),
		CSpawnPoint(Vector(-591.293, 1135.15, 128.031), QAngle(7.84053, -77.768, 0)),
		CSpawnPoint(Vector(-862.766, 970.865, 128.031), QAngle(1.48803, 57.6439, 0)),
		CSpawnPoint(Vector(-1037.24, 1057.87, 128.031), QAngle(3.37562, 72.0518, 0)),
		CSpawnPoint(Vector(-914.311, 1322.14, 128.031), QAngle(4.93652, 112.05, 0)),
		CSpawnPoint(Vector(-1068.35, 1568.73, 128.031), QAngle(7.87682, -62.509, 0)),
		CSpawnPoint(Vector(-233.563, 2570.67, 128.031), QAngle(3.15783, 2.68575, 0)),
		CSpawnPoint(Vector(16.0313, 2031.99, -127.969), QAngle(3.08523, -22.9056, 0)),
		CSpawnPoint(Vector(18.1842, 1943.79, -127.969), QAngle(1.45173, -12.4149, 0)),
		CSpawnPoint(Vector(173.68, 2031.97, -127.969), QAngle(-0.508472, -94.0536, 0)),
		CSpawnPoint(Vector(465.719, 1677.51, -127.969), QAngle(0.979845, -169.558, 0)),
		CSpawnPoint(Vector(495.969, 1888.46, -127.969), QAngle(2.14145, 169.171, 0)),
		CSpawnPoint(Vector(-14.2027, 1458.77, 0.03125), QAngle(2.64965, 50.1792, 0)),
		CSpawnPoint(Vector(495.972, 1424.05, 0.03125), QAngle(5.44473, 115.664, 0)),
		CSpawnPoint(Vector(499.017, 2132.85, 0.0312482), QAngle(6.75151, -128.393, 0)),
		CSpawnPoint(Vector(-10.3079, 2117.96, 0.03125), QAngle(7.84051, -59.5673, 0))
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
	CreateSpawnsFromArray(SP_ZombieSpawns, false);
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