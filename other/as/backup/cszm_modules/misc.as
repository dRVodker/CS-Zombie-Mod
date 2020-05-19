void AutoMap()
{
	Schedule::Task(0.05f, "Set_CSZM_ScreenOverlay");
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

void ClearIntArray(array<int> &iTarget)
{
	while (iTarget.length() > 0)
	{
		iTarget.removeAt(0);
	}
}

void lobby_hint(CZP_Player@ pPlayer)
{
	string sNextLine = "\n";
	SendGameTextPlayer(pPlayer, strHintF1, 3, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(64, 128, 255), Color(255, 95, 5));

	if (!RoundManager.IsRoundOngoing(false))
	{
		SendGameTextPlayer(pPlayer, "\n" + strHintF2Inf, 4, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(255, 32, 64), Color(255, 95, 5));
	}
	else if (bAllowZombieSpawn)
	{
		SendGameTextPlayer(pPlayer, "\n" + strHintF2, 4, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(255, 32, 64), Color(255, 95, 5));
	}
	else 
	{
		SendGameTextPlayer(pPlayer, "", 4, 0.0f, 0.00f, 0.0f, 0.0f, 0.0f, 0.0f, Color(0, 0, 0), Color(0, 0, 0));
		sNextLine = "";
	}

	SendGameTextPlayer(pPlayer, "\n" + sNextLine + strHintF3, 5, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(255, 255, 255), Color(255, 95, 5));
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

void AttachEyesLights(CBaseEntity@ pPlayerEntity)
{
	CEntityData@ L_EyeLight = EntityCreator::EntityData();
	L_EyeLight.Add("HDRColorScale", "0.5");
	L_EyeLight.Add("model", "sprites/light_glow01.vmt");
	L_EyeLight.Add("renderamt", "255");
	L_EyeLight.Add("rendercolor", "255 153 6");
	L_EyeLight.Add("spawnflags", "1");
	L_EyeLight.Add("rendermode", "9");
	L_EyeLight.Add("scale", "0.195");
	L_EyeLight.Add("GlowProxySize", "1.1");
	L_EyeLight.Add("targetname", "LeftEye");

	CEntityData@ R_EyeLight = EntityCreator::EntityData();
	R_EyeLight.Add("HDRColorScale", "0.5");
	R_EyeLight.Add("model", "sprites/light_glow01.vmt");
	R_EyeLight.Add("renderamt", "255");
	R_EyeLight.Add("rendercolor", "255 153 6");
	R_EyeLight.Add("spawnflags", "1");
	R_EyeLight.Add("rendermode", "9");
	R_EyeLight.Add("scale", "0.195");
	R_EyeLight.Add("GlowProxySize", "1.1");
	R_EyeLight.Add("targetname", "RighrEye");

	@pL_Eye = EntityCreator::Create("env_sprite", pPlayerEntity.GetAbsOrigin(), QAngle(0, 0, 0), L_EyeLight);
	@pR_Eye = EntityCreator::Create("env_sprite", pPlayerEntity.GetAbsOrigin(), QAngle(0, 0, 0), R_EyeLight);
	
	pL_Eye.SetParent(pPlayerEntity);
	pR_Eye.SetParent(pPlayerEntity);
	
	pL_Eye.SetParentAttachment("LeftEye", false);
	pR_Eye.SetParentAttachment("RightEye", false);
}

void SetUsed(const int &in index, CBaseEntity@ pItemDeliver)
{
	pItemDeliver.SetEntityName("used" + index);
	Engine.Ent_Fire("used" + index, "addoutput", "itemstate 0");
	Engine.Ent_Fire("used" + index, "kill", "0", "0.5");	
}

int ChooseVolunteer()
{
	int iCount = 0;
	int iVIndex = 0;
	
	array<int> p_VolunteerIndex = {0};
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlrEntity = FindEntityByEntIndex(i);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];
		
		if (pPlrEntity is null)
		{
			continue;
		}
		
		if (pCSZMPlayer.IsVolunteer() && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS && pPlrEntity.IsAlive())
		{
			iCount++;
			p_VolunteerIndex.insertLast(i);
		}
	}
	
	if (iCount != 0)
	{
		int iLength = p_VolunteerIndex.length() - 1;

		if (iLength == 0)
		{
			iVIndex = p_VolunteerIndex[iLength];
		}
		else
		{
			iVIndex = p_VolunteerIndex[Math::RandomInt(1, iLength)];
		}
	}
	
	return iVIndex;
}

int ChooseVictim()
{
	int iCount = 0;
	int iVicIndex = 0;
	int iRND;
	
	array<int> p_VictimIndex = {0};
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlrEntity = FindEntityByEntIndex(i);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];
		
		if (pPlrEntity is null)
		{
			continue;
		}
		
		if (!pCSZMPlayer.WasFirstInfected() && pPlrEntity.IsAlive() && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS && pCSZMPlayer.GetInfectDelay() < 2)
		{
			iCount++;
			p_VictimIndex.insertLast(i);
		}
	}
	
	if (iCount != 0)
	{
		int iLength = int(p_VictimIndex.length() - 1);

		if (iLength > 0)
		{
			iVicIndex = p_VictimIndex[Math::RandomInt(1, iLength)];
		}
		else
		{
			iVicIndex = p_VictimIndex[0];
		}
	}

	if (iCount == 0)
	{
		CZP_Player@ pVictim = GetRandomPlayer(survivor, true);
		CBasePlayer@ pVPlrEnt = pVictim.opCast();
		CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();

		iVicIndex = pVBaseEnt.entindex();
	}
	
	return iVicIndex;
}

void DecideFirstInfected()
{
	int iPlrWereFZ = 0;
	int iPlr = 0;
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];
		
		if (pPlayer is null)
		{
			continue;
		}
		
		iPlr++;

		if (pCSZMPlayer.WasFirstInfected())
		{
			iPlrWereFZ++;
		}
	}
	
	if (iPlrWereFZ >= iPlr)
	{
		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];

			if (pCSZMPlayer !is null)
			{
				pCSZMPlayer.SetFInfectedState(false);
			}
		}
	}

	if (iFZIndex == 0)
	{
		iFZIndex = ChooseVolunteer();

		if (iFZIndex == 0)
		{
			iFZIndex = ChooseVictim();
		}
	}
}

void SetShowTime()
{
	flShowHours = floor(iSeconds / 3600);
	flShowMinutes = floor((iSeconds - flShowHours * 3600) / 60);
	flShowSeconds = floor(iSeconds - (flShowHours * 3600) - (flShowMinutes * 60));
}

void ShowTimer(float &in flHoldTime)
{
	SetShowTime();

	string SZero = "0";
	string MZero = "0";
	
	if (flShowMinutes <= 9)
	{
		MZero = "0";
	}
	else
	{
		MZero = "";
	}
	
	if (flShowSeconds <= 9)
	{
		SZero = "0";
	}
	else
	{
		SZero = "";
	}

	string TimerText = MZero + flShowMinutes + ":" + SZero + flShowSeconds;

	if (flHoldTime <= 0)
	{
		flHoldTime = 1.08f;
	}
	
	SendGameText(any, TimerText, 0, 1, -1, 0, 0, 0, flHoldTime, Color(235, 235, 235), Color(0, 0, 0));
}

void ShowOutbreak(int &in index)
{
	CZP_Player@ pFirstInf = ToZPPlayer(index);
	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

	string strColor = "blue";

	if (pCSZMPlayer.IsVolunteer())
	{
		strColor = "violet";
	}
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if (pPlayer is null)
		{
			continue;
		}
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		
		if (i != index)
		{
			Chat.PrintToChatPlayer(pPlrEnt, "{" + strColor + "}" + pFirstInf.GetPlayerName() + strBecameFi);
		}
	}

	SendGameText(any, strOutbreakMsg, 1, 0, -1, 0.175, 0, 0.35, 6.75, Color(64, 255, 128), Color(0, 255, 0));
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
	while ((@pEntity = FindEntityByClassname(pEntity, "item_deliver")) !is null)
	{
		if (Utils.StringToInt(pEntity.GetEntityName()) == iIndex && Utils.StrContains("iantidote", pEntity.GetEntityName()))
		{
			Engine.Ent_Fire(iIndex + "iantidote", "addoutput", "itemstate " + iAStage);
			break;
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
			int iCustomHealth = int((pEntity.GetHealth() * 0.225) * iPlrCount);

			if (iCustomHealth > PROP_MAX_HEALTH)
			{
				iCustomHealth = PROP_MAX_HEALTH;
			}

			pEntity.SetHealth(iCustomHealth + Math::RandomInt(0, 65));			
		}
	}
}

void SetCustomDoorHealth(CBaseEntity@ pEntity, const int &in iPlrCount)
{
	float flMultiplier = 6.0f;
	if(Utils.StrContains("doormainmetal01", pEntity.GetModelName()))
	{
		flMultiplier = 8.9f;
	}
	else if(Utils.StrContains("doormain01", pEntity.GetModelName()))
	{
		flMultiplier = 9.8f;
	}
	else if(Utils.StrContains("door_zps_wood", pEntity.GetModelName()))
	{
		flMultiplier = 10.5f;
	}
	else if(Utils.StrContains("door_zps_metal", pEntity.GetModelName()))
	{
		flMultiplier = 9.1f;
	}

	Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + int((iPlrCount * flMultiplier) + Math::RandomInt(0, 25)), "0.00");	
}

void SetCustomFuncHealth(CBaseEntity@ pEntity, const int &in iPlrCount)
{
	string strTargetname = pEntity.GetEntityName();

	if (!Utils.StrContains("special", strTargetname))
	{
		pEntity.SetHealth(pEntity.GetHealth() * iPlrCount + Math::RandomInt(0, 75));		
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

void Set_CSZM_ScreenOverlay()
{
	CBaseEntity@ pOverlay = FindEntityByClassname(pOverlay, "env_screenoverlay");
	if (pOverlay is null)
	{
		CEntityData@ ScreenOverlayIPD = EntityCreator::EntityData();
		ScreenOverlayIPD.Add("targetname", "cszm_screenoverlay");
		ScreenOverlayIPD.Add("OverlayName1", "effects/sp_shading.vmf");
		ScreenOverlayIPD.Add("OverlayTime1", "9999");

		CBaseEntity@ pOverlayEntity = EntityCreator::Create("env_screenoverlay", Vector(0, 0, 0), QAngle(0, 0, 0), ScreenOverlayIPD);

		Engine.Ent_Fire_Ent(pOverlayEntity, "StartOverlays");
	}
}

void GiveStartGear(CZP_Player@ pPlayer, const bool bPPK)
{
	int iWTSLength = int(g_strWeaponToStrip.length());
	for (int i = 0; i < iWTSLength; i++)
	{
		if (pPlayer !is null)
		{
			StripWeapon(pPlayer, g_strWeaponToStrip[i]);
		}
	}

	int iSWLength = int(g_strStartWeapons.length());
	string firearm = g_strStartWeapons[Math::RandomInt(0, (iSWLength - 1))];
	string melee = "weapon_barricade";
	int pistol_ammo_count = 30;

	if (bPPK)
	{
		firearm = "weapon_ppk";
		pistol_ammo_count = 7;
	}

	pPlayer.AmmoBank(set, pistol, pistol_ammo_count);
	pPlayer.AmmoBank(add, barricade, 1);
	pPlayer.GiveWeapon(melee);
	pPlayer.GiveWeapon(firearm);
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

void HoldOut()
{
	UnlimitedRandom = true;
	g_strStartWeapons.resize(iStartWeaponLength);
	g_strStartWeapons.insertLast("weapon_mp5");
}