bool bDebugCrates = false;
int iMaxCrates = 1;
int iMinCrates = 3;
float flDistBetweenCrates = 32.0f;

array<Vector> g_PICOrigin;
array<QAngle> g_PICAngles;

void SpawnCrates()
{
	if (bDebugCrates)
	{
		Chat.PrintToChat(all, "{cyan}-=info=-\n{gold}*Spawning crates.");		
	}

	uint iOriginLength = g_PICOrigin.length();
	array<Vector> p_OriginSpawned;
	array<Vector> p_Origin;
	array<QAngle> p_Angles;

	for (uint q = 0; q < iOriginLength; q++)
	{
		p_Origin.insertLast(g_PICOrigin[q]);
		p_Angles.insertLast(g_PICAngles[q]);
	}

	uint iCrateCount = Math::RandomInt(iMinCrates, iMaxCrates);
	uint iMaxIterations = iCrateCount * 2;

	while (iCrateCount != 0)
	{
		iMaxIterations--;

		int RNG_Position = Math::RandomInt(0, p_Origin.length() - 1);
		int RND_ItemCount = Math::RandomInt(1, 5);

		if (CheckDist(p_OriginSpawned, p_Origin[RNG_Position]))
		{
			iCrateCount--;
			CEntityData@ InputData = EntityCreator::EntityData();
			InputData.Add("itemclass", "item_ammo_flare");
			InputData.Add("itemcount", "" + RND_ItemCount);

			EntityCreator::Create("prop_itemcrate", p_Origin[RNG_Position], p_Angles[RNG_Position], InputData);
			p_OriginSpawned.insertLast(p_Origin[RNG_Position]);
		}

		p_Origin.removeAt(RNG_Position);
		p_Angles.removeAt(RNG_Position);

		if (iMaxIterations <= 0)
		{
			if (bDebugCrates)
			{
				Chat.PrintToChat(all, "{cyan}-=info=-\n{red}*Iterations limit has been hit!");					
			}
			break;
		}
	}
}

bool CheckDist(array<Vector> TargetArray, Vector Subject)
{
	bool Spawn = true;
	uint TargetLength = TargetArray.length();

	if (flDistBetweenCrates > 32.0f && TargetLength > 0)
	{
		for (uint u = 0; u < TargetLength; u++)
		{
			if (Globals.Distance(Subject, TargetArray[u]) < flDistBetweenCrates)
			{
				Spawn = false;
				if (bDebugCrates)
				{
					Chat.PrintToChat(all, "{cyan}-=info=-\n{gold}*Crate spawn points too close to each other - SKIPPING");						
				}
				break;
			}
		}		
	}

	return Spawn;
}