void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

//some data
bool bIsCSZM = false;

float flWaitSpawnTime = 0;

int iDroppedAmmoCount = 0;
const int iMaxDroppedAmmo = 32;

array<string> g_strAmmoClass =
{
	"item_ammo_pistol_clip",
	"item_ammo_rifle_clip",
	"item_ammo_revolver_clip",
	"item_ammo_shotgun_clip"
};

array<string> g_strAllowedCN =
{
	"null",					//0
	"item_ammo_pistol",		//1
	"item_ammo_rifle",		//2
	"item_ammo_shotgun",	//3
	"item_ammo_revolver",	//4
	"item_armor"			//5
};

array<float> g_flRespawnTime =
{
	0.0f,	//0
	7.0f,	//1
	22.0f,	//2
	27.0f,	//3
	36.0f,	//4
	39.0f	//5
};

array<float> g_flSpawnTime;
array<int> g_iIndex;
array<string> g_strClassname;
array<Vector> g_vecOrigin;
array<QAngle> g_angAngles;

void OnProcessRound()
{
	if ( bIsCSZM )
	{
		if ( flWaitSpawnTime <= Globals.GetCurrentTime() )
		{
			flWaitSpawnTime = Globals.GetCurrentTime() + 0.01f;

			for ( uint i = 0; i <= g_flSpawnTime.length(); i++ )
			{
				if ( g_flSpawnTime[i] == -1 )
				{
					continue;
				}

				if ( g_flSpawnTime[i] <= Globals.GetCurrentTime() )
				{
					g_flSpawnTime[i] = -1;
					SpawnItem( i );
				}
			}
		}
	}
}

void OnPluginInit()
{
	PluginData::SetVersion(  "1.0"  );
	PluginData::SetAuthor(  "dR.Vodker"  );
	PluginData::SetName(  "CSZM - Items Respawn"  );

	Events::Entities::OnEntityCreation.Hook( @OnEntityCreation );
	Events::Entities::OnEntityDestruction.Hook( @OnEntityDestruction );
}

void RegisterPickup()
{
	for ( uint i = 1; i <= g_strAllowedCN.length() - 1; i++ )
	{
		Entities::RegisterPickup( g_strAllowedCN[i] );
	}
}

void RemoveRegisterPickup()
{
	for ( uint i = 1; i <= g_strAllowedCN.length() - 1; i++ )
	{
		Entities::RemoveRegisterPickup( g_strAllowedCN[i] );
	}
}

void OnMapInit()
{		
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		bIsCSZM = true;
		flWaitSpawnTime = 0;
		iDroppedAmmoCount = 0;

		RegisterPickup();
		
		Engine.PrecacheFile( sound, "items/suitchargeok1.wav" );
	}
}

void OnNewRound()
{
	if ( bIsCSZM )
	{
		ClearArray();
	}
}

void OnMapShutdown()
{
	if ( bIsCSZM )
	{
		iDroppedAmmoCount = 0;
		bIsCSZM = false;
		RemoveRegisterPickup();
		ClearArray();
	}
}

void OnMatchBegin()
{
	if ( bIsCSZM )
	{
		Schedule::Task( 1.75f, "FindItems" );
	}
}

void FindItems()
{
	g_flSpawnTime.removeRange( 0, g_flSpawnTime.length() );
	g_iIndex.removeRange( 0, g_iIndex.length() );
	g_strClassname.removeRange( 0, g_strClassname.length() );
	g_vecOrigin.removeRange( 0, g_vecOrigin.length() );
	g_angAngles.removeRange( 0, g_angAngles.length() );

	g_flSpawnTime.insertLast( -1 );
	g_iIndex.insertLast( 0 );
	g_strClassname.insertLast( "" );
	g_vecOrigin.insertLast( Vector( 0, 0, 0 ) );
	g_angAngles.insertLast( QAngle( 0, 0, 0 ) );

	CBaseEntity@ pEntity;

	for ( uint i = 0; i < g_strAllowedCN.length(); i++ )
	{
		if ( i == 0 )
		{
			continue;
		}

		while ( ( @pEntity = FindEntityByClassname( pEntity, g_strAllowedCN[i] ) ) !is null )
		{
			InsertValues( pEntity.entindex(), pEntity.GetClassname(), pEntity.GetAbsOrigin(), pEntity.GetAbsAngles() );
		}
	}
}

void InsertValues( const int &in iIndex, const string &in strClass, const Vector &in vecOrigin, const QAngle &in angAngles )
{
	g_flSpawnTime.insertLast( -1 );
	g_iIndex.insertLast( iIndex );
	g_strClassname.insertLast( strClass );
	g_vecOrigin.insertLast( vecOrigin );
	g_angAngles.insertLast( angAngles );
}

void ClearArray()
{
	g_flSpawnTime.removeRange( 0, g_flSpawnTime.length() );
	g_iIndex.removeRange( 0, g_iIndex.length() );
	g_strClassname.removeRange( 0, g_strClassname.length() );
	g_vecOrigin.removeRange( 0, g_vecOrigin.length() );
	g_angAngles.removeRange( 0, g_angAngles.length() );
}

HookReturnCode OnEntityCreation( const string &in strClassname, CBaseEntity@ pEntity )
{
	if ( bIsCSZM )
	{
		if ( Utils.StrContains( "weapon", strClassname ) || Utils.StrContains( "item", strClassname ) )
		{
			Engine.Ent_Fire_Ent( pEntity, "DisableDamageForces" );
		}

		if ( Utils.StrContains( "clip", strClassname ) && strClassname != "item_ammo_barricade_clip" )
		{
			pEntity.SetEntityName( "dropped_ammo" );

			uint iType = 0;

			for ( uint ui = 0; ui < g_strAmmoClass.length(); ui++ )
			{
				if ( strClassname == g_strAmmoClass[ui] )
				{
					iDroppedAmmoCount++;
					iType = ui;
				}
			}

			if ( iDroppedAmmoCount > iMaxDroppedAmmo )
			{
				uint iResult = 1;
				if ( ( iDroppedAmmoCount - iMaxDroppedAmmo ) > 0 )
				{
					iResult = iDroppedAmmoCount - iMaxDroppedAmmo;
				}

				RemoveExtraClip( iResult );
			}
		}
	}
	
	return HOOK_CONTINUE;
}

void OnEntityPickedUp( CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	if ( bIsCSZM )
	{
		pEntity.SetHealth( -1 );

		for ( uint ui = 1; ui <= g_strAllowedCN.length() - 1; ui++ )
		{
			if ( pEntity.GetClassname() == g_strAllowedCN[ui] )
			{
				int iIndex = pEntity.entindex();

				for ( uint i = 0; i <= g_strClassname.length(); i++ )
				{
					if ( g_iIndex[i] != iIndex )
					{
						continue;
					}

					g_flSpawnTime[i] = Globals.GetCurrentTime() + g_flRespawnTime[ui];
					g_iIndex[i] = -2;
					pEntity.SUB_Remove();
				}
			}
		}
	}
}

HookReturnCode OnEntityDestruction( const string &in strClassname, CBaseEntity@ pEntity )
{
	if ( bIsCSZM )
	{
		RemoveIndex( pEntity.entindex(), pEntity.GetHealth(), strClassname );

		if ( Utils.StrContains( "clip", strClassname ) && strClassname != "item_ammo_barricade_clip" )
		{
			uint iType = 0;

			for ( uint ui = 0; ui < g_strAmmoClass.length(); ui++ )
			{
				if ( strClassname == g_strAmmoClass[ui] )
				{
					iDroppedAmmoCount--;
					if ( iDroppedAmmoCount < 0 )
					{
						iDroppedAmmoCount = 0;
					}
				}
			}
		}

		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

void RemoveIndex( const int &in iRIndex, const int &in iRHealth, const string strClassname )
{
	if ( iRHealth != -1 )
	{
		for ( uint ui = 0; ui < g_iIndex.length(); ui++ )
		{
			if ( g_iIndex[ui] == iRIndex && g_strClassname[ui] == strClassname )
			{
				g_flSpawnTime.removeAt( ui );
				g_iIndex.removeAt( ui );
				g_strClassname.removeAt( ui );
				g_vecOrigin.removeAt( ui );
				g_angAngles.removeAt( ui );
			}
		}
	}
}

void SpawnItem( const int &in iID )
{
	CEntityData@ ItemIPD = EntityCreator::EntityData();
	ItemIPD.Add( "targetname", "cszm_respawned_item" );
	ItemIPD.Add( "health", "" + iID );

	ItemIPD.Add( "DisableDamageForces", "1", true );

	CBaseEntity@ pItem = EntityCreator::Create( g_strClassname[iID], g_vecOrigin[iID], g_angAngles[iID], ItemIPD );

	g_iIndex[iID] = pItem.entindex();

	CEntityData@ SparkIPD = EntityCreator::EntityData();
	SparkIPD.Add( "spawnflags", "896" );
	SparkIPD.Add( "magnitude", "1" );
	SparkIPD.Add( "trailLength", "1" );
	SparkIPD.Add( "maxdelay", "0" );

	SparkIPD.Add( "SparkOnce", "0", true );
	SparkIPD.Add( "kill", "0", true );

	EntityCreator::Create( "env_spark", g_vecOrigin[iID], QAngle( -90, 0, 0 ), SparkIPD );	

	Engine.EmitSoundPosition( 0, "items/suitchargeok1.wav", g_vecOrigin[iID], 0.695f, 75, Math::RandomInt( 135, 165 ) );
}

void RemoveExtraClip( const uint &in iUnit )
{
	array<CBaseEntity@> g_pAmmoEntity;
	CBaseEntity@ pAmmoEntity;

	while ( ( @pAmmoEntity = FindEntityByName( pAmmoEntity, "dropped_ammo" ) ) !is null )
	{
		g_pAmmoEntity.insertLast( pAmmoEntity );
	}

	if ( iUnit == 1 )
	{
		g_pAmmoEntity[0].SUB_Remove();
	}

	else
	{
		for ( uint uii = 0; uii <= iUnit; uii++ )
		{
			g_pAmmoEntity[uii].SUB_Remove();
		}
	}
}