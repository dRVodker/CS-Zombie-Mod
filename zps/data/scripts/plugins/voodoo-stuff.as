//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//DATA
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

enum ZPS_Teams {TEAM_LOBBYGUYS, TEAM_SPECTATORS, TEAM_SURVIVORS, TEAM_ZOMBIES}
bool bIsCSZM;

string GetAttackerInfo(const string &in FullInfo)
{
	string AttakerInfo = ":";
	if (Utils.StrContains("|", FullInfo))
	{
		int iFirst = FullInfo.findFirst("|", 0) + 1;
		int iLast = FullInfo.findFirst("|", iFirst);
		AttakerInfo = FullInfo.substr(iFirst, iLast - iFirst);
	}

	return AttakerInfo;
}

string EraseAttackerInfo(string &in FullInfo)
{
	if (Utils.StrContains("|", FullInfo))
	{
		int iFirst = FullInfo.findFirst("|", 0) + 1;
		int iLast = FullInfo.findFirst("|", iFirst);
		FullInfo.erase(iFirst - 1, iLast - iFirst + 2);
	}

	return FullInfo;
}

float PlusGT(float flTime)
{
	return Globals.GetCurrentTime() + flTime;
}

bool bDamageType(int &in iSubjectDT, int &in iDMGNum)
{
	return iSubjectDT & (1<<iDMGNum) == (1<<iDMGNum);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Action
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("TheOne");
	PluginData::SetName("VooDoo-Stuff");

	SameStuff();
	Events::Player::OnPlayerSpawn.Hook(@VooDoo_OnPlayerSpawn);
	Events::Player::OnPlayerInitSpawn.Hook(@VooDoo_OnPlayerInitSpawn);
	Events::Custom::OnEntityDamaged.Hook(@VooDoo_OnEntDamaged);
	Events::Custom::OnPlayerDamagedCustom_PRE.Hook(@VooDoo_OnPlayerDamaged);
	Events::Player::PlayerSay.Hook(@VooDoo_PlrSay);
	SendToVodker();
}

void OnMapInit()
{
	SameStuff();
}

void SameStuff()
{
	Engine.EnableCustomSettings(true);
	bIsCSZM = Utils.StrContains("cszm", Globals.GetCurrentMapName());
}

void SendToVodker()
{
	CZP_Player@ pVodker = GetPlayerBySteamID("STEAM_0:0:83782978");

	if (pVodker !is null)
	{
		CBasePlayer@ pPlayerBase = pVodker.opCast();
		Chat.PrintToChatPlayer(pPlayerBase, "{gold}-= {blueviolet}VooDoo Plugin{gold} is {cyan}ONLINE {gold}=-");
	}
}

HookReturnCode VooDoo_OnPlayerSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	if (!bIsCSZM)
	{
		int iLobbyGuySpeed = 25;
		int iExtraSpeed = 20;

		if (pPlayerEntity.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			iExtraSpeed += iLobbyGuySpeed;
		}

		pPlayer.SetMaxSpeed(pPlayer.GetMaxSpeed() + iExtraSpeed);
	}

	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_OnPlayerInitSpawn(CZP_Player@ pPlayer)
{
	string Name = pPlayer.GetPlayerName();
	string IP = pPlayer.GrabIP();
	string SteamID64 = pPlayer.GetSteamID64();

	Log.PrintToServerConsole(LOGTYPE_INFO, "IPs", "Player ["+Name+"] | SteamID64 ["+SteamID64+"] | IP Address ["+IP+"]");

	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_OnPlayerDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &out DamageInfo)
{
	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();
	int iAttakerIndex = pAttacker.entindex();
	int iAttakerTeam = pAttacker.GetTeamNumber();
	int iDamageType = DamageInfo.GetDamageType();

	if (!bIsCSZM)
	{
		if (!pAttacker.IsPlayer())
		{
			if (Utils.StrEql(pAttacker.GetClassname(), "worldspawn") && bDamageType(iDamageType, 0))
			{
				DamageInfo.SetDamageType(1<<9);
				DamageInfo.SetDamage(0);
			}
		}

		if (Utils.StrContains("physics", pAttacker.GetClassname()) || Utils.StrContains("physbox", pAttacker.GetClassname()))
		{
			string AttInfo = GetAttackerInfo(pAttacker.GetEntityDescription());
			CASCommand@ pSplitArgs = StringToArgSplit(AttInfo, ":");
			int iPhysAttacker = Utils.StringToInt(pSplitArgs.Arg(0));

			if (iPhysAttacker > 0)
			{
				DamageInfo.SetAttacker(FindEntityByEntIndex(iPhysAttacker));
			}
		}
	}
	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();
	int iAttakerIndex = pAttacker.entindex();
	int iAttakerTeam = pAttacker.GetTeamNumber();
	string strEntClassname = pEntity.GetClassname();

	if (!bIsCSZM)
	{
		if (pAttacker.IsPlayer() && (Utils.StrContains("physics", strEntClassname) || Utils.StrContains("physbox", strEntClassname)))
		{
			string EntDesc = pEntity.GetEntityDescription();
			string AttInfo = GetAttackerInfo(EntDesc);
			CASCommand@ pSplitArgs = StringToArgSplit(AttInfo, ":");
			bool bSetNewAttacker = true;
			EntDesc = EraseAttackerInfo(EntDesc);
			if (pSplitArgs.Args() > 1)
			{
				if (Utils.StringToFloat(pSplitArgs.Arg(1)) > Globals.GetCurrentTime() && Utils.StringToInt(pSplitArgs.Arg(0)) != iAttakerIndex)
				{
					bSetNewAttacker = false;
				}
			}

			if (bSetNewAttacker)
			{
				pEntity.ChangeTeam(iAttakerTeam);
				pEntity.SetEntityDescription(EntDesc + "|" + iAttakerIndex + ":" + "" + (PlusGT(7.04f)) + "|");
			}
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_PlrSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HOOK_RESULT = HOOK_CONTINUE;
	if (pArgs is null) 
	{
		return HOOK_RESULT;
	}

	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	int index = pPlayerEntity.entindex();
	string ARG = pArgs.Arg(1);

	if (ARG.findFirst("/", 0) == 0 && ARG.length() > 1 && AdminSystem.PlayerHasFlag(pPlayer, GetAdminFlag(gAdminFlagRoot)))
	{
		HOOK_RESULT = HOOK_HANDLED;
		ARG = Utils.StrReplace(ARG, "/", "");
		if (Utils.StrEql(ARG, "to_spec"))
		{
			pPlayerEntity.ChangeTeam(TEAM_LOBBYGUYS);
			pPlayer.ConsoleCommand("choose3");
		}
		else if (Utils.StrEql(ARG, "to_lobby"))
		{
			pPlayerEntity.ChangeTeam(TEAM_LOBBYGUYS);
			pPlayer.ForceRespawn();
		}
		else if (Utils.StrEql(ARG, "snowball"))
		{
			if (pPlayerEntity.GetTeamNumber() != TEAM_SPECTATORS)
			{
				pPlayer.GiveWeapon("weapon_snowball");
			}
		}
	}
	return HOOK_RESULT;	
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//End
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
