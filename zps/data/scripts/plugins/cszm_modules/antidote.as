array<int> g_iAntidote;

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int iIndex = pBaseEnt.entindex();

	if (pEntity.GetEntityName() == "iantidote")
	{
		pEntity.SetEntityName(iIndex + "iantidote");
		if (g_iAntidote[iIndex] >= 2)
		{
			Chat.CenterMessagePlayer(pPlrEnt, "You got Maximum Infection Resist: "+g_iAntidote[iIndex]);
			Engine.Ent_Fire(iIndex + "iantidote", "addoutput", "itemstate 0");
		}
		else
		{
			Engine.Ent_Fire(iIndex + "iantidote", "addoutput", "itemstate 1");
		}
	}	
}

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int iIndex = pBaseEnt.entindex();

	if (Utils.StrContains("iantidote", pEntity.GetEntityName()) && Utils.StringToInt(pEntity.GetEntityName()) == iIndex)
	{
		pEntity.SetEntityName("iantidote");
		return;
	}

	if (Utils.StrContains("used", pEntity.GetEntityName()))
	{
		pEntity.SUB_Remove();
		return;
	}
}

void OnItemDeliverUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity, int &in iEntityOutput)
{
	if (pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int iIndex = pBaseEnt.entindex();

	if (Utils.StrContains("iantidote", pEntity.GetEntityName()))
	{
		AntidoteInjection(iIndex, pPlayer, pEntity);
	}
}

void AntidoteInjection(const int &in iIndex, CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	g_iAntidote[iIndex]++;
	Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0.0, fade_in);
	pBaseEnt.SetHealth(pBaseEnt.GetHealth() + Math::RandomInt(15, 25));
	Engine.EmitSoundPosition(iIndex, "items/smallmedkit1.wav", pBaseEnt.EyePosition(), 0.5f, 75, 100);

	pEntity.SetEntityName("used" + iIndex);
	Engine.Ent_Fire("used" + iIndex, "addoutput", "itemstate 0");
	Engine.Ent_Fire("used" + iIndex, "kill", "0", "0.5");

	if (g_iAntidote[iIndex] >= 2) 
	{
		Chat.CenterMessagePlayer(pPlrEnt, "You got Maximum Infection Resist: "+g_iAntidote[iIndex]);
		SetAntidoteState(iIndex, 0);
	}
	else Chat.CenterMessagePlayer(pPlrEnt, "Infection Resist: "+g_iAntidote[pBaseEnt.entindex()]);
}

void SetAntidoteState(const int &in iIndex, const int &in iAStage)
{
	bool bTest = false;
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "item_deliver")) !is null)
	{
		if (Utils.StringToInt(pEntity.GetEntityName()) == iIndex && Utils.StrContains("iantidote", pEntity.GetEntityName()))
		{
			bTest = true;
		}
	}

	if (bTest)
	{
		Engine.Ent_Fire(iIndex + "iantidote", "addoutput", "itemstate " + iAStage);
	}
}

void SpawnAntidote(CBaseEntity@ pEntity)
{
	if (!bIsCSZM)
	{
		return;
	}

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