
bool UnlimitedRandom = false;

void OverrideLimits()
{
	if (bIsCSZM)
	{
		RoundManager.Limit_Enable(true);
		RoundManager.Limit_Override(random_def, true);
		int iSurvCount = 0;

		if (UnlimitedRandom)
		{
			iSurvCount = -1;
		}	
		else
		{
			iSurvCount = Utils.GetNumPlayers(survivor, false);
		}

		SetLimits(iSurvCount);
	}
}

void SetLimits(const int &in iSurvCount)
{
	int iThingsListLength = int(g_ThingsList.length());

	for (int i = 0; i < iThingsListLength; i++)
	{
		CASCommand@ pSplited = StringToArgSplit(GetLimit(g_ThingsList[i], iSurvCount), ";");
		string strClassname = pSplited.Arg(0);
		int iLimit = Utils.StringToInt(pSplited.Arg(1));

		RoundManager.Limit_Random(strClassname, iLimit);	
	}
}

string GetLimit(string &in strItem, const int &in iSurvCount)
{
	CASCommand@ p_ASplited = null;
	CASCommand@ p_ISplited = StringToArgSplit(strItem, ";");
	string strResult = "";
	string strClassname = p_ISplited.Arg(0);
	int iArgs = p_ISplited.Args();
	int iLimit = 0;
	int iPlayers = 0;
	int iCount = 0;

	for (int i = 1; i < iArgs; i++)
	{
		@p_ASplited = StringToArgSplit(p_ISplited.Arg(i), "=");

		iPlayers = Utils.StringToInt(p_ASplited.Arg(0));
		iCount = Utils.StringToInt(p_ASplited.Arg(1));

		if (iSurvCount >= iPlayers)
		{
			iLimit = iCount;
			break;
		}
	}

	return strResult = strClassname + ";" + iLimit;
}