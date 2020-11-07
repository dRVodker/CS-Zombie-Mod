CASConVar @g_infectRateVar = null;

const int iMaxInfection = 75;
const int iMinInfection = 5;

int iWinStrik = 0;
int iLastWinState = 0;
bool bDisabled;

array<string> g_MSGText = 
{
	"{blue}[{lime}dynamic infection{blue}]{gold}",	// 0 - Типа шапка / просто содержит текст
	"Шанс заражения понижен до:",						// 1 - победили зомби / просто содержит текст
	"Шанс заражения повышен до:",						// 2 - победили люди / просто содержит текст
	"Достигнут максимальный шанс заражения:",			// 3 - просто содержит текст
	"Достигнут минимальный шанс заражения:",			// 4 - просто содержит текст
	""													// 5 - строка для вывода сообщения в начале раунда
};

const array<int> g_PositiveNegative = {0, -1, 1};

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnPluginInit()
{
	PluginData::SetVersion("1.0.0");
	PluginData::SetAuthor("LiveSixx");
	PluginData::SetName("Dynamic infection");
	
	Events::Rounds::RoundWin.Hook(@DI_RoundWin);
	
	@g_infectRateVar = ConVar::Find("sv_zps_infectionrate");
}

HookReturnCode DI_RoundWin(const string &in strMapname, RoundWinState iWinState)
{
	ChangeInfection(iWinState);

	return HOOK_CONTINUE;
}

void OnMapInit()
{
	//В cszm это не нужно но нужно на всех других картах
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bDisabled = true;
	}
}

void OnMapShutdown()
{
	bDisabled = false;
	iWinStrik = 0;
	iLastWinState = 0;
	g_MSGText[5] = "";
}

void OnMatchBegin()
{
	//Не выводить сообщение, если строка пустая
	if (Utils.StrEql("", g_MSGText[3], true))
	{
		return;
	}

	SD(g_MSGText[5]);
	//SD("{blueviolet}iWinStrik: {cyan}" + iWinStrik);
}

void ChangeInfection(int iWinState)
{
	int iCurrentInfection = Utils.StringToInt(g_infectRateVar.GetValue());

	//Условия при кторорых не надо менять инфекцию
	if (iWinState == ws_Stalemate || (iWinState == ws_HumanWin && iCurrentInfection == iMaxInfection) || (iWinState == ws_ZombieWin && iCurrentInfection == iMinInfection) || bDisabled)
	{
		iWinStrik = 0;
		g_MSGText[5] = "";
		return;
	}

	int iNewInfection = 0;

	if (iLastWinState != iWinState)
	{
		iLastWinState = iWinState;
		iWinStrik = 1;
	}
	else
	{
		iWinStrik++;
	}

	iNewInfection = iCurrentInfection + (g_PositiveNegative[iLastWinState] * int(ceil(float(iCurrentInfection  * iWinStrik) * Math::RandomFloat(0.102f, 0.185f)))); //0.25f

	if (iNewInfection >= iMaxInfection)
	{
		iNewInfection = iMaxInfection;
		iWinState = 3;
	}
	else if (iNewInfection <= iMinInfection)
	{
		iNewInfection = iMinInfection;
		iWinState = 4;
	}

	g_infectRateVar.SetValue(formatInt(iNewInfection));
	g_MSGText[5] = g_MSGText[0] + " " + g_MSGText[iWinState] + " {red}" + formatInt(iNewInfection) + "%";
}