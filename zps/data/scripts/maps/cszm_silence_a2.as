#include "cszm/random_def"
#include "cszm/doorset"

int iSurvInBasement;
bool bIsBZSEnabled;

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SURVIVORS = 2;

void OnMapInit()
{
	Events::Player::OnPlayerSpawn.Hook( @OnPlayerSpawn );
	Events::Trigger::OnStartTouch.Hook( @OnStartTouch );
	Events::Trigger::OnEndTouch.Hook( @OnEndTouch );
	Schedule::Task( 0.05f, "SetStuff" );
	OverrideLimits();
}

void OnNewRound()
{
	Schedule::Task( 0.05f, "SetStuff" );
	OverrideLimits();
}

void OnMatchStarting()
{
	bIsBZSEnabled = false;
}

void OnMatchBegin()
{
	Engine.Ent_Fire( "zs_outside_pvs*", "EnableSpawn" );
	Engine.Ent_Fire( "zs_outside_base*", "EnableSpawn" );
	Engine.Ent_Fire( "zs_inside_pvs*", "EnableSpawn" );
	Engine.Ent_Fire( "zs_basement_ns_pvs*", "EnableSpawn" );
	Engine.Ent_Fire( "_temp_humanclip", "ForceSpawn" );
	PropDoorHP();
	PropsSettings();
}

void SetStuff()
{
	Engine.Ent_Fire( "Precache", "kill" );
	Engine.Ent_Fire( "shading", "StartOverlays" );
	RemoveAmmoBar();
}

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if ( Utils.StrContains( "gascan001a", pEntity.GetModelName() ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeDamage 85" );
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeRadius 256" );
			pEntity.SetHealth( 5 );
		}

		else if ( Utils.StrContains( "weak", pEntity.GetEntityName() ) )
		{
			pEntity.SetHealth( 5 );
			pEntity.SetMaxHealth( 5 );
		}

		else
		{
			int Health = int( pEntity.GetHealth() * 0.45f );
			pEntity.SetMaxHealth( PlrCountHP( Health ) );
			pEntity.SetHealth( PlrCountHP( Health ) );
		}
	}
}

void DoorHP( int &in iWoodDoorHP, int &in iMetalDoorHP )
{
	Engine.Ent_Fire( "WoodDoor*", "SetDoorHealth", "" + iWoodDoorHP );
	Engine.Ent_Fire( "FrontDoors", "SetDoorHealth", "" + iWoodDoorHP );
	Engine.Ent_Fire( "MetalDoor*", "SetDoorHealth", "" + iMetalDoorHP );
	Engine.Ent_Fire( "CrematoryDoors", "SetDoorHealth", "" + iMetalDoorHP );
}

HookReturnCode OnPlayerSpawn( CZP_Player@ pPlayer )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( pBaseEnt.GetTeamNumber() != TEAM_LOBBYGUYS )
	{
		Engine.Ent_Fire_Ent( pBaseEnt, "SetFogController", "base_fog" );
	}

	else
	{
		Engine.Ent_Fire_Ent( pBaseEnt, "SetFogController", "lobby_fog" );
	}

	return HOOK_CONTINUE;	
}

HookReturnCode OnStartTouch( CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity )
{
	if ( pEntity is null )
	{
		return HOOK_CONTINUE;
	}
	
	if ( pEntity.GetTeamNumber() == TEAM_SURVIVORS && Utils.StrEql( strEntityName, "fog_volume" ) )
	{
		iSurvInBasement++;
		if( bIsBZSEnabled == false )
		{
			bIsBZSEnabled = true;
			string strInput = "FireUser1";
			ManipulateZS( strInput );
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnEndTouch( CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity )
{
	if ( pEntity is null )
	{
		return HOOK_CONTINUE;
	}
	
	if ( pEntity.GetTeamNumber() == TEAM_SURVIVORS && Utils.StrEql( strEntityName, "fog_volume" ) )
	{
		iSurvInBasement--;
		if( iSurvInBasement <= 0 )
		{
			bIsBZSEnabled = false;
			string strInput = "FireUser2";
			ManipulateZS( strInput );
		}
	}
	
	return HOOK_CONTINUE;
}

void ManipulateZS( const string &in strInput )
{
	Engine.Ent_Fire( "zs_outside_pvs", "" + strInput );
	Engine.Ent_Fire( "zs_outside_base", "" + strInput );
	Engine.Ent_Fire( "zs_inside_pvs", "" + strInput );
	Engine.Ent_Fire( "zs_basement_ns_pvs", "" + strInput );
	Engine.Ent_Fire( "zs_basement_pvs", "" + strInput );
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "item_ammo_barricade" ) ) !is null )
	{
		iRND = Math::RandomInt( 0, 100 );
		
		if( iRND < 45 )
		{
			pEntity.SUB_Remove();
		}
	}
}