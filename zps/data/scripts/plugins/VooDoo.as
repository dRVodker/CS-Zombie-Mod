//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Debug funcs
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void CD(const string &in strMsg)
{
	Chat.CenterMessage(all, strMsg);
}

string StrSD = "";

void SDPlus()
{
	StrSD += "-";
	SD("{blueviolet}SDPlus: {cyan}" + StrSD);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//CustomItems
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

CEntityData@ gFragMineIPD = EntityCreator::EntityData();
CEntityData@ gAdrenalineIPD = EntityCreator::EntityData();
CEntityData@ gAntidoteIPD = EntityCreator::EntityData();
CEntityData@ gMoneyIPD = EntityCreator::EntityData();

void SetUpIPD(const int &in iFlags)
{
	if (iFlags & 1<<1 == 1<<1)
	{
		gFragMineIPD.Add("targetname", "weapon_fragmine");
		gFragMineIPD.Add("viewmodel", "models/cszm/weapons/v_minefrag.mdl");
		gFragMineIPD.Add("model", "models/cszm/weapons/w_minefrag.mdl");
		gFragMineIPD.Add("itemstate", "1");
		gFragMineIPD.Add("isimportant", "0");
		gFragMineIPD.Add("carrystate", "6");
		gFragMineIPD.Add("glowcolor", "0 128 245");
		gFragMineIPD.Add("delivername", "FragMine");
		gFragMineIPD.Add("sound_pickup", "Player.PickupWeapon");
		gFragMineIPD.Add("printname", "vgui/images/fragmine");
		gFragMineIPD.Add("weight", "5");
		gFragMineIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}FragMine IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<2 == 1<<2)
	{
		gAdrenalineIPD.Add("targetname", "item_adrenaline");
		gAdrenalineIPD.Add("delivername", "Adrenaline");
		gAdrenalineIPD.Add("glowcolor", "5 250 121");
		gAdrenalineIPD.Add("itemstate", "1");
		gAdrenalineIPD.Add("model", "models/cszm/weapons/w_adrenaline.mdl");
		gAdrenalineIPD.Add("viewmodel", "models/cszm/weapons/v_adrenaline.mdl");
		gAdrenalineIPD.Add("printname", "vgui/images/adrenaline");
		gAdrenalineIPD.Add("sound_pickup", "Deliver.PickupGeneric");
		gAdrenalineIPD.Add("weight", "0");
		gAdrenalineIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Adrenaline IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<3 == 1<<3)
	{
		gAntidoteIPD.Add("targetname", "item_antidote");
		gAntidoteIPD.Add("delivername", "Antidote");
		gAntidoteIPD.Add("glowcolor", "5 250 121");
		gAntidoteIPD.Add("itemstate", "1");
		gAntidoteIPD.Add("model", "models/cszm/weapons/w_antidote.mdl");
		gAntidoteIPD.Add("viewmodel", "models/cszm/weapons/v_antidote.mdl");
		gAntidoteIPD.Add("printname", "vgui/images/weapons/inoculator");
		gAntidoteIPD.Add("sound_pickup", "Deliver.PickupGeneric");
		gAntidoteIPD.Add("weight", "0");
		gAntidoteIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Antidote IPD {cyan}Added{green}=-");
	}

	if (iFlags & 1<<4 == 1<<4)
	{
		gMoneyIPD.Add("canfirehurt", "0");
		gMoneyIPD.Add("minhealthdmg", "1000");
		gMoneyIPD.Add("model", "models/cszm/weapons/w_rubles.mdl");
		gMoneyIPD.Add("nodamageforces", "1");
		gMoneyIPD.Add("nofiresound", "1");
		gMoneyIPD.Add("physdamagescale", "0");
		gMoneyIPD.Add("spawnflags", "8582");
		gMoneyIPD.Add("unbreakable", "1");
		gMoneyIPD.Add("overridescript", "mass,1,");
		gMoneyIPD.Add("DisableDamageForces", "0", true);
		Log.PrintToServerConsole(LOGTYPE_INFO, "Custom Items", "{green}-={blueviolet}Money IPD {cyan}Added{green}=-");
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Data
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

enum ZPS_Teams {TEAM_LOBBYGUYS, TEAM_SPECTATORS, TEAM_SURVIVORS, TEAM_ZOMBIES}

int iMaxPlayers;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Plugin/Map init
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("VooDoo Plugin");

	Engine.PrecacheFile(model, "models/editor/playerstart.mdl");
	Engine.PrecacheFile(model, "models/cszm/weapons/w_rubles.mdl");

	Engine.PrecacheFile(sound, "buttons/button14.wav");
	Engine.PrecacheFile(sound, "buttons/combine_button7.wav");
	Engine.PrecacheFile(sound, "buttons/combine_button_locked.wav");

	iMaxPlayers = Globals.GetMaxClients();
	A_VooDoo.resize(iMaxPlayers + 1);
	SetVooDoo();

	Entities::RegisterOutput("OnUser1", "money_model");
	Entities::RegisterOutput("OnUser1", "info_beacon");
	Entities::RegisterOutput("OnUser2", "info_beacon");

	Engine.EnableCustomSettings(true);
	Globals.AllowNPCs(true);

	Events::Player::PlayerSay.Hook(@VooDoo_PlayerSay);
	Events::Player::OnConCommand.Hook(@VooDoo_OnConCommand);
	Events::Player::OnPlayerConnected.Hook(@VooDoo_OnPlayerConnected);
	Events::Player::OnPlayerDisconnected.Hook(@VooDoo_OnPlayerDisconnected);

	Events::Player::OnPlayerInitSpawn.Hook(@VooDoo_OnPlayerInitSpawn);

	Events::Custom::OnEntityDamaged.Hook(@VooDoo_OnEntDamaged);

	RespawnMaker::LogicPlayerManager();
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

void OnMapInit()
{
	RespawnMaker::ResetSpawn();
}

void OnNewRound()
{

}

void OnProcessRound()
{
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		if (FindEntityByEntIndex(i) !is null)
		{
			A_VooDoo[i].Think();
		}
	}
}

void OnEntityOutput(const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller)
{
	//SD("ActivatorClass: " + pActivator.GetClassname());
	//SD("CallerClass: " + pCaller.GetClassname());
	//SD("Output: " + strOutput);

	if (Utils.StrEql("OnUser1", strOutput, true) && Utils.StrEql("money_model", pActivator.GetEntityName(), true))
	{
		pActivator.SetAbsAngles(pActivator.GetAbsAngles() + QAngle(0, 5.00f, 0));
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//VooDooPlayer
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

array<VooDooPlayer@> A_VooDoo;

class VooDooPlayer
{
	int PlayerSlot;

	VooDooPlayer(CBaseEntity@ pPlayer)
	{
		PlayerSlot = pPlayer.entindex();
		SD("{blueviolet}VooDoo{team}Player\n{gold}Index = {cyan}" + formatInt(PlayerSlot));
	}

	void Think()
	{

	}
}

void SetVooDoo()
{
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null)
		{
			continue;
		}

		@A_VooDoo[i] = VooDooPlayer(pPlayerEntity);
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Hooks
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

HookReturnCode VooDoo_OnPlayerConnected(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	int index = pPlayerEntity.entindex();

	@A_VooDoo[index] = VooDooPlayer(pPlayerEntity);

	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_OnPlayerDisconnected(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	int index = pPlayerEntity.entindex();

	@A_VooDoo[index] = null;

	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_PlayerSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HRC_Result = HOOK_CONTINUE;
	if (pPlayer is null || pArgs is null) 
	{
		return HRC_Result;
	}

	string Content = pArgs.Arg(1);

	if ((Content.findFirst("/", 0) == 0 || Content.findFirst("!", 0) == 0) && Content.length() > 1)
	{
		HRC_Result = HOOK_HANDLED;
		Content = Utils.StrReplace(Content, "/", "");
		Content = Utils.StrReplace(Content, "!", "");
		VooDoo_CommandManager(StringToArgSplit(Content, " "), pPlayer);
	}

	return HRC_Result;
}

HookReturnCode VooDoo_OnConCommand(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HOOK_RESULT = HOOK_CONTINUE;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int index = pBaseEnt.entindex();

	HOOK_RESULT = VooDoo_CommandManager(pArgs, pPlayer);

	return HOOK_RESULT;
}

HookReturnCode VooDoo_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	SD("AttackerClass: " + DamageInfo.GetAttacker().GetClassname());
	SD("Damage = " + DamageInfo.GetDamage());

	int EntIndex = pEntity.entindex();

	return HOOK_CONTINUE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Other shit
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

HookReturnCode VooDoo_CommandManager(CASCommand@ pCS, CZP_Player@ pPlayer)
{
	HookReturnCode HOOK_RESULT = HOOK_CONTINUE;
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
	int index = pPlayerEntity.entindex();

	if (Utils.StrEql("test1", pCS.Arg(0), true))
	{
		SD("*{green}TEST1");
		AddToArray("TEST1", Utils.StringToInt(pCS.Arg(1)));
	}
	else if (Utils.StrEql("test2", pCS.Arg(0), true))
	{
		SD("*{red}TEST2");
		ShowArray();
		/*CBaseEntity@ pEntity = GetEntityByTraceLine(pPlayer);

		if (pEntity !is null)
		{
			SD("*{blueviolet}Entity Health{green}:{cyan} " + formatInt(pEntity.GetHealth()));
		}*/
	}
	else if (Utils.StrEql("test3", pCS.Arg(0), true))
	{
		SD("*{blue}TEST3");
		CBaseEntity@ pEntity = GetEntityByTraceLine(pPlayer);
		CBasePropDoor@ pDoor = ToBasePropDoor(pEntity);

		if (pDoor !is null)
		{
			int nHealth = Utils.StringToInt(pCS.Arg(1));
			pDoor.SetDoorHealth(nHealth);
			SD("*{blueviolet}Door health set to {green}({cyan}"+formatInt(nHealth)+"{green})");
		}
	}
	else if (Utils.StrEql("findspawn", pCS.Arg(0), true))
	{
		SD("*{Violet}FindSpawn");
		FindSpawns(pCS.Arg(1));
	}
	else if (Utils.StrEql("findcash", pCS.Arg(0), true))
	{
		SD("*{Violet}FindCash");
		FindCash(pCS.Arg(1));
	}
	else if (Utils.StrEql("calldebug", pCS.Arg(0), true))
	{
		OtherFunc(pCS.Arg(1));
	}
	else if (Utils.StrEql("roar_target", pCS.Arg(0), true) && Utils.StrEql("weapon_phone", pPlayer.GetCurrentWeapon().GetClassname(), true))
	{
		MoneyMaker::Make(pPlayer);
	}
	else if (Utils.StrEql("taunt", pCS.Arg(0), true) && Utils.StrEql("weapon_phone", pPlayer.GetCurrentWeapon().GetClassname(), true))
	{
		MoneyMaker::Clear(pPlayer);
	}
	else if (RespawnMaker::CheckCommands(pPlayerEntity, pCS.Arg(0))) 
	{
		HOOK_RESULT = HOOK_HANDLED;
	}
	/*else
	{
		SD("{red}*{gold}Команда не найдена!");
	}*/

	return HOOK_RESULT;
}

CBaseEntity@ GetEntityByTraceLine(CZP_Player@ pCaller)
{
	CBaseEntity@ pEntity = null;

	CBasePlayer@ pCallerBase = pCaller.opCast();
	CBaseEntity@ pCallerEntity = pCallerBase.opCast();

	Vector Forward = pCallerEntity.EyePosition();
	Vector StartPos = pCallerEntity.EyePosition();
	Vector EndPos;

	Globals.AngleVectors(pCallerEntity.EyeAngles(), Forward);

	EndPos = StartPos + Forward * 16000;

	CGameTrace trace;

	Utils.TraceLine(StartPos, EndPos, MASK_ALL, pCallerEntity, COLLISION_GROUP_NONE, trace);

	if (trace.DidHit())
	{
		@pEntity = trace.m_pEnt;
	}

	return pEntity;
}

void OtherFunc(const string nFuncName)
{
	NetData nData;
	nData.Write(nFuncName);

	Network::CallFunction("DebugCall", nData);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Testing Zone
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

array<CText@> g_DefaultText;
array<CText@> g_SpecialText;

void ShowArray()
{
	int iCount = 0;

	for(uint i = 0; i < g_DefaultText.length(); i++)
	{
		iCount++;
	}

	SD("Default Text: " + iCount);
	iCount = 0;

	for(uint i = 0; i < g_SpecialText.length(); i++)
	{
		iCount++;
	}

	SD("Special Text: " + iCount);
}

class AddToArray
{
	AddToArray(string nMSG)
	{
		Add(nMSG, 0);
	}

	AddToArray(string nMSG, int nPoints)
	{
		Add(nMSG, nPoints);
	}

	private void Add(string nMSG, int nPoints)
	{
		(nPoints > 0) ? g_SpecialText.insertLast(CText(nMSG, nPoints)) : g_DefaultText.insertLast(CText(nMSG));
	}
}

class CText
{
	string MyMSG;
	int MyPoints;

	CText(string nMSG)
	{
		MyMSG = nMSG;
	}

	CText(string nMSG, int nPoints)
	{
		MyMSG = nMSG;
		MyPoints = nPoints;
	}
}


//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Money Maker
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

namespace MoneyMaker
{
	void Make(CZP_Player@ pCaller)
	{
		CBasePlayer@ pCallerBase = pCaller.opCast();
		CBaseEntity@ pCallerEntity = pCallerBase.opCast();

		Vector CashOrigin = GetOriginByTraceLine(pCallerEntity);

		float X = CashOrigin.x;
		float Y = CashOrigin.y;
		float Z = CashOrigin.z;

		CEntityData@ ID = EntityCreator::EntityData();

		ID.Add("targetname", "money_model");
		ID.Add("disableshadows", "1");
		ID.Add("model", "models/cszm/weapons/w_rubles.mdl");
		ID.Add("solid", "0");
		ID.Add("spawnflags", "256");
		ID.Add("origin", X + " " + Y + " " + Z);

		ID.Add("addoutput", "OnUser1 !self:FireUser1:0:0.01:-1", true);
		ID.Add("FireUser1", "0", true, "0.15");

		CBaseEntity@ pModel = EntityCreator::Create("prop_dynamic_override", CashOrigin, QAngle(0, Math::RandomFloat(-180.0f, 180.0f), 0), ID);

		Chat.PrintToConsole(all, "{cyan}InsertToArray("+ X +", "+ Y +", "+ Z +");");
	}

	void Clear(CZP_Player@ pCaller)
	{
		Engine.Ent_Fire("money_model", "kill", "0", "0.00");
		pCaller.ConsoleCommand("clear");
	}

	Vector GetOriginByTraceLine(CBaseEntity@ pCallerEntity)
	{
		Vector Forward = pCallerEntity.EyePosition();
		Vector StartPos = pCallerEntity.EyePosition();
		Vector EndPos;

		Globals.AngleVectors(pCallerEntity.EyeAngles(), Forward);

		EndPos = StartPos + Forward * 16000;

		CGameTrace trace;

		Utils.TraceLine(StartPos, EndPos, MASK_ALL, pCallerEntity, COLLISION_GROUP_NONE, trace);

		return trace.endpos + Vector(0, 0, 1);
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Respawn Maker
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

namespace RespawnMaker
{
	int iSpawnCount = 0;

	bool CheckCommands(CBaseEntity@ pPlayerEntity, const string &in Command)
	{
		bool b = true;

		if (Utils.StrEql("showspawn", Command, true))
		{
			CreateDummy(pPlayerEntity);
		}
		else if (Utils.StrEql("resetspawn", Command, true))
		{
			ResetSpawn();
			ToZPPlayer(pPlayerEntity).ConsoleCommand("clear");
		}
		else if (Utils.StrEql("vcenter", Command, true))
		{
			pPlayerEntity.Teleport(pPlayerEntity.GetAbsOrigin(), QAngle(0, pPlayerEntity.GetAbsAngles().y, 0), Vector(0, 0, 0));
		}
		else
		{
			b = false;
		}

		return b;
	}

	void ResetSpawn()
	{
		iSpawnCount = 0;
		Engine.Ent_Fire("playerstart_model", "kill", "0", "0.00");
		CD("-=Spawn Reset=-");
	}

	void CreateDummy(CBaseEntity@ pPlayer)
	{
		iSpawnCount++;
		CEntityData@ ID = EntityCreator::EntityData();
		ID.Add("targetname", "playerstart_model");
		ID.Add("disableshadows", "1");
		ID.Add("model", "models/editor/playerstart.mdl");
		ID.Add("solid", "0");
		ID.Add("spawnflags", "256");
		ID.Add("DefaultAnim", "IDLE");

		CBaseEntity@ pModel = EntityCreator::Create("prop_dynamic", pPlayer.GetAbsOrigin(), QAngle(0, pPlayer.GetAbsAngles().y, 0), ID);

		Chat.PrintToConsole(all, "{cyan}CSpawnPoint(Vector(" + pPlayer.GetAbsOrigin().x + ", " + pPlayer.GetAbsOrigin().y + ", " + pPlayer.GetAbsOrigin().z + "), QAngle(" + pPlayer.GetAbsAngles().x + ", " + pPlayer.GetAbsAngles().y + ", " + pPlayer.GetAbsAngles().z + ")),");
		CD("-=Spawn Count = " + formatInt(iSpawnCount) + "=-");
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
}

void FindSpawns(const string strClass)
{
	CBaseEntity@ pSpawn = null;
	int iCount = 0;

	while ((@pSpawn = FindEntityByClassname(pSpawn, strClass)) !is null)
	{
		iCount++;
		Chat.PrintToConsole(all, "{cyan}CSpawnPoint(Vector(" + pSpawn.GetAbsOrigin().x + ", " + pSpawn.GetAbsOrigin().y + ", " + pSpawn.GetAbsOrigin().z + "), QAngle(" + pSpawn.GetAbsAngles().x + ", " + pSpawn.GetAbsAngles().y + ", " + pSpawn.GetAbsAngles().z + ")),");
	}

	Chat.PrintToConsole(all, "{blueviolet}Spawns found{green}: {cyan}" + formatInt(iCount));
}

void FindCash(const string strName)
{
	CBaseEntity@ pSpawn = null;
	int iCount = 0;

	while ((@pSpawn = FindEntityByName(pSpawn, strName)) !is null)
	{
		iCount++;
		Chat.PrintToConsole(all, "{cyan}InsertToArray("+ pSpawn.GetAbsOrigin().x +", "+ pSpawn.GetAbsOrigin().y +", "+ pSpawn.GetAbsOrigin().z +");");
	}

	Chat.PrintToConsole(all, "{blueviolet}Cash found{green}: {cyan}" + formatInt(iCount));
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Client Bindings
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

//VooDoo_OnPlayerInitSpawn

HookReturnCode VooDoo_OnPlayerInitSpawn(CZP_Player@ pPlayer)
{
	pPlayer.ConsoleCommand("bind 6 slot6");
	pPlayer.ConsoleCommand("bind 7 slot7");
	pPlayer.ConsoleCommand("bind 8 slot8");
	pPlayer.ConsoleCommand("bind 9 slot9");
	pPlayer.ConsoleCommand("bind 0 slot0;menuselect 10");

	Schedule::Task(1.05f, "IS_TEST");

	return HOOK_CONTINUE;
}

void IS_TEST()
{
	SD("{violet}OnPlayerInitSpawn");
}