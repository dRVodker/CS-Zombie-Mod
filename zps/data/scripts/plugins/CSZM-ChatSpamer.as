bool bIsCSZM = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.0f);
const string lb = "{blue}[";
const string rb = "{blue}] ";
const string strCSZM = lb + "{coral}cszm"+rb;
const array<string> g_strMsg =
{
	"Находясь в {white}наблюдателях{gold}, нажмите {cornflowerblue}F4{gold} чтоб вернуться в {green}лобби{gold}.",
	"Используйте {cornflowerblue}антитод{gold} для повышения сопротивления к {green}инфекции{gold}.",
	"Нажмите {cornflowerblue}Z {gold}[по умолчанию] или напишите в чат {cornflowerblue}!menu{gold}, чтоб открыть меню.",
	"В {cornflowerblue}Zombie Menu{gold} вы можете приобрести разные {cornflowerblue}улучшения{gold}.",
	"Получить {cornflowerblue}оружие{gold} или иные {cornflowerblue}полезные предметы{gold} можно только из {cornflowerblue}магазина{gold}.",
	"Зомби может купить доп. здоровье {cornflowerblue}только 2 раза за раунд{gold}.",
	"Доп. здоровье зомби сохраняется {cornflowerblue}после возрождения{gold}.",
	"Зомби {red}не сможет{gold} купить новую броню, {cornflowerblue}полностью{gold} не потратив старую.",
	"Зомби получают небольшие {selfmade}деньги{gold}, ломая баррикады или другие вещи.",
	"Будьте осторожны! У вас всего {cornflowerblue}одна жизнь на раунд{gold}. После смерти вы отправитесь в {white}наблюдатели{gold}.",
	"Мины с {white}белой{gold} обводкой - {cornflowerblue}ничейные{gold}, их можно забрать.",
	"{cornflowerblue}Бронированный{gold} зомби замедляется слабее от получаемого урона.",
	"На картах могут быть спрятаны {selfmade}деньги{gold} в разных местах."
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
	bIsCSZM = Utils.StrContains("cszm", Globals.GetCurrentMapName());
}

void OnMapShutdown()
{
	if (!bIsCSZM)
	{
		return;
	}

	bIsCSZM = false;
	flMsgWaitTime = 0.0f;
}

void OnProcessRound()
{
	if (!bIsCSZM)
	{
		return;
	}

	if (flMsgWaitTime <= Globals.GetCurrentTime())
	{
		flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(65.0f, 95.0f);
		ShowMsg();
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
	Chat.PrintToChat(all, strCSZM + "{gold}" + g_strMsgToShow[iRNG]);
	g_strMsgToShow.removeAt(iRNG);
}