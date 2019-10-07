#include "cszm_modules/random_def"
#include "cszm_modules/spawncrates"
#include "cszm_modules/barricadeammo"

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

void OnMapInit()
{	
	Schedule::Task( 0.05f, "SetUpStuff" );

	iMinCrates = 0;
	iMaxCrates = 4;

	iMaxBarricade = 8;
	iMinBarricade = 2;

	//Spawn points for "prop_itemcrate"
	g_PICOrigin.insertLast(Vector(-3260.25, 1504.83, 780.466));
	g_PICAngles.insertLast(QAngle(0, -37.24, 0));

	g_PICOrigin.insertLast(Vector(-2807.68, 2142.01, 969.004));
	g_PICAngles.insertLast(QAngle(-0.0368034, -27.3475, 0.0120844));

	g_PICOrigin.insertLast(Vector(-1755.55, 1475.33, 1261.0));
	g_PICAngles.insertLast(QAngle(0, 57.6366, 0));

	g_PICOrigin.insertLast(Vector(-972.825, 1840.93, 888.455));
	g_PICAngles.insertLast(QAngle(0, -33.8835, 0));

	g_PICOrigin.insertLast(Vector(-2612.6, 1289.8, 720.479));
	g_PICAngles.insertLast(QAngle(0, 31.2687, 0));

	g_PICOrigin.insertLast(Vector(-1695.06, 3252.04, 1097.11));
	g_PICAngles.insertLast(QAngle(0, 40.387, 0));

	g_PICOrigin.insertLast(Vector(-1858.55, 2268.52, 1032.42));
	g_PICAngles.insertLast(QAngle(0, 127.438, 0));

	g_PICOrigin.insertLast(Vector(-3250.75, 2402.12, 912.5));
	g_PICAngles.insertLast(QAngle(0, -131.857, -180));

	//Spawn points for "item_ammo_barricade"
	g_IABOrigin.insertLast(Vector(-1995.09, 1481.33, 1033.49));
	g_IABAngles.insertLast(QAngle(89.8769, 112.305, 149.649));

	g_IABOrigin.insertLast(Vector(-2040.85, 1417.87, 1035.94));
	g_IABAngles.insertLast(QAngle(-89.7789, 178.142, -14.8435));

	g_IABOrigin.insertLast(Vector(-1645.24, 1986.01, 1144.9));
	g_IABAngles.insertLast(QAngle(89.8282, -178.092, -151.047));

	g_IABOrigin.insertLast(Vector(-1602.8, 1737.96, 1144.2));
	g_IABAngles.insertLast(QAngle(89.7437, -102.799, 0));

	g_IABOrigin.insertLast(Vector(-1687.32, 1541.85, 1144.12));
	g_IABAngles.insertLast(QAngle(89.6569, 127.459, -25.9164));

	g_IABOrigin.insertLast(Vector(-1649.93, 1983.56, 1147.44));
	g_IABAngles.insertLast(QAngle(-86.8677, -27.5342, 73.4688));

	g_IABOrigin.insertLast(Vector(-1615.44, 2038.58, 1033.42));
	g_IABAngles.insertLast(QAngle(89.5736, -161.389, 179.932));

	g_IABOrigin.insertLast(Vector(-923.432, 2473.7, 890.135));
	g_IABAngles.insertLast(QAngle(89.6968, 159.747, -0.216248));

	g_IABOrigin.insertLast(Vector(-1028.99, 2820.73, 897.871));
	g_IABAngles.insertLast(QAngle(89.5329, 134.937, -20.6587));

	g_IABOrigin.insertLast(Vector(-1301.13, 2569.32, 890.637));
	g_IABAngles.insertLast(QAngle(89.9585, 117.01, 180));

	g_IABOrigin.insertLast(Vector(-1299.89, 2154.59, 889.49));
	g_IABAngles.insertLast(QAngle(-89.7763, -49.958, -0.165741));

	g_IABOrigin.insertLast(Vector(-2113.49, 1880.98, 906.706));
	g_IABAngles.insertLast(QAngle(-14.7634, -0.0957668, 89.5636));

	g_IABOrigin.insertLast(Vector(-2366.76, 1434.4, 717.459));
	g_IABAngles.insertLast(QAngle(89.8553, -54.4836, 0.11075));

	g_IABOrigin.insertLast(Vector(-2196.68, 1273.35, 725.511));
	g_IABAngles.insertLast(QAngle(89.7831, -2.7599, 160.538));

	g_IABOrigin.insertLast(Vector(-2857.08, 2352.09, 889.433));
	g_IABAngles.insertLast(QAngle(89.675, 137.204, -0.0786438));

	g_IABOrigin.insertLast(Vector(-2856.39, 2402.38, 889.572));
	g_IABAngles.insertLast(QAngle(-89.5667, -169.542, 14.0368));

	g_IABOrigin.insertLast(Vector(-3686.43, 1511.92, 781.441));
	g_IABAngles.insertLast(QAngle(89.9643, -3.81714, 180));

	g_IABOrigin.insertLast(Vector(-3702.24, 1541.4, 783.913));
	g_IABAngles.insertLast(QAngle(-89.8006, -173.504, -128.103));

	g_IABOrigin.insertLast(Vector(-3104.02, 1626.5, 781.488));
	g_IABAngles.insertLast(QAngle(-89.9681, 141.547, 180));

	g_IABOrigin.insertLast(Vector(-2790.18, 3010.07, 889.449));
	g_IABAngles.insertLast(QAngle(-89.3933, 97.9808, -14.0358));

	g_IABOrigin.insertLast(Vector(-2712.24, 3043.06, 889.515));
	g_IABAngles.insertLast(QAngle(-89.9583, -129.564, 180));

	g_IABOrigin.insertLast(Vector(-1804.13, 2889.37, 825.491));
	g_IABAngles.insertLast(QAngle(-89.7798, 34.4226, 0.234766));

	g_IABOrigin.insertLast(Vector(-1842.42, 2253.47, 1036.52));
	g_IABAngles.insertLast(QAngle(-23.9134, 128.892, -90.4828));

	g_IABOrigin.insertLast(Vector(-2152.13, 2478.74, 1036.57));
	g_IABAngles.insertLast(QAngle(-14.2556, 0.664229, -89.5185));

	g_IABOrigin.insertLast(Vector(-2662.74, 1485.99, 1033.5));
	g_IABAngles.insertLast(QAngle(89.4268, 144.291, -75.2653));

	g_IABOrigin.insertLast(Vector(-3279.65, 2578.58, 889.515));
	g_IABAngles.insertLast(QAngle(-89.953, -135.521, 180));


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
	Schedule::Task(0.5f, "SpawnCrates");
	Schedule::Task(0.5f, "SpawnBarricades");
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