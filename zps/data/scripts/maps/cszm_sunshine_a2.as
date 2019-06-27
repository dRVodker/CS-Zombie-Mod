#include "cszm_random_def"
#include "../SendGameText"

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

int iMaxPlayers;

int iUNum = 0;

array<int> g_iStrongLevel;

array<int> g_iFHintIndex;
array<float> g_iFHintRecoverTime;

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

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	g_iStrongLevel.resize( iMaxPlayers + 1 );

	Engine.PrecacheFile( sound, "@sunshine_ambient/vo/sometimes01.wav" );
	Engine.PrecacheFile( sound, "@sunshine_ambient/vo/no02.wav" );
	Engine.PrecacheFile( sound, "@sunshine_ambient/vo/no01.wav" );

	Engine.PrecacheFile( sound, "sunshine_ambient/vo/youkilllingme.wav" );

	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-01.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-02.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-03.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-04.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-05.wav" );
	Engine.PrecacheFile( sound, "humans/eugene/pain/pain-06.wav" );

	Engine.PrecacheFile( sound, "items/suitchargeok1.wav" );

	Entities::RegisterOutput( "OnBreak", "cheese" );

	Entities::RegisterOutput( "OnPhysPunted", "bust" );
	Entities::RegisterOutput( "OnTakeDamage", "bust" );

	Entities::RegisterPickup( "base_item_energy" );
	Entities::RegisterUse( "base_item_energy" );

	Entities::RegisterUse( "hint_frag" );

	Entities::RegisterUse( "cheese" );

	Events::Trigger::OnEndTouch.Hook( @OnEndTouch );
	Events::Trigger::OnStartTouch.Hook( @OnStartTouch );
	
	Schedule::Task( 0.01f, "SetUpStuff" );
	OverrideLimits();
}

int CalculateHealthPoints( int &in iMulti )
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers( survivor, true );
	if ( iSurvNum < 4 ) iSurvNum = 5;

	iHP = iSurvNum * iMulti;
	
	return iHP;
}

void OnNewRound()
{
	Schedule::Task( 0.01f, "SetUpStuff" );

	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		g_iStrongLevel[i] = 0;
	}

	if ( g_iFHintIndex.length() != 0 ) g_iFHintIndex.removeRange( 0, g_iFHintIndex.length() );
	if ( g_iFHintRecoverTime.length() != 0 ) g_iFHintRecoverTime.removeRange( 0, g_iFHintRecoverTime.length() );
}

void OnMatchBegin()
{
	HealthSettings();
}

void SetUpStuff()
{
	iUNum = 0;

	Engine.Ent_Fire( "Precache", "kill" );
	Engine.Ent_Fire( "shading", "StartOverlays" );
	
	Engine.Ent_Fire( "item*", "DisableDamageForces" );
	Engine.Ent_Fire( "weapon*", "DisableDamageForces" );

	Engine.Ent_Fire( "LGPlayer", "Kill" );
	
	RemoveAmmoBar();
	SpawnCheese();
}

void OnProcessRound()
{
	if ( g_iFHintIndex.length() != 0 )
	{
		CBaseEntity@ PFHint;

		while ( ( @PFHint = FindEntityByName( PFHint, "hint_frag" ) ) !is null )
		{
			if ( PFHint !is null )
			{
				for ( uint i = 0; i < g_iFHintIndex.length(); i++ )
				{
					if ( PFHint.entindex() == g_iFHintIndex[i] )
					{
						if( g_iFHintRecoverTime[i] <= Globals.GetCurrentTime() )
						{
							BringBack( PFHint );
							g_iFHintIndex.removeAt( i );
							g_iFHintRecoverTime.removeAt( i );
						}	
					}
				}
			}
		}
	}
}

HookReturnCode OnEndTouch( CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity )
{
	if ( strEntityName == "bob_trigger" && pEntity.GetClassname() == "npc_grenade_frag" )
	{	
		pEntity.SetHealth( 25 );
		pEntity.Ignite( 15 );
		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	CBaseEntity@ pParent = pTrigger.GetParent();

	if ( pParent !is null && Utils.StrEql( pParent.GetClassname(), "func_breakable" ) ) pParent.SetHealth( pParent.GetHealth() + pParent.GetMaxHealth() );
	
	return HOOK_CONTINUE;
}

void OnEntityPickedUp( CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( Utils.StrEql( pEntity.GetEntityName(), "base_item_energy" ) )
	{
		g_iStrongLevel[pBaseEnt.entindex()] += 1;
		pEntity.SUB_Remove();
		Chat.CenterMessagePlayer( pPlrEnt, "Power Level of Push: " + g_iStrongLevel[pBaseEnt.entindex()] );
		Utils.ScreenFade( pPlayer, Color( 16, 64, 245, 64 ), 0.35f, 0.0f, fade_in );
	}
}

void OnEntityUsed( CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( Utils.StrEql( pEntity.GetEntityName(), "cheese" ) ) 
	{
		Engine.Ent_Fire_Ent( pEntity, "AddHealth", "-5" );
		Engine.EmitSoundPosition( 0, "@sunshine_ambient/vo/sometimes01.wav", Vector( 0, 0, 0 ), 1.0f, 0, 75 );
	}

	if ( Utils.StrEql( pEntity.GetEntityName(), "base_item_energy" ) )
	{
		g_iStrongLevel[pBaseEnt.entindex()] += 1;
		pEntity.SUB_Remove();
		Chat.CenterMessagePlayer( pPlrEnt, "Power Level of Push: " + g_iStrongLevel[pBaseEnt.entindex()] );
		Utils.ScreenFade( pPlayer, Color( 16, 64, 245, 64 ), 0.35f, 0.0f, fade_in );
		
		Engine.EmitSoundEntity( pEntity, "Popcan.ImpactSoft" );
		pEntity.SUB_Remove();
	}
}

void OnEntityOutput(const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller)
{
	if ( Utils.StrEql( pCaller.GetEntityName(), "cheese" ) )
	{
		if ( Utils.StrEql( strOutput, "OnBreak" ) )
		{
			Schedule::Task(0.25f, "CheeseNoNo");
			Schedule::Task(1.75f, "CheeseNooo");
		}
	}

	if ( Utils.StrEql( pCaller.GetEntityName(), "bust" ) )
	{
		if ( Utils.StrEql( strOutput, "OnPhysPunted" ) )
		{
			Engine.EmitSoundPosition( pCaller.entindex(), "sunshine_ambient/vo/youkilllingme.wav", pCaller.GetAbsOrigin(), 1.0f, 75, Math::RandomInt(25, 157) );
		}

		if ( Utils.StrEql( strOutput, "OnTakeDamage" ) )
		{
			Engine.EmitSoundPosition( pCaller.entindex(), "humans/eugene/pain/pain-0" + Math::RandomInt(1, 6) + ".wav", pCaller.GetAbsOrigin(), 1.0f, 75, Math::RandomInt(25, 157) );
		}
	}
}

void CheeseNoNo()
{
    Engine.EmitSoundPosition( 0, "@sunshine_ambient/vo/no01.wav", Vector( 0, 0, 0 ), 1.0f, 0, 95 );
    SendGameText( any, "The Cheese...", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.0f, 10.0f, Color( 255, 0, 0 ), Color( 0, 0, 0) );
}

void CheeseNooo()
{
    Engine.EmitSoundPosition( 0, "@sunshine_ambient/vo/no01.wav", Vector( 0, 0, 0 ), 1.0f, 0, 95 );
    SendGameText( any, "The Cheese...", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.0f, 10.0f, Color( 255, 0, 0 ), Color( 0, 0, 0) );   
}

void SpawnCheese()
{
	if ( Math::RandomInt( 0, 100 ) <= 75 )
	{
		float RandomYaw = Math::RandomFloat( 0.0f, 360.0f );

		CEntityData@ CheeseIPD = EntityCreator::EntityData();
		CheeseIPD.Add("targetname", "cheese");
		CheeseIPD.Add("model", "models/props_sunshine/cheese.mdl");
		CheeseIPD.Add("overridescript", "surfaceprop,watermelon,");
		CheeseIPD.Add("puntsound", "Flesh_Zombie.BulletImpact");
		CheeseIPD.Add("spawnflags", "256");

		CBaseEntity@ pCheese = EntityCreator::Create( "prop_physics_multiplayer", g_vecCheeseOrigin[Math::RandomInt( 0, 9 )], QAngle( 0, RandomYaw, 0 ), CheeseIPD );

		pCheese.SetMaxHealth( 105 );
		pCheese.SetHealth( 105 );
	}
}

void RemoveAmmoBar()
{
	int iRND;
	
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "item_ammo_barricade" ) ) !is null )
	{
		iRND = Math::RandomInt( 1, 100 );
		if ( iRND < 45 ) pEntity.SUB_Remove();
	}
}

void HealthSettings()
{
	CBaseEntity@ pEntity;

	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_physics_multiplayer" ) ) !is null )
	{
		if ( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ) )
		{
			pEntity.SetHealth( 20 );
		}

		else if ( Utils.StrContains( "props_junk/glass", pEntity.GetModelName() ) )
		{
			pEntity.SetHealth( 5 );
		}

		else if ( Utils.StrContains( "bust", pEntity.GetEntityName() ) )
		{
			pEntity.SetMaxHealth( 999999 );
			pEntity.SetHealth( 999999 );
		}

		else if ( Utils.StrContains( "cheese", pEntity.GetEntityName() ) ) continue;

		else
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( pEntity.GetHealth() ) );
			pEntity.SetHealth( CalculateHealthPoints( pEntity.GetHealth() ) );
		}
	}

	while ( ( @pEntity = FindEntityByClassname( pEntity, "func_breakable" ) ) !is null )
	{
		if ( Utils.StrContains( "UselessBoards", pEntity.GetEntityName() ) )
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
		else if ( Utils.StrContains( "CeilingHatch", pEntity.GetEntityName() ) )
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 50 ) );
			pEntity.SetHealth( CalculateHealthPoints( 50 ) );
		}
		else if ( Utils.StrContains( "AtticHatch", pEntity.GetEntityName() ) )
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 45 ) );
			pEntity.SetHealth( CalculateHealthPoints( 45 ) );
		}
		else if ( Utils.StrContains( "SewerCap", pEntity.GetEntityName() ) )
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 10 ) );
			pEntity.SetHealth( CalculateHealthPoints( 10 ) );
		}
		else if ( Utils.StrContains( "lockers_breakable", pEntity.GetEntityName() ) )
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 11 ) );
			pEntity.SetHealth( CalculateHealthPoints( 11 ) );
		}
	}

	while ( ( @pEntity = FindEntityByClassname( pEntity, "func_physbox" ) ) !is null )
	{
		if ( Utils.StrContains( "physd", pEntity.GetEntityName() ) )
		{
			pEntity.SetMaxHealth( CalculateHealthPoints( 52 ) );
			pEntity.SetHealth( CalculateHealthPoints( 52 ) );
		}
	}
}

void BringBack( CBaseEntity@ PFHint )
{
	float X = PFHint.GetAbsOrigin().x;
	float Y = PFHint.GetAbsOrigin().y;
	float Z = PFHint.GetAbsOrigin().z + 128.0f;

	Vector NewOrigin( X, Y, Z );
	PFHint.SetHealth( 5 );
	PFHint.SetAbsOrigin( NewOrigin );

	CEntityData@ SparkIPD = EntityCreator::EntityData();
	SparkIPD.Add( "spawnflags", "896" );
	SparkIPD.Add( "magnitude", "1" );
	SparkIPD.Add( "trailLength", "1" );
	SparkIPD.Add( "maxdelay", "0" );

	SparkIPD.Add( "SparkOnce", "0", true );
	SparkIPD.Add( "kill", "0", true );

	EntityCreator::Create( "env_spark", NewOrigin, QAngle( -90, 0, 0 ), SparkIPD );	

	Engine.EmitSoundPosition( 0, "items/suitchargeok1.wav", NewOrigin, 0.695f, 75, Math::RandomInt( 135, 165 ) );
}

void HFGiveGrenade( CBaseEntity@ pEntity, CZP_Player@ pPlayer )
{
	if ( pEntity.GetHealth() != 10 )
	{
		g_iFHintIndex.insertLast( pEntity.entindex() );
		g_iFHintRecoverTime.insertLast( Globals.GetCurrentTime() + 2.17f );

		pEntity.SetAbsOrigin( Vector( pEntity.GetAbsOrigin().x, pEntity.GetAbsOrigin().y, pEntity.GetAbsOrigin().z - 128 ) );

		pEntity.SetHealth( 10 );

		CEntityData@ FragIPD = EntityCreator::EntityData();
		FragIPD.Add("targetname", "test_frag");

		CBaseEntity@ pFrag = EntityCreator::Create( "weapon_frag", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), FragIPD );

		pPlayer.PutToInventory( pFrag );
	}
}