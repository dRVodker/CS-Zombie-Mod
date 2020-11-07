CASConVar@ pInfectionFate = null;
bool bIsCSZM = false;
bool bShowInfectionRate = false;
float flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(3.50f, 10.0f);
const string strCSZM = "{blue}[{coral}cszm{blue}]{gold} ";
const string strInfo = "{blue}[{white}info{blue}]{gold} ";
const string strZPS = "{blue}[{red}zps{blue}]{gold} ";
const string strInfect = "{blue}[{green}infection rate{blue}]{gold} ";
const array<string> g_strCSZMMsg =
{
	"Находясь в {white}наблюдателях{gold}, нажмите {cornflowerblue}F4{gold} чтоб вернуться в {green}лобби{gold}.",
	"Используйте {cornflowerblue}антитод{gold} для повышения сопротивления к {green}инфекции{gold}.",
	"Нажмите {cornflowerblue}Z {gold}[по умолчанию] или напишите в чат {cornflowerblue}!menu{gold}, чтоб открыть меню.",
	"В {cornflowerblue}Zombie Menu{gold} вы можете приобрести {cornflowerblue}улучшения{gold}.",
	"Получить {cornflowerblue}оружие{gold} или иные {cornflowerblue}полезные предметы{gold} можно только из {cornflowerblue}магазина{gold}.",
	"Зомби {red}не сможет{gold} купить новую броню, {cornflowerblue}полностью{gold} не потратив старую.",
	"Зомби получают небольшие {selfmade}деньги{gold}, ломая баррикады или другие вещи.",
	"Мины с {white}белой{gold} обводкой - {cornflowerblue}ничейные{gold}, их можно забрать.",
	"{cornflowerblue}Бронированный{gold} зомби замедляется слабее от получаемого урона.",
	"На картах могут быть спрятаны {selfmade}деньги{gold} в разных местах.",
	"Кувалда убивает любового зомби с {cornflowerblue}одного{gold} удара.",
	"Последний {blue}выживший{gold} имеет 100% имунитет к {green}инфекции{gold}."
};
const array<string> g_strInfoMsg =
{
	"IP Адрес сервера: {blueviolet}45.12.4.113:27015",
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
	"Белый шприц даёт {selfmade}+30HP{gold}."
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

void OnMapShutdown()
{
	flMsgWaitTime = 150.0f;
	g_CurrentMSG.removeRange(0, g_CurrentMSG.length());
}

void FillArray()
{
	int iLength = 0;
	g_CurrentMSG.removeRange(0, g_CurrentMSG.length());

	if (bIsCSZM)
	{
		iLength = int(g_strCSZMMsg.length());
		for (int i = 0; i < iLength; i++)
		{
			g_CurrentMSG.insertLast(strCSZM + g_strCSZMMsg[i]);
		}
	}

	iLength = int(g_strZPSMsg.length());
	for (int i = 0; i < iLength; i++)
	{
		g_CurrentMSG.insertLast(strZPS + g_strZPSMsg[i]);
	}

	iLength = int(g_strInfoMsg.length());
	for (int i = 0; i < iLength; i++)
	{
		g_CurrentMSG.insertLast(strInfo + g_strInfoMsg[i]);
	}

	flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(35.0f, 50.0f);
}

void OnProcessRound()
{
	if (flMsgWaitTime <= Globals.GetCurrentTime())
	{
		flMsgWaitTime = Globals.GetCurrentTime() + Math::RandomFloat(35.0f, 50.0f);

		(bShowInfectionRate && !bIsCSZM) ? ShowInfectRate() : ShowMsg();
	}
}

void ShowInfectRate()
{
	Chat.PrintToChat(all, strInfect + "Шанс заражения: {red}" +pInfectionFate.GetValue()+ "%");
	bShowInfectionRate = !bShowInfectionRate;
}

void ShowMsg()
{
	bShowInfectionRate = !bShowInfectionRate;
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