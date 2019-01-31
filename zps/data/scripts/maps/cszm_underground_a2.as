#include "cszm_random_def"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iMaxPlayers;
const float flMaxDist = 1024;
const float flLastRadius = 384;
bool bAllowClearName = false;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();
	Schedule::Task(0.025f, "SetUpStuff");
}

void OnNewRound()
{	
	Engine.Ent_Fire("SND_Ambient", "StopSound");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");

	Schedule::Task(0.025f, "SetUpStuff");
}

void OnMatchBegin() 
{
	PropsSettings();
	PropDoorHP();
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	
	Schedule::Task(5.0f, "SpawnDist");
}

void SpawnDist()
{
	Schedule::Task(0.1f, "SpawnDist");

	int iLCount = 0;
	float flSDist;
	
	CBaseEntity@ pZSpawn;
	while ((@pZSpawn = FindEntityByClassname(pZSpawn, "info_player_zombie")) !is null)
	{
		for(int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);

			if(pPlayer is null) continue;

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if(pBaseEnt.GetTeamNumber() != 2) continue;
			
			flSDist = pZSpawn.Distance(pBaseEnt.GetAbsOrigin());
			
			if(flSDist < flMaxDist)
			{
				if(bAllowClearName == false) bAllowClearName = true;
				
				if(pZSpawn.GetEntityName() != "locked")
				{
					pZSpawn.SetEntityName("locked");
					Engine.Ent_Fire_Ent(pZSpawn, "EnableSpawn");
				}
			}
			else
			{
				if(pZSpawn.GetEntityName() != "locked" && pZSpawn.GetEntityName() != "disabled")
				{
					pZSpawn.SetEntityName("disabled");
					Engine.Ent_Fire_Ent(pZSpawn, "DisableSpawn");
				}
			}
		}
	}
	
	if(bAllowClearName == true)
	{
		CBaseEntity@ pZLockedSpawn;
		while ((@pZLockedSpawn = FindEntityByClassname(pZLockedSpawn, "info_player_zombie")) !is null)
		{
			if(pZLockedSpawn.GetEntityName() == "locked")
			{
				iLCount = 0;

				for(int i = 1; i <= iMaxPlayers; i++)
				{
					CZP_Player@ pPlayer = ToZPPlayer(i);

					if(pPlayer is null) continue;

					CBasePlayer@ pPlrEnt = pPlayer.opCast();
					CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
					
					if(pBaseEnt.GetTeamNumber() != 2) continue;
					
					flSDist = pZLockedSpawn.Distance(pBaseEnt.GetAbsOrigin());
					
					if(flSDist < flMaxDist) iLCount++;
				}
				
				for(int i = 1; i <= iMaxPlayers; i++)
				{
					CZP_Player@ pPlayer = ToZPPlayer(i);

					if(pPlayer is null) continue;

					CBasePlayer@ pPlrEnt = pPlayer.opCast();
					CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
						
					flSDist = pZLockedSpawn.Distance(pBaseEnt.GetAbsOrigin());
						
					if(flSDist > flMaxDist && pZLockedSpawn.GetEntityName() == "locked" && iLCount == 0) pZLockedSpawn.SetEntityName("");
				}
			}
		}
	}
	
	array<CBaseEntity@> g_pZSpawn;
	array<float> g_flZSDist;

	CBaseEntity@ pLocked = null;
	@pLocked = FindEntityByName(pLocked, "locked");
	
	if(pLocked is null)
	{
		if(bAllowClearName != false) bAllowClearName = false;
		
		CBaseEntity@ pFarZSpawn = null;
		
		while ((@pFarZSpawn = FindEntityByClassname(pFarZSpawn, "info_player_zombie")) !is null)
		{
			g_pZSpawn.insertLast(pFarZSpawn);
			g_flZSDist.insertLast(0.0f);
		}
		
		CBaseEntity@ pPlayer = null;
		
		for(uint ui = 0; ui < g_pZSpawn.length(); ui++)
		{
			while ((@pPlayer = FindEntityByClassname(pPlayer, "player")) !is null)
			{
				if(pPlayer.GetTeamNumber() == 2) g_flZSDist[ui] = g_pZSpawn[ui].Distance(pPlayer.GetAbsOrigin());
			}	
		}
		
		float flMinDist = g_flZSDist[0];
		
		for(uint ui = 0; ui < g_pZSpawn.length(); ui++)
		{
			if(flMinDist > g_flZSDist[ui]) flMinDist = g_flZSDist[ui];
		}
		
		CBaseEntity@ pLastZS;
		
		for(uint ui = 0; ui < g_pZSpawn.length(); ui++)
		{
			if(g_flZSDist[ui] == flMinDist)
			{
				g_pZSpawn[ui].SetEntityName("locked");
				Engine.Ent_Fire_Ent(g_pZSpawn[ui], "EnableSpawn");
				@pLastZS = g_pZSpawn[ui];
			}
		}
		
		for(uint ui = 0; ui < g_pZSpawn.length(); ui++)
		{
			float flLDist = g_pZSpawn[ui].Distance(pLastZS.GetAbsOrigin());
			if(flLDist < flLastRadius)
			{
				g_pZSpawn[ui].SetEntityName("locked");
				Engine.Ent_Fire_Ent(g_pZSpawn[ui], "EnableSpawn");
			}
		}
	}
}

void SetUpStuff()
{
	int iNumbers = 0;
	RemoveAmmoBar();
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	FlickerLight1();
	ChangeFog();
	
	CBaseEntity@ pZSpawn;
	while ((@pZSpawn = FindEntityByClassname(pZSpawn, "info_player_zombie")) !is null)
	{
		pZSpawn.SetEntityName("");
		Engine.Ent_Fire_Ent(pZSpawn, "AddOutput", "minspawns 0");
		Engine.Ent_Fire_Ent(pZSpawn, "AddOutput", "mintime 1");
	}
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
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(25));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(25));
		}
	}
}

void PropDoorHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		if(Utils.StrContains("doormainmetal01.mdl", pEntity.GetModelName()))
		{
			if("security_door" == pEntity.GetEntityName()) Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", ""+PlrCountHP(11));
			else Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", ""+PlrCountHP(6));
		}
	}
}

void ChangeFog()
{
	CBaseEntity@ pEntity = FindEntityByClassname(pEntity, "env_fog_controller");
	Engine.Ent_Fire_Ent(pEntity, "SetStartDist", "-128");
	Engine.Ent_Fire_Ent(pEntity, "SetEndDist", "4096");
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(1, 100);
		
		if(iRND < 35)
		{
			pEntity.SUB_Remove();
		}
	}
}

int PlrCountHP(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
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