bool bDamageType(int &in iSubjectDT, int &in iDMGNum)
{
	bool bIsDTValid = false;

	if (iSubjectDT & (1<<iDMGNum) == (1<<iDMGNum))
	{
		bIsDTValid = true;
	}

	return bIsDTValid;
}

void GetRandomVictim()
{
	CZP_Player@ pVictim = GetRandomPlayer(survivor, true);
	CBasePlayer@ pVPlrEnt = pVictim.opCast();
	CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();
	TurnToZ(pVBaseEnt.entindex());
}

void DisallowWeakZombie()
{
	bSpawnWeak = false;
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

void AddSpeed(CZP_Player@ pPlayer, int &in iSpeed)
{
	pPlayer.SetMaxSpeed(pPlayer.GetMaxSpeed() + iSpeed);
}

void ClearIntArray(array<int> &iTarget)
{
    while (iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

void ClearFloatArray(array<float> &iTarget)
{
    while (iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

void ClearBoolArray(array<bool> &iTarget)
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

void AttachTrail(CBaseEntity@ pEntity)
{
		CEntityData@ SPRTrailIPD = EntityCreator::EntityData();
		SPRTrailIPD.Add("lifetime", "0.25");
		SPRTrailIPD.Add("renderamt", "255");
		SPRTrailIPD.Add("rendercolor", "245 16 16");
		SPRTrailIPD.Add("rendermode", "5");
		SPRTrailIPD.Add("spritename", "sprites/lgtning.vmt");
		SPRTrailIPD.Add("startwidth", "3.85");

		CEntityData@ SpriteIPD = EntityCreator::EntityData();
		SpriteIPD.Add("spawnflags", "1");
		SpriteIPD.Add("GlowProxySize", "4");
		SpriteIPD.Add("scale", "0.35");
		SpriteIPD.Add("rendermode", "9");
		SpriteIPD.Add("rendercolor", "245 16 16");
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
		DLightIPD.Add("_light", "245 8 8 200");
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

		if (iLength == 1)
		{
			iVIndex = p_VolunteerIndex[1];
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
		int iLength = p_VictimIndex.length() - 1;

		if (iLength > 1)
		{
			iVicIndex = p_VictimIndex[Math::RandomInt(1, iLength)];
		}

		else
		{
			iVicIndex = p_VictimIndex[1];
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
	int iPlrWasFZ = 0;
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
			iPlrWasFZ++;
		}
	}
	
	if (iPlrWasFZ >= iPlr)
	{
		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];

			if (pCSZMPlayer !is null)
			{
				pCSZMPlayer.SetWFirstInfected(false);
			}
		}
	}

	if (iFZIndex == 0)
	{
		iFZIndex = ChooseVolunteer();
	}

	if (iFZIndex == 0)
	{
		iFZIndex = ChooseVictim();
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
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
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

int ObjectPos(const int &in index)
{
	int pos = -1;

	for (uint q = 0; q < PPArray.length(); q++)
	{
		CPhysProp@ pPhysProp = PPArray[q];

		if (pPhysProp !is null)
		{
			if (pPhysProp.GetPropIndex() == index)
			{
				pos = q;
				return pos;
			}
		}
	}

	return pos;
}