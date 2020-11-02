#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"
#include "cszm_modules/cashmaker"

const int TEAM_LOBBYGUYS = 0;

array<array<CSpawnPoint@>> New_Spawns =
{
	{
		CSpawnPoint(Vector(-63.7509, -499.856, -1204.59), QAngle(0, -100.951, 0), "info_player_start"),
		CSpawnPoint(Vector(-634.318, -582.359, -1209.07), QAngle(-20.9088, -3.40019, 0)),
		CSpawnPoint(Vector(-488.526, -571.896, -1207.01), QAngle(-26.3538, 16.7826, 0)),
		CSpawnPoint(Vector(-463.759, -683.306, -1211.15), QAngle(-27.1524, 32.2827, 0)),
		CSpawnPoint(Vector(-598.012, -732.933, -1209.98), QAngle(-21.8163, 31.3752, 0)),
		CSpawnPoint(Vector(-539.72, -868.141, -1206.5), QAngle(-20.2917, 42.4467, 0)),
		CSpawnPoint(Vector(-407.24, -810.729, -1212.11), QAngle(-24.7929, 51.4853, 0)),
		CSpawnPoint(Vector(-383.26, -978.165, -1202.52), QAngle(-19.7835, 60.8282, 0)),
		CSpawnPoint(Vector(-307.298, -873.234, -1207.19), QAngle(-25.4463, 62.0123, 0)),
		CSpawnPoint(Vector(-231.956, -1030.55, -1200.99), QAngle(-19.7109, 73.2654, 0)),
		CSpawnPoint(Vector(-226.459, -904.665, -1203.08), QAngle(-24.0669, 74.79, 0)),
		CSpawnPoint(Vector(-105.126, -1079.03, -1205), QAngle(-18.5857, 85.3532, 0)),
		CSpawnPoint(Vector(-93.6622, -937.313, -1210.57), QAngle(-24.5026, 85.9703, 0)),
		CSpawnPoint(Vector(53.2766, -1029.04, -1204.5), QAngle(-22.3246, 97.9736, 0)),
		CSpawnPoint(Vector(34.524, -905.432, -1209.37), QAngle(-26.1724, 98.1165, -0)),
		CSpawnPoint(Vector(239.296, -919.118, -1200.87), QAngle(-22.8328, 115.627, 0)),
		CSpawnPoint(Vector(154.522, -788.349, -1206.75), QAngle(-30.5647, 114.683, 0)),
		CSpawnPoint(Vector(348.231, -808.568, -1209.72), QAngle(-23.8855, 133.122, -0)),
		CSpawnPoint(Vector(288.83, -708.328, -1214.93), QAngle(-30.6373, 136.028, 0)),
		CSpawnPoint(Vector(438.321, -665.496, -1212.24), QAngle(-24.2485, 151.129, 0)),
		CSpawnPoint(Vector(355.792, -612.196, -1213.03), QAngle(-30.7099, 151.964, 0)),
		CSpawnPoint(Vector(169.902, -994.504, -1203.29), QAngle(-21.4171, 109.275, 0)),
		CSpawnPoint(Vector(492.513, -566.061, -1211.55), QAngle(-24.1759, 164.524, 0)),
		CSpawnPoint(Vector(381.23, -535.431, -1212.46), QAngle(-31.0003, 166.52, 0)),
		CSpawnPoint(Vector(-46.4367, -791.824, -1195.36), QAngle(-30.601, 91.7788, 0))
	},
	{
		CSpawnPoint(Vector(-63.7509, -499.856, -1204.59), QAngle(0, -100.951, 0), "info_player_start"),
		CSpawnPoint(Vector(-601.759, -624.299, -1208.68), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-442.572, -624.299, -1204.18), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-255.372, -624.299, -1195.18), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-85.6767, -624.299, -1195.89), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(103.114, -642.366, -1195.26), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(293.5, -642.366, -1207.16), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(463.868, -642.366, -1212.75), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(384.43, -786.427, -1210.17), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(220.444, -786.427, -1212.61), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(26.0437, -786.427, -1187.45), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-165.956, -786.427, -1194.5), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-338.756, -786.427, -1203.97), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-529.423, -751.608, -1209.24), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-628.33, -917.156, -1209.11), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-459.693, -917.156, -1204.46), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-264.533, -917.156, -1209.15), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-80.7291, -917.156, -1210.15), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(109.801, -917.156, -1201.79), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(303.828, -917.156, -1209.52), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(428.282, -964.153, -1215.62), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(203.963, -1026.78, -1208.54), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(16.9387, -1029.74, -1204.17), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-160.896, -1029.74, -1202.02), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-365.13, -1029.74, -1204.37), QAngle(0, 90, 0))
	},
	{
		CSpawnPoint(Vector(-63.7509, -499.856, -1204.59), QAngle(0, -100.951, 0), "info_player_start"),
		CSpawnPoint(Vector(-578.631, 669.873, -1215.97), QAngle(0, -89.1727, 0)),
		CSpawnPoint(Vector(-580.794, 819.211, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-583.434, 1001.44, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-585.495, 1143.64, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-482.231, 1145.13, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-458.476, 972.424, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-357.865, 1094.09, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-195.715, 1124.99, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-37.1667, 1096.62, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(114.497, 1107.34, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(273.375, 1130.72, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(271.276, 1275.69, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(397.338, 1277.52, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(401.971, 1130.78, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(570.187, 1133.22, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(505.585, 1273.8, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(561.506, 1009.33, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(676.514, 1010.99, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(679.401, 811.583, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(575.978, 810.086, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(631.473, 908.468, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(479.785, 1197.36, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(341.435, 1203.68, -1215.97), QAngle(0, -89.1705, 0)),
		CSpawnPoint(Vector(-530.64, 1084.49, -1215.97), QAngle(0, -89.1705, 0))
	},
	{
		CSpawnPoint(Vector(-63.7509, -499.856, -1204.59), QAngle(0, -100.951, 0), "info_player_start"),
		CSpawnPoint(Vector(-652.672, 1488.52, -1215.97), QAngle(0, -49.4893, 0)),
		CSpawnPoint(Vector(-435.923, 1480.85, -1215.97), QAngle(29.7296, -130.761, 0)),
		CSpawnPoint(Vector(-457.841, 973.696, -1215.97), QAngle(24.2846, -11.7691, 0)),
		CSpawnPoint(Vector(-244.515, 1104.63, -1215.97), QAngle(30.02, -105.278, 0)),
		CSpawnPoint(Vector(111.456, 1043.98, -1215.97), QAngle(7.55035, 130.563, 0)),
		CSpawnPoint(Vector(-137.302, 1079.83, -1215.97), QAngle(11.7612, 35.8926, 0)),
		CSpawnPoint(Vector(-4.64388, 1178.23, -1215.97), QAngle(-26.0998, -95.7675, 0)),
		CSpawnPoint(Vector(473.331, 1250.19, -1215.97), QAngle(8.92976, 131.071, 0)),
		CSpawnPoint(Vector(491.735, 1456.07, -1215.97), QAngle(10.527, -156.619, 0)),
		CSpawnPoint(Vector(711.682, 1684.42, -1135.97), QAngle(1.74237, -133.836, 0)),
		CSpawnPoint(Vector(643.786, 950.334, -1215.97), QAngle(0.18146, 151.568, 0)),
		CSpawnPoint(Vector(717.867, 997.599, -1089.09), QAngle(15.1734, 178.103, 0)),
		CSpawnPoint(Vector(526.204, 712.866, -1215.97), QAngle(12.4146, 141.331, 0)),
		CSpawnPoint(Vector(464.268, 390.394, -1215.97), QAngle(30.7824, 90.6687, 0)),
		CSpawnPoint(Vector(555.183, 131.263, -1215.97), QAngle(1.23422, -56.9273, 0)),
		CSpawnPoint(Vector(680.429, -57.6401, -1215.97), QAngle(-0.471886, 121.101, 0)),
		CSpawnPoint(Vector(668.195, 369.892, -1215.97), QAngle(1.59721, 102.515, 0)),
		CSpawnPoint(Vector(195.606, -64.1604, -1215.97), QAngle(1.81504, 36.8353, -0)),
		CSpawnPoint(Vector(107.701, 122.626, -1215.97), QAngle(45.2662, 150.636, 0)),
		CSpawnPoint(Vector(89.8318, 273.425, -1215.97), QAngle(-14.8829, 137.822, -0)),
		CSpawnPoint(Vector(197.886, 603.954, -1215.97), QAngle(3.41227, -101.916, 0)),
		CSpawnPoint(Vector(-639.056, 313.556, -1215.97), QAngle(2.43217, 39.7992, 0)),
		CSpawnPoint(Vector(-168.872, 325.382, -1211.54), QAngle(2.35957, 124.015, 0)),
		CSpawnPoint(Vector(-422.729, 1012.54, -1325.99), QAngle(1.70618, -39.2624, 0)),
		CSpawnPoint(Vector(474.909, 1010.49, -1319.84), QAngle(1.63358, -131.537, 0))
	},
	{
		CSpawnPoint(Vector(-63.7509, -499.856, -1204.59), QAngle(0, -100.951, 0), "info_player_start"),
		CSpawnPoint(Vector(-428.224, 1970.68, -1215.97), QAngle(11.1441, -28.8785, 0)),
		CSpawnPoint(Vector(-410.124, 1843.61, -1215.97), QAngle(4.5738, 15.4075, 0)),
		CSpawnPoint(Vector(373.3, 1909.77, -1135.97), QAngle(9.9462, -178.749, 0)),
		CSpawnPoint(Vector(529.498, 1682.6, -1135.97), QAngle(3.5211, -77.3631, 0)),
		CSpawnPoint(Vector(646.421, 1475.07, -1135.97), QAngle(0, 141.171, 0)),
		CSpawnPoint(Vector(298.842, 1222.21, -1215.97), QAngle(5.73538, 23.1809, 0)),
		CSpawnPoint(Vector(434.938, 1395.52, -1215.97), QAngle(6.49766, -97.5891, 0)),
		CSpawnPoint(Vector(-452.566, 1246.15, -1215.97), QAngle(2.10536, -140.242, 0)),
		CSpawnPoint(Vector(-646.762, 1045.14, -1215.97), QAngle(29.2578, -25.6426, 0)),
		CSpawnPoint(Vector(-595.077, 345.929, -1215.97), QAngle(2.17795, 58.537, 0)),
		CSpawnPoint(Vector(-541.955, -104.309, -1215.97), QAngle(15.5001, -32.7212, 0)),
		CSpawnPoint(Vector(-626.675, -723.243, -1209.79), QAngle(-20.5822, 15.2311, 0)),
		CSpawnPoint(Vector(-109.983, -1092.4, -1207.08), QAngle(-19.4933, 83.947, 0)),
		CSpawnPoint(Vector(393.011, -1017.64, -1214.82), QAngle(-18.9125, 120.646, 0)),
		CSpawnPoint(Vector(491.617, -709.228, -1213.54), QAngle(-22.4336, 148.162, 0)),
		CSpawnPoint(Vector(202.09, -467.976, -1205.17), QAngle(-4.06577, -110.561, 0)),
		CSpawnPoint(Vector(-74.2775, -470.081, -1206.34), QAngle(-6.67936, -111.82, 0)),
		CSpawnPoint(Vector(-305.073, -468.224, -1205.91), QAngle(3.41205, -108.081, 0)),
		CSpawnPoint(Vector(649.771, 46.1191, -1215.97), QAngle(0.290261, 101.094, 0)),
		CSpawnPoint(Vector(-193.188, 31.6418, -954.969), QAngle(29.9474, -7.74666, 0)),
		CSpawnPoint(Vector(-621.659, -318.153, -1215.97), QAngle(0.54099, 44.4192, 0)),
		CSpawnPoint(Vector(-620.457, 130.406, -1215.97), QAngle(0.0363, -58.6364, 0)),
		CSpawnPoint(Vector(-638.98, 1564.19, -1215.97), QAngle(0.907505, 33.2051, 0)),
		CSpawnPoint(Vector(-186.096, 1702.22, -1215.97), QAngle(2.86771, -166.844, 0)),
		CSpawnPoint(Vector(253.674, 433.838, -1215.97), QAngle(-0.472013, -135.862, 0))
	}
};

array<array<CSpawnPoint@>> New_ZombieSpawns =
{
	{
		CSpawnPoint(Vector(-579.069, -673.992, -1209.18), QAngle(2.1741, 85.2942, -0)),
		CSpawnPoint(Vector(-372.764, -862.873, -1212.14), QAngle(-20.0778, 70.9194, 0)),
		CSpawnPoint(Vector(-102.738, -922.14, -1209.32), QAngle(-22.5099, 92.0096, 0)),
		CSpawnPoint(Vector(147.031, -848.002, -1210.77), QAngle(-25.5591, 116.149, 0)),
		CSpawnPoint(Vector(363.268, -686.285, -1211.53), QAngle(-27.12, 150.816, 0)),
		CSpawnPoint(Vector(-145.303, -596.93, -1195.87), QAngle(5.73146, -148.817, 0)),
		CSpawnPoint(Vector(92.9236, -589.323, -1195.82), QAngle(7.18346, -66.6342, 0)),
		CSpawnPoint(Vector(399.532, -1002.07, -1215), QAngle(-1.34703, 123.817, 0)),
		CSpawnPoint(Vector(-82.8461, -1128.4, -1209.09), QAngle(-3.48873, 76.5458, 0)),
		CSpawnPoint(Vector(-526.095, -1015.37, -1210.05), QAngle(2.13778, 43.3676, 0)),
		CSpawnPoint(Vector(518.891, -351.477, -1215.97), QAngle(0.104993, 115.496, 0)),
		CSpawnPoint(Vector(660.009, -69.4061, -1215.97), QAngle(-3.41611, 97.3458, 0)),
		CSpawnPoint(Vector(423.882, -186.405, -1215.97), QAngle(8.88959, -78.7583, 0)),
		CSpawnPoint(Vector(197.089, -77.3976, -1215.97), QAngle(-0.475812, 32.6958, 0)),
		CSpawnPoint(Vector(443.663, 65.4715, -1089.95), QAngle(48.1661, -128.344, 0)),
		CSpawnPoint(Vector(547.877, 109.694, -1089.95), QAngle(52.4858, 33.8808, 0)),
		CSpawnPoint(Vector(524.884, 64.8026, -1215.97), QAngle(2.71847, -23.7508, 0)),
		CSpawnPoint(Vector(668.715, 588.518, -1215.97), QAngle(2.42806, 117.01, 0)),
		CSpawnPoint(Vector(453.066, 436.651, -1215.97), QAngle(34.0817, 89.9778, -0)),
		CSpawnPoint(Vector(130.232, 128.796, -1215.97), QAngle(8.67173, 22.0363, 0)),
		CSpawnPoint(Vector(38.9059, 227.429, -1215.97), QAngle(4.20683, 43.78, 0)),
		CSpawnPoint(Vector(216.866, 415.448, -1215.97), QAngle(8.78063, -141.762, 0)),
		CSpawnPoint(Vector(2.02832, 547.01, -1215.97), QAngle(8.85322, 173.625, 0)),
		CSpawnPoint(Vector(240.541, 600.915, -1215.97), QAngle(2.17403, -148.732, 0)),
		CSpawnPoint(Vector(-194.215, 37.2016, -954.969), QAngle(34.4084, -13.9499, 0)),
		CSpawnPoint(Vector(-361.823, -319.907, -951.969), QAngle(-1.12935, 30.7353, 0)),
		CSpawnPoint(Vector(-315.021, -143.026, -959.969), QAngle(-1.52865, -25.6023, 0)),
		CSpawnPoint(Vector(-77.7873, -143.456, -951.969), QAngle(11.1764, -150.874, 0)),
		CSpawnPoint(Vector(-140.22, -423.416, -959.969), QAngle(40.9061, -68.8354, 0)),
		CSpawnPoint(Vector(38.3047, -412.212, -959.969), QAngle(42.1402, -122.523, 0)),
		CSpawnPoint(Vector(-501.86, -336.23, -1215.96), QAngle(-2.29104, 102.332, 0)),
		CSpawnPoint(Vector(-613.179, 133.718, -1215.97), QAngle(5.11414, -77.8613, 0)),
		CSpawnPoint(Vector(-162.378, 322.829, -1211.35), QAngle(17.928, 130.61, 0)),
		CSpawnPoint(Vector(-628.772, 334.849, -1215.97), QAngle(20.1061, 46.6113, 0)),
		CSpawnPoint(Vector(-423.549, 1008.74, -1325.86), QAngle(10.6317, -41.888, 0)),
		CSpawnPoint(Vector(-173.346, 757.281, -1329.06), QAngle(12.9912, 110.318, 0)),
		CSpawnPoint(Vector(25.9322, 999.901, -1321.71), QAngle(14.9877, -75.4292, 0)),
		CSpawnPoint(Vector(74.2632, 726.458, -1330.55), QAngle(13.6809, 85.9606, 0)),
		CSpawnPoint(Vector(486.193, 1013.06, -1320.03), QAngle(14.9514, -135.391, -0)),
		CSpawnPoint(Vector(402.109, 730.108, -1343.58), QAngle(8.81675, 116.03, 0)),
		CSpawnPoint(Vector(-643.302, 848.531, -1204.37), QAngle(12.0475, -13.3792, 0)),
		CSpawnPoint(Vector(-457.977, 1173.47, -1215.97), QAngle(6.96545, -140.853, 0)),
		CSpawnPoint(Vector(-654.66, 1484.05, -1215.97), QAngle(7.50995, -55.1967, 0)),
		CSpawnPoint(Vector(-454.154, 1446.14, -1215.97), QAngle(11.3577, -123.114, -0)),
		CSpawnPoint(Vector(-630.82, 1764.01, -1175.89), QAngle(17.0569, -43.3994, 0)),
		CSpawnPoint(Vector(-623.091, 1569.21, -1215.97), QAngle(13.1364, 28.7651, 0)),
		CSpawnPoint(Vector(-415.449, 1836.76, -1215.97), QAngle(11.6118, 19.4723, 0)),
		CSpawnPoint(Vector(-420.084, 1962.08, -1215.97), QAngle(14.3343, -33.562, 0)),
		CSpawnPoint(Vector(50.8621, 1927.67, -1187.53), QAngle(17.0931, -156.692, 0)),
		CSpawnPoint(Vector(428.697, 1996.53, -1135.97), QAngle(19.38, -124.094, 0)),
		CSpawnPoint(Vector(305.111, 2011.6, -1135.97), QAngle(25.7325, -59.916, 0)),
		CSpawnPoint(Vector(711.068, 1677.78, -1135.97), QAngle(8.01808, -132.298, 0)),
		CSpawnPoint(Vector(726.969, 1413.97, -1133.98), QAngle(6.02155, -154.369, 0)),
		CSpawnPoint(Vector(687.542, 1393.07, -1020.48), QAngle(-0.802814, -134.185, 0)),
		CSpawnPoint(Vector(549.969, 1359.22, -1013.77), QAngle(5.6586, -128.849, 0)),
		CSpawnPoint(Vector(738.461, 956.009, -1087.97), QAngle(20.5052, 158.152, 0)),
		CSpawnPoint(Vector(664.545, 1222.92, -1195.36), QAngle(11.4665, -131.062, 0)),
		CSpawnPoint(Vector(394.033, 1157.1, -1215.97), QAngle(10.668, -113.203, -0)),
		CSpawnPoint(Vector(74.5957, 1101.78, -1215.97), QAngle(-1.92813, -77.4109, 0)),
		CSpawnPoint(Vector(-278.225, 1137.68, -1215.97), QAngle(-2.10961, -65.0325, 0)),
		CSpawnPoint(Vector(-321.258, 300.557, -951.969), QAngle(24.6072, 104.416, 0)),
		CSpawnPoint(Vector(-165.796, 308.969, -951.969), QAngle(14.8789, 137.957, 0)),
		CSpawnPoint(Vector(-149.445, 466.161, -951.969), QAngle(27.0031, 157.56, 0)),
		CSpawnPoint(Vector(-123.175, 682.781, -943.969), QAngle(13.6083, -40.2029, 0)),
		CSpawnPoint(Vector(101.353, 702.122, -1215.97), QAngle(39.5267, 107.575, 0)),
		CSpawnPoint(Vector(-658.894, 1487.58, -989.254), QAngle(4.60613, -54.9042, 0)),
		CSpawnPoint(Vector(-437.815, 1490.59, -993.769), QAngle(16.9119, -128.92, 0)),
		CSpawnPoint(Vector(-609.09, 1200.72, -930.337), QAngle(31.7585, -67.7631, 0)),
		CSpawnPoint(Vector(-317.514, 1188.75, -930.537), QAngle(31.7949, -53.4156, 0)),
		CSpawnPoint(Vector(-647.839, 892.949, -926.25), QAngle(29.7984, 2.59533, 0)),
		CSpawnPoint(Vector(-647.51, 614.618, -926.25), QAngle(17.7831, 4.74917, 0))
	}
};

int iMaxPlayers;

array<float> g_TeleportDelay;

array<QAngle> g_TPAngles =
{
	QAngle(0, 135, 0),
	QAngle(0, 315, 0)
};

array<Vector> g_TPOrigins = 
{
	Vector(727, 289, -704),
	Vector(-356, 1509, -943)
};

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	Schedule::Task(0.05f, "SetUpStuff");

	Entities::RegisterUse("teleport_door");

	Engine.PrecacheFile(sound, "doors/default_stop.wav");
	Engine.PrecacheFile(sound, "doors/default_move.wav");

	g_TeleportDelay.resize(iMaxPlayers + 1);

	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);

	CashDATA();
	Schedule::Task(0.05f, "SetUpStuff");
}

void CashDATA()
{
	MaxRandomCash = 15;
	MinRandomCash = 8;

	MaxMoneyPerItem = 75.0f;
	MinMoneyPerItem = 15.0f;

	InsertToArray(11.4171f, 398.509f, -1042.97f, 950);
	InsertToArray(-80.0718f, 1364.34f, -902.663f, 500);

	InsertToArray(81.3646f, 142.244f, -1185.17f);
	InsertToArray(29.2226f, -142.162f, -920.0f);
	InsertToArray(63.2106f, -383.62f, -958.969f);
	InsertToArray(488.398f, -943.83f, -1214.15f);
	InsertToArray(-28.4988f, -536.835f, -1203.07f);
	InsertToArray(-571.954f, 19.2776f, -1214.97f);
	InsertToArray(-453.723f, 281.249f, -1288.62f);
	InsertToArray(-26.7921f, 604.304f, -902.874f);
	InsertToArray(-322.352f, 1232.76f, -942.969f);
	InsertToArray(765.505f, 932.906f, -1086.97f);
	InsertToArray(662.912f, 1347.79f, -1103.91f);
	InsertToArray(654.366f, 1333.53f, -1103.9f);
	InsertToArray(204.444f, 1703.7f, -1134.97f);
	InsertToArray(-202.786f, 1970.0f, -1174.7f);
	InsertToArray(-87.8858f, 1731.11f, -1213.95f);
	InsertToArray(-327.051f, 1721.28f, -1025.73f);
	InsertToArray(497.008f, 347.183f, -1214.97f);
	InsertToArray(284.921f, 516.682f, -1125.15f);
	InsertToArray(192.564f, 657.321f, -1058.97f);
	InsertToArray(65.7012f, 706.822f, -1214.97f);
	InsertToArray(86.6535f, 690.58f, -1214.97f);
	InsertToArray(185.323f, 1043.45f, -1324.72f);
	InsertToArray(709.422f, 1270.38f, -1181.07f);
	InsertToArray(674.613f, 1282.41f, -1188.03f);
}

void OnNewRound()
{
	Engine.Ent_Fire("SND_Ambient", "StopSound");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(New_ZombieSpawns, false);
}

void SetUpStuff()
{
	Schedule::Task(Math::RandomFloat(4.32f, 35.14f), "SND_Ambient_Rats");
	Schedule::Task(Math::RandomFloat(12.85f, 175.35f), "SND_Ambient_Groan2");
	Schedule::Task(Math::RandomFloat(35.24f, 225.25f), "SND_Ambient_Thunder");
	Schedule::Task(Math::RandomFloat(45.75f, 250.00f), "SND_Ambient_Groan1");
	Schedule::Task(Math::RandomFloat(20.15f, 135.17f), "SND_Ambient_Siren");
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");

	Engine.Ent_Fire("prop*", "FireUser1", "0", "0.00");
	Engine.Ent_Fire("item_money", "kill", "0", "0.00");

	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_human");
	RemoveNativeSpawns("info_player_zombie");
	RemoveNativeSpawns("info_player_start");
	CreateSpawnsFromArray(New_Spawns, true);
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

void OnProcessRound()
{
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);
		CZP_Player@ pPlayer = ToZPPlayer(i);

		if (pPlayerEntity is null)
		{
			continue;
		}

		if (g_TeleportDelay[i] != 0 && g_TeleportDelay[i] <= Globals.GetCurrentTime())
		{
			g_TeleportDelay[i] = 0;

			if (pPlayerEntity.GetTeamNumber() == 0)
			{
				int iRNG = Math::RandomInt(0, 1);
				Utils.ScreenFade(pPlayer, Color(0, 0, 0, 255), 0.175f, 0.01f, fade_in);
				pPlayerEntity.SetMoveType(MOVETYPE_WALK);
				pPlayerEntity.Teleport(g_TPOrigins[iRNG], g_TPAngles[iRNG], Vector(0, 0, 0));
				Engine.EmitSoundPosition(i, "doors/default_stop.wav", pPlayerEntity.EyePosition(), 1.0f, 60, 105);
			}
		}
	}
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();

	if (Utils.StrEql(pEntity.GetEntityName(), "teleport_door") && g_TeleportDelay[iIndex] == 0)
	{
		Vector Start = pBaseEnt.GetAbsOrigin();
		Vector End;
		Vector Down;

		Globals.AngleVectors(QAngle(90, 0, 0), Down);

		End = Start + Down * 256;

		CGameTrace trace;

		Utils.TraceLine(Start, End, MASK_ALL, pBaseEnt, COLLISION_GROUP_NONE, trace);

		pBaseEnt.Teleport(trace.endpos, pBaseEnt.EyeAngles(), Vector(0, 0, 0));

		pBaseEnt.SetAbsVelocity(Vector(0, 0, 0));
		g_TeleportDelay[iIndex] = Globals.GetCurrentTime() + 1.485f;
		Utils.ScreenFade(pPlayer, Color(0, 0, 0, 255), 1.175f, 0.395f, fade_out);
		pBaseEnt.SetMoveType(MOVETYPE_NONE);
		Engine.EmitSoundPosition(iIndex, "doors/default_move.wav", pBaseEnt.EyePosition(), 1.0f, 60, 105);
	}
}

void SND_Ambient_Rats()
{
	Engine.Ent_Fire("rat", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(4.32f, 35.14f), "SND_Ambient_Rats");
}

void SND_Ambient_Groan2()
{
	Engine.Ent_Fire("groan2", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(37.85f, 175.35f), "SND_Ambient_Groan2");
}

void SND_Ambient_Siren()
{
	Engine.Ent_Fire("siren", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(40.15f, 135.17f), "SND_Ambient_Siren");
}

void SND_Ambient_Thunder()
{
	Engine.Ent_Fire("thunder", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(51.24f, 225.25f), "SND_Ambient_Thunder");
}

void SND_Ambient_Groan1()
{
	Engine.Ent_Fire("groan1", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(103.75f, 250.00f), "SND_Ambient_Groan1");
}