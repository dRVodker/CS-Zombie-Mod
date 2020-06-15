
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

	Engine.PrecacheFile(sound, "buttons/button14.wav");
	Engine.PrecacheFile(sound, "buttons/combine_button7.wav");
	Engine.PrecacheFile(sound, "buttons/combine_button_locked.wav");

	iMaxPlayers = Globals.GetMaxClients();
	Array_VooDoo.resize(iMaxPlayers + 1);
	SetVooDoo();

	Engine.EnableCustomSettings(true);
	Globals.AllowNPCs(true);

	Events::Player::PlayerSay.Hook(@VooDoo_PlayerSay);
	Events::Player::OnPlayerConnected.Hook(@VooDoo_OnPlayerConnected);
	Events::Player::OnPlayerDisonnected.Hook(@VooDoo_OnPlayerDisconnected);
	Events::Custom::OnPlayerDamagedCustom_PRE.Hook(@VooDoo_OnPlayerDamaged);
	Events::Custom::OnEntityDamaged.Hook(@CSZM_OnEntDamaged);
	Events::Player::OnConCommand.Hook(@VooDoo_OnConCommand);

	RespawnMaker::LogicPlayerManager();
}

bool LessThanGT(float flTime)
{
	return (flTime <= Globals.GetCurrentTime() && flTime != 0);
}

float PlusGT(float flTime)
{
	return Globals.GetCurrentTime() + flTime;
}

void OnMapInit()
{
	RespawnMaker::ResetSpawn();
}

void OnProcessRound()
{
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		if (FindEntityByEntIndex(i) !is null)
		{
			Array_VooDoo[i].Think();
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

array<VooDooPlayer@> Array_VooDoo;

class VooDooProp
{
	private array<array<string>> Props;

	void Add(const string Key, const string Value)
	{
		array<string> NewProp = {Key, Value};
		Props.insertLast(NewProp);
	}

	string GetKeyValue(const string Key)
	{
		if (Key == "item0")
		{
			return "Close";
		}

		int iLength = int(Props.length());
		for (int i = 0; i < iLength; i++)
		{
			if (Utils.StrEql(Key, Props[i][0], true))
			{
				return Props[i][1];
			}
		}

		return "null";
	}
}

class VooDooPlayer
{
	private int EIndex;
	int cash;
	Radio::Menu@ pMenu;
	GameText::Cash@ pCash;
	float flTest1;
	float flTest2;

	VooDooPlayer(CBaseEntity@ pPlayer)
	{
		flTest1 = PlusGT(1.0f);
		EIndex = pPlayer.entindex();
		cash = 7500;
		@pMenu = null;
		@pCash = GameText::Cash(EIndex, cash);
		SD("{blueviolet}VooDoo{team}Player\n{gold}Index = {cyan}" + formatInt(EIndex));
	}

	void AddMenu(Radio::Menu@ nShop)
	{
		@pMenu = nShop;
	}

	void ExitMenu()
	{
		@pMenu = null;
	}

	void Think()
	{
		if (pMenu !is null)
		{
			pMenu.Think();
		}

		if (pCash !is null)
		{
			pCash.Think();
		}
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

		@Array_VooDoo[i] = VooDooPlayer(pPlayerEntity);
	}
}

HookReturnCode VooDoo_OnPlayerConnected(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	int index = pPlayerEntity.entindex();

	@Array_VooDoo[index] = VooDooPlayer(pPlayerEntity);

	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_OnPlayerDisconnected(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	int index = pPlayerEntity.entindex();

	@Array_VooDoo[index] = null;

	return HOOK_CONTINUE;
}

HookReturnCode VooDoo_OnPlayerDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &out DamageInfo)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	CBaseEntity@ pInflictor = DamageInfo.GetInflictor();
	CBaseEntity@ pAttaker = DamageInfo.GetAttacker();

	int index = pPlayerEntity.entindex();

	SD("{pink}Damage: " + DamageInfo.GetDamage());

	if (pAttaker.IsPlayer())
	{
		SD("{pink}Player Attacker: " + ToZPPlayer(pAttaker).GetPlayerName());
	}
	else
	{
		SD("{pink}Attacker: " + pAttaker.GetClassname());	
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	DamageInfo.SetDamage(floor(DamageInfo.GetDamage()));
	
	//CBaseEntity@ pAttaker = DamageInfo.GetAttacker();

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

HookReturnCode VooDoo_OnConCommand(CZP_Player@ pCaller, CASCommand@ pArgs)
{
	CBasePlayer@ pCallerBase = pCaller.opCast();
	CBaseEntity@ pCallerEntity = pCallerBase.opCast();

	SD("Command: " + pArgs.Arg(0) + " " + pArgs.Arg(1));


	if (pArgs.Arg(0) == "as_slot" && Array_VooDoo[pCallerEntity.entindex()].pMenu !is null)
	{
		Array_VooDoo[pCallerEntity.entindex()].pMenu.Input(Utils.StringToInt(pArgs.Arg(1)));
		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

void VooDoo_CommandManager(CASCommand@ pCS, CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
	int index = pPlayerEntity.entindex();

	if (Utils.StrEql("test1", pCS.Arg(0), true))
	{
		SD("*{violet}TEST1");
		//SentTestMenu(index);
		pPlayer.SetHudVisibility(true);
	}
	else if (Utils.StrEql("test2", pCS.Arg(0), true))
	{
		SD("*{red}TEST2");
		pPlayer.SetHudVisibility(false);
	}
	else if (Utils.StrEql("test3", pCS.Arg(0), true))
	{
		SD("*{blueviolet}TEST3");
		SD("{blueviolet}" + formatInt(7 * Utils.StringToInt(pCS.Arg(1)) - 7));
	}
	else if (Utils.StrEql("shop", pCS.Arg(0), true))
	{
		SendTestShop(index, Utils.StringToInt(pCS.Arg(1)));
	}
	else if (Utils.StrEql("input", pCS.Arg(0), true))
	{
		Array_VooDoo[index].pMenu.Input(Utils.StringToInt(pCS.Arg(1)));
	}
	else if (Utils.StrEql("cash", pCS.Arg(0), true))
	{
		Array_VooDoo[index].cash = Utils.StringToInt(pCS.Arg(1));
	}
	else if (RespawnMaker::CheckCommands(pPlayerEntity, pCS.Arg(0)))
	{

	}
	else
	{
		SD("{red}*{gold}Команда не найдена!");
	}
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

void SendTestShop(const int &in Index, const int &in nType)
{
	Array_VooDoo[Index].AddMenu(Radio::Menu(Index, nType));
}

void SentTestMenu(const int &in Index)
{
	GameText::MenuKeyValyes@ pMParams = GameText::MenuKeyValyes();

	pMParams.Add("title", "The Title");
	pMParams.Add("item1", "slot1");
	pMParams.Add("item2", "slot2");
	pMParams.Add("item3", "slot3");
	pMParams.Add("item4", "slot4");
	pMParams.Add("item5", "slot5");
	pMParams.Add("item6", "slot6");
	pMParams.Add("item7", "slot7");
	pMParams.Add("prev", "true");
	pMParams.Add("next", "true");

	pMParams.Add("holdtime", "3.0");
	pMParams.Add("fadeout", "2.75");

	GameText::Menu(Index, pMParams);
}

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

namespace GameText
{
	const float AccCashLifeTime = 4.0f;

	const array<string> AMPExtra = 
	{
		"title",
		"holdtime",
		"fadeout"
	};

	const array<string> AMPItem = 
	{
		"item1",
		"item2",
		"item3",
		"item4",
		"item5",
		"item6",
		"item7"
	};

	void STM(CZP_Player@ pPlayer, const string &in strMessage, const float &in flHoldTime, const float &in flFadeOutTime)
	{
		HudTextParams pParams;
		pParams.x = 0.00725f;
		pParams.y = 0.185f;
		pParams.channel = 7;
		pParams.fadeoutTime = flFadeOutTime;
		pParams.holdTime = flHoldTime;
		pParams.SetColor(Color(215, 180, 115));
		Utils.GameTextPlayer(pPlayer, strMessage, pParams);
	}

	class MenuKeyValyes
	{
		private array<string> p_Key;
		private array<string> p_Value;

		void Add(const string Key, const string Value)
		{
			p_Key.insertLast(Key);
			p_Value.insertLast(Value);
		}

		void Update(const string Key, const string Value)
		{
			int KeyIndex = p_Key.find(Key);

			if (KeyIndex > -1)
			{
				p_Value[KeyIndex] = Value;
			}
			else
			{
				Add(Key, Value);
			}
		}

		string GetKeyValue(const string Key)
		{
			int KeyIndex = p_Key.find(Key);

			if (KeyIndex > -1)
			{
				return p_Value[KeyIndex];
			}

			switch(AMPExtra.find(Key))
			{
				case 0: return "Empty Title";
				case 1: return "10.0";
				case 2: return "0.0";
			}

			return "null";
		}
	}

	class Menu
	{
		Menu(const int iPlayerIndex, MenuKeyValyes@ nParams)
		{
			string FullMSG = "";

			FullMSG += nParams.GetKeyValue("title") + "\n";

			for (uint i = 0; i < AMPItem.length(); i++)
			{
				string MI_Value = nParams.GetKeyValue(AMPItem[i]);

				if (MI_Value != "null")
				{
					FullMSG += "\n" + formatInt(i + 1) + ". " + MI_Value;
				}

				if (i == AMPItem.length() - 1)
				{
					FullMSG += "\n";
				}
			}

			if (nParams.GetKeyValue("prev") == "true")
			{
				FullMSG +="\n8. Previous";
			}

			if (nParams.GetKeyValue("next") == "true")
			{
				FullMSG +="\n9. Next";
			}

			FullMSG +="\n0. Close";

			STM(ToZPPlayer(iPlayerIndex), FullMSG, Utils.StringToFloat(nParams.GetKeyValue("holdtime")), Utils.StringToFloat(nParams.GetKeyValue("fadeout")));
		}
	}

	class Cash
	{
		int PlayerIndex;
		float Alpha;
		int AccumulateCash;
		int PrevCash;
		float flLifeTime;
		float flShowTime;

		Cash(const int nPlayer, const int nCash)
		{
			PlayerIndex = nPlayer;
			flShowTime = PlusGT(0.0991f);
			PrevCash = nCash;
			flLifeTime = AccCashLifeTime;
		}

		void CheckCash()
		{
			if (PrevCash != Array_VooDoo[PlayerIndex].cash)
			{
				if (flLifeTime >= AccCashLifeTime / 2)
				{
					AccumulateCash = 0;
				}

				AccumulateCash += Array_VooDoo[PlayerIndex].cash - PrevCash;
				PrevCash = Array_VooDoo[PlayerIndex].cash;
				Alpha = 0.0f;
				flLifeTime = 0.0f;
			}
			Show();
		}

		void Think()
		{
			if (flLifeTime < AccCashLifeTime)
			{
				flLifeTime += 0.0149254f;

				if (flLifeTime > AccCashLifeTime)
				{
					flLifeTime = AccCashLifeTime;
				}

				Alpha = (flLifeTime / 100.0f / 0.04f);
			}

			if (LessThanGT(flShowTime))
			{
				flShowTime = PlusGT(0.0991f);
				CheckCash();
			}
		}

		private void Show()
		{
			string FullMSG = formatInt(Array_VooDoo[PlayerIndex].cash) + "$";
			int Red = 230;
			int Green = 230;
			int Blue = 230;

			if (flLifeTime < AccCashLifeTime)
			{
				if (AccumulateCash < 0)
				{
					Green = int(Green * Alpha);
					Blue = int(Blue * Alpha);
				}
				else
				{
					Red = int(Red * Alpha);
					Blue = int(Blue * Alpha);
				}
			}

			if (flLifeTime < AccCashLifeTime / 2)
			{
				if (AccumulateCash < 0)
				{
					int LocalAC = AccumulateCash * -1;
					FullMSG += "\n- " + formatInt(LocalAC) + "$";
				}
				else
				{
					FullMSG += "\n+ " + formatInt(AccumulateCash) + "$";
				}
			}

			HudTextParams pParams;
			pParams.x = 0.025f;
			pParams.y = 0.80999f;
			pParams.channel = 2;
			pParams.holdTime = 0.11f;
			pParams.SetColor(Color(Red, Green, Blue));
			Utils.GameTextPlayer(ToZPPlayer(PlayerIndex), FullMSG, pParams);
		}
	}
}

namespace Radio
{
	enum WepName_Indexes {WN_NAME, WN_CLASS}
	enum RS_Types {RS_CAT, RS_FIREARMS, RS_AMMO}
	enum Menu_Inputs {IP_CLOSE, IP_PREV = 8, IP_NEXT}
	enum MenuData_Indexes {SD_ID, SD_COST, SD_AMOUNT}
	enum MenuSound_Flags {SF_ACCEPT = 1<<1, SF_DENIED = 1<<2, SF_WEPPICK = 1<<3, SF_AMMOPICK = 1<<4, SF_CLOSE = 1<<5}
	const int MAX_ITEMS_ON_PAGE = 7;

	const array<string> pMenuSound = 
	{
		"buttons/button14.wav",
		"buttons/combine_button_locked.wav",
		"HL2Player.PickupWeapon",
		"ZPlayer.AmmoPickup",
		"buttons/combine_button7.wav"
	};

	const array<string> pMenuTitle = 
	{
		"Categories",
		"Weapons",
		"Ammo",
		"Zombie Menu"
	};

	const array<array<string>> pWeaponName =
	{
		{"Glock18c",		"weapon_glock18c"},
		{"Glock",			"weapon_glock"},
		{"USP",				"weapon_usp"},
		{"PPK",				"weapon_ppk"},
		{"AK47",			"weapon_ak47"},
		{"M4",				"weapon_m4"},
		{"MP5",				"weapon_mp5"},
		{"Remington 870",	"weapon_870"},
		{"SuperShorty",		"weapon_supershorty"},
		{"Winchester",		"weapon_winchester"},
		{"Revolver",		"weapon_revolver"},
		{"Shovel",			"weapon_shovel"},
		{"Sledgehammer",	"weapon_sledgehammer"}
	};

	const array<string> pAmmoName = 
	{
		"Pistol",
		"Revovler",
		"Shotgun",
		"Rifle",
		"Barricade"
	};

	const array<array<array<int>>> pMenuData = 
	{
		{
			{1},
			{2}
		},
		{
			{0,150},
			{1,100},
			{2,110},
			{3,50},
			{4,500},
			{5,450},
			{6,300},
			{7,700},
			{8,400},
			{9,250},
			{10,950},
			{11,250},
			{12,2000}
		},
		{
			{0,50,15},
			{1,210,6},
			{2,90,6},
			{3,120,30},
			{4,250,1}
		}
	};

	string GetName(const int nType, const int nIndex)
	{
		switch(nType)
		{
			case RS_CAT: return pMenuTitle[nIndex];
			case RS_FIREARMS: return pWeaponName[nIndex][WN_NAME];
			case RS_AMMO: return pAmmoName[nIndex];
		}
		return "null";
	}

	class Menu
	{
		private int MenuType;
		private int PlayerIndex;
		private int TotalItems;
		private int CurrentPage;
		private int TotalPages;
		private int Start;
		private int Steps;
		private int SoundFlag;
		private float flLifeTime;
		private float flThinkTime;

		GameText::MenuKeyValyes@ pMParams;

		Menu(const int nPlayerIndex, const int nType)
		{
			PlayerIndex = nPlayerIndex;
			MenuType = nType;
			FillMenu(-1);
		}

		Menu(const int nPlayerIndex, const int nType, const int nLifeTime)
		{
			PlayerIndex = nPlayerIndex;
			MenuType = nType;
			FillMenu(nLifeTime);
		}

		private void FillMenu(const int nLifeTime)
		{
			ToZPPlayer(PlayerIndex).SetHudVisibility(false);
			SoundFlag = 0;
			Start = 0;
			CurrentPage = 1;
			flThinkTime = Globals.GetCurrentTime() + 0.089f;
			TotalItems = int(pMenuData[MenuType].length());
			TotalPages = int(ceil(float(TotalItems) / float(MAX_ITEMS_ON_PAGE)));
			
			if (TotalItems > MAX_ITEMS_ON_PAGE)
			{
				Steps = MAX_ITEMS_ON_PAGE;
			}
			else
			{
				Steps = TotalItems;
			}

			UpdateMenu(nLifeTime);
		}

		private void UpdateMenu()
		{
			Start = 7 * CurrentPage - 7;

			if (CurrentPage < TotalPages)
			{
				Steps = MAX_ITEMS_ON_PAGE;
			}
			else if (CurrentPage == TotalPages && CurrentPage * MAX_ITEMS_ON_PAGE > TotalItems)
			{
				Steps = TotalItems - Start;
			}

			UpdateMenu(-1);
		}

		void UpdateMenu(float nLifeTime)
		{
			if (nLifeTime < 0)
			{
				nLifeTime = 15.0f;
			}

			flLifeTime = Globals.GetCurrentTime() + nLifeTime;
			
			@pMParams = GameText::MenuKeyValyes();

			int Num = 0;
			int length = Start + Steps;
			pMParams.Add("title", "-= " + pMenuTitle[MenuType] + " =-");
			pMParams.Add("holdtime", "0.1");
			
			for (int i = Start; i < length; i++)
			{
				string dItem = GetName(MenuType, pMenuData[MenuType][i][SD_ID]);

				if (MenuType > RS_CAT)
				{
					dItem += " - " + formatInt(pMenuData[MenuType][i][SD_COST]) + "$";
				}

				Num++;
				pMParams.Add("item" + formatInt(Num), dItem);
			}

			if (TotalPages > 1)
			{
				if (CurrentPage < TotalPages)
				{
					pMParams.Add("next", "true");
				}
				else if (CurrentPage == TotalPages)
				{
					pMParams.Add("prev", "true");
				}
				else
				{
					pMParams.Add("next", "true");
					pMParams.Add("prev", "true");
				}
			}

			if (flLifeTime == Globals.GetCurrentTime())
			{
				pMParams.Add("fadeout", "0.2");
			}

			GameText::Menu(PlayerIndex, pMParams);
		}

		void Input(const int &in iSlot)
		{
			SoundFlag = 0;

			if (iSlot == IP_CLOSE)
			{
				ExitMenu(false);
			}
			else if (iSlot == IP_NEXT && IsNextPageExist())
			{
				GoToNextPage();
			}
			else if (iSlot == IP_PREV && IsPrevPageExist())
			{
				GoToPrevPage();
			}
			else if (iSlot <= Steps)
			{
				Select(Start + iSlot - 1);
			}

			PlaySound();
		}

		void Select(const int iItemIndex)
		{
			CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
			int iPlrCash = Array_VooDoo[PlayerIndex].cash;

			if (MenuType == RS_CAT)
			{
				Array_VooDoo[PlayerIndex].AddMenu(Radio::Menu(PlayerIndex, pMenuData[MenuType][iItemIndex][0]));
				SoundFlag = SF_ACCEPT;
			}
			else
			{
				if (Array_VooDoo[PlayerIndex].cash < pMenuData[MenuType][iItemIndex][SD_COST])
				{
					SD("Мало денег!");
					SoundFlag = SF_DENIED;
				}
				else
				{
					if (MenuType == RS_FIREARMS)
					{
						Array_VooDoo[PlayerIndex].cash -= pMenuData[MenuType][iItemIndex][SD_COST];
						pPlayer.GiveWeapon(pWeaponName[pMenuData[MenuType][iItemIndex][SD_ID]][WN_CLASS]);
						Array_VooDoo[PlayerIndex].pCash.CheckCash();
						SoundFlag = SF_ACCEPT + SF_WEPPICK;
						GameText::Menu(PlayerIndex, pMParams);

						if (!(pMenuData[MenuType][iItemIndex][SD_ID] == 12 || pMenuData[MenuType][iItemIndex][SD_ID] == 11))
						{
							Array_VooDoo[PlayerIndex].AddMenu(Radio::Menu(PlayerIndex, RS_AMMO));
						}
						else
						{
							ExitMenu(true);
						}
					}
					else if (MenuType == RS_AMMO)
					{
						AmmoBankSetValue iAmmoType = AmmoBankSetValue(pMenuData[MenuType][iItemIndex][SD_ID]);
						bool SoldOut = pPlayer.AmmoBank(add, iAmmoType, pMenuData[MenuType][iItemIndex][SD_AMOUNT]);
						if (SoldOut)
						{
							SoundFlag = SF_ACCEPT;

							if (pMenuData[MenuType][iItemIndex][SD_ID] == 4)
							{
								SoundFlag += SF_WEPPICK;
							}
							else
							{
								SoundFlag += SF_AMMOPICK;
							}

							Array_VooDoo[PlayerIndex].cash -= pMenuData[MenuType][iItemIndex][SD_COST];
							Array_VooDoo[PlayerIndex].pCash.CheckCash();
							GameText::Menu(PlayerIndex, pMParams);
						}
						else
						{
							SoundFlag = SF_DENIED;
							SD("Нет свободного места!");
						}
					}
				}
			}
		}

		void ExitMenu(bool bSilent)
		{
			if (!bSilent)
			{
				SoundFlag = SF_CLOSE;
			}

			pMParams.Update("holdtime", "0.0");
			pMParams.Update("fadeout", "0.15");
			GameText::Menu(PlayerIndex, pMParams);
			ToZPPlayer(PlayerIndex).SetHudVisibility(true);
			Array_VooDoo[PlayerIndex].ExitMenu();
		}

		private void PlaySound()
		{
			for (int i = 1; i <= 5; i++)
			{
				if (cSoundFlag(1<<i))
				{
					if (i == 2 || i == 3)
					{
						Engine.EmitSoundEntity(FindEntityByEntIndex(PlayerIndex), pMenuSound[i - 1]);
						continue;
					}
					Engine.EmitSoundPlayer(ToZPPlayer(PlayerIndex), pMenuSound[i - 1]);
				}
			}
		}

		private bool IsNextPageExist()
		{
			return (CurrentPage < TotalPages && TotalPages > 1);
		}

		private bool IsPrevPageExist()
		{
			return (CurrentPage != 1 && TotalPages > 1);
		}

		private bool cSoundFlag (int &in iTargetFlag)
		{
			return SoundFlag & iTargetFlag == iTargetFlag;
		}

		private void GoToNextPage()
		{
			SoundFlag = SF_ACCEPT;
			CurrentPage++;
			UpdateMenu();
			UpdateMenu(-1);
		}

		private void GoToPrevPage()
		{
			SoundFlag = SF_ACCEPT;
			CurrentPage--;
			UpdateMenu();
			UpdateMenu(-1);
		}

		void Think()
		{
			if (flThinkTime <= Globals.GetCurrentTime() && pMParams !is null)
			{
				flThinkTime = Globals.GetCurrentTime() + 0.089f;
				GameText::Menu(PlayerIndex, pMParams);
			}

			if (flLifeTime <= Globals.GetCurrentTime())
			{
				ExitMenu(false);
				PlaySound();
			}
		}
	}	
}