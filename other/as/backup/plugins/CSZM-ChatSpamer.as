#include "./cszm_modules/chat.as"

bool bIsCSZM = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.00f);
const string lb = "{blue}[";
const string rb = "{blue}] ";
const string strCSZM = lb + "{coral}cszm"+rb;

array<string> g_strMsg =
{
	"{gold}Press {red}F2{gold} to choose play as the {lightseagreen}First infected{gold}.",
	"{gold}If you stuck in spectator mode, press {seagreen}F4{gold} to get back to the {green}ready room{gold}.",
	"{gold}Picked up ammo and {green}antidote{gold} will respawn over a period of time.",
	"{gold}Zombies getting the {lime}HP Bonus{gold} each death!",
	"{gold}Commiting suicide as zombie won't give you the {lime}Death HP Bonus{gold}.",
	"{gold}Use an {green}antidote{gold} to increase your resistance to the {green}infection{gold}.",
	"{gold}Type {green}!chatcom {gold}to see all available chat commands."
};

array<string> g_strMsgToShow;

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Chat Spammer");
}

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
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
	if (bIsCSZM)
	{
		if (flMsgWaitTime <= Globals.GetCurrentTime())
		{
			flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(45.00f, 120.00f);
			ShowMsg();
		}
	}
}

void ShowMsg()
{
	int iMSGToShowLength = int(g_strMsgToShow.length());
	if (iMSGToShowLength == 0)
	{
		int iMSGLength = int(g_strMsg.length());
		for (int i = 0; i < iMSGLength; i++)
		{
			g_strMsgToShow.insertLast(g_strMsg[i]);
		}
	}

	int iRNG = Math::RandomInt(0, iMSGToShowLength - 1);
	SD(strCSZM + g_strMsgToShow[iRNG]);
	g_strMsgToShow.removeAt(iRNG);
}