void GetRandomVictim()
{
	CZP_Player@ pVictim = GetRandomPlayer( survivor, true );
	CBasePlayer@ pVPlrEnt = pVictim.opCast();
	CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();
	TurnToZ( pVBaseEnt.entindex() );
}

void DisallowWeakZombie()
{
	bSpawnWeak = false;
}

void MovePlrToSpec( CBaseEntity@ pEntPlr )
{
	pEntPlr.ChangeTeam( 0 );
	CZP_Player@ pPlayer = ToZPPlayer( pEntPlr);
	pPlayer.ForceRespawn();
}

int CountPlrs( const int &in iTeamNum )
{
	int iCount = 0;
	
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
	
		if ( pPlayer is null ) continue;
			
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if ( pBaseEnt.GetTeamNumber() == iTeamNum )
		{
			iCount++;
		}
	}
	
	return iCount;
}

void SetDoorFilter( const int &in iFilter )
{
	CBaseEntity@ pEntity;
	while ( ( @pEntity = FindEntityByClassname( pEntity, "prop_door_rotating" ) ) !is null )
	{
		Engine.Ent_Fire_Ent( pEntity, "AddOutput", "doorfilter " + iFilter );
	}
}

void AddSpeed( CZP_Player@ pPlayer, int &in iSpeed )
{
	pPlayer.SetMaxSpeed( pPlayer.GetMaxSpeed() + iSpeed );
}

void ClearIntArray( array<int> &iTarget )
{
    while ( iTarget.length() > 0 )
    {
        iTarget.removeAt( 0 );
    }
}

void ClearFloatArray( array<float> &iTarget )
{
    while ( iTarget.length() > 0 )
    {
        iTarget.removeAt( 0 );
    }
}

void ClearBoolArray( array<bool> &iTarget )
{
    while ( iTarget.length() > 0 )
    {
        iTarget.removeAt( 0 );
    }
}