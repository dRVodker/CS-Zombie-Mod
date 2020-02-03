int iPreviousIndex = 0;

array<string> TerroristsSpawn;

void CreateTerroristsSpawn()
{
	int iRandomIndex = 0;

	while(iRandomIndex == iPreviousIndex)
	{
		iRandomIndex = Math::RandomInt(0, TerroristsSpawn.length() - 1);
	}
	
	iPreviousIndex = iRandomIndex;

	CBaseEntity@ pEntity;
	CASCommand@ pSplitedOrigin = null;
	CASCommand@ pSplited = StringToArgSplit(TerroristsSpawn[iRandomIndex], "|");
	int Args = pSplited.Args();

	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_zombie")) !is null)
	{
		pEntity.SUB_Remove();
	}

	for (int i = 1; i < Args; i++)
	{
		@pSplitedOrigin = StringToArgSplit(pSplited.Arg(i), " ");
		CreateSpawnEntity(Vector(Utils.StringToFloat(pSplitedOrigin.Arg(0)), Utils.StringToFloat(pSplitedOrigin.Arg(1)), Utils.StringToFloat(pSplitedOrigin.Arg(2))), QAngle(0, Utils.StringToFloat(pSplited.Arg(0)), 0));
	}
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