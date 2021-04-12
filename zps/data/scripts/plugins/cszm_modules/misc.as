void AutoMap()
{
	Schedule::Task(0.05f, "CSZM_SetScreenOverlay");
	Schedule::Task(0.05f, "CSZM_SetColorCorrection");
}

bool bDamageType(int &in iSubjectDT, int &in iDMGNum)
{
	return iSubjectDT & (1<<iDMGNum) == (1<<iDMGNum);
}

bool LessThanGTZ(float flTime)
{
	return (flTime <= Globals.GetCurrentTime() && flTime != 0);
}

bool LessThanGT(float flTime)
{
	return (flTime <= Globals.GetCurrentTime());
}

float PlusGT(float flTime)
{
	return Globals.GetCurrentTime() + flTime;
}

int DamageToMoney(const int &in nVicHealth, float &in nDamage)
{
	if (nVicHealth < nDamage)
	{
		nDamage = nVicHealth;
	}

	return int(ceil(nDamage * ECO_Damage_Multiplier));
}

int PropHealthToMoney(const int &in nHealth)
{
	return int(ceil(nHealth * ECO_Health_Multiplier));
}

string BoolToString(bool boolean)
{
	return (boolean) ? "true" : "false";
}

int CountPlrs(const int &in iTeamNum)
{
	int iCount = 0;
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() != iTeamNum)
		{
			continue;
		}

		iCount++;
	}
	
	return iCount;
}

void SetDoorFilter(const int &in iFilter)
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "AddOutput", "doorfilter " + formatInt(iFilter));
	}
}

void lobby_hint(CZP_Player@ pPlayer)
{
	string sNextLine = "\n";
	SendGameTextPlayer(pPlayer, strHintF1, 5, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(64, 128, 255), Color(255, 95, 5));
	SendGameTextPlayer(pPlayer, "\n" + strHintF3, 4, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(255, 255, 255), Color(255, 95, 5));
}

void lobby_hint_wu(CZP_Player@ pPlayer)
{
	SendGameTextPlayer(pPlayer, strHintF4WU, 5, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color(64, 255, 128), Color(255, 95, 5));
}

void spec_hint(CZP_Player@ pPlayer)
{
	SendGameTextPlayer(pPlayer, strHintF4, 5, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 15.0f, Color(64, 255, 128), Color(255, 95, 5));
}

void PutPlrToLobby(CBaseEntity@ pEntPlayer)
{
	array<CBaseEntity@> g_pLobbySpawn = {null};
	CBaseEntity@ pEntity = null;
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_commons")) !is null)
	{
		g_pLobbySpawn.insertLast(pEntity);
	}

	int iLength = int(g_pLobbySpawn.length()) - 1;

	if (pEntPlayer is null)
	{
		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

			if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() > TEAM_SPECTATORS)
			{
				continue;
			}

			pPlayerEntity.SetAbsOrigin(g_pLobbySpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
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
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_start")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}

	int iLength = int(g_pOtherSpawn.length()) - 1;
	
	if (iLength > 0)
	{
		if (pEntPlayer is null)
		{
			for (int i = 1; i <= iMaxPlayers; i++)
			{
				CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);
				
				if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() > TEAM_SPECTATORS)
				{
					continue;
				}
				
				pPlayerEntity.SetAbsOrigin(g_pOtherSpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
			}
		}
		else
		{
			pEntPlayer.SetAbsOrigin(g_pOtherSpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
		}
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
	Engine.Ent_Fire("used" + formatInt(index), "addoutput", "itemstate 0");
	Engine.Ent_Fire("used" + formatInt(index), "kill", "0", "0.5");	
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
		Engine.EmitSoundPosition(pBaseEnt.entindex(), ")impacts/flesh_impact_headshot-01.wav", pBaseEnt.EyePosition(), 0.985f, 70, Math::RandomInt(85, 100));
		Engine.EmitSoundPosition(pBaseEnt.entindex(), g_strBloodSND[Math::RandomInt(0, g_strBloodSND.length() - 1)], pBaseEnt.EyePosition(), 1.0f, 65, Math::RandomInt(95, 115));
	}
}

void RegisterEntities()
{
	Entities::RegisterPickup("item_deliver");
	Entities::RegisterUse("item_deliver");
	Entities::RegisterDrop("item_deliver");
	Entities::RegisterUse("item_money");
	Entities::RegisterOutput("OnUser1", "info_beacon");
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
	if (!(bIsPropJunk(pEntity) || bIsPropExplosive(pEntity)))
	{
		SetCustomHealth(pEntity, iPlrCount, flPropHPPercent);
	}
}

void SetCustomFuncHealth(CBaseEntity@ pEntity, const int &in iPlrCount)
{
	if (!Utils.StrContains("special", pEntity.GetEntityName()))
	{
		SetCustomHealth(pEntity, iPlrCount, flBrushHPPercent);
	}
}

void SetCustomDoorHealth(CBaseEntity@ pEntity, const int &in iPlrCount)
{
	CBasePropDoor@ pDoor = ToBasePropDoor(pEntity);
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

	int NewHealth = int((iPlrCount * flMultiplier) + Math::RandomInt(0, 25));

	pEntity.SetMaxHealth(NewHealth);
	pEntity.SetHealth(NewHealth);
	pDoor.SetDoorHealth(NewHealth);
}

void SetCustomHealth(CBaseEntity@ pEntity, const int &in iPlrCount, const float &in flBaseHealthMult)
{
	int iCustomHealth = int((pEntity.GetHealth() * flBaseHealthMult) * iPlrCount) + Math::RandomInt(0, 35);

	pEntity.SetHealth(iCustomHealth);
	pEntity.SetMaxHealth(iCustomHealth);
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

void CSZM_SetColorCorrection()
{
	CBaseEntity@ pColor = FindEntityByClassname(pColor, "color_correction");
	if (pColor is null)
	{
		CEntityData@ ColorCorrection = EntityCreator::EntityData();
		ColorCorrection.Add("targetname", "cszm_colorcorrection");
		ColorCorrection.Add("fadeInDuration", "0.01");
		ColorCorrection.Add("fadeOutDuration", "0.01");
		ColorCorrection.Add("filename", "materials/cc_zombiemod.raw");
		ColorCorrection.Add("maxfalloff", "-1");
		ColorCorrection.Add("maxweight", "0.25");
		ColorCorrection.Add("minfalloff", "0");
		ColorCorrection.Add("StartDisabled", "0");
		ColorCorrection.Add("Enable", "0", true);

		EntityCreator::Create("color_correction", Vector(0, 0, 0), QAngle(0, 0, 0), ColorCorrection);
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
	
	pL_Eye.SetEntityName(pPlayerEntity.entindex() + "_lefteye");
	pR_Eye.SetEntityName(pPlayerEntity.entindex() + "_righreye");
	
	pL_Eye.SetParent(pPlayerEntity);
	pR_Eye.SetParent(pPlayerEntity);
	
	pL_Eye.SetParentAttachment("lefteye", false);
	pR_Eye.SetParentAttachment("righteye", false);
}

void DetachEyesLights(CBaseEntity@ pPlayerEntity)
{
	pPlayerEntity.SetBodyGroup("eyesglow", 0);
	pPlayerEntity.SetSkin(0);

	CBaseEntity@ pR_Eye = FindEntityByName(null, formatInt(pPlayerEntity.entindex()) + "_righreye");
	CBaseEntity@ pL_Eye = FindEntityByName(null, formatInt(pPlayerEntity.entindex()) + "_lefteye");

	if (pR_Eye !is null)
	{
		pR_Eye.SUB_Remove();
	}
	
	if (pL_Eye !is null)
	{
		pL_Eye.SUB_Remove();
	}
}

void ApplyVictoryRewards(RoundWinState iWinState)
{
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null)
		{
			continue;
		}

		if (pPlayerEntity.GetTeamNumber() < TEAM_SURVIVORS)
		{
			continue;
		}

		CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[i];
		int Team = pPlayerEntity.GetTeamNumber();

		if (iWinState == STATE_HUMAN)
		{
			if (Team >= TEAM_SURVIVORS)
			{
				pCSZMPlayer.AddInfectPoints(-5);
			}

			if (Team == TEAM_SURVIVORS)
			{
				pCSZMPlayer.AddMoney(ECO_Human_Win);
			}
			else if (Team == TEAM_ZOMBIES)
			{
				pCSZMPlayer.AddMoney(ECO_Lose);
				Chat.PrintToChatPlayer(ToBasePlayer(i), "{red}" + formatInt(ECO_Lose) + "$ {gold}За поражение в раунде!");
				pPlayerEntity.TakeDamage(CTakeDamageInfo(pPlayerEntity, pPlayerEntity, float(pPlayerEntity.GetHealth() + 315.0f), 1));
			}
		}
		else if (iWinState == STATE_ZOMBIE)
		{
			if (Team == TEAM_SURVIVORS)
			{
				pCSZMPlayer.AddInfectPoints(5);
				pCSZMPlayer.AddMoney(ECO_Human_Last);
			}
			else if (Team == TEAM_ZOMBIES)
			{
				pCSZMPlayer.AddInfectPoints(-15);
				pCSZMPlayer.AddMoney(ECO_Zombie_Win);

				if (pCSZMPlayer.FirstInfected)
				{
					pCSZMPlayer.AddMoney(ECO_Zombie_Win * 2);
				}
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

int CheckSteamID(const string &in STR_STEAM)
{
	int iArrayElement = -1;

	for (uint i = 0; i < Array_SteamID.length(); i++)
	{
		if (Utils.StrEql(STR_STEAM, Array_SteamID[i][0], true))
		{
			iArrayElement = i;
			break;
		}
	}

	return iArrayElement;
}

void LogicPlayerManager()
{
	CBaseEntity@ pPlrManager = null;
	@pPlrManager = FindEntityByClassname(pPlrManager, "logic_player_manager");

	if (pPlrManager !is null)
	{
		pPlrManager.SUB_Remove();
	}

	CEntityData@ InputData = EntityCreator::EntityData();
	InputData.Add("targetname", "p-manager");
	InputData.Add("spawnflags", "1");
	InputData.Add("stripstarterweapons", "1");

	EntityCreator::Create("logic_player_manager", Vector(0, 0, 0), QAngle(0, 0, 0) , InputData);
}

void ShootTracers(Vector Orinig)
{
	int iFree;
	int iUsed;

	Engine.EdictCount(iFree, iUsed);

	int iShowerCount = Math::RandomInt(1, 3);
	int iTracerCount = Math::RandomInt(18, 27);

	if (iUsed > 1964)
	{
		iShowerCount = 1;
		iTracerCount = -1;
	}

	while (iShowerCount > 0)
	{
		iShowerCount--;
		CBaseEntity@ pShower = EntityCreator::Create("spark_shower", Orinig, QAngle(0, 0, 0));
		Vector vUP;
		Globals.AngleVectors(QAngle(Math::RandomFloat(-55, -78), Math::RandomFloat(0, 270), Math::RandomFloat(0, 270)), vUP);
		pShower.SetAbsVelocity(vUP * Math::RandomInt(247, 389));
	}

	while (iTracerCount > 0)
	{
		iTracerCount--;
		CEntityData@ TracerIPD = EntityCreator::EntityData();
		TracerIPD.Add("rendercolor", "255 155 5");
		TracerIPD.Add("rendermode", "5");
		TracerIPD.Add("spritename", "sprites/xbeam2.vmt");
		TracerIPD.Add("endwidth", formatFloat(Math::RandomFloat(0.21, 0.37), 'l', 3, 3));
		TracerIPD.Add("lifetime", formatFloat(Math::RandomFloat(0.032, 0.135), 'l', 3, 3));
		TracerIPD.Add("renderamt", formatInt(Math::RandomInt(195, 235)));
		TracerIPD.Add("startwidth", formatFloat(Math::RandomFloat(1.85, 2.85), 'l', 2, 2));
		TracerIPD.Add("kill", "0", true, formatFloat(Math::RandomFloat(0.194, 0.842), 'l', 2, 2));

		CBaseEntity@ pTracer = EntityCreator::Create("env_spritetrail", Orinig, QAngle(0, 0, 0), TracerIPD);

		Vector vUP;
		pTracer.SetMoveType(MOVETYPE_FLYGRAVITY);
		Globals.AngleVectors(QAngle(Math::RandomFloat(0, 360), Math::RandomFloat(0, 360), Math::RandomFloat(0, 360)), vUP);
		pTracer.SetAbsVelocity(vUP * Math::RandomInt(2900, 2999));
	}
}

void ShowHitMarker(const int &in PlayerIndex, const int &in ColorIndex)
{
	CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

	array<Vector> HitColor =
	{
		Vector(255, 255, 255),
		Vector(0, 155, 255),
		Vector(255, 75, 75)
	};

	Color nColor = Color(int(HitColor[ColorIndex].x), int(HitColor[ColorIndex].y), int(HitColor[ColorIndex].z));

	HudTextParams pParams;
	pParams.x = -1;
	pParams.y = -1;
	pParams.channel = 1;
	pParams.fadeinTime = 0.0f;
	pParams.fadeoutTime = 0.2f;
	pParams.holdTime = 0.075f;
	pParams.fxTime = 0.0f;
	pParams.SetColor(nColor);
	pParams.SetColor2(nColor);
	Utils.GameTextPlayer(pPlayer, "+", pParams);
}

namespace NPZ
{
	void DLight(CBaseEntity@ pPlayerEntity, const int &in index)
	{
		CBaseEntity@ pPlrDlight = FindEntityByName(null, (formatInt(index) + "dlight_origin"));

		Engine.EmitSoundEntity(pPlayerEntity, "Buttons.snd14");

		if (pPlrDlight !is null)
		{
			pPlrDlight.SUB_Remove();
		}
		else
		{
			CEntityData@ PropDynamicIPD = EntityCreator::EntityData();

			PropDynamicIPD.Add("targetname", formatInt(index) + "dlight_origin");
			PropDynamicIPD.Add("disableshadows", "1");
			PropDynamicIPD.Add("solid", "0");
			PropDynamicIPD.Add("DisableBoneFollowers", "1");
			PropDynamicIPD.Add("spawnflags", "256");
			PropDynamicIPD.Add("model", "models/props_junk/popcan01a.mdl");
			PropDynamicIPD.Add("modelscale", "0.25");
			PropDynamicIPD.Add("DefaultAnim", "idle");
			PropDynamicIPD.Add("Effects", "18");	//2
			PropDynamicIPD.Add("rendermode", "10");
			PropDynamicIPD.Add("health", "0");
			PropDynamicIPD.Add("fademindist", "1");
			PropDynamicIPD.Add("fademaxdist", "2");

			CBaseEntity@ pDlight = EntityCreator::Create("prop_dynamic_override", pPlayerEntity.GetAbsOrigin(), pPlayerEntity.GetAbsAngles(), PropDynamicIPD);

			pDlight.SetParent(pPlayerEntity);
			pDlight.SetParentAttachment("anim_attachment_LH", false);
		}
	}

	void GiveThrowable(CZP_Player@ pPlayer, const string &in strClassname)
	{
		CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();
		string strCurWepClassname = pWeapon.GetClassname();

		if (Utils.StrEql("weapon_emptyhand", strCurWepClassname))
		{
			pPlayer.GiveWeapon(strClassname);
		}
		else if (Utils.StrEql(strClassname, strCurWepClassname))
		{
			StripWeapon(pPlayer, strCurWepClassname);
		}
		else
		{
			StripWeapon(pPlayer, pWeapon.GetClassname());
			pPlayer.GiveWeapon(strClassname);
		}
	}

	bool SetFirefly(CBaseEntity@ pPlayerEntity, const int &in iIndex, int &in iR, int &in iG, int &in iB)
	{
		if (!RoundManager.IsRoundOngoing(false) || pPlayerEntity.GetTeamNumber() > TEAM_SPECTATORS)
		{
			Chat.PrintToChatPlayer(ToBasePlayer(iIndex), "{red}*{gold}Сейчас нельзя это сделать!");
			return false;
		}

		if ((iR + iG + iB) < 48)
		{
			iR = Math::RandomInt(16, 255);
			iG = Math::RandomInt(16, 255);
			iB = Math::RandomInt(16, 255);
		}

		string SNDFile = "ZPlayer.AmmoPickup";
		CBaseEntity@ pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");
		CBaseEntity@ pTrailEnt = FindEntityByName(pTrailEnt, iIndex + "firefly_trail");

		if (pSpriteEnt !is null && pTrailEnt !is null)
		{
			Engine.Ent_Fire_Ent(pSpriteEnt, "color", "" + formatInt(iR) + " " + formatInt(iG) + " " + formatInt(iB));
			Engine.Ent_Fire_Ent(pTrailEnt, "color", "" + formatInt(iR) + " " + formatInt(iG) + " " + formatInt(iB));
			Chat.PrintToChatPlayer(ToBasePlayer(iIndex), "{green}*{gold}Цвет светлячка изменён на {white}[ {red}"+formatInt(iR)+" {green}"+formatInt(iG)+" {blue}"+formatInt(iB)+" {white}]");
		}
		else
		{
			if (pPlayerEntity.GetTeamNumber() != TEAM_SPECTATORS)
			{
				pPlayerEntity.ChangeTeam(TEAM_LOBBYGUYS);
				ToZPPlayer(iIndex).ConsoleCommand("choose3");
			}

			CEntityData@ FFSpriteIPD = EntityCreator::EntityData();
			CEntityData@ FFTrailIPD = EntityCreator::EntityData();

			FFSpriteIPD.Add("targetname", formatInt(iIndex) + "firefly_sprite");
			FFSpriteIPD.Add("model", "sprites/light_glow01.vmt");
			FFSpriteIPD.Add("rendercolor", formatInt(iR) + " " + formatInt(iG) + " " + formatInt(iB));
			FFSpriteIPD.Add("rendermode", "5");
			FFSpriteIPD.Add("renderamt", "240");
			FFSpriteIPD.Add("scale", "0.25");
			FFSpriteIPD.Add("spawnflags", "1");
			FFSpriteIPD.Add("framerate", "0");

			FFTrailIPD.Add("targetname", formatInt(iIndex) + "firefly_trail");
			FFTrailIPD.Add("endwidth", "12");
			FFTrailIPD.Add("lifetime", "0.145");
			FFTrailIPD.Add("rendercolor", formatInt(iR) + " " + formatInt(iG) + " " + formatInt(iB));
			FFTrailIPD.Add("rendermode", "5");
			FFTrailIPD.Add("renderamt", "84");
			FFTrailIPD.Add("spritename", "sprites/xbeam2.vmt");
			FFTrailIPD.Add("startwidth", "3");

			EntityCreator::Create("env_spritetrail", pPlayerEntity.GetAbsOrigin(), pPlayerEntity.GetAbsAngles(), FFTrailIPD);
			EntityCreator::Create("env_sprite", pPlayerEntity.GetAbsOrigin(), pPlayerEntity.GetAbsAngles(), FFSpriteIPD);

			@pSpriteEnt = FindEntityByName(pSpriteEnt, formatInt(iIndex) + "firefly_sprite");
			@pTrailEnt = FindEntityByName(pTrailEnt, formatInt(iIndex) + "firefly_trail");

			pTrailEnt.SetParent(pSpriteEnt);
			pSpriteEnt.SetParent(pPlayerEntity);
			SNDFile = "Player.PickupWeapon";
			Chat.PrintToChatPlayer(ToBasePlayer(iIndex), "{green}*{gold}Вы стали светлячком. Цвет в RGB {white}[ {red}"+formatInt(iR)+" {green}"+formatInt(iG)+" {blue}"+formatInt(iB)+" {white}]");
		}

		Engine.EmitSoundPosition(iIndex, SNDFile, pPlayerEntity.GetAbsOrigin(), 0.75F, 80, 105);
		return true;
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
}