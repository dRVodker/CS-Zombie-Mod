array<CEntityData@> gCustomItemIPD;

void SetUpIPD(const int &in iFlags)
{
	gCustomItemIPD.resize(5);
	for (int i = 0; i < 5; i++)
	{
		@gCustomItemIPD[i] = EntityCreator::EntityData();
	}

	if (iFlags & 1<<1 == 1<<1)
	{
		gCustomItemIPD[1].Add("targetname", "weapon_fragmine");
		gCustomItemIPD[1].Add("viewmodel", "models/cszm/weapons/v_minefrag.mdl");
		gCustomItemIPD[1].Add("model", "models/cszm/weapons/w_minefrag.mdl");
		gCustomItemIPD[1].Add("itemstate", "1");
		gCustomItemIPD[1].Add("isimportant", "0");
		gCustomItemIPD[1].Add("carrystate", "6");
		gCustomItemIPD[1].Add("glowcolor", "0 128 245");
		gCustomItemIPD[1].Add("delivername", "FragMine");
		gCustomItemIPD[1].Add("sound_pickup", "Player.PickupWeapon");
		gCustomItemIPD[1].Add("printname", "vgui/images/fragmine");
		gCustomItemIPD[1].Add("weight", "5");
		gCustomItemIPD[1].Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}FragMine IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<2 == 1<<2)
	{
		gCustomItemIPD[2].Add("targetname", "item_adrenaline");
		gCustomItemIPD[2].Add("delivername", "Adrenaline");
		gCustomItemIPD[2].Add("glowcolor", "5 250 121");
		gCustomItemIPD[2].Add("itemstate", "1");
		gCustomItemIPD[2].Add("model", "models/cszm/weapons/w_adrenaline.mdl");
		gCustomItemIPD[2].Add("viewmodel", "models/cszm/weapons/v_adrenaline.mdl");
		gCustomItemIPD[2].Add("printname", "vgui/images/adrenaline");
		gCustomItemIPD[2].Add("sound_pickup", "Deliver.PickupGeneric");
		gCustomItemIPD[2].Add("weight", "0");
		gCustomItemIPD[2].Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Adrenaline IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<3 == 1<<3)
	{
		gCustomItemIPD[3].Add("targetname", "item_antidote");
		gCustomItemIPD[3].Add("delivername", "Antidote");
		gCustomItemIPD[3].Add("glowcolor", "5 250 121");
		gCustomItemIPD[3].Add("itemstate", "1");
		gCustomItemIPD[3].Add("model", "models/cszm/weapons/w_antidote.mdl");
		gCustomItemIPD[3].Add("viewmodel", "models/cszm/weapons/v_antidote.mdl");
		gCustomItemIPD[3].Add("printname", "vgui/images/weapons/inoculator");
		gCustomItemIPD[3].Add("sound_pickup", "Deliver.PickupGeneric");
		gCustomItemIPD[3].Add("weight", "0");
		gCustomItemIPD[3].Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Antidote IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<4 == 1<<4)
	{
		gCustomItemIPD[4].Add("canfirehurt", "0");
		gCustomItemIPD[4].Add("minhealthdmg", "1000");
		gCustomItemIPD[4].Add("model", "models/cszm/weapons/w_rubles.mdl");
		gCustomItemIPD[4].Add("nodamageforces", "1");
		gCustomItemIPD[4].Add("nofiresound", "1");
		gCustomItemIPD[4].Add("physdamagescale", "0");
		gCustomItemIPD[4].Add("spawnflags", "8582");
		gCustomItemIPD[4].Add("unbreakable", "1");
		gCustomItemIPD[4].Add("overridescript", "mass,1,");
		gCustomItemIPD[4].Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Money IPD {cyan}Added{green}=-");
	}
}

void ClearIPD()
{
	for (int i = 0; i < 5; i++)
	{
		@gCustomItemIPD[i] = null;
	}
}

CBaseEntity@ SpawnWepFragMine(CBaseEntity@ pEntity)
{
	CBaseEntity@ pMineEntity = EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), gCustomItemIPD[1]);
	pEntity.SUB_Remove();
	return pMineEntity;
}

void SpawnAdrenaline(CBaseEntity@ pEntity)
{
	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), gCustomItemIPD[2]);
	pEntity.SUB_Remove();
}

void SpawnAntidote(CBaseEntity@ pEntity)
{
	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), gCustomItemIPD[3]);
	pEntity.SUB_Remove();
}