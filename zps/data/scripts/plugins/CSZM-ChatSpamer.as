bool bIsCSZM = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.0f);
const string strCSZM = "{blue}[{coral}cszm{blue}]{gold} ";
const string strInfo = "{blue}[{white}info{blue}]{gold} ";
const array<string> g_strCSZMMsg =
{
	"Находясь в {white}наблюдателях{gold}, нажмите {cornflowerblue}F4{gold} чтоб вернуться в {green}лобби{gold}.",
	"Используйте {cornflowerblue}антитод{gold} для повышения сопротивления к {green}инфекции{gold}.",
	"Нажмите {cornflowerblue}Z {gold}[по умолчанию] или напишите в чат {cornflowerblue}!menu{gold}, чтоб открыть меню.",
	"В {cornflowerblue}Zombie Menu{gold} вы можете приобрести {cornflowerblue}улучшения{gold}.",
	"Получить {cornflowerblue}оружие{gold} или иные {cornflowerblue}полезные предметы{gold} можно только из {cornflowerblue}магазина{gold}.",
	//"Зомби может купить доп. здоровье {cornflowerblue}только 2 раза за раунд{gold}.",
	//"Доп. здоровье зомби сохраняется {cornflowerblue}после возрождения{gold}.",
	"Зомби {red}не сможет{gold} купить новую броню, {cornflowerblue}полностью{gold} не потратив старую.",
	"Зомби получают небольшие {selfmade}деньги{gold}, ломая баррикады или другие вещи.",
	//"Будьте осторожны! У вас всего {cornflowerblue}одна жизнь на раунд{gold}. После смерти вы отправитесь в {white}наблюдатели{gold}.",
	"Мины с {white}белой{gold} обводкой - {cornflowerblue}ничейные{gold}, их можно забрать.",
	"{cornflowerblue}Бронированный{gold} зомби замедляется слабее от получаемого урона.",
	"На картах могут быть спрятаны {selfmade}деньги{gold} в разных местах.",
	"Кувалда убивает любового зомби с {cornflowerblue}одного{gold} удара.",
	"Последний {blue}выживший{gold} имеет 100% имунитет к {green}инфекции{gold}."
};
const array<string> g_strInfoMsg =
{
	"Архив с контентом для CSZM: {cyan}https://yadi.sk/d/8x1gFtYFMo9rgw",
	"Архив с картами сервера: {cyan}https://yadi.sk/d/BG_jU6SMKvHykQ",
	"Steam-чат сервера: {cyan}https://s.team/chat/bvibKkn9"
};

array<string> g_CurrentMSG;
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
		int iCSZMMSGLength = int(g_strCSZMMsg.length());
		for (int i = 0; i < iCSZMMSGLength; i++)
		{
			g_CurrentMSG.insertLast(strCSZM + g_strCSZMMsg[i]);
		}
	}

	int iInfoMSGLength = int(g_strInfoMsg.length());
	for (int i = 0; i < iInfoMSGLength; i++)
	{
		g_CurrentMSG.insertLast(strInfo + g_strInfoMsg[i]);
	}

	flMsgWaitTime = 0.0f;
}

void OnMapShutdown()
{
	flMsgWaitTime = 150.0f;
}

void OnProcessRound()
{
	if (flMsgWaitTime <= Globals.GetCurrentTime())
	{
		flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(27.0f, 48.0f);
		ShowMsg();
	}
}

void ShowMsg()
{
	int iMSGToShowLength = int(g_strMsgToShow.length());
	
	if (iMSGToShowLength == 0)
	{
		int iMSGLength = int(g_CurrentMSG.length());
		for (int i = 0; i < iMSGLength; i++)
		{
			g_strMsgToShow.insertLast(g_CurrentMSG[i]);
		}
	}

	int iRNG = Math::RandomInt(0, iMSGToShowLength - 1);
	Chat.PrintToChat(all, g_strMsgToShow[iRNG]);
	g_strMsgToShow.removeAt(iRNG);
}