#include "cszm_modules/spawncrates"
#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"

array<array<CSpawnPoint@>> ZombieSpawns = 
{
	{
		CSpawnPoint(Vector(1045.21, 1128.46, -255.969), QAngle(-13.2495, -169.969, 0), "info_player_zombie"),
		CSpawnPoint(Vector(1822.59, 896.683, -255.969), QAngle(-13.6125, -110.22, 0), "info_player_zombie")
	}
};

int iSurvInBasement;
bool bIsBZSEnabled;

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SURVIVORS = 2;

void OnMapInit()
{
	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Schedule::Task(0.05f, "SetStuff");

	iMinCrates = 0;
	iMaxCrates = 7;

	g_PICOrigin.insertLast(Vector(563.168, 1158.57, -255.513));
	g_PICAngles.insertLast(QAngle(0, -124.061, 0));

	g_PICOrigin.insertLast(Vector(1085.96, 604.511, -223.5));
	g_PICAngles.insertLast(QAngle(0, -37.9823, 0));

	g_PICOrigin.insertLast(Vector(1115.62, -514.564, -208.483));
	g_PICAngles.insertLast(QAngle(-90, 111.568, 180));

	g_PICOrigin.insertLast(Vector(1442.12, -710.87, -255.5));
	g_PICAngles.insertLast(QAngle(0, 45.9262, 0));

	g_PICOrigin.insertLast(Vector(1690.78, 607.679, -255.5));
	g_PICAngles.insertLast(QAngle(0, -57.5093, 0));

	g_PICOrigin.insertLast(Vector(906.575, 634.657, -111.649));
	g_PICAngles.insertLast(QAngle(0, 163.374, -90));

	g_PICOrigin.insertLast(Vector(424.675, -23.2762, -223.5));
	g_PICAngles.insertLast(QAngle(0, 43.616, 0));

	g_PICOrigin.insertLast(Vector(183.272, -179.602, -183.483));
	g_PICAngles.insertLast(QAngle(0, 1.70893, 0));

	g_PICOrigin.insertLast(Vector(772.598, -25.9671, -47.5992));
	g_PICAngles.insertLast(QAngle(0, 29.2479, 0));

	g_PICOrigin.insertLast(Vector(1056.26, -554.552, 65.8727));
	g_PICAngles.insertLast(QAngle(0, 99.0, 90));

	g_PICOrigin.insertLast(Vector(1599.29, 693.566, -47.5002));
	g_PICAngles.insertLast(QAngle(0, -90.216, 0));

	g_PICOrigin.insertLast(Vector(296.685, 869.228, -47.5395));
	g_PICAngles.insertLast(QAngle(0, 59.6748, 0));

	g_PICOrigin.insertLast(Vector(202.921, 257.598, -56.0867));
	g_PICAngles.insertLast(QAngle(12.8485, 37.5217, -16.111));

	g_PICOrigin.insertLast(Vector(1536.22, 475.612, -639.5));
	g_PICAngles.insertLast(QAngle(0, -40.5027, 0));

	g_PICOrigin.insertLast(Vector(744.534, -421.528, -575.5));
	g_PICAngles.insertLast(QAngle(0, 28.4555, 0));

	g_PICOrigin.insertLast(Vector(171.652, 1217.12, -727.493));
	g_PICAngles.insertLast(QAngle(0, 49.7227, 0));

	g_PICOrigin.insertLast(Vector(1417.45, 927.386, -766.622));
	g_PICAngles.insertLast(QAngle(0, -121.457, 0));

	g_PICOrigin.insertLast(Vector(2268.33, 549.154, -495.249));
	g_PICAngles.insertLast(QAngle(0, 136.575, 0));

	g_PICOrigin.insertLast(Vector(874.264, 582.238, -45.5426));
	g_PICAngles.insertLast(QAngle(0, 44.9195, 0));

	g_PICOrigin.insertLast(Vector(212.612, -481.648, -47.5002));
	g_PICAngles.insertLast(QAngle(-2.50223e-006, -125.909, 0));
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetStuff");
}

void OnMatchStarting()
{
	bIsBZSEnabled = false;
}

void OnMatchBegin()
{
	Schedule::Task(0.5f, "SpawnCrates");
}

void SetStuff()
{
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("shading", "StartOverlays");
	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(ZombieSpawns);
}

HookReturnCode OnPlayerSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (pBaseEnt.GetTeamNumber() != TEAM_LOBBYGUYS)
	{
		Engine.Ent_Fire_Ent(pBaseEnt, "SetFogController", "base_fog");
	}

	else
	{
		Engine.Ent_Fire_Ent(pBaseEnt, "SetFogController", "lobby_fog");
		PlayLobbyAmbient();
	}

	return HOOK_CONTINUE;	
}