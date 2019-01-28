#include "cszm_random_def"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnMapInit()
{
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
}

void SetUpStuff()
{
	RemoveAmmoBar();
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	FlickerLight1();
	ChangeFog();
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