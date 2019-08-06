#include "cszm/random_def"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnMapInit()
{	
	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();
}

void OnMatchBegin() 
{
	PropsSettings();
}

void SetUpStuff()
{
	int iRNDPitch = Math::RandomInt(65, 135);
	
	Engine.Ent_Fire("teleport_ambient", "Pitch", ""+iRNDPitch);
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitchstart "+iRNDPitch);
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitch "+iRNDPitch);
	
	Engine.Ent_Fire("teleport_ambient", "PlaySound");
	Engine.Ent_Fire("teleport_ambient", "Volume", "10");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	Engine.Ent_Fire("HumanSpawn*", "AddOutput", "OnPlayerSpawn !self:kill:0:0:1");
	
//	FixZSpawn();
	
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

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("PropaneCanister001a", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 85");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("cardboard_box004a", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 128");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
			pEntity.SetHealth(1);
		}
		else if(Utils.StrContains("propane_tank001a", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 128");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 200");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
			pEntity.SetHealth(20);
		}
		else if(Utils.StrContains("wood_crate002a", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(20));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(20));
		}
		else if(Utils.StrContains("wood_crate001a", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(10));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(10));
		}
		else if(Utils.StrContains("vent001", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(5);
			pEntity.SetHealth(5);
		}
		else if(Utils.StrContains("trashdumpster01a", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(99999);
			pEntity.SetHealth(99999);
		}
		else
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(10));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(10));
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

/*
void FixZSpawn()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_zombie")) !is null)
	{
		if(pEntity.GetAbsOrigin() == Vector(-1361.92, 2110.43, 889.001)) pEntity.SetAbsOrigin(Vector(-1350.92, 2110.43, 889.001));
		if(pEntity.GetAbsOrigin() == Vector(-2563.01, 1898.16, 1032)) pEntity.SetAbsOrigin(Vector(-2563.01, 1898.16, 1034));
	}
}
*/