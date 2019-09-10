#include "cszm/random_def"
#include "cszm/doorset"

//MyDebugFunc
void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

//Some Data
int iPreviousID;
int iMaxPlayers;
int iFireflyIndex;
int iSSCount;
bool bIsFireflyPikedUp;

array<bool> g_bIsFireFly;

array<string> g_strWeaponsCN =
{
	"weapon_ppk",
	"weapon_usp",
	"weapon_glock",
	"weapon_glock18c",
	"weapon_revolver",
	"weapon_mp5",
	"weapon_m4",
	"weapon_ak47",
	"weapon_supershorty",
	"weapon_winchester",
	"weapon_870"
};

array<string> g_strExpCN =
{
	"weapon_frag",
	"weapon_ied",
	"weapon_machete"
};

array<string> g_strAmmoCN =
{
	"item_ammo_pistol",
	"item_ammo_rifle",
	"item_ammo_shotgun",
	"item_ammo_revolver"
};

array<string> g_strMedCN =
{
	"item_pills",
	"item_healthkit",
	"item_armor"
};

//Other Data ( Don't even touch this )
bool bAllowSPB = false;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	Events::Player::OnPlayerSpawn.Hook( @OnPlayerSpawn );
	Events::Trigger::OnStartTouch.Hook( @OnStartTouch );
	Events::Entities::OnEntityCreation.Hook( @OnEntityCreation );

	Entities::RegisterUse( "spec_button" );

	g_bIsFireFly.resize( iMaxPlayers + 1 );

	Engine.Ent_Fire( "breencrate", "FireUser1", "", "0.01" );
	Schedule::Task( 0.05f, "SetUpStuff" );
	OverrideLimits();
}

HookReturnCode OnPlayerSpawn( CZP_Player@ pPlayer )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	int iTeamNum = pBaseEnt.GetTeamNumber();

	if ( iTeamNum != 0 ) Engine.Ent_Fire_Ent( pBaseEnt, "SetFogController", "main_insta_fog" );

	if ( g_bIsFireFly[iIndex] == true && iTeamNum == 1 )
	{
		SpawnFirefly( pBaseEnt, iIndex );
		g_bIsFireFly[iIndex] = false;	
	}

	else if ( g_bIsFireFly[iIndex] == false ) RemoveFireFly( iIndex );

	return HOOK_CONTINUE;
}

HookReturnCode OnStartTouch( CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity )
{
	if ( pEntity.GetTeamNumber() == 0 && pEntity.IsPlayer() == true && strEntityName == "fog_volume_lobby" ) Engine.Ent_Fire_Ent( pEntity, "SetFogController", "lobby_fog" );

	return HOOK_HANDLED;
}

HookReturnCode OnEntityCreation( const string &in strClassname, CBaseEntity@ pEntity )
{
	if ( Utils.StrEql( "item_ammo_flare", pEntity.GetClassname() ) )
	{
		SpawnRandomItem( pEntity );
	}

	return HOOK_CONTINUE;
}

void SpawnRandomItem( CBaseEntity@ pEntity )
{
	uint length;
	string classname;
	int RND = iPreviousID;

	while ( RND == iPreviousID )
	{
		RND = Math:: RandomInt( 1, 4 );
	}

	iPreviousID = RND;

	switch( RND )
	{
		case 1:
			length = g_strWeaponsCN.length() - 1;
			classname = g_strWeaponsCN[Math::RandomInt( 0, length )];
		break;
		
		case 2:
			length = g_strExpCN.length() - 1;
			classname = g_strExpCN[Math::RandomInt( 0, length )];
		break;
		
		case 3:
			length = g_strAmmoCN.length() - 1;
			classname = g_strAmmoCN[Math::RandomInt( 0, length )];
		break;
		
		case 4:
			length = g_strMedCN.length() - 1;
			classname = g_strMedCN[Math::RandomInt( 0, length )];
		break;
	}

	if ( Utils.StrEql( "weapon_machete", classname ) )
	{
		SpawnWepFragMine( pEntity );
	}

	else if ( Utils.StrEql( "item_healthkit", classname ) ) 
	{
		SpawnAntidote( pEntity );
	}

	else if ( Utils.StrEql( "item_pills", classname ) )
	{
		SpawnAdrenaline( pEntity );
	}

	else
	{
		CEntityData@ ItemIPD = EntityCreator::EntityData();

		ItemIPD.Add( "DisableDamageForces", "1", true );

		CBaseEntity@ pItem = EntityCreator::Create( classname, pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), ItemIPD );

		pEntity.SUB_Remove();
	}
}

void OnEntityUsed( CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	if ( pPlayer is null ) return;
	if ( pEntity is null ) return;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	
	if ( Utils.StrEql( pEntity.GetEntityName(), "spec_button" ) && g_bIsFireFly[iIndex] == false )
	{
		Chat.PrintToChatPlayer( pPlrEnt, "{cornflowerblue}*You picked up a firefly." );
		g_bIsFireFly[iIndex] = true;
	}
}

void OnNewRound()
{
	iSSCount = 0;
	iPreviousID = 0;
	bIsFireflyPikedUp = false;
	iFireflyIndex = 0;

	for ( int i = 1; i <= iMaxPlayers; i++ ) 
	{
		g_bIsFireFly[i] = false;
	}

	Schedule::Task( 0.05f, "SetUpStuff" );
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

	Engine.Ent_Fire( "lobby_ambient_generic", "stopsound" );
	Engine.Ent_Fire( "lobby_ambient_generic", "kill", "0", "0.01" );
}

// Random Skins for the vending machines
void VMSkins()
{
	for ( int i = 1; i <= 10; i++ )
	{
		Engine.Ent_Fire( "vm"+i, "Skin", ""+Math::RandomInt( 0, 2 ) );
	}
}

//Setiing HP of 'func_breakable'
void BreakableHP()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "func_breakable" ) ) !is null )
	{
		if ( Utils.StrContains( "-Helper", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( PlrCountHP( 25 ) );
			pEntity.SetHealth( PlrCountHP( 25 ) );
		}
		
		if ( Utils.StrContains( "ContainerBDoor", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( PlrCountHP( 50 ) );
			pEntity.SetHealth( PlrCountHP( 50 ) );
		}
	}
}

//Setiing HP of 'prop_physics_multiplayer'
void PropsHP()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if ( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ) )
		{
			continue;
		}

		else if ( Utils.StrEql( "phys_cars", pEntity.GetEntityName() ) )
		{
			pEntity.SetEntityName( "unbrk_cars" );
		}

		else
		{
			int Health = int( pEntity.GetHealth() * 0.65f );
			pEntity.SetMaxHealth( PlrCountHP( Health ) );
			pEntity.SetHealth( PlrCountHP( Health ) );
		}
	}
}

//Remove extra 'item_ammo_barricade'
void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "item_ammo_barricade" ) ) !is null )
	{
		iRND = Math::RandomInt( 1, 100 );
		
		if ( iRND < 80 )
		{
			pEntity.SUB_Remove();
		}
	}
}

//Setting a random count of items to 'prop_itemcrate'
void RandomizePropCrate()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_itemcrate" ) ) !is null )
	{
		if ( Math::RandomInt( 1, 100 ) < 15 && !Utils.StrEql( "breencrate", pEntity.GetEntityName() ) )
		{
			pEntity.SUB_Remove();
			continue;
		}

		else
		{
			int RNG = Math::RandomInt( 1, 6 );

			Engine.Ent_Fire_Ent( pEntity, "AddOutput", "ItemCount " + RNG );
			Engine.Ent_Fire_Ent( pEntity, "AddOutput", "ItemClass item_ammo_flare" );
		}
	}
}

void SpawnFirefly( CBaseEntity@ pEntity, const int &in iIndex )
{
	const int iR = Math::RandomInt( 128, 255 );
	const int iG = Math::RandomInt( 128, 255 );
	const int iB = Math::RandomInt( 128, 255 );

	CEntityData@ FFSpriteIPD = EntityCreator::EntityData();

	FFSpriteIPD.Add( "targetname", iIndex + "firefly_sprite" );
	FFSpriteIPD.Add( "model", "sprites/light_glow01.vmt" );
	FFSpriteIPD.Add( "rendercolor", iR + " " + iG + " " + iB );
	FFSpriteIPD.Add( "rendermode", "5" );
	FFSpriteIPD.Add( "renderamt", "240" );
	FFSpriteIPD.Add( "scale", "0.25" );
	FFSpriteIPD.Add( "spawnflags", "1" );
	FFSpriteIPD.Add( "framerate", "0" );

	CEntityData@ FFTrailIPD = EntityCreator::EntityData();

	FFTrailIPD.Add( "targetname", iIndex + "firefly_trail" );
	FFTrailIPD.Add( "endwidth", "12" );
	FFTrailIPD.Add( "lifetime", "0.145" );
	FFTrailIPD.Add( "rendercolor", iR + " " + iG + " " + iB );
	FFTrailIPD.Add( "rendermode", "5" );
	FFTrailIPD.Add( "renderamt", "84" );
	FFTrailIPD.Add( "spritename", "sprites/xbeam2.vmt" );
	FFTrailIPD.Add( "startwidth", "3" );

	EntityCreator::Create( "env_spritetrail", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), FFTrailIPD );
	EntityCreator::Create( "env_sprite", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), FFSpriteIPD );

	CBaseEntity@ pSpriteEnt = null;
	CBaseEntity@ pTrailEnt = null;

	@pSpriteEnt = FindEntityByName( pSpriteEnt, iIndex + "firefly_sprite" );
	@pTrailEnt = FindEntityByName( pTrailEnt, iIndex + "firefly_trail" );

	pTrailEnt.SetParent( pSpriteEnt );
	pSpriteEnt.SetParent( pEntity );

	Engine.EmitSoundPosition( iIndex, " )items/ammo_pickup.wav", pEntity.GetAbsOrigin(), 0.75F, 80, 105 );
}

void SpawnWepFragMine( CBaseEntity@ pEntity )
{
	CEntityData@ WepFragMineIPD = EntityCreator::EntityData();
	WepFragMineIPD.Add( "targetname", "weapon_fragmine" );
	WepFragMineIPD.Add( "viewmodel", "models/cszm/weapons/v_minefrag.mdl" );
	WepFragMineIPD.Add( "model", "models/cszm/weapons/w_minefrag.mdl" );
	WepFragMineIPD.Add( "itemstate", "1" );
	WepFragMineIPD.Add( "isimportant", "0" );
	WepFragMineIPD.Add( "carrystate", "6" );
	WepFragMineIPD.Add( "glowcolor", "0 128 245" );
	WepFragMineIPD.Add( "delivername", "FragMine" );
	WepFragMineIPD.Add( "sound_pickup", "Player.PickupWeapon" );
	WepFragMineIPD.Add( "printname", "vgui/images/fragmine" );
	WepFragMineIPD.Add( "weight", "5" );

	WepFragMineIPD.Add( "DisableDamageForces", "0", true );

	EntityCreator::Create( "item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), WepFragMineIPD );

	pEntity.SUB_Remove();
}

void SpawnAdrenaline( CBaseEntity@ pEntity )
{
	CEntityData@ AdrenalineIPD = EntityCreator::EntityData();

	AdrenalineIPD.Add( "targetname", "item_adrenaline" );
	AdrenalineIPD.Add( "delivername", "Adrenaline" );
	AdrenalineIPD.Add( "glowcolor", "5 250 121" );
	AdrenalineIPD.Add( "itemstate", "1" );
	AdrenalineIPD.Add( "model", "models/cszm/weapons/w_adrenaline.mdl" );
	AdrenalineIPD.Add( "viewmodel", "models/cszm/weapons/v_adrenaline.mdl" );
	AdrenalineIPD.Add( "printname", "vgui/images/adrenaline" );
	AdrenalineIPD.Add( "sound_pickup", "Deliver.PickupGeneric" );
	AdrenalineIPD.Add( "weight", "0" );
	
	AdrenalineIPD.Add( "DisableDamageForces", "0", true );

	EntityCreator::Create( "item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), AdrenalineIPD );

	pEntity.SUB_Remove();
}

void SpawnAntidote( CBaseEntity@ pEntity )
{
	CEntityData@ AntidoteIPD = EntityCreator::EntityData();

	AntidoteIPD.Add( "targetname", "iantidote" );
	AntidoteIPD.Add( "delivername", "Antidote" );
	AntidoteIPD.Add( "glowcolor", "5 250 121" );
	AntidoteIPD.Add( "itemstate", "1" );
	AntidoteIPD.Add( "model", "models/cszm/weapons/w_antidote.mdl" );
	AntidoteIPD.Add( "viewmodel", "models/cszm/weapons/v_antidote.mdl" );
	AntidoteIPD.Add( "printname", "vgui/images/weapons/inoculator" );
	AntidoteIPD.Add( "sound_pickup", "Deliver.PickupGeneric" );
	AntidoteIPD.Add( "weight", "0" );

	AntidoteIPD.Add( "DisableDamageForces", "0", true );

	EntityCreator::Create( "item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), AntidoteIPD );

	pEntity.SUB_Remove();
}

void RemoveFireFly( const int &in iIndex )
{
	CBaseEntity@ pSpriteEnt = null;

	@pSpriteEnt = FindEntityByName( pSpriteEnt, iIndex + "firefly_sprite" );

	if ( pSpriteEnt !is null )
	{
		pSpriteEnt.SUB_Remove();
	}
}