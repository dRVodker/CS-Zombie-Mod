//WarmUp Related Funcs
void WarmUpTimer()
{
	int iNumPlrs = 0;
	iNumPlrs += CountPlrs(TEAM_LOBBYGUYS);

	if (bWarmUp && iNumPlrs >= 2)
	{
		flWUWait = Globals.GetCurrentTime() + 1.0f;

		string TimerText = "\n\n\n"+strWarmUp+"\n| "+iWUSeconds+" |";
		SendGameText(any, TimerText, 1, 0, -1, 0, 0, 0, 1.10f, Color(255, 175, 85), Color(255, 95, 5));

		if (iWUSeconds == 0)
		{
			WarmUpEnd();
		}
		if (iWUSeconds > 0)
		{
			iWUSeconds--;
		}
	}
	else if (iNumPlrs <= 1)
	{
		flWUWait = 0;
		iWUSeconds = CONST_WARMUP_TIME;
		SendGameText(any, strAMP, 1, 0, -1, 0, 0, 0, 600, Color(255, 255, 255), Color(255, 95, 5));
	}
}

void WarmUpEnd()
{
	if (bWarmUp)
	{
		bWarmUp = false;
	}
	
	flWUWait = 0;
	Engine.EmitSound("@buttons/button3.wav");
	string TimerText = "\n\n\n"+strWarmUp+"\n| 0 |";
	SendGameText(any, TimerText, 1, 0, -1, 0, 0, 0.35f, 0.05f, Color(255, 175, 85), Color(255, 95, 5));
	SendGameText(any, "", 3, 0, 0, 0, 0, 0, 0, Color(0, 0, 0), Color(0, 0, 0));
	SendGameText(any, strHintF1, 3, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(64, 128, 255), Color(255, 95, 5));

	if (!RoundManager.IsRoundOngoing(false))
	{
		SendGameText(any, "\n" + strHintF2Inf, 4, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(255, 32, 64), Color(255, 95, 5));
	}
	else
	{
		SendGameText(any, "\n" + strHintF2, 4, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(255, 32, 64), Color(255, 95, 5));
	}

	SendGameText(any, "\n\n" + strHintF3, 5, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(255, 255, 255), Color(255, 95, 5));
}