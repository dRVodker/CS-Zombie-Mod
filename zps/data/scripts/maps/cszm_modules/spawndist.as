/*----------------------------------------------------------------------------------*/

const int SS_DISABLED = 0;
const int SS_ENABLED = 1;
const float WAIT_TIME = 0.25f;

/*----------------------------------------------------------------------------------*/

float flMaxZSDist = 1024.0f;
float flMinZSDist = 512.0f;

/*----------------------------------------------------------------------------------*/

CZSpawnManager@ ZSpawnManager = null;

/*----------------------------------------------------------------------------------*/

bool bIsValidPlayer(CBaseEntity@ pPlayerEntity)
{
	bool b = true;

	if (pPlayerEntity is null)
	{
		b = false;
	}

	else if (!pPlayerEntity.IsPlayer())
	{
		b = false;
	}

	else if (pPlayerEntity.GetTeamNumber() != 2)
	{
		b = false;
	}

	return b;
}

bool bIsZombieSpawn(CBaseEntity@ pEntity)
{
	bool b = false;

	if (pEntity is null)
	{
		return b;
	}

	if (Utils.StrEql("info_player_zombie", pEntity.GetClassname()))
	{
		b = true;
	}

	return b;
}

/*----------------------------------------------------------------------------------*/

class CZSpawnManager
{
	float flThinkTime;
	int ilength;
	array<int> p_SpawnEntIndex;
	int iSpawnCount;
	int iLastSpawn;

	CZSpawnManager()
	{
		flThinkTime = Globals.GetCurrentTime() + WAIT_TIME;
		CBaseEntity@ pSpawn = null;
		iSpawnCount = 0;

		int iZSCount = 0;

		while ((@pSpawn = FindEntityByClassname(pSpawn, "info_player_zombie")) !is null)
		{
			iZSCount++;
			pSpawn.SetEntityName("ZSpawn" + iZSCount);

			Engine.Ent_Fire_Ent(pSpawn, "AddOutput", "minspawns 0");
			Engine.Ent_Fire_Ent(pSpawn, "AddOutput", "mintime 0");

			Engine.Ent_Fire_Ent(pSpawn, "EnableSpawn");

			pSpawn.SetEntityDescription("enabled");

			p_SpawnEntIndex.insertLast(pSpawn.entindex());
		}

		ilength = int(p_SpawnEntIndex.length());
	}

	void Think()
	{

		if (flThinkTime <= Globals.GetCurrentTime() && flThinkTime != -1)
		{
			flThinkTime = Globals.GetCurrentTime() + WAIT_TIME;

			for (int i = 0; i < ilength; i++)
			{
				CBaseEntity@ pSpawn = FindEntityByEntIndex(p_SpawnEntIndex[i]);

				if (!bIsZombieSpawn(pSpawn))
				{
					this.UpdateArrays();
					break;
				}

				int iState = CheckSpawn(pSpawn);

				if (iState == SS_ENABLED)
				{
					this.EnableSpawn(pSpawn);
				}

				else
				{
					this.DisableSpawn(pSpawn);
				}
			}
		}
	}

	int CheckSpawn(CBaseEntity@ pSpawn)
	{
		int iState = SS_DISABLED;

		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

			if (!bIsValidPlayer(pPlayerEntity))
			{
				continue;
			}

			Vector PlrOrigin = pPlayerEntity.GetAbsOrigin();

			if (pSpawn.Distance(PlrOrigin) < flMaxZSDist && pSpawn.Distance(PlrOrigin) > flMinZSDist)
			{
				iState = SS_ENABLED;
			}

			else if (pSpawn.Distance(PlrOrigin) < flMinZSDist)
			{
				iState = SS_DISABLED;
			}
		}

		return iState;
	}

	void DisableSpawn(CBaseEntity@ pSpawn)
	{
		if (bIsZombieSpawn(pSpawn))
		{
			string EntDesc = pSpawn.GetEntityDescription();

			if (Utils.StrEql("enabled", EntDesc))
			{
				iSpawnCount++;

				if (iSpawnCount == ilength)
				{
					iLastSpawn = pSpawn.entindex();	
				}

				else
				{
					Engine.Ent_Fire_Ent(pSpawn, "DisableSpawn");					
				}	

				pSpawn.SetEntityDescription("disabled");	
			}
		}
	}

	void EnableSpawn(CBaseEntity@ pSpawn)
	{
		if (bIsZombieSpawn(pSpawn))
		{
			string EntDesc = pSpawn.GetEntityDescription();

			if (Utils.StrEql("disabled", EntDesc))
			{
				iSpawnCount--;
				pSpawn.SetEntityDescription("enabled");
				Engine.Ent_Fire_Ent(pSpawn, "EnableSpawn");	
			}

			if (iLastSpawn != 0)
			{
				if (pSpawn.entindex() != iLastSpawn)
				{
					CBaseEntity@ pLastSpawn = FindEntityByEntIndex(iLastSpawn);
					pLastSpawn.SetEntityDescription("disabled");
					Engine.Ent_Fire_Ent(pLastSpawn, "DisableSpawn");					
				}

				iLastSpawn = 0;
			}
		}
	}

	void UpdateArrays()
	{
		SD("{red}-=UpdateArrays=-");

		p_SpawnEntIndex.resize(0);
		CBaseEntity@ pSpawn = null;

		while ((@pSpawn = FindEntityByClassname(pSpawn, "info_player_zombie")) !is null)
		{
			string strState = pSpawn.GetEntityDescription();
			int iState = SS_ENABLED;

			if (Utils.StrEql("disabled", strState))
			{
				iState = SS_DISABLED;
				Engine.Ent_Fire_Ent(pSpawn, "DisableSpawn");
			}

			else
			{
				pSpawn.SetEntityDescription("enabled");	
				Engine.Ent_Fire_Ent(pSpawn, "EnableSpawn");			
			}

			p_SpawnEntIndex.insertLast(pSpawn.entindex());
		}

		ilength = int(p_SpawnEntIndex.length());
	}
}

/*----------------------------------------------------------------------------------*/