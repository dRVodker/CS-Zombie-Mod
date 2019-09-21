#include "cszm/random_def"
#include "../SendGameText"

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

void CD( const string &in strMsg )
{
	Chat.CenterMessage( all, strMsg );
}

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SURVIVORS = 2;

int iMaxPlayers;
int iUNum;
int iBlackCross;
int iBustPitch = 75;

float flWaitTime;

bool bIsIPCCollected;
bool bIsFirstRound = true;

array<int> g_iIndex;
array<Vector> g_vOrigin;
array<QAngle> g_qAngles;
array<float> g_flRSTime;

array<int> g_iBlackCrossIndex;
array<int> g_iSewerCapIndex;
int iAtticHatchIndex;
int iCeilingHatchIndex;

array<string> g_strFBNames =
{
	"_black_cross",
	"SewerCap",
	"AtticHatch",
	"CeilingHatch"
};

array<string> g_strStartWeapons =
{
	"weapon_usp",
	"weapon_ppk",
	"weapon_glock",
	"weapon_glock18c",
	"weapon_mp5"
};

array<Vector> g_vecCheeseOrigin =
{
	Vector( -1240, -256, 48 ),
	Vector( -883.99, -0.01, 288 ),
	Vector( -951.99, -112.01, 48.01 ),
	Vector( 1536.01, 1083.99, 44.01 ),
	Vector( 822.85, 909.08, 53.65 ),
	Vector( 1368.07, 776.38, 232.18 ),
	Vector( 441.88, 1093.9, 325.27 ),
	Vector( 2415.95, -474.52, 84.27 ),
	Vector( 937.86, -209.4, 117.63 ),
	Vector( 1029.52, 216.92, -218.88 )
};

array<Vector> g_vLobbySpawn;

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	flWaitTime = Globals.GetCurrentTime()+ 0.01f;

	Engine.PrecacheFile( sound, "sunshine_ambient/vo/sometimes01.wav" );
	Engine.PrecacheFile( sound, "@sunshine_ambient/vo/sometimes01.wav" );
	Engine.PrecacheFile( sound, "@sunshine_ambient/vo/no02.wav" );
	Engine.PrecacheFile( sound, "@sunshine_ambient/vo/no01.wav" );

	Engine.PrecacheFile( sound, "@ambient/voices/citizen_punches2.wav" );

	Engine.PrecacheFile( sound, "sunshine_ambient/vo/youkilllingme.wav" );

	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-01.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-02.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-03.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-04.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-05.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-06.wav" );

	Engine.PrecacheFile( sound, "@physics/glass/glass_impact_bullet1.wav" );
	Engine.PrecacheFile( sound, "@physics/glass/glass_impact_bullet2.wav" );
	Engine.PrecacheFile( sound, "@physics/glass/glass_impact_bullet3.wav" );

	Engine.PrecacheFile( sound, "items/suitchargeok1.wav" );

	Entities::RegisterOutput( "OnBreak", "cheese" );
	Entities::RegisterOutput( "OnBreak", "func_breakable" );

	Entities::RegisterOutput( "OnPhysPunted", "bust" );
	
	Entities::RegisterOutput( "OnTakeDamage", "bust" );

	Entities::RegisterPickup( "weapon_frag" );

	Entities::RegisterUse( "cheese" );

	Events::Trigger::OnEndTouch.Hook( @SH_OnEndTouch );
	Events::Trigger::OnStartTouch.Hook( @SH_OnStartTouch );
	Events::Player::OnPlayerSpawn.Hook( @SH_OnPlayerSpawn );

	Schedule::Task( 0.01f, "SetUpStuff" );
	OverrideLimits();
}

int CalculateHealthPoints( int &in iMulti )
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers( survivor, true );
	if ( iSurvNum < 4 )
	{
		iSurvNum = 5;
	}

	iHP = iSurvNum * iMulti;
	
	return iHP;
}

void FindIPC()
{
	int iCount = 0;
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "info_player_commons" ) )!is null )
	{
		iCount++;
		if ( !bIsIPCCollected )
		{
			g_vLobbySpawn.insertLast( pEntity.GetAbsOrigin() );
		}

		if ( iCount < 41 )
		{
			pEntity.SUB_Remove();
		}

		else if ( !bIsIPCCollected )
		{
			bIsIPCCollected = true;
		}
	}
}

void OnNewRound()
{
	Schedule::Task( 0.01f, "SetUpStuff" );
	if ( bIsFirstRound )
	{
		bIsFirstRound = false;
	}

	OverrideLimits();
}

void OnMatchBegin()
{
	HealthSettings();
	FindItems();

	Schedule::Task( 0.35f, "GiveStartGear");
}

void GiveStartGear()
{
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
							
		if ( pPlayer is null )
		{
			continue;
		}

		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex( i );

		if ( pPlayerEntity.GetTeamNumber()== TEAM_SURVIVORS )
		{
			pPlayer.AmmoBank( add, pistol, 30 );
			pPlayer.GiveWeapon( "weapon_barricade" );
			pPlayer.GiveWeapon( g_strStartWeapons[ Math::RandomInt( 0, g_strStartWeapons.length()-1 )] );
		}
	}
}

void SetUpStuff()
{
	iUNum = 0;
	iBlackCross = 0;

	iBustPitch = 100 - Math::RandomInt( -15, 25 );

	Engine.Ent_Fire( "tonemap", "SetBloomScale", "0.85", "0.00" );
	Engine.Ent_Fire( "tonemap", "SetAutoExposureMin", "0.64", "0.00" );
	Engine.Ent_Fire( "tonemap", "SetAutoExposureMax", "1.4", "0.00" );

	Engine.Ent_Fire( "Player_clip1", "Enable", "0", "0.00" );
	Engine.Ent_Fire( "Precache", "kill", "0", "0.00" );
	Engine.Ent_Fire( "shading", "StartOverlays", "0", "0.00" );
	Engine.Ent_Fire( "plr_manager", "Kill", "0", "0.00" );
	Engine.Ent_Fire( "bust", "addoutput", "damagetoenablemotion 999998", "0.00" );
	
	RemoveAmmoBar();
	SpawnCheese();
	FindIPC();
	CollectEntIndexs();
	OverrideLimits();
}

HookReturnCode SH_OnEndTouch( CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity )
{
	if ( strEntityName == "bob_trigger" && pEntity.GetClassname()== "npc_grenade_frag" )
	{	
		pEntity.SetHealth( 25 );
		pEntity.Ignite( 15 );
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode SH_OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	CBaseEntity@ pParent = pTrigger.GetParent();

	if ( pParent !is null && Utils.StrEql( pParent.GetClassname(), "func_breakable" )&& pEntity.GetTeamNumber()== 2 )
	{
		pParent.SetHealth( pParent.GetHealth()+ pParent.GetMaxHealth() );
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode SH_OnPlayerSpawn( CZP_Player@ pPlayer )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS && !bIsFirstRound )
	{
		pBaseEnt.SetAbsOrigin( g_vLobbySpawn[ Math::RandomInt( 0, g_vLobbySpawn.length() )] );
	}

	return HOOK_CONTINUE;
}

void OnEntityPickedUp( CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	if ( Utils.StrEql( pEntity.GetClassname(), "weapon_frag" ) )
	{
		int iIndex = pEntity.entindex();

		for ( uint i = 0; i < g_iIndex.length(); i++ )
		{
			if ( i == 0 )
			{
				continue;
			}

			if ( g_iIndex[i] == iIndex )
			{
				SetRespawnTime( pEntity.entindex() );
			}
		}
	}
}

void OnEntityUsed( CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( Utils.StrEql( pEntity.GetEntityName(), "cheese" ) )
	{
		Engine.Ent_Fire_Ent( pEntity, "AddHealth", "-5" );
		Engine.Ent_Fire( "cheese_voice", "PlaySound" );
	}
}

void OnEntityOutput(const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller)
{
	if ( Utils.StrEql( strOutput, "OnBreak" ) )
	{
		if ( Utils.StrEql( pCaller.GetEntityName(), "cheese" ) )
		{
			Engine.Ent_Fire( "cheese_voice", "volume", "0" );
			Engine.Ent_Fire( "cheese_voice", "kill", "0", "0.05" );
			Schedule::Task(0.25f, "CheeseNoNo");
			Schedule::Task(1.9f, "CheeseNooo");
		}

		if ( g_iBlackCrossIndex.length()> 0 )
		{
			for ( uint i = 0; i < g_iBlackCrossIndex.length(); i++ )
			{
				if ( pCaller.entindex()== g_iBlackCrossIndex[i] )
				{
					BlackCross( pActivator );
					g_iBlackCrossIndex.removeAt( i );
					break;
				}
			}
		}

		if ( g_iSewerCapIndex.length()> 0 )
		{
			for ( uint i = 0; i < g_iSewerCapIndex.length(); i++ )
			{
				if ( pCaller.entindex()== g_iSewerCapIndex[i] )
				{
					Engine.Ent_Fire( "SewerCap", "SetHealth", "50", "0.00" );
					g_iSewerCapIndex.removeAt( i );
					break;
				}
			}
		}

		if ( pCaller.entindex()== iAtticHatchIndex )
		{
			Engine.Ent_Fire( "areaportal_wall4", "Open", "", "0.00" );
			Engine.Ent_Fire( "Player_clip1", "Disable", "", "0.00" );
		}

		if ( pCaller.entindex()== iCeilingHatchIndex )
		{
			Engine.Ent_Fire( "ladder", "EnableMotion", "", "0.00" );
			Engine.Ent_Fire( "areaportal_wall3", "Open", "", "0.00" );
			Engine.Ent_Fire( "_temp_attic", "ForceSpawn", "", "0.00" );
			Engine.Ent_Fire( "mega_props", "AddOutput", "damagetoenablemotion 1880", "0.05" );
		}
	}

	if ( Utils.StrEql( pCaller.GetEntityName(), "bust" ) )
	{
		if ( Utils.StrEql( strOutput, "OnPhysPunted" ) )
		{
			Engine.EmitSoundPosition( pCaller.entindex(), "sunshine_ambient/vo/youkilllingme.wav", pCaller.GetAbsOrigin(), 1.0f, 65, iBustPitch );
		}

		if ( Utils.StrEql( strOutput, "OnTakeDamage" ) )
		{
			Engine.EmitSoundPosition( pCaller.entindex(), "humans/eugene/pain/pain-0" + Math::RandomInt(1, 6)+ ".wav", pCaller.GetAbsOrigin(), 1.0f, 75, iBustPitch );
		}
	}
}

void BlackCross( CBaseEntity@ pEntityPlayer )
{
	CZP_Player@ pPlayer = ToZPPlayer( pEntityPlayer );

	if ( pPlayer !is null )
	{
		int iRND = Math::RandomInt( 1, 3 );
		Utils.ScreenFade( pPlayer, Color( 0, 0, 0, 255 ), 3.0f, 0.0f, fade_in );
		Engine.EmitSoundPlayer( pPlayer, "@physics/glass/glass_impact_bullet" + iRND + ".wav" );
		Engine.EmitSoundPlayer( pPlayer, "@physics/glass/glass_impact_bullet" + iRND + ".wav" );
		Engine.EmitSoundPlayer( pPlayer, "@physics/glass/glass_impact_bullet" + iRND + ".wav" );
	}

	iBlackCross++;

	if ( iBlackCross == 10 )
	{
		Schedule::Task( Math::RandomFloat( 4.12f, 7.23f ), "BlackCrossCompleted");
	}
}

void BlackCrossCompleted()
{
	Engine.EmitSoundPosition( 0, "@ambient/voices/citizen_punches2.wav", Vector( 0, 0, 0 ), 1.0f, 0, 105 );
	Utils.ViewPunch( Vector( 0, 0, 0 ), QAngle( -180, 0, 0 ), 0.0f, true );
	Utils.ScreenFade( null, Color( 175, 2, 2, 32 ), 0.35f, 0.0f, fade_in );
}

void CheeseNoNo()
{
    Engine.EmitSoundPosition( 0, "@sunshine_ambient/vo/no01.wav", Vector( 0, 0, 0 ), 1.0f, 0, 95 );
    SendGameText( any, "The Cheese . . . .", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.0f, 10.0f, Color( 255, 0, 0 ), Color( 0, 0, 0) );
}

void CheeseNooo()
{
    Engine.EmitSoundPosition( 0, "@sunshine_ambient/vo/no02.wav", Vector( 0, 0, 0 ), 1.0f, 0, 95 );
    SendGameText( any, "The Cheese . . . .\nAre broken!!!", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.45f, 2.24f, Color( 255, 0, 0 ), Color( 0, 0, 0) );
}

void SpawnCheese()
{
	if ( Math::RandomInt( 0, 100 )<= 47 )
	{
		Vector NewOrigin = g_vecCheeseOrigin[Math::RandomInt( 0, 9 )];

		float RandomYaw = Math::RandomFloat( 0.0f, 360.0f );

		CEntityData@ CheeseIPD = EntityCreator::EntityData();
		CheeseIPD.Add("targetname", "cheese");
		CheeseIPD.Add("model", "models/props_sunshine/cheese.mdl");
		CheeseIPD.Add("overridescript", "surfaceprop,watermelon,");
		CheeseIPD.Add("puntsound", "Flesh_Zombie.BulletImpact");
		CheeseIPD.Add("spawnflags", "256");

		CEntityData@ CheeseVoiceIPD = EntityCreator::EntityData();
		CheeseVoiceIPD.Add( "targetname", "cheese_voice" );
		CheeseVoiceIPD.Add( "message", "@sunshine_ambient/vo/sometimes01.wav" );
		CheeseVoiceIPD.Add( "pitch", "75" );
		CheeseVoiceIPD.Add( "pitchstart", "75" );
		CheeseVoiceIPD.Add( "spawnflags", "49" );
		CheeseVoiceIPD.Add( "health", "10" );
		CheeseVoiceIPD.Add( "radius", "1024" );

		CBaseEntity@ pCheese = EntityCreator::Create( "prop_physics_multiplayer", NewOrigin, QAngle( 0, RandomYaw, 0 ), CheeseIPD );
		CBaseEntity@ pCheeseVoice = EntityCreator::Create( "ambient_generic", NewOrigin, QAngle( 0, RandomYaw, 0 ), CheeseVoiceIPD );

		pCheese.SetMaxHealth( 256 );
		pCheese.SetHealth( 256 );
	}
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "item_ammo_barricade" ) )!is null )
	{
		iRND = Math::RandomInt( 1, 100 );
		if ( iRND < 45 )
		{
			pEntity.SUB_Remove();
		}
	}
}

void HealthSettings()
{
	CBaseEntity@ pEntity;

	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) )!is null )
	{
		if ( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ))
		{
			pEntity.SetHealth( 20 );
		}

		else if ( Utils.StrContains( "props_junk/glass", pEntity.GetModelName() ))
		{
			pEntity.SetHealth( 5 );
		}

		else if ( Utils.StrContains( "bust", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( 999999 );
			pEntity.SetHealth( 999999 );
		}

		else if ( Utils.StrContains( "cheese", pEntity.GetEntityName() ))
		{
			continue;
		}

		else
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( pEntity.GetHealth() ));
			pEntity.SetHealth( CalculateHealthPoints( pEntity.GetHealth() ));
		}
	}

	while ( ( @pEntity = FindEntityByClassname( pEntity, "func_breakable" ) )!is null )
	{
		if ( Utils.StrContains( "UselessBoards", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 3 ) );
			pEntity.SetHealth( CalculateHealthPoints( 3 ) );
		}
		else if ( Utils.StrEql( pEntity.GetEntityName(), "glass" ) )
		{
			pEntity.SetMaxHealth( 1 );
			pEntity.SetHealth( 1 );
		}
		else if ( Utils.StrEql( pEntity.GetEntityName(), "FB_Board" ) )
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 52 ) );
			pEntity.SetHealth( CalculateHealthPoints( 52 ) );
		}
		else if ( Utils.StrEql( pEntity.GetEntityName(), "BalconyWood" ) )
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 52 ) );
			pEntity.SetHealth( CalculateHealthPoints( 52 ) );
		}
		else if ( Utils.StrContains( "CeilingHatch", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 50 ) );
			pEntity.SetHealth( CalculateHealthPoints( 50 ) );
		}
		else if ( Utils.StrContains( "SewerCap", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 10 ) );
			pEntity.SetHealth( CalculateHealthPoints( 10 ) );
		}
		else if ( Utils.StrContains( "lockers_breakable", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 10 ) );
			pEntity.SetHealth( CalculateHealthPoints( 10 ) );
		}
		else if ( Utils.StrContains( "AtticHatch", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 45 ) );
			pEntity.SetHealth( CalculateHealthPoints( 45 ) );
		}
		else if ( Utils.StrContains( "SewerCap", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 10 ) );
			pEntity.SetHealth( CalculateHealthPoints( 10 ) );
		}
		else if ( Utils.StrContains( "lockers_breakable", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 11 ) );
			pEntity.SetHealth( CalculateHealthPoints( 11 ) );
		}
	}

	while ( ( @pEntity = FindEntityByClassname( pEntity, "func_physbox" ) )!is null )
	{
		if ( Utils.StrContains( "physd", pEntity.GetEntityName() ))
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 52 ) );
			pEntity.SetHealth( CalculateHealthPoints( 52 ) );
		}
	}
}

void OnProcessRound()
{
	if ( g_iIndex.length()> 1 && flWaitTime <= Globals.GetCurrentTime() )
	{
		flWaitTime = Globals.GetCurrentTime()+ 0.01f;
		CBaseEntity@ pEntity;

		for ( uint i = 0; i < g_iIndex.length(); i++ )
		{
			if ( i == 0 )
			{
				continue;
			}

			if ( g_flRSTime[i] == -1 )
			{
				continue;
			}

			if ( g_flRSTime[i] <= Globals.GetCurrentTime() )
			{
				SpawnItem( i );
			}
		}

		while ( ( @pEntity = FindEntityByClassname( pEntity, "weapon_frag" ) )!is null )
		{
			for ( uint n = 0; n < g_iIndex.length(); n++ )
			{
				if ( n == 0 )
				{
					continue;
				}

				if ( pEntity.entindex()== g_iIndex[n] && Globals.Distance( g_vOrigin[n], pEntity.GetAbsOrigin() )>= 32.0f )
				{
					pEntity.SUB_Remove();
					SpawnItem( n );
				}
			}
		}
	}
}

void FindItems()
{
	g_iIndex.removeRange( 0, g_iIndex.length() );
	g_vOrigin.removeRange( 0, g_vOrigin.length() );
	g_qAngles.removeRange( 0, g_qAngles.length() );
	g_flRSTime.removeRange( 0, g_flRSTime.length() );

	g_iIndex.insertLast( 0 );
	g_vOrigin.insertLast( Vector( 0, 0, 0 ) );
	g_qAngles.insertLast( QAngle( 0, 0, 0 ) );
	g_flRSTime.insertLast( -1 );

	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByName( pEntity, "re_frag" ) )!is null )
	{
		if ( Utils.StrEql( pEntity.GetClassname(), "weapon_frag" ) )
		{
			InsertValues( pEntity );
		}
	}
}

void InsertValues( CBaseEntity@ pEntity )
{
	g_iIndex.insertLast( pEntity.entindex() );
	g_vOrigin.insertLast( pEntity.GetAbsOrigin() );
	g_qAngles.insertLast( pEntity.GetAbsAngles() );
	g_flRSTime.insertLast( -1 );	
}

void SetRespawnTime( const int &in iIndex )
{
	for ( uint i = 0; i < g_iIndex.length(); i++ )
	{
		if ( i == 0 )
		{
			continue;
		}

		if ( g_iIndex[i] == iIndex )
		{
			g_flRSTime[i] = Globals.GetCurrentTime()+ Math::RandomFloat( 4.12f, 6.21f );
			g_iIndex[i] = -1;
		}
	}
}

void SpawnItem( const int &in iID )
{
	g_flRSTime[iID] = -1;

	CEntityData@ ItemIPD = EntityCreator::EntityData();

	ItemIPD.Add( "DisableDamageForces", "1", true );

	CBaseEntity@ pWepFrag = EntityCreator::Create( "weapon_frag", g_vOrigin[iID], g_qAngles[iID], ItemIPD );

	CEntityData@ SparkIPD = EntityCreator::EntityData();
	SparkIPD.Add( "spawnflags", "896" );
	SparkIPD.Add( "magnitude", "1" );
	SparkIPD.Add( "trailLength", "1" );
	SparkIPD.Add( "maxdelay", "0" );

	SparkIPD.Add( "SparkOnce", "0", true );
	SparkIPD.Add( "kill", "0", true );

	EntityCreator::Create( "env_spark", g_vOrigin[iID], QAngle( -90, 0, 0 ), SparkIPD );

	g_iIndex[iID] = pWepFrag.entindex();

	Engine.EmitSoundPosition( 0, "items/suitchargeok1.wav", g_vOrigin[iID], 0.695f, 75, Math::RandomInt( 135, 165 ) );
}

void CollectEntIndexs()
{
	g_iBlackCrossIndex.removeRange( 0, g_iBlackCrossIndex.length() );
	g_iSewerCapIndex.removeRange( 0, g_iSewerCapIndex.length() );
	iAtticHatchIndex = 0;
	iCeilingHatchIndex = 0;

	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "func_breakable" ) )!is null )
	{
		for ( uint i = 0; i < g_strFBNames.length(); i++ )
		{
			if ( Utils.StrEql( pEntity.GetEntityName(), g_strFBNames[i] ) )
			{
				if ( i == 0 )
				{
					g_iBlackCrossIndex.insertLast( pEntity.entindex() );
				}

				if ( i == 1 )
				{
					g_iSewerCapIndex.insertLast( pEntity.entindex() );
				}

				if ( i == 2 )
				{
					iAtticHatchIndex = pEntity.entindex();
				}

				if ( i == 3 )
				{
					iCeilingHatchIndex = pEntity.entindex();
				}
			}
		}
	}
}