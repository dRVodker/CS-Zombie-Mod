#include "cszm_modules/random_def"
#include "cszm_modules/doorset"
#include "cszm_modules/spawncrates"
#include "cszm_modules/barricadeammo"
#include "cszm_modules/lobbyambient"

const int TEAM_LOBBYGUYS = 0;

int CalculateHealthPoints(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();

	iMaxBarricade = 8;
	iMinBarricade = 6;

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
}

void OnNewRound()
{	
	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();
}

void OnMatchBegin() 
{
	PropsHP();
	BreakableHP();
	PropDoorHP();
	Schedule::Task(0.5f, "SpawnCrates");
	Schedule::Task(0.5f, "SpawnBarricades");
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	Engine.Ent_Fire("SND-Ambient", "Volume", "10");

	Engine.Ent_Fire("blade", "SetDamageFilter", "filter_null");
	FindBarricades();
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

void PropsHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		int Health = int(pEntity.GetHealth() * 0.65f);
		pEntity.SetMaxHealth(PlrCountHP(Health));
		pEntity.SetHealth(PlrCountHP(Health));
	}
}

void BreakableHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "func_breakable")) !is null)
	{
		pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
		pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
	}
}