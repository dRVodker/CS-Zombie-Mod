//Some data over there
bool bIsCSZM = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.00f);
const string lb = "{blue}[";
const string rb = "{blue}] ";
const string strCSZM = lb+"{coral}cszm"+rb;

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

array<string> g_strMsg =
{
	"null",
	strCSZM+"{default}Press {red}F2{default} to choose play as the {lightseagreen}First infected{default}.",
	strCSZM+"{default}If you stuck in spectator mode, press {seagreen}F4{default} to get back to the {green}ready room{default}.",
	strCSZM+"{default}Picked up ammo and {green}antidote{default} will respawn over a period of time.",
	strCSZM+"{default}Zombies getting the {lime}HP Bonus{default} each death!",
	strCSZM+"{default}Commiting suicide as zombie won't give you the {lime}Death HP Bonus{default}.",
	strCSZM+"{default}Pick up an {green}antidote{default} to increase your resistance to {green}infection{default}."
};

array<bool> g_bIsShown;

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Chat Spammer" );
}

void OnMapInit()
{
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
		
		g_bIsShown.resize(g_strMsg.length());
		for(uint i = 0; i <= g_strMsg.length() - 1; i++)
		{
			g_bIsShown[i] = false;
		}
	}
}

void OnMapShutdown()
{
	bIsCSZM = false;
	flMsgWaitTime = 0.0f;
}

void OnProcessRound()
{
	if(bIsCSZM == true)
	{
		if(flMsgWaitTime <= Globals.GetCurrentTime())
		{
			flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(30.00f, 50.00f);
			ShowMsg();
		}
	}
}

void ShowMsg()
{
	int iRND = 0;
	uint iLength = g_bIsShown.length() - 1;
	uint iCount = 0;
	
	for(uint i = 0; i <= iLength; i++)
	{
		if(g_bIsShown[i] == true) iCount++;
	}	
	
	if(iCount >= iLength)
	{
		for(uint i = 0; i <= iLength; i++)
		{
			g_bIsShown[i] = false;
		}
	}
	
	while(iRND == 0)
	{
		iRND = Math::RandomInt(1, iLength);
		if(g_bIsShown[iRND] == false)
		{
			g_bIsShown[iRND] = true;
			SD(g_strMsg[iRND]);
		}
		else iRND = 0;
	}
}