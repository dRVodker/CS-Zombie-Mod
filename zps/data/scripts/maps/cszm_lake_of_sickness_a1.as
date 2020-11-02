#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iMaxPlayers;
float flWaitBeforeCollect = 0;

//------------------------------------------------------------------------
//Spawns SetUp
//------------------------------------------------------------------------

array<array<CSpawnPoint@>> PrimarySpawns =
{
	{
		CSpawnPoint(Vector(-939.246, 82.4492, -159.96), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1003.53, -6.06772, -159.96), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-977.687, -135.626, -156.757), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-876.31, -208.785, -153.535), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-799.806, -111.058, -159.45), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-822.244, -8.56953, -159.969), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-801.871, 70.0544, -159.969), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-729.083, -63.5339, -159.814), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-724.397, -215.073, -153.172), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1070.68, -198.609, -149.023), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1120.21, -95.9159, -159.73), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1108.82, 20.6364, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1109.22, 85.4009, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-702.232, 17.1355, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-559.257, 77.6257, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-513.015, -47.7739, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-566.524, -173.975, -153.728), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-654.145, -121.378, -159.196), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-633.67, 0.79066, -159.966), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-449.188, 38.6767, -159.966), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-406.699, -69.1795, -159.399), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-409.403, -194.431, -154.122), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-353.532, 38.3529, -159.953), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-249.355, -145.547, -156.83), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-173.351, 24.6575, -159.969), QAngle(0, -2.75542, 0))
	},
	{
		CSpawnPoint(Vector(-857.994, 487.579, -110.969), QAngle(1.19788, 90.2354, 0)),
		CSpawnPoint(Vector(-865.056, 756.825, -110.969), QAngle(0.653375, -87.8887, 0)),
		CSpawnPoint(Vector(-313.391, 795.06, -110.969), QAngle(0.145173, -87.4896, 0)),
		CSpawnPoint(Vector(-284.172, 540.803, -110.969), QAngle(-1.19792, 100.703, -0)),
		CSpawnPoint(Vector(-553.866, 575.304, -110.969), QAngle(30.492, 111.303, 0)),
		CSpawnPoint(Vector(-1079.49, -1447.98, -150.969), QAngle(18.9848, -147.965, 0)),
		CSpawnPoint(Vector(-887.405, -1688.99, -150.969), QAngle(3.66623, 139.313, 0)),
		CSpawnPoint(Vector(-302.151, -1637.24, -22.9688), QAngle(2.21422, 124.77, 0)),
		CSpawnPoint(Vector(-507.546, -1390.99, -22.9688), QAngle(4.10181, -15.3847, 0)),
		CSpawnPoint(Vector(-835.109, -1328.56, -22.9688), QAngle(30.9275, -123.909, 0)),
		CSpawnPoint(Vector(1279.51, -1382.68, -102.969), QAngle(3.12167, 150.592, 0)),
		CSpawnPoint(Vector(1467.6, -1174.97, -102.969), QAngle(15.5, 123.439, 0)),
		CSpawnPoint(Vector(1688.31, -1205.31, -102.969), QAngle(15.8267, 45.1764, 0)),
		CSpawnPoint(Vector(1757.38, -1475.13, -102.969), QAngle(16.3711, -146.573, 0)),
		CSpawnPoint(Vector(1407.3, -1567.76, -102.969), QAngle(5.59002, 47.4274, 0)),
		CSpawnPoint(Vector(1496.9, 444.6, -118.969), QAngle(13.213, -145.035, 0)),
		CSpawnPoint(Vector(1201.47, 447.179, -118.969), QAngle(9.83713, -40.2008, 0)),
		CSpawnPoint(Vector(1286.17, 895.957, -151.878), QAngle(-0.0727746, -81.2327, 0)),
		CSpawnPoint(Vector(1301.76, 712.652, 612.031), QAngle(20.1099, 154.73, 0)),
		CSpawnPoint(Vector(1153.03, 890.065, 612.031), QAngle(34.5937, -167.155, 0)),
		CSpawnPoint(Vector(-866.478, 321.969, 49.0313), QAngle(28.7856, 60.0964, 0)),
		CSpawnPoint(Vector(-629.439, -1563.21, -22.9687), QAngle(0.471637, 118.285, 0)),
		CSpawnPoint(Vector(1155.31, -1204.69, -146.969), QAngle(-7.29658, -29.4326, -0)),
		CSpawnPoint(Vector(1345.61, 438.867, -118.969), QAngle(10.3452, -128.858, 0)),
		CSpawnPoint(Vector(239.298, -166.818, -156.408), QAngle(14.665, -163.343, 0))
	},
	{
		CSpawnPoint(Vector(-907.622, 307.757, 49.0313), QAngle(7.11455, 43.6393, 0)),
		CSpawnPoint(Vector(-444.298, 355.996, 49.0313), QAngle(15.4998, 139.762, 0)),
		CSpawnPoint(Vector(-481.508, 820.018, 49.0313), QAngle(9.07474, -78.8368, 0)),
		CSpawnPoint(Vector(-25.1232, 980.693, -110.969), QAngle(2.94012, -159.241, 0)),
		CSpawnPoint(Vector(-30.3014, 338.42, -110.969), QAngle(2.50452, 163.152, 0)),
		CSpawnPoint(Vector(-380.226, -1632.66, -22.9688), QAngle(16.3348, -109.002, 0)),
		CSpawnPoint(Vector(-531.032, -1445.88, -22.9688), QAngle(5.44481, 161.047, 0)),
		CSpawnPoint(Vector(-340.827, -1375.13, -22.9688), QAngle(23.2681, 35.2672, 0)),
		CSpawnPoint(Vector(-1103.12, -1328.68, -22.9688), QAngle(6.09818, -53.1601, 0)),
		CSpawnPoint(Vector(-829.272, -1304.86, -22.9688), QAngle(5.51737, -117.919, 0)),
		CSpawnPoint(Vector(-946.012, -1666.76, -150.969), QAngle(-13.9031, 98.4776, 0)),
		CSpawnPoint(Vector(-914.344, 1001.47, -110.969), QAngle(-11.7251, -44.3265, 0)),
		CSpawnPoint(Vector(1451.28, -1083.91, -102.969), QAngle(1.37921, -70.1357, 0)),
		CSpawnPoint(Vector(1456.94, -1273.02, -102.969), QAngle(3.88391, 69.1473, 0)),
		CSpawnPoint(Vector(1634.26, -1267.29, -102.969), QAngle(3.412, 58.5115, 0)),
		CSpawnPoint(Vector(1701.17, -1087.95, -102.969), QAngle(7.40502, -49.953, 0)),
		CSpawnPoint(Vector(1701.08, -1485.36, -102.969), QAngle(-22.7966, -63.4201, 0)),
		CSpawnPoint(Vector(1480.28, -1486.99, -102.969), QAngle(28.459, -55.7971, 0)),
		CSpawnPoint(Vector(1167.55, 451.254, -118.969), QAngle(19.1299, 153.001, 0)),
		CSpawnPoint(Vector(1222.85, 386.622, -118.969), QAngle(2.64968, 9.23954, 0)),
		CSpawnPoint(Vector(1490.86, 462.507, -118.969), QAngle(12.9226, -146.415, 0)),
		CSpawnPoint(Vector(1317.94, 841.479, 612.031), QAngle(13.7574, -66.1063, 0)),
		CSpawnPoint(Vector(1402.71, 741.528, 612.031), QAngle(8.748, 171.635, 0)),
		CSpawnPoint(Vector(1454.58, 625.009, 612.031), QAngle(26.3535, -126.328, 0)),
		CSpawnPoint(Vector(1495.23, 123.7, -162.969), QAngle(5.04536, -126.401, 0))
	}
};

array<array<CSpawnPoint@>> SecondarySpawns =
{
	{
		CSpawnPoint(Vector(-842.699, -1300.48, -22.9687), QAngle(2.4608, -134.432, 0)),
		CSpawnPoint(Vector(-1104.2, -1362.13, -22.9687), QAngle(7.17979, -53.7735, 0)),
		CSpawnPoint(Vector(-1106.3, -1613.07, -22.9687), QAngle(8.9948, 25.2153, 0)),
		CSpawnPoint(Vector(-809.993, -1666.87, -22.9687), QAngle(6.41748, 108.778, 0)),
		CSpawnPoint(Vector(-861.227, -1355.28, -150.969), QAngle(-2.04042, -125.588, 0)),
		CSpawnPoint(Vector(-1092.33, -1666.85, -150.969), QAngle(-2.73013, 59.8455, 0)),
		CSpawnPoint(Vector(-365.452, -1627.07, -22.9688), QAngle(-0.552107, 102.679, 0)),
		CSpawnPoint(Vector(-465.774, -1350.99, -22.9688), QAngle(3.18679, -42.9562, 0)),
		CSpawnPoint(Vector(-677.351, -1466.36, -22.9688), QAngle(1.2266, -0.545199, 0)),
		CSpawnPoint(Vector(-1173.34, -1217.76, -22.9688), QAngle(6.2723, 57.3171, 0)),
		CSpawnPoint(Vector(-1647.61, -1730.1, -99.9063), QAngle(0.355378, 57.2386, 0)),
		CSpawnPoint(Vector(-1378.66, -1996.83, -109.957), QAngle(-1.49593, 43.0683, 0)),
		CSpawnPoint(Vector(-1631.13, -1998.01, -99.9688), QAngle(1.84367, 48.0243, 0)),
		CSpawnPoint(Vector(-1440.09, -971.96, -279.207), QAngle(-1.38707, 14.2572, 0)),
		CSpawnPoint(Vector(-1307.73, -716.664, -300.313), QAngle(-7.66697, 8.67521, 0)),
		CSpawnPoint(Vector(-662.315, -802.606, -308.216), QAngle(-12.5675, 29.0758, -0)),
		CSpawnPoint(Vector(-256.958, -719.115, -295.161), QAngle(-7.77587, 49.6455, 0)),
		CSpawnPoint(Vector(193.964, -734.111, -276.66), QAngle(-3.12947, 94.8549, 0)),
		CSpawnPoint(Vector(545.116, -458.299, -274.615), QAngle(-2.54866, 23.8068, -0)),
		CSpawnPoint(Vector(962.868, -228.18, -300.634), QAngle(5.87294, 52.2715, -0)),
		CSpawnPoint(Vector(1359.45, -370.212, -269.926), QAngle(-3.85545, 81.0688, 0)),
		CSpawnPoint(Vector(1634.2, -512.468, -282.817), QAngle(-10.2442, -45.1214, 0)),
		CSpawnPoint(Vector(1020.51, -525.897, -278.393), QAngle(-10.1717, -62.4983, 0)),
		CSpawnPoint(Vector(732.569, -879.118, -277.119), QAngle(-9.44566, -29.9431, 0)),
		CSpawnPoint(Vector(708.79, -1346.69, -275.27), QAngle(-17.2502, -170.756, -0)),
		CSpawnPoint(Vector(-410.21, -1347.52, -150.594), QAngle(1.77106, 71.0877, -0)),
		CSpawnPoint(Vector(-138.53, -1458.34, -157.97), QAngle(1.55325, 43.749, -0)),
		CSpawnPoint(Vector(13.3299, -1795.92, -157.223), QAngle(2.56964, 17.5815, -0)),
		CSpawnPoint(Vector(-410.378, -1800.87, -150.798), QAngle(5.58254, 50.1063, 0)),
		CSpawnPoint(Vector(306.465, -2010.07, -121.416), QAngle(5.18325, 74.4106, -0)),
		CSpawnPoint(Vector(759.466, -2051.35, -99.3755), QAngle(10.0838, 107.909, 0)),
		CSpawnPoint(Vector(1262.54, -1925.15, -157.74), QAngle(3.44085, 132.521, 0)),
		CSpawnPoint(Vector(1610.09, -1872.31, -159.969), QAngle(1.40805, 123.723, 0)),
		CSpawnPoint(Vector(1914.47, -1917.93, -159.969), QAngle(5.47365, 96.8017, 0)),
		CSpawnPoint(Vector(2102.21, -1745.25, -159.969), QAngle(-2.62125, 131.071, 0)),
		CSpawnPoint(Vector(2155.97, -1972.66, -159.969), QAngle(6.23595, 133.646, 0)),
		CSpawnPoint(Vector(2143.56, -1402.9, -159.969), QAngle(4.56615, 125.006, 0)),
		CSpawnPoint(Vector(1903.73, -1069.88, -102.969), QAngle(7.47015, 124.359, 0)),
		CSpawnPoint(Vector(1727.84, -1231.98, -102.969), QAngle(5.98186, 104.279, 0)),
		CSpawnPoint(Vector(1469.06, -1108.62, -102.969), QAngle(3.47716, -55.6952, 0)),
		CSpawnPoint(Vector(1691.61, -1517.25, -102.969), QAngle(4.421, 105.731, 0)),
		CSpawnPoint(Vector(1443.68, -1532.25, -102.969), QAngle(-0.697383, 77.0173, 0)),
		CSpawnPoint(Vector(1172.95, -1187.15, -146.969), QAngle(-2.33089, 132.265, 0)),
		CSpawnPoint(Vector(1192.25, -1420.56, -146.969), QAngle(6.3811, 118.362, 0)),
		CSpawnPoint(Vector(1349.78, -941.76, -102.969), QAngle(8.48648, 119.524, 0)),
		CSpawnPoint(Vector(2136.55, -635.469, -103.366), QAngle(16.1821, 170.078, 0)),
		CSpawnPoint(Vector(2048.02, -467.427, -98.063), QAngle(16.9807, 148.927, 0)),
		CSpawnPoint(Vector(2104.57, -104.656, -99.2086), QAngle(23.4784, -175.432, 0)),
		CSpawnPoint(Vector(2074.21, 111.813, -99.4217), QAngle(16.1458, 143.554, 0)),
		CSpawnPoint(Vector(1905.72, 401.799, -121.761), QAngle(6.59886, -167.332, 0)),
		CSpawnPoint(Vector(1476.74, -42.7961, -162.969), QAngle(2.27919, 143.99, 0)),
		CSpawnPoint(Vector(1871.6, 1555.27, -289.629), QAngle(-12.2772, -125.732, -0)),
		CSpawnPoint(Vector(1517.2, 1590.77, -277.152), QAngle(-12.132, -104.791, 0)),
		CSpawnPoint(Vector(1075.67, 1504.1, -285.621), QAngle(-13.3662, -78.6823, 0)),
		CSpawnPoint(Vector(722.236, 1214.48, -262.476), QAngle(-14.4552, -41.8423, -0)),
		CSpawnPoint(Vector(1043.27, 663.817, -160.206), QAngle(9.28502, 172.704, 0)),
		CSpawnPoint(Vector(1018.37, 952.786, -160.893), QAngle(11.8986, -173.68, 0)),
		CSpawnPoint(Vector(585.898, 920.963, -285.511), QAngle(-21.7152, -171.651, -0)),
		CSpawnPoint(Vector(512.97, 1098.12, -272.881), QAngle(-20.5536, -170.163, 0)),
		CSpawnPoint(Vector(-50.3738, 1207.14, -272.541), QAngle(5.07426, 39.7371, -0)),
		CSpawnPoint(Vector(-823.223, 1234.33, -275.634), QAngle(5.24996, 144.813, -0)),
		CSpawnPoint(Vector(-1362.76, 1577.86, -281.275), QAngle(-15.1811, -56.4705, 0)),
		CSpawnPoint(Vector(-1438.46, 1254.24, -300.31), QAngle(-12.1319, -62.1695, 0)),
		CSpawnPoint(Vector(-1380.76, 838.81, -297.279), QAngle(-15.5078, -50.4082, 0)),
		CSpawnPoint(Vector(-1636.61, 302.66, -159.958), QAngle(0.609388, 8.25719, 0)),
		CSpawnPoint(Vector(-1466.65, 141.418, -159.958), QAngle(4.42089, -7.13855, -0)),
		CSpawnPoint(Vector(-1562.24, -163.283, -159.228), QAngle(2.96888, -0.892831, 0)),
		CSpawnPoint(Vector(-1126.28, -128.407, -158.545), QAngle(10.8823, -10.8435, 0)),
		CSpawnPoint(Vector(-999.865, 70.045, -159.962), QAngle(8.77688, -31.476, -0)),
		CSpawnPoint(Vector(-740.343, -158.907, -155.616), QAngle(3.25929, 11.7039, 0)),
		CSpawnPoint(Vector(-547.567, 56.5961, -159.969), QAngle(6.70779, -28.5918, -0)),
		CSpawnPoint(Vector(-472.532, -172.851, -154.361), QAngle(7.72418, 156.856, -0)),
		CSpawnPoint(Vector(-315.169, 47.8279, -159.954), QAngle(6.96188, -179.975, 0)),
		CSpawnPoint(Vector(-218.448, -150.123, -155.852), QAngle(6.19958, 154.832, -0)),
		CSpawnPoint(Vector(-28.641, 42.9672, -159.969), QAngle(2.78738, 154.213, 0)),
		CSpawnPoint(Vector(12.8102, -204.804, -152.92), QAngle(5.87285, 126.954, 0)),
		CSpawnPoint(Vector(225.972, 191.948, -147.063), QAngle(17.0896, -2.89144, 0)),
		CSpawnPoint(Vector(203.974, -250.366, -155.672), QAngle(19.4854, -44.0556, 0)),
		CSpawnPoint(Vector(-57.8502, 1199.75, -110.969), QAngle(0.754552, -19.1176, 0)),
		CSpawnPoint(Vector(-318.702, 1191.26, -110.969), QAngle(4.34825, -124.077, 0)),
		CSpawnPoint(Vector(-791.682, 1177.66, -110.969), QAngle(12.6609, -86.8967, 0)),
		CSpawnPoint(Vector(-332.018, 920.516, -110.969), QAngle(8.12343, -100.102, 0)),
		CSpawnPoint(Vector(-877.091, 728.204, -110.969), QAngle(5.11052, -46.0491, 0)),
		CSpawnPoint(Vector(-238.091, 332.232, -110.969), QAngle(5.72761, 119.985, 0)),
		CSpawnPoint(Vector(-833.841, 939.841, 217.031), QAngle(-0.189255, -42.7288, 0)),
		CSpawnPoint(Vector(-153.764, 941.945, 217.031), QAngle(10.6644, -61.5082, -0)),
		CSpawnPoint(Vector(-100.106, 404.535, 217.031), QAngle(18.9409, -46.8492, 0)),
		CSpawnPoint(Vector(-803.448, 373.569, 217.031), QAngle(16.4362, -71.0284, 0)),
		CSpawnPoint(Vector(1191.49, 625.031, 612.031), QAngle(32.0088, -120.514, 0)),
		CSpawnPoint(Vector(1511.29, 651.642, 612.031), QAngle(32.8801, -110.241, 0)),
		CSpawnPoint(Vector(1514.48, 962.272, 612.031), QAngle(4.49342, -108.245, 0)),
		CSpawnPoint(Vector(1168.97, 969.43, 612.031), QAngle(3.87633, -101.203, 0))
	}
};

//------------------------------------------------------------------------
//NetData/Funcs
//------------------------------------------------------------------------

void CallMapPurchase(const string &in nFuncName, const int &in nPlrIndex, const int &in nCost, const int &in nWinIndex)
{
	NetData PurchaseData;
	PurchaseData.Write(nFuncName);
	PurchaseData.Write(nPlrIndex);
	PurchaseData.Write(nCost);
	PurchaseData.Write(nWinIndex);

	Network::CallFunction("MapPurchase", PurchaseData);
}

void BlockWindow(NetObject@ pData)
{
	if (pData is null)
	{
		return;
	}

	if (pData.HasIndexValue(0))
	{
		WindowBlocker::Array_Window[pData.GetInt(0)].CreateBlock();
	}
}

//------------------------------------------------------------------------
//FORWARDS
//------------------------------------------------------------------------

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();
	WindowBlocker::FillImputData();
	WindowBlocker::RegisterEnts();

	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
	flWaitBeforeCollect = Globals.GetCurrentTime() + 0.05f;
}

void OnMatchBegin()
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SecondarySpawns, false);
}

void OnProcessRound()
{
	WindowBlocker::Think();

	if (flWaitBeforeCollect <= Globals.GetCurrentTime() && flWaitBeforeCollect != 0)
	{
		flWaitBeforeCollect = 0;
		WindowBlocker::CollectWindows();
	}
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	WindowBlocker::OnFuncUsed(pPlayer, pEntity);
}

void SetUpStuff()
{
	PlayLobbyAmbient();
	CreateSpawnsFromArray(PrimarySpawns, true);
}

//------------------------------------------------------------------------
//Window Blocker Funcs
//------------------------------------------------------------------------

namespace WindowBlocker
{
	//------------------------------------------------------------------------
	//DATA
	//------------------------------------------------------------------------
	enum eWindowMaterialTypes {MAT_NONE, MAT_METAL, MAT_ROCK, MAT_WOOD}
	enum eWindowTypes {WT_OTHER, WT_BLOCK, WT_BARRICADE, WT_SHUTTER}
	enum eWindowConds {WC_WATING, WC_LISTEN, WC_EXIST}
	enum eWindowArgs {WA_INDEX, WA_TYPE, WA_MAT, WA_OFFSET}

	float WaitTime = 0.0f;
	float CostMultiplier = 1.0f;
	float ButtonDist = 145.0f;
	bool IsWindowsCollected = false;
	array<CEntityData@> gBlocksIPD;

	const array<string> WindMaterialTypes = 
	{
		"none",
		"metal",
		"rock",
		"wood"
	};
	const array<string> WindSetUpSND =
	{
		"Default.Null",
		"SolidMetal.ImpactHard",
		"Concrete_Block.ImpactHard",
		"Wood.ImpactHard"
	};
	const array<string> WindTypes = 
	{
		"other",
		"block",
		"barricade",
		"shutter"
	};
	const array<string> WindBeaconLabels = 
	{
		"Create block",
		"Lock it down",
		"Create barricade",
		"Create shutter"
	};

	CEntityData@ GetINputData(int &in iType)
	{
		if (iType < 0 || iType > int(gBlocksIPD.length()))
		{
			iType = 0;
		}

		CEntityData@ nIPD = gBlocksIPD[iType];

		return nIPD;
	}

	string GetBlockClassname(const int &in iType)
	{
		return (iType < WT_SHUTTER) ? "func_breakable" : "func_door";;
	}

	int GetBlockType(const string &in sType)
	{
		int iResult = WindTypes.find(sType);
		if (iResult == -1)
		{
			iResult = 0;
		}

		return iResult;
	}

	int GetMatType(const string &in sType)
	{
		int iResult = WindMaterialTypes.find(sType);
		if (iResult == -1)
		{
			iResult = 0;
		}

		return iResult;
	}

	bool IsIntersectPlayer(CBaseEntity@ pEntity)
	{
		bool IsIntersect = false;
		CBaseEntity@ pPlayerEntity = null;

		for (int i = 1; i <= iMaxPlayers; i++)
		{
			@pPlayerEntity = FindEntityByEntIndex(i);

			if (pPlayerEntity is null)
			{
				continue;
			}

			if (pEntity.Intersects(pPlayerEntity))
			{
				IsIntersect = true;
				break;
			}
		}

		return IsIntersect;
	}

	//------------------------------------------------------------------------
	//FUNCS
	//------------------------------------------------------------------------

	void RegisterEnts()
	{
		Entities::RegisterUse("func_button");
		Entities::RegisterUse("func_door");
		Entities::RegisterBreak("func_breakable");
		Engine.PrecacheFile(sound, "items/weaponappear/weaponappear.wav");
	}

	void CollectWindows()
	{
		CBaseEntity@ pEntity = null;
		int iLength = 0;
		if (!IsWindowsCollected)
		{
			IsWindowsCollected = true;
			array<Window@> PrepearWindows;
			while ((@pEntity = FindEntityByClassname(pEntity, "func_button")) !is null)
			{
				if (Utils.StrContains("button:", pEntity.GetEntityName()))
				{
					PrepearWindows.insertLast(Window(pEntity));
					pEntity.SUB_Remove();
				}
			}

			iLength = int(PrepearWindows.length());
			Array_Window.resize(iLength + 1);
			for (int i = 0; i < iLength; i++)
			{
				@Array_Window[PrepearWindows[i].Index] = PrepearWindows[i];
			}
		}
		else
		{
			while ((@pEntity = FindEntityByClassname(pEntity, "func_button")) !is null)
			{
				if (Utils.StrContains("button:", pEntity.GetEntityName()))
				{
					pEntity.SUB_Remove();
				}
			}

			iLength = int(Array_Window.length());
			for (int i = 1; i < iLength; i++)
			{
				Array_Window[i].Reset();
			}
		}
	}

	void Think()
	{
		if (WaitTime <= Globals.GetCurrentTime())
		{
			WaitTime = Globals.GetCurrentTime() + 0.25f;
			for (uint w = 1; w < Array_Window.length(); w++)
			{
				if (Array_Window[w] is null)
				{
					continue;
				}

				if (Array_Window[w].Condition == WC_EXIST || Array_Window[w].EntIndex > 0)
				{
					continue;
				}

				bool IsPlayerClose = false;
				for (int i = 1; i <= iMaxPlayers; i++)
				{
					CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

					if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() != 2)
					{
						continue;
					}

					if (pPlayerEntity.Distance(Array_Window[w].Origin) <= ButtonDist)
					{
						IsPlayerClose = true;
						break;
					}
				}

				if (IsPlayerClose)
				{
					Array_Window[w].CreateButton();
				}
				else
				{
					Array_Window[w].KillButton();
				}
			}
		}
	}

	void FillImputData()
	{
		gBlocksIPD.resize(4);
		for(int i = 0; i < 4; i++)
		{
			@gBlocksIPD[i] = EntityCreator::EntityData();
		}

		gBlocksIPD[0].Add("material", "2");
		gBlocksIPD[0].Add("health", "0");
		gBlocksIPD[0].Add("spawnflags", "3073");
		@gBlocksIPD[1] = gBlocksIPD[0];

		gBlocksIPD[2].Add("targetname", "barricade_window");
		gBlocksIPD[2].Add("material", "1");
		gBlocksIPD[2].Add("spawnflags", "0");
		gBlocksIPD[2].Add("health", "750");

		gBlocksIPD[3].Add("spawnflags", "288"); //2304
		gBlocksIPD[3].Add("health", "0");
		gBlocksIPD[3].Add("lip", "0.35");
		gBlocksIPD[3].Add("movedir", "90 0 0");
		gBlocksIPD[3].Add("forceclosed", "1");
		gBlocksIPD[3].Add("dmg", "1");
		gBlocksIPD[3].Add("startclosesound", "doors/door_metal_thin_move1.wav");
		gBlocksIPD[3].Add("closesound", "doors/door_metal_thin_close2.wav");
		gBlocksIPD[3].Add("noise1", "doors/door_metal_thin_move1.wav");
		gBlocksIPD[3].Add("noise2", "doors/door_metal_thin_close2.wav");
		gBlocksIPD[3].Add("locked_sound", "npc/combine_soldier/vo/_comma.wav");
		gBlocksIPD[3].Add("spawnpos", "1");
		gBlocksIPD[3].Add("rendermode", "2");
		gBlocksIPD[3].Add("renderamt", "0");
		gBlocksIPD[3].Add("alpha", "255", true, "0.01");
		gBlocksIPD[3].Add("close", "0", true, "0.01");
		gBlocksIPD[3].Add("lock", "0", true, "0.02");
	}

	void OnFuncUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
	{
		CBasePlayer@ pPlayerBase = pPlayer.opCast();
		CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

		if (Utils.StrEql("func_button", pEntity.GetClassname(), true) && Utils.StrEql("button_window", pEntity.GetEntityName(), true))
		{
			int WindowIndex = pEntity.GetHealth();
			if (Array_Window[WindowIndex] !is null)
			{
				if (IsIntersectPlayer(pEntity))
				{
					Engine.EmitSoundPlayer(pPlayer, "buttons/combine_button_locked.wav");
					Chat.PrintToChatPlayer(pPlayerBase, "{red}*{gold}Кто-то мешает закрыть проход!");
				}
				else
				{
					CallMapPurchase("BlockWindow", pPlayerEntity.entindex(), Array_Window[WindowIndex].Cost, WindowIndex);
				}
			}
		}
		else if (Utils.StrEql("func_door", pEntity.GetClassname(), true) && pPlayerEntity.GetTeamNumber() == 2)
		{
			Engine.Ent_Fire_Ent(pEntity, "unlock", "", "0.00");
			Engine.Ent_Fire_Ent(pEntity, "toggle", "", "0.01");
			Engine.Ent_Fire_Ent(pEntity, "lock", "", "0.02");
		}
	}

	//------------------------------------------------------------------------
	//Window Stuff
	//------------------------------------------------------------------------

	array<Window@> Array_Window;

	class Window
	{
		int EntIndex;
		int Index;
		int Type;
		int MaterialType;
		int Cost;
		int Condition;
		string Model;
		Vector Origin;
		float OriginOffset;

		int ButtonIndex;
		int BeaconIndex;

		Window(CBaseEntity@ pWindowEntity)
		{
			CASCommand@ pSplited = StringToArgSplit(pWindowEntity.GetEntityName(), ":"); 
			@pSplited = StringToArgSplit(pSplited.Arg(1), ";");
			EntIndex = -1;
			ButtonIndex = -1;
			BeaconIndex = -1;

			Index = Utils.StringToInt(pSplited.Arg(WA_INDEX));
			Type = GetBlockType(pSplited.Arg(WA_TYPE));
			MaterialType = GetMatType(pSplited.Arg(WA_MAT));
			OriginOffset = Utils.StringToFloat(pSplited.Arg(WA_OFFSET));
			Cost = int(ceil(pWindowEntity.GetHealth() * CostMultiplier));
			Model = pWindowEntity.GetModelName();
			Origin = pWindowEntity.GetAbsOrigin();

			Condition = WC_WATING;
		}

		void Reset()
		{
			EntIndex = -1;
			ButtonIndex = -1;
			BeaconIndex = -1;
			Condition = WC_WATING;
		}

		void CreateBlock()
		{
			if (Condition == WC_LISTEN)
			{
				Condition = WC_EXIST;
				CEntityData@ InputData = GetINputData(Type);
				InputData.Add("origin", "" + Origin.x + " " + Origin.y + " " + Origin.z);
				InputData.Add("model", Model);

				CBaseEntity@ pBlock = EntityCreator::Create(GetBlockClassname(Type), Origin, QAngle(0, 0, 0), InputData);
				EntIndex = pBlock.entindex();
				pBlock.SetEntityDescription(formatInt(Type));

				if (MaterialType > MAT_NONE)
				{
					Engine.EmitSoundEntity(FindEntityByEntIndex(ButtonIndex), WindSetUpSND[MaterialType]);
				}

				if (Type == WT_SHUTTER)
				{
					Engine.Ent_Fire_Ent(pBlock, "addoutput", "origin " + Origin.x + " " + Origin.y + " " + (Origin.z - OriginOffset));
				}

				Engine.EmitSoundPosition(ButtonIndex, "items/weaponappear/weaponappear.wav", Origin, 1, 65, 95);
				RemoveButton();
			}
		}

		void CreateButton()
		{
			if (Condition == WC_WATING)
			{
				Condition = WC_LISTEN;
				CEntityData@ InputData = EntityCreator::EntityData();
				InputData.Add("targetname", "button_window");
				InputData.Add("filterteam", "2");
				InputData.Add("nonsolid", "1");
				InputData.Add("renderamt", "0");
				InputData.Add("rendermode", "10");
				InputData.Add("spawnflags", "1057");
				InputData.Add("origin", "" + Origin.x + " " + Origin.y + " " + Origin.z);

				CBaseEntity@ pButton = EntityCreator::Create("func_button", Origin, QAngle(0, 0, 0), InputData);
				pButton.SetHealth(Index);
				ButtonIndex = pButton.entindex();

				@InputData = EntityCreator::EntityData();
				InputData.Add("customicons", "1");
				InputData.Add("displayteam", "2");
				InputData.Add("distance", "" + ButtonDist);
				InputData.Add("startactive", "1");
				InputData.Add("human_icon", "vgui/images/emptyimage");
				InputData.Add("zombie_icon", "vgui/images/emptyimage");
				InputData.Add("survivorlabel", "| " + WindBeaconLabels[Type] + " - " + formatInt(Cost) + "$ |");

				CBaseEntity@ pBeacon = EntityCreator::Create("info_beacon", Origin - Vector(0, 0, 16), QAngle(0, 0, 0), InputData);
				BeaconIndex = pBeacon.entindex();
			}
		}

		void KillButton()
		{
			if (Condition == WC_LISTEN)
			{
				Condition = WC_WATING;
				RemoveButton();
			}
		}

		private void RemoveButton()
		{
			CBaseEntity@ pButton = FindEntityByEntIndex(ButtonIndex);
			CBaseEntity@ pBeacon = FindEntityByEntIndex(BeaconIndex);

			if (pButton !is null)
			{
				ButtonIndex = -1;
				pButton.SUB_Remove();
			}

			if (pBeacon !is null)
			{
				BeaconIndex = -1;
				pBeacon.SUB_Remove();
			}
		}
	}
}

//------------------------------------------------------------------------
//END
//------------------------------------------------------------------------