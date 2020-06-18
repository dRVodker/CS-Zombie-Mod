#include "../SendGameText"
#include "cszm_modules/newspawn"

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

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SURVIVORS = 2;

int iMaxPlayers;
int iUNum;
int iBlackCross;
int iBustPitch = 75;

float flWaitTime;

bool bIsIPCCollected;
bool bIsFirstRound = true;

array<int> g_iIndex;
array<Vector> g_vOrigin;
array<QAngle> g_qAngles;
array<float> g_flRSTime;

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
	CreateSpawnsFromArray(SecondaryHumanSpawns);
}

void OnMatchEnded()
{

}

void SetUpStuff()
{
	iUNum = 0;
	iBlackCross = 0;

	iBustPitch = 100 - Math::RandomInt(-15, 25);

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
	CreateSpawnsFromArray(PrimaryHumanSpawns);
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

void BlackCross(CBaseEntity@ pEntityPlayer)
{
	CZP_Player@ pPlayer = ToZPPlayer(pEntityPlayer);

	if (pPlayer !is null)
	{
		int iRND = Math::RandomInt(1, 3);
		Utils.ScreenFade(pPlayer, Color(0, 0, 0, 255), 3.0f, 0.0f, fade_in);
		Engine.EmitSoundPlayer(pPlayer, "@physics/glass/glass_impact_bullet" + formatInt(iRND) + ".wav");
		Engine.EmitSoundPlayer(pPlayer, "@physics/glass/glass_impact_bullet" + formatInt(iRND) + ".wav");
		Engine.EmitSoundPlayer(pPlayer, "@physics/glass/glass_impact_bullet" + formatInt(iRND) + ".wav");
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