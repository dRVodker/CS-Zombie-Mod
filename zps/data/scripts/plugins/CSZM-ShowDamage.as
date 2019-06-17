#include "../SendGameText"

//some data
int iMaxPlayers;
bool bIsCSZM = false;
float flWaitTime;

array<float> g_flDamage;
array<float> g_flShowDamage;
array<float> g_flSDTimer;

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

void OnPluginInit()
{
	PluginData::SetVersion( "1.0");
	PluginData::SetAuthor( "dR.Vodker");
	PluginData::SetName( "CSZM - Show Damage");

	//Events
	Events::Player::OnPlayerConnected.Hook( @OnKPlayerConnected );
	Events::Player::OnPlayerDamaged.Hook( @OnKPlayerDamaged );
}

void OnMapInit()
{		
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		bIsCSZM = true;
		iMaxPlayers = Globals.GetMaxClients();
				
		g_flDamage.resize( iMaxPlayers + 1 );
		g_flShowDamage.resize( iMaxPlayers + 1 );
		g_flSDTimer.resize( iMaxPlayers + 1 );
		
		flWaitTime = Globals.GetCurrentTime() + 0.10f;
	}
}

void OnNewRound()
{
	if ( bIsCSZM == true )
	{
		for ( int i = 1; i <= iMaxPlayers; i++ ) 
		{
			g_flDamage[i] = 0.0f;
			g_flShowDamage[i] = 0.0f;
			g_flSDTimer[i] = 0.0f;
			
			flWaitTime = Globals.GetCurrentTime() + 0.10f;
		}
	}
}

void OnMapShutdown()
{
	if ( bIsCSZM == true )
	{
		bIsCSZM = false;
		
		flWaitTime = 0.0f;
		
		ClearFloatArray( g_flDamage );
		ClearFloatArray( g_flShowDamage );
		ClearFloatArray( g_flSDTimer );
	}
}

void OnProcessRound()
{
	if ( bIsCSZM == true )
	{
		if ( flWaitTime <= Globals.GetCurrentTime() )
		{
			flWaitTime = Globals.GetCurrentTime() + 0.10f;
			
			for ( int i = 1; i <= iMaxPlayers; i++ )
			{
				CZP_Player@ pPlayer = ToZPPlayer( i );

				if ( pPlayer is null ) continue;

				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

				if ( g_flSDTimer[i] > 0 )
				{
					g_flSDTimer[i] -= 0.1f;
				}
				
				if ( g_flSDTimer[i] <= 0 && g_flShowDamage[i] > 0 )
				{
					g_flShowDamage[i] = 0;
				}
			}
		}
	}
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

HookReturnCode OnKPlayerConnected( CZP_Player@ pPlayer )
{
	if ( bIsCSZM == true )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		g_flDamage[pBaseEnt.entindex()] = 0.0f;
		g_flShowDamage[pBaseEnt.entindex()] = 0.0f;
		g_flSDTimer[pBaseEnt.entindex()] = 0.0f;
		
		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnKPlayerDamaged( CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo )
{
	if ( bIsCSZM == true )
	{
		CZP_Player@ pPlrAttacker = null;
		CBasePlayer@ pBPlrAttacker = null;
	
		const int iDamageType = DamageInfo.GetDamageType();
	
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		const int iVicIndex = pBaseEnt.entindex();
		const int iVicTeam = pBaseEnt.GetTeamNumber();
		
		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
		
		const int iAttIndex = pEntityAttacker.entindex();
		const bool bIsAttPlayer = pEntityAttacker.IsPlayer();
		
		if ( bIsAttPlayer == true )
		{
			@pPlrAttacker = ToZPPlayer( iAttIndex );
			@pBPlrAttacker = ToBasePlayer( iAttIndex );
		}
		else return HOOK_HANDLED;

		if ( iAttIndex == iVicIndex ) return HOOK_HANDLED;

		if ( iVicTeam == pEntityAttacker.GetTeamNumber() ) return HOOK_HANDLED;

		if ( iVicTeam == 0 || iVicTeam == 1 ) return HOOK_HANDLED;
		
		if ( pEntityAttacker.GetTeamNumber() == 2 )
		{
			g_flSDTimer[iAttIndex] = 0.8f;
			
			float flHPD = 0;
			float flHP = pBaseEnt.GetHealth();
			float flDMG = floor( DamageInfo.GetDamage() );
			
			if ( flHP < flDMG )
			{
				flHPD = flHP - flDMG;
				flHPD = flDMG + flHPD;
				
				g_flDamage[iAttIndex] += flHPD;
				g_flShowDamage[iAttIndex] += flHPD;
			}
			
			else if ( DamageInfo.GetDamage() >= pBaseEnt.GetMaxHealth() && pBaseEnt.GetHealth() <= pBaseEnt.GetMaxHealth() )
			{
				g_flDamage[iAttIndex] += pBaseEnt.GetMaxHealth();
				g_flShowDamage[iAttIndex] += pBaseEnt.GetMaxHealth();
			}
			
			else
			{
				g_flDamage[iAttIndex] += floor( DamageInfo.GetDamage() );
				g_flShowDamage[iAttIndex] += floor( DamageInfo.GetDamage() );
			}
			
			if ( g_flShowDamage[iAttIndex] > 0 ) Chat.CenterMessagePlayer( pBPlrAttacker, "- "+g_flShowDamage[iAttIndex]+" HP" );

			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}