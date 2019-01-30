#include "cszm_random_def"

int CalculateHealthPoints(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}

void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnNewRound()
{	
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	PropsHP();
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	RemoveAmmoBar();
	CreatedByColors();
}

void CreatedByColors()
{
	float flFireTime = Math::RandomFloat(0.10f, 1.20f);
	
	Schedule::Task(flFireTime, "CreatedByColors");
	
	int iR = Math::RandomInt(32, 255);
	int iG = Math::RandomInt(32, 255);
	int iB = Math::RandomInt(32, 255);
	
	Engine.Ent_Fire("created_by", "color", ""+iR+" "+iG+" "+iB);
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

void PropsHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("vent001", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(5);
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(20);
			pEntity.SetHealth(20);
		}
		else if(Utils.StrContains("canister0", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(5);
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("gascan001a", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(5);
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("PropaneCanister001a", pEntity.GetModelName()))
		{
			pEntity.SetHealth(5);
		}
		else
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(20));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(20));
		}
	}
}