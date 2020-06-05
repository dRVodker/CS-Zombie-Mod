#include "./cszm_modules/chat.as"

bool bIsCSZM = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.00f);
const string lb = "{blue}[";
const string rb = "{blue}] ";
const string strCSZM = lb + "{coral}cszm"+rb;

array<string> g_strMsg =
{
	"{gold}Если вы застряли в наблюдателях, нажмите {seagreen}F4{gold} чтоб вернуться {green}лобби{gold}.",
	"{gold}Используйте {green}антитод{gold} для повышения сопротивления к {green}инфекции{gold}.",
	"{gold}Чтобы увидеть доступные комманды чата, напишите {green}!chatcom{gold} или {green}!help{gold}."
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