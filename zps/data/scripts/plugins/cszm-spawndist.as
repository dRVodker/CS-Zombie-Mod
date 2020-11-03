//------------------------------------------------------------------------------------------------------------------------------
//DATA
//------------------------------------------------------------------------------------------------------------------------------

enum SDM_States {ST_DISABLED = 0, ST_ENABLED}
const float SDM_BlockDistance = 950.0f;

int iMaxPlayers;
bool bIsCSZM;

CNetworked@ pNetworked = Network::Create("cszm_spawnsist", false);
CSpawnDistanceManager@ gSDManager = null;

//------------------------------------------------------------------------------------------------------------------------------
//Plugin Initialization
//------------------------------------------------------------------------------------------------------------------------------

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Spawn Dist");

	pNetworked.Save("distvalue", SDM_BlockDistance);
	pNetworked.Save("updatespawn", false);

	OnMapInit();
}

//------------------------------------------------------------------------------------------------------------------------------
//Booleans
//------------------------------------------------------------------------------------------------------------------------------

bool IsValidSpawn(CBaseEntity@ pSpawn)
{
	return (pSpawn !is null && Utils.StrEql("info_player_human", pSpawn.GetClassname(), true));
}

bool IsValidPlayer(CBaseEntity@ pPlayerEntity)
{
	return (pPlayerEntity !is null && pPlayerEntity.IsPlayer() && pPlayerEntity.IsAlive() && pPlayerEntity.GetTeamNumber() == 2);
}

//------------------------------------------------------------------------------------------------------------------------------
//Debug
//------------------------------------------------------------------------------------------------------------------------------

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

//------------------------------------------------------------------------------------------------------------------------------
//Forwards
//------------------------------------------------------------------------------------------------------------------------------

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
		iMaxPlayers = Globals.GetMaxClients();
	}
}

void OnInfectedTurns(NetObject@ pData)
{
	@gSDManager = CSpawnDistanceManager();
}

void OnMatchEnded()
{
	if (bIsCSZM)
	{
		@gSDManager = null;
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		@gSDManager = null;
		bIsCSZM = false;

		ResetSpawnDist();
	}
}

void OnProcessRound()
{
	if (bIsCSZM && gSDManager !is null)
	{
		gSDManager.Think();
	}
}

//------------------------------------------------------------------------------------------------------------------------------
//Reset Spawn Distance
//------------------------------------------------------------------------------------------------------------------------------

void ResetSpawnDist()
{
	if (pNetworked.GetFloat("distvalue") != SDM_BlockDistance)
	{
		pNetworked.Save("distvalue", SDM_BlockDistance);
	}
}

//------------------------------------------------------------------------------------------------------------------------------
//Spawn Distance Manager
//------------------------------------------------------------------------------------------------------------------------------

class CSpawnDistanceManager
{
	private array<int> SDM_EntIndex;
	private float SDM_ThinkTime;
	private int SDM_Length;
	private int SDM_DisabledCount;

	CSpawnDistanceManager()
	{
		SDM_DisabledCount = 0;
		UpdateArray();
	}

	void Think()
	{
		if (SDM_ThinkTime <= Globals.GetCurrentTime() && SDM_ThinkTime != 0)
		{
			SDM_ThinkTime = 0;

			if (pNetworked.GetBool("updatespawn"))
			{
				pNetworked.Save("updatespawn", false);
				UpdateArray();
				return;
			}

			for (int i = 0; i < SDM_Length; i++)
			{
				CBaseEntity@ pSpawn = FindEntityByEntIndex(SDM_EntIndex[i]);

				if (!IsValidSpawn(pSpawn))
				{
					SDM_ThinkTime = 0;
					UpdateArray();
					break;
				}

				CheckDist(pSpawn) == ST_ENABLED ? EnableSpawn(pSpawn) : DisableSpawn(pSpawn);
			}

			StartThinking();
		}
	}

	private int CheckDist(CBaseEntity@ pSpawn)
	{
		int iSpawnState = ST_ENABLED;

		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

			if (!IsValidPlayer(pPlayerEntity))
			{
				continue;
			}

			Vector PlayerOrigin = Vector(pPlayerEntity.GetAbsOrigin().x, pPlayerEntity.GetAbsOrigin().y, 0);
			Vector SpawnOrigin = Vector(pSpawn.GetAbsOrigin().x, pSpawn.GetAbsOrigin().y, 0);

			if (Globals.Distance(PlayerOrigin, SpawnOrigin) < pNetworked.GetFloat("distvalue"))
			{
				iSpawnState = ST_DISABLED;
			}
		}

		return iSpawnState;
	}

	private void EnableSpawn(CBaseEntity@ pSpawn)
	{
		if (IsValidSpawn(pSpawn) && Utils.StrEql("enabled", pSpawn.GetEntityDescription(), true))
		{
			return;
		}

		SDM_DisabledCount--;
		pSpawn.SetEntityDescription("enabled");
		Engine.Ent_Fire_Ent(pSpawn, "enablespawn");
	}

	private void DisableSpawn(CBaseEntity@ pSpawn)
	{
		if ((IsValidSpawn(pSpawn) && Utils.StrEql("disabled", pSpawn.GetEntityDescription(), true)) || (SDM_DisabledCount + 5 >= SDM_Length))
		{
			return;
		}

		SDM_DisabledCount++;
		pSpawn.SetEntityDescription("disabled");
		Engine.Ent_Fire_Ent(pSpawn, "disablespawn");
	}

	private void UpdateArray()
	{
		if (SDM_Length > 0)
		{
			SDM_EntIndex.resize(0);
		}

		CBaseEntity@ pSpawn = null;
		while ((@pSpawn = FindEntityByClassname(pSpawn, "info_player_human")) !is null)
		{
			SDM_EntIndex.insertLast(pSpawn.entindex());
		}

		SDM_Length = int(SDM_EntIndex.length());
		StartThinking();
	}

	private void StartThinking()
	{
		SDM_ThinkTime = Globals.GetCurrentTime() + 0.15f;
	}
}