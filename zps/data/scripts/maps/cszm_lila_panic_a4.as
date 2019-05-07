#include "cszm_random_def"
#include "cszm_doorset"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

//Some Data
int iMaxPlayers;
int iUNum;
int iFireflyIndex;
int iSSCount;
bool bIsFireflyPikedUp;

array<bool> g_bIsFireFly;

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
	"item_ammo_pistol", //13
	"item_ammo_rifle", //14
	"item_ammo_shotgun", //15
	"item_ammo_revolver", //16
	"item_pills", //17
	"item_healthkit" //18
};

//Other Data (Don't even touch this)
bool bAllowSPB = false;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Events::Trigger::OnStartTouch.Hook(@OnStartTouch);

	Entities::RegisterUse("spec_button");

	Engine.PrecacheFile(sound, ")items/ammo_pickup.wav");

	g_bIsFireFly.resize(iMaxPlayers + 1);

	Engine.Ent_Fire("breencrate", "FireUser1", "", "0.01");
	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();
}

HookReturnCode OnPlayerSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	int iTeamNum = pBaseEnt.GetTeamNumber();

	if(iTeamNum != 0)
	{
		iUNum++;
		pBaseEnt.SetEntityName("FOGGUY"+iUNum);
		Engine.Ent_Fire("FOGGUY"+iUNum, "SetFogController", "main_insta_fog");
	}

	if(g_bIsFireFly[iIndex] == true && iTeamNum == 1)
	{
		SpawnFirefly(pBaseEnt, iIndex);
		g_bIsFireFly[iIndex] = false;	
	}

	else if(g_bIsFireFly[iIndex] == false) RemoveFireFly(iIndex);

	return HOOK_CONTINUE;
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
	if(pPlayer is null) return;
	if(pEntity is null) return;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	
	if(Utils.StrEql(pEntity.GetEntityName(), "spec_button") && g_bIsFireFly[iIndex] == false)
	{
		Chat.PrintToChatPlayer(pPlrEnt, "{cornflowerblue}*You picked up a firefly.");
		g_bIsFireFly[iIndex] = true;
	}
}

void OnNewRound()
{
	iSSCount = 0;
	bIsFireflyPikedUp = false;
	iFireflyIndex = 0;

	for ( int i = 1; i <= iMaxPlayers; i++ ) 
	{
		g_bIsFireFly[i] = false;
	}

	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	PropDoorHP();
	BreakableHP();
	PropsHP();
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
				int iRND_Type = Math::RandomInt(0, 10);

				//Default Class and Count
				iRND_Class = 13;
				iRND_Count = 1;	

				if(iRND_Type <= 2) 
				{
					iRND_Class = Math::RandomInt(0, 10);
					iRND_Count = Math::RandomInt(2, 4);		//Amout of weapons
				}
				else if(iRND_Type >= 3 && iRND_Type <= 6)
				{
					iRND_Class = Math::RandomInt(13, 16);
					iRND_Count = Math::RandomInt(1, 3);		//Amout of ammo
				}
				else if(iRND_Type >= 7 && iRND_Type <= 8) 
				{
					iRND_Class = Math::RandomInt(11, 12);
					iRND_Count = Math::RandomInt(3, 4);		//Amout of frag and ied
				}
				else if(iRND_Type > 8)
				{
					iRND_Class = Math::RandomInt(17, 18);
					iRND_Count = Math::RandomInt(1, 3);		//Amout of adrenaline and antidote
				}
				
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
			//BreenCrate contains only ammo and medicine
			iRND_Class = Math::RandomInt(13, 18);
			iRND_Count = Math::RandomInt(2, 5);
			if(iRND_Class > 16) iRND_Count = Math::RandomInt(1, 3);
			
			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemCount "+iRND_Count);
			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemClass "+g_strClassnames[iRND_Class]);
		}	
	}
}

void SpawnFirefly(CBaseEntity@ pEntity, const int &in iIndex)
{
	const int iR = Math::RandomInt(128, 255);
	const int iG = Math::RandomInt(128, 255);
	const int iB = Math::RandomInt(128, 255);

	CEntityData@ FFSpriteIPD = EntityCreator::EntityData();

	FFSpriteIPD.Add("targetname", iIndex + "firefly_sprite");
	FFSpriteIPD.Add("model", "sprites/light_glow01.vmt");
	FFSpriteIPD.Add("rendercolor", iR + " " + iG + " " + iB);
	FFSpriteIPD.Add("rendermode", "5");
	FFSpriteIPD.Add("renderamt", "240");
	FFSpriteIPD.Add("scale", "0.25");
	FFSpriteIPD.Add("spawnflags", "1");
	FFSpriteIPD.Add("framerate", "0");

	CEntityData@ FFTrailIPD = EntityCreator::EntityData();

	FFTrailIPD.Add("targetname", iIndex + "firefly_trail");
	FFTrailIPD.Add("endwidth", "12");
	FFTrailIPD.Add("lifetime", "0.145");
	FFTrailIPD.Add("rendercolor", iR + " " + iG + " " + iB);
	FFTrailIPD.Add("rendermode", "5");
	FFTrailIPD.Add("renderamt", "84");
	FFTrailIPD.Add("spritename", "sprites/xbeam2.vmt");
	FFTrailIPD.Add("startwidth", "3");

	EntityCreator::Create("env_spritetrail", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), FFTrailIPD);
	EntityCreator::Create("env_sprite", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), FFSpriteIPD);

	CBaseEntity@ pSpriteEnt = null;
	CBaseEntity@ pTrailEnt = null;

	@pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");
	@pTrailEnt = FindEntityByName(pTrailEnt, iIndex + "firefly_trail");

	pTrailEnt.SetParent(pSpriteEnt);
	pSpriteEnt.SetParent(pEntity);

	Engine.EmitSoundPosition(iIndex, ")items/ammo_pickup.wav", pEntity.GetAbsOrigin(), 0.75F, 80, 105);
}

void RemoveFireFly(const int &in iIndex)
{
	CBaseEntity@ pSpriteEnt = null;

	@pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");

	if(pSpriteEnt !is null) pSpriteEnt.SUB_Remove();
}