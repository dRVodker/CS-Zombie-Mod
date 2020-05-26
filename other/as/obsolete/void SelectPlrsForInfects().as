void SelectPlrsForInfects()
{
	float flIP = flInfectionPercent;

	if (flIP > 0.75f)
	{
		flIP = 0.75f;
	}

	int iShortage = 0;
	int iSurvCount = Utils.GetNumPlayers(survivor, true);
	int iInfectedCount = int(ceil(flIP * float(iSurvCount)));

	if (iInfectedCount < 1)
	{
		iInfectedCount = 1;
	}

	array<int> p_Survivors;
	array<int> p_Infected;
	array<int> p_WereInfected;

	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];

		if (pPlayer is null)
		{
			continue;
		}

		if (pPlayerEntity.GetTeamNumber() != TEAM_SURVIVORS || !pPlayerEntity.IsAlive())
		{
			continue;
		}

		if (!pCSZMPlayer.IsFirstInfectedInSession())
		{
			p_Survivors.insertLast(i);
		}
		else
		{
			p_WereInfected.insertLast(i);
		}
	}

	int iSurvLength = int(p_Survivors.length());

	if (iSurvLength < iInfectedCount)
	{
		iShortage = iInfectedCount - iSurvLength;
		iInfectedCount -= iShortage;
	}

	if (iShortage > 0)
	{
		for (int e = 1; e <= iShortage; e++)
		{
			int iRandom1 = Math::RandomInt(0, p_WereInfected.length() - 1);
			p_Infected.insertLast(p_WereInfected[iRandom1]);
			p_WereInfected.removeAt(iRandom1);	
		}
	}

	for (int q = 1; q <= iInfectedCount; q++)
	{
		int iRandom2 = Math::RandomInt(0, p_Survivors.length() - 1);
		p_Infected.insertLast(p_Survivors[iRandom2]);
		p_Survivors.removeAt(iRandom2);
	}
	
	int iInfectedLength = int(p_Infected.length());

	for (int w = 0; w < iInfectedLength; w++)
	{
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[p_Infected[w]];
		pCSZMPlayer.SetFirstInfected(true);
		pCSZMPlayer.SetFirstInfectedInSession(true);
		TurnToZombie(p_Infected[w]);		
	}

	Engine.EmitSound("CS_FirstTurn");
	SD("{blue}[{coral}cszm{blue}]{gold} Произошло заражение ({red}" + iInfectedLength + " {gold}из {blue}" + iSurvCount + "{gold})");
}