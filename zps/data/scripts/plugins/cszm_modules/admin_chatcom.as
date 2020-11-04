namespace Admin
{
	enum ComIndexes {CI_SET, CI_INF, CI_CURE, CI_SHOWI, CI_SHOWV, CI_SHOWC, CI_RESP, CI_TOG_R, CI_GIVECASH, CI_ENDWU, CI_FORCE}
	enum VarIndexes {VI_CURRS, VI_RECOVER, VI_SPEED, VI_SECONDS, VI_ZMRRATE, VI_ZMRHP, VI_AAT, VI_RTIME, VI_GUTIME, VI_WUTIME, VI_WUSECONDS, VI_ZMHEALTH, VI_INFPER, VI_INFEHP, VI_ZMRDD, VI_E_DEFCASH, VI_E_STARTCASH, VI_E_HWIN, VI_E_HKILL, VI_E_ZWIN, VI_E_ZKILL, VI_E_LOSE, VI_E_DMGM = VI_E_LOSE + 1, VI_E_HPM, VI_PROPM, VI_BRUSHM}
	const string STR_NULLPLAYER = "{red}*{gold}Игрок не найден!";
	const array<array<string>> g_ChatComms =
	{
		{
			"set",
			"infect",
			"cure",
			"showinf",
			"showvar",
			"showcom",
			"respawn",
			"toggle_respawn",
			"givecash",
			"endwarmup",
			"forceselect"
		},
		{
			"Установить значение для доступных переменных",
			"Заразить игрока",
			"Излечить игрока",
			"Показать очки заражения игрока",
			"Показать переменные",
			"Показать команды",
			"Возродить игрока",
			"Включить/выключить респавн зомби",
			"Дать денег",
			"Завершить разминку",
			"Принудительно превратить первых зараженных"
		}
	}; 
	const array<array<string>> g_VariablesList =
	{
		{
			"sd_speed_percent",
			"sd_recover",
			"sd_slowspeed",
			"seconds",
			"zmr_rate",
			"zmr_health",
			"allow_addtime",
			"round_time",
			"gearup_time",
			"warmup_time",
			"wseconds",
			"zombie_health",
			"infect_percent",
			"extrahp_percent",
			"zmr_dmgdelay",
			"money_def",
			"money_start",
			"money_hwin",
			"money_hkill",
			"money_zwin",
			"money_zkill",
			"money_lose",
			"money_suicide",
			"money_dmg_percent",
			"money_hp_percent",
			"prop_hp_percent",
			"brush_hp_percent"
		},
		{
			"flCurrs",
			"flRecover",
			"flPSpeed",
			"iSeconds",
			"flZMRRate",
			"iZMRHealth",
			"bAllowAddTime",
			"iRoundTime",
			"iGearUpTime",
			"iWarmUpTime",
			"iWUSeconds",
			"iZombieHealth",
			"flInfectionPercent",
			"flInfectedExtraHP",
			"flZMRDamageDelay",
			"ECO_DefaultCash",
			"ECO_StartingCash",
			"ECO_Human_Win",
			"ECO_Human_Kill",
			"ECO_Zombie_Win",
			"ECO_Zombie_Kill",
			"ECO_Lose",
			"ECO_Damage_Multiplier",
			"ECO_Health_Multiplier",
			"flPropHPPercent",
			"flBrushHPPercent"
		}
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
			IsCommandExist = SwitchCom(pCaller, g_ChatComms[0].find(pCC.Arg(0)), pCC, FromChat);
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
		int iLength = int(g_VariablesList[0].length());
		Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Список переменных:");

		for (int i = 0; i < iLength; i++)
		{
			Chat.PrintToChatPlayer(pCaller, " {blueviolet}- {gold}" + g_VariablesList[0][i]);
		}
	}

	void ShowCommands(CBasePlayer@ pCaller)
	{
		int iLength = int(g_ChatComms[0].length());
		Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Список команд");

		for (int i = 0; i < iLength; i++)
		{
			Chat.PrintToChatPlayer(pCaller, " {blueviolet}- {gold}" + g_ChatComms[0][i] + " {green}: {blue}" + g_ChatComms[1][i]);
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
			else if (!pPlayerEntity.IsAlive() || pPlayerEntity.GetTeamNumber() <= TEAM_SPECTATORS)
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
		//Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Респавн зомби {"+strColor+"}"+strTurn+"{gold}!");
		SD("{green}*{gold}Респавн зомби {"+strColor+"}"+strTurn+"{gold}!");
	}

	void ChangeVariable(CBasePlayer@ pCaller, const string &in strVariable, string &in strValue)
	{
		string OldValue = "";
		int iVarIndex = (g_VariablesList[0].find(strVariable) == -1) ? g_VariablesList[1].find(strVariable) : g_VariablesList[0].find(strVariable);

		switch(iVarIndex)
		{
			case VI_CURRS:
				OldValue = flCurrs;
				flCurrs = Utils.StringToFloat(strValue);
			break;
			case VI_RECOVER:
				OldValue = flRecover;
				flRecover = Utils.StringToFloat(strValue);
			break;
			case VI_SPEED:
				OldValue = flPSpeed;
				flPSpeed = Utils.StringToFloat(strValue);
			break;
			case VI_SECONDS:
				OldValue = formatInt(iSeconds);
				iSeconds = Utils.StringToInt(strValue);
			break;
			case VI_ZMRRATE:
				OldValue = flZMRRate;
				flZMRRate = Utils.StringToFloat(strValue);
			break;
			case VI_ZMRHP:
				OldValue = formatInt(iZMRHealth);
				iZMRHealth = Utils.StringToInt(strValue);
			break;
			case VI_AAT:
				OldValue =  BoolToString(bAllowAddTime);
				bAllowAddTime = (Utils.StrEql("true", strValue, true) || Utils.StrEql("1", strValue, true));
			break;
			case VI_RTIME:
				OldValue = formatInt(iRoundTime);
				iRoundTime = Utils.StringToInt(strValue);
			break;
			case VI_GUTIME:
				OldValue = formatInt(iGearUpTime);
				iGearUpTime = Utils.StringToInt(strValue);
			break;
			case VI_WUTIME:
				OldValue = formatInt(iWarmUpTime);
				iWarmUpTime = Utils.StringToInt(strValue);
			break;
			case VI_WUSECONDS:
				OldValue = formatInt(iWUSeconds);
				iWUSeconds = Utils.StringToInt(strValue);
			break;
			case VI_ZMHEALTH:
				OldValue = formatInt(iZombieHealth);
				iZombieHealth = Utils.StringToInt(strValue);
			break;
			case VI_INFPER:
				OldValue = flInfectionPercent;
				flInfectionPercent = Utils.StringToFloat(strValue);
			break;
			case VI_INFEHP:
				OldValue = flInfectedExtraHP;
				flInfectedExtraHP = Utils.StringToFloat(strValue);
			break;
			case VI_ZMRDD:
				OldValue = flZMRDamageDelay;
				flZMRDamageDelay = Utils.StringToFloat(strValue);
			break;
			case VI_E_DEFCASH:
				OldValue = formatInt(ECO_DefaultCash);
				ECO_DefaultCash = Utils.StringToInt(strValue);
			break;
			case VI_E_STARTCASH:
				OldValue = formatInt(ECO_StartingCash);
				ECO_StartingCash = Utils.StringToInt(strValue);
			break;
			case VI_E_HKILL:
				OldValue = formatInt(ECO_Human_Kill);
				ECO_Human_Kill = Utils.StringToInt(strValue);
			break;
			case VI_E_HWIN:
				OldValue = formatInt(ECO_Human_Win);
				ECO_Human_Win = Utils.StringToInt(strValue);
			break;
			case VI_E_ZWIN:
				OldValue = formatInt(ECO_Zombie_Win);
				ECO_Zombie_Win = Utils.StringToInt(strValue);
			break;
			case VI_E_ZKILL:
				OldValue = formatInt(ECO_Zombie_Kill);
				ECO_Zombie_Kill = Utils.StringToInt(strValue);
			break;
			case VI_E_LOSE:
				OldValue = formatInt(ECO_Lose);
				ECO_Lose = Utils.StringToInt(strValue);
			break;
			case VI_E_DMGM:
				OldValue = ECO_Damage_Multiplier;
				ECO_Damage_Multiplier = Utils.StringToFloat(strValue);
			break;
			case VI_E_HPM:
				OldValue = ECO_Health_Multiplier;
				ECO_Health_Multiplier = Utils.StringToFloat(strValue);
			break;
			case VI_PROPM:
				OldValue = flPropHPPercent;
				flPropHPPercent = Utils.StringToFloat(strValue);
			break;
			case VI_BRUSHM:
				OldValue = flBrushHPPercent;
				flBrushHPPercent = Utils.StringToFloat(strValue);
			break;

			case -1:
				Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Переменная не найдена!");
			break;
		}

		if (iVarIndex != -1)
		{
			Chat.PrintToChatPlayer(pCaller, "{green}*{gold}Значение переменной {cornflowerblue}" + g_VariablesList[1][iVarIndex] + " {gold}было изменено на {green}" + strValue + "\n{gold}Предыдущее значение: {green}" + OldValue);
		}
	}

	bool SwitchCom(CBasePlayer@ pCaller, const int &in iCommIndex, CASCommand@ pCC, const bool &in FromChat)
	{
		switch(iCommIndex)
		{
			case CI_SET: ChangeVariable(pCaller, pCC.Arg(1), pCC.Arg(2)); break;
			case CI_INF: Infect(pCaller, pCC.Arg(1)); break;
			case CI_CURE: Cure(pCaller, pCC.Arg(1)); break;
			case CI_SHOWI: ShowInfChance(pCaller, pCC.Arg(1)); break;
			case CI_SHOWV: ShowVariables(pCaller); break;
			case CI_SHOWC: ShowCommands(pCaller); break;
			case CI_RESP: RespawnPlayer(pCaller, Utils.StringToInt(pCC.Arg(1)), pCC.Arg(2)); break;
			case CI_TOG_R: ToggleZombieRespawn(pCaller); break;
			case CI_GIVECASH: GiveCash(pCaller, Utils.StringToInt(pCC.Arg(1)), pCC.Arg(2)); break;
			case CI_ENDWU: WarmUpEnd(); break;
			case CI_FORCE: SelectPlrsForInfect(); break;

			case -1: if (FromChat) {Chat.PrintToChatPlayer(pCaller, "{red}*{gold}Команда не найдена!");} break;
		}

		return iCommIndex >= 0;
	}
}
