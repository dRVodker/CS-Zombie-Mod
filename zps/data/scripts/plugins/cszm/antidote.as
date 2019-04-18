array<int> g_iAntidote;

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	if(pEntity.GetClassname() == "item_pills" && pBaseEnt.GetTeamNumber() == 2)
	{
		if(g_iAntidote[pBaseEnt.entindex()] < 2)
		{
			g_iAntidote[pBaseEnt.entindex()]++;
			if(g_iAntidote[pBaseEnt.entindex()] >= 2) pBaseEnt.SetMaxHealth(1);
			Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0.0, fade_in);
			pBaseEnt.SetHealth((pBaseEnt.GetHealth() - 20) + Math::RandomInt(15, 25));
//			Engine.EmitSoundEntity(pBaseEnt, "HealthKit.Touch");
			pEntity.SUB_Remove();
			Chat.CenterMessagePlayer(pPlrEnt, "You picked up an antidote!\nInfectionResist: "+g_iAntidote[pBaseEnt.entindex()]);
		}
		
		else Chat.CenterMessagePlayer(pPlrEnt, "You got Maximum Infection Resist: "+g_iAntidote[pBaseEnt.entindex()]);
	}
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	if(pEntity.GetClassname() == "item_pills" && pBaseEnt.GetTeamNumber() == 2 && g_iAntidote[pBaseEnt.entindex()] >= 2) Chat.CenterMessagePlayer(pPlrEnt, "You got Maximum Infection Resist: "+g_iAntidote[pBaseEnt.entindex()]);
}