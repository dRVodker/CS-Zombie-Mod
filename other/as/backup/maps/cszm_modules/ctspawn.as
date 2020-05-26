int iPreviousCTIndex = 0;

array<string> CounterTerroristsSpawn;

int CreateCounterTerroristsSpawn()
{
	int iRandomIndex = 0;
	int TSLength = int(CounterTerroristsSpawn.length());
	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_human")) !is null)
	{
		pEntity.SUB_Remove();
	}
	
	if (TSLength > 1)
	{
		while(iRandomIndex == iPreviousCTIndex)
		{
			iRandomIndex = Math::RandomInt(0, TSLength - 1);
		}
		iPreviousCTIndex = iRandomIndex;
	}

	CASCommand@ pSplitedOrigin = null;
	CASCommand@ pSplited = StringToArgSplit(CounterTerroristsSpawn[iRandomIndex], "|");
	int Args = pSplited.Args();
	float Angle_Yaw = CTS_YawAngle(pSplited.Arg(0));

	for (int i = 1; i < Args; i++)
	{
		int Shift = 0;
		@pSplitedOrigin = StringToArgSplit(pSplited.Arg(i), " ");
		
		if (pSplitedOrigin.Args() == 4)
		{
			Angle_Yaw = CTS_YawAngle(pSplitedOrigin.Arg(0));
			Shift = 1;
		}
		else if (pSplitedOrigin.Args() != 3)
		{
			Chat.PrintToChat(all, "{red}-=Warning=-\n*{blue}Counter-terrorist {gold}spawn has wrong origin coordinates!\n{violet}Index: {cyan} " + i);
		}

		CreateCTSpawnEntity(Vector(Utils.StringToFloat(pSplitedOrigin.Arg(0 + Shift)), Utils.StringToFloat(pSplitedOrigin.Arg(1 + Shift)), Utils.StringToFloat(pSplitedOrigin.Arg(2 + Shift))), QAngle(0, Angle_Yaw, 0));
	}

	return iRandomIndex;
}

void CreateCTSpawnEntity(Vector Origin, QAngle Angles)
{
	CEntityData@ ImputData = EntityCreator::EntityData();
	ImputData.Add("targetname", "counter-terrorists_spawn");
	ImputData.Add("startdisabled", "0");
	ImputData.Add("minspawns", "1");
	ImputData.Add("pvsmode", "0");
	ImputData.Add("mintime", "15");

	EntityCreator::Create("info_player_human", Origin, Angles, ImputData);
}

float CTS_YawAngle(const string &in strValue)
{
	float Yaw = Utils.StringToFloat(strValue);

	if (strValue == "r")
	{
		Yaw = Math::RandomFloat(0, 360);
	}

	return Yaw;
}