#include "cszm_modules/spawndist"
#include "cszm_modules/spawncrates"

int iMaxPlayers;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();
	Schedule::Task(0.05f, "SetUpStuff");

	flMaxZSDist = 1850.0f;
	flMinZSDist = 1256.0f;
	flRoarDist = 512.0f;

	iMinCrates = 0;
	iMaxCrates = 4;

	//Spawn points for "prop_itemcrate"
	g_PICOrigin.insertLast(Vector(216.58, -1251.65, 25));
	g_PICAngles.insertLast(QAngle(0, 335, 0));
	
	g_PICOrigin.insertLast(Vector(-358, -1725.47, -428.97));
	g_PICAngles.insertLast(QAngle(0, 334.5, 0));
	
	g_PICOrigin.insertLast(Vector(-1529.76, -2106.13, -46));
	g_PICAngles.insertLast(QAngle(0, 336, 0));
	
	g_PICOrigin.insertLast(Vector(-884.28, -2330.05, -45));
	g_PICAngles.insertLast(QAngle(0, 315, 0));
	
	g_PICOrigin.insertLast(Vector(-971.61, -1969.15, -31.99));
	g_PICAngles.insertLast(QAngle(-87.95, 295.724, -14.0065));
	
	g_PICOrigin.insertLast(Vector(-261.09, -1809.13, 359.26));
	g_PICAngles.insertLast(QAngle(0, 314.5, 0));
	
	g_PICOrigin.insertLast(Vector(358.05, -384.85, 323));
	g_PICAngles.insertLast(QAngle(0, 136, 0));
	
	g_PICOrigin.insertLast(Vector(-608.12, -770.22, -330.15));
	g_PICAngles.insertLast(QAngle(0, 0, 90));
	
	g_PICOrigin.insertLast(Vector(-1150.88, -502.75, -392));
	g_PICAngles.insertLast(QAngle(0, 26, 0));
	
	g_PICOrigin.insertLast(Vector(-1037.5, -523.18, 86.58));
	g_PICAngles.insertLast(QAngle(0, 0, 0));
	
	g_PICOrigin.insertLast(Vector(556.78, -1107.16, -271.35));
	g_PICAngles.insertLast(QAngle(-28, 0, 0));
	
	g_PICOrigin.insertLast(Vector(-109.28, -1257.29, -305.83));
	g_PICAngles.insertLast(QAngle(-54.3743, 22.5675, 1.09255));
	
	g_PICOrigin.insertLast(Vector(-67.9, -1436.44, 173.59));
	g_PICAngles.insertLast(QAngle(-14, 0, 0));
}

void OnProcessRound()
{
	if (ZSpawnManager !is null)
	{
		ZSpawnManager.Think();
	}
}

void OnNewRound()
{	
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnCrates");
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
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("ventprop_junk", "DisableMotion");
	Engine.Ent_Fire("ventprop_junk", "DamageToEnableMotion 10");
	CreatedByColors();
}

void CreatedByColors()
{
	float flFireTime = Math::RandomFloat(0.10f, 1.20f);
	
	Schedule::Task(flFireTime, "CreatedByColors");
	
	int iR = Math::RandomInt(32, 255);
	int iG = Math::RandomInt(32, 255);
	int iB = Math::RandomInt(32, 255);
	
	Engine.Ent_Fire("created_by", "color", ""+iR+" "+iG+" "+iB);
}