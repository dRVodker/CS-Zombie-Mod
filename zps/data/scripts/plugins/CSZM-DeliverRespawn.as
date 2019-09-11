void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

//some data
bool bIsCSZM = false;

float flWaitSpawnTime = 0;

array<float> g_flSpawnTime;
array<int> g_iIndex;
array<string> g_strClassname;
array<string> g_strTargetname;
array<Vector> g_vecOrigin;
array<QAngle> g_angAngles;

const float flAntidoteRespawnTime = 70.0f;
const float flAdrenalineRespawnTime = 50.0f;

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Deliver Respawn" );
}

void OnMapInit()
{
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		bIsCSZM = true;
		flWaitSpawnTime = Globals.GetCurrentTime() + 0.01f;

		Entities::RegisterUse( "item_deliver" );
		Entities::RegisterDrop( "item_deliver" );
		Entities::RegisterPickup( "item_deliver" );
	}
}

void OnProcessRound()
{
	if ( flWaitSpawnTime <= Globals.GetCurrentTime() && bIsCSZM )
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

void OnNewRound()
{
	if ( bIsCSZM )
	{
		flWaitSpawnTime = Globals.GetCurrentTime() + 0.01f;
		ClearArray();
	}
}

void OnMapShutdown()
{
	if ( bIsCSZM )
	{
		bIsCSZM = false;
		flWaitSpawnTime = 0;

		Entities::RemoveRegisterUse( "item_deliver" );
		Entities::RemoveRegisterDrop( "item_deliver" );
		Entities::RemoveRegisterPickup( "item_deliver" );
		
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

void ClearArray()
{
	g_flSpawnTime.removeRange( 0, g_flSpawnTime.length() );
	g_iIndex.removeRange( 0, g_iIndex.length() );
	g_strClassname.removeRange( 0, g_strClassname.length() );
	g_strTargetname.removeRange( 0, g_strClassname.length() );
	g_vecOrigin.removeRange( 0, g_vecOrigin.length() );
	g_angAngles.removeRange( 0, g_angAngles.length() );
}

void FindItems()
{
	if ( bIsCSZM )
	{
		g_flSpawnTime.removeRange( 0, g_flSpawnTime.length() );
		g_iIndex.removeRange( 0, g_iIndex.length() );
		g_strClassname.removeRange( 0, g_strClassname.length() );
		g_strTargetname.removeRange( 0, g_strTargetname.length() );
		g_vecOrigin.removeRange( 0, g_vecOrigin.length() );
		g_angAngles.removeRange( 0, g_angAngles.length() );

		g_flSpawnTime.insertLast( -1 );
		g_iIndex.insertLast( 0 );
		g_strClassname.insertLast( "" );
		g_strTargetname.insertLast( "" );
		g_vecOrigin.insertLast( Vector( 0, 0, 0 ) );
		g_angAngles.insertLast( QAngle( 0, 0, 0 ) );

		CBaseEntity@ pEntity;

		while ( ( @pEntity = FindEntityByClassname( pEntity, "item_deliver" ) ) !is null )
		{
			if ( pEntity.GetEntityName() == "item_adrenaline" || pEntity.GetEntityName() == "iantidote" )
			{
				InsertValues( pEntity.entindex(), pEntity.GetClassname(), pEntity.GetEntityName(), pEntity.GetAbsOrigin(), pEntity.GetAbsAngles() );
			}
		}
	}
}

void InsertValues( const int &in iIndex, const string &in strClass, const string &in strName, const Vector &in vecOrigin, const QAngle &in angAngles )
{
	g_flSpawnTime.insertLast( -1 );
	g_iIndex.insertLast( iIndex );
	g_strClassname.insertLast( strClass );
	g_strTargetname.insertLast( strName );
	g_vecOrigin.insertLast( vecOrigin );
	g_angAngles.insertLast( angAngles );
}

void OnEntityPickedUp( CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	if ( bIsCSZM )
	{
		int iIndex = pEntity.entindex();

		float flRespawnT = 60.0f;

		if ( pEntity.GetEntityName() == "iantidote" )
		{
			flRespawnT = flAntidoteRespawnTime;
		}

		else if ( pEntity.GetEntityName() == "item_adrenaline" )
		{
			flRespawnT = flAdrenalineRespawnTime;
		}

		if ( pEntity.GetClassname() == "item_deliver" )
		{
			for ( uint i = 0; i <= g_iIndex.length(); i++ )
			{
				if ( g_iIndex[i] != iIndex )
				{
					continue;
				}

				g_flSpawnTime[i] = Globals.GetCurrentTime() + flRespawnT;
				g_iIndex[i] = -2;
			}
		}
	}
}

void SpawnItem( const int &in iID )
{
	if ( g_strTargetname[iID] == "iantidote" )
	{
		SpawnAntidote( iID );
	}

	else if ( g_strTargetname[iID] == "item_adrenaline" )
	{
		SpawnAdrenaline( iID );
	}

	CEntityData@ SparkIPD = EntityCreator::EntityData();
	SparkIPD.Add( "spawnflags", "896" );
	SparkIPD.Add( "magnitude", "1" );
	SparkIPD.Add( "trailLength", "1" );
	SparkIPD.Add( "maxdelay", "0" );

	SparkIPD.Add( "SparkOnce", "0", true );
	SparkIPD.Add( "kill", "0", true );

	EntityCreator::Create( "env_spark", g_vecOrigin[iID], QAngle( -90, 0, 0 ), SparkIPD );	

	Engine.EmitSoundPosition( 0, "items/suitchargeok1.wav", g_vecOrigin[iID], 0.75f, 80, Math::RandomInt( 130, 145 ) );
}

void SpawnAntidote( const int &in iID )
{
	CEntityData@ AntidoteIPD = EntityCreator::EntityData();

	AntidoteIPD.Add( "targetname", "iantidote" );
	AntidoteIPD.Add( "health", "" + iID );
	AntidoteIPD.Add( "delivername", "Antidote" );
	AntidoteIPD.Add( "glowcolor", "5 250 121" );
	AntidoteIPD.Add( "itemstate", "1" );
	AntidoteIPD.Add( "model", "models/cszm/weapons/w_antidote.mdl" );
	AntidoteIPD.Add( "viewmodel", "models/cszm/weapons/v_antidote.mdl" );
	AntidoteIPD.Add( "printname", "vgui/images/weapons/inoculator" );
	AntidoteIPD.Add( "sound_pickup", "Deliver.PickupGeneric" );
	AntidoteIPD.Add( "weight", "0" );

	AntidoteIPD.Add( "DisableDamageForces", "1", true );

	CBaseEntity@ pItem = EntityCreator::Create( "item_deliver", g_vecOrigin[iID], g_angAngles[iID], AntidoteIPD );

	g_iIndex[iID] = pItem.entindex();
}

void SpawnAdrenaline( const int &in iID )
{
	CEntityData@ AdrenalineIPD = EntityCreator::EntityData();

	AdrenalineIPD.Add( "targetname", "item_adrenaline" );
	AdrenalineIPD.Add( "health", "" + iID );
	AdrenalineIPD.Add( "delivername", "Adrenaline" );
	AdrenalineIPD.Add( "glowcolor", "5 250 121" );
	AdrenalineIPD.Add( "itemstate", "1" );
	AdrenalineIPD.Add( "model", "models/cszm/weapons/w_adrenaline.mdl" );
	AdrenalineIPD.Add( "viewmodel", "models/cszm/weapons/v_adrenaline.mdl" );
	AdrenalineIPD.Add( "printname", "vgui/images/adrenaline" );
	AdrenalineIPD.Add( "sound_pickup", "Deliver.PickupGeneric" );
	AdrenalineIPD.Add( "weight", "0" );

	AdrenalineIPD.Add( "DisableDamageForces", "1", true );

	CBaseEntity@ pItem = EntityCreator::Create( "item_deliver", g_vecOrigin[iID], g_angAngles[iID], AdrenalineIPD );

	g_iIndex[iID] = pItem.entindex();
}