#include "cszm_modules/random_def"
#include "cszm_modules/doorset"
#include "cszm_modules/barricadeammo"
#include "cszm_modules/lobbyambient"

const int TEAM_LOBBYGUYS = 0;

int CalculateHealthPoints( int &in iMulti ) 
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers( survivor, true );
	if( iSurvNum < 4 ) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}

void OnMapInit() 
{
	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);

	Schedule::Task( 0.05f, "SetUpStuff" );
	iMaxBarricade = 12;
	iMinBarricade = 6;
	OverrideLimits();
}

void OnNewRound() 
{	
	Schedule::Task( 0.05f, "SetUpStuff" );
	OverrideLimits();
}

void OnMatchBegin() 
{
	PropsHP();
	PropDoorHP();
	Schedule::Task(0.5f, "SpawnBarricades");
}

void SetUpStuff() 
{
	Engine.Ent_Fire( "screenoverlay", "StartOverlays" );
	Engine.Ent_Fire( "Precache", "Kill" );
	
	Engine.Ent_Fire( "tonemap", "SetBloomScale", "0.475" );
	Engine.Ent_Fire( "extinguisher", "Addoutput", "damagetoenablemotion 500" );

	FindBarricades();
	VMSkins();
	RndSpawn();
	OpenDoors();
	PlayLobbyAmbient();
}

HookReturnCode OnPlrSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
	{
		PlayLobbyAmbient();
	}

	return HOOK_HANDLED;
}

void OpenDoors() 
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_door_rotating" ) ) !is null ) 
	{
		Engine.Ent_Fire_Ent( pEntity, "FireUser1" );
	}
	
	Engine.Ent_Fire( "H-OF*", "Kill", "0", "0.85" );
}

void VMSkins() 
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null ) 
	{
		if( Utils.StrContains( "vending_machine", pEntity.GetModelName() ) ) 
		{
			Engine.Ent_Fire_Ent( pEntity, "Skin", ""+Math::RandomInt( 0, 2 ) );
		}
	}
}

void RndSpawn() 
{
	int iRND_First = Math::RandomInt( 0, 100 );
	int iRND_Second = Math::RandomInt( 0, 100 );

	if( iRND_First >= iRND_Second ) 
	{
		Engine.Ent_Fire( "Human-CTerrorisSpawns", "Kill" );
		Engine.Ent_Fire( "Zombie-TerrorisSpawns", "Kill" );
	}

	else
	{
		Engine.Ent_Fire( "Zombie-CTerrorisSpawns", "Kill" );
		Engine.Ent_Fire( "Human-TerrorisSpawns", "Kill" );
	}
}

void PropsHP() 
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null ) 
	{
		if ( Utils.StrContains( "fire_extinguisher", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 10 );
			pEntity.SetHealth( 10 );
		}

		else
		{
			int Health = int( pEntity.GetHealth() * 0.6f );
			pEntity.SetMaxHealth( PlrCountHP( Health ) );
			pEntity.SetHealth( PlrCountHP( Health ) );
		}
	}
}