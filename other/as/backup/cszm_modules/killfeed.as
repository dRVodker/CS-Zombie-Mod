array<int> g_iKills;
array<int> g_iVictims;

void ShowTextPlr(CZP_Player@ pPlayer, const string &in strMessage, int iChannel, float flxTime, float flxPos, float flyPos, float flFadeIn, float flFadeOut, float flHoldTime, Color clrPrimary, Color clrSecondary)
{
	HudTextParams pParams;
	pParams.x = flxPos;
	pParams.y = flyPos;
	pParams.channel = iChannel;
	pParams.fadeinTime = flFadeIn;
	pParams.fadeoutTime = flFadeOut;
	pParams.holdTime = flHoldTime;
	pParams.fxTime = flxTime;
	pParams.SetColor(clrPrimary);
	pParams.SetColor2(clrSecondary);
	Utils.GameTextPlayer(pPlayer, strMessage, pParams);
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

	if(!bIsSuicide)
	{
		string strKill = "killed";
		
		if(bIsInfect)
		{
			strKill = "infected";
			VicColor = "blue";
		}

		Chat.PrintToChat(all, "{"+VicColor+"}" + strVicName + " {default}" + strKill + " by {"+AttColor+"}" + strAttName +"{default}.");
	}
	else
	{
		Chat.PrintToChat(all, "{"+VicColor+"}" + strVicName + "{default} committed suicide.");
	}
}

void ShowKills(CZP_Player@ pPlayer, const int &in iKills, const bool &in bIsVictim)
{
	string strMsgToShow = "";
	int iR = 235;
	int iG = 16;
	int iB = 32;
	
	if(!bIsVictim)
	{
		if(iKills == 1)
		{
			strMsgToShow = "Kill: ";
		}
		else
		{
			strMsgToShow = "Kills: ";
		}
	}
	
	else
	{
		iG = 235;
		iR = 16;
		iB = 32;
		
		if(iKills == 1)
		{
			strMsgToShow = "Victim: ";
		}
		else 
		{
			strMsgToShow = "Victims: ";
		}
	}
	
	ShowTextPlr(pPlayer, strMsgToShow + iKills, 5, 0.00f, -1, 0.65f, 0.00f, 0.125f, 2.00f, Color(iR, iG, iB), Color(255, 95, 5));
}

void ShowStatsEnd(CZP_Player@ pPlayer, const int &in iKills, const int &in iVictims)
{
	string strStatsHead = "Your stats of the round:\n";
	string strStats = "";
	strStats = strStatsHead + " Kills: " + iKills + "\n Victims: " + iVictims;

	ShowTextPlr(pPlayer, strStats, 2, 0.00f, 0, 0.25f, 0.25f, 0.00f, 10.10f, Color(205, 205, 220), Color(255, 95, 5));
}