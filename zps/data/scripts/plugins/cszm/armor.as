array<int> g_iArmor;

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	if(pEntity.GetClassname() == "item_armor")
	{
		if(g_iArmor[pBaseEnt.entindex()] < 2)
		{
			g_iArmor[pBaseEnt.entindex()]++;
			Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0.0, fade_in);
		}
		
		Chat.CenterMessagePlayer(pPlrEnt, "Infection Protection: "+g_iArmor[pBaseEnt.entindex()]);
	}
	
	//SD("g_iArmor["+pBaseEnt.entindex()+"] = " +g_iArmor[pBaseEnt.entindex()]);
}