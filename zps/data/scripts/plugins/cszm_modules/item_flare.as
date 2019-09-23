int iPreviousID;

array<string> g_strWeaponsCN =
{
	"weapon_ppk",
	"weapon_usp",
	"weapon_glock",
	"weapon_glock18c",
	"weapon_revolver",
	"weapon_mp5",
	"weapon_m4",
	"weapon_ak47",
	"weapon_supershorty",
	"weapon_winchester",
	"weapon_870"
};

array<string> g_strExpCN =
{
	"weapon_frag",
	"weapon_ied",
	"weapon_machete"
};

array<string> g_strAmmoCN =
{
	"item_ammo_pistol",
	"item_ammo_rifle",
	"item_ammo_shotgun",
	"item_ammo_revolver"
};

array<string> g_strMedCN =
{
	"item_pills",
	"item_healthkit",
	"item_armor"
};

void SpawnRandomItem(CBaseEntity@ pEntity)
{
	uint length;
	string classname;
	int RND = iPreviousID;

	while (RND == iPreviousID)
	{
		RND = Math:: RandomInt(1, 4);
	}

	iPreviousID = RND;

	switch(RND)
	{
		case 1:
			length = g_strWeaponsCN.length() - 1;
			classname = g_strWeaponsCN[Math::RandomInt(0, length)];
		break;
		
		case 2:
			length = g_strExpCN.length() - 1;
			classname = g_strExpCN[Math::RandomInt(0, length)];
		break;
		
		case 3:
			length = g_strAmmoCN.length() - 1;
			classname = g_strAmmoCN[Math::RandomInt(0, length)];
		break;
		
		case 4:
			length = g_strMedCN.length() - 1;
			classname = g_strMedCN[Math::RandomInt(0, length)];
		break;
	}

	if (Utils.StrEql("weapon_machete", classname))
	{
		SpawnWepFragMine(pEntity);
	}

	else if (Utils.StrEql("item_healthkit", classname)) 
	{
		SpawnAntidote(pEntity);
	}

	else if (Utils.StrEql("item_pills", classname))
	{
		SpawnAdrenaline(pEntity);
	}

	else
	{
		CEntityData@ ItemIPD = EntityCreator::EntityData();
		ItemIPD.Add("DisableDamageForces", "1", true);

		CBaseEntity@ pItem = EntityCreator::Create(classname, pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), ItemIPD);

		pEntity.SUB_Remove();
	}
}

void SpawnWepFragMine(CBaseEntity@ pEntity)
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

	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), WepFragMineIPD);

	pEntity.SUB_Remove();
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

	AntidoteIPD.Add("targetname", "iantidote");
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