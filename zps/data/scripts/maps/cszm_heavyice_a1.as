#include "cszm_random_def"
#include "../SendGameText"

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

int CHP( int &in iMulti )
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers( survivor, true );
	if( iSurvNum < 4 ) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}

int iMaxPlayers;
int iMysticismAttackerIndex = 0;
float flExpBarrelsWaitTime = 0;

array<string> g_strStartWeapons =
{
	"weapon_usp",
	"weapon_ppk",
	"weapon_glock",
	"weapon_glock18c",
	"weapon_mp5"
};

array<string> g_BreakName = 
{
	"mysticism",
	"powerbox_small",
	"powerbox_large",
	"Tram-Ceiling",
	"RoofAccess"
};

array<int> g_BreakIndex;

array<Vector> g_ExpBarrelOrigin;
array<QAngle> g_ExpBarrelAngles;
array<int> g_ExpBarrelIndex;
array<float> g_ExpBarrelRecover;

array<Vector> g_CeilingOrigin;
array<QAngle> g_CeilingAngles;
array<string> g_CeilingModel;

array<Vector> g_MadLaughOrigin =
{
	Vector( -323.900269, 279.813934, 377.814850 ),
	Vector( -59.336475, -334.928619, 314.448883 ),
	Vector( 456.075470, 169.799622, 106.704620 ),
	Vector( 907.733032, -401.066986, 65.747391 ),
	Vector( 1255.201050, -1501.076172, 129.978668 ),
	Vector( 589.242004, -1518.316528, 228.332870 ),
	Vector( 762.574524, -781.900208, 168.850510 ),
	Vector( 1173.709106, -734.399170, 206.043930 ),
	Vector( 1408.999634, -985.120850, 157.446930 ),
	Vector( 1762.769409, -770.424072, 245.177979 ),
	Vector( 1439.726685, -646.239563, 18.549292 ),
	Vector( 1250.507202, -89.147224, 340.220245 ),
	Vector( 1569.919922, -740.280701, 530.952454 ),
	Vector( 1485.243652, 1397.473999, 579.283630 ),
	Vector( 611.066589, 1055.873657, 183.812958 ),
	Vector( 620.445984, 938.652222, 25.580721 ),
	Vector( 1408.424316, 8.112995, 28.450911 ),
	Vector( 1680.077271, -78.585167, 13.082731 )
};

array<Vector> g_MExplosionOrigin =
{
	Vector( 1325.097290, -184.277893, 33.307758 ),
	Vector( 1011.827515, -473.509094, 25.607576 ),
	Vector( 237.346741, -270.756866, 107.647110 ),
	Vector( 445.926788, 111.564972, 38.406864 ),
	Vector( -467.867188, 329.295929, 25.406727 ),
	Vector( -234.909424, -203.461777, 37.532677 ),
	Vector( 828.984375, -224.542496, 153.126038 ),
	Vector( 1004.267151, 316.870239, 40.513008 ),
	Vector( 1194.631348, -571.635010, 43.626965 ),
	Vector( 1210.464233, -1468.295776, 25.819437 ),
	Vector( 761.654358, -1202.981323, 24.974453 ),
	Vector( 1018.534973, -886.281372, 323.325500 ),
	Vector( 790.314209, 226.318451, 201.898056 )
};

array<Vector> g_vecActiveOrigin;

array<string> g_BreakableCN =
{
	"func_breakable",
	"func_physbox",
	"func_door",
	"prop_physics_multiplayer"
};

array<string> g_FuncBreakName =
{
	"wood",//0
	"glass",//1
	"BalconyGrate",//2
	"UppedBoards",//3
	"mysticism",//4
	"BalconyFloor",//5
	"Tram-Ceiling",//6
	"BalconyFenceSmall",//7
	"RoofAccess",//8
	"powerbox_small",//9
	"powerbox_large",//10
	"HiddenPath",//11
	"Dick-Hook",//12
	"Tram-Stair"//13
};

array<int> g_FuncBreakHP =
{
	64,//0
	1,//1
	84,//2
	3,//3
	42,//4
	24,//5
	41,//6
	35,//7
	43,//8
	17,//9
	32,//10
	20,//11
	25,//12
	21//13
};

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	Engine.PrecacheFile( sound, "ambient/explosions/explode_1.wav" );
	Engine.PrecacheFile( sound, "ambient/explosions/explode_2.wav" );
	Engine.PrecacheFile( sound, "ambient/explosions/explode_3.wav" );
	Engine.PrecacheFile( sound, "ambient/explosions/explode_4.wav" );
	Engine.PrecacheFile( sound, "ambient/explosions/explode_5.wav" );
	Engine.PrecacheFile( sound, "ambient/explosions/explode_6.wav" );
	Engine.PrecacheFile( sound, "ambient/explosions/explode_7.wav" );
	Engine.PrecacheFile( sound, "ambient/explosions/explode_8.wav" );
	Engine.PrecacheFile( sound, "@heavyice_ambient/vo/sometimes01.wav" );
	Engine.PrecacheFile( sound, "@heavyice_ambient/vo/no01.wav" );
	Engine.PrecacheFile( sound, "@heavyice_ambient/vo/no02.wav" );
	Engine.PrecacheFile( sound, "npc/fast_zombie/wake1.wav" );
	Engine.PrecacheFile( sound, "ambient/levels/labs/electric_explosion1.wav" );
	Engine.PrecacheFile( sound, "weapons/crossbow/fire1.wav" );
	Engine.PrecacheFile( sound, "heavyice_ambient/vo/hello1.wav" );
//	Engine.PrecacheFile( sound, "" );
//	Engine.PrecacheFile( sound, "" );

	Entities::RegisterOutput( "OnBreak", "cheese" );
	Entities::RegisterOutput( "OnBreak", "func_breakable" );
	Entities::RegisterOutput( "OnBreak", "ExpBarrels" );

	Entities::RegisterOutput( "OnAwakened", "heavy_props1" );
	Entities::RegisterOutput( "OnAwakened", "heavy_props2" );

	Events::Trigger::OnEndTouch.Hook( @HI_OnEndTouch );
	Events::Trigger::OnStartTouch.Hook( @HI_OnStartTouch );

	Events::Custom::OnEntityDamaged.Hook( @HI_OnEntDamaged );
	Events::Player::OnPlayerSpawn.Hook( @HI_OnPlrSpawn );
	
	Schedule::Task( 0.01f, "SetUpStuff" );
	OverrideLimits();
}

void OnNewRound()
{
	Schedule::Task( 0.01f, "SetUpStuff" );
}

void OnMatchBegin()
{
	Schedule::Task( 0.35f, "GiveStartGear");
	Schedule::Task( 1.00f, "DisableDamageForces" );
	HealthSettings();
}

void OnProcessRound()
{
	if ( flExpBarrelsWaitTime != 0 && flExpBarrelsWaitTime <= Globals.GetCurrentTime() )
	{
		for ( uint i = 0; i < g_ExpBarrelRecover.length(); i++ )
		{
			if ( g_ExpBarrelRecover[i] != 0 && g_ExpBarrelRecover[i] <= Globals.GetCurrentTime() )
			{
				g_ExpBarrelRecover[i] = 0.0f;
				RespawnExpBarrel( i );
			}
		}
	}
}

HookReturnCode HI_OnPlrSpawn( CZP_Player@ pPlayer )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( pBaseEnt.GetTeamNumber() == 3 || pBaseEnt.GetTeamNumber() == 0 ) LittleStar( pBaseEnt );

	return HOOK_HANDLED;
}

HookReturnCode HI_OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if ( pEntity.IsPlayer() )
	{
		CZP_Player@ pPlayer =  ToZPPlayer( pEntity );

		if ( pTrigger.GetAbsOrigin() == Vector( -4792, -1008, -524 ) )
		{	
			if ( pPlayer !is null )
			{
				pPlayer.GiveWeapon( "weapon_snowball" );
				LittleStar( pEntity );
			}
			return HOOK_HANDLED;
		}

		if ( pTrigger.GetAbsOrigin() == Vector( 624, -958, 164 ) && pEntity.GetTeamNumber() == 2 )
		{	
			pEntity.SetEntityName( "BalconyPlr" + pEntity.entindex() );
			Engine.Ent_Fire( "BalconyPlr" + pEntity.entindex(), "AddOutput", "physdamagescale 0" );
			return HOOK_HANDLED;
		}

		if ( pTrigger.GetAbsOrigin() == Vector( 812, 768, 235.5 ) )
		{	
			Engine.EmitSoundPosition( 0, "heavyice_ambient/vo/hello1.wav", Vector( 812, 810, 251 ), 1.0f, 75, 100 );
			Engine.Ent_Fire( "say_hello", "Disable" );
			Engine.Ent_Fire( "say_hello", "Enable", "0", "25.0" );
			return HOOK_HANDLED;
		}
	}

	return HOOK_HANDLED;
}

HookReturnCode HI_OnEndTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if ( pEntity.IsPlayer() )
	{
		CZP_Player@ pPlayer =  ToZPPlayer( pEntity );

		if ( pTrigger.GetAbsOrigin() == Vector( 624, -958, 164 ) )
		{	
			pEntity.SetEntityName( "BalconyPlr" + pEntity.entindex() );
			Engine.Ent_Fire( "BalconyPlr" + pEntity.entindex(), "AddOutput", "physdamagescale 0.1" );
			return HOOK_HANDLED;
		}
	}
	return HOOK_HANDLED;
}

HookReturnCode HI_OnEntDamaged( CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo )
{
	if ( Utils.StrEql( pEntity.GetEntityName(), "bust" ) && DamageInfo.GetDamage() > 1 )
	{
		DamageInfo.SetDamage( 0 );
		Engine.EmitSoundEntity( pEntity, "HeavyIce.BustPain" );
		return HOOK_HANDLED;
	}

	if ( Utils.StrEql( pEntity.GetEntityName(), "cheese" ) && DamageInfo.GetDamageType() == (1<<23) )
	{
		DamageInfo.SetDamage( 25 );
		Engine.Ent_Fire( "cheese_voice", "PlaySound" );
		return HOOK_HANDLED;
	}

	return HOOK_HANDLED;
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

		if ( Utils.StrEql( pCaller.GetEntityName(), "ExpBarrels" ) )
		{
			for ( uint i = 0; i < g_ExpBarrelIndex.length(); i++ )
			{
				if ( pCaller.entindex() == g_ExpBarrelIndex[i] )
				{
					g_ExpBarrelIndex[i] = 0;
					g_ExpBarrelRecover[i] = Globals.GetCurrentTime() + 25.13f;
					break;
				}
			}
		}

		if ( Utils.StrEql( pCaller.GetClassname(), "func_breakable" ) )
		{
			for ( uint i = 0; i < g_BreakIndex.length(); i++ )
			{
				if ( pCaller.entindex() == g_BreakIndex[i] )
				{
					if ( i == 0 && pActivator.IsPlayer() )
					{
						g_BreakIndex[i] = 0;
						Mysticism( pActivator );
						break;
					}

					if ( i == 1 )
					{
						g_BreakIndex[i] = 0;
						PowerBoxExplode( pCaller.GetAbsOrigin() );
						Engine.Ent_Fire( "ho1_light", "FadeToPattern", "a" );
						Engine.EmitSoundPosition( 0, "ambient/levels/labs/electric_explosion1.wav", Vector( 1761.4, -790.36, 256 ), 1.0f, 135, Math::RandomInt( 90, 125 ) );
						break;
					}

					if ( i == 2 )
					{
						g_BreakIndex[i] = 0;
						PowerBoxExplode( pCaller.GetAbsOrigin() );
						if ( g_BreakIndex[0] != 0)
						{
							Engine.Ent_Fire( "ho2_light", "FadeToPattern", "a" );
							Engine.Ent_Fire( "securitybutton1", "kill" );
							Engine.Ent_Fire( "securitybutton_prop1", "skin", "1" );
							Engine.Ent_Fire( "powerbox_shake", "powerbox_shake");
						}
						break;
					}

					if ( i == 3 )
					{
						g_BreakIndex[i] = 0;
						SpawnCeilingEnts();
						break;
					}

					if ( i == 4 )
					{
						g_BreakIndex[i] = 0;
						Engine.EmitSoundPosition( 0, "npc/fast_zombie/wake1.wav", Vector( 630, 808, 309 ), 1.0f, 75, 100 );
						break;
					}
				}
			}
		}
	}

	if ( Utils.StrEql( strOutput, "OnAwakened" ) )
	{
		if( Utils.StrContains( "heavy_props", pCaller.GetModelName() ) ) Engine.Ent_Fire( pCaller.GetEntityName(), "Wake" );
	}
}

void LittleStar( CBaseEntity@ pPlayerEntity )
{
	float flRNG = Math::RandomFloat( 0, 100 );
	int iIndex = pPlayerEntity.entindex();

	if ( flRNG < 2.147f )
	{
		pPlayerEntity.SetEntityName( "plr_ littlestar" + iIndex );
		Engine.Ent_Fire( "plr_ littlestar" + iIndex, "SetLightingOrigin", "littlestar_lighting" );
	}
}

void GiveStartGear()
{
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
							
		if ( pPlayer is null ) continue;

		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex( i );

		if ( pPlayerEntity.GetTeamNumber() == 2 ) 
		{
			pPlayer.AmmoBank( add, pistol, 30 );
			pPlayer.GiveWeapon( "weapon_barricade" );
			pPlayer.GiveWeapon( g_strStartWeapons[ Math::RandomInt( 0, g_strStartWeapons.length() - 1 ) ] );
		}
	}
}

void DisableDamageForces()
{
	Engine.Ent_Fire( "item*", "DisableDamageForces", "1" );
	Engine.Ent_Fire( "weapon*", "DisableDamageForces", "1" );
}

void SetUpStuff()
{
	iMysticismAttackerIndex = 0;

	flExpBarrelsWaitTime = Globals.GetCurrentTime() + 0.1f;
	
	Engine.Ent_Fire( "Precache", "kill" );
	Engine.Ent_Fire( "vrad_shadows", "kill" );
	Engine.Ent_Fire( "temp_expbarrel*", "ForceSpawn" );
	Engine.Ent_Fire( "lobby_*", "Disable" );
	Engine.Ent_Fire( "shading", "StartOverlays" );

	Engine.Ent_Fire( "dr_vodker", "Disable" );
	Engine.Ent_Fire( "hi_greenhouse", "Enable" );
	Engine.Ent_Fire( "hi_greenhouse_nm", "Disable" );
	Engine.Ent_Fire( "KD-Core", "Open" );
	Engine.Ent_Fire( "sky_light1", "FadeToPattern", "f" );
	Engine.Ent_Fire( "Tram-Stair*", "AddOutput", "targetname Tram-Stair" );

	Engine.Ent_Fire( "watermelon", "SetLightingOrigin", "armor_lighting" );
	
	SpawnCheese();

	switch( Math::RandomInt( 1, 3 ) )
	{
		case 1:
			Engine.Ent_Fire( "lobby_knockknock", "Enable" );
		break;
		
		case 2:
			Engine.Ent_Fire( "lobby_raul", "Enable" );
		break;
		
		case 3:
			Engine.Ent_Fire( "lobby_deepcover", "Enable" );
		break;
	}

	g_vecActiveOrigin.removeRange( 0, g_vecActiveOrigin.length() );

	for ( uint i = 0; i < g_MExplosionOrigin.length(); i++ )
	{
		g_vecActiveOrigin.insertLast( g_MExplosionOrigin[i] );
	}

	FindBreakIndexes();
	FindCeilingEnts();
	FindExpBarrels();
}

void FindExpBarrels()
{
	g_ExpBarrelAngles.removeRange( 0, g_ExpBarrelAngles.length() );
	g_ExpBarrelOrigin.removeRange( 0, g_ExpBarrelOrigin.length() );
	g_ExpBarrelIndex.removeRange( 0, g_ExpBarrelIndex.length() );
	g_ExpBarrelRecover.removeRange( 0, g_ExpBarrelRecover.length() );

	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByName( pEntity, "ExpBarrels" ) ) !is null )
	{
		g_ExpBarrelAngles.insertLast( pEntity.GetAbsAngles() );
		g_ExpBarrelOrigin.insertLast( pEntity.GetAbsOrigin() );
		g_ExpBarrelIndex.insertLast( pEntity.entindex() );
		g_ExpBarrelRecover.insertLast( 0.0f );
	}
}

void FindBreakIndexes()
{
	g_BreakIndex.resize( g_BreakName.length() );

	for ( uint i = 0; i < g_BreakName.length(); i++ )
	{
		CBaseEntity@ pEntity;
		@pEntity = FindEntityByName( pEntity, g_BreakName[i] );

		if ( pEntity is null ) continue;

		if ( Utils.StrEql( pEntity.GetEntityName(), g_BreakName[i] ) ) g_BreakIndex[i] = pEntity.entindex();
	}
}

void FindCeilingEnts()
{
	g_CeilingAngles.removeRange( 0, g_CeilingAngles.length() );
	g_CeilingOrigin.removeRange( 0, g_CeilingOrigin.length() );
	g_CeilingModel.removeRange( 0, g_CeilingModel.length() );

	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByName( pEntity, "CeilingProps" ) ) !is null )
	{
		g_CeilingAngles.insertLast( pEntity.GetAbsAngles() );
		g_CeilingOrigin.insertLast( pEntity.GetAbsOrigin() );
		g_CeilingModel.insertLast( pEntity.GetModelName() );
		pEntity.SUB_Remove();
	}

	while ( ( @pEntity = FindEntityByName( pEntity, "CeilingWeapons" ) ) !is null )
	{
		g_CeilingAngles.insertLast( pEntity.GetAbsAngles() );
		g_CeilingOrigin.insertLast( pEntity.GetAbsOrigin() );
		g_CeilingModel.insertLast( pEntity.GetClassname() );
		pEntity.SUB_Remove();
	}
}

void RespawnExpBarrel( const int &in iID )
{
	CEntityData@ ExpBarrelIPD = EntityCreator::EntityData();
	ExpBarrelIPD.Add( "targetname", "ExpBarrels" );
	ExpBarrelIPD.Add( "ExplodeDamage", "400" );
	ExpBarrelIPD.Add( "ExplodeRadius", "350" );
	ExpBarrelIPD.Add( "model", "models/props_heavyice/oildrum001_explosive.mdl" );
	ExpBarrelIPD.Add( "nofiresound", "1" );
	ExpBarrelIPD.Add( "physicsmode", "1" );

	CBaseEntity@ pExpBarrel = EntityCreator::Create( "prop_physics_multiplayer", g_ExpBarrelOrigin[iID], g_ExpBarrelAngles[iID], ExpBarrelIPD );

	Engine.EmitSoundPosition( pExpBarrel.entindex(), "weapons/crossbow/fire1.wav", g_ExpBarrelOrigin[iID], 1.0f, 60, Math::RandomInt( 125, 140 ) );

	g_ExpBarrelIndex[iID] = pExpBarrel.entindex();
}

void PowerBoxExplode( Vector &in Origin )
{
	CEntityData@ SparksIPD = EntityCreator::EntityData();
	SparksIPD.Add( "spawnflags", "0" );
	SparksIPD.Add( "Magnitude", "8" );
	SparksIPD.Add( "TrailLength", "3" );
	SparksIPD.Add( "SparkOnce", "0", true );
	SparksIPD.Add( "kill", "0", true, "0.50" );

	CEntityData@ ExplodeIPD = EntityCreator::EntityData();
	ExplodeIPD.Add( "spawnflags", "1" );
	ExplodeIPD.Add( "iMagnitude", "5" );
	ExplodeIPD.Add( "Explode", "0", true );

	EntityCreator::Create( "env_spark", Origin, QAngle( 0, 0, 0 ), SparksIPD );
	EntityCreator::Create( "env_explosion", Origin, QAngle( 0, 0, 0 ), ExplodeIPD );

	Engine.EmitSoundPosition( 0, "ambient/levels/labs/electric_explosion1.wav", Origin, 1.0f, 135, Math::RandomInt( 90, 125 ) );
}

void SpawnCeilingEnts()
{
	for ( uint i = 0; i < g_CeilingModel.length(); i++ )
	{
		if( Utils.StrContains( "weapon_", g_CeilingModel[i] ) ) EntityCreator::Create( g_CeilingModel[i], g_CeilingOrigin[i], g_CeilingAngles[i] );

		else
		{
			CEntityData@ PropIPD = EntityCreator::EntityData();
			PropIPD.Add( "damagefilter", "filter_no_human" );
			PropIPD.Add( "overridescript", "mass,500," );
			PropIPD.Add( "targetname", "CeilingProps" );
			PropIPD.Add( "Damagetype", "1" );
			PropIPD.Add( "model", g_CeilingModel[i] );

			CBaseEntity@ pProp = EntityCreator::Create( "prop_physics", g_CeilingOrigin[i], g_CeilingAngles[i], PropIPD );
		}
	}

	Engine.Ent_Fire( "BalconyTrigger", "Disable", "0", "1.74");
	Engine.Ent_Fire( "BalconyTrigger", "kill", "0", "1.83" );
}

void SpawnCheese()
{
	Vector NewOrigin = Vector( 680, 688, 165.25 );

	CEntityData@ CheeseIPD = EntityCreator::EntityData();
	CheeseIPD.Add("targetname", "cheese");
	CheeseIPD.Add("model", "models/props_heavyice/cheese.mdl");
	CheeseIPD.Add("overridescript", "surfaceprop,watermelon,");
	CheeseIPD.Add("puntsound", "Flesh_Zombie.BulletImpact");
	CheeseIPD.Add("spawnflags", "256");

	CEntityData@ CheeseVoiceIPD = EntityCreator::EntityData();
	CheeseVoiceIPD.Add( "targetname", "cheese_voice" );
	CheeseVoiceIPD.Add( "message", "@heavyice_ambient/vo/sometimes01.wav" );
	CheeseVoiceIPD.Add( "pitch", "75" );
	CheeseVoiceIPD.Add( "pitchstart", "75" );
	CheeseVoiceIPD.Add( "spawnflags", "49" );
	CheeseVoiceIPD.Add( "health", "10" );
	CheeseVoiceIPD.Add( "radius", "1024" );

	CBaseEntity@ pCheese = EntityCreator::Create( "prop_physics_multiplayer", NewOrigin, QAngle( 0, 66, 0 ), CheeseIPD );
	CBaseEntity@ pCheeseVoice = EntityCreator::Create( "ambient_generic", NewOrigin, QAngle( 0, 0, 0 ), CheeseVoiceIPD );

	pCheese.SetMaxHealth( 256 );
	pCheese.SetHealth( 256 );
}

void CheeseNoNo()
{
	Engine.EmitSoundPosition( 0, "@heavyice_ambient/vo/no01.wav", Vector( 0, 0, 0 ), 1.0f, 0, 95 );
	SendGameText( any, "The Cheese . . . .", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.0f, 10.0f, Color( 255, 0, 0 ), Color( 0, 0, 0) );
}

void CheeseNooo()
{
	Engine.EmitSoundPosition( 0, "@heavyice_ambient/vo/no02.wav", Vector( 0, 0, 0 ), 1.0f, 0, 95 );
	SendGameText( any, "The Cheese . . . .\nAre broken!!!", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.45f, 2.24f, Color( 255, 0, 0 ), Color( 0, 0, 0) );
}

void Mysticism( CBaseEntity@ pActivator )
{
	CZP_Player@ pPlayer =  ToZPPlayer( pActivator );

	iMysticismAttackerIndex = pActivator.entindex();
	
	Utils.ScreenFade( pPlayer, Color( 255, 0, 0, 150 ), 0.5f, 0.0f, fade_in );

	Engine.EmitSoundPlayer( pPlayer, "npc/stalker/go_alert2a.wav");
	
	Engine.Ent_Fire( "ho2_light", "FadeToPattern", "a" );
	Engine.Ent_Fire( "mysticism_fireligth", "FadeToPattern", "a" );
	Engine.Ent_Fire( "hi_greenhouse_nm", "FireUser1" );
	Engine.Ent_Fire( "hi_greenhouse", "FireUser1" );
	Engine.Ent_Fire( "mysticism_shake", "StartShake");
	Engine.Ent_Fire( "fire_small", "stop" );
	Engine.Ent_Fire( "mysticism_blood", "EmitBlood" );
	Engine.Ent_Fire( "ho2_light", "FadeToPattern", "z" );
	Engine.Ent_Fire( "ho2_light", "FadeToPattern", "vgdbertywbhtrjuynrtikjgpvjedbndbzhgdgqbedfvhtyfbfntjdsghfebhrewerttryhtrd", "2.00" );
	Engine.Ent_Fire( "mysticism_light1", "TurnOn", "0", "2.00" );

	MysticismSpawnExplosion();
	MadLaugh();
}

void MysticismSpawnExplosion()
{
	if ( g_vecActiveOrigin.length() > 0 )
	{
		Schedule::Task( 0.4f, "MysticismSpawnExplosion");

		int iRNG = Math::RandomInt( 0, g_vecActiveOrigin.length() - 1 );

		CEntityData@ ExplosionIPD = EntityCreator::EntityData();
		ExplosionIPD.Add( "iMagnitude", "150" );
		ExplosionIPD.Add( "spawnflags", "80" );
		ExplosionIPD.Add( "Explode", "0", true );

		CBaseEntity@ pExplosion = EntityCreator::Create( "env_explosion", g_vecActiveOrigin[iRNG], QAngle( 0, 0, 0 ), ExplosionIPD );
		Engine.EmitSoundPosition( 0, "ambient/explosions/explode_" + Math::RandomInt( 1, 9 ) + ".wav", g_MExplosionOrigin[iRNG], 1.0f, 145, Math::RandomInt( 95, 105 ) );

		CBaseEntity@ pActivator = FindEntityByEntIndex( iMysticismAttackerIndex );
		if ( pActivator !is null ) pExplosion.SetOwner( pActivator );

		g_vecActiveOrigin.removeAt( iRNG );
	}
	else iMysticismAttackerIndex = 0;

	Engine.Ent_Fire( "mysticism_blood", "EmitBlood" );
}

void MadLaugh()
{
	for ( uint i = 0; i < g_MadLaughOrigin.length(); i++ )
	{
		CEntityData@ MadLaughIPD = EntityCreator::EntityData();
		MadLaughIPD.Add( "targetname", "MadLaugh_SND" );
		MadLaughIPD.Add( "message", "heavyice_ambient/vo/madlaugh03.wav" );
		MadLaughIPD.Add( "pitch", "80" );
		MadLaughIPD.Add( "pitchstart", "80" );
		MadLaughIPD.Add( "spawnflags", "0" );
		MadLaughIPD.Add( "health", "5" );
		MadLaughIPD.Add( "radius", "9000" );

		CBaseEntity@ pMadLaugh = EntityCreator::Create( "ambient_generic", g_MadLaughOrigin[i], QAngle( 0, 0, 0 ), MadLaughIPD );
	}

	Engine.Ent_Fire( "MadLaugh_SND", "Kill", "0", "7.14" );
}

void HealthSettings()
{
	CBaseEntity@ pEntity;

	for ( uint i = 0; i < g_BreakableCN.length(); i++ )
	{
		while ( ( @pEntity = FindEntityByClassname( pEntity, g_BreakableCN[i] ) ) !is null )
		{
			if ( i == 0 )
			{
				for ( uint u = 0; u < g_FuncBreakName.length(); u++ )
				{
					if ( Utils.StrEql( pEntity.GetEntityName(), g_FuncBreakName[u] ) ) SetHP( pEntity, g_FuncBreakHP[u] );
				}
			}

			if ( i == 1 || i == 2 ) SetHP( pEntity, 54 );

			if ( i == 3 )
			{
				if( Utils.StrContains( "toycar", pEntity.GetModelName() ) ) pEntity.SetEntityName( "unbrk_toycar" );

				if( Utils.StrContains( "oildrum001_explosive", pEntity.GetModelName() ) )
				{
					Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeDamage 400" );
					Engine.Ent_Fire_Ent( pEntity, "addoutput", "ExplodeRadius 350" );
				}

				else if( Utils.StrContains( "watermelon", pEntity.GetEntityName() ) )
				{
					pEntity.SetMaxHealth( 250 );
					pEntity.SetHealth( 250 );
				}

				else if( Utils.StrContains( "BlueCrate", pEntity.GetEntityName() ) ) SetHP( pEntity, 32 );

				else if( Utils.StrContains( "RedCrate", pEntity.GetEntityName() ) ) SetHP( pEntity, 64 );

				else if( Utils.StrContains( "_tv", pEntity.GetEntityName() ) ) SetHP( pEntity, 42 );

				else if( Utils.StrContains( "props_junk/glass", pEntity.GetModelName() ) ) pEntity.SetHealth( 5 );

				else SetHP( pEntity, int( floor( pEntity.GetHealth() * 0.75 ) ) );
			}
		}
	}
}

void SetHP( CBaseEntity@ pEntity, const int iHP )
{
	pEntity.SetMaxHealth( CHP( iHP ) );
	pEntity.SetHealth( CHP( iHP ) );
}