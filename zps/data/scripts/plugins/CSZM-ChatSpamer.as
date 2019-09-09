//Some data over there
bool bIsCSZM = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat( 3.50f, 10.00f );
const string lb = "{blue}[";
const string rb = "{blue}] ";
const string strCSZM = lb + "{coral}cszm"+rb;

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

array<string> g_strMsg =
{
	strCSZM + "{default}Press {red}F2{default} to choose play as the {lightseagreen}First infected{default}.",
	strCSZM + "{default}If you stuck in spectator mode, press {seagreen}F4{default} to get back to the {green}ready room{default}.",
	strCSZM + "{default}Picked up ammo and {green}antidote{default} will respawn over a period of time.",
	strCSZM + "{default}Zombies getting the {lime}HP Bonus{default} each death!",
	strCSZM + "{default}Commiting suicide as zombie won't give you the {lime}Death HP Bonus{default}.",
	strCSZM + "{default}Use an {green}antidote{default} to increase your resistance to the {green}infection{default}."
};

array<string> g_strMsgToShow;

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Chat Spammer" );
}

void OnMapInit()
{
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		bIsCSZM = true;
	}
}

void OnMapShutdown()
{
	bIsCSZM = false;
	flMsgWaitTime = 0.0f;
}

void OnProcessRound()
{
	if ( bIsCSZM == true )
	{
		if ( flMsgWaitTime <= Globals.GetCurrentTime() )
		{
			flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat( 30.00f, 50.00f );
			ShowMsg();
		}
	}
}

void ShowMsg()
{
	if ( g_strMsgToShow.length() == 0 )
	{
		for ( uint i = 0; i < g_strMsg.length(); i++ )
		{
			g_strMsgToShow.insertLast( g_strMsg[i] );
		}
	}

	int iRNG = Math::RandomInt( 0, g_strMsgToShow.length() - 1 );

	SD( g_strMsgToShow[iRNG] );
	g_strMsgToShow.removeAt( iRNG );
}