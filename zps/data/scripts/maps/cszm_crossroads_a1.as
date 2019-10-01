#include "cszm_modules/random_def"
#include "cszm_modules/doorset"

int CalculateHealthPoints( const int &in iMulti )
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
}

void SetUpStuff()
{
	Engine.Ent_Fire( "screenoverlay", "StartOverlays" );
	Engine.Ent_Fire( "Precache", "Kill" );
	
//	Engine.Ent_Fire( "tonemap", "SetBloomScale", "0.475" );
	RemoveAmmoBar();
	PropSkins();
	OpenDoors();
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

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "item_ammo_barricade" ) ) !is null )
	{
		iRND = Math::RandomInt( 0, 100 );
		
		if( iRND < 75 )
		{
			pEntity.SUB_Remove();
		}
	}
}

void PropSkins()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if( Utils.StrContains( "vending_machine", pEntity.GetModelName() ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "Skin", "" + Math::RandomInt( 0, 2 ) );
		}

		else if( Utils.StrContains( "oildrum001", pEntity.GetModelName() ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "Skin", "" + Math::RandomInt( 0, 5 ) );
		}
	}
}

void PropsHP()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if ( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ) )
		{
			continue;
		}

		else
		{
			int Health = int( pEntity.GetHealth() * 0.6f );
			pEntity.SetMaxHealth( PlrCountHP( Health ) );
			pEntity.SetHealth( PlrCountHP( Health ) );
		}
	}
}