array<int> g_iArmor;

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	if(pEntity.GetClassname() == "item_armor")
	{
		if(g_iArmor[pBaseEnt.entindex()] < 2) g_iArmor[pBaseEnt.entindex()]++;
		
		Chat.CenterMessagePlayer(pPlrEnt, "Infection Protection: "+g_iArmor[pBaseEnt.entindex()]);
	}
	
	//SD("g_iArmor["+pBaseEnt.entindex()+"] = " +g_iArmor[pBaseEnt.entindex()]);
}