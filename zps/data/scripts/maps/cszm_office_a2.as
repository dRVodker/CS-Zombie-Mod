#include "cszm_modules/lobbyambient"

const int TEAM_LOBBYGUYS = 0;

void OnMapInit() 
{
	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);

	Schedule::Task(0.05f, "SetUpStuff");
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
	int iRND_First = Math::RandomInt(0, 100);
	int iRND_Second = Math::RandomInt(0, 100);

	if(iRND_First >= iRND_Second) 
	{
		Engine.Ent_Fire("Human-CTerrorisSpawns", "Kill");
		Engine.Ent_Fire("Zombie-TerrorisSpawns", "Kill");
	}

	else
	{
		Engine.Ent_Fire("Zombie-CTerrorisSpawns", "Kill");
		Engine.Ent_Fire("Human-TerrorisSpawns", "Kill");
	}
}