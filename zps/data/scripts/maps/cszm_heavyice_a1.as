#include "cszm_random_def"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnMapInit()
{
	Entities::RegisterDamaged("breen");
	Entities::RegisterDamaged("body");
	
	Entities::RegisterUse("that_lamp");
	
	Entities::RegisterPickup("item_ammo_pistol");
	Entities::RegisterPickup("item_ammo_revolver");
	Entities::RegisterPickup("item_ammo_rifle");
	Entities::RegisterPickup("item_ammo_shotgun");
	Entities::RegisterPickup("item_armor");
	
	Events::Trigger::OnEndTouch.Hook(@OnEndTouch);
	
	Schedule::Task(0.01f, "SetUpStuff");
	OverrideLimits();
}

int CalculateHealthPoints(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}

void OnNewRound()
{
	Schedule::Task(0.01f, "SetUpStuff");
}

void OnMatchBegin()
{
	PropsSettings();
	BreakableHP();
	PhysboxHP();
}

void SetUpStuff()
{
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("vrad_shadows", "kill");
	Engine.Ent_Fire("temp_expbarrel*", "ForceSpawn");
	Engine.Ent_Fire("lobby_*", "Disable");	
	Engine.Ent_Fire("shading", "StartOverlays");	
	
	Engine.Ent_Fire("item*", "DisableDamageForces");
	Engine.Ent_Fire("weapon*", "DisableDamageForces");
	
	RemoveAmmoBar();
	
	switch(Math::RandomInt(1,3))
	{
		case 1:
			Engine.Ent_Fire("lobby_knockknock", "Enable");
		break;
		
		case 2:
			Engine.Ent_Fire("lobby_raul", "Enable");
		break;
		
		case 3:
			Engine.Ent_Fire("lobby_deepcover", "Enable");
		break;
	}
}

HookReturnCode OnEndTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if(strEntityName == "bob_trigger" && pEntity.GetClassname() == "npc_grenade_frag")
	{	
		pEntity.SetHealth(25);
		Engine.Ent_Fire_Ent(pEntity, "ignite");
		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

void OnEntityDamaged(CBaseEntity@ pAttacker, CBaseEntity@ pEntity)
{
	if(pEntity.GetEntityName() == "breen") Engine.EmitSoundEntity(pEntity, "HeavyIce.BustPain");
	if(pEntity.GetEntityName() == "body") Engine.EmitSoundEntity(pEntity, "Character_Eugene.Pain");
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	if(pEntity.GetEntityName() == "that_lamp" && pBaseEnt.GetTeamNumber() == 2) Engine.Ent_Fire("HiddenDoor", "Open");
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(1, 100);
		
		if(iRND < 30)
		{
			pEntity.SUB_Remove();
		}
	}
}

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 400");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 350");
		}
		else if(Utils.StrContains("wooden_shelf01", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
		}
		else if(Utils.StrContains("shelfunit01", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(30));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(30));
		}
		else if(Utils.StrContains("BlueCrate", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
		}
		else if(Utils.StrContains("cheese", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(250);
			pEntity.SetHealth(250);
		}
		else if(Utils.StrContains("watermelon", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(250);
			pEntity.SetHealth(250);
		}
		else if(Utils.StrContains("props_junk/glass", pEntity.GetModelName()))
		{
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("RedCrate", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(50));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(50));
		}
		else if(Utils.StrContains("breen", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(250));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(250));
		}
		else
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(5));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(5));
		}
	}
}

void BreakableHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "func_breakable")) !is null)
	{
		if(Utils.StrContains("wood", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(17));
			pEntity.SetHealth(CalculateHealthPoints(17));
		}
		else if("powerbox_small" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(20));
			pEntity.SetHealth(CalculateHealthPoints(20));
		}
		else if("powerbox_large" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(45));
			pEntity.SetHealth(CalculateHealthPoints(45));
		}
		else if(Utils.StrContains("glass", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(3));
			pEntity.SetHealth(CalculateHealthPoints(3));
		}
		else if(Utils.StrContains("Tram-Stair", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(25));
			pEntity.SetHealth(CalculateHealthPoints(25));
		}
		else if(Utils.StrContains("BalconyFenceSmall", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(35));
			pEntity.SetHealth(CalculateHealthPoints(35));
		}
		else if(Utils.StrContains("UppedBoards", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(4));
			pEntity.SetHealth(CalculateHealthPoints(4));
		}
		else if("BalconyFloor" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(450);
			pEntity.SetHealth(450);
		}
		else if("Tram-Ceiling" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(40));
			pEntity.SetHealth(CalculateHealthPoints(40));
		}
		else if("Dick-Hook" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(25));
			pEntity.SetHealth(CalculateHealthPoints(25));
		}
		else if("RoofAccess" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(21));
			pEntity.SetHealth(CalculateHealthPoints(21));
		}
		else if("HiddenDoor-Breakable" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(41));
			pEntity.SetHealth(CalculateHealthPoints(41));
		}
		else if("KD-MetalBreakable" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(84));
			pEntity.SetHealth(CalculateHealthPoints(84));
		}
		else if("BalconyGrate" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(62));
			pEntity.SetHealth(CalculateHealthPoints(62));
		}
		else if("mysticism" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(200);
			pEntity.SetHealth(200);
		}
		else if("win-fence" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(62));
			pEntity.SetHealth(CalculateHealthPoints(62));
		}
	}
}

void PhysboxHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "func_physbox")) !is null)
	{
		if(Utils.StrContains("physdoor", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(32));
			pEntity.SetHealth(CalculateHealthPoints(32));
		}
		else if("body" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(1750);
			pEntity.SetHealth(1750);
		}
	}
}