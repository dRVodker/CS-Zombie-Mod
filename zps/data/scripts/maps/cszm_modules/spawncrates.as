int iMaxCrates = 1;
int iMinCrates = 3;

array<Vector> g_PICOrigin;
array<QAngle> g_PICAngles;

void SpawnCrates()
{
	array<Vector> p_Origin;
	array<QAngle> p_Angles;

	for (uint q = 0; q < g_PICOrigin.length(); q++)
	{
		p_Origin.insertLast(g_PICOrigin[q]);
		p_Angles.insertLast(g_PICAngles[q]);
	}

	uint iCrateCount = Math::RandomInt(iMinCrates, iMaxCrates);

	while (iCrateCount != 0)
	{
		int RNG_Position = Math::RandomInt(0, p_Origin.length() - 1);

		int RND_ItemCount = Math::RandomInt(1, 5);

		iCrateCount--;
		CEntityData@ InputData = EntityCreator::EntityData();
		InputData.Add("itemclass", "item_ammo_flare");
		InputData.Add("itemcount", "" + RND_ItemCount);

		EntityCreator::Create("prop_itemcrate", p_Origin[RNG_Position], p_Angles[RNG_Position], InputData);

		p_Origin.removeAt(RNG_Position);
		p_Angles.removeAt(RNG_Position);
	}
}