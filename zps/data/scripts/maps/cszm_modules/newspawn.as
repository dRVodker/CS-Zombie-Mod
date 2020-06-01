int NS_PSCIndex = 0;

class CSpawnPoint
{
	Vector Origin;
	QAngle Angles;
	string ClassName;

	CSpawnPoint(Vector nOrigin, QAngle nAngles)
	{
		Origin = nOrigin;
		Angles = nAngles;
		ClassName = "info_player_human";
	}

	CSpawnPoint(Vector nOrigin)
	{
		Origin = nOrigin;
		Angles = QAngle(Math::RandomFloat(-10, 25), Math::RandomFloat(-180, 180), 0);
		ClassName = "info_player_human";
	}

	CSpawnPoint(Vector nOrigin, QAngle nAngles, string nClass)
	{
		Origin = nOrigin;
		Angles = nAngles;
		ClassName = nClass;
	}

	CSpawnPoint(Vector nOrigin, string nClass)
	{
		Origin = nOrigin;
		Angles = QAngle(Math::RandomFloat(-10, 25), Math::RandomFloat(-180, 180), 0);
		ClassName = nClass;
	}
}

void CreateSpawnsFromArray(array<array<CSpawnPoint@>> SpawnsArray)
{
	int iRandom = Math::RandomInt(0, SpawnsArray.length() - 1);

	while (iRandom == NS_PSCIndex && SpawnsArray.length() > 1)
	{
		iRandom = Math::RandomInt(0, SpawnsArray.length() - 1);
	}

	NS_PSCIndex = iRandom;

	int ArrayLength = int(SpawnsArray[iRandom].length());

	for (int i = 0; i < ArrayLength; i++)
	{
		CSpawnPoint@ pSpawn = SpawnsArray[iRandom][i];

		if (pSpawn !is null)
		{

			CEntityData@ ID = EntityCreator::EntityData();
			ID.Add("targetname", "new_spawn");
			ID.Add("minspawns", "1");
			ID.Add("pvsmode", "0");
			ID.Add("mintime", "5");
			ID.Add("startdisabled", "0");

			EntityCreator::Create(pSpawn.ClassName, pSpawn.Origin, pSpawn.Angles, ID);			
		}
	}
}

void RemoveNativeSpawns(const string &in ClassName)
{
	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByClassname(pEntity, ClassName)) !is null)
	{
		pEntity.SUB_Remove();
	}
}