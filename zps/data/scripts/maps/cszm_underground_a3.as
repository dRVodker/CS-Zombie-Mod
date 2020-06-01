#include "cszm_modules/spawncrates"
#include "cszm_modules/lobbyambient"

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

	iMinCrates = 1;
	iMaxCrates = 6;

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
}

void OnNewRound()
{	
	Engine.Ent_Fire("SND_Ambient", "StopSound");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");

	Schedule::Task(0.025f, "SetUpStuff");
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnCrates");

	Engine.Ent_Fire("SND_Ambient", "PlaySound");
}

void SetUpStuff()
{
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	FlickerLight1();
	ChangeFog();
	PlayLobbyAmbient();
}

void OnProcessRound()
{

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