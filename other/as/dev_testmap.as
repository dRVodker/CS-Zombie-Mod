//	CBasePlayer@ pPlrEnt = pPlayer.opCast();
//	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

#include "overridelimits/example_balance_arrays"
#include "overridelimits/balance_funcs"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void CD(const string &in strMsg)
{
	Chat.CenterMessage(all, strMsg);
}

void OverrideLimits()
{
	RoundManager.Limit_Enable(true);
	RoundManager.Limit_Override(random_def, true);

	int iSurvCount = Utils.GetNumPlayers(survivor, false);

	SetLimits(iSurvCount);
}

int iMaxPlayers;

void OnProcessRound()
{

}

array<string> g_ExceptionCN =
{
    "info_player_commons",
    "point_template",
    "info_target",
    "env_soundscape",
    "light",
    "func_illusionary",
    "predicted_viewmodel",
    "func_areaportal",
    "trigger_multiple",
    "weapon_emptyhand"
};

void OnMapInit()
{
	Engine.EnableCustomSettings(true);

	RoundManager.Limit_Enable(true);
	RoundManager.Limit_Override(random_def, true);

	iMaxPlayers = Globals.GetMaxClients();

	Entities::RegisterUse("test_brush");
	Entities::RegisterUse("test_brush2");

	Entities::RegisterUse("prop_physics");

	Engine.PrecacheFile(sound, "buttons/button16.wav");
	Engine.PrecacheFile(sound, "buttons/button17.wav");

	Engine.PrecacheFile(sound, "items/suitchargeok1.wav");

	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Events::Player::OnPlayerDisonnected.Hook(@OnPlayerDisonnected);
	Events::Player::OnPlayerConnected.Hook(@OnPlayerConnected);
	Events::Player::OnPlayerKilled.Hook(@OnPlayerKilled);
}

void OnNewRound()
{

}

HookReturnCode OnPlayerConnected(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerDisonnected(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerSpawn(CZP_Player@ pPlayer)
{
	
	return HOOK_HANDLED;
}

HookReturnCode OnPlayerKilled(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	return HOOK_CONTINUE;
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pPlayer is null) return;
	if (pEntity is null) return;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	int iTeamNum = pBaseEnt.GetTeamNumber();

	if (Utils.StrEql(pEntity.GetEntityName(), "test_brush"))
	{
		SD("{allies}Проверочное сообщение!");
		Schedule::Task(0.5f, "TestFunc");
	}

	if (Utils.StrEql(pEntity.GetEntityName(), "test_brush2"))
	{
		SD("{blue}Проверочное сообщение!");

	}

	if (Utils.StrEql(pEntity.GetClassname(), "prop_physics"))
	{
		SD("{red}Проверочное сообщение!");

	}
}

void TestFunc()
{
	SD("{violet}-=Map Func=-");	
}

bool IsException(const string &in strClassname)
{
	bool IsExc = false;

	for (uint q = 0; q < g_ExceptionCN.length(); q++)
	{
		if (Utils.StrEql(g_ExceptionCN[q], strClassname))
		{
			IsExc = true;
		}
	}

	return IsExc;
}

void LockdownBasement()
{
	int iEdictsLimit = 2048;

	SD("{cyan}Edicts: " + iEdictsLimit);

	CBaseEntity@ pEntity;
	for (int i = 1; i <= iEdictsLimit; i++)
	{
		@pEntity = FindEntityByEntIndex(i);

		if (pEntity is null)
		{
			continue;
		}

		if (pEntity.IsPlayer())
		{
			continue;
		}

		string strClassname = pEntity.GetClassname();
		Vector absOrigin = pEntity.GetAbsOrigin();

		if (absOrigin.z <= 205)
		{
			if (!IsException(strClassname))
			{
				SD("{gold}(For) Classname: " + strClassname + "\n{violet}EntIndex: " + pEntity.entindex());
//				pEntity.SUB_Remove();
			}
		}
	}

/*
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_zombie")) !is null)
	{
		string strClassname = pEntity.GetClassname();
		Vector absOrigin = pEntity.GetAbsOrigin();

		if (absOrigin.z <= 205)
		{
			SD("{gold}(While) Classname: " + strClassname + "\n{violet}EntIndex: " + pEntity.entindex());
//			pEntity.SUB_Remove();
		}
	}
*/
}