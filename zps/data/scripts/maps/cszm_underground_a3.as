#include "cszm_modules/random_def"
#include "cszm_modules/doorset"

//MyDebugFunc
void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

const int TEAM_SURVIVORS = 2;

int iMaxPlayers;
const float flMaxDist = 1024;
const float flLastRadius = 384;

float flSpawnThinkTime = 0;

int iLatsZSpawnIndex;
array<int> g_ZSpawnIndex;
array<int> g_ZSpawnState;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();
	Schedule::Task( 0.025f, "SetUpStuff" );
	OverrideLimits();
}

void OnNewRound()
{	
	Engine.Ent_Fire( "SND_Ambient", "StopSound" );
	Engine.Ent_Fire( "SND_Ambient", "PlaySound" );

	Schedule::Task( 0.025f, "SetUpStuff" );
	OverrideLimits();
}

void OnMatchBegin() 
{
	PropsSettings();
	PropDoorHP();
	Engine.Ent_Fire( "SND_Ambient", "PlaySound" );
	
	Schedule::Task( 5.0f, "SpawnDist" );
}

void SetUpStuff()
{
	int iNumbers = 0;
	RemoveAmmoBar();
	Engine.Ent_Fire( "Precache", "kill" );
	Engine.Ent_Fire( "SND_Ambient", "PlaySound" );
	
	Engine.Ent_Fire( "shading", "StartOverlays" );
	
	FlickerLight1();
	ChangeFog();
}

void FindZSpawns()
{
	int iCount = 0;
	flSpawnThinkTime = Globals.GetCurrentTime() + 1.0f;
	g_ZSpawnIndex.removeRange( 0, g_ZSpawnIndex.length() );
	g_ZSpawnState.removeRange( 0, g_ZSpawnState.length() );


	CBaseEntity@ pSpawn;
	while ( ( @pSpawn = FindEntityByClassname( pSpawn, "info_player_zombie" ) ) !is null )
	{
		iCount++;
		pSpawn.SetEntityName( "ZSpawn" + iCount );
		Engine.Ent_Fire( "ZSpawn" + iCount, "AddOutput", "minspawns 0" );
		Engine.Ent_Fire( "ZSpawn" + iCount, "AddOutput", "mintime 1" );
		g_ZSpawnIndex.insertLast( pSpawn.entindex() );
		g_ZSpawnState.insertLast( 0 );
	}
}

void SpawnDist()
{
	int iCount = 0;
	int iLCount = 0;

	bool bCloseStageTwo;

	for ( uint i = 0; i < g_ZSpawnIndex.length(); i++ )
	{
		CBaseEntity@ pSpawn = FindEntityByEntIndex( g_ZSpawnIndex[i] );

		if ( pSpawn is null )
		{
			continue;
		}

		for ( int p = 1; p <= iMaxPlayers; p++ ) 
		{
			CBaseEntity@ pPlayerEnt = FindEntityByEntIndex( p );

			if ( pPlayerEnt is null )
			{
				continue;
			}

			if ( pPlayerEnt.GetTeamNumber() != TEAM_SURVIVORS )
			{
				continue;
			}

			if ( pSpawn.Distance( pPlayerEnt.GetAbsOrigin() ) < 512.0f )
			{
				if ( g_ZSpawnState[i] != 1 && g_ZSpawnState[i] != 2 )
				{
					Engine.Ent_Fire( pSpawn.GetEntityName(), "DisableSpawn" );
					g_ZSpawnState[i] = 1;
				}
			}

			if ( pSpawn.Distance( pPlayerEnt.GetAbsOrigin() ) > 1024.0f )
			{
				if ( g_ZSpawnState[i] != 1 && g_ZSpawnState[i] != 2 )
				{
					iLatsZSpawnIndex = g_ZSpawnIndex[i];
					Engine.Ent_Fire( pSpawn.GetEntityName(), "DisableSpawn" );
					g_ZSpawnState[i] = 1;
				}
			}

			else
			{
				if ( g_ZSpawnState[i] != 0 && pSpawn.Distance( pPlayerEnt.GetAbsOrigin() ) > 512.0f && pSpawn.Distance( pPlayerEnt.GetAbsOrigin() ) < 1024.0f )
				{
					Engine.Ent_Fire( pSpawn.GetEntityName(), "EnableSpawn" );
					g_ZSpawnState[i] = 0;
					bCloseStageTwo = true;
				}
			}
		}
	}

	if ( bCloseStageTwo )
	{
		for ( uint w = 0; w < g_ZSpawnIndex.length(); w++ )
		{
			if ( g_ZSpawnState[w] == 2 )
			{
				CBaseEntity@ pSpawn = FindEntityByEntIndex( g_ZSpawnIndex[w] );
				Engine.Ent_Fire( pSpawn.GetEntityName(), "DisableSpawn" );
				g_ZSpawnState[w] = 1;
			}
		}
	}

	for ( uint u = 0; u < g_ZSpawnState.length(); u++ )
	{
		iCount++;
		if ( g_ZSpawnState[u] == 1 )
		{
			iLCount++;
		}
	}

	if ( iLCount >= iCount )
	{
		CBaseEntity@ pLastSpawn = FindEntityByEntIndex( iLatsZSpawnIndex );

		if ( pLastSpawn !is null )
		{
			for ( uint q = 0; q < g_ZSpawnIndex.length(); q++ )
			{
				CBaseEntity@ pSpawn = FindEntityByEntIndex( g_ZSpawnIndex[q] );

				if ( pSpawn is null )
				{
					continue;
				}

				if ( g_ZSpawnState[q] == 2 || g_ZSpawnState[q] == 1 )
				{
					continue;
				}

				if ( pSpawn.Distance( pLastSpawn.GetAbsOrigin() ) < 512.0f )
				{
					Engine.Ent_Fire( pSpawn.GetEntityName(), "EnableSpawn" );
					g_ZSpawnState[q] = 2;
				}
			}
		}
	}
}

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeDamage 200" );
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeRadius 256" );
		}

		else if( Utils.StrContains( "wood_crate", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( pEntity.GetHealth() + PlrCountHP( 50 ) );
			pEntity.SetHealth( pEntity.GetHealth() + PlrCountHP( 50 ) );
		}

		else if( Utils.StrContains( "plasma_53", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 5 );
			pEntity.SetHealth( 5 );
		}
		
		else if( Utils.StrContains( "fire_extinguisher", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 5 );
			pEntity.SetHealth( 5 );
		}

		else if( Utils.StrContains( "interior_fence001g", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( pEntity.GetHealth() + PlrCountHP( 45 ) );
			pEntity.SetHealth( pEntity.GetHealth() + PlrCountHP( 45 ) );
		}

		else
		{
			int Health = int( pEntity.GetHealth() * 0.5f );
			pEntity.SetMaxHealth( PlrCountHP( Health ) );
			pEntity.SetHealth( PlrCountHP( Health ) );
		}
	}
}

void ChangeFog()
{
	CBaseEntity@ pEntity = FindEntityByClassname( pEntity, "env_fog_controller" );
	pEntity.SetEntityName( "my_fog" );
	Engine.Ent_Fire( "my_fog", "SetStartDist", "-128" );
	Engine.Ent_Fire( "my_fog", "SetEndDist", "4096" );
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "item_ammo_barricade" ) ) !is null )
	{
		iRND = Math::RandomInt( 1, 100 );
		
		if( iRND < 55 )
		{
			pEntity.SUB_Remove();
		}
	}
}

void FlickerLight1()
{
	float flInterval = Math::RandomFloat( 0.085, 0.35 );
	float flOffInterval = Math::RandomFloat( 0.05, 0.20 );
	Engine.Ent_Fire( "FL-Prop1", "skin", "1" );
	Engine.Ent_Fire( "FL-Light1", "TurnOn" );
	Engine.Ent_Fire( "FL-Spr1", "ShowSprite" );
	
	Schedule::Task( flOffInterval, "FlickerLight1Off" );
	Schedule::Task( flInterval, "FlickerLight1" );
}

void FlickerLight1Off()
{
	Engine.Ent_Fire( "FL-Prop1", "skin", "0" );
	Engine.Ent_Fire( "FL-Light1", "TurnOff" );
	Engine.Ent_Fire( "FL-Spr1", "HideSprite" );
}