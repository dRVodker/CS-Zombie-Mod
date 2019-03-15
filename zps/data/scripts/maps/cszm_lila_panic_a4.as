#include "cszm_random_def"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

//Some Data
int iUNum;
int iFireflyIndex;

int iSSCount;

bool bAllowFirefly;
bool bIsFireflyPikedUp;

//List of item and weapon classnames
array<string> g_strClassnames =
{
	"weapon_ppk", //0
	"weapon_usp", //1
	"weapon_glock", //2
	"weapon_glock18c", //3
	"weapon_revolver", //4
	"weapon_mp5", //5
	"weapon_m4", //6
	"weapon_ak47", //7
	"weapon_supershorty", //8
	"weapon_winchester", //9
	"weapon_870", //10
	"weapon_frag", //11
	"weapon_ied", //12
	"item_ammo_pistol_clip", //13
	"item_ammo_rifle_clip", //14
	"item_ammo_shotgun_clip", //15
	"item_ammo_revolver_clip", //16
	"weapon_inoculator_delay" //17
};

//Other Data (Don't even touch this)
bool bAllowSPB = false;

void OnMapInit()
{
	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Events::Trigger::OnStartTouch.Hook(@OnStartTouch);
	Entities::RegisterUse("spec_button");

	Engine.Ent_Fire("breencrate", "FireUser1", "", "0.01");
	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();
}

HookReturnCode OnPlayerSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	if(pBaseEnt.entindex() == iFireflyIndex && pBaseEnt.GetTeamNumber() != 1 || pBaseEnt.GetTeamNumber() != 0)
	{
		iFireflyIndex = 0;
		Engine.Ent_Fire("spec_sprite", "kill");
	}
	
	if(pBaseEnt.GetTeamNumber() != 0)
	{
		iUNum++;
		pBaseEnt.SetEntityName("FOGGUY"+iUNum);
		Engine.Ent_Fire("FOGGUY"+iUNum, "SetFogController", "main_insta_fog");
	}
	
	return HOOK_HANDLED;
}

HookReturnCode OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if(pEntity.GetTeamNumber() == 0 && pEntity.IsPlayer() == true && strEntityName == "fog_volume_lobby")
	{
		iUNum++;
		pEntity.SetEntityName("FOGGUY"+iUNum);
		Engine.Ent_Fire("FOGGUY"+iUNum, "SetFogController", "lobby_fog");
	}

	return HOOK_HANDLED;
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if(pEntity.GetEntityName() == "spec_button" && pBaseEnt.GetTeamNumber() == 0 && bAllowFirefly == true)
	{
		Firefly(pBaseEnt);
		pEntity.SUB_Remove();
	}
}

void OnNewRound()
{
	iSSCount = 0;
	bAllowFirefly = false;
	bIsFireflyPikedUp = false;
	iFireflyIndex = 0;
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	PropDoorHP();
	BreakableHP();
	PropsHP();
	Schedule::Task(0.50f, "AllowFirefly");
}

void AllowFirefly()
{
	bAllowFirefly = true;
}

void SetUpStuff()
{
	iUNum = 0;
	VMSkins();
	RandomizePropCrate();
	RemoveAmmoBar();
}

// Random Skins for the vending machines
void VMSkins()
{
	for(int i = 1; i <= 10; i++)
	{
		Engine.Ent_Fire("vm"+i, "Skin", ""+Math::RandomInt(0, 2));
	}
}

//Setiing HP of 'prop_door_rotating'
void PropDoorHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		if(Utils.StrContains("doormainmetal01.mdl", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", ""+PlrCountHP(7));
		}
		if(Utils.StrContains("doormain01.mdl", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", ""+PlrCountHP(6));
		}
	}
}

//Setiing HP of 'func_breakable'
void BreakableHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "func_breakable")) !is null)
	{
		if("TrashDumpster-Helper" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(PlrCountHP(25));
			pEntity.SetHealth(PlrCountHP(25));
		}
		
		if("Container-Helper" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(PlrCountHP(25));
			pEntity.SetHealth(PlrCountHP(25));
		}
		
		if("ContainerBDoor1" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(PlrCountHP(50));
			pEntity.SetHealth(PlrCountHP(50));
		}
		
		if("ContainerBDoor2" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(PlrCountHP(50));
			pEntity.SetHealth(PlrCountHP(50));
		}
	}
}

//Setiing HP of 'prop_physics_multiplayer'
void PropsHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if("Oildrums-Solid" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(75));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(75));
		}
		
		else if(Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeDamage 200");
			Engine.Ent_Fire_Ent(pEntity, "addoutput", "ExplodeRadius 256");
		}
		
		else if("Sofa-Solid" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(55));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(55));
		}
		
		else if("Shelves-Solid" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(50));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(50));
		}
		
		else if(Utils.StrContains("vm", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(100));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(100));
		}
		
		else if(Utils.StrContains("Pallet", pEntity.GetEntityName()))
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(30));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(30));
		}
		
		else if("phys_cars" == pEntity.GetEntityName())
		{
			pEntity.SetMaxHealth(999999);
			pEntity.SetHealth(999999);
		}
		
		else
		{
			pEntity.SetMaxHealth(pEntity.GetHealth() + PlrCountHP(5));
			pEntity.SetHealth(pEntity.GetHealth() + PlrCountHP(5));
		}
	}
}

//Remove extra 'item_ammo_barricade'
void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		iRND = Math::RandomInt(1, 100);
		
		if(iRND < 80)
		{
			pEntity.SUB_Remove();
		}
	}
}

//Setting a random classname and count of item to 'prop_itemcrate'
void RandomizePropCrate()
{
	int iUN = 0;
	
	int iRND;
	int iRND_Class;
	int iRND_Count;
	
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_itemcrate")) !is null)
	{
		iRND = Math::RandomInt(1, 100);
		
		if(iRND > 32)
		{
			if(pEntity.GetEntityName() != "breencrate")
			{
				int iRND_Type = Math::RandomInt(1, 10);

				if(iRND_Type < 5) iRND_Class = Math::RandomInt(0, 10);
				else if(iRND_Type == 1) iRND_Class = Math::RandomInt(0, 17);
				else iRND_Class = Math::RandomInt(11, 17);
				iRND_Count = Math::RandomInt(1, 3);	//Count of weapons
				
				if(iRND_Class < 13) iRND_Class = Math::RandomInt(3, 16);
				
				if(iRND_Class == 11 || iRND_Class == 12) iRND_Count = Math::RandomInt(3, 4);	//Count of frag and ied
				if(iRND_Class >= 13 && iRND_Class <= 16) iRND_Count = Math::RandomInt(1, 3);	//Count of ammo
				if(iRND_Class == 17) iRND_Count = Math::RandomInt(1, 2);	//Count of armor
				
				Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemCount "+iRND_Count);
				Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemClass "+g_strClassnames[iRND_Class]);
			}
		}
		else
		{
			if(pEntity.GetEntityName() != "breencrate") pEntity.SUB_Remove();
		}
		if(pEntity.GetEntityName() == "breencrate")
		{
			iRND_Class = Math::RandomInt(13, 16);
			iRND_Count = Math::RandomInt(2, 5);
			
			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemCount "+iRND_Count);
			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemClass "+g_strClassnames[iRND_Class]);
		}	
	}
}

//Calculate HP from the players count
int PlrCountHP(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}

//Make a spectator the Firefly
void Firefly(CBaseEntity@ pEntity)
{
	if(bIsFireflyPikedUp == false)
	{
		bIsFireflyPikedUp == true;
		iUNum++;
		iFireflyIndex = pEntity.entindex();
		
		pEntity.SetAbsOrigin(Vector(3040, -1952, 0));
		pEntity.SetEntityName("FireflyGuy"+iUNum);
		
		Engine.EmitSoundEntity(pEntity, "Player.PickupWeapon");
		
		Engine.Ent_Fire("spec_ornament", "SetAttached", "FireflyGuy"+iUNum);
		Engine.Ent_Fire("spec_sprite", "SetParent", "FireflyGuy"+iUNum, "0.05");
		Engine.Ent_Fire("spec_sprite", "ShowSprite", "", "0.10");
		Engine.Ent_Fire("spec_ornament", "Kill", "0", "0.10");
	}
}