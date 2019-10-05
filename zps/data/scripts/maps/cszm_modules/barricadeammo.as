int iMaxBarricade = 3;
int iMinBarricade = 9;

array<Vector> g_IABOrigin;
array<QAngle> g_IABAngles;

bool IsBarricadesFound;

void FindBarricades()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_ammo_barricade")) !is null)
	{
		if (!IsBarricadesFound)
		{
			g_IABOrigin.insertLast(pEntity.GetAbsOrigin());
			g_IABAngles.insertLast(pEntity.GetAbsAngles());
		}
		pEntity.SUB_Remove();
	}

	if (!IsBarricadesFound)
	{
		IsBarricadesFound = true;
	}
}

void SpawnBarricades()
{
	array<Vector> p_Origin;
	array<QAngle> p_Angles;

	if (iMaxBarricade > int(g_IABOrigin.length()))
	{
		iMaxBarricade = int(g_IABOrigin.length());
	}

	for (uint q = 0; q < g_IABOrigin.length(); q++)
	{
		p_Origin.insertLast(g_IABOrigin[q]);
		p_Angles.insertLast(g_IABAngles[q]);
	}

	uint iBarricadeCount = Math::RandomInt(iMinBarricade, iMaxBarricade);

	while (iBarricadeCount != 0)
	{
		int RNG_Position = Math::RandomInt(0, p_Origin.length() - 1);

		iBarricadeCount--;
		CEntityData@ InputData = EntityCreator::EntityData();
		InputData.Add("DisableDamageForces", "1", true);

		EntityCreator::Create("item_ammo_barricade", p_Origin[RNG_Position], p_Angles[RNG_Position], InputData);

		p_Origin.removeAt(RNG_Position);
		p_Angles.removeAt(RNG_Position);
	}
}