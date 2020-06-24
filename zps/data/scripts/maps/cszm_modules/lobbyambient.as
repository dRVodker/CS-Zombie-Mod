void PlayLobbyAmbient()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByName(pEntity, "lobby_ambient_generic")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "Volume", "" + formatInt(pEntity.GetHealth()));
	}
}