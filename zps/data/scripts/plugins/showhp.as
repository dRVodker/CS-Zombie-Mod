//some data
int iMaxPlayers;

array<int> g_iEntIndex;
array<int> g_iPropHP;

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnPluginInit()
{
	//Events
	Events::Player::OnPlayerConnected.Hook(@OnPlayerConnected);
//	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
}

void OnMapInit()
{		
	iMaxPlayers = Globals.GetMaxClients();
	
	g_iPropHP.resize(iMaxPlayers + 1);
	g_iEntIndex.resize(iMaxPlayers + 1);

	//Entities
	Entities::RegisterDamaged("prop_physics_multiplayer");
	Entities::RegisterDamaged("prop_physics_override");
	Entities::RegisterDamaged("prop_physics_");
	Entities::RegisterDamaged("func_breakable");
	Entities::RegisterDamaged("func_physbox");
	Entities::RegisterDamaged("prop_barricade");
}

void OnMapShutdown()
{
	Entities::RemoveRegisterDamaged("prop_physics_multiplayer");
	Entities::RemoveRegisterDamaged("prop_physics_override");
	Entities::RemoveRegisterDamaged("prop_physics_");
	Entities::RemoveRegisterDamaged("func_breakable");
	Entities::RemoveRegisterDamaged("func_physbox");
	Entities::RemoveRegisterDamaged("prop_barricade");
}

HookReturnCode OnPlayerConnected(CZP_Player@ pPlayer) 
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
	g_iPropHP[pBaseEnt.entindex()] = 0;
	g_iEntIndex[pBaseEnt.entindex()] = 0;

	return HOOK_CONTINUE;
}

void OnEntityDamaged(CBaseEntity@ pAttacker, CBaseEntity@ pEntity)
{	
	if(pAttacker.GetTeamNumber() == 3)
	{
		g_iPropHP[pAttacker.entindex()] = pEntity.GetHealth();
		g_iEntIndex[pAttacker.entindex()] = pEntity.entindex();
		Schedule::Task(0.001f, "ShowHPLeft");
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
			while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
			{
				if(pEntity.entindex() == g_iEntIndex[i])
				{
					ValidEntity(i, pEntity, pPlrEnt);
				}
			}
				
			while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_override")) !is null)
			{
				if(pEntity.entindex() == g_iEntIndex[i])
				{
						ValidEntity(i, pEntity, pPlrEnt);
				}
			}
				
			while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics")) !is null)
			{
				if(pEntity.entindex() == g_iEntIndex[i])
				{
					ValidEntity(i, pEntity, pPlrEnt);
				}
			}
				
			while ((@pEntity = FindEntityByClassname(pEntity, "func_breakable")) !is null)
			{
				if(pEntity.entindex() == g_iEntIndex[i])
				{
					ValidEntity(i, pEntity, pPlrEnt);
				}
			}
				
			while ((@pEntity = FindEntityByClassname(pEntity, "func_physbox")) !is null)
			{
				if(pEntity.entindex() == g_iEntIndex[i])
				{
					ValidEntity(i, pEntity, pPlrEnt);
				}
			}
				
			while ((@pEntity = FindEntityByClassname(pEntity, "prop_barricade")) !is null)
			{
				if(pEntity.entindex() == g_iEntIndex[i])
				{
					ValidEntity(i, pEntity, pPlrEnt);
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