void ModelChange()
{
	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByClassname(pEntity, "item_pills")) !is null)
	{
		pEntity.SetModel("models/healthvial.mdl");
	}
}