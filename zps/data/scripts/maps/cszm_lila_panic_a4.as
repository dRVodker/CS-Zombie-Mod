#include "cszm_modules/random_def"
#include "cszm_modules/doorset"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

//Some Data
int iMaxPlayers;
int iFireflyIndex;
int iSSCount;
bool bIsFireflyPikedUp;

array<bool> g_bIsFireFly;

//Other Data (Don't even touch this)
bool bAllowSPB = false;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Events::Trigger::OnStartTouch.Hook(@OnStartTouch);

	Entities::RegisterUse("spec_button");

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

	if (iTeamNum != 0)
	{
		Engine.Ent_Fire_Ent(pBaseEnt, "SetFogController", "main_insta_fog");
	}

	if (g_bIsFireFly[iIndex] == true && iTeamNum == 1)
	{
		SpawnFirefly(pBaseEnt, iIndex);
		g_bIsFireFly[iIndex] = false;	
	}

	else if (!g_bIsFireFly[iIndex])
	{
		RemoveFireFly(iIndex);
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (pEntity.GetTeamNumber() == 0 && pEntity.IsPlayer() == true && strEntityName == "fog_volume_lobby")
	{
		Engine.Ent_Fire_Ent(pEntity, "SetFogController", "lobby_fog");
	}

	return HOOK_HANDLED;
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity is null || pPlayer is null) 
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	
	if (Utils.StrEql(pEntity.GetEntityName(), "spec_button") && !g_bIsFireFly[iIndex])
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

	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		g_bIsFireFly[i] = false;
	}

	Schedule::Task(0.05f, "SetUpStuff");
	OverrideLimits();
}

void OnMatchBegin() 
{
	PropDoorHP();
	BreakableHP();
	PropsHP();
}

void SetUpStuff()
{
	VMSkins();
	RandomizePropCrate();
	RemoveAmmoBar();
}

// Random Skins for the vending machines
void VMSkins()
{
	for (int i = 1; i <= 10; i++)
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
		if (Utils.StrContains("-Helper", pEntity.GetModelName()))
		{
			pEntity.SetMaxHealth(PlrCountHP(25));
			pEntity.SetHealth(PlrCountHP(25));
		}
		
		if (Utils.StrContains("ContainerBDoor", pEntity.GetModelName()))
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
		if (Utils.StrContains("oildrum001_explosive", pEntity.GetModelName()))
		{
			continue;
		}

		else if (Utils.StrEql("phys_cars", pEntity.GetEntityName()))
		{
			pEntity.SetEntityName("unbrk_cars");
		}

		else
		{
			int Health = int(pEntity.GetHealth() * 0.4f);
			pEntity.SetMaxHealth(PlrCountHP(Health));
			pEntity.SetHealth(PlrCountHP(Health));
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
		
		if (iRND < 80)
		{
			pEntity.SUB_Remove();
		}
	}
}

//Setting a random count of items to 'prop_itemcrate'
void RandomizePropCrate()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_itemcrate")) !is null)
	{
		if (Math::RandomInt(1, 100) < 15 && !Utils.StrEql("breencrate", pEntity.GetEntityName()))
		{
			pEntity.SUB_Remove();
			continue;
		}

		else
		{
			int RNG = Math::RandomInt(1, 6);

			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemCount " + RNG);
			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemClass item_ammo_flare");
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

	if (pSpriteEnt !is null)
	{
		pSpriteEnt.SUB_Remove();
	}
}