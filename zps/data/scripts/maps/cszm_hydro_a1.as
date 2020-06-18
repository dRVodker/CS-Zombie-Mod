#include "cszm_modules/lobbyambient"

const int TEAM_LOBBYGUYS = 0;

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");

	iMinCrates = 4;
	iMaxCrates = 8;

	Schedule::Task(0.05f, "Hydro_FindCrates");
}

void OnNewRound()
{
	Engine.Ent_Fire("AmbientG", "StopSound");
	Engine.Ent_Fire("AmbientG", "PlaySound");
	Schedule::Task(0.05f, "SetUpStuff");
	Schedule::Task(0.05f, "Hydro_FindCrates");
}

void OnMatchBegin() 
{
	Engine.Ent_Fire("AmbientG", "PlaySound");
	Schedule::Task(0.5f, "SpawnCrates");
}

void SetUpStuff()
{
	Engine.Ent_Fire("AmbientG", "PlaySound");
	PlayLobbyAmbient();
}

void Hydro_FindCrates()
{
	CBaseEntity@ pEntity = null;

	while ((@pEntity = FindEntityByClassname(pEntity, "prop_itemcrate")) !is null)
	{
		pEntity.SUB_Remove();
	}
}