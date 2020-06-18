namespace Admin
{
	const string STR_NULLPLAYER = "{red}*{gold}Игрок не найден!";
	const array<array<string>> g_ChatComms =
	{
		{ "set",				"Установить значение для доступных переменных" },
		{ "infect",				"Заразить игрока" },
		{ "cure",				"Излечить игрока" },
		{ "showinf",			"Показать очки заражения игрока" },
		{ "showvar",			"Показать переменные" },
		{ "showcom",			"Показать команды" },
		{ "respawn",			"Возродить игрока" },
		{ "toggle_respawn",		"Включить/выключить респавн зомби" },
		{ "givecash",			"Дать денег" }
	}; 
	const array<array<string>> g_VariablesList =
	{
		{ "sd_speed_fraction",	"flCurrs"},
		{ "sd_recover",			"flRecover"},
		{ "sd_slowspeed",		"flPSpeed" },
		{ "seconds",			"iSeconds" },
		{ "zmr_rate",			"flZMRRate" },
		{ "zmr_health",			"iZMRHealth" },
		{ "allow_addtime",		"bAllowAddTime" },
		{ "round_time",			"iRoundTime" },
		{ "gearup_time",		"iGearUpTime" },
		{ "warmup_time",		"iWarmUpTime" },
		{ "wseconds",			"iWUSeconds" },
		{ "zombie_health",		"iZombieHealth" },
		{ "infect_percent",		"flInfectionPercent" },
		{ "extrahp_percent",	"flInfectedExtraHP" },
		{ "zmr_dmgdelay",		"flZMRDamageDelay" }
	};
	const array<string> g_TeamList =
	{
		"{green}лобби{gold}",
		"{white}наблюдателей{gold}",
		"{blue}выживших{gold}",
		"{red}зомби{gold}"
	};

	bool Command(CBasePlayer@ pCaller, CASCommand@ pCC, const bool &in FromChat)
	{
		bool IsCommandExist = false;
		
		if (AdminSystem.PlayerHasFlag(pCaller, GetAdminFlag(gAdminFlagRoot)))
		{
			IsCommandExist = SwitchCom(pCaller, GetCommIndex(pCC.Arg(0)), pCC, FromChat);
		}

		return IsCommandExist;
	}

	CZP_Player@ GetPlayerByTraceLine(CZP_Player@ pCaller)
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

	CZP_Player@ GetPlayer(CZP_Player@ pCaller, const string &in strInput)
	{
		CZP_Player@ pPlayer = null;

		if (Utils.StrEql(strInput, "@aim", true))
		{
			@pPlayer = GetPlayerByTraceLine(pCaller);
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

	int GetCommIndex(const string &in Command)
	{
		int iIndex = -1;
		int iLength = g_ChatComms.length();

		for(int i = 0; i < iLength; i++)
		{
			if (Utils.StrEql(Command, g_ChatComms[i][0], true))
			{
				iIndex = i;
				break;
			}
		}

		return iIndex;
	}

	int GetVarIndex(const string &in Variable)
	{
		int iIndex = -1;
		int iLength = g_VariablesList.length();

		for(int i = 0; i < iLength; i++)
		{
			if (Utils.StrEql(Variable, g_VariablesList[i][0], true) || Utils.StrEql(Variable, g_VariablesList[i][1], true))
			{
				iIndex = i;
				break;
			}
		}

		return iIndex;
	}

	void Infect(CBasePlayer@ pCaller, const string &in strInput)
	{
		CZP_Player@ pPlayer = GetPlayer(pCaller, strInput);

		if (pPlayer is null)
		{
			Chat.PrintToChatPlayer(pCaller, STR_NULLPLAYER);
		}
		else 
		{
			CBasePlayer@ pPlayerBase = pPlayer.opCast();
			CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
			int TeamNum = pPlayerEntity.GetTeamNumber();

			if (TeamNum == TEAM_SURVIVORS)
			{
				string sMsg = (pPlayer is pCaller) ? "{green}*{gold}Вы заразились." : "{violet}*{gold}Администратор заразил вас.";
				TurnToZombie(pPlayerEntity.entindex());
				Chat.PrintToChatPlayer(pPlayerBase, sMsg);
			}
			else
			{
				Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Заразить можно только {blue}выживших{gold}! Выбранный игрокв в команде "+ g_TeamList[TeamNum] +".");
			}
		}
	}

	void GiveCash(CBasePlayer@ pCaller, const int &in nCash, const string &in strInput)
	{
		if (nCash == 0)
		{
			return;
		}

		CZP_Player@ pPlayer = GetPlayer(pCaller, strInput);
		
		if (pPlayer is null)
		{
			Chat.PrintToChatPlayer(pCaller, STR_NULLPLAYER);
		}
		else
		{
			CBasePlayer@ pPlayerBase = pPlayer.opCast();
			CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
			Array_CSZMPlayer[pPlayerEntity.entindex()].AddMoney(nCash);
		}
	}

	void Cure(CBasePlayer@ pCaller, const string &in strInput)
	{
		CZP_Player@ pPlayer = GetPlayer(pCaller, strInput);

		if (pPlayer is null)
		{
			Chat.PrintToChatPlayer(pCaller, STR_NULLPLAYER);
		}
		else
		{
			CBasePlayer@ pPlayerBase = pPlayer.opCast();
			CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
			CSZMPlayer@ pCCZMPlayer = Array_CSZMPlayer[pPlayerEntity.entindex()];
			int TeamNum = pPlayerEntity.GetTeamNumber();

			if (TeamNum == TEAM_ZOMBIES)
			{
				string sMsg = (pPlayer is pCaller) ? "{green}*{gold}Вы излечились." : "{violet}*{gold}Aдминистратор излечил вас от инфекции.";

				if (pCCZMPlayer.FirstInfected)
				{
					DetachEyesLights(pPlayerEntity);
				}

				Vector PlrOrigin = pPlayerEntity.GetAbsOrigin();
				QAngle EyeAngles = pPlayerEntity.EyeAngles();

				Utils.CosmeticRemove(pPlayer, MODEL_KNIFE);
				pPlayerEntity.ChangeTeam(TEAM_SURVIVORS);
				pCCZMPlayer.Cured = true;
				pCCZMPlayer.FirstInfected = false;
				pPlayer.ForceRespawn();

				pPlayerEntity.Teleport(PlrOrigin, EyeAngles, Vector(0, 0, 0));
				Chat.PrintToChatPlayer(pPlayerBase, sMsg );
				Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0, fade_in);

			}
			else
			{
				Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Исцелить можно только {red}зомби{gold}! Выбранный игрокв в команде "+ g_TeamList[TeamNum] +"{gold}.");
			}
		}
	}

	void ChangeVariable(CBasePlayer@ pCaller, const string &in strVariable, string &in strValue)
	{
		string OldValue = "";
		int iVarIndex = GetVarIndex(strVariable);

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
			Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Значение переменной {cornflowerblue}" + g_VariablesList[iVarIndex][1] + " {gold}было изменено на {green}" + strValue + "\n{gold}Предыдущее значение: {green}" + OldValue);
		}
	}

	void ShowInfChance(CBasePlayer@ pCaller, const string &in strInput)
	{
		CZP_Player@ pPlayer = GetPlayer(pCaller, strInput);

		if (pPlayer is null)
		{
			Chat.PrintToChatPlayer(pCaller, STR_NULLPLAYER);
		}
		else
		{
			CBaseEntity@ pPlayerEntity = (pPlayer.opCast()).opCast();
			CSZMPlayer@ pCCZMPlayer = Array_CSZMPlayer[pPlayerEntity.entindex()];
			int iPlrInfectChance = pCCZMPlayer.InfectPoints;

			Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Игрок {green}[{cyan}"+pPlayer.GetPlayerName()+"{green}]{gold} Склонность к заражению{green}: {violet}" + iPlrInfectChance);
		}
	}

	void ShowVariables(CBasePlayer@ pCaller)
	{
		int iLength = int(g_VariablesList.length());
		Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Список переменных:");

		for (int i = 0; i < iLength; i++)
		{
			Chat.PrintToChatPlayer(pCaller, " {blueviolet}- {gold}" + g_VariablesList[i][0]);
		}
	}

	void ShowCommands(CBasePlayer@ pCaller)
	{
		int iLength = int(g_ChatComms.length());
		Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Список команд");

		for (int i = 0; i < iLength; i++)
		{
			Chat.PrintToChatPlayer(pCaller, " {blueviolet}- {gold}" + g_ChatComms[i][0] + " {green}: {blue}" + g_ChatComms[i][1]);
		}
	}

	void RespawnPlayer(CBasePlayer@ pCaller, const int &in TeamNum, const string &in strInput)
	{
		CZP_Player@ pPlayer = GetPlayer(pCaller, strInput);

		if (pPlayer is null)
		{
			Chat.PrintToChatPlayer(pCaller, STR_NULLPLAYER);
		}
		else
		{
			CBasePlayer@ pPlayerBase = pPlayer.opCast();
			CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

			if (TeamNum == TEAM_SPECTATORS)
			{
				Chat.PrintToChatPlayer(pPlayerBase, "{red}*{gold}Нельзя возродить в команду "+g_TeamList[TeamNum]+"!");
			}
			else if (!pPlayerEntity.IsAlive() || pPlayerEntity.GetTeamNumber() == TEAM_SPECTATORS)
			{
				string sMsg = (pPlayer is pCaller) ? "{green}*{gold}Вы возродились." : "{violet}*{gold}Aдминистратор возродил вас в комманде "+g_TeamList[TeamNum]+".";

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

				Chat.PrintToChatPlayer(pPlayerBase, sMsg);
			}
			else
			{
				Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Нельзя возродить живого игрока!");
			}
		}
	}

	void ToggleZombieRespawn(CBasePlayer@ pCaller)
	{
		bAllowZombieRespawn = !bAllowZombieRespawn;
		string strTurn = (bAllowZombieRespawn) ? "включен" : "выключен";
		string strColor = (bAllowZombieRespawn) ? "cyan" : "red";
		Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Респавн зомби {"+strColor+"}"+strTurn+"{gold}!");
	}

	bool SwitchCom(CBasePlayer@ pCaller, const int &in iCommIndex, CASCommand@ pCC, const bool &in FromChat)
	{
		switch(iCommIndex)
		{
			case 0: ChangeVariable(pCaller, pCC.Arg(1), pCC.Arg(2)); break;
			case 1: Infect(pCaller, pCC.Arg(1)); break;
			case 2: Cure(pCaller, pCC.Arg(1)); break;
			case 3: ShowInfChance(pCaller, pCC.Arg(1)); break;
			case 4: ShowVariables(pCaller); break;
			case 5: ShowCommands(pCaller); break;
			case 6: RespawnPlayer(pCaller, Utils.StringToInt(pCC.Arg(1)), pCC.Arg(2)); break;
			case 7: ToggleZombieRespawn(pCaller); break;
			case 8: GiveCash(pCaller, Utils.StringToInt(pCC.Arg(1)), pCC.Arg(2)); break;

			case -1: if (FromChat) {Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Команда не найдена!");} break;
		}

		return iCommIndex >= 0;
	}
}