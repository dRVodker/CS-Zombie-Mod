CEntityData@ gFragMineIPD = EntityCreator::EntityData();
CEntityData@ gAdrenalineIPD = EntityCreator::EntityData();
CEntityData@ gAntidoteIPD = EntityCreator::EntityData();
CEntityData@ gMoneyIPD = EntityCreator::EntityData();

void SetUpIPD(const int &in iFlags)
{
	if (iFlags & 1<<1 == 1<<1)
	{
		gFragMineIPD.Add("targetname", "weapon_fragmine");
		gFragMineIPD.Add("viewmodel", "models/cszm/weapons/v_minefrag.mdl");
		gFragMineIPD.Add("model", "models/cszm/weapons/w_minefrag.mdl");
		gFragMineIPD.Add("itemstate", "1");
		gFragMineIPD.Add("isimportant", "0");
		gFragMineIPD.Add("carrystate", "6");
		gFragMineIPD.Add("glowcolor", "0 128 245");
		gFragMineIPD.Add("delivername", "FragMine");
		gFragMineIPD.Add("sound_pickup", "Player.PickupWeapon");
		gFragMineIPD.Add("printname", "vgui/images/fragmine");
		gFragMineIPD.Add("weight", "5");
		gFragMineIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}FragMine IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<2 == 1<<2)
	{
		gAdrenalineIPD.Add("targetname", "item_adrenaline");
		gAdrenalineIPD.Add("delivername", "Adrenaline");
		gAdrenalineIPD.Add("glowcolor", "5 250 121");
		gAdrenalineIPD.Add("itemstate", "1");
		gAdrenalineIPD.Add("model", "models/cszm/weapons/w_adrenaline.mdl");
		gAdrenalineIPD.Add("viewmodel", "models/cszm/weapons/v_adrenaline.mdl");
		gAdrenalineIPD.Add("printname", "vgui/images/adrenaline");
		gAdrenalineIPD.Add("sound_pickup", "Deliver.PickupGeneric");
		gAdrenalineIPD.Add("weight", "0");
		gAdrenalineIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Adrenaline IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<3 == 1<<3)
	{
		gAntidoteIPD.Add("targetname", "item_antidote");
		gAntidoteIPD.Add("delivername", "Antidote");
		gAntidoteIPD.Add("glowcolor", "5 250 121");
		gAntidoteIPD.Add("itemstate", "1");
		gAntidoteIPD.Add("model", "models/cszm/weapons/w_antidote.mdl");
		gAntidoteIPD.Add("viewmodel", "models/cszm/weapons/v_antidote.mdl");
		gAntidoteIPD.Add("printname", "vgui/images/weapons/inoculator");
		gAntidoteIPD.Add("sound_pickup", "Deliver.PickupGeneric");
		gAntidoteIPD.Add("weight", "0");
		gAntidoteIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Antidote IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<4 == 1<<4)
	{
		gMoneyIPD.Add("canfirehurt", "0");
		gMoneyIPD.Add("minhealthdmg", "1000");
		gMoneyIPD.Add("model", "models/zp_props/100dollar/100dollar.mdl");
		gMoneyIPD.Add("nodamageforces", "1");
		gMoneyIPD.Add("nofiresound", "1");
		gMoneyIPD.Add("physdamagescale", "0");
		gMoneyIPD.Add("spawnflags", "8582");
		gMoneyIPD.Add("unbreakable", "1");
		gMoneyIPD.Add("overridescript", "mass,1,");
		gMoneyIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Money IPD {cyan}Added{green}=-");
	}
}

void ClearIPD()
{
	@gFragMineIPD is null;
	@gAdrenalineIPD is null;
	@gAntidoteIPD is null;
	@gMoneyIPD is null;
}

CBaseEntity@ SpawnWepFragMine(CBaseEntity@ pEntity)
{
	CBaseEntity@ pMineEntity = EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), gFragMineIPD);
	pEntity.SUB_Remove();
	return pMineEntity;
}

void SpawnAdrenaline(CBaseEntity@ pEntity)
{
	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), gAdrenalineIPD);
	pEntity.SUB_Remove();
}

void SpawnAntidote(CBaseEntity@ pEntity)
{
	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), gAntidoteIPD);
	pEntity.SUB_Remove();
}