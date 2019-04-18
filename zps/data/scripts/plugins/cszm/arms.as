void SetCSSArms()
{
	int iMP = Globals.GetMaxClients();

	for(int i = 0; i <= iMP; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);

		if(pPlayer is null) continue;

		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if(pBaseEnt.GetTeamNumber() != 3) pPlayer.SetArmModel("models/cszm/weapons/c_css_arms.mdl");
		else pPlayer.SetArmModel("models/cszm/weapons/c_css_zombie_arms.mdl");
	}
}