void ModelChange()
{
	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByClassname(pEntity, "item_pills")) !is null)
	{
		pEntity.SetModel("models/healthvial.mdl");
	}
}

void RemoveExtraPills()
{
	int iPillsCount = 0;

	array<CBaseEntity@> g_pPills = {null};

	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByClassname(pEntity, "item_pills")) !is null)
	{
		iPillsCount++;
		g_pPills.insertLast(pEntity);
	}

	if(iPillsCount >= 4)
	{
		int iIterations = iPillsCount - Math::RandomInt(2,4);

		if(iIterations > 0)
		{
			for(int i = 1; i <= iIterations; i++ )
			{
				int iRNG = Math::RandomInt(1, g_pPills.length() - 1);

				if(g_pPills[iRNG].entindex() != 0)
				{
					g_pPills[iRNG].SUB_Remove();
					g_pPills.removeAt(iRNG);
				}

				else iIterations--;
			}
		}
	}
}