#include "cszm_modules/spawncrates"
#include "cszm_modules/barricadeammo"
#include "cszm_modules/lobbyambient"

const int TEAM_LOBBYGUYS = 0;

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

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

	iMinCrates = 1;
	iMaxCrates = 4;

	iMaxBarricade = 12;
	iMinBarricade = 4;

	g_PICOrigin.insertLast(Vector(-661.715, 487.519, -1215.51));
	g_PICOrigin.insertLast(Vector(719.118, 1402.53, -1135.04));
	g_PICOrigin.insertLast(Vector(714.735, 1335.2, -1135.58));
	g_PICOrigin.insertLast(Vector(216.396, 1550.16, -1135.5));
	g_PICOrigin.insertLast(Vector(-101.957, 1563.59, -1128.42));
	g_PICOrigin.insertLast(Vector(29.9501, 585.308, -919.582));
	g_PICOrigin.insertLast(Vector(25.0248, 226.476, -1215.5));
	g_PICOrigin.insertLast(Vector(41.3811, -281.985, -951.505));
	g_PICOrigin.insertLast(Vector(690.564, 642.899, -1215.55));
	g_PICOrigin.insertLast(Vector(483.639, -921.102, -1214.39));

	g_PICAngles.insertLast(QAngle(-0.0457825, -55.4922, -0.00650024));
	g_PICAngles.insertLast(QAngle(-0.0533273, -30.7486, 1.74876));
	g_PICAngles.insertLast(QAngle(-0.283024, 40.0352, -0.000915527));
	g_PICAngles.insertLast(QAngle(0.000625706, 45.1696, -0.000640869));
	g_PICAngles.insertLast(QAngle(-0.143524, 16.1076, -0.0185547));
	g_PICAngles.insertLast(QAngle(-0.0357275, 153.391, 179.869));
	g_PICAngles.insertLast(QAngle(0.00177929, 135.067, 0.00177985));
	g_PICAngles.insertLast(QAngle(-0.128871, -36.6698, -0.128876));
	g_PICAngles.insertLast(QAngle(-0.0151184, -38.4389, 0.188698));
	g_PICAngles.insertLast(QAngle(-0.781201, 41.2206, 0.181596));

	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);
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
	PropsSettings();
	Schedule::Task(0.5f, "SpawnCrates");
	Schedule::Task(0.5f, "SpawnBarricades");
}

void SetUpStuff()
{
	FindBarricades();
	RemoveItemCrate();
	Schedule::Task(Math::RandomFloat(4.32f, 35.14f), "SND_Ambient_Rats");
	Schedule::Task(Math::RandomFloat(12.85f, 175.35f), "SND_Ambient_Groan2");
	Schedule::Task(Math::RandomFloat(35.24f, 225.25f), "SND_Ambient_Thunder");
	Schedule::Task(Math::RandomFloat(45.75f, 250.00f), "SND_Ambient_Groan1");
	Schedule::Task(Math::RandomFloat(20.15f, 135.17f), "SND_Ambient_Siren");
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	Engine.Ent_Fire("shading", "StartOverlays");

	PlayLobbyAmbient();
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

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if (Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 200");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
		}

		else if (Utils.StrContains("PropaneCanister001a", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 85");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
			pEntity.SetHealth(5);
			pEntity.SetMaxHealth(5);
		}

		else if (Utils.StrContains("weak", pEntity.GetEntityName()))
		{
			pEntity.SetHealth(5);
			pEntity.SetMaxHealth(5);
		}

		else if(Utils.StrContains("bluebarrel001", pEntity.GetModelName()) || Utils.StrContains("Wheebarrow01a", pEntity.GetModelName()) || Utils.StrContains("trashdumpster01a", pEntity.GetModelName()))
		{
			pEntity.SetEntityName("unbrk");
		}

		else
		{
			int Health = int(pEntity.GetHealth() * 0.65f);
			pEntity.SetMaxHealth(PlrCountHP(Health));
			pEntity.SetHealth(PlrCountHP(Health));
		}
	}
}

void RemoveItemCrate()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_itemcrate")) !is null)
	{
		pEntity.SUB_Remove();
	}
}

int PlrCountHP(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
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