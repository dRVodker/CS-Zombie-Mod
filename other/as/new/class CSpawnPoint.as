array<CSpawnPoint@> Array_SPoint;

class CSpawnPoint
{
	int EntIndex;
	private string Targetname;
	private bool IsEnabled;

	CSpawnPoint(CBaseEntity@ pSpawnEnt, const int nIndex)
	{
		Targetname = "spawnpoint_" + formatInt(nIndex);
		pSpawnEnt.SetEntityName(Targetname);
		EntIndex = pSpawnEnt.entindex();
		EnabelSpawn();
	}

	private void EnabelSpawn()
	{
		if (!IsEnabled)
		{
			IsEnabled = true;
			Engine.Ent_Fire(Targetname, "EnableSpawn", "", "0.00");		
		}
	}

	private void DisableSpawn()
	{
		if (IsEnabled)
		{
			IsEnabled = false;
			Engine.Ent_Fire(Targetname, "DisableSpawn", "", "0.00");			
		}
	}

	void Think()
	{
		float LockDist = 512.0f;
		CBaseEntity@ pSpawnEnt = FindEntityByEntIndex(EntIndex);
		int State = 0;

		if (!Utils.StrEql(pSpawnEnt.GetEntityName(), Targetname, true))
		{
			for (uint u = 0; u < Array_SPoint.length(); u++)
			{
				if (Array_SPoint[u].EntIndex == pSpawnEnt.entindex())
				{
					Array_SPoint.removeAt(u);
					return;
				}
			}
		}

		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

			if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() != TEAM_SURVIVORS)
			{
				continue;
			}

			if (pPlayerEntity.Distance(pSpawnEnt.GetAbsOrigin()) > LockDist)
			{
				if (State < 1)
				{
					State = 1;
				}
			}

			if (pPlayerEntity.Distance(pSpawnEnt.GetAbsOrigin()) <= LockDist)
			{
				if (!pPlayerEntity.IsAlive())
				{
					if (State < 1)
					{
						State = 1;
					}
				}
				else
				{
					State = 2;	
				}
			}
		}	

		switch(State)
		{
			case 1: EnabelSpawn(); break;
			case 2: DisableSpawn(); break;
		}
	}
}

void FindSpawnPoints()
{
	Array_SPoint.removeRange(0, Array_SPoint.length());

	int iNum = 0;
	CBaseEntity@ pSPoint = null;
	while ((@pSPoint = FindEntityByClassname(pSPoint, "info_player_zombie")) !is null)
	{
		iNum++;
		Array_SPoint.insertLast(CSpawnPoint(pSPoint, iNum));
	}
}