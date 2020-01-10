#include "cszm_modules/spawncrates"
#include "cszm_modules/lobbyambient"

const int TEAM_LOBBYGUYS = 0;

float flFan1FLTime = 0.0f;
float flFan2FLTime = 0.0f;

int iF1SPitch = 0;
bool bFan1IsOn = false;
float flFan1Delay = 0.0f;

int iF2SPitch = 0;
bool bFan2IsOn = false;
float flFan2Delay = 0.0f;

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");

	Entities::RegisterUse("func_button");
	Events::Trigger::OnStartTouch.Hook(@OnStartTouch);
	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);

	iMinCrates = 0;
	iMaxCrates = 3;

	g_PICOrigin.insertLast(Vector(-852.261, -163.311, -191.5));
	g_PICAngles.insertLast(QAngle(0, 40.4629, 0));

	g_PICOrigin.insertLast(Vector(-562.468, -1020.97, 48.4892));
	g_PICAngles.insertLast(QAngle(0, 23.0501, 0));

	g_PICOrigin.insertLast(Vector(489.671, -1037.58, 48.487));
	g_PICAngles.insertLast(QAngle(0, 27.1824, 0));

	g_PICOrigin.insertLast(Vector(152.969, -681.461, -64.7168));
	g_PICAngles.insertLast(QAngle(0, 35.3623, 0));

	g_PICOrigin.insertLast(Vector(-85.5905, -282.227, -303.548));
	g_PICAngles.insertLast(QAngle(0, -53.877, 0));

	g_PICOrigin.insertLast(Vector(1381.25, -601.578, -447.509));
	g_PICAngles.insertLast(QAngle(0, 40.262, 0));

	g_PICOrigin.insertLast(Vector(442.822, -456.774, -543.508));
	g_PICAngles.insertLast(QAngle(0, -18.2347, 0));

	g_PICOrigin.insertLast(Vector(372.145, -1089.51, -303.5));
	g_PICAngles.insertLast(QAngle(0, -43.6699, 0));

	g_PICOrigin.insertLast(Vector(-465.154, -160.674, 0.4998));
	g_PICAngles.insertLast(QAngle(0, 36.16, 0));
}

void OnNewRound()
{	
	bFan1IsOn = false;
	bFan2IsOn = false;
	iF1SPitch = 0;
	iF2SPitch = 0;
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnProcessRound()
{
	if (flFan1FLTime <= Globals.GetCurrentTime() && bFan1IsOn)
	{
		flFan1FLTime = Globals.GetCurrentTime() + 1.1f;
		Engine.Ent_Fire("snd_fan1", "Volume", "10");
	}

	if (flFan2FLTime <= Globals.GetCurrentTime() && bFan2IsOn)
	{
		flFan2FLTime = Globals.GetCurrentTime() + 1.1f;
		Engine.Ent_Fire("snd_fan2", "Volume", "10");
	}
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnCrates");
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	Engine.Ent_Fire("vrad*", "Kill");
	
	Engine.Ent_Fire("tonemap", "SetBloomScale", "0.375");

	TurnOnFan1();

	PlayLobbyAmbient();
}

HookReturnCode OnPlayerSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
	{
		PlayLobbyAmbient();
	}

	return HOOK_CONTINUE;	
}

HookReturnCode OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (strEntityName == "hurt_toxic1" || strEntityName == "hurt_toxic2")
	{
		if (!pEntity.IsPlayer())
		{
			if (Utils.StrContains("weapon_", pEntity.GetClassname()) || Utils.StrContains("item_", pEntity.GetClassname()))
			{
				pEntity.SUB_Remove();
			}
		}
	}

	return HOOK_CONTINUE;
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity.GetEntityName() == "button_fan1")
	{
		if (flFan1Delay <= Globals.GetCurrentTime())
		{
			if (iF1SPitch == 100 || iF1SPitch == 0)
			{
				Engine.EmitSoundEntity(pEntity, "Buttons.snd14");
				flFan1Delay = Globals.GetCurrentTime() + 20.0f;

				if (bFan1IsOn)
				{
					bFan1IsOn = false;
					iF1SPitch = 100;
					Fan1SNDStop();
					Engine.Ent_Fire("func_fan1", "stop");
					Engine.Ent_Fire("fanpush", "disable", "0", "0.75");
					Schedule::Task(10.0f, "TurnOnFan1");
				}

				else
				{
					bFan1IsOn = true;
					iF1SPitch = 0;
					Fan1SNDPlay();
					Engine.Ent_Fire("func_fan1", "start");
					Engine.Ent_Fire("fanpush", "enable", "0", "1.25");
				}
			}
		}
	}

	if (pEntity.GetEntityName() == "button_fan2")
	{
		if (flFan2Delay <= Globals.GetCurrentTime())
		{
			if (iF2SPitch == 100 || iF2SPitch == 0)
			{
				Engine.EmitSoundEntity(pEntity, "Buttons.snd14");
				flFan2Delay = Globals.GetCurrentTime() + 45.0f;

				if (bFan2IsOn)
				{
					bFan2IsOn = false;
					iF2SPitch = 100;
					Fan2SNDStop();
					Engine.Ent_Fire("func_fan2", "stop");
					Engine.Ent_Fire("fanpush2", "disable", "0", "0.75");
				}

				else
				{
					bFan2IsOn = true;
					iF2SPitch = 0;
					Fan2SNDPlay();
					Engine.Ent_Fire("func_fan2", "start");
					Engine.Ent_Fire("fanpush2", "enable", "0", "1.25");
					Schedule::Task(10.0f, "TurnOffFan2");
				}
			}
		}
	}
}

void Fan1SNDPlay()
{
	if (iF1SPitch == 0)
	{
		Engine.Ent_Fire("snd_fan1", "Volume", "10");
	}

	iF1SPitch++;

	Engine.Ent_Fire("snd_fan1", "Pitch", "" + iF1SPitch);

	if (iF1SPitch != 100 && iF1SPitch > 0 && iF1SPitch < 100)
	{
		Schedule::Task(0.025f, "Fan1SNDPlay");
	}
}

void Fan1SNDStop()
{
	iF1SPitch--;

	Engine.Ent_Fire("snd_fan1", "Pitch", "" + iF1SPitch);

	if (iF1SPitch != 0 && iF1SPitch > 0 && iF1SPitch < 100)
	{
		Schedule::Task(0.025f, "Fan1SNDStop");
	}

	if (iF1SPitch == 0)
	{
		Engine.Ent_Fire("snd_fan1", "Volume", "0");
	}
}

void Fan2SNDPlay()
{
	if (iF2SPitch == 0)
	{
		Engine.Ent_Fire("snd_fan2", "Volume", "10");
	}

	iF2SPitch++;

	Engine.Ent_Fire("snd_fan2", "Pitch", "" + iF2SPitch);

	if (iF2SPitch != 100 && iF2SPitch > 0 && iF2SPitch < 100)
	{
		Schedule::Task(0.025f, "Fan2SNDPlay");
	}
}

void Fan2SNDStop()
{
	iF2SPitch--;

	Engine.Ent_Fire("snd_fan2", "Pitch", "" + iF2SPitch);

	if (iF2SPitch > 0)
	{
		Schedule::Task(0.025f, "Fan2SNDStop");
	}

	if (iF2SPitch == 0)
	{
		Engine.Ent_Fire("snd_fan2", "Volume", "0");
	}
}

void TurnOnFan1()
{
	if (!bFan1IsOn)
	{
		bFan1IsOn = true;
		iF1SPitch = 0;
		Fan1SNDPlay();
		Engine.Ent_Fire("func_fan1", "start");
		Engine.Ent_Fire("fanpush", "enable", "0", "0.75");
	}
}

void TurnOffFan2()
{
	if (bFan2IsOn)
	{
		bFan2IsOn = false;
		iF2SPitch = 100;
		Fan2SNDStop();
		Engine.Ent_Fire("func_fan2", "stop");
		Engine.Ent_Fire("fanpush2", "disable", "0", "0.75");
	}
}