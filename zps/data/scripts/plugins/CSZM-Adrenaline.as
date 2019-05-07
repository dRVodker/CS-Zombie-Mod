void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iMaxPlayers;
bool bIsCSZM = false;

const int iHumanSpeed = 197; 
const int iAdrenalineSpeed = 100;

array<float> g_flAdrenalineTime;

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Item_Adrenaline" );

	Engine.PrecacheFile(sound, "cszm_fx/weapons/adrenaline_cap_off.wav");
	Engine.PrecacheFile(sound, "cszm_fx/weapons/adrenaline_needle_open.wav");
	Engine.PrecacheFile(sound, "cszm_fx/weapons/adrenaline_needle_in.wav");

	Events::Entities::OnEntityCreation.Hook( @OnEntityCreation );
	Events::Player::OnPlayerKilled.Hook( @OnPlayerKilled );
}

void OnMapInit()
{
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;

		Entities::RegisterUse("item_adrenaline");
		Entities::RegisterDrop("item_adrenaline");
		Entities::RegisterPickup("item_adrenaline");

		iMaxPlayers = Globals.GetMaxClients();

		g_flAdrenalineTime.resize(iMaxPlayers + 1);
	}
}

void OnMapShutdown()
{
	if(bIsCSZM == true) bIsCSZM = false;
}

void OnNewRound()
{
	if(bIsCSZM == true)
	{
		for ( int i = 1; i <= iMaxPlayers; i++ ) 
		{
			g_flAdrenalineTime[i] = 0.0f;
		}
	}	
}

void OnProcessRound()
{
	if(bIsCSZM == true)
	{
		for(int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
								
			if(pPlayer is null) continue;

			if(g_flAdrenalineTime[i] <= Globals.GetCurrentTime() && g_flAdrenalineTime[i] != 0)
			{
				if(pBaseEnt.GetTeamNumber() == 2)pPlayer.m_iSpeedOverride = iHumanSpeed;
				pPlayer.DoPlayerDSP(0);
				g_flAdrenalineTime[i] = 0;
			}
		}
	}
}

HookReturnCode OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if(bIsCSZM == false) return HOOK_HANDLED;

	if(Utils.StrContains("item_pills", strClassname)) SpawnAdrenaline(pEntity);

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerConnected(CZP_Player@ pPlayer) 
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		g_flAdrenalineTime[pBaseEnt.entindex()] = 0.0f;
	}
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerKilled(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	if(bIsCSZM == false) return HOOK_HANDLED;

	if(pPlayer is null) return HOOK_HANDLED;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();

	if(g_flAdrenalineTime[iIndex] != 0) g_flAdrenalineTime[iIndex] = 0;
	pPlayer.DoPlayerDSP(0);

	return HOOK_CONTINUE;
}

void OnItemDeliverUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity, int &in iEntityOutput)
{
    if(pPlayer is null) return;
    if(pEntity is null) return;
	if(bIsCSZM == false) return;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int iIndex = pBaseEnt.entindex();

	if(pEntity.GetEntityName() == "item_adrenaline") AdrenalineInjection(iIndex, pPlayer, pEntity);
}

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if(bIsCSZM == false) return;

	if(Utils.StrContains("used", pEntity.GetEntityName()))
	{
		pEntity.SUB_Remove();
		return;
	}
}

void AdrenalineInjection(const int &in iIndex, CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if(bIsCSZM == false) return;

	g_flAdrenalineTime[iIndex] = Globals.GetCurrentTime() + 12.0f;
	pPlayer.m_iSpeedOverride = iHumanSpeed + iAdrenalineSpeed;
	pPlayer.DoPlayerDSP(34);
	Utils.ScreenFade(pPlayer, Color(8, 16, 64, 50), 0.25f, 11.75f, fade_in);
	Engine.EmitSoundPlayer(pPlayer, "ZPlayer.Panic");
	pEntity.SetEntityName("used" + iIndex);
	Engine.Ent_Fire("used" + iIndex, "addoutput", "itemstate 0");
	Engine.Ent_Fire("used" + iIndex, "kill", "0", "0.5");
}

void SpawnAdrenaline(CBaseEntity@ pEntity)
{
	if(bIsCSZM == false) return;

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

	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), AdrenalineIPD);

	pEntity.SUB_Remove();
}