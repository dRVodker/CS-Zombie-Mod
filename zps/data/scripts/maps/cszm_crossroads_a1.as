#include "cszm_modules/random_def"
#include "cszm_modules/doorset"
#include "cszm_modules/spawncrates"
#include "cszm_modules/barricadeammo"

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

	iMaxBarricade = 16;
	iMinBarricade = 8;

	iMinCrates = 0;
	iMaxCrates = 4;

	g_PICOrigin.insertLast(Vector(687.176, 518.164, 144.499));
	g_PICAngles.insertLast(QAngle(0, -39.3396, 0));

	g_PICOrigin.insertLast(Vector(215.928, 12.7174, 0.4998));
	g_PICAngles.insertLast(QAngle(0, 37.7857, 0));

	g_PICOrigin.insertLast(Vector(196.874, 2199.98, 0.487563));
	g_PICAngles.insertLast(QAngle(0, 160.113, 0));

	g_PICOrigin.insertLast(Vector(-869.544, 2198.39, -175.023));
	g_PICAngles.insertLast(QAngle(0, -29.4917, 0));

	g_PICOrigin.insertLast(Vector(320.141, 2748.25, 175.867));
	g_PICAngles.insertLast(QAngle(0, 6.47761, 0));

	g_PICOrigin.insertLast(Vector(198.54, 866.949, 292.692));
	g_PICAngles.insertLast(QAngle(0, 156.909, 0));

	g_PICOrigin.insertLast(Vector(-1188.67, 825.958, 16.4363));
	g_PICAngles.insertLast(QAngle(0, 126.38, 0));

	g_PICOrigin.insertLast(Vector(1034.61, 1747.99, -215.5));
	g_PICAngles.insertLast(QAngle(0, -41.8031, 0));

	g_PICOrigin.insertLast(Vector(-401.409, 1566.96, 152.901));
	g_PICAngles.insertLast(QAngle(0, -53.3466, 0));
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
	Schedule::Task(0.5f, "SpawnCrates");
	Schedule::Task(0.5f, "SpawnBarricades");
}

void SetUpStuff()
{
	Engine.Ent_Fire( "screenoverlay", "StartOverlays" );
	Engine.Ent_Fire( "Precache", "Kill" );
	
//	Engine.Ent_Fire( "tonemap", "SetBloomScale", "0.475" );
	FindBarricades();
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