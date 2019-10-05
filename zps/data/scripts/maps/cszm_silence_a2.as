#include "cszm_modules/random_def"
#include "cszm_modules/doorset"
#include "cszm_modules/spawncrates"
#include "cszm_modules/barricadeammo"

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

	iMaxBarricade = 15;
	iMinBarricade = 8;

	iMinCrates = 0;
	iMaxCrates = 5;

	g_PICOrigin.insertLast(Vector(563.168, 1158.57, -255.513));
	g_PICAngles.insertLast(QAngle(0, -124.061, 0));

	g_PICOrigin.insertLast(Vector(1085.96, 604.511, -223.5));
	g_PICAngles.insertLast(QAngle(0, -37.9823, 0));

	g_PICOrigin.insertLast(Vector(1115.62, -514.564, -208.483));
	g_PICAngles.insertLast(QAngle(-90, 111.568, 180));

	g_PICOrigin.insertLast(Vector(1442.12, -710.87, -255.5));
	g_PICAngles.insertLast(QAngle(0, 45.9262, 0));

	g_PICOrigin.insertLast(Vector(1690.78, 607.679, -255.5));
	g_PICAngles.insertLast(QAngle(0, -57.5093, 0));

	g_PICOrigin.insertLast(Vector(906.575, 634.657, -111.649));
	g_PICAngles.insertLast(QAngle(0, 163.374, -90));

	g_PICOrigin.insertLast(Vector(424.675, -23.2762, -223.5));
	g_PICAngles.insertLast(QAngle(0, 43.616, 0));

	g_PICOrigin.insertLast(Vector(183.272, -179.602, -183.483));
	g_PICAngles.insertLast(QAngle(0, 1.70893, 0));

	g_PICOrigin.insertLast(Vector(772.598, -25.9671, -47.5992));
	g_PICAngles.insertLast(QAngle(0, 29.2479, 0));

	g_PICOrigin.insertLast(Vector(1056.26, -554.552, 65.8727));
	g_PICAngles.insertLast(QAngle(0, 99.0, 90));

	g_PICOrigin.insertLast(Vector(1599.29, 693.566, -47.5002));
	g_PICAngles.insertLast(QAngle(0, -90.216, 0));

	g_PICOrigin.insertLast(Vector(296.685, 869.228, -47.5395));
	g_PICAngles.insertLast(QAngle(0, 59.6748, 0));

	g_PICOrigin.insertLast(Vector(202.921, 257.598, -56.0867));
	g_PICAngles.insertLast(QAngle(12.8485, 37.5217, -16.111));

	g_PICOrigin.insertLast(Vector(1536.22, 475.612, -639.5));
	g_PICAngles.insertLast(QAngle(0, -40.5027, 0));

	g_PICOrigin.insertLast(Vector(744.534, -421.528, -575.5));
	g_PICAngles.insertLast(QAngle(0, 28.4555, 0));

	g_PICOrigin.insertLast(Vector(171.652, 1217.12, -727.493));
	g_PICAngles.insertLast(QAngle(0, 49.7227, 0));

	g_PICOrigin.insertLast(Vector(1417.45, 927.386, -766.622));
	g_PICAngles.insertLast(QAngle(0, -121.457, 0));

	g_PICOrigin.insertLast(Vector(2268.33, 549.154, -495.249));
	g_PICAngles.insertLast(QAngle(0, 136.575, 0));

	g_PICOrigin.insertLast(Vector(874.264, 582.238, -45.5426));
	g_PICAngles.insertLast(QAngle(0, 44.9195, 0));

	g_PICOrigin.insertLast(Vector(212.612, -481.648, -47.5002));
	g_PICAngles.insertLast(QAngle(-2.50223e-006, -125.909, 0));
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
	
	Schedule::Task(0.5f, "SpawnCrates");
	Schedule::Task(0.5f, "SpawnBarricades");
}

void SetStuff()
{
	Engine.Ent_Fire( "Precache", "kill" );
	Engine.Ent_Fire( "shading", "StartOverlays" );
	FindBarricades();
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