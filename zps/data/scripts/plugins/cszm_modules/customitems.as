CBaseEntity@ SpawnWepFragMine(CBaseEntity@ pEntity)
{
	CEntityData@ WepFragMineIPD = EntityCreator::EntityData();
	WepFragMineIPD.Add("targetname", "weapon_fragmine");
	WepFragMineIPD.Add("viewmodel", "models/cszm/weapons/v_minefrag.mdl");
	WepFragMineIPD.Add("model", "models/cszm/weapons/w_minefrag.mdl");
	WepFragMineIPD.Add("itemstate", "1");
	WepFragMineIPD.Add("isimportant", "0");
	WepFragMineIPD.Add("carrystate", "6");
	WepFragMineIPD.Add("glowcolor", "0 128 245");
	WepFragMineIPD.Add("delivername", "FragMine");
	WepFragMineIPD.Add("sound_pickup", "Player.PickupWeapon");
	WepFragMineIPD.Add("printname", "vgui/images/fragmine");
	WepFragMineIPD.Add("weight", "5");

	WepFragMineIPD.Add("DisableDamageForces", "0", true);

	CBaseEntity@ pMineEntity = EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), WepFragMineIPD);

	pEntity.SUB_Remove();

	return pMineEntity;
}

void SpawnAdrenaline(CBaseEntity@ pEntity)
{
	CEntityData@ AdrenalineIPD = EntityCreator::EntityData();

	AdrenalineIPD.Add("targetname", "item_adrenaline");
	AdrenalineIPD.Add("delivername", "Adrenaline");
	AdrenalineIPD.Add("glowcolor", "5 250 121");
	AdrenalineIPD.Add("itemstate", "1");
	AdrenalineIPD.Add("model", "models/cszm/weapons/w_adrenaline.mdl");
	AdrenalineIPD.Add("viewmodel", "models/cszm/weapons/v_adrenaline.mdl");
	AdrenalineIPD.Add("printname", "vgui/images/adrenaline");
	AdrenalineIPD.Add("sound_pickup", "Deliver.PickupGeneric");
	AdrenalineIPD.Add("weight", "0");
	
	AdrenalineIPD.Add("DisableDamageForces", "0", true);

	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), AdrenalineIPD);

	pEntity.SUB_Remove();
}

void SpawnAntidote(CBaseEntity@ pEntity)
{
	CEntityData@ AntidoteIPD = EntityCreator::EntityData();

	AntidoteIPD.Add("targetname", "item_antidote");
	AntidoteIPD.Add("delivername", "Antidote");
	AntidoteIPD.Add("glowcolor", "5 250 121");
	AntidoteIPD.Add("itemstate", "1");
	AntidoteIPD.Add("model", "models/cszm/weapons/w_antidote.mdl");
	AntidoteIPD.Add("viewmodel", "models/cszm/weapons/v_antidote.mdl");
	AntidoteIPD.Add("printname", "vgui/images/weapons/inoculator");
	AntidoteIPD.Add("sound_pickup", "Deliver.PickupGeneric");
	AntidoteIPD.Add("weight", "0");

	AntidoteIPD.Add("DisableDamageForces", "0", true);

	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), AntidoteIPD);

	pEntity.SUB_Remove();
}