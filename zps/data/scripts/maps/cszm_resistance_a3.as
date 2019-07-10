#include "cszm_random_def"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();
}
/* //Walkaround to make a fade effect via AS
void WAFade(const string &in strTarName, CBaseEntity@ pEntity)
{
	iUNum++;
	pEntity.SetEntityName("PlrFade"+iUNum);
	Engine.Ent_Fire("PlrFade"+iUNum, "AddOutput", "OnUser1 "+strTarName+":fade:0:0:1");
	Engine.Ent_Fire_Ent(pEntity, "AddOutput", "OnUser1 "+strTarName+":fade:0:0:1");
	Engine.Ent_Fire("maker_trigger", "ForceSpawnAtEntityOrigin", "PlrFade"+iUNum);
}
*/
void OnNewRound()
{
	Engine.Ent_Fire("SND_Ambient", "StopSound");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	PropsSettings();
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
}

void SetUpStuff()
{
	RemoveAmmoBar();
	RemoveItemCrate();
	Schedule::Task(Math::RandomFloat(4.32f, 35.14f), "SND_Ambient_Rats");
	Schedule::Task(Math::RandomFloat(12.85f, 175.35f), "SND_Ambient_Groan2");
	Schedule::Task(Math::RandomFloat(35.24f, 225.25f), "SND_Ambient_Thunder");
	Schedule::Task(Math::RandomFloat(45.75f, 250.00f), "SND_Ambient_Groan1");
	Schedule::Task(Math::RandomFloat(20.15f, 135.17f), "SND_Ambient_Siren");
	Engine.Ent_Fire("Precache", "kill");
	Engine.Ent_Fire("SND_Ambient", "PlaySound");
	Engine.Ent_Fire("shading", "StartOverlays");
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
		else if(Utils.StrContains("PropaneCanister001a", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 85");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 200");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
		}
		else if(Utils.StrContains("wood_crate001", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(84));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(84));
		}
		else if(Utils.StrContains("wood_crate002", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(168));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(168));
		}
		else if(Utils.StrContains("PushCart01a", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(150));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(150));
		}
		else if(Utils.StrContains("bluebarrel001", pEntity.GetModelName()) || Utils.StrContains("Wheebarrow01a", pEntity.GetModelName()) || Utils.StrContains("trashdumpster01a", pEntity.GetModelName()))
		{
			pEntity.SetEntityName( "unbrk" );
//			pEntity.SetMaxHealth(99999);
//			pEntity.SetHealth(99999);
		}
		else
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(25));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(25));
		}
	}
}

void RemoveItemCrate()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_itemcrate")) !is null)
	{
		pEntity.SUB_Remove();
	}
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(1, 100);
		
		if(iRND < 60)
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

void SND_Ambient_Rats()
{
	Engine.Ent_Fire("rat", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(4.32f, 35.14f), "SND_Ambient_Rats");
}

void SND_Ambient_Groan2()
{
	Engine.Ent_Fire("groan2", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(37.85f, 175.35f), "SND_Ambient_Groan2");
}

void SND_Ambient_Siren()
{
	Engine.Ent_Fire("siren", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(40.15f, 135.17f), "SND_Ambient_Siren");
}

void SND_Ambient_Thunder()
{
	Engine.Ent_Fire("thunder", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(51.24f, 225.25f), "SND_Ambient_Thunder");
}

void SND_Ambient_Groan1()
{
	Engine.Ent_Fire("groan1", "PlaySound");
	
	Schedule::Task(Math::RandomFloat(103.75f, 250.00f), "SND_Ambient_Groan1");
}