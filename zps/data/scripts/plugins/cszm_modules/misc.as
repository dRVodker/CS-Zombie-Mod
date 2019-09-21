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
	pEntPlr.ChangeTeam(0);
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
			
			if (pBaseEnt.GetTeamNumber() == 1 || pBaseEnt.GetTeamNumber() == 0)
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
			
			if (pBaseEnt.GetTeamNumber() == 1 || pBaseEnt.GetTeamNumber() == 0)
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