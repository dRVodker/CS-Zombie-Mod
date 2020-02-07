#include "cszm_modules/spawncrates"
#include "cszm_modules/lobbyambient"
#include "cszm_modules/tspawn"

const int TEAM_LOBBYGUYS = 0;

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");

	iMinCrates = 0;
	iMaxCrates = 4;

	g_PICAngles.insertLast(QAngle(-2.45, -52.38, 0));
	g_PICAngles.insertLast(QAngle(-1.1, -132.475, 1.39));
	g_PICAngles.insertLast(QAngle(0, -12.6762, 0));
	g_PICAngles.insertLast(QAngle(-7.46603, -40.4338, 2.6239));
	g_PICAngles.insertLast(QAngle(-1.204, -17.697, 0.193198));
	g_PICAngles.insertLast(QAngle(1.76, -35.6631, 0.054));
	g_PICAngles.insertLast(QAngle(0, -168.769, 0.08));
	g_PICAngles.insertLast(QAngle(0, 153.966, 0));
	g_PICAngles.insertLast(QAngle(0, -59.1124, 0));
	g_PICAngles.insertLast(QAngle(5.3, -67.3699, 5.3));

	g_PICOrigin.insertLast(Vector(447.475, 2152.51, 0.4998));
	g_PICOrigin.insertLast(Vector(-569.618, 1811.43, 128.5));
	g_PICOrigin.insertLast(Vector(-1214.02, 938.47, 209.026));
	g_PICOrigin.insertLast(Vector(772.269, 787.876, 140.223));
	g_PICOrigin.insertLast(Vector(344.928, 3696.49, 128.449));
	g_PICOrigin.insertLast(Vector(-317.804, 2852.49, 128.485));
	g_PICOrigin.insertLast(Vector(-1480.47, 1346.19, 256.481));
	g_PICOrigin.insertLast(Vector(-703.085, 2070.37, 432.461));
	g_PICOrigin.insertLast(Vector(791.813, 1367.01, 480.462));
	g_PICOrigin.insertLast(Vector(660.53, 3056.13, 128.5));

	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);

	TerroristsSpawn.insertLast("90|1441 2065 129|1313 2065 129|270 1313 2287 129|270 1441 2287 129|0 -879 3105 129|0 -879 2977 129|180 -657 2977 129|180 -657 3105 129");
	TerroristsSpawn.insertLast("0|-1536 1964 129|-1536 1920 129|-1536 1876 129|-1492 1964 129|-1492 1920 129|-1492 1876 129|-1204 1964 129|-1204 1876 129|90 288 1752 -127|90 224 1752 -127|90 160 1752 -127|270 288 1944 -127|270 224 1944 -127|270 160 1944 -127");
	TerroristsSpawn.insertLast("0|45 -1648 1760 129|270 -768 3073 129|315 41 2003 -127|270 468 2132 1|180 1407 2176 129|315 160 1120 281|45 -224 1056 65|135 -428 938 129|-599 2090 129");
}

void OnNewRound()
{	
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnCrates");
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	Engine.Ent_Fire("SND-Ambient", "Volume", "10");

	PlayLobbyAmbient();
	CreateTerroristsSpawn();
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