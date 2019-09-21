#include "../SendGameText"
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

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SPECTATORS = 1;
const int TEAM_SURVIVORS = 2;
const int TEAM_ZOMBIES = 3;

const float CONST_SHOWDMG_RESET = 1.35f;

int iMaxPlayers;
bool bIsCSZM = false;

class CShowDamage
{
	int PlayerIndex;
	int VicIndex; 
	int Hits;
	float DamageDealt;
	float Reset;
	float Wait;
	bool Show;

	CShowDamage( int index )
	{
		PlayerIndex = index;
		VicIndex = 0;
		Hits = 0;
		DamageDealt = 0.0f;
		Reset = 0.0f;
		Wait = 0.0f;
		Show = false;
	}

	void AddDamage( float flDamage, CBaseEntity@ pVictim )
	{	
		if ( pVictim is null )
		{
			return;
		}

		int VicHP = pVictim.GetHealth();
		VicIndex = pVictim.entindex();
		Hits++;
		Reset = Globals.GetCurrentTime() + CONST_SHOWDMG_RESET;
		Wait = Globals.GetCurrentTime() + 0.005f;
		Show = true;

		if ( VicHP - flDamage <= 0 )
		{
			DamageDealt += VicHP;
		}

		else
		{
			DamageDealt += flDamage;
		}
	}

	void Think()
	{
		if ( Reset <= Globals.GetCurrentTime() && Reset != 0 )
		{
			Reset = 0.0f;
			VicIndex = 0;
			DamageDealt = 0.0f;
			Hits = 0;
			Show = false;
		}

		if ( Show && Wait <= Globals.GetCurrentTime() && Wait != 0 )
		{
			Wait = 0;
			Show = false;

			CBasePlayer@ pBasePlayer = ToBasePlayer( PlayerIndex );
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex( PlayerIndex );
			CBaseEntity@ pVictim = FindEntityByEntIndex( VicIndex );

			int VicHP = pVictim.GetHealth();

			if ( VicHP < 0 )
			{
				VicHP = 0;
			}

			string strHits = " hits";

			if ( Hits == 1 )
			{
				strHits = " hit";
			}

			if ( pPlayerEntity.GetTeamNumber() == TEAM_SURVIVORS )
			{
				Chat.CenterMessagePlayer( pBasePlayer, "Damage dealt: " + int( DamageDealt ) + "\nin " + Hits + strHits + "\nHealth left: " + VicHP );
			}
		}
	}
}

array<CShowDamage@> ShowDamageArray;

void OnMapInit()
{
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		bIsCSZM = true;
		iMaxPlayers = Globals.GetMaxClients();

		ShowDamageArray.resize( iMaxPlayers + 1 );	
	}
}
/*
void OnNewRound()
{
	if ( !bIsCSZM )
	{
		return;
	}
}

void OnMapShutdown()
{
	if ( !bIsCSZM )
	{
		return;
	}
}
*/
void OnProcessRound()
{
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CShowDamage@ pShowDamage = ShowDamageArray[i];

		if ( pShowDamage !is null )
		{
			pShowDamage.Think();
		}
	}
}

HookReturnCode OnKPlayerConnected( CZP_Player@ pPlayer )
{
	if ( !bIsCSZM )
	{
		return HOOK_CONTINUE;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	
	ShowDamageArray.removeAt( iIndex );
	ShowDamageArray.insertAt( iIndex, CShowDamage( iIndex ) );

	return HOOK_CONTINUE;
}

HookReturnCode OnKPlayerDamaged( CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo )
{
	if ( !bIsCSZM )
	{
		return HOOK_CONTINUE;
	}

	CZP_Player@ pPlrAttacker = null;

	CBasePlayer@ pBPlrAttacker = null;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
	
	const int iVicIndex = pBaseEnt.entindex();
	const int iVicTeam = pBaseEnt.GetTeamNumber();
	const int iAttIndex = pEntityAttacker.entindex();
	const bool bIsAttPlayer = pEntityAttacker.IsPlayer();

	CShowDamage@ pShowDamage = ShowDamageArray[iAttIndex];

	if ( bIsAttPlayer )
	{
		@pPlrAttacker = ToZPPlayer( iAttIndex );
		@pBPlrAttacker = ToBasePlayer( iAttIndex );
	}

	else
	{
		return HOOK_HANDLED;
	}

	if ( pEntityAttacker.GetTeamNumber() == TEAM_SURVIVORS && iVicTeam == TEAM_ZOMBIES )
	{
		pShowDamage.AddDamage( DamageInfo.GetDamage(), pBaseEnt );
	}

	return HOOK_CONTINUE;
}