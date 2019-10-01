#include "cszm_modules/random_def"

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
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
	PropsSettings();
}

void SetUpStuff()
{
	int iRNDPitch = Math::RandomInt( 65, 135 );
	
	Engine.Ent_Fire( "teleport_ambient", "Pitch", ""+iRNDPitch );
	Engine.Ent_Fire( "teleport_ambient", "AddOutput", "pitchstart "+iRNDPitch );
	Engine.Ent_Fire( "teleport_ambient", "AddOutput", "pitch "+iRNDPitch );
	
	Engine.Ent_Fire( "teleport_ambient", "PlaySound" );
	Engine.Ent_Fire( "teleport_ambient", "Volume", "10" );
	
	Engine.Ent_Fire( "shading", "StartOverlays" );
	
	Engine.Ent_Fire( "HumanSpawn*", "AddOutput", "OnPlayerSpawn !self:kill:0:0:1" );
	
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

void PropsSettings()
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeDamage 200" );
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeRadius 256" );
			pEntity.SetHealth( 20 );
		}

		else if( Utils.StrContains( "PropaneCanister001a", pEntity.GetModelName() ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeDamage 85" );
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeRadius 256" );
			pEntity.SetHealth( 5 );
		}

		else if( Utils.StrContains( "propane_tank001a", pEntity.GetModelName() ) || Utils.StrContains( "cardboard_box004a", pEntity.GetModelName() ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeDamage 128" );
			Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeRadius 256" );
			pEntity.SetHealth( 5 );
		}

		else if( Utils.StrContains( "vent001", pEntity.GetModelName() ) )
		{
			pEntity.SetMaxHealth( 5 );
			pEntity.SetHealth( 5 );
		}

		else if ( Utils.StrEql( "trashdumpster01a", pEntity.GetModelName() ) )
		{
			pEntity.SetEntityName( "unbrk" );
		}

		else
		{
			int Health = int( pEntity.GetHealth() * 0.5f );
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