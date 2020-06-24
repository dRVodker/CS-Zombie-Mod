/*----------------------------------------------------------------------------------*/

const int SS_DISABLED = 0;
const int SS_ENABLED = 1;
const float WAIT_TIME = 0.25f;

/*----------------------------------------------------------------------------------*/

float flMaxZSDist = 1024.0f;
float flMinZSDist = 512.0f;
float flRoarDist = 512.0f;

/*----------------------------------------------------------------------------------*/

CZSpawnManager@ ZSpawnManager = null;

/*----------------------------------------------------------------------------------*/

class CZSpawnManager
{
	private array<int> p_SpawnEntIndex;
	private float flThinkTime;
	private int ilength;
	private int iDisZSpawn;
	private int iLastSpawn;

	CZSpawnManager()
	{
		flThinkTime = Globals.GetCurrentTime() + WAIT_TIME;
		CBaseEntity@ pSpawn = null;
		iDisZSpawn = 0;
		ilength = 0;

		this.UpdateArrays();
	}

	void Think()
	{
		if (flThinkTime <= Globals.GetCurrentTime() && flThinkTime != -1)
		{
			flThinkTime = Globals.GetCurrentTime() + WAIT_TIME;

			for (int i = 0; i < ilength; i++)
			{
				CBaseEntity@ pSpawn = FindEntityByEntIndex(p_SpawnEntIndex[i]);

				if (!this.IsZombieSpawn(pSpawn))
				{
					this.UpdateArrays();
					break;
				}

				int iState = this.CheckSpawn(pSpawn);
				
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

	private int CheckSpawn(CBaseEntity@ pSpawn)
	{
		int iState = SS_DISABLED;

		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

			if (!this.IsValidPlayer(pPlayerEntity))
			{
				continue;
			}

			Vector PlrOrigin = pPlayerEntity.GetAbsOrigin();
			float flDistance = pSpawn.Distance(PlrOrigin);

			if (flDistance < flRoarDist && pPlayerEntity.GetTeamNumber() == 3)
			{
				iState = SS_ENABLED;
			}

			else if (flDistance < flMaxZSDist && flDistance > flMinZSDist)
			{
				iState = SS_ENABLED;
			}

			else if (flDistance < flMinZSDist)
			{
				iState = SS_DISABLED;
			}
		}

		return iState;
	}

	private void DisableSpawn(CBaseEntity@ pSpawn)
	{
		if (!this.IsZombieSpawn(pSpawn))
		{
			return;
		}

		if (Utils.StrEql("enabled", pSpawn.GetEntityDescription()))
		{
			iDisZSpawn++;

			if (iDisZSpawn == ilength)
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

	private void EnableSpawn(CBaseEntity@ pSpawn)
	{
		if (!this.IsZombieSpawn(pSpawn))
		{
			return;
		}

		if (Utils.StrEql("disabled", pSpawn.GetEntityDescription()))
		{
			iDisZSpawn--;
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

	private void UpdateArrays()
	{
		if (ilength > 0)
		{
			p_SpawnEntIndex.resize(0);
		}

		CBaseEntity@ pSpawn = null;

		while ((@pSpawn = FindEntityByClassname(pSpawn, "info_player_zombie")) !is null)
		{
			if (!Utils.StrEql("disabled", pSpawn.GetEntityDescription()))
			{
				if (!Utils.StrEql("enabled", pSpawn.GetEntityDescription()))
				{
					Engine.Ent_Fire_Ent(pSpawn, "AddOutput", "minspawns 0");
					Engine.Ent_Fire_Ent(pSpawn, "AddOutput", "mintime 0");
				}

				pSpawn.SetEntityDescription("enabled");	
				Engine.Ent_Fire_Ent(pSpawn, "EnableSpawn");			
			}

			p_SpawnEntIndex.insertLast(pSpawn.entindex());
		}

		ilength = int(p_SpawnEntIndex.length());
	}

	private bool IsValidPlayer(CBaseEntity@ pPlayerEntity)
	{
		bool b = false;
		CZP_Player@ pPlayer =  ToZPPlayer(pPlayerEntity);

		if (pPlayerEntity !is null && pPlayerEntity.IsAlive())
		{
			b = pPlayerEntity.GetTeamNumber() == 2 || (pPlayerEntity.GetTeamNumber() == 3 && pPlayer.IsRoaring());
		}

		return b;
	}

	private bool IsZombieSpawn(CBaseEntity@ pEntity)
	{
		bool b = false;

		if (pEntity !is null && Utils.StrEql("info_player_zombie", pEntity.GetClassname()))
		{
			b = true;
		}

		return b;
	}
}

/*----------------------------------------------------------------------------------*/