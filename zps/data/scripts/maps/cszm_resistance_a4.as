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

	MapCash();
}

void MapCash()
{
	MaxRandomCash = 8;
	MinRandomCash = 2;

	MaxMoneyPerItem = 110.0f;
	MinMoneyPerItem = 30.0f;

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
}

void OnMatchBegin() 
{
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
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