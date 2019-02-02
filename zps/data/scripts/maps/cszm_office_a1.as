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
	PropDoorHP();
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	
	Engine.Ent_Fire("tonemap", "SetBloomScale", "0.475");
	RemoveAmmoBar();
	VMSkins();
	RndSpawn();
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(0, 100);
		
		if(iRND < 47)
		{
			pEntity.SUB_Remove();
		}
	}
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
	int iRND_First = Math::RandomInt(0, 500);
	int iRND_Second = Math::RandomInt(0, 500);

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

void PropsHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("sofa", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(30));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(30));
		}
		else if(Utils.StrContains("fire_extinguisher", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(10);
			pEntity.SetHealth(10);
		}
		else if(Utils.StrContains("vending_machine", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(50));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(50));
		}
		else if(Utils.StrContains("helves_metal", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
		}
		else
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(15));
			pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(15));
		}
	}
}

void PropDoorHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + CalculateHealthPoints(6));
	}
}