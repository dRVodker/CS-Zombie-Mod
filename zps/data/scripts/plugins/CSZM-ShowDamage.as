#include "../SendGameText"

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SPECTATORS = 1;
const int TEAM_SURVIVORS = 2;

int iMaxPlayers;
bool bIsCSZM = false;

array<int> g_VicIndex;
array<int> g_Hits;
array<float> g_DamageDealt;
array<float> g_ResetTime;
array<bool> g_Show;

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
				
		g_VicIndex.resize( iMaxPlayers + 1 );
		g_Hits.resize( iMaxPlayers + 1 );
		g_DamageDealt.resize( iMaxPlayers + 1 );
		g_ResetTime.resize( iMaxPlayers + 1 );
		g_Show.resize( iMaxPlayers + 1 );
	}
}

void OnNewRound()
{
	if ( !bIsCSZM ) return;
	
	for ( int i = 1; i <= iMaxPlayers; i++ ) 
	{
		g_Hits[i] = 0;
		g_VicIndex[i] = 0;
		g_DamageDealt[i] = 0.0f;
		g_ResetTime[i] = 0.0f;
		g_Show[i] = false;
	}
}

void OnMapShutdown()
{
	if ( !bIsCSZM ) return;

	g_Hits.removeRange( 0, g_Hits.length() );
	g_VicIndex.removeRange( 0, g_VicIndex.length() );
	g_DamageDealt.removeRange( 0, g_DamageDealt.length() );
	g_ResetTime.removeRange( 0, g_ResetTime.length() );
	g_Show.removeRange( 0, g_Show.length() );
}

HookReturnCode OnKPlayerConnected( CZP_Player@ pPlayer )
{
	if ( !bIsCSZM ) return HOOK_CONTINUE;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int index = pBaseEnt.entindex();
	
	g_Hits[index] = 0;
	g_VicIndex[index] = 0;
	g_DamageDealt[index] = 0.0f;
	g_ResetTime[index] = 0.0f;
	g_Show[index] = false;
	
	return HOOK_CONTINUE;
}

HookReturnCode OnKPlayerDamaged( CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo )
{
	if ( !bIsCSZM ) return HOOK_CONTINUE;

	CZP_Player@ pPlrAttacker = null;
	CBasePlayer@ pBPlrAttacker = null;
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
	const int iVicIndex = pBaseEnt.entindex();
	const int iVicTeam = pBaseEnt.GetTeamNumber();
	const int iAttIndex = pEntityAttacker.entindex();
	const bool bIsAttPlayer = pEntityAttacker.IsPlayer();
	
	if ( bIsAttPlayer )
	{
		@pPlrAttacker = ToZPPlayer( iAttIndex );
		@pBPlrAttacker = ToBasePlayer( iAttIndex );
	}

	else return HOOK_HANDLED;

	if ( iAttIndex == iVicIndex ) return HOOK_HANDLED;
	if ( iVicTeam == pEntityAttacker.GetTeamNumber() ) return HOOK_HANDLED;
	if ( iVicTeam == TEAM_LOBBYGUYS || iVicTeam == TEAM_SPECTATORS ) return HOOK_HANDLED;

	if ( pEntityAttacker.GetTeamNumber() == TEAM_SURVIVORS )
	{
		if ( g_ResetTime[iAttIndex] <= Globals.GetCurrentTime() )
		{
			g_DamageDealt[iAttIndex] = 0.0f;
			g_VicIndex[iAttIndex] = 0;
			g_Hits[iAttIndex] = 0;
		}

		g_Hits[iAttIndex]++;
		g_Show[iAttIndex] = true;
		g_ResetTime[iAttIndex] = Globals.GetCurrentTime() + 1.35f;

		if ( g_VicIndex[iAttIndex] != iVicIndex ) g_VicIndex[iAttIndex] = iVicIndex;
		if ( pBaseEnt.GetHealth() - DamageInfo.GetDamage() <= 0 ) g_DamageDealt[iAttIndex] += pBaseEnt.GetHealth();

		else g_DamageDealt[iAttIndex] += DamageInfo.GetDamage();

		Schedule::Task( 0.01f, "ShowDamageHealth" );

		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

void ShowDamageHealth()
{
	if ( !bIsCSZM ) return;
	
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
						
		if ( pPlayer is null ) continue;

		if ( !g_Show[i] ) continue;

		CBasePlayer@ pBPlrAttacker = ToBasePlayer( i );
		CBaseEntity@ pVicPlayer = FindEntityByEntIndex( g_VicIndex[i] );

		g_Show[i] = false;

		string strHits = " hits";

		if ( g_Hits[i] == 1 ) strHits = " hit";

		if ( pVicPlayer is null ) Chat.CenterMessagePlayer( pBPlrAttacker, "Damage dealt: " + int( g_DamageDealt[i] ) + "\nin " + g_Hits[i] + strHits );

		else
		{
			int iHealth = pVicPlayer.GetHealth();
			if ( iHealth < 0 ) iHealth = 0;
			Chat.CenterMessagePlayer( pBPlrAttacker, "Damage dealt: " + int( g_DamageDealt[i] ) + "\nin " + g_Hits[i] + strHits + "\nHealth left: " + iHealth );
		}
	}
}