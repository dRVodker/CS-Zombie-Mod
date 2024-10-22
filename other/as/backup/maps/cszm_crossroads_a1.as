#include "cszm_modules/spawncrates"
#include "cszm_modules/lobbyambient"
#include "cszm_modules/tspawn"

const int TEAM_LOBBYGUYS = 0;

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");

	TerroristsSpawn.insertLast("0|-1443 1979 -214|-1443 2051 -214|-1443 2123 -214|-1443 2195 -214|180 1052 1355 -214|180 1052 1427 -214|180 1052 1499 -214|180 1052 1571 -214");

	iMinCrates = 0;
	iMaxCrates = 4;

	g_PICOrigin.insertLast(Vector(687.176, 518.164, 144.499));
	g_PICAngles.insertLast(QAngle(0, -39.3396, 0));

	g_PICOrigin.insertLast(Vector(215.928, 12.7174, 0.4998));
	g_PICAngles.insertLast(QAngle(0, 37.7857, 0));

	g_PICOrigin.insertLast(Vector(196.874, 2199.98, 0.487563));
	g_PICAngles.insertLast(QAngle(0, 160.113, 0));

	g_PICOrigin.insertLast(Vector(-869.544, 2198.39, -175.023));
	g_PICAngles.insertLast(QAngle(0, -29.4917, 0));

	g_PICOrigin.insertLast(Vector(320.141, 2748.25, 175.867));
	g_PICAngles.insertLast(QAngle(0, 6.47761, 0));

	g_PICOrigin.insertLast(Vector(198.54, 866.949, 292.692));
	g_PICAngles.insertLast(QAngle(0, 156.909, 0));

	g_PICOrigin.insertLast(Vector(-1188.67, 825.958, 16.4363));
	g_PICAngles.insertLast(QAngle(0, 126.38, 0));

	g_PICOrigin.insertLast(Vector(1034.61, 1747.99, -215.5));
	g_PICAngles.insertLast(QAngle(0, -41.8031, 0));

	g_PICOrigin.insertLast(Vector(-401.409, 1566.96, 152.901));
	g_PICAngles.insertLast(QAngle(0, -53.3466, 0));

	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);
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
	
//	Engine.Ent_Fire("tonemap", "SetBloomScale", "0.475");
	PropSkins();
	OpenDoors();
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

void OpenDoors()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "FireUser1");
	}
	
	Engine.Ent_Fire("H-OF*", "Kill", "0", "0.85");
}

void PropSkins()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("vending_machine", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", "" + Math::RandomInt(0, 2));
		}

		else if(Utils.StrContains("oildrum001", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", "" + Math::RandomInt(0, 5));
		}
	}
}