int iMaxCash = 10;
int iMinCash = 3;

array<Vector> g_Origins;

void SpawnCashItem()
{
	uint iItemsCount = Math::RandomInt(iMinCash, iMaxCash);
	uint iLength = g_Origins.length();
	array<Vector> p_Oririgns;

	if (iItemsCount > iLength)
	{
		iItemsCount = iLength;
	}

	for (uint i = 0; i < iLength; i++)
	{
		p_Oririgns.insertLast(g_Origins[i]);
	}

	while (iItemsCount != 0)
	{
		int RND_ArrPos = Math::RandomInt(0, p_Oririgns.length() - 1);

		CEntityData@ InputData = EntityCreator::EntityData();

		InputData.Add("canfirehurt", "0");
		InputData.Add("minhealthdmg", "1000");
		InputData.Add("model", "models/zp_props/100dollar/100dollar.mdl");
		InputData.Add("nodamageforces", "1");
		InputData.Add("nofiresound", "1");
		InputData.Add("physdamagescale", "0");
		InputData.Add("spawnflags", "8582");
		InputData.Add("unbreakable", "1");
		InputData.Add("overridescript", "mass,1,");
		InputData.Add("DisableDamageForces", "0", true);

		CBaseEntity@ pMoneyItem = EntityCreator::Create("prop_physics_override", p_Oririgns[RND_ArrPos], QAngle(0, Math::RandomFloat(-180.0f, 180.0f), 0), InputData);
		pMoneyItem.SetClassname("item_money");
		pMoneyItem.SetHealth(int(floor(Math::RandomFloat(25.0f, 200.0f) / 5) * 5));
		pMoneyItem.SetOutline(true, filter_team, 2, Color(235, 65, 175), 185.0f, false, true);

		p_Oririgns.removeAt(RND_ArrPos);

		iItemsCount--;
	}
}