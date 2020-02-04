#include "cszm_modules/lobbyambient"
#include "cszm_modules/tspawn"

const int TEAM_LOBBYGUYS = 0;

void OnMapInit() 
{
	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);

	Schedule::Task(0.05f, "SetUpStuff");

	TerroristsSpawn.insertLast("90|1408 672 -159|1408 608 -159|1472 544 -159|180 1736 712 -159|270 976 -64 -159|270 920 -208 -159"); //T Spawn - 0
	TerroristsSpawn.insertLast("90|-1136 -1344 -335|-1136 -1280 -335|-1248 -1280 -335|-1248 -1344 -335|270 168 -1600 -335|270 232 -1600 -335|270 296 -1600 -335|270 296 -1664 -335"); //CT Spawn - 1
	TerroristsSpawn.insertLast("r|270 -1008 1248 -335|0 -1376 464 -285.37|270 -1192 336 -325|-736 232 -367|0 -1464 -1664 -335|270 -968 -1600 -335|-745 -824 -328|-649 -760 -332|180 -401 -952 -175|90 424 -2144 -335|180 1400 -1488 -328|270 296 -1600 -335|0 304 -1328 -279"); //Random Spawn - 2
}

void OnNewRound() 
{	
	Schedule::Task(0.05f, "SetUpStuff");
}

void SetUpStuff() 
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	
	Engine.Ent_Fire("tonemap", "SetBloomScale", "0.475");
	Engine.Ent_Fire("extinguisher", "Addoutput", "damagetoenablemotion 500");

	VMSkins();
	RndSpawn();
	OpenDoors();
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

void OpenDoors() 
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null) 
	{
		Engine.Ent_Fire_Ent(pEntity, "FireUser1");
	}
	
	Engine.Ent_Fire("H-OF*", "Kill", "0", "0.85");
}

void VMSkins() 
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null) 
	{
		if(Utils.StrContains("vending_machine", pEntity.GetModelName())) 
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", ""+Math::RandomInt(0, 2));
		}
	}
}

void RndSpawn() 
{
	int iTSpawnIndex = CreateTerroristsSpawn();
	int iRND_First = Math::RandomInt(0, 100);
	int iRND_Second = Math::RandomInt(0, 100);

	if (iTSpawnIndex == 0)
	{
		iRND_First = -1;
		iRND_Second = 1;	
	}
	else if (iTSpawnIndex == 1)
	{
		iRND_First = 1;
		iRND_Second = -1;		
	}

	if(iRND_First >= iRND_Second) 
	{
		Engine.Ent_Fire("Human-CTerrorisSpawns", "Kill");
	}
	else
	{
		Engine.Ent_Fire("Human-TerrorisSpawns", "Kill");
	}
}