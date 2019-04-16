#include "cszm_random_def"
#include "cszm_doorset"

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
	OverrideLimits();
}

void OnNewRound()
{	
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	PropsHP();
	BreakableHP();
	PropDoorHP();
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	Engine.Ent_Fire("SND-Ambient", "Volume", "10");
	RemoveAmmoBar();
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(0, 100);
		
		if(iRND < 75)
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
		pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
		pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
	}
}

void BreakableHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "func_breakable")) !is null)
	{
		pEntity.SetMaxHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
		pEntity.SetHealth(pEntity.GetHealth() + CalculateHealthPoints(25));
	}
}