//some data
int iMaxPlayers;
bool bIsCSZM = false;

array<int> g_iEntIndex;
array<int> g_iPropHP;

array<string> g_strEntities = 
{
	"prop_door_rotating", //0
	"prop_physics_multiplayer", //1
	"prop_physics_override", //2
	"prop_physics", //3
	"func_door_rotating", //4
	"func_door", //5
	"func_breakable", //6
	"func_physbox", //7
	"prop_barricade" //8
};

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Show HP of Breakables" );

	//Events
	Events::Player::OnPlayerConnected.Hook(@OnPlayerConnected);
}

void OnMapInit()
{	
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{	
		bIsCSZM = true;
		iMaxPlayers = Globals.GetMaxClients();
		
		g_iPropHP.resize(iMaxPlayers + 1);
		g_iEntIndex.resize(iMaxPlayers + 1);

		//Entities
		RegisterDamaged();
	}
}

void OnMapShutdown()
{
	if(bIsCSZM == true)
	{
		bIsCSZM = false;

		RemoveRegisterDamaged();
	}
}

void RegisterDamaged()
{
	for(uint i = 0; i <= g_strEntities.length(); i++)
	{
		Entities::RegisterDamaged(g_strEntities[i]);
	}
}

void RemoveRegisterDamaged()
{
	for(uint i = 0; i <= g_strEntities.length(); i++)
	{
		Entities::RemoveRegisterDamaged(g_strEntities[i]);
	}
}

HookReturnCode OnPlayerConnected(CZP_Player@ pPlayer) 
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
		g_iPropHP[pBaseEnt.entindex()] = 0;
		g_iEntIndex[pBaseEnt.entindex()] = 0;
	}

	return HOOK_CONTINUE;
}

void OnEntityDamaged(CBaseEntity@ pAttacker, CBaseEntity@ pEntity)
{	
	if(bIsCSZM == true)
	{
		if(pAttacker.GetTeamNumber() == 3)
		{
			g_iPropHP[pAttacker.entindex()] = pEntity.GetHealth();
			g_iEntIndex[pAttacker.entindex()] = pEntity.entindex();
			Schedule::Task(0.001f, "ShowHPLeft");
		}
	}
}

void ShowHPLeft()
{
	CBaseEntity@ pEntity;
	
	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
				
		if(pPlayer is null) continue;
			
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if(g_iEntIndex[i] > 0 && pBaseEnt.GetTeamNumber() == 3)
		{
			for(uint ui = 0; ui <= g_strEntities.length(); ui++)
			{
				while ((@pEntity = FindEntityByClassname(pEntity, g_strEntities[ui])) !is null)
				{
					if(pEntity.entindex() == g_iEntIndex[i])
					{
						ValidEntity(i, pEntity, pPlrEnt);
					}
				}
			}
		}
	}
}

void ValidEntity(const int &in i, CBaseEntity@ pEntity, CBasePlayer@ pPlrEnt)
{
	if(g_iPropHP[i] == pEntity.GetHealth()) 
	{
		Chat.CenterMessagePlayer(pPlrEnt, pEntity.GetHealth() + " HP");
		g_iEntIndex[i] = 0;
		g_iPropHP[i] = 0;
	}
	else
	{
		Chat.CenterMessagePlayer(pPlrEnt, pEntity.GetHealth() + " HP Left");
		g_iEntIndex[i] = 0;
		g_iPropHP[i] = 0;
	}
}