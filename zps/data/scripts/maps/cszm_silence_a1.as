#include "cszm_random_def"

int iSurvInBasement;
bool bIsBZSEnabled;

void OnMapInit()
{
	Events::Trigger::OnStartTouch.Hook( @OnStartTouch );
	Events::Trigger::OnEndTouch.Hook( @OnEndTouch );
	Schedule::Task(0.05f, "SetStuff");
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetStuff");
}

void OnMatchStarting()
{
	bIsBZSEnabled = false;
}

void OnMatchBegin()
{
	Engine.Ent_Fire("zs_outside_pvs*", "EnableSpawn");
	Engine.Ent_Fire("zs_outside_base*", "EnableSpawn");
	Engine.Ent_Fire("zs_inside_pvs*", "EnableSpawn");
	Engine.Ent_Fire("zs_basement_ns_pvs*", "EnableSpawn");
	Engine.Ent_Fire("_temp_humanclip", "ForceSpawn");
	SetUpDoorHP();
	PropsSettings();
}

void SetStuff()
{
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("shading", "StartOverlays");
	RemoveAmmoBar();
}

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if("weak" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(15);
			pEntity.SetHealth(15);
		}
		else if(Utils.StrContains("gascan001a", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 85");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("wood_crate", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(50));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(50));
		}
		else
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(10));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(10));
		}
	}
}

void SetUpDoorHP()
{
	int iWoodDoorHP;
	int iMetalDoorHP;
	int iPlrNum = Utils.GetNumPlayers(any, true);
	if (iPlrNum >= 24)
	{
		iWoodDoorHP = 75;
		iMetalDoorHP = 100;
		DoorHP(iWoodDoorHP, iMetalDoorHP);
	}
	else if (iPlrNum >= 18)
	{
		iWoodDoorHP = 65;
		iMetalDoorHP = 85;
		DoorHP(iWoodDoorHP, iMetalDoorHP);
	}
	else if (iPlrNum >= 12)
	{
		iWoodDoorHP = 40;
		iMetalDoorHP = 75;
		DoorHP(iWoodDoorHP, iMetalDoorHP);
	}		
	else if (iPlrNum >= 6)
	{
		iWoodDoorHP = 25;
		iMetalDoorHP = 60;
		DoorHP(iWoodDoorHP, iMetalDoorHP);
	}	
	else if (iPlrNum >= 1)
	{
		iWoodDoorHP = 10;
		iMetalDoorHP = 30;
		DoorHP(iWoodDoorHP, iMetalDoorHP);
	}
}

void DoorHP(int &in iWoodDoorHP, int &in iMetalDoorHP)
{
	Engine.Ent_Fire("WoodDoor*", "SetDoorHealth", "" + iWoodDoorHP);
	Engine.Ent_Fire("FrontDoors", "SetDoorHealth", "" + iWoodDoorHP);
	Engine.Ent_Fire("MetalDoor*", "SetDoorHealth", "" + iMetalDoorHP);
	Engine.Ent_Fire("CrematoryDoors", "SetDoorHealth", "" + iMetalDoorHP);
}

HookReturnCode OnStartTouch(const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (pEntity is null) return HOOK_CONTINUE;
	
	if (pEntity.GetTeamNumber() == 2 && Utils.StrEql(strEntityName, "fog_volume"))
	{
		iSurvInBasement++;
		if(bIsBZSEnabled == false)
		{
			bIsBZSEnabled = true;
			string strInput = "FireUser1";
			ManipulateZS(strInput);
		}
		return HOOK_HANDLED;
	}
	return HOOK_CONTINUE;
}

HookReturnCode OnEndTouch(const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (pEntity is null) return HOOK_CONTINUE;
	
	if (pEntity.GetTeamNumber() == 2 && Utils.StrEql(strEntityName, "fog_volume"))
	{
		iSurvInBasement--;
		if(iSurvInBasement <= 0)
		{
			bIsBZSEnabled = false;
			string strInput = "FireUser2";
			ManipulateZS(strInput);
		}
	}
	return HOOK_CONTINUE;
}

void ManipulateZS(const string &in strInput)
{
	Engine.Ent_Fire("zs_outside_pvs", "" + strInput);
	Engine.Ent_Fire("zs_outside_base", "" + strInput);
	Engine.Ent_Fire("zs_inside_pvs", "" + strInput);
	Engine.Ent_Fire("zs_basement_ns_pvs", "" + strInput);
	Engine.Ent_Fire("zs_basement_pvs", "" + strInput);
}

int PlrCountHP(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(0, 100);
		
		if(iRND < 45)
		{
			pEntity.SUB_Remove();
		}
	}
}