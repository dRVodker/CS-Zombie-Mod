int iPreviousIndex = 0;

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
		while(iRandomIndex == iPreviousIndex)
		{
			iRandomIndex = Math::RandomInt(0, TSLength - 1);
		}
		iPreviousIndex = iRandomIndex;
	}

	CASCommand@ pSplitedOrigin = null;
	CASCommand@ pSplited = StringToArgSplit(TerroristsSpawn[iRandomIndex], "|");
	int Args = pSplited.Args();
	float Angle_Yaw = YawAngle(pSplited.Arg(0));

	for (int i = 1; i < Args; i++)
	{
		int Shift = 0;
		@pSplitedOrigin = StringToArgSplit(pSplited.Arg(i), " ");
		
		if (pSplitedOrigin.Args() == 4)
		{
			Angle_Yaw = YawAngle(pSplitedOrigin.Arg(0));
			Shift = 1;
		}
		else if (pSplitedOrigin.Args() != 3)
		{
			Chat.PrintToChat(all, "{red}-=Warning=-\n*{gold}Terrorist spawn has wrong origin coordinates!\n{violet}Index: {cyan} " + i);
		}

		CreateSpawnEntity(Vector(Utils.StringToFloat(pSplitedOrigin.Arg(0 + Shift)), Utils.StringToFloat(pSplitedOrigin.Arg(1 + Shift)), Utils.StringToFloat(pSplitedOrigin.Arg(2 + Shift))), QAngle(0, Angle_Yaw, 0));
	}

	return iRandomIndex;
}

void CreateSpawnEntity(Vector Origin, QAngle Angles)
{
	CEntityData@ ImputData = EntityCreator::EntityData();
	ImputData.Add("targetname", "terrorists_spawn");
	ImputData.Add("startdisabled", "0");
	ImputData.Add("minspawns", "0");
	ImputData.Add("pvsmode", "0");
	ImputData.Add("mintime", "1");

	EntityCreator::Create("info_player_zombie", Origin, Angles, ImputData);
}

float YawAngle(const string &in strValue)
{
	float Yaw = Utils.StringToFloat(strValue);

	if (strValue == "r")
	{
		Yaw = Math::RandomFloat(0, 360);
	}

	return Yaw;
}