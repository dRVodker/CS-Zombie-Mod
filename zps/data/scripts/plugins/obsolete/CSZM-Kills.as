#include "../SendGameText"

//some data
int iMaxPlayers;
bool bIsCSZM = false;
float flWaitTime;

int iHumanWin;
int iZombieWin;

array<int> g_iAntidote;
array<int> g_iKills;
array<int> g_iHits;
array<int> g_iVictims;
array<int> g_iSVictims;
array<int> g_iSKills;
array<float> g_flDamage;
array<float> g_flShowDamage;
array<float> g_flScoreDamage;
array<float> g_flSDTimer;

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Show Damage and Stats" );

	//Events
	Events::Player::OnPlayerConnected.Hook(@OnKPlayerConnected);
	Events::Player::OnPlayerDamaged.Hook(@OnKPlayerDamaged);
	Events::Player::OnPlayerKilled.Hook(@OnKPlayerKilled);
	Events::Rounds::RoundWin.Hook(@KRoundWin);
}

void OnMapInit()
{		
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
		iMaxPlayers = Globals.GetMaxClients();
		
		Entities::RegisterPickup("item_pills");
		
		g_iKills.resize(iMaxPlayers + 1);
		g_iHits.resize(iMaxPlayers + 1);
		g_iVictims.resize(iMaxPlayers + 1);
		g_iSVictims.resize(iMaxPlayers + 1);
		g_iSKills.resize(iMaxPlayers + 1);
		g_flDamage.resize(iMaxPlayers + 1);
		g_flShowDamage.resize(iMaxPlayers + 1);
		g_flScoreDamage.resize(iMaxPlayers + 1);
		g_flSDTimer.resize(iMaxPlayers + 1);
		g_iAntidote.resize(iMaxPlayers + 1);
		
		flWaitTime = Globals.GetCurrentTime() + 0.10f;
	}
}

void OnNewRound()
{
	if(bIsCSZM == true)
	{
		for(int i = 1; i <= iMaxPlayers; i++) 
		{
			g_iHits[i] = 0;
			g_iAntidote[i] = 0;
			g_iKills[i] = 0;
			g_iVictims[i] = 0;
			g_flDamage[i] = 0.0f;
			g_flShowDamage[i] = 0.0f;
			g_flScoreDamage[i] = 0.0f;
			g_flSDTimer[i] = 0.0f;
			
			flWaitTime = Globals.GetCurrentTime() + 0.10f;
		}
	}
}

void OnMatchEnded()
{
	if(bIsCSZM == true)
	{
		ShowStatsEnd();
	}
}

void OnMapShutdown()
{
	if(bIsCSZM == true)
	{
		bIsCSZM = false;
		
		iHumanWin = 0;
		iZombieWin = 0;
		
		flWaitTime = 0.0f;
		
		Entities::RemoveRegisterPickup("item_pills");
		
		ClearIntArray(g_iKills);
		ClearIntArray(g_iHits);
		ClearIntArray(g_iVictims);
		ClearIntArray(g_iSVictims);
		ClearIntArray(g_iSKills);
		ClearIntArray(g_iAntidote);
		ClearFloatArray(g_flDamage);
		ClearFloatArray(g_flShowDamage);
		ClearFloatArray(g_flScoreDamage);
		ClearFloatArray(g_flSDTimer);
	}
}

void OnProcessRound()
{
	if(bIsCSZM == true)
	{
		if(flWaitTime <= Globals.GetCurrentTime())
		{
			flWaitTime = Globals.GetCurrentTime() + 0.10f;
			
			for(int i = 1; i <= iMaxPlayers; i++)
			{
				CZP_Player@ pPlayer = ToZPPlayer(i);

				if(pPlayer is null) continue;

				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

				if(g_flSDTimer[i] > 0)
				{
					g_flSDTimer[i] -= 0.1f;
				}
				
				if(g_flSDTimer[i] <= 0 && g_flShowDamage[i] > 0)
				{
					g_flShowDamage[i] = 0;
				}
			}
		}
	}
}

void ClearIntArray(array<int> &iTarget)
{
    while (iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

void ClearFloatArray(array<float> &iTarget)
{
    while (iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

HookReturnCode KRoundWin(const string &in strMapname, RoundWinState iWinState)
{
	if(bIsCSZM == true)
	{
		if(iWinState == STATE_HUMAN) iHumanWin++;
		if(iWinState == STATE_ZOMBIE) iZombieWin++;
		
		string strHW = "\n  Humans Win - " + iHumanWin;
		string strZW = "\n  Zombies Win - " + iZombieWin;
		
		SendGameText(any, "-=Win Counter=-" + strHW + strZW, 4, 0.00f, 0, 0.50f, 0.25f, 0.00f, 10.10f, Color(235, 235, 235), Color(255, 95, 5));
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnKPlayerConnected(CZP_Player@ pPlayer)
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		g_iAntidote[pBaseEnt.entindex()] = 0;
		g_iKills[pBaseEnt.entindex()] = 0;
		g_iHits[pBaseEnt.entindex()] = 0;
		g_iVictims[pBaseEnt.entindex()] = 0;
		g_iSVictims[pBaseEnt.entindex()] = 0;
		g_iSKills[pBaseEnt.entindex()] = 0;
		g_flDamage[pBaseEnt.entindex()] = 0.0f;
		g_flShowDamage[pBaseEnt.entindex()] = 0.0f;
		g_flScoreDamage[pBaseEnt.entindex()] = 0.0f;
		g_flSDTimer[pBaseEnt.entindex()] = 0.0f;
		
		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnKPlayerDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	if(bIsCSZM == true)
	{
		CZP_Player@ pPlrAttacker = null;
		CBasePlayer@ pBPlrAttacker = null;
	
		const int iDamageType = DamageInfo.GetDamageType();
	
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		const int iVicIndex = pBaseEnt.entindex();
		const int iVicTeam = pBaseEnt.GetTeamNumber();
		
		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
		
		const int iAttIndex = pEntityAttacker.entindex();
		const bool bIsAttPlayer = pEntityAttacker.IsPlayer();
		
		if(bIsAttPlayer == true)
		{
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			@pBPlrAttacker = ToBasePlayer(iAttIndex);
		}
		else
		{
			return HOOK_HANDLED;
		}

		
		if(iAttIndex == iVicIndex) return HOOK_HANDLED;
		
		if(pEntityAttacker.GetTeamNumber() == 3 && iDamageType == 8196)
		{
			if(pBaseEnt.GetTeamNumber() == 0 || pBaseEnt.GetTeamNumber() == 1) return HOOK_HANDLED;
			
			if(g_iAntidote[iVicIndex] > 2) g_iAntidote[iVicIndex] = 2;
			
			if(g_iAntidote[iVicIndex] > 0)
			{
				g_iAntidote[iVicIndex]--;
				return HOOK_HANDLED;
			}
			else
			{
				g_iVictims[iAttIndex]++;
				g_iSVictims[iAttIndex]++;
				ShowKills(pPlrAttacker, g_iVictims[iAttIndex], true);
				KillFeed(pPlrAttacker.GetPlayerName(), pEntityAttacker.GetTeamNumber(), pPlayer.GetPlayerName(), iVicTeam, true, false);
			}
			
			return HOOK_HANDLED;
		}
		
		if(pEntityAttacker.GetTeamNumber() == 2)
		{
			g_flSDTimer[iAttIndex] = 0.8f;
			g_iHits[iAttIndex]++;
			
			float flHPD = 0;
			float flHP = pBaseEnt.GetHealth();
			float flDMG = floor(DamageInfo.GetDamage());
			
			if(g_flScoreDamage[iAttIndex] < 0) g_flScoreDamage[iAttIndex] == 0;
			
			if(flHP < flDMG)
			{
				flHPD = flHP - flDMG;
				flHPD = flDMG + flHPD;
				
				g_flDamage[iAttIndex] += flHPD;
				g_flShowDamage[iAttIndex] += flHPD;
				g_flScoreDamage[iAttIndex] += flHPD;
			}
			
			else if(DamageInfo.GetDamage() >= pBaseEnt.GetMaxHealth() && pBaseEnt.GetHealth() <= pBaseEnt.GetMaxHealth())
			{
				g_flDamage[iAttIndex] += pBaseEnt.GetMaxHealth();
				g_flShowDamage[iAttIndex] += pBaseEnt.GetMaxHealth();
				g_flScoreDamage[iAttIndex] += pBaseEnt.GetMaxHealth();
			}
			
			else
			{
				g_flDamage[iAttIndex] += floor(DamageInfo.GetDamage());
				g_flShowDamage[iAttIndex] += floor(DamageInfo.GetDamage());
				g_flScoreDamage[iAttIndex] += floor(DamageInfo.GetDamage());
			}
			
			Score(iAttIndex);
			if(g_flShowDamage[iAttIndex] > 0) Chat.CenterMessagePlayer(pBPlrAttacker, "- "+g_flShowDamage[iAttIndex]+" HP");

			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}

void Score(const int &in iPlrIndex)
{
	CZP_Player@ pPlayer = ToZPPlayer(iPlrIndex);
	float flSCDmg = g_flScoreDamage[iPlrIndex];
	float flTimes = 0;
	
	if(g_flScoreDamage[iPlrIndex] >= 100 && g_flScoreDamage[iPlrIndex] < 200)
	{
		pPlayer.AddScore(1, null);
		g_flScoreDamage[iPlrIndex] -= 100.0f;
	}
	else if(g_flScoreDamage[iPlrIndex] > 80)
	{
		flTimes = floor(flSCDmg / 100.0f);
		pPlayer.AddScore(int(flTimes), null);
		g_flScoreDamage[iPlrIndex] -= (100.0f * flTimes);
	}
}

HookReturnCode OnKPlayerKilled(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	if(bIsCSZM == true)
	{
		CZP_Player@ pPlrAttacker = null;
		CBasePlayer@ pBPlrAttacker = null;
	
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		const int iVicIndex = pBaseEnt.entindex();
		const int iVicTeam = pBaseEnt.GetTeamNumber();

		const string strVicName = pPlayer.GetPlayerName();
		
		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
		
		const int iAttIndex = pEntityAttacker.entindex();
		const int iAttTeam = pEntityAttacker.GetTeamNumber();
		const bool bIsAttPlayer = pEntityAttacker.IsPlayer();
		
		if(bIsAttPlayer == true)
		{
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			@pBPlrAttacker = ToBasePlayer(iAttIndex);
		}
		else
		{
			KillFeed("", 0, strVicName, iVicTeam, false, true);
			return HOOK_HANDLED;
		}
		
		const string strAttName = pPlrAttacker.GetPlayerName();

		if(iAttIndex == iVicIndex || pEntityAttacker.IsPlayer() == false)
		{
			KillFeed("", 0, strVicName, iVicTeam, false, true);
			return HOOK_HANDLED;
		}
		if(iAttTeam == 2)
		{
			g_iKills[iAttIndex]++;
			g_iSKills[iAttIndex]++;
			ShowKills(pPlrAttacker, g_iKills[iAttIndex], false);
			KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, false, false);
			
			return HOOK_HANDLED;
		}
		if(iAttTeam == 3)
		{
			g_iVictims[iAttIndex]++;
			g_iSVictims[iAttIndex]++;
			ShowKills(pPlrAttacker, g_iVictims[iAttIndex], true);
			KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, false, false);
			
			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}

void ShowKills(CZP_Player@ pPlayer, const int &in iKills,const bool &in bIsVictim)
{
	string strMsgToShow = "";
	int iR = 235;
	int iG = 16;
	int iB = 32;
	
	if(bIsVictim == false)
	{
		if(iKills == 1) strMsgToShow = "Kill: ";
		else strMsgToShow = "Kills: ";
	}
	else
	{
		iG = 235;
		iR = 16;
		iB = 32;
		if(iKills == 1) strMsgToShow = "Victim: ";
		else strMsgToShow = "Victims: ";
	}
	
	SendGameTextPlayer(pPlayer, strMsgToShow + iKills, 5, 0.00f, -1, 0.65f, 0.00f, 0.125f, 2.00f, Color(iR, iG, iB), Color(255, 95, 5));
}

void KillFeed(const string &in strAttName, const int &in iAttTeam, const string &in strVicName, const int &in iVicTeam, const bool &in bIsInfect, const bool &in bIsSuicide)
{
	string VicColor = "white";
	string AttColor = "white";
	
	switch(iAttTeam)
	{
		case 1:
			AttColor = "green";
		break;

		case 2:
			AttColor = "blue";
		break;

		case 3:
			AttColor = "red";
		break;
	}

	switch(iVicTeam)
	{
		case 1:
			VicColor = "green";
		break;

		case 2:
			VicColor = "blue";
		break;

		case 3:
			VicColor = "red";
		break;
	}

	if(bIsSuicide == false)
	{
		string strKill = "killed";
		if(bIsInfect == true)
		{
			strKill = "infected";
			VicColor = "blue";
		}
		Chat.PrintToChat(all, "{"+VicColor+"}" + strVicName + " {default}" + strKill + " by {"+AttColor+"}" + strAttName +"{default}.");
	}
	
	else Chat.PrintToChat(all, "{"+VicColor+"}" + strVicName + "{default} committed suicide.");
}

void ShowStatsEnd()
{
	string strStatsHead = "Your stats of the round:\n";
	string strSStatsHead = "Your stats of the session:\n";
	string strStats = "";
	string strSStats = "";
	
	for(int i = 1; i <= iMaxPlayers; i++) 
	{
		CZP_Player@ pPlr = ToZPPlayer(i);

		if(pPlr is null) continue;
		
		CBasePlayer@ pPlrEnt = pPlr.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
		strStats = strStatsHead + "  Kills: " + g_iKills[pBaseEnt.entindex()] + "\n  Hits: " + g_iHits[pBaseEnt.entindex()] + "\n  Damage: " + g_flDamage[pBaseEnt.entindex()] + "\n  Victims: " + g_iVictims[pBaseEnt.entindex()];
		
		strSStats = strSStatsHead + "  Kills: " + g_iSKills[pBaseEnt.entindex()] + "\n  Victims: " + g_iSVictims[pBaseEnt.entindex()];
		
		SendGameTextPlayer(pPlr, strStats, 2, 0.00f, 0, 0.25f, 0.25f, 0.00f, 10.10f, Color(205, 205, 220), Color(255, 95, 5));
		
		SendGameTextPlayer(pPlr, strSStats, 3, 0.00f, 0, 0.40f, 0.25f, 0.00f, 10.10f, Color(220, 205, 205), Color(255, 95, 5));
	}
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if(pEntity.GetClassname() == "item_pills" && pBaseEnt.GetTeamNumber() == 2 && g_iAntidote[pBaseEnt.entindex()] < 2) g_iAntidote[pBaseEnt.entindex()]++;
}