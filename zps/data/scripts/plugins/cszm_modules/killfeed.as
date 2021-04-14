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
	string strKill = (bIsInfect) ? TEXT_KF_Infected : TEXT_KF_Killed;
	string VicColor = "green";
	string AttColor = "green";
	
	switch(iAttTeam)
	{
		case 1: AttColor = "white"; break;
		case 2: AttColor = "blue"; break;
		case 3: AttColor = "red"; break;
	}

	switch(iVicTeam)
	{
		case 1: VicColor = "white"; break;
		case 2: VicColor = "blue"; break;
		case 3: VicColor = "red"; break;
	}

	!bIsSuicide ? Chat.PrintToChat(all, "{"+AttColor+"}" + strAttName + " {default}" + strKill + " {"+VicColor+"}" + strVicName + "{default}.") : Chat.PrintToChat(all, "{"+VicColor+"}" + strVicName + "{default} " + TEXT_KF_Suicide + ".");
}

void ShowKills(CZP_Player@ pPlayer, const int &in iKills, const bool &in bIsInfection)
{
	string strMsgToShow = (bIsInfection) ? "Victim" : "Kill";
	int iR = (bIsInfection) ? 16 : 235 ;
	int iG = (bIsInfection) ? 235 : 16 ;
	strMsgToShow += (iKills == 1) ? ": " : "s: ";
	 
	ShowTextPlr(pPlayer, strMsgToShow + formatInt(iKills), 5, 0.00f, -1, 0.65f, 0.00f, 0.125f, 2.00f, Color(iR, iG, 32), Color(255, 95, 5));
}