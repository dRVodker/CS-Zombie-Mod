const string ACC_STR_NULLPLAYER = "{red}*{gold}Игрок не найден!";

array<array<string>> g_ACC_ChatComms =
{
	{ "/set", "Установить значение для доступных переменных" },
	{ "/infect", "Заразить игрока" },
	{ "/cure", "Излечить игрока" },
	{ "/showpoints", "Показать очки заражения игрока" },
	{ "/showvar", "Показать переменные" },
	{ "/showcom", "Показать команды" },
	{ "/respawn", "Возродить игрока" },
}; 

array<array<string>> g_ACC_VariablesList =
{
	{ "sd_speed_fraction", "flCurrs"},
	{ "sd_recover", "flRecover"},
	{ "sd_slowspeed", "flPSpeed" },
	{ "seconds", "iSeconds" },
	{ "zmr_rate", "flZMRRate" },
	{ "zmr_health", "iZMRHealth" },
	{ "allow_addtime", "bAllowAddTime" },
	{ "round_time", "iRoundTime" },
	{ "gearup_time", "iGearUpTime" },
	{ "warmup_time", "iWarmUpTime" },
	{ "wseconds", "iWUSeconds" },
	{ "zombie_health", "iZombieHealth" },
	{ "infect_percent", "flInfectionPercent" },
	{ "extrahp_percent", "flInfectedExtraHP" },
	{ "zmr_dmgdelay", "flZMRDamageDelay" }
};

array<string> g_ACC_TeamList =
{
	"{green}лобби{gold}",
	"{white}наблюдателей{gold}",
	"{blue}выживших{gold}",
	"{red}зомби{gold}"
};

CZP_Player@ ACC_GetPlayerByTraceLine(CZP_Player@ pCaller)
{
	CZP_Player@ pPlayer = null;

	CBasePlayer@ pCallerBase = pCaller.opCast();
	CBaseEntity@ pCallerEntity = pCallerBase.opCast();

	Vector Forward = pCallerEntity.EyePosition();
	Vector StartPos = pCallerEntity.EyePosition();
	Vector EndPos;

	Globals.AngleVectors(pCallerEntity.EyeAngles(), Forward);

	EndPos = StartPos + Forward * 16000;

	CGameTrace trace;

	Utils.TraceLine(StartPos, EndPos, MASK_ALL, pCallerEntity, COLLISION_GROUP_NONE, trace);

	if (trace.DidHit() && (trace.m_pEnt).IsPlayer())
	{
		@pPlayer = ToZPPlayer(trace.m_pEnt);
	}

	return pPlayer;
}

CZP_Player@ ACC_GetPlayer(CZP_Player@ pCaller, const string &in strInput)
{
	CZP_Player@ pPlayer = null;

	if (Utils.StrEql(strInput, "@aim", true))
	{
		@pPlayer = ACC_GetPlayerByTraceLine(pCaller);
	}
	else if (Utils.StrEql(strInput, "@me", true) || Utils.StrEql(strInput, ""))
	{
		@pPlayer = pCaller;
	}
	else
	{
		@pPlayer = GetPlayerByName(strInput, false);
	}

	return pPlayer;
}

int ACC_GetCommIndex(const string &in Command)
{
	int iIndex = -1;
	int iLength = g_ACC_ChatComms.length();

	for(int i = 0; i < iLength; i++)
	{
		if (Utils.StrEql(Command, g_ACC_ChatComms[i][0], true))
		{
			iIndex = i;
			break;
		}
	}

	return iIndex;
}

int ACC_GetVarIndex(const string &in Variable)
{
	int iIndex = -1;
	int iLength = g_ACC_VariablesList.length();

	for(int i = 0; i < iLength; i++)
	{
		if (Utils.StrEql(Variable, g_ACC_VariablesList[i][0], true) || Utils.StrEql(Variable, g_ACC_VariablesList[i][1], true))
		{
			iIndex = i;
			break;
		}
	}

	return iIndex;
}

void ACC_Infect(CBasePlayer@ pCaller, const string &in strInput)
{
	CZP_Player@ pPlayer = ACC_GetPlayer(pCaller, strInput);

	if (pPlayer is null)
	{
		Chat.PrintToChatPlayer(pCaller, ACC_STR_NULLPLAYER);
	}
	else 
	{
		CBasePlayer@ pPlayerBase = pPlayer.opCast();
		CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
		int TeamNum = pPlayerEntity.GetTeamNumber();

		if (TeamNum == TEAM_SURVIVORS)
		{
			TurnToZombie(pPlayerEntity.entindex());
		}
		else
		{
			Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Заразить можно только {blue}выживших{gold}! Выбранный игрокв в команде "+ g_ACC_TeamList[TeamNum] +".");
		}
	}
}

void ACC_Cure(CBasePlayer@ pCaller, const string &in strInput)
{
	CZP_Player@ pPlayer = ACC_GetPlayer(pCaller, strInput);

	if (pPlayer is null)
	{
		Chat.PrintToChatPlayer(pCaller, ACC_STR_NULLPLAYER);
	}
	else
	{
		CBasePlayer@ pPlayerBase = pPlayer.opCast();
		CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
		CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[pPlayerEntity.entindex()];
		int TeamNum = pPlayerEntity.GetTeamNumber();

		if (TeamNum == TEAM_ZOMBIES)
		{
			if (pCSZMPlayer.IsFirstInfected())
			{
				DetachEyesLights(pPlayerEntity);
			}

			Vector PlrOrigin = pPlayerEntity.GetAbsOrigin();
			QAngle EyeAngles = pPlayerEntity.EyeAngles();

			Utils.CosmeticRemove(pPlayer, MODEL_KNIFE);
			pPlayerEntity.ChangeTeam(TEAM_SURVIVORS);
			pCSZMPlayer.Cured = true;
			pCSZMPlayer.SetFirstInfected(false);
			pPlayer.ForceRespawn();

			pPlayerEntity.Teleport(PlrOrigin, EyeAngles, Vector(0, 0, 0));
			pPlayer.ConsoleCommand("phone");
		}
		else
		{
			Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Исцелить можно только {red}зомби{gold}! Выбранный игрокв в команде "+ g_ACC_TeamList[TeamNum] +"{gold}.");
		}
	}
}

void ACC_ChangeVariable(CBasePlayer@ pCaller, const string &in strVariable, string &in strValue)
{
	string OldValue = "";
	int iVarIndex = ACC_GetVarIndex(strVariable);

	switch(iVarIndex)
	{
		case 0:
			OldValue = "" + flCurrs;
			flCurrs = Utils.StringToFloat(strValue);
		break;

		case 1:
			OldValue = "" + flRecover;
			flRecover = Utils.StringToFloat(strValue);
		break;

		case 2:
			OldValue = "" + flPSpeed;
			flPSpeed = Utils.StringToFloat(strValue);
		break;

		case 3:
			OldValue = "" + iSeconds;
			iSeconds = Utils.StringToInt(strValue);
		break;

		case 4:
			OldValue = "" + flZMRRate;
			flZMRRate = Utils.StringToFloat(strValue);
		break;

		case 5:
			OldValue = "" + iZMRHealth;
			iZMRHealth = Utils.StringToInt(strValue);
		break;

		case 6:
			OldValue = "" + bAllowAddTime;
			bAllowAddTime = (strValue == "true" || strValue == "1");
		break;

		case 7:
			OldValue = "" + iRoundTime;
			iRoundTime = Utils.StringToInt(strValue);
		break;

		case 8:
			OldValue = "" + iGearUpTime;
			iGearUpTime = Utils.StringToInt(strValue);
		break;

		case 9:
			OldValue = "" + iWarmUpTime;
			iWarmUpTime = Utils.StringToInt(strValue);
		break;

		case 10:
			OldValue = "" + iWUSeconds;
			iWUSeconds = Utils.StringToInt(strValue);
		break;

		case 11:
			OldValue = "" + iZombieHealth;
			iZombieHealth = Utils.StringToInt(strValue);
		break;

		case 12:
			OldValue = "" + flInfectionPercent;
			flInfectionPercent = Utils.StringToFloat(strValue);
		break;

		case 13:
			OldValue = "" + flInfectedExtraHP;
			flInfectedExtraHP = Utils.StringToFloat(strValue);
		break;

		case 14:
			OldValue = "" + flZMRDamageDelay;
			flZMRDamageDelay = Utils.StringToFloat(strValue);
		break;

		case -1:
			Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Переменная не найдена!");
		break;
	}

	if (iVarIndex != -1)
	{
		Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Значение переменной {cornflowerblue}" + g_ACC_VariablesList[iVarIndex][1] + " {gold}было изменено на {green}" + strValue + "\n{gold}Предыдущее значение: {green}" + OldValue);
	}
}

void ACC_ShowInfChance(CBasePlayer@ pCaller, const string &in strInput)
{
	CZP_Player@ pPlayer = ACC_GetPlayer(pCaller, strInput);

	if (pPlayer is null)
	{
		Chat.PrintToChatPlayer(pCaller, ACC_STR_NULLPLAYER);
	}
	else
	{
		CBaseEntity@ pPlayerEntity = (pPlayer.opCast()).opCast();
		CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[pPlayerEntity.entindex()];

		int iPlrInfectChance = pCSZMPlayer.GetInfectPoints();
		Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Очки заражения выбранного игрока: {violet}" + iPlrInfectChance);
	}
}

void ACC_ShowVariables(CBasePlayer@ pCaller)
{
	int iLength = int(g_ACC_VariablesList.length());

	Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Список переменных");

	for (int i = 0; i < iLength; i++)
	{
		Chat.PrintToChatPlayer(pCaller, " {violet}- {gold}" + g_ACC_VariablesList[i][0]);
	}
}

void ACC_ShowCommands(CBasePlayer@ pCaller)
{
	int iLength = int(g_ACC_ChatComms.length());

	Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Список команд");

	for (int i = 0; i < iLength; i++)
	{
		Chat.PrintToChatPlayer(pCaller, " {violet}- {gold}" + g_ACC_ChatComms[i][0] + " {green}: {blue}" + g_ACC_ChatComms[i][1]);
	}
}

void ACC_RespawnPlayer(CBasePlayer@ pCaller, const string &in strInput, const int &in TeamNum)
{
	CZP_Player@ pPlayer = ACC_GetPlayer(pCaller, strInput);

	if (pPlayer is null)
	{
		Chat.PrintToChatPlayer(pCaller, ACC_STR_NULLPLAYER);
	}
	else
	{
		CBasePlayer@ pPlayerBase = pPlayer.opCast();
		CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

		if (TeamNum == TEAM_SPECTATORS)
		{
			Chat.PrintToChatPlayer(pPlayerBase, "{red}*{gold}Нельзя возродить в команду "+g_ACC_TeamList[TeamNum]+"!");
		}
		else if (!pPlayerEntity.IsAlive() || pPlayerEntity.GetTeamNumber() == TEAM_SPECTATORS)
		{
			if (TeamNum == TEAM_ZOMBIES)
			{
				pPlayerEntity.ChangeTeam(TEAM_SURVIVORS);
				pPlayer.ForceRespawn();
				pPlayer.SetHudVisibility(true);
				TurnToZombie(pPlayerEntity.entindex());
			}
			else
			{
				pPlayerEntity.ChangeTeam(TeamNum);
				pPlayer.ForceRespawn();
				pPlayer.SetHudVisibility(true);				
			}

			Chat.PrintToChatPlayer(pPlayerBase, "{violet}*{gold}Вы были возрождены администратором.");
		}
		else
		{
			Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Нельзя возродить живого игрока!");
		}
	}
}

void ACC_SwitchCom(CBasePlayer@ pCaller, CASCommand@ pARGSplited, const int &in iCommIndex)
{
	switch(iCommIndex)
	{
		case 0:
			ACC_ChangeVariable(pCaller, pARGSplited.Arg(1), pARGSplited.Arg(2));
		break;

		case 1:
			ACC_Infect(pCaller, pARGSplited.Arg(1));
		break;

		case 2:
			ACC_Cure(pCaller, pARGSplited.Arg(1));
		break;

		case 3:
			ACC_ShowInfChance(pCaller, pARGSplited.Arg(1));
		break;

		case 4:
			ACC_ShowVariables(pCaller);
		break;

		case 5:
			ACC_ShowCommands(pCaller);
		break;

		case 6:
			ACC_RespawnPlayer(pCaller, pARGSplited.Arg(1), Utils.StringToInt(pARGSplited.Arg(2)));
		break;

		case 7:
			ACC_Give(pCaller, pARGSplited.Arg(1));
		break;

		case -1:
			Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Команда не найдена!");
		break;
	}
}

HookReturnCode CSZM_CORE_PlrSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HOOK_RESULT = HOOK_CONTINUE;
	if (!bIsCSZM || pArgs is null) 
	{
		return HOOK_RESULT;
	}

	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	string ARG = pArgs.Arg(1);

	if (ARG.findFirst("/", 0) == 0)
	{
		if (AdminSystem.PlayerHasFlag(pPlayer, GetAdminFlag(gAdminFlagRoot)))
		{
			HOOK_RESULT = HOOK_HANDLED;
			CASCommand@ pARGSplited = StringToArgSplit(ARG, " ");
			int iCommIndex = ACC_GetCommIndex(pARGSplited.Arg(0));

			ACC_SwitchCom(pPlayerBase, pARGSplited, iCommIndex);
		}
	}

	return HOOK_RESULT;	
}