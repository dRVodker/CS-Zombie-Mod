CASConVar@ pInfectionFate = null;
bool bIsCSZM = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.0f);
float flInfRateWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.0f);
const string strCSZM = "{blue}[{coral}cszm{blue}]{gold} ";
const string strInfo = "{blue}[{white}info{blue}]{gold} ";
const string strZPS = "{blue}[{red}zps{blue}]{gold} ";
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
	"IP Адрес сервера: {blueviolet}45.12.4.113:27015",
	"Архив с контентом для CSZM: {cyan}https://yadi.sk/d/8x1gFtYFMo9rgw",
	"Архив с картами сервера: {cyan}https://yadi.sk/d/BG_jU6SMKvHykQ",
	"ZB ZP!S Discord-сервер: {cyan}https://discord.gg/uV6n598"
};
const array<string> g_strZPSMsg = //{gold}{cornflowerblue}{selfmade}
{
	"Удерживайте {cornflowerblue}R {gold}чтоб изменить размер доски.",
	"Чтобы разрядить оружие нажмите {cornflowerblue}N{gold}.",
	"Выбрать тип патронов - {cornflowerblue}V{gold}, Бросить выбранный тип - {cornflowerblue}T{gold}.",
	"Если у вас есть {selfmade}ненужные патроны{gold}, нажмите {cornflowerblue}Alt{gold} чтобы выкинуть их.",
	"Доски можно {selfmade}поворачивать{gold} нажатиеми кнопок {cornflowerblue}R{gold} и {cornflowerblue}N{gold}.",
	"Красный шприц даёт {selfmade}+100HP{gold}.",
	"Белый шприц даёт {selfmade}+35HP{gold}."
};

array<string> g_CurrentMSG;
array<string> g_strMsgToShow;

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Chat Spammer");

	@pInfectionFate = ConVar::Find("sv_zps_infectionrate");

	OnMapInit();
}

void OnMapInit()
{
	bIsCSZM = Utils.StrContains("cszm", Globals.GetCurrentMapName());
	FillArray();
}

void FillArray()
{
	g_CurrentMSG.removeRange(0, g_CurrentMSG.length());

	if (bIsCSZM)
	{
		int iCSZMMSGLength = int(g_strCSZMMsg.length());
		for (int i = 0; i < iCSZMMSGLength; i++)
		{
			g_CurrentMSG.insertLast(strCSZM + g_strCSZMMsg[i]);
		}
	}

	int iZPSMSGLength = int(g_strZPSMsg.length());
	for (int i = 0; i < iZPSMSGLength; i++)
	{
		g_CurrentMSG.insertLast(strZPS + g_strZPSMsg[i]);
	}

	int iInfoMSGLength = int(g_strInfoMsg.length());
	for (int i = 0; i < iInfoMSGLength; i++)
	{
		g_CurrentMSG.insertLast(strInfo + g_strInfoMsg[i]);
	}

	flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(60.0f, 90.0f);
	flInfRateWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(25.0f, 30.0f);
}

void OnMapShutdown()
{
	flMsgWaitTime = 150.0f;
	flInfRateWaitTime = 150.0f;
}

void OnProcessRound()
{
	if (flMsgWaitTime <= Globals.GetCurrentTime())
	{
		flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(60.0f, 90.0f);;
		ShowMsg();
	}

	if (!bIsCSZM && flInfRateWaitTime != 0 && flInfRateWaitTime <= Globals.GetCurrentTime())
	{
		flInfRateWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(40.0f, 60.0f);
		Chat.PrintToChat(all, strZPS + "Infection Rate: {green}" +pInfectionFate.GetValue()+ "%");
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