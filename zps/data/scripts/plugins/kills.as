#include "../SendGameText"

//some data
int iMaxPlayers;
bool bIsCSZM = false;
float flWaitTime;

int iHumanWin;
int iZombieWin;

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
		
		g_iKills.resize(iMaxPlayers + 1);
		g_iHits.resize(iMaxPlayers + 1);
		g_iVictims.resize(iMaxPlayers + 1);
		g_iSVictims.resize(iMaxPlayers + 1);
		g_iSKills.resize(iMaxPlayers + 1);
		g_flDamage.resize(iMaxPlayers + 1);
		g_flShowDamage.resize(iMaxPlayers + 1);
		g_flScoreDamage.resize(iMaxPlayers + 1);
		g_flSDTimer.resize(iMaxPlayers + 1);
		
		flWaitTime = Globals.GetCurrentTime() + 0.10f;
	}
}

void OnNewRound()
{
	if(bIsCSZM = true)
	{
		for(int i = 1; i <= iMaxPlayers; i++) 
		{
			g_iHits[i] = 0;
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
	if(bIsCSZM = true)
	{
		ShowStatsEnd();
	}
}

void OnMapShutdown()
{
	bIsCSZM = false;
	
	iHumanWin = 0;
	iZombieWin = 0;
	
	flWaitTime = 0.0f;
	
	ClearIntArray(g_iKills);
	ClearIntArray(g_iHits);
	ClearIntArray(g_iVictims);
	ClearIntArray(g_iSVictims);
	ClearIntArray(g_iSKills);
	ClearFloatArray(g_flDamage);
	ClearFloatArray(g_flShowDamage);
	ClearFloatArray(g_flScoreDamage);
	ClearFloatArray(g_flSDTimer);
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
		if(iWinState == STATE_HUMAN)
		{
			iHumanWin++;
		}
		if(iWinState == STATE_ZOMBIE)
		{
			iZombieWin++;
		}
		
		string strHW = "\n  Humans Win - " + iHumanWin;
		string strZW = "\n  Zombies Win - " + iZombieWin;
		
		SendGameText(any, "-=Win Counter=-" + strHW + strZW, 4, 0.00f, 0, 0.50f, 0.25f, 0.00f, 10.10f, Color(235, 235, 235), Color(255, 95, 5));
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnKPlayerConnected(CZP_Player@ pPlayer)
{
	if(bIsCSZM = true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
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
	if(bIsCSZM = true)
	{
//		SD("Damage Type: "+DamageInfo.GetDamageType());
//		SD("Damage: "+DamageInfo.GetDamage());

		const int iDamageType = DamageInfo.GetDamageType();
	
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		CZP_Player@ pPlrAttacker = ToZPPlayer(DamageInfo.GetAttacker());
		
		CBasePlayer@ pAttEnt = pPlrAttacker.opCast();
		CBaseEntity@ pBasaAtt = pAttEnt.opCast();
		
		if(pBasaAtt.entindex() == pBaseEnt.entindex()) return HOOK_HANDLED;
		
		if(pBasaAtt.GetTeamNumber() == 3 && iDamageType == 8196)
		{
			g_iVictims[pBasaAtt.entindex()]++;
			g_iSVictims[pBasaAtt.entindex()]++;
			ShowKills(pPlrAttacker, g_iVictims[pBasaAtt.entindex()], true);
			KillFeed(pPlrAttacker.GetPlayerName(), pBasaAtt.GetTeamNumber(), pPlayer.GetPlayerName(), pBaseEnt.GetTeamNumber(), true, false);
			
			return HOOK_HANDLED;
		}
		
		if(pBasaAtt.GetTeamNumber() == 2)
		{
			g_flSDTimer[pBasaAtt.entindex()] = 0.8f;
			g_iHits[pBasaAtt.entindex()]++;
			
			float flHPD = 0;
			float flHP = pBaseEnt.GetHealth();
			float flDMG = floor(DamageInfo.GetDamage());
			
			if(g_flScoreDamage[pBasaAtt.entindex()] < 0) g_flScoreDamage[pBasaAtt.entindex()] == 0;
			
			if(flHP < flDMG)
			{
				flHPD = flHP - flDMG;
				flHPD = flDMG + flHPD;
				
				g_flDamage[pBasaAtt.entindex()] += flHPD;
				g_flShowDamage[pBasaAtt.entindex()] += flHPD;
				g_flScoreDamage[pBasaAtt.entindex()] += flHPD;
			}
			
			else if(DamageInfo.GetDamage() >= pBaseEnt.GetMaxHealth() && pBaseEnt.GetHealth() <= pBaseEnt.GetMaxHealth())
			{
				g_flDamage[pBasaAtt.entindex()] += pBaseEnt.GetMaxHealth();
				g_flShowDamage[pBasaAtt.entindex()] += pBaseEnt.GetMaxHealth();
				g_flScoreDamage[pBasaAtt.entindex()] += pBaseEnt.GetMaxHealth();
			}
			
			else
			{
				g_flDamage[pBasaAtt.entindex()] += floor(DamageInfo.GetDamage());
				g_flShowDamage[pBasaAtt.entindex()] += floor(DamageInfo.GetDamage());
				g_flScoreDamage[pBasaAtt.entindex()] += floor(DamageInfo.GetDamage());
			}
			
			Score(pBasaAtt.entindex());
			if(g_flShowDamage[pBasaAtt.entindex()] > 0) Chat.CenterMessagePlayer(pAttEnt, "- "+g_flShowDamage[pBasaAtt.entindex()]+" HP");

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
	
	if(g_flScoreDamage[iPlrIndex] >= 80 && g_flScoreDamage[iPlrIndex] < 160)
	{
		pPlayer.AddScore(1);
		g_flScoreDamage[iPlrIndex] -= 80.00f;
	}
	else if(g_flScoreDamage[iPlrIndex] > 80)
	{
		flTimes = floor(flSCDmg / 80.00f);
		pPlayer.AddScore(int(flTimes));
		g_flScoreDamage[iPlrIndex] -= (80.00f * flTimes);
	}
}

HookReturnCode OnKPlayerKilled(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	if(bIsCSZM = true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		CZP_Player@ pPlrAttacker = ToZPPlayer(DamageInfo.GetAttacker());
		
		CBasePlayer@ pAttEnt = pPlrAttacker.opCast();
		CBaseEntity@ pBasaAtt = pAttEnt.opCast();
		
		if(pBasaAtt.entindex() == pBaseEnt.entindex())
		{
			KillFeed("", 0, pPlayer.GetPlayerName(), pBaseEnt.GetTeamNumber(), false, true);
			return HOOK_HANDLED;
		}
		
		if(pBasaAtt.GetTeamNumber() == 2)
		{
			g_iKills[pBasaAtt.entindex()]++;
			g_iSKills[pBasaAtt.entindex()]++;
			ShowKills(pPlrAttacker, g_iKills[pBasaAtt.entindex()], false);
			KillFeed(pPlrAttacker.GetPlayerName(), pBasaAtt.GetTeamNumber(), pPlayer.GetPlayerName(), pBaseEnt.GetTeamNumber(), false, false);
			
			return HOOK_HANDLED;
		}
		
		if(pBasaAtt.GetTeamNumber() == 3)
		{
			g_iVictims[pBasaAtt.entindex()]++;
			g_iSVictims[pBasaAtt.entindex()]++;
			ShowKills(pPlrAttacker, g_iVictims[pBasaAtt.entindex()], true);
			KillFeed(pPlrAttacker.GetPlayerName(), pBasaAtt.GetTeamNumber(), pPlayer.GetPlayerName(), pBaseEnt.GetTeamNumber(), false, false);
			
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
	string VicColoe = "white";
	string AttColoe = "white";
	switch(iAttTeam)
	{
		case 2:
			AttColoe = "blue";
		break;
		
		case 3:
			AttColoe = "red";
		break;
		
		default:
			AttColoe = "grey";
		break;
	}
	
	switch(iVicTeam)
	{
		case 2:
			VicColoe = "blue";
		break;
		
		case 3:
			VicColoe = "red";
		break;
		
		default:
			VicColoe = "grey";
		break;
	}
	
	if(bIsSuicide == false)
	{
		string strKill = "killed";
		if(bIsInfect == true) strKill = "infected";
		Chat.PrintToChat(all, "{"+VicColoe+"}" + strVicName + " {default}" + strKill + " by {"+AttColoe+"}" + strAttName +"{default}.");
	}
	
	else Chat.PrintToChat(all, "{"+VicColoe+"}" + strVicName + "{default} committed suicide.");
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