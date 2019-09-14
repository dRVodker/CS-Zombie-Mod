void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

void CD( const string &in strMsg )
{
	Chat.CenterMessage( all, strMsg );
}

void EmitCountdownSound( const int &in iNumber )
{
	Engine.EmitSound( "CS_FVox" + iNumber );
}

void ShowChatMsg( const string &in strMsg, const int &in iTeamNum )
{
	if ( iTeamNum != -1 )
	{
		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			CZP_Player@ pPlayer = ToZPPlayer( i );

			if ( pPlayer is null )
			{
				continue;
			}

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if ( pBaseEnt.GetTeamNumber() == iTeamNum )
			{
				Chat.PrintToChatPlayer( pPlrEnt, strMsg );
			}
		}
	}
	else
	{
		Chat.PrintToChat( all, strMsg );
	}
}
