void SetAntidoteState(const int &in iIndex, const int &in iAStage)
{
	bool bTest = false;
	CBaseEntity@ pEntity;
	
	while ((@pEntity = FindEntityByClassname(pEntity, "item_deliver")) !is null)
	{
		if (Utils.StringToInt(pEntity.GetEntityName()) == iIndex && Utils.StrContains("iantidote", pEntity.GetEntityName()))
		{
			bTest = true;
		}
	}

	if (bTest)
	{
		Engine.Ent_Fire(iIndex + "iantidote", "addoutput", "itemstate " + iAStage);
	}
}