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
	strCSZM+"{default}Type {lime}!infect{default} to be the {lightseagreen}first infected{default}.",
	strCSZM+"{default}If you stuck in spectator mode, press {seagreen}F4{default} to get back to the {green}ready room.{default}.",
	strCSZM+"{default}Ammunition and armor respawn over a period of time.",
	strCSZM+"{default}Zombies getting stronger each death!",
	strCSZM+"{default}Dropped ammunition disappear over a period of time."
};

array<bool> g_bIsShown;

void OnPluginInit()
{
	Events::Player::PlayerSay.Hook(@PlayerSay);
}

//Funcs below
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

HookReturnCode PlayerSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pBasePlayer = pPlayer.opCast();
		
		if(Utils.StrEql("!arr2", pArgs.Arg(1)))
		{
			for(uint i = 0; i <= g_bIsShown.length() - 1; i++)
			{
				Chat.PrintToChatPlayer(pBasePlayer, "g_bIsShown["+i+"] = " + g_bIsShown[i]);
			}
			
			return HOOK_HANDLED;
		}

	}
	
	return HOOK_CONTINUE;
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
	bool bYouGotThis = false;
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
	
	while(bYouGotThis != true)
	{
		iRND = Math::RandomInt(1, iLength);
		if(g_bIsShown[iRND] == false)
		{
			bYouGotThis = true;
			g_bIsShown[iRND] = true;
			SD(g_strMsg[iRND]);
		}
	}
}