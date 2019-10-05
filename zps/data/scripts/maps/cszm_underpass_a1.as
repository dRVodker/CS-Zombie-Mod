#include "cszm_modules/random_def"
#include "cszm_modules/barricadeammo"

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
	Schedule::Task( 0.05f, "SetUpStuff" );

	iMaxBarricade = 11;
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
	Schedule::Task(0.5f, "SpawnBarricades");
}

void SetUpStuff()
{
	FindBarricades();
	Engine.Ent_Fire( "screenoverlay", "StartOverlays" );
	CreatedByColors();
}

void CreatedByColors()
{
	float flFireTime = Math::RandomFloat( 0.10f, 1.20f );
	
	Schedule::Task( flFireTime, "CreatedByColors" );
	
	int iR = Math::RandomInt( 32, 255 );
	int iG = Math::RandomInt( 32, 255 );
	int iB = Math::RandomInt( 32, 255 );
	
	Engine.Ent_Fire( "created_by", "color", ""+iR+" "+iG+" "+iB );
}

void PropsHP()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if( Utils.StrContains( "vent001", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 5 );
			pEntity.SetHealth( 5 );
		}

		else if( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 20 );
			pEntity.SetHealth( 20 );
		}

		else if( Utils.StrContains( "canister0", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 5 );
			pEntity.SetHealth( 5 );
		}

		else if( Utils.StrContains( "gascan001a", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 5 );
			pEntity.SetHealth( 5 );
		}

		else if( Utils.StrContains( "PropaneCanister001a", pEntity.GetModelName() ) )
		{
			pEntity.SetHealth( 5 );
		}

		else
		{
			int Health = int( pEntity.GetHealth() * 0.45f );
			pEntity.SetMaxHealth( PlrCountHP( Health ) );
			pEntity.SetHealth( PlrCountHP( Health ) );
		}
	}
}

int PlrCountHP( int &in iMulti )
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers( survivor, true );
	if( iSurvNum < 4 )
	{
		iSurvNum = 5;
	}

	iHP = iSurvNum * iMulti;
	
	return iHP;
}