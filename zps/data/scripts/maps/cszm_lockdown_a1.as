#include "cszm_modules/spawncrates"
#include "cszm_modules/lobbyambient"
#include "cszm_modules/ctspawn"
#include "cszm_modules/tspawn"
#include "cszm_modules/spawndist"

const int TEAM_LOBBYGUYS = 0;
int iMaxPlayers;
bool bIsCratesFound = false;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	iMinCrates = 2;
	iMaxCrates = 4;

	flDistBetweenCrates = 407.0f;

	flMaxZSDist = 1975.0f;
	flMinZSDist = 1250.0f;
	flRoarDist = 650.0f;

	Engine.PrecacheFile(sound, "buttons/lever8.wav");

	TerroristsSpawn.insertLast("270|-3952 6064 1|-3904 6064 1|-3856 6064 1|-3952 6000 1|-3904 6000 1|-3856 6000 1");
	TerroristsSpawn.insertLast("270|-4112 4592 1|-4064 4592 1|-4016 4592 1|-4112 4528 1|-4064 4528 1|-4016 4528 1");
	TerroristsSpawn.insertLast("0|-3648 3424 2|-3648 3472 2|-3648 3520 2|-3584 3520 2|-3584 3568 2|-3584 3616 2");
	TerroristsSpawn.insertLast("0|180 -2842 3072 0|180 -2842 2752 0|180 -2842 2432 0|90 -3360 2008 4|90 -3616 2008 4|-4128 2432 7|-4128 2752 1|-4128 3072 0");
	TerroristsSpawn.insertLast("r|-3825.03 1449.22 1|-3255 1391 1|-2851.11 1762.55 -1.28|-2767.58 2747.6 129|-2759.15 2036.09 129|-3155 2293.81 -0.45|-3686.39 1890.97 1|-3616.05 2100.65 -2|-4122.04 2186.41 1|-3278.85 3080.87 0.36|-3654.46 3442.46 1|-3700.74 4000.57 1|-3968.32 4671.84 1|-4143.68 4447.89 1|-4121.14 4281.66 129|-3539.07 4020.49 129|-3236.52 4086.24 129|-3344.08 4352.08 1|-3344.48 4192.16 1|-3235.91 3715.37 1|-3107.16 4011.35 129|-3195.32 4493.41 129|-3186.46 3741.46 1|-3046.5 4627.55 1|-2794.83 3941.54 129|-2690.69 4106.57 129|-2798.44 3700.8 129|-2668.78 3884.21 129|-2488.17 4098.98 129|-2479.56 3978.27 129|-2649.13 3091.34 129|-2720.85 4908 129|-2727 5011.11 1|-3296 5631.89 1|-3744 5647.99 1|-3936.01 6143.95 1|-3552.2 5136.21 1|-3398.71 5059.02 129|-3648.15 4816.09 1|-3568.03 4943.61 129|-3664.05 4815.87 129|-4064.19 5343.88 1");

	CounterTerroristsSpawn.insertLast("0|-3616 1536 1|-3616 1600 1|-3616 1664 1|-3616 1728 1|-3616 1792 1|-3552 1536 1|-3552 1600 1|-3552 1664 1|-3552 1728 1|-3552 1792 1|-3488 1536 1|-3488 1600 1|-3488 1664 1|-3488 1728 1|-3488 1792 1|-3424 1536 1|-3424 1600 1|-3424 1664 1|-3424 1728 1|-3424 1792 1|-3360 1568 1|-3360 1632 1|-3360 1696 1|-3360 1760 1");
	CounterTerroristsSpawn.insertLast("0|-3376 4480 129|-3376 4544 129|-3376 4608 129|-3376 4672 129|-3376 4736 129|-3312 4480 129|-3312 4544 129|-3312 4608 129|-3312 4672 129|-3312 4736 129|-3312 4480 129|-3312 4544 129|-3312 4608 129|-3312 4672 129|-3312 4736 129|-3248 4480 129|-3248 4544 129|-3248 4608 129|-3248 4608 129|-3248 4736 129|-3184 4480 129|-3184 4544 129|-3184 4608 129|-3184 4672 129|-3184 4736 129|-3120 4512 129|-3120 4576 129|-3120 4640 129|-3120 4704 129");
	CounterTerroristsSpawn.insertLast("0|-4056.01 5376.01 1|-4056.01 5440.01 1|-4056.01 5504.01 1|-4056.01 5568.01 1|-4056.01 5632.01 1|-3992.01 5376.01 1|-3992.01 5440.01 1|-3992.01 5504.01 1|-3992.01 5568.01 1|-3992.01 5632.01 1|-3928.01 5376.01 1|-3928.01 5440.01 1|-3928.01 5504.01 1|-3928.01 5568.01 1|-3928.01 5632.01 1|-3864.01 5376.01 1|-3864.01 5440.01 1|-3864.01 5504.01 1|-3864.01 5568.01 1|-3864.01 5568.01 1|-3800.01 5408.01 1|-3800.01 5408.01 1|-3800.01 5536.01 1|-3800.01 5600.01 1");

	Entities::RegisterOutput("OnPressed", "fan_button");

	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "Stuff");
	Schedule::Task(0.05f, "LockDown_FindCrates");
}

void OnProcessRound()
{
	if (ZSpawnManager !is null)
	{
		ZSpawnManager.Think();
	}
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnCrates");
}

void OnMatchEnded()
{
	@ZSpawnManager = null;
}

void Stuff()
{
	int iTSpawnIndex = CreateTerroristsSpawn();
	CreateCounterTerroristsSpawn();
	PlayLobbyAmbient();
	Shadows();

	if (iTSpawnIndex == 4)
	{
		@ZSpawnManager = CZSpawnManager();
	}

	Engine.Ent_Fire("what_a_light", "TurnOn");
	Engine.Ent_Fire("crates", "AddOutput", "physdamagescale 0.05");
	Engine.Ent_Fire("fan_button", "AddOutput", "wait 25");
}

void LockDown_FindCrates()
{
	CBaseEntity@ pEntity = null;

	while ((@pEntity = FindEntityByClassname(pEntity, "prop_itemcrate")) !is null)
	{
		if (!bIsCratesFound)
		{
			g_PICOrigin.insertLast(pEntity.GetAbsOrigin());
			g_PICAngles.insertLast(pEntity.GetAbsAngles());		
		}
		pEntity.SUB_Remove();
	}

	if (!bIsCratesFound)
	{
		bIsCratesFound = true;
	}
}

void OnEntityOutput(const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller)
{
	string strTargetname = pCaller.GetEntityName();

//	Chat.CenterMessage(all, "-=Output=-\nClass: " + pCaller.GetClassname() + "\nName: " + strTargetname);

	if (Utils.StrEql("OnPressed", strOutput) && Utils.StrEql("fan_button", strTargetname))
	{
		Engine.EmitSoundPosition(pCaller.entindex(), "buttons/lever8.wav", pCaller.GetAbsOrigin(), 0.85f, 65, 95);
		Engine.Ent_Fire("fan_switch", "SetAnimation", "switch");
		Engine.Ent_Fire("fan_switch", "SetPlaybackRate", "1.5");
		Engine.Ent_Fire("fan_switch", "SetPlaybackRate", "0", "0.85");
		Engine.Ent_Fire("fan_enable", "Trigger", "0", "1.5");
		Engine.Ent_Fire("fan_switch", "SetAnimation", "idle", "24.85");
	}
}

void Shadows()
{
	CBaseEntity@ pShadowControl = FindEntityByClassname(pShadowControl, "shadow_control");
	if (pShadowControl !is null)
	{
		Engine.Ent_Fire_Ent(pShadowControl, "SetShadowsDisabled", "0");
	}
}