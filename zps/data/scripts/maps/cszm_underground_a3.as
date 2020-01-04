#include "cszm_modules/random_def"
#include "cszm_modules/doorset"
#include "cszm_modules/spawncrates"
#include "cszm_modules/barricadeammo"
#include "cszm_modules/lobbyambient"
#include "cszm_modules/spawndist"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SURVIVORS = 2;

int iMaxPlayers;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();
	Schedule::Task(0.025f, "SetUpStuff");

	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);

	flMinZSDist = 631.0f;

	iMaxBarricade = 19;
	iMinBarricade = 7;

	iMinCrates = 0;
	iMaxCrates = 5;

	g_PICOrigin.insertLast(Vector(-202.258, 3106.7, 36.4784));
	g_PICAngles.insertLast(QAngle(0, -23.3962, 0));

	g_PICOrigin.insertLast(Vector(-709.278, 2568.18, -95.5102));
	g_PICAngles.insertLast(QAngle(0, -21.5856, 0));

	g_PICOrigin.insertLast(Vector(-1824.23, 3296.78, -87.5186));
	g_PICAngles.insertLast(QAngle(0, -49.2699, 0));

	g_PICOrigin.insertLast(Vector(-2168.22, 590.721, -63.5755));
	g_PICAngles.insertLast(QAngle(0, 105.523, 0));

	g_PICOrigin.insertLast(Vector(-1079.64, 728.415, -95.5002));
	g_PICAngles.insertLast(QAngle(0, 31.9734, 0));

	g_PICOrigin.insertLast(Vector(757.196, 88.6725, -95.5002));
	g_PICAngles.insertLast(QAngle(0, 30.251, 0));

	g_PICOrigin.insertLast(Vector(1793.23, 1377.68, -31.5357));
	g_PICAngles.insertLast(QAngle(0, 33.0636, 0));

	g_PICOrigin.insertLast(Vector(1544.52, 1982.43, -415.531));
	g_PICAngles.insertLast(QAngle(0, -49.9025, 0));

	g_PICOrigin.insertLast(Vector(1538.92, 1938.98, -415.504));
	g_PICAngles.insertLast(QAngle(0, -90.4959, 0));

	g_PICOrigin.insertLast(Vector(-1118.18, 1793.79, -95.5098));
	g_PICAngles.insertLast(QAngle(0, -62.8027, 0));

	g_PICOrigin.insertLast(Vector(1059.76, 1279.23, -222.523));
	g_PICAngles.insertLast(QAngle(0, -151.2, 0));

	g_PICOrigin.insertLast(Vector(-1068.36, 977.885, 16.3951));
	g_PICAngles.insertLast(QAngle(0, 3.08162, 0));

	OverrideLimits();
}

void OnNewRound()
{	
	Engine.Ent_Fire("SND_Ambient", "StopSound");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");

	Schedule::Task(0.025f, "SetUpStuff");
	OverrideLimits();
}

void OnMatchBegin() 
{
	PropsSettings();
	PropDoorHP();

	Schedule::Task(0.5f, "SpawnCrates");
	Schedule::Task(0.5f, "SpawnBarricades");

	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	
	Schedule::Task(5.0f, "SpawnDist");
}

void OnMatchStarting()
{
	@ZSpawnManager = CZSpawnManager();
}

void OnMatchEnded()
{
	@ZSpawnManager = null;
}

void SetUpStuff()
{
	FindBarricades();
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	FlickerLight1();
	ChangeFog();
	PlayLobbyAmbient();
}

void OnProcessRound()
{
	if (ZSpawnManager !is null)
	{
		ZSpawnManager.Think();
	}
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

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 200");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
		}

		else if(Utils.StrContains("wood_crate", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(50));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(50));
		}

		else if(Utils.StrContains("plasma_53", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(5);
			pEntity.SetHealth(5);
		}
		
		else if(Utils.StrContains("fire_extinguisher", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(5);
			pEntity.SetHealth(5);
		}

		else if(Utils.StrContains("interior_fence001g", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(45));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(45));
		}

		else
		{
			int Health = int(pEntity.GetHealth() * 0.5f);
			pEntity.SetMaxHealth(PlrCountHP(Health));
			pEntity.SetHealth(PlrCountHP(Health));
		}
	}
}

void ChangeFog()
{
	CBaseEntity@ pEntity = FindEntityByClassname(pEntity, "env_fog_controller");
	pEntity.SetEntityName("my_fog");
	Engine.Ent_Fire("my_fog", "SetStartDist", "-128");
	Engine.Ent_Fire("my_fog", "SetEndDist", "4096");
}

void FlickerLight1()
{
	float flInterval = Math::RandomFloat(0.085, 0.35);
	float flOffInterval = Math::RandomFloat(0.05, 0.20);
	Engine.Ent_Fire("FL-Prop1", "skin", "1");
	Engine.Ent_Fire("FL-Light1", "TurnOn");
	Engine.Ent_Fire("FL-Spr1", "ShowSprite");
	
	Schedule::Task(flOffInterval, "FlickerLight1Off");
	Schedule::Task(flInterval, "FlickerLight1");
}

void FlickerLight1Off()
{
	Engine.Ent_Fire("FL-Prop1", "skin", "0");
	Engine.Ent_Fire("FL-Light1", "TurnOff");
	Engine.Ent_Fire("FL-Spr1", "HideSprite");
}