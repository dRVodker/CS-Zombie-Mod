void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Dropped Items Limit");

	Events::Entities::OnEntityDestruction.Hook(@CSZM_DI_OnEntityDestruction);
	Events::Entities::OnEntityCreation.Hook(@CSZM_DI_OnEntityCreation);
}

const int MAX_DROPPED_ITEMS = 32;
bool bIsCSZM;
float flTimeToDelete;

array<int> gItemIndex;
array<DroppedItem@> gItem;

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
		flTimeToDelete = Globals.GetCurrentTime() + 0.25f;
		RegisterEntity();
		Engine.Ent_Fire("_items_to_kill", "kill", "0", "0.1");
	}
}

void OnNewRound()
{
	if (bIsCSZM)
	{
		RemoveRange();
		flTimeToDelete = Globals.GetCurrentTime() + 0.25f;
		Engine.Ent_Fire("_items_to_kill", "kill", "0", "0.1");
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		bIsCSZM = false;
		RemoveRange();
	}
}

void RemoveRange()
{
	gItemIndex.removeRange(0,gItemIndex.length());
	gItem.removeRange(0,gItem.length());
}

class DroppedItem
{
	int Eindex;

	DroppedItem(const int nIndex)
	{
		Eindex = nIndex;
	}

	void Fade()
	{
		CBaseEntity@ pItem = FindEntityByEntIndex(Eindex);

		if (pItem !is null)
		{
			Eindex = -1;
			pItem.SUB_StartFadeOut(0.05f, true);
		}
	}
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (Utils.StrContains("weapon", pEntity.GetClassname()) && !Utils.StrContains("_frag", pEntity.GetClassname()))
	{
		RemoveItem(gItemIndex.find(pEntity.entindex()));
	}
}

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if ((Utils.StrContains("clip", pEntity.GetClassname()) || Utils.StrContains("armor", pEntity.GetClassname())) || (Utils.StrContains("weapon", pEntity.GetClassname()) && !Utils.StrContains("_frag", pEntity.GetClassname())))
	{
		InsertItem(pEntity.entindex());
	}
}

HookReturnCode CSZM_DI_OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (((Utils.StrContains("weapon", strClassname) || Utils.StrContains("item", strClassname)) && !(Utils.StrEql("weapon_phone", strClassname, true) || Utils.StrEql("item_deliver", strClassname, true) || Utils.StrEql("weapon_emptyhand", strClassname, true))) && flTimeToDelete > Globals.GetCurrentTime())
	{
		pEntity.SetEntityName("_items_to_kill");
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_DI_OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if ((Utils.StrEql("dropped_money", pEntity.GetEntityName(), true) || Utils.StrContains("clip", strClassname) || Utils.StrContains("armor", strClassname)) || (Utils.StrContains("weapon", strClassname) && !Utils.StrContains("_frag", strClassname)))
	{
		RemoveItem(gItemIndex.find(pEntity.entindex()));
	}

	return HOOK_CONTINUE;
}

void OnItemCashCreation(NetObject@ pData)
{
	if (pData is null)
	{
		return;
	}

	if (pData.HasIndexValue(0))
	{
		InsertItem(pData.GetInt(0));
	}
}

void InsertItem(const int &in EntIndex)
{
	if (gItemIndex.find(EntIndex) < 0)
	{
		gItemIndex.insertLast(EntIndex);
		gItem.insertLast(DroppedItem(EntIndex));
		CheckDropCount();
	}
}

void RemoveItem(const int &in ArrPos)
{
	if (ArrPos != -1)
	{
		@gItem[ArrPos] is null;
		gItemIndex[ArrPos] = 0;
		gItemIndex.removeAt(ArrPos);
		gItem.removeAt(ArrPos);
	}
}

void CheckDropCount()
{
	if (gItemIndex.length() > MAX_DROPPED_ITEMS)
	{
		gItem[0].Fade();
		gItem.removeAt(0);
		gItemIndex.removeAt(0);
	}
}

void RegisterEntity()
{
	const array<string> pClassName =
	{
		"weapon_870",
		"weapon_ak47",
		"weapon_axe",
		"weapon_baguette",
		"weapon_barricade",
		"weapon_bat_aluminum",
		"weapon_bat_wood",
		"weapon_broom",
		"weapon_bugbait",
		"weapon_chair",
		"weapon_crowbar",
		"weapon_fryingpan",
		"weapon_glock",
		"weapon_glock18c",
		"weapon_golf",
		"weapon_ied",
		"weapon_inoculator",
		"weapon_inoculator_delay",
		"weapon_inoculator_full",
		"weapon_keyboard",
		"weapon_m4",
		"weapon_machete",
		"weapon_meatcleaver",
		"weapon_mp5",
		"weapon_pipe",
		"weapon_pipewrench",
		"weapon_plank",
		"weapon_pot",
		"weapon_ppk",
		"weapon_racket",
		"weapon_revolver",
		"weapon_shovel",
		"weapon_sledgehammer",
		"weapon_snowball",
		"weapon_spanner",
		"weapon_supershorty",
		"weapon_tennisball",
		"weapon_tireiron",
		"weapon_usp",
		"weapon_winchester",
		"weapon_wrench",
		"item_ammo_pistol_clip",
		"item_ammo_revolver_clip",
		"item_ammo_shotgun_clip",
		"item_ammo_rifle_clip",
		"item_ammo_barricade_clip",
		"item_ammo_pistol_clip",
		"item_ammo_revolver",
		"item_ammo_shotgun",
		"item_ammo_rifle",
		"item_ammo_barricade",
		"item_armor",
		"item_deliver"
	};

	int length = int(pClassName.length());

	for (int i = 0; i < length;i++)
	{
		Entities::RegisterDrop(pClassName[i]);
		Entities::RegisterPickup(pClassName[i]);
	}
}