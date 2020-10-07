#include "../SendGameText"
#include "cszm_modules/newspawn"
#include "cszm_modules/cashmaker"

array<array<CSpawnPoint@>> PrimaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(-28.3999, -1394.01, -5.80957), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-83.5069, -1319.7, -7.21992), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(6.86754, -1271.79, -2.37119), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-131.51, -1405.13, -10.4845), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-232.347, -1372.14, -9.99016), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-160.233, -1270.11, -8.88592), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-258.904, -1231.25, -18.4523), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-342.764, -1313.12, -4.04865), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-312.47, -1392.53, -4.17452), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-410.273, -1288.55, 0.034111), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-334.579, -1166.61, -13.9181), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-231.341, -1102.62, -25.8202), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-130.803, -1180.33, -8.34069), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-34.8482, -1171.79, 1.03125), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(9.54036, -1062.11, 1.03125), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-120.129, -1062.14, -3.5229), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-198.067, -991.78, -16.6928), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-302.161, -1014.03, -12.3864), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-393.672, -1044.72, 0.0412865), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-363.98, -951.512, -4.48498), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-254.86, -892.718, -23.7359), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-154.004, -922.561, -14.3217), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-48.2831, -956.078, 1.02246), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-408.678, -1141.53, -1.32711), QAngle(0, 88.9783, 0)),
		CSpawnPoint(Vector(-69.5831, -1115.26, 0.692287), QAngle(0, 88.9783, 0)),

		CSpawnPoint(Vector(-391.266, 452.504, 8.03125), QAngle(-6.4614, -122.241, 0), "info_player_start"),
		CSpawnPoint(Vector(-469.172, -1282.55, 8.03125), QAngle(-2.90398, 56.718, 0), "info_player_start"),
		CSpawnPoint(Vector(359.085, -399.297, 8.03125), QAngle(-0.580772, 62.163, 0), "info_player_start"),
		CSpawnPoint(Vector(962.664, 842.978, -7.71015), QAngle(-0.435567, -126.053, 0), "info_player_start"),
		CSpawnPoint(Vector(2300.01, -417.953, -164.669), QAngle(-12.8865, 146.742, 0), "info_player_start")
	},
	{
		CSpawnPoint(Vector(-364.06, -1333.51, -2.21761), QAngle(6.60653, 58.792, 0)),
		CSpawnPoint(Vector(-369.983, -1096.56, -3.07562), QAngle(16.2986, -53.847, 0)),
		CSpawnPoint(Vector(-179.466, -1378.34, -10.5882), QAngle(-0.835, 120.03, 0)),
		CSpawnPoint(Vector(100.434, -1132.08, 8.03125), QAngle(2.2868, 123.841, 0)),
		CSpawnPoint(Vector(-157.769, -997.932, -8.97089), QAngle(5.699, 95.3819, 0)),
		CSpawnPoint(Vector(-458.172, -529.406, 8.03125), QAngle(0.871099, -29.7805, 0)),
		CSpawnPoint(Vector(187.104, -461.116, 8.03125), QAngle(1.05259, 115.71, 0)),
		CSpawnPoint(Vector(-135.749, 226.986, 8.03125), QAngle(21.0176, -33.3743, 0)),
		CSpawnPoint(Vector(-252.927, -358.083, -36.6914), QAngle(0.87115, -79.076, 0)),
		CSpawnPoint(Vector(-29.8035, -429.159, -9.72815), QAngle(7.25995, -125.467, 0)),
		CSpawnPoint(Vector(445.986, 110.495, -0.984589), QAngle(6.31614, -148.204, 0)),
		CSpawnPoint(Vector(259.881, -164.569, -27.3962), QAngle(4.71895, 26.1214, 0)),
		CSpawnPoint(Vector(858.632, 707.193, -29.4603), QAngle(5.95312, -107.367, -0)),
		CSpawnPoint(Vector(552.762, 574.599, 0.447208), QAngle(2.28682, -57.5993, 0)),
		CSpawnPoint(Vector(1671.18, 285.795, 8.03125), QAngle(2.17792, -167.77, 0)),
		CSpawnPoint(Vector(1476.2, 481.388, -2.5352), QAngle(3.48472, -141.198, 0)),
		CSpawnPoint(Vector(1133.83, 62.8701, -57.0316), QAngle(-1.27059, 35.3652, 0)),
		CSpawnPoint(Vector(2107.53, -290.48, -175.969), QAngle(5.5175, 38.9589, 0)),
		CSpawnPoint(Vector(2372.58, -195.679, -167.969), QAngle(4.86411, 172.507, 0)),
		CSpawnPoint(Vector(2286.64, 11.795, -167.969), QAngle(4.39222, -108.578, 0)),
		CSpawnPoint(Vector(1651, -403.748, 8.03125), QAngle(2.3231, 58.2572, 0)),
		CSpawnPoint(Vector(1795.66, -480.811, 8.03125), QAngle(-3.26708, 110.311, 0)),
		CSpawnPoint(Vector(1069.82, 481.4, -5.32403), QAngle(8.53042, -54.4307, 0)),
		CSpawnPoint(Vector(566.528, -76.683, -13.216), QAngle(3.92031, 31.092, 0)),

		CSpawnPoint(Vector(359.085, -399.297, 8.03125), QAngle(-0.580772, 62.163, 0), "info_player_start"),
		CSpawnPoint(Vector(-389.983, -938.032, -1.98685), QAngle(0, -0.184061, 0), "info_player_start"),
		CSpawnPoint(Vector(69.8392, -1316.04, 8.03125), QAngle(0, 179.553, 0), "info_player_start"),
		CSpawnPoint(Vector(-1021.43, 294.911, 3.89251), QAngle(0, 2.39168, 0), "info_player_start"),
		CSpawnPoint(Vector(256.536, 1220.06, 8.03125), QAngle(0, -0.163876, 0), "info_player_start")
	},
	{
		CSpawnPoint(Vector(2557.82, 208.598, -141.868), QAngle(7.55036, -155.015, 0)),
		CSpawnPoint(Vector(2574.36, 89.99, -154.579), QAngle(12.7776, 175.473, 0)),
		CSpawnPoint(Vector(2485.35, 178.968, -154.991), QAngle(-3.12181, -176.686, 0)),
		CSpawnPoint(Vector(2372.25, 225.954, -142.688), QAngle(9.90989, -170.551, 0)),
		CSpawnPoint(Vector(2334.62, 147.902, -152.738), QAngle(10.4907, -173.637, 0)),
		CSpawnPoint(Vector(2228.81, 193.59, -143.601), QAngle(7.94968, -176.686, 0)),
		CSpawnPoint(Vector(2233.29, 53.9173, -170.589), QAngle(2.72247, 158.775, 0)),
		CSpawnPoint(Vector(2385.21, -11.5958, -182.03), QAngle(3.26699, 150.027, 0)),
		CSpawnPoint(Vector(2295.94, -15.5983, -167.969), QAngle(9.9462, 150.753, 0)),
		CSpawnPoint(Vector(2566.1, -12.4966, -158.749), QAngle(3.48481, 173.682, 0)),
		CSpawnPoint(Vector(2485.15, -60.9909, -179.939), QAngle(2.14171, 179.417, 0)),
		CSpawnPoint(Vector(2592.37, -91.8058, -159.12), QAngle(-1.34306, 176.84, 0)),
		CSpawnPoint(Vector(2497.35, -158.932, -167.363), QAngle(4.28343, 174.262, 0)),
		CSpawnPoint(Vector(2584.6, -221.756, -149.463), QAngle(2.94035, 167.402, 0)),
		CSpawnPoint(Vector(2411.67, -178.243, -174.102), QAngle(3.15815, 170.886, 0)),
		CSpawnPoint(Vector(2285.12, -178.175, -175.969), QAngle(5.00945, -177.352, 0)),
		CSpawnPoint(Vector(2166.56, -57.7746, -165.531), QAngle(2.72255, 111.221, 0)),
		CSpawnPoint(Vector(2214.1, -108.895, -167.969), QAngle(4.46496, 153.608, 0)),
		CSpawnPoint(Vector(2186.76, -245.998, -167.969), QAngle(5.11836, 159.307, 0)),
		CSpawnPoint(Vector(2308.99, -257.884, -171.755), QAngle(2.86773, 151.866, 0)),
		CSpawnPoint(Vector(2503.71, -305.326, -138.888), QAngle(4.13824, 154.588, 0)),
		CSpawnPoint(Vector(2379.62, -422.179, -149.366), QAngle(2.35954, 137.346, 0)),
		CSpawnPoint(Vector(2279.09, -313.137, -175.969), QAngle(4.97313, 142.5, 0)),
		CSpawnPoint(Vector(2138.29, -287.482, -175.969), QAngle(4.24713, 128.488, 0)),
		CSpawnPoint(Vector(2243.48, -413.775, -165.33), QAngle(-1.12529, 124.459, 0)),
		CSpawnPoint(Vector(2481.98, -371.801, -138.579), QAngle(7.04222, 142.428, 0)),
		CSpawnPoint(Vector(2214.37, -341.564, -184.011), QAngle(-1.63347, 125.766, 0)),

		CSpawnPoint(Vector(-200.031, -164.629, 0.03125), QAngle(0, -0.953902, 0), "info_player_start"),
		CSpawnPoint(Vector(637.743, 115.44, -19.154), QAngle(0, -1.05914, 0), "info_player_start"),
		CSpawnPoint(Vector(1631.7, 835.056, 8.03125), QAngle(0, -91.4409, 0), "info_player_start"),
		CSpawnPoint(Vector(219.475, 896.399, 8.03125), QAngle(0, -1.29208, 0), "info_player_start")
	}
};

array<array<CSpawnPoint@>> SecondaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(-412.915, -979.043, 0.643227), QAngle(-3.92047, 53.8141, 0)),
		CSpawnPoint(Vector(-11.5664, -1072.1, 1.03125), QAngle(-1.23427, 118.065, 0)),
		CSpawnPoint(Vector(-73.6829, 206.688, 8.03125), QAngle(2.75872, -161.785, 0)),
		CSpawnPoint(Vector(138.752, 205.674, 8.03125), QAngle(2.32313, -26.8937, 0)),
		CSpawnPoint(Vector(239.629, 1237.35, 8.03125), QAngle(3.70253, -40.4335, 0)),
		CSpawnPoint(Vector(1609.6, 851.007, 8.03125), QAngle(-0.907581, -97.5697, 0)),
		CSpawnPoint(Vector(1676.88, 716.939, 8.03125), QAngle(-5.51768, -107.516, 0)),
		CSpawnPoint(Vector(443.753, -332.761, 8.03125), QAngle(10.4906, 144.891, 0)),
		CSpawnPoint(Vector(-786.7, -509.555, 18.713), QAngle(2.79503, 22.4509, 0)),
		CSpawnPoint(Vector(-943.192, 438.392, 3.60064), QAngle(4.68264, -35.7143, 0))
	},
	{
		CSpawnPoint(Vector(-445.802, -767.163, 43.4684), QAngle(9.98243, 47.0625, 0)),
		CSpawnPoint(Vector(99.0391, -708.678, 8.03125), QAngle(-0.108957, 145.944, 0)),
		CSpawnPoint(Vector(-240.607, -156.874, -13.7622), QAngle(-3.19446, 175.359, 0)),
		CSpawnPoint(Vector(-542.567, 477.808, 8.03125), QAngle(3.04914, -124.89, 0)),
		CSpawnPoint(Vector(-793.889, -420.183, 8.44565), QAngle(12.4145, -15.5183, 0)),
		CSpawnPoint(Vector(290.092, 1246.97, 8.03125), QAngle(-43.2697, -56.2832, 0)),
		CSpawnPoint(Vector(587.335, 1249.37, 8.03125), QAngle(0.980031, -78.4262, -0)),
		CSpawnPoint(Vector(1538.27, -89.6895, -36.9218), QAngle(2.64984, 131.764, 0)),
		CSpawnPoint(Vector(1235.58, 181.386, -41.2426), QAngle(-10.5997, 77.35, 0)),
		CSpawnPoint(Vector(1072.75, 299.737, -45.3396), QAngle(-4.93688, -152.696, 0))
	}
};

enum ZPS_Teams {TEAM_LOBBYGUYS = 0, TEAM_SURVIVORS = 2}

int iMaxPlayers;
int iUNum;
int iBlackCross;
int iBustPitch;

float flWaitTime;

bool bIsIPCCollected;
bool bIsFirstRound = true;

array<int> g_iBlackCrossIndex;
array<int> g_iSewerCapIndex;
int iAtticHatchIndex;
int iCeilingHatchIndex;

array<string> g_strFBNames =
{
	"_black_cross",
	"SewerCap",
	"AtticHatch",
	"CeilingHatch"
};

array<Vector> g_vecCheeseOrigin =
{
	Vector(-1240, -256, 48),
	Vector(-883.99, -0.01, 288),
	Vector(-951.99, -112.01, 48.01),
	Vector(1536.01, 1083.99, 44.01),
	Vector(822.85, 909.08, 53.65),
	Vector(1368.07, 776.38, 232.18),
	Vector(441.88, 1093.9, 325.27),
	Vector(2415.95, -474.52, 84.27),
	Vector(937.86, -209.4, 117.63),
	Vector(1029.52, 216.92, -218.88)
};

array<Vector> g_vLobbySpawn;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	flWaitTime = Globals.GetCurrentTime() + 0.01f;

	Engine.PrecacheFile(sound, "sunshine_ambient/vo/sometimes01.wav");
	Engine.PrecacheFile(sound, "@sunshine_ambient/vo/sometimes01.wav");
	Engine.PrecacheFile(sound, "@sunshine_ambient/vo/no02.wav");
	Engine.PrecacheFile(sound, "@sunshine_ambient/vo/no01.wav");

	Engine.PrecacheFile(sound, "@ambient/voices/citizen_punches2.wav");

	Engine.PrecacheFile(sound, "sunshine_ambient/vo/youkilllingme.wav");

	Engine.PrecacheFile(sound, "humans/eugene/pain/pain-01.wav");
	Engine.PrecacheFile(sound, "humans/eugene/pain/pain-02.wav");
	Engine.PrecacheFile(sound, "humans/eugene/pain/pain-03.wav");
	Engine.PrecacheFile(sound, "humans/eugene/pain/pain-04.wav");
	Engine.PrecacheFile(sound, "humans/eugene/pain/pain-05.wav");
	Engine.PrecacheFile(sound, "humans/eugene/pain/pain-06.wav");

	Engine.PrecacheFile(sound, "@physics/glass/glass_impact_bullet1.wav");
	Engine.PrecacheFile(sound, "@physics/glass/glass_impact_bullet2.wav");
	Engine.PrecacheFile(sound, "@physics/glass/glass_impact_bullet3.wav");

	Engine.PrecacheFile(sound, "items/suitchargeok1.wav");

	Entities::RegisterOutput("OnBreak", "cheese");
	Entities::RegisterOutput("OnBreak", "func_breakable");
	Entities::RegisterOutput("OnPhysPunted", "bust");
	Entities::RegisterOutput("OnTakeDamage", "bust");
	Entities::RegisterUse("cheese");

	Events::Trigger::OnEndTouch.Hook(@SH_OnEndTouch);
	Events::Trigger::OnStartTouch.Hook(@SH_OnStartTouch);
	Events::Player::OnPlayerSpawn.Hook(@SH_OnPlayerSpawn);

	Schedule::Task(0.01f, "SetUpStuff");
	CashDATA();
}

void FindIPC()
{
	int iCount = 0;
	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_commons")) !is null)
	{
		iCount++;

		if (!bIsIPCCollected)
		{
			g_vLobbySpawn.insertLast(pEntity.GetAbsOrigin());
		}

		if (iCount < 41)
		{
			pEntity.SUB_Remove();
		}

		else if (!bIsIPCCollected)
		{
			bIsIPCCollected = true;
		}
	}
}

void OnNewRound()
{
	Schedule::Task(0.01f, "SetUpStuff");

	if (bIsFirstRound)
	{
		bIsFirstRound = false;
	}
}

void OnMatchBegin()
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SecondaryHumanSpawns, false);
}

void OnMatchEnded()
{

}

void SetUpStuff()
{
	iUNum = 0;
	iBlackCross = 0;

	iBustPitch = Math::RandomInt(85, 125);

	Engine.Ent_Fire("tonemap", "SetBloomScale", "0.85", "0.00");
	Engine.Ent_Fire("tonemap", "SetAutoExposureMin", "0.64", "0.00");
	Engine.Ent_Fire("tonemap", "SetAutoExposureMax", "1.4", "0.00");

	Engine.Ent_Fire("Player_clip1", "Enable", "0", "0.00");
	Engine.Ent_Fire("Precache", "kill", "0", "0.00");
	Engine.Ent_Fire("shading", "StartOverlays", "0", "0.00");
	Engine.Ent_Fire("plr_manager", "Kill", "0", "0.00");
	Engine.Ent_Fire("bust", "addoutput", "damagetoenablemotion 999998", "0.00");
	
	SpawnCheese();
	FindIPC();
	CollectEntIndexs();

	RemoveNativeSpawns("info_player_human");
	RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(PrimaryHumanSpawns, true);
}

HookReturnCode SH_OnEndTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (Utils.StrEql("bob_trigger", strEntityName, true) && Utils.StrEql("npc_grenade_frag", pEntity.GetClassname(), true))
	{	
		pEntity.SetHealth(25);
		pEntity.Ignite(15);
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode SH_OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	CBaseEntity@ pParent = pTrigger.GetParent();

	if (pParent !is null && Utils.StrEql(pParent.GetClassname(), "func_breakable") && pEntity.GetTeamNumber() == 2)
	{
		pParent.SetHealth(pParent.GetHealth() + pParent.GetMaxHealth());
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode SH_OnPlayerSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS && !bIsFirstRound)
	{
		pBaseEnt.SetAbsOrigin(g_vLobbySpawn[Math::RandomInt(0, g_vLobbySpawn.length())]);
	}

	return HOOK_CONTINUE;
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (Utils.StrEql(pEntity.GetEntityName(), "cheese"))
	{
		Engine.Ent_Fire_Ent(pEntity, "AddHealth", "-5");
		Engine.Ent_Fire("cheese_voice", "PlaySound");
	}
}

void OnEntityOutput(const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller)
{
	if (Utils.StrEql(strOutput, "OnBreak"))
	{
		if (Utils.StrEql(pCaller.GetEntityName(), "cheese"))
		{
			Engine.Ent_Fire("cheese_voice", "volume", "0");
			Engine.Ent_Fire("cheese_voice", "kill", "0", "0.05");
			Schedule::Task(0.25f, "CheeseNoNo");
			Schedule::Task(1.9f, "CheeseNooo");
		}

		int iBCIlength = int(g_iBlackCrossIndex.length());
		int iSCIlength = int(g_iSewerCapIndex.length());

		if (iBCIlength > 0)
		{
			for (int i = 0; i < iBCIlength; i++)
			{
				if (pCaller.entindex() == g_iBlackCrossIndex[i])
				{
					BlackCross(pActivator);
					g_iBlackCrossIndex.removeAt(i);
					break;
				}
			}
		}

		if (iSCIlength > 0)
		{
			for (int i = 0; i < iSCIlength; i++)
			{
				if (pCaller.entindex() == g_iSewerCapIndex[i])
				{
					Engine.Ent_Fire("SewerCap", "SetHealth", "50", "0.00");
					g_iSewerCapIndex.removeAt(i);
					break;
				}
			}
		}

		if (pCaller.entindex() == iAtticHatchIndex)
		{
			Engine.Ent_Fire("areaportal_wall4", "Open", "", "0.00");
			Engine.Ent_Fire("Player_clip1", "Disable", "", "0.00");
		}

		if (pCaller.entindex() == iCeilingHatchIndex)
		{
			Engine.Ent_Fire("ladder", "EnableMotion", "", "0.00");
			Engine.Ent_Fire("areaportal_wall3", "Open", "", "0.00");
			Engine.Ent_Fire("_temp_attic", "ForceSpawn", "", "0.00");
			Engine.Ent_Fire("mega_props", "AddOutput", "damagetoenablemotion 1880", "0.05");
		}
	}

	if (Utils.StrEql(pCaller.GetEntityName(), "bust"))
	{
		if (Utils.StrEql(strOutput, "OnPhysPunted"))
		{
			Engine.EmitSoundPosition(pCaller.entindex(), "sunshine_ambient/vo/youkilllingme.wav", pCaller.GetAbsOrigin(), 1.0f, 65, iBustPitch);
		}

		if (Utils.StrEql(strOutput, "OnTakeDamage"))
		{
			Engine.EmitSoundPosition(pCaller.entindex(), "humans/eugene/pain/pain-0" + Math::RandomInt(1, 6) + ".wav", pCaller.GetAbsOrigin(), 1.0f, 75, iBustPitch);
		}
	}
}

void BlackCross(CBaseEntity@ pPlayerEntity)
{
	CZP_Player@ pPlayer = ToZPPlayer(pPlayerEntity);

	if (pPlayer !is null)
	{
		int iRND = Math::RandomInt(1, 3);
		Utils.ScreenFade(pPlayer, Color(0, 0, 0, 255), 3.0f, 0.0f, fade_in);
		Engine.EmitSoundEntity(pPlayerEntity, "@physics/glass/glass_impact_bullet" + formatInt(iRND) + ".wav");
		Engine.EmitSoundEntity(pPlayerEntity, "@physics/glass/glass_impact_bullet" + formatInt(iRND) + ".wav");
		Engine.EmitSoundEntity(pPlayerEntity, "@physics/glass/glass_impact_bullet" + formatInt(iRND) + ".wav");
	}

	iBlackCross++;

	if (iBlackCross == 10)
	{
		Schedule::Task(Math::RandomFloat(4.12f, 7.23f), "BlackCrossCompleted");
	}
}

void BlackCrossCompleted()
{
	Engine.EmitSoundPosition(0, "@ambient/voices/citizen_punches2.wav", Vector(0, 0, 0), 1.0f, 0, 105);
	Utils.ViewPunch(Vector(0, 0, 0), QAngle(-180, 0, 0), 0.0f, true);
	Utils.ScreenFade(null, Color(175, 2, 2, 32), 0.35f, 0.0f, fade_in);
}

void CheeseNoNo()
{
	Engine.EmitSoundPosition(0, "@sunshine_ambient/vo/no01.wav", Vector(0, 0, 0), 1.0f, 0, 95);
	SendGameText(any, "The Cheese . . . .", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.0f, 10.0f, Color(255, 0, 0), Color(0, 0, 0));
}

void CheeseNooo()
{
	Engine.EmitSoundPosition(0, "@sunshine_ambient/vo/no02.wav", Vector(0, 0, 0), 1.0f, 0, 95);
	SendGameText(any, "The Cheese . . . .\nare broken!!!", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.45f, 2.24f, Color(255, 0, 0), Color(0, 0, 0));
}

void SpawnCheese()
{
	if (Math::RandomInt(0, 100) <= 47)
	{
		Vector NewOrigin = g_vecCheeseOrigin[Math::RandomInt(0, 9)];

		float RandomYaw = Math::RandomFloat(0.0f, 360.0f);

		CEntityData@ CheeseIPD = EntityCreator::EntityData();
		CheeseIPD.Add("targetname", "cheese");
		CheeseIPD.Add("model", "models/props_sunshine/cheese.mdl");
		CheeseIPD.Add("overridescript", "surfaceprop,watermelon,");
		CheeseIPD.Add("puntsound", "Flesh_Zombie.BulletImpact");
		CheeseIPD.Add("spawnflags", "256");

		CEntityData@ CheeseVoiceIPD = EntityCreator::EntityData();
		CheeseVoiceIPD.Add("targetname", "cheese_voice");
		CheeseVoiceIPD.Add("message", "@sunshine_ambient/vo/sometimes01.wav");
		CheeseVoiceIPD.Add("pitch", "75");
		CheeseVoiceIPD.Add("pitchstart", "75");
		CheeseVoiceIPD.Add("spawnflags", "49");
		CheeseVoiceIPD.Add("health", "10");
		CheeseVoiceIPD.Add("radius", "1024");

		CBaseEntity@ pCheese = EntityCreator::Create("prop_physics_multiplayer", NewOrigin, QAngle(0, RandomYaw, 0), CheeseIPD);
		CBaseEntity@ pCheeseVoice = EntityCreator::Create("ambient_generic", NewOrigin, QAngle(0, RandomYaw, 0), CheeseVoiceIPD);

		pCheese.SetMaxHealth(256);
		pCheese.SetHealth(256);
	}
}

void CollectEntIndexs()
{
	g_iBlackCrossIndex.removeRange(0, g_iBlackCrossIndex.length());
	g_iSewerCapIndex.removeRange(0, g_iSewerCapIndex.length());
	iAtticHatchIndex = 0;
	iCeilingHatchIndex = 0;

	CBaseEntity@ pEntity;
	int ilength = int(g_strFBNames.length());

	while ((@pEntity = FindEntityByClassname(pEntity, "func_breakable")) !is null)
	{
		for (int i = 0; i < ilength; i++)
		{
			if (Utils.StrEql(pEntity.GetEntityName(), g_strFBNames[i]))
			{
				if (i == 0)
				{
					g_iBlackCrossIndex.insertLast(pEntity.entindex());
				}

				if (i == 1)
				{
					g_iSewerCapIndex.insertLast(pEntity.entindex());
				}

				if (i == 2)
				{
					iAtticHatchIndex = pEntity.entindex();
				}

				if (i == 3)
				{
					iCeilingHatchIndex = pEntity.entindex();
				}
			}
		}
	}
}

void RespawnEffects(Vector &in Origin)
{
	CEntityData@ SparkIPD = EntityCreator::EntityData();
	SparkIPD.Add("spawnflags", "896");
	SparkIPD.Add("magnitude", "1");
	SparkIPD.Add("trailLength", "1");
	SparkIPD.Add("maxdelay", "0");

	SparkIPD.Add("SparkOnce", "0", true);
	SparkIPD.Add("kill", "0", true);

	EntityCreator::Create("env_spark", Origin, QAngle(-90, 0, 0), SparkIPD);	

	Engine.EmitSoundPosition(0, "items/suitchargeok1.wav", Origin, 0.695f, 75, Math::RandomInt(135, 165));
}

void CashDATA()
{
	MaxRandomCash = 12;
	MinRandomCash = 2;

	InsertToArray(2008.62, -435.337, 81.0313);
	InsertToArray(2607.8, -75.5436, -46.9688);
	InsertToArray(2174.87, -339.638, -166.969);
	InsertToArray(1687.77, -494.29, 54.4029);
	InsertToArray(1406.01, 336.835, 1.03125);
	InsertToArray(1596.26, 873.901, 9.03125);
	InsertToArray(831.841, -260.68, 155.031);
	InsertToArray(756.366, 1255.42, 9.03125);
	InsertToArray(368.895, 1177.03, 321.031);
	InsertToArray(437.055, 1043.55, 1.03125);
	InsertToArray(447.632, 1042.02, 1.03125);
	InsertToArray(463.667, 1019.52, 1.03125);
	InsertToArray(1450.19, 1132.7, 45.972);
	InsertToArray(1496.32, 1127.62, 9.03125);
	InsertToArray(1128.63, 1263.5, 113.983);
	InsertToArray(1087.88, 1131.55, 46.2174);
	InsertToArray(876.94, 1219.83, 206.449);
	InsertToArray(852.254, 1256.44, 185.029);
	InsertToArray(1329.15, 909.134, 238.476);
	InsertToArray(1107.64, 1061.74, 145.031);
	InsertToArray(338.079, 915.731, -238.969);
	InsertToArray(1331.17, -245.299, -198.833);
	InsertToArray(1090.99, 398.722, -193.523);
	InsertToArray(544.242, 127.878, 65.0313);
	InsertToArray(-69.6797, 129.079, 12.0754);
	InsertToArray(-174.067, -227.366, 65.0313);
	InsertToArray(-467.726, -1448.28, 9.03125);
	InsertToArray(-819.515, -360.434, 145.031);
	InsertToArray(-1020.74, -6.86909, 281.031);
	InsertToArray(-1062.96, -257.093, 281.031);
	InsertToArray(-985.682, -220.644, 145.031);
	InsertToArray(-1004.81, -146.292, 9.03125);
	InsertToArray(-1141.7, -70.2236, 41.0312);
	InsertToArray(-1226.97, 414.427, 71.0877);
	InsertToArray(-1102.74, -53.1684, 77.2627);
	InsertToArray(-688.779, 492.8, 9.03125);
	InsertToArray(372.12, -424.413, 9.03125);
	InsertToArray(-818.163, -290.123, 226.662);
	InsertToArray(-883.249, 217.45, 172.031);
	InsertToArray(-492.805, -580.37, 9.03125);
	InsertToArray(-850.657, -458.73, 36.4255);
	InsertToArray(-1005.643, -147.479, 327.388);
}