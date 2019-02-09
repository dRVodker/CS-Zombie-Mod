#include "cszm_random_def"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iUNum = 0;

void OnMapInit()
{
	Events::Entities::OnEntityCreation.Hook(@OnEntityCreation);
	
	Entities::RegisterPickup("weapon_frag");
	Entities::RegisterDrop("weapon_frag");
	
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

array<Vector> g_vecCheeseOrigin =
{
	Vector(-1240, -256, 48),
	Vector(-883.99, -0.01, 288),
	Vector(-951.99, -112.01, 48.01),
	Vector(1536.01, 1083.99, 44.01),
	Vector(822.85, 909.08, 53.65),
	Vector(1368.07, 776.38, 232.18),
	Vector(441.88, 1093.9, 325.27),
	Vector(2415.95, -474.52, 84.27),
	Vector(937.86, -209.4, 117.63),
	Vector(1029.52, 216.92, -218.88)
};

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
	iUNum = 0;

	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("shading", "StartOverlays");
	Engine.Ent_Fire("-temp_wep_frag1", "ForceSpawn");
	Engine.Ent_Fire("-temp_wep_frag2", "ForceSpawn");
	Engine.Ent_Fire("-temp_wep_frag4", "ForceSpawn");
	Engine.Ent_Fire("-temp_wep_frag5", "ForceSpawn");
	
	Engine.Ent_Fire("item*", "DisableDamageForces");
	Engine.Ent_Fire("weapon*", "DisableDamageForces");
	
	RemoveAmmoBar();
	Cheese();
}

HookReturnCode OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{	
	if(pEntity.GetClassname() == "weapon_frag" && pEntity.GetHealth() > 0)
	{
		Engine.EmitSoundEntity(pEntity, "CS.ItemMaterialize");
		iUNum++;
		pEntity.SetEntityName("RE-ITEM"+iUNum);
		Engine.Ent_Fire("-maker_spark", "ForceSpawnAtEntityOrigin", "RE-ITEM"+iUNum);
		
		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}


HookReturnCode OnEndTouch(const string &in strEntityName, CBaseEntity@ pEntity)
{
	if(strEntityName == "bob_trigger" && pEntity.GetClassname() == "npc_grenade_frag")
	{	
		pEntity.SetHealth(25);
		Engine.Ent_Fire_Ent(pEntity, "ignite");
		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

void Cheese()
{
	if(int(Math::RandomInt(0, 100)) <= 75)
	{
		CBaseEntity@ pMakerCheese;
		@pMakerCheese = FindEntityByName(pMakerCheese, "maker_cheese");	
		pMakerCheese.SetAbsOrigin(g_vecCheeseOrigin[Math::RandomInt(0, 9)]);
		Engine.Ent_Fire_Ent(pMakerCheese, "ForceSpawn");
	}
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(1, 100);
		
		if(iRND < 45)
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
			pEntity.SetHealth(20);
		}
		else if(Utils.StrContains("oildrum001", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(75));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(75));
		}
		else if(Utils.StrContains("props_junk/glass", pEntity.GetModelName()))
		{
			pEntity.SetHealth(5);
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
		else if(Utils.StrContains("wood_crate001", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(32));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(32));
		}
		else if(Utils.StrContains("wood_crate002", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(64));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(64));
		}
		else if(Utils.StrContains("metal_panel02a", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(4));
			pEntity.SetHealth(CalculateHealthPoints(4));
		}
		else if(Utils.StrContains("bust", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(99999);
			pEntity.SetHealth(99999);
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
		if(Utils.StrContains("UselessBoards", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(3));
			pEntity.SetHealth(CalculateHealthPoints(3));
		}
		else if("glass" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(1));
			pEntity.SetHealth(CalculateHealthPoints(1));
		}
		else if("wood" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(25));
			pEntity.SetHealth(CalculateHealthPoints(25));
		}
		else if(Utils.StrContains("CeilingHatch", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(50));
			pEntity.SetHealth(CalculateHealthPoints(50));
		}
		else if(Utils.StrContains("AtticHatch", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(45));
			pEntity.SetHealth(CalculateHealthPoints(45));
		}
		else if(Utils.StrContains("sewer_cap", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(10));
			pEntity.SetHealth(CalculateHealthPoints(10));
		}
		else if(Utils.StrContains("lockers_breakable", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(11));
			pEntity.SetHealth(CalculateHealthPoints(11));
		}
	}
}

void PhysboxHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "func_physbox")) !is null)
	{
		if(Utils.StrContains("physd", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(CalculateHealthPoints(32));
			pEntity.SetHealth(CalculateHealthPoints(32));
		}
	}
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if(pEntity.GetClassname() == "weapon_frag" && pEntity.GetHealth() > 0)
	{
		Engine.Ent_Fire("-temp_wep_frag"+pEntity.GetHealth(), "ForceSpawn", "0", ""+Math::RandomFloat(4.25f, 6.15f));
		return;
	}
}

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if(pEntity.GetClassname() == "weapon_frag")
	{		
		pEntity.SetEntityName("_remove_me");
		Schedule::Task(0.15f, "RemoveThing");
	}
}

void RemoveThing()
{
	CBaseEntity@ pEntity;
	while((@pEntity = FindEntityByName(pEntity, "_remove_me")) !is null)
	{
		pEntity.SetEntityName("");
		pEntity.SUB_StartFadeOut(12.0f, false);
	}
}