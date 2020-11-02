void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

#include "cszm_modules/newspawn"
#include "cszm_modules/cashmaker"

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

array<array<CSpawnPoint@>> SL_ZombieSpawns = 
{
	{
		CSpawnPoint(Vector(-2490.3, 2137.21, 1032.03), QAngle(0.0699345, -48.4832, 0)),
		CSpawnPoint(Vector(-2442.87, 1490.48, 1032.03), QAngle(5.76903, 63.0305, 0)),
		CSpawnPoint(Vector(-1965.94, 2162.32, 1032.03), QAngle(4.75264, -171.758, 0)),
		CSpawnPoint(Vector(-2210.04, 2379.73, 1032.03), QAngle(16.1871, -99.8345, 0)),
		CSpawnPoint(Vector(-2046.15, 2473.6, 1120.03), QAngle(36.4788, -162.706, 0)),
		CSpawnPoint(Vector(-1866.06, 2268.16, 1032.03), QAngle(8.70934, 152.936, 0)),
		CSpawnPoint(Vector(-2283.42, 1972.96, 1032.03), QAngle(5.76906, -48.7724, -0)),
		CSpawnPoint(Vector(-2235.91, 1533.58, 1033.26), QAngle(5.22455, 58.255, 0)),
		CSpawnPoint(Vector(-1828.53, 1589.4, 1032.03), QAngle(8.96344, 140.182, 0)),
		CSpawnPoint(Vector(-1820.09, 2010.12, 1032.03), QAngle(5.18823, -133.896, 0)),
		CSpawnPoint(Vector(-1656.19, 2122.53, 1032.03), QAngle(3.15546, -92.6462, 0)),
		CSpawnPoint(Vector(-1645.08, 1532.42, 1030.03), QAngle(5.58756, 95.6912, 0)),
		CSpawnPoint(Vector(-1764.27, 1461.23, 1146.03), QAngle(15.5701, 106.291, 0)),
		CSpawnPoint(Vector(-2118.59, 2148.05, 1164.03), QAngle(22.8301, -123.392, 0)),
		CSpawnPoint(Vector(-1982.25, 2152.13, 1164.03), QAngle(28.2388, -104.153, -0)),
		CSpawnPoint(Vector(-2510.22, 2160.47, 1140.03), QAngle(11.323, -50.7791, 0)),
		CSpawnPoint(Vector(-2486.94, 1424.03, 1140), QAngle(2.64736, 87.161, 0)),
		CSpawnPoint(Vector(-2711.97, 1476.03, 1032.03), QAngle(4.93426, 59.3192, 0)),
		CSpawnPoint(Vector(-2646.68, 1588.9, 1032.03), QAngle(8.89097, 76.9973, 0)),
		CSpawnPoint(Vector(-2556.03, 1903.97, 1032.03), QAngle(-0.29293, -140.246, 0)),
		CSpawnPoint(Vector(-2759.97, 1732.03, 1032.03), QAngle(1.95767, 25.1249, 0)),
		CSpawnPoint(Vector(-2680.92, 2136.82, 1016.03), QAngle(21.0878, 161.871, 0)),
		CSpawnPoint(Vector(-2643, 2423.21, 1016.03), QAngle(23.6651, -166.669, 0)),
		CSpawnPoint(Vector(-2671.94, 2890.2, 888.031), QAngle(4.60755, -156.969, 0)),
		CSpawnPoint(Vector(-2760.8, 2828.51, 888.031), QAngle(15.1346, 159.953, -0)),
		CSpawnPoint(Vector(-2762.56, 2692.34, 888.031), QAngle(10.597, 156.023, 0)),
		CSpawnPoint(Vector(-2656.68, 3050.95, 888.031), QAngle(2.93772, 175.939, 0)),
		CSpawnPoint(Vector(-2844.07, 2995.38, 888.031), QAngle(13.1743, 162.455, -0)),
		CSpawnPoint(Vector(-2998.57, 3051.47, 888.031), QAngle(7.87451, -163.651, 0)),
		CSpawnPoint(Vector(-3059.09, 3499.45, 888.031), QAngle(4.93421, -119.256, -0)),
		CSpawnPoint(Vector(-3171.41, 3398.57, 888.031), QAngle(11.4682, -80.1788, 0)),
		CSpawnPoint(Vector(-3167.76, 3059.11, 888.031), QAngle(6.96701, -77.6531, 0)),
		CSpawnPoint(Vector(-3193.85, 2827.65, 888.031), QAngle(1.88501, -74.4523, 0)),
		CSpawnPoint(Vector(-2802.12, 2603.13, 888.031), QAngle(8.09231, -140.888, 0)),
		CSpawnPoint(Vector(-2813.93, 2448.67, 888.031), QAngle(3.88151, -150.996, -0)),
		CSpawnPoint(Vector(-2871.34, 2306.43, 888.031), QAngle(4.31711, 177.557, -0)),
		CSpawnPoint(Vector(-3222.35, 2176.23, 888.031), QAngle(6.60401, 18.8282, -0)),
		CSpawnPoint(Vector(-3163.1, 2539.04, 889.219), QAngle(8.60049, -19.7857, 0)),
		CSpawnPoint(Vector(-3134, 2409.96, 888.031), QAngle(8.74569, -18.8107, 0)),
		CSpawnPoint(Vector(-2956.09, 1858.96, 888.031), QAngle(0.116462, 74.9161, 0)),
		CSpawnPoint(Vector(-3084.16, 1878.13, 888.031), QAngle(3.05676, 82.1382, -0)),
		CSpawnPoint(Vector(-3461.74, 1913.92, 888.031), QAngle(6.65045, -17.8301, 0)),
		CSpawnPoint(Vector(-3665.51, 1547.24, 780.031), QAngle(2.04036, 45.5366, 0)),
		CSpawnPoint(Vector(-3582.01, 1649.23, 780.031), QAngle(-1.29924, -114.401, 0)),
		CSpawnPoint(Vector(-3349.1, 1528.6, 780.031), QAngle(0.660967, 105.286, 0)),
		CSpawnPoint(Vector(-3497.22, 1547.11, 780.031), QAngle(2.69377, 64.7393, -0)),
		CSpawnPoint(Vector(-3159, 1568.2, 780.031), QAngle(3.67388, 177.851, 0)),
		CSpawnPoint(Vector(-3291.56, 1903.36, 773.08), QAngle(8.02988, -143.672, 0)),
		CSpawnPoint(Vector(-3512.14, 1932.73, 776.194), QAngle(4.87179, -60.2546, 0)),
		CSpawnPoint(Vector(-2498.66, 1850.03, 888.031), QAngle(-0.173912, 172.174, 0)),
		CSpawnPoint(Vector(-2502.55, 2038.49, 848.031), QAngle(3.12938, -2.24742, 0)),
		CSpawnPoint(Vector(-2699.75, 1284.95, 816.031), QAngle(4.94439, 39.7882, 0)),
		CSpawnPoint(Vector(-2693.69, 1535.04, 888.031), QAngle(15.907, -26.7497, 0)),
		CSpawnPoint(Vector(-2559.66, 1319.59, 812.263), QAngle(3.05681, 82.5473, -0)),
		CSpawnPoint(Vector(-2211.27, 1300.9, 812.031), QAngle(4.58141, 111.335, -0)),
		CSpawnPoint(Vector(-1971.69, 1292.31, 808.031), QAngle(17.8672, 103.335, 0)),
		CSpawnPoint(Vector(-2003.41, 1508.97, 720.031), QAngle(-0.282783, -141.035, 0)),
		CSpawnPoint(Vector(-2582, 1530.83, 720.031), QAngle(-6.30859, -47.345, 0)),
		CSpawnPoint(Vector(-2451.63, 1291.37, 720.031), QAngle(0.00761057, 37.636, 0)),
		CSpawnPoint(Vector(-1935.39, 1297.44, 720.031), QAngle(3.0205, 161.606, -0)),
		CSpawnPoint(Vector(-2000.03, 1090.6, 704.031), QAngle(3.1294, 130.139, 0)),
		CSpawnPoint(Vector(-2294.69, 1048.17, 584.031), QAngle(-23.8415, 5.73859, -0)),
		CSpawnPoint(Vector(-1809.49, 1337.22, 800.031), QAngle(2.22192, 165.072, 0)),
		CSpawnPoint(Vector(-1797.77, 1495.03, 800.031), QAngle(1.78631, -168.066, -0)),
		CSpawnPoint(Vector(-2053.9, 1679.24, 848.031), QAngle(25.2361, 22.9215, 0)),
		CSpawnPoint(Vector(-1663.56, 2040.77, 848.031), QAngle(4.29101, -179.56, 0)),
		CSpawnPoint(Vector(-1416.08, 1466.91, 906.031), QAngle(5.81562, 88.5159, 0)),
		CSpawnPoint(Vector(-1405.63, 1584.1, 906.031), QAngle(3.23832, 97.1553, 0)),
		CSpawnPoint(Vector(-1363.3, 1839.1, 888.031), QAngle(10.462, 20.8764, 0)),
		CSpawnPoint(Vector(-1172.37, 1890.69, 888.031), QAngle(-6.12708, 70.584, 0)),
		CSpawnPoint(Vector(-1012.3, 1874.65, 889.155), QAngle(7.41282, 81.1703, -0)),
		CSpawnPoint(Vector(-1346.11, 2130.65, 888.031), QAngle(0.0439132, 18.8796, -0)),
		CSpawnPoint(Vector(-894.665, 2255.55, 889.092), QAngle(7.41281, -174.823, 0)),
		CSpawnPoint(Vector(-874.726, 2445.75, 888.031), QAngle(6.06971, -166.141, 0)),
		CSpawnPoint(Vector(-1333.62, 2572.56, 889.219), QAngle(0.152819, -46.4602, 0)),
		CSpawnPoint(Vector(-1064.04, 2798.74, 888.031), QAngle(3.92802, -98.6958, 0)),
		CSpawnPoint(Vector(-1364.2, 2826.03, 888.031), QAngle(-3.36834, 25.2454, 0)),
		CSpawnPoint(Vector(-1429.39, 2844.69, 1016.03), QAngle(31.4797, 2.04063, 0)),
		CSpawnPoint(Vector(-1447.24, 2536.8, 1016.03), QAngle(21.2431, -5.76728, 0)),
		CSpawnPoint(Vector(-1454.17, 2282.96, 1016.03), QAngle(16.3789, 9.79034, 0)),
		CSpawnPoint(Vector(-1457.03, 2090.28, 1016.03), QAngle(14.2372, 13.6417, 0)),
		CSpawnPoint(Vector(-1555.97, 1903.97, 1032.03), QAngle(1.78626, -67.1382, 0)),
		CSpawnPoint(Vector(-1438.48, 1749.83, 1032.03), QAngle(1.20546, 142.689, 0)),
		CSpawnPoint(Vector(-1455.36, 3366.35, 1016.03), QAngle(25.0183, -166.201, 0)),
		CSpawnPoint(Vector(-1911.84, 3378.52, 888.031), QAngle(4.76292, -85.3244, 0)),
		CSpawnPoint(Vector(-1768.99, 3181.35, 1056.03), QAngle(39.4658, -120.027, 0)),
		CSpawnPoint(Vector(-1704.81, 2997.82, 1060.03), QAngle(38.9938, 149.695, 0)),
		CSpawnPoint(Vector(-1894.15, 2626.04, 962.031), QAngle(27.7046, 117.388, 0)),
		CSpawnPoint(Vector(-2260.14, 2733.6, 824.031), QAngle(-1.77098, 30.7036, 0)),
		CSpawnPoint(Vector(-2018.59, 2731.32, 824.031), QAngle(-0.899785, 147.19, 0)),
		CSpawnPoint(Vector(-1938.82, 2272.89, 824.031), QAngle(3.1295, 157.935, 0)),
		CSpawnPoint(Vector(-2439.94, 3065.46, 888.031), QAngle(7.44919, -15.5427, 0)),
		CSpawnPoint(Vector(-2108.65, 3037.86, 888.031), QAngle(0.95149, 2.60732, 0)),
		CSpawnPoint(Vector(-2351.84, 3265.62, 888.031), QAngle(5.41639, -164.821, -0)),
		CSpawnPoint(Vector(-2982.41, 3242.14, 888.031), QAngle(1.496, -1.39828, 0))
	}
};

void OnMapInit()
{
	MaxRandomCash = 18;
	MinRandomCash = 12;

	MaxMoneyPerItem = 175.0f;
	MinMoneyPerItem = 45.0f;

	InsertToArray(-1558.54, 2029.38, 951.016);
	InsertToArray(-2339.93, 1094.39, 585.031);
	InsertToArray(-2340.81, 1604.4, 801.031);
	InsertToArray(-3656.48, 1667.89, 858.031);
	InsertToArray(-3112.07, 1503.72, 877.979);
	InsertToArray(-3231.59, 2187.62, 1119.29);
	InsertToArray(-3011.24, 3403.88, 925.031);
	InsertToArray(-2735.81, 2745.02, 889.031);
	InsertToArray(-2673.71, 3150.15, 912.031);
	InsertToArray(-1831.65, 3232.5, 1142.86);
	InsertToArray(-2065.09, 2265.87, 929.031);
	InsertToArray(-2037.45, 2484.9, 1121.03);
	InsertToArray(-2457.99, 1459.38, 1141.03);
	InsertToArray(-1807.19, 1493.12, 1261.03);
	InsertToArray(-1595.84, 2127.81, 1033.03);
	InsertToArray(-2429.9, 1419.61, 1065.03);
	InsertToArray(-826.005, 2118.5, 993.031);
	InsertToArray(-831.771, 2132.34, 993.031);
	InsertToArray(-1434.88, 3348.66, 1156.92);
	InsertToArray(-2417.47, 2938.16, 978.031);
	InsertToArray(-1727.91, 2732.16, 977.031);
	InsertToArray(-1816.53, 1435.91, 1261.03);
	InsertToArray(-1598.65, 2092.52, 1069.03);
	InsertToArray(-2748.19, 1583.44, 1105.03);
	InsertToArray(-2740.27, 1539.08, 1041.03);
	InsertToArray(-2902.64, 2674.69, 993.031);
	InsertToArray(-2843.02, 1925.71, 966.031);
	InsertToArray(-2840.93, 2953.43, 982.031);
	InsertToArray(-3361.3, 1543.73, 1039.29);
	InsertToArray(-1321.97, 2765.89, 1103.04);
	InsertToArray(-2007.39, 2081.14, 1069.03);
	InsertToArray(-1901.63, 2202.46, 1033.03);
	InsertToArray(-2118.82, 2194.15, 1124.03);
	InsertToArray(-2417.31, 1487.69, 1141.03);
	InsertToArray(-1830.02, 1413.11, 1033.03);

	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void SetUpStuff()
{
	int iRNDPitch = Math::RandomInt(65, 135);
	
	Engine.Ent_Fire("teleport_ambient", "Pitch", formatInt(iRNDPitch));
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitchstart " + formatInt(iRNDPitch));
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitch " + formatInt(iRNDPitch));
	
	Engine.Ent_Fire("teleport_ambient", "PlaySound");
	Engine.Ent_Fire("teleport_ambient", "Volume", "10");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	CreatedByColors();

	RemoveNativeSpawns("info_player_zombie");
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SL_HumanSpawns, true);
}

void OnMatchBegin() 
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SL_ZombieSpawns, false);
}

void CreatedByColors()
{
	float flFireTime = Math::RandomFloat(0.10f, 1.20f);
	
	Schedule::Task(flFireTime, "CreatedByColors");
	
	int iR = Math::RandomInt(32, 255);
	int iG = Math::RandomInt(32, 255);
	int iB = Math::RandomInt(32, 255);
	
	Engine.Ent_Fire("created_by", "color", ""+formatInt(iR)+" "+formatInt(iG)+" "+formatInt(iB));
}