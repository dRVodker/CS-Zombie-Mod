int iPreviousTIndex = 0;
string strPVS_Value = "0";

array<string> TerroristsSpawn;

int CreateTerroristsSpawn()
{
	int iRandomIndex = 0;
	int TSLength = int(TerroristsSpawn.length());
	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_zombie")) !is null)
	{
		pEntity.SUB_Remove();
	}
	
	if (TSLength > 1)
	{
		while(iRandomIndex == iPreviousTIndex)
		{
			iRandomIndex = Math::RandomInt(0, TSLength - 1);
		}
		iPreviousTIndex = iRandomIndex;
	}

	CASCommand@ pSplitedOrigin = null;
	CASCommand@ pSplited = StringToArgSplit(TerroristsSpawn[iRandomIndex], "|");
	int Args = pSplited.Args();
	float Angle_Yaw = TS_YawAngle(pSplited.Arg(0));

	for (int i = 1; i < Args; i++)
	{
		int Shift = 0;
		@pSplitedOrigin = StringToArgSplit(pSplited.Arg(i), " ");
		
		if (pSplitedOrigin.Args() == 4)
		{
			Angle_Yaw = TS_YawAngle(pSplitedOrigin.Arg(0));
			Shift = 1;
		}
		else if (pSplitedOrigin.Args() != 3)
		{
			Chat.PrintToChat(all, "{red}-=Warning=-\n*{red}Terrorist {gold}spawn has wrong origin coordinates!\n{violet}Index: {cyan} " + i);
		}

		CreateTSpawnEntity(Vector(Utils.StringToFloat(pSplitedOrigin.Arg(0 + Shift)), Utils.StringToFloat(pSplitedOrigin.Arg(1 + Shift)), Utils.StringToFloat(pSplitedOrigin.Arg(2 + Shift))), QAngle(0, Angle_Yaw, 0));
	}

	return iRandomIndex;
}

void CreateTSpawnEntity(Vector Origin, QAngle Angles)
{
	CEntityData@ ImputData = EntityCreator::EntityData();
	ImputData.Add("targetname", "terrorists_spawn");
	ImputData.Add("startdisabled", "0");
	ImputData.Add("minspawns", "100");
	ImputData.Add("pvsmode", strPVS_Value);
	ImputData.Add("mintime", "0");

	EntityCreator::Create("info_player_zombie", Origin, Angles, ImputData);
}

float TS_YawAngle(const string &in strValue)
{
	float Yaw = Utils.StringToFloat(strValue);

	if (strValue == "r")
	{
		Yaw = Math::RandomFloat(0, 360);
		strPVS_Value = "1";
	}
	else
	{
		strPVS_Value = "0";
	}

	return Yaw;
}