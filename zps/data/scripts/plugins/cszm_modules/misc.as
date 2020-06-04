void AutoMap()
{
	Schedule::Task(0.05f, "CSZM_SetScreenOverlay");
}

bool bDamageType(int &in iSubjectDT, int &in iDMGNum)
{
	return iSubjectDT & (1<<iDMGNum) == (1<<iDMGNum);;
}

void MovePlrToSpec(CBaseEntity@ pEntPlr)
{
	pEntPlr.ChangeTeam(TEAM_LOBBYGUYS);
	CZP_Player@ pPlayer = ToZPPlayer(pEntPlr);
	pPlayer.ConsoleCommand("choose3");
}

int CountPlrs(const int &in iTeamNum)
{
	int iCount = 0;
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		if (pPlayer is null)
		{
			continue;
		}
			
		CBaseEntity@ pBaseEnt = FindEntityByEntIndex(i);

		if (pBaseEnt.GetTeamNumber() == iTeamNum)
		{
			iCount++;
		}
	}
	
	return iCount;
}

void SetDoorFilter(const int &in iFilter)
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "AddOutput", "doorfilter " + iFilter);
	}
}

void lobby_hint(CZP_Player@ pPlayer)
{
	string sNextLine = "\n";
	SendGameTextPlayer(pPlayer, strHintF1, 3, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(64, 128, 255), Color(255, 95, 5));
	SendGameTextPlayer(pPlayer, "\n" + strHintF3, 4, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(255, 255, 255), Color(255, 95, 5));
}

void lobby_hint_wu(CZP_Player@ pPlayer)
{
	SendGameTextPlayer(pPlayer, strHintF4WU, 3, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(64, 255, 128), Color(255, 95, 5));
}

void spec_hint(CZP_Player@ pPlayer)
{
	SendGameTextPlayer(pPlayer, strHintF4, 3, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 15.0f, Color(64, 255, 128), Color(255, 95, 5));
}

void PutPlrToLobby(CBaseEntity@ pEntPlayer)
{
	array<CBaseEntity@> g_pLobbySpawn = {null};
	CBaseEntity@ pEntity;
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_commons")) !is null)
	{
		g_pLobbySpawn.insertLast(pEntity);
	}

	int iLength = g_pLobbySpawn.length() - 1;
	if (pEntPlayer is null)
	{
		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);

			if (pPlayer is null)
			{
				continue;
			}

			CBaseEntity@ pBaseEnt = FindEntityByEntIndex(i);

			if (pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS || pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
			{
				pBaseEnt.SetAbsOrigin(g_pLobbySpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
			}
		}
	}
	else
	{
		pEntPlayer.SetAbsOrigin(g_pLobbySpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
	}
}

void PutPlrToPlayZone(CBaseEntity@ pEntPlayer)
{
	array<CBaseEntity@> g_pOtherSpawn = {null};
	CBaseEntity@ pEntity;
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_human")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_zombie")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_start")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}

	int iLength = g_pOtherSpawn.length() - 1;
	
	if (pEntPlayer is null)
	{
		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);
			
			if (pPlayer is null)
			{
				continue;
			}
			
			CBaseEntity@ pBaseEnt = FindEntityByEntIndex(i);

			if (pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS || pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
			{
				pBaseEnt.SetAbsOrigin(g_pOtherSpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
			}
		}
	}
	else
	{
		pEntPlayer.SetAbsOrigin(g_pOtherSpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
	}
}

void AttachTrail(CBaseEntity@ pEntity, const string strColor)
{
		CEntityData@ SPRTrailIPD = EntityCreator::EntityData();
		SPRTrailIPD.Add("lifetime", "0.25");
		SPRTrailIPD.Add("renderamt", "255");
		SPRTrailIPD.Add("rendercolor", strColor);
		SPRTrailIPD.Add("rendermode", "5");
		SPRTrailIPD.Add("spritename", "sprites/lgtning.vmt");
		SPRTrailIPD.Add("startwidth", "3.85");

		CEntityData@ SpriteIPD = EntityCreator::EntityData();
		SpriteIPD.Add("spawnflags", "1");
		SpriteIPD.Add("GlowProxySize", "4");
		SpriteIPD.Add("scale", "0.35");
		SpriteIPD.Add("rendermode", "9");
		SpriteIPD.Add("rendercolor", strColor);
		SpriteIPD.Add("renderamt", "255");
		SpriteIPD.Add("model", "sprites/light_glow01.vmt");
		SpriteIPD.Add("renderfx", "0");

		CEntityData@ DLightIPD = EntityCreator::EntityData();
		DLightIPD.Add("_cone", "0");
		DLightIPD.Add("_inner_cone", "0");
		DLightIPD.Add("pitch", "0");
		DLightIPD.Add("spawnflags", "0");
		DLightIPD.Add("spotlight_radius", "0");
		DLightIPD.Add("style", "0");
		DLightIPD.Add("_light", strColor + " 200");
		DLightIPD.Add("brightness", "4");
		DLightIPD.Add("distance", "48");

		CBaseEntity@ pEntTrail = EntityCreator::Create("env_spritetrail", pEntity.GetAbsOrigin(), QAngle(0, 0, 0), SPRTrailIPD);
		CBaseEntity@ pEntSprite = EntityCreator::Create("env_sprite", pEntity.GetAbsOrigin(), QAngle(0, 0, 0), SpriteIPD);
		CBaseEntity@ pDLight = EntityCreator::Create("light_dynamic", pEntity.GetAbsOrigin(), QAngle(0, 0, 0), DLightIPD);
		
		pEntTrail.SetParent(pEntity);
		pEntSprite.SetParent(pEntity);
		pDLight.SetParent(pEntity);
}

void SetUsed(const int &in index, CBaseEntity@ pItemDeliver)
{
	pItemDeliver.SetEntityName("used" + index);
	Engine.Ent_Fire("used" + index, "addoutput", "itemstate 0");
	Engine.Ent_Fire("used" + index, "kill", "0", "0.5");	
}

void CSZM_EndGame()
{
	if (Utils.GetNumPlayers(survivor, true) > 0) 
	{
		RoundManager.SetWinState(ws_HumanWin);
	}
	else if (Utils.GetNumPlayers(zombie, true) == 0) 
	{
		RoundManager.SetWinState(ws_Stalemate);
	}
	else
	{
		RoundManager.SetWinState(ws_ZombieWin);
	}
}

void EmitBloodEffect(CZP_Player@ pPlayer, const bool &in bSilent)
{
	if (pPlayer is null)
	{
		return;
	}

	Utils.ScreenFade(pPlayer, Color(125, 35, 30, 145), 0.375, 0, fade_in);

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	CEntityData@ CameraBloodIPD = EntityCreator::EntityData();
	CameraBloodIPD.Add("targetname", "PS-Turn-Head");
	CameraBloodIPD.Add("flag_as_weather", "0");
	CameraBloodIPD.Add("start_active", "1");
	CameraBloodIPD.Add("effect_name", "blood_impact_red_01_headshot");
	CameraBloodIPD.Add("kill", "0", true, "0.05");

	CEntityData@ BodyBloodIPD = EntityCreator::EntityData();
	BodyBloodIPD.Add("targetname", "PS-Turn");
	BodyBloodIPD.Add("flag_as_weather", "0");
	BodyBloodIPD.Add("start_active", "1");
	BodyBloodIPD.Add("effect_name", "blood_explode_01");
	BodyBloodIPD.Add("kill", "0", true, "0.05");

	EntityCreator::Create("info_particle_system", pBaseEnt.EyePosition(), pBaseEnt.EyeAngles(), CameraBloodIPD);
	EntityCreator::Create("info_particle_system", pBaseEnt.GetAbsOrigin(), pBaseEnt.GetAbsAngles(), BodyBloodIPD);
	
	if (!bSilent)
	{
		Engine.EmitSoundEntity(pBaseEnt, "Flesh.HeadshotExplode");
	}
}

void ZombiePoints(CZP_Player@ pIgnorePlayer)
{
	pIgnorePlayer.AddScore(100, null);

	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayer !is null)
		{
			if (pPlayerEntity.GetTeamNumber() == TEAM_ZOMBIES)
			{
				pPlayer.AddScore(-100, pIgnorePlayer);
			}
		}
	}
}

void ShowHP(CBasePlayer@ pBasePlayer, const int &in iHP, const bool &in bLeft, const bool &in bHide)
{
	if (bHide)
	{
		Chat.CenterMessagePlayer(pBasePlayer, "");
	}
	else
	{
		string strLeft = "";

		if (bLeft)
		{
			strLeft = " Left";
		}

		Chat.CenterMessagePlayer(pBasePlayer, iHP + " HP" + strLeft);
	}
}

void SetAntidoteState(const int &in iIndex, const int &in iAStage)
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByName(pEntity, "item_antidote")) !is null)
	{
		if (Utils.StringToInt(pEntity.GetEntityDescription()) == iIndex && Utils.StrEql("item_antidote", pEntity.GetEntityName(), true))
		{
			pEntity.SetEntityName("antidote" + iIndex);
			Engine.Ent_Fire(pEntity.GetEntityName(), "addoutput", "itemstate " + formatInt(iAStage));
			Engine.Ent_Fire(pEntity.GetEntityName(), "addoutput", "targetname item_antidote", "0.01");
		}
	}
}

void RegisterEntities()
{
	Entities::RegisterPickup("item_deliver");
	Entities::RegisterUse("item_deliver");
	Entities::RegisterDrop("item_deliver");
}

string GetAttackerInfo(const string &in FullInfo)
{
	string AttakerInfo = ":";
	if (Utils.StrContains("|", FullInfo))
	{
		int iFirst = FullInfo.findFirst("|", 0) + 1;
		int iLast = FullInfo.findFirst("|", iFirst);
		AttakerInfo = FullInfo.substr(iFirst, iLast - iFirst);			
	}

	return AttakerInfo;
}

string EraseAttackerInfo(string &in FullInfo)
{
	if (Utils.StrContains("|", FullInfo))
	{
		int iFirst = FullInfo.findFirst("|", 0) + 1;
		int iLast = FullInfo.findFirst("|", iFirst);
		FullInfo.erase(iFirst - 1, iLast - iFirst + 2);
	}

	return FullInfo;
}

bool bIsPropUnbreakable(CBaseEntity@ pEntity)
{
	return Utils.StrContains("unbreakable", pEntity.GetEntityDescription());
}

bool bIsPropJunk(CBaseEntity@ pEntity)
{
	return Utils.StrContains("junk", pEntity.GetEntityDescription());
}

bool bIsPropExplosive(CBaseEntity@ pEntity)
{
	return Utils.StrContains("explosive", pEntity.GetEntityDescription());
}

void HealthSettings()
{
	CBaseEntity@ pEntity = null;
	int iPlrCount = Utils.GetNumPlayers(survivor, true);
	int iLength = int(g_strBreakableEntities.length());

	if (iPlrCount < 6)
	{
		iPlrCount = 5;
	}

	for (int i = 0; i < iLength; i++)
	{
		while ((@pEntity = FindEntityByClassname(pEntity, g_strBreakableEntities[i])) !is null)
		{
			if (i <= 2)
			{
				SetCustomPropHealth(pEntity, iPlrCount);
			}
			else if (i == 3)
			{
				SetCustomDoorHealth(pEntity, iPlrCount);
			}
			else
			{
				SetCustomFuncHealth(pEntity, iPlrCount);
			}
		}
	}
}

void SetCustomPropHealth(CBaseEntity@ pEntity, const int &in iPlrCount)
{
	if (!bIsPropJunk(pEntity))
	{
		if (!bIsPropExplosive(pEntity))
		{
			float flBaseHealth = float(pEntity.GetHealth());
			int iCustomHealth = int((flBaseHealth * 0.0845f) * iPlrCount);

			if (iCustomHealth > PROP_MAX_HEALTH)
			{
				iCustomHealth = PROP_MAX_HEALTH;
			}

			pEntity.SetHealth(iCustomHealth + Math::RandomInt(0, 35));			
		}
	}
}

void SetCustomDoorHealth(CBaseEntity@ pEntity, const int &in iPlrCount)
{
	float flMultiplier = 3.0f;
	if(Utils.StrContains("doormainmetal01", pEntity.GetModelName()))
	{
		flMultiplier = 6.2f;
	}
	else if(Utils.StrContains("doormain01", pEntity.GetModelName()))
	{
		flMultiplier = 5.9f;
	}
	else if(Utils.StrContains("door_zps_wood", pEntity.GetModelName()))
	{
		flMultiplier = 7.1f;
	}
	else if(Utils.StrContains("door_zps_metal", pEntity.GetModelName()))
	{
		flMultiplier = 7.9f;
	}

	Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + int((iPlrCount * flMultiplier) + Math::RandomInt(0, 25)), "0.00");	
}

void SetCustomFuncHealth(CBaseEntity@ pEntity, const int &in iPlrCount)
{
	string strTargetname = pEntity.GetEntityName();

	if (!Utils.StrContains("special", strTargetname))
	{
		float flBaseHealth = float(pEntity.GetHealth());
		int iCustomHealth = int((flBaseHealth * 0.185f) * iPlrCount);

		if (iCustomHealth > BRUSH_MAX_HEALTH)
		{
			iCustomHealth = BRUSH_MAX_HEALTH;
		}

		pEntity.SetHealth(iCustomHealth + Math::RandomInt(0, 35));
	}
}

string GetJustModel(const string &in strFullModelName)
{
	int iLength = strFullModelName.length();
	int iLast = strFullModelName.findLast("/") + 1;	// 1 = "/"
	return strFullModelName.substr(iLast, (iLength - iLast));
}

void CheckProp(CBaseEntity@ pProp, const string &in strClassname)
{
	string ModelName = GetJustModel(pProp.GetModelName());
	string Targetname = pProp.GetEntityName();
	pProp.SetMaxHealth(PROP_MAX_HEALTH + 65);

	if (!Utils.StrContains("unbreakable", pProp.GetEntityDescription()))
	{
		if (Utils.StrContains("unbrk", Targetname) || Utils.StrContains("unbreakable", Targetname))
		{
			pProp.SetEntityDescription(pProp.GetEntityDescription() + ";unbreakable");
		}
	}

	if (!Utils.StrContains("junk", pProp.GetEntityDescription()))
	{
		if (Utils.StrContains("junk", Targetname) || Utils.StrContains("weak", Targetname) || Utils.StrContains("garbage_", ModelName) || Utils.StrContains(ModelName, JUNK_PROP_MODELS))
		{
			pProp.SetEntityDescription(pProp.GetEntityDescription() + ";junk");
		}
	}

	if (!Utils.StrContains("explosive", pProp.GetEntityDescription()))
	{
		if (Utils.StrContains("explosive", Targetname) || Utils.StrContains(ModelName, EXPLOSIVES_PROP_MODELS))
		{
			pProp.SetEntityDescription(pProp.GetEntityDescription() + ";explosive");
		}
	}
}

void CSZM_SetScreenOverlay()
{
	CBaseEntity@ pOverlay = FindEntityByClassname(pOverlay, "env_screenoverlay");
	if (pOverlay is null)
	{
		CEntityData@ ScreenOverlayIPD = EntityCreator::EntityData();
		ScreenOverlayIPD.Add("targetname", "cszm_screenoverlay");
		ScreenOverlayIPD.Add("OverlayName1", "effects/cszm_shading.vmf");
		ScreenOverlayIPD.Add("OverlayTime1", "9999");
		ScreenOverlayIPD.Add("StartOverlays", "0", true);

		EntityCreator::Create("env_screenoverlay", Vector(0, 0, 0), QAngle(0, 0, 0), ScreenOverlayIPD);
	}
}

void GiveStartGear(CZP_Player@ pPlayer, const bool bPPK, const bool bCured)
{
	int iWTSLength = int(g_strWeaponToStrip.length());
	for (int i = 0; i < iWTSLength; i++)
	{
		if (pPlayer !is null)
		{
			StripWeapon(pPlayer, g_strWeaponToStrip[i]);
		}
	}

	if (!bCured)
	{
		int iSWLength = int(g_strStartWeapons.length());
		string firearm = g_strStartWeapons[Math::RandomInt(0, (iSWLength - 1))];
		string melee = "weapon_barricade";
		int pistol_ammo_count = 15;

		if (bPPK)
		{
			firearm = "weapon_ppk";
			pistol_ammo_count = 7;
		}

		pPlayer.AmmoBank(set, pistol, pistol_ammo_count);
		pPlayer.GiveWeapon(melee);
		pPlayer.GiveWeapon(firearm);		
	}
}

void StripWeapon(CZP_Player@ pPlayer, const string &in strClassname)
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pBasePlayer.opCast();
	CBaseEntity@ pWeapon;

	pPlayer.StripWeapon(strClassname);

	while ((@pWeapon = FindEntityByClassname(pWeapon, strClassname)) !is null)
	{
		CBaseEntity@ pOwner = pWeapon.GetOwner();

		if (pPlayerEntity is pOwner)
		{
			pWeapon.SUB_Remove();
		}
	}
}

void CheckForHoldout(const string &in MapName)
{
	if (Utils.StrContains("heavyice", MapName) || Utils.StrContains("sunshine", MapName))
	{
		UnlimitedRandom = true;
		g_strStartWeapons.resize(iStartWeaponLength);
		g_strStartWeapons.insertLast("weapon_mp5");
	}
	else
	{
		UnlimitedRandom = false;
		g_strStartWeapons.resize(iStartWeaponLength);
	}
}

void AttachEyesLights(CBaseEntity@ pPlayerEntity)
{
	CEntityData@ EyesLight = EntityCreator::EntityData();
	EyesLight.Add("HDRColorScale", "0.5");
	EyesLight.Add("model", "sprites/light_glow01.vmt");
	EyesLight.Add("renderamt", "255");
	EyesLight.Add("rendercolor", "255 153 6");
	EyesLight.Add("spawnflags", "1");
	EyesLight.Add("rendermode", "9");
	EyesLight.Add("scale", "0.195");
	EyesLight.Add("GlowProxySize", "1.1");

	CBaseEntity@ pL_Eye = EntityCreator::Create("env_sprite", pPlayerEntity.GetAbsOrigin(), QAngle(0, 0, 0), EyesLight);
	CBaseEntity@ pR_Eye = EntityCreator::Create("env_sprite", pPlayerEntity.GetAbsOrigin(), QAngle(0, 0, 0), EyesLight);
	
	pL_Eye.SetEntityName(pPlayerEntity.entindex() + "_LeftEye");
	pR_Eye.SetEntityName(pPlayerEntity.entindex() + "_RighrEye");
	
	pL_Eye.SetParent(pPlayerEntity);
	pR_Eye.SetParent(pPlayerEntity);
	
	pL_Eye.SetParentAttachment("LeftEye", false);
	pR_Eye.SetParentAttachment("RightEye", false);
}

void DetachEyesLights(CBaseEntity@ pPlayerEntity)
{
	pPlayerEntity.SetBodyGroup("EyesGlow", 0);
	pPlayerEntity.SetSkin(0);

	CBaseEntity@ pR_Eye = FindEntityByName(null, pPlayerEntity.entindex() + "_RighrEye");
	CBaseEntity@ pL_Eye = FindEntityByName(null, pPlayerEntity.entindex() + "_LeftEye");

	if (pR_Eye !is null)
	{
		pR_Eye.SUB_Remove();
	}
	
	if (pL_Eye !is null)
	{
		pL_Eye.SUB_Remove();
	}
}

void HumanVictoryRewards()
{
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null)
		{
			continue;
		}

		CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[i];

		if (pPlayerEntity.IsAlive())
		{
			if (pPlayerEntity.GetTeamNumber() == TEAM_SURVIVORS)
			{
				pCSZMPlayer.AddInfectPoints(-15);
			}
			else if (pPlayerEntity.GetTeamNumber() == TEAM_ZOMBIES)
			{
				pCSZMPlayer.AddInfectPoints(5);
				CTakeDamageInfo SelfDamage = CTakeDamageInfo(pPlayerEntity, pPlayerEntity, float(pPlayerEntity.GetHealth() + 200.0f), (1<<0));
				pPlayerEntity.TakeDamage(SelfDamage);
			}
		}
	}
}

void ShakeInfected(CBaseEntity@ pPlayerEntity)
{
	CEntityData@ ShakeIPD = EntityCreator::EntityData();
	ShakeIPD.Add("spawnflags", "4");
	ShakeIPD.Add("frequency", "42");
	ShakeIPD.Add("duration", "2.21");
	ShakeIPD.Add("amplitude", "16");
	ShakeIPD.Add("radius", "32");

	ShakeIPD.Add("StartShake", "0", true);
	ShakeIPD.Add("kill", "0", true, "0.25");

	EntityCreator::Create("env_shake", pPlayerEntity.EyePosition(), QAngle(-90, 0, 0), ShakeIPD);	
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