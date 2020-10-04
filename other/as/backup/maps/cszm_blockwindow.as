//	CBasePlayer@ pPlayerBase = pPlayer.opCast();
//	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

void DebugCall(NetObject@ pData)
{
	if (pData is null)
	{
		return;
	}

	if (pData.HasIndexValue(0))
	{
		Schedule::Task(0.0f, pData.GetString(0));
	}
}

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iMaxPlayers;
float flWaitBeforeCollect = 0;

//------------------------------------------------------------------------
//NetData/Funcs
//------------------------------------------------------------------------

void CallMapPurchase(const string &in nFuncName, const int &in nPlrIndex, const int &in nCost, const int &in nWinIndex)
{
	NetData PurchaseData;
	PurchaseData.Write(nFuncName);
	PurchaseData.Write(nPlrIndex);
	PurchaseData.Write(nCost);
	PurchaseData.Write(nWinIndex);

	Network::CallFunction("MapPurchase", PurchaseData);
}

void BlockWindow(NetObject@ pData)
{
	if (pData is null)
	{
		return;
	}

	if (pData.HasIndexValue(0))
	{
		WindowBlocker::Array_Window[pData.GetInt(0)].CreateBlock();
	}
}

//------------------------------------------------------------------------
//FORWARDS
//------------------------------------------------------------------------

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();
	WindowBlocker::FillImputData();
	Entities::RegisterUse("func_button");
	Entities::RegisterUse("func_door");

	flWaitBeforeCollect = Globals.GetCurrentTime() + 0.05f;
}

void OnNewRound()
{
	flWaitBeforeCollect = Globals.GetCurrentTime() + 0.05f;
}

void OnProcessRound()
{
	WindowBlocker::Think();

	if (flWaitBeforeCollect <= Globals.GetCurrentTime() && flWaitBeforeCollect != 0)
	{
		flWaitBeforeCollect = 0;
		WindowBlocker::CollectWindows();
	}
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	WindowBlocker::OnFuncUsed(pPlayer, pEntity);
}

//------------------------------------------------------------------------
//Window Blocker Funcs
//------------------------------------------------------------------------

namespace WindowBlocker
{
	//------------------------------------------------------------------------
	//DATA
	//------------------------------------------------------------------------
	enum eWindowMaterialTypes {MAT_NONE, MAT_METAL, MAT_ROCK, MAT_WOOD}
	enum eWindowTypes {WT_OTHER, WT_BLOCK, WT_BARRICADE, WT_SHUTTER}
	enum eWindowConds {WC_WATING, WC_LISTEN, WC_EXIST}
	enum eWindowArgs {WA_INDEX, WA_TYPE, WA_MAT, WA_OFFSET}

	float WaitTime = 0.0f;
	float CostMultiplier = 1.0f;
	float ButtonDist = 145.0f;
	bool IsWindowsCollected = false;
	array<CEntityData@> gBlocksIPD;

	const array<string> WindMaterialTypes = 
	{
		"none",
		"metal",
		"rock",
		"wood"
	};
	const array<string> WindSetUpSND =
	{
		"Default.Null",
		"SolidMetal.ImpactHard",
		"Concrete_Block.ImpactHard",
		"Wood.ImpactHard"
	};
	const array<string> WindTypes = 
	{
		"other",
		"block",
		"barricade",
		"shutter"
	};
	const array<string> WindBeaconLabels = 
	{
		"Create block",
		"Lock it down",
		"Create barricade",
		"Create shutter"
	};

	CEntityData@ GetINputData(int &in iType)
	{
		if (iType < 0 || iType > int(gBlocksIPD.length()))
		{
			iType = 0;
		}

		CEntityData@ nIPD = gBlocksIPD[iType];

		return nIPD;
	}

	string GetBlockClassname(const int &in iType)
	{
		return (iType < WT_SHUTTER) ? "func_breakable" : "func_door";;
	}

	int GetBlockType(const string &in sType)
	{
		int iResult = WindTypes.find(sType);
		if (iResult == -1)
		{
			iResult = 0;
		}

		return iResult;
	}

	int GetMatType(const string &in sType)
	{
		int iResult = WindMaterialTypes.find(sType);
		if (iResult == -1)
		{
			iResult = 0;
		}

		return iResult;
	}

	bool IsIntersectPlayer(CBaseEntity@ pEntity)
	{
		bool IsIntersect = false;
		CBaseEntity@ pPlayerEntity = null;

		for (int i = 1; i <= iMaxPlayers; i++)
		{
			@pPlayerEntity = FindEntityByEntIndex(i);

			if (pPlayerEntity is null)
			{
				continue;
			}

			if (pEntity.Intersects(pPlayerEntity))
			{
				IsIntersect = true;
				break;
			}
		}

		return IsIntersect;
	}

	//------------------------------------------------------------------------
	//FUNCS
	//------------------------------------------------------------------------

	void RegisterEnts()
	{
		Entities::RegisterUse("func_button");
		Entities::RegisterUse("func_door");
		Entities::RegisterBreak("func_breakable");
		Engine.PrecacheFile(sound, "items/weaponappear/weaponappear.wav");
	}

	void CollectWindows()
	{
		CBaseEntity@ pEntity = null;
		int iLength = 0;
		if (!IsWindowsCollected)
		{
			IsWindowsCollected = true;
			array<Window@> PrepearWindows;
			while ((@pEntity = FindEntityByClassname(pEntity, "func_button")) !is null)
			{
				if (Utils.StrContains("button:", pEntity.GetEntityName()))
				{
					PrepearWindows.insertLast(Window(pEntity));
					pEntity.SUB_Remove();
				}
			}

			iLength = int(PrepearWindows.length());
			Array_Window.resize(iLength + 1);
			for (int i = 0; i < iLength; i++)
			{
				@Array_Window[PrepearWindows[i].Index] = PrepearWindows[i];
			}
		}
		else
		{
			while ((@pEntity = FindEntityByClassname(pEntity, "func_button")) !is null)
			{
				if (Utils.StrContains("button:", pEntity.GetEntityName()))
				{
					pEntity.SUB_Remove();
				}
			}

			iLength = int(Array_Window.length());
			for (int i = 1; i < iLength; i++)
			{
				Array_Window[i].Reset();
			}
		}
	}

	void Think()
	{
		if (WaitTime <= Globals.GetCurrentTime())
		{
			WaitTime = Globals.GetCurrentTime() + 0.25f;
			for (uint w = 1; w < Array_Window.length(); w++)
			{
				if (Array_Window[w] is null)
				{
					continue;
				}

				if (Array_Window[w].Condition == WC_EXIST || Array_Window[w].EntIndex > 0)
				{
					continue;
				}

				bool IsPlayerClose = false;
				for (int i = 1; i <= iMaxPlayers; i++)
				{
					CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

					if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() != 2)
					{
						continue;
					}

					if (pPlayerEntity.Distance(Array_Window[w].Origin) <= ButtonDist)
					{
						IsPlayerClose = true;
						break;
					}
				}

				if (IsPlayerClose)
				{
					Array_Window[w].CreateButton();
				}
				else
				{
					Array_Window[w].KillButton();
				}
			}
		}
	}

	void FillImputData()
	{
		gBlocksIPD.resize(4);
		for(int i = 0; i < 4; i++)
		{
			@gBlocksIPD[i] = EntityCreator::EntityData();
		}

		gBlocksIPD[0].Add("material", "2");
		gBlocksIPD[0].Add("health", "0");
		gBlocksIPD[0].Add("spawnflags", "3073");
		@gBlocksIPD[1] = gBlocksIPD[0];

		gBlocksIPD[2].Add("targetname", "barricade_window");
		gBlocksIPD[2].Add("material", "1");
		gBlocksIPD[2].Add("spawnflags", "0");
		gBlocksIPD[2].Add("health", "750");

		gBlocksIPD[3].Add("spawnflags", "288"); //2304
		gBlocksIPD[3].Add("health", "0");
		gBlocksIPD[3].Add("lip", "0.35");
		gBlocksIPD[3].Add("movedir", "90 0 0");
		gBlocksIPD[3].Add("forceclosed", "1");
		gBlocksIPD[3].Add("dmg", "1");
		gBlocksIPD[3].Add("startclosesound", "doors/door_metal_thin_move1.wav");
		gBlocksIPD[3].Add("closesound", "doors/door_metal_thin_close2.wav");
		gBlocksIPD[3].Add("noise1", "doors/door_metal_thin_move1.wav");
		gBlocksIPD[3].Add("noise2", "doors/door_metal_thin_close2.wav");
		gBlocksIPD[3].Add("locked_sound", "npc/combine_soldier/vo/_comma.wav");
		gBlocksIPD[3].Add("spawnpos", "1");
		gBlocksIPD[3].Add("rendermode", "2");
		gBlocksIPD[3].Add("renderamt", "0");
		gBlocksIPD[3].Add("alpha", "255", true, "0.01");
		gBlocksIPD[3].Add("close", "0", true, "0.01");
		gBlocksIPD[3].Add("lock", "0", true, "0.02");
	}

	void OnFuncUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
	{
		CBasePlayer@ pPlayerBase = pPlayer.opCast();
		CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

		if (Utils.StrEql("func_button", pEntity.GetClassname(), true) && Utils.StrEql("button_window", pEntity.GetEntityName(), true))
		{
			int WindowIndex = pEntity.GetHealth();
			if (Array_Window[WindowIndex] !is null)
			{
				if (IsIntersectPlayer(pEntity))
				{
					Engine.EmitSoundPlayer(pPlayer, "buttons/combine_button_locked.wav");
					Chat.PrintToChatPlayer(pPlayerBase, "{red}*{gold}Кто-то мешает закрыть проход!");
				}
				else
				{
					CallMapPurchase("BlockWindow", pPlayerEntity.entindex(), Array_Window[WindowIndex].Cost, WindowIndex);
				}
			}
		}
		else if (Utils.StrEql("func_door", pEntity.GetClassname(), true) && pPlayerEntity.GetTeamNumber() == 2)
		{
			Engine.Ent_Fire_Ent(pEntity, "unlock", "", "0.00");
			Engine.Ent_Fire_Ent(pEntity, "toggle", "", "0.01");
			Engine.Ent_Fire_Ent(pEntity, "lock", "", "0.02");
		}
	}

	//------------------------------------------------------------------------
	//Window Stuff
	//------------------------------------------------------------------------

	array<Window@> Array_Window;

	class Window
	{
		int EntIndex;
		int Index;
		int Type;
		int MaterialType;
		int Cost;
		int Condition;
		string Model;
		Vector Origin;
		float OriginOffset;

		int ButtonIndex;
		int BeaconIndex;

		Window(CBaseEntity@ pWindowEntity)
		{
			CASCommand@ pSplited = StringToArgSplit(pWindowEntity.GetEntityName(), ":"); 
			@pSplited = StringToArgSplit(pSplited.Arg(1), ";");
			EntIndex = -1;
			ButtonIndex = -1;
			BeaconIndex = -1;

			Index = Utils.StringToInt(pSplited.Arg(WA_INDEX));
			Type = GetBlockType(pSplited.Arg(WA_TYPE));
			MaterialType = GetMatType(pSplited.Arg(WA_MAT));
			OriginOffset = Utils.StringToFloat(pSplited.Arg(WA_OFFSET));
			Cost = int(ceil(pWindowEntity.GetHealth() * CostMultiplier));
			Model = pWindowEntity.GetModelName();
			Origin = pWindowEntity.GetAbsOrigin();

			Condition = WC_WATING;
		}

		void Reset()
		{
			EntIndex = -1;
			ButtonIndex = -1;
			BeaconIndex = -1;
			Condition = WC_WATING;
		}

		void CreateBlock()
		{
			if (Condition == WC_LISTEN)
			{
				Condition = WC_EXIST;
				CEntityData@ InputData = GetINputData(Type);
				InputData.Add("origin", "" + Origin.x + " " + Origin.y + " " + Origin.z);
				InputData.Add("model", Model);

				if (Type == WT_SHUTTER)
				{
					InputData.Add("addoutput", "origin " + Origin.x + " " + Origin.y + " " + (Origin.z - OriginOffset), true, "0.00");
				}

				if (MaterialType > MAT_NONE)
				{
					Engine.EmitSoundEntity(FindEntityByEntIndex(ButtonIndex), WindSetUpSND[MaterialType]);
				}

				CBaseEntity@ pBlock = EntityCreator::Create(GetBlockClassname(Type), Origin, QAngle(0, 0, 0), InputData);
				@InputData is null;
				EntIndex = pBlock.entindex();
				pBlock.SetEntityDescription(formatInt(Type));

				Engine.EmitSoundPosition(ButtonIndex, "items/weaponappear/weaponappear.wav", Origin, 1, 65, 95);
				RemoveButton();
			}
		}

		void CreateButton()
		{
			if (Condition == WC_WATING)
			{
				Condition = WC_LISTEN;
				CEntityData@ InputData = EntityCreator::EntityData();
				InputData.Add("targetname", "button_window");
				InputData.Add("filterteam", "2");
				InputData.Add("nonsolid", "1");
				InputData.Add("renderamt", "0");
				InputData.Add("rendermode", "10");
				InputData.Add("spawnflags", "1057");
				InputData.Add("origin", "" + Origin.x + " " + Origin.y + " " + Origin.z);

				CBaseEntity@ pButton = EntityCreator::Create("func_button", Origin, QAngle(0, 0, 0), InputData);
				pButton.SetHealth(Index);
				ButtonIndex = pButton.entindex();

				@InputData = EntityCreator::EntityData();
				InputData.Add("customicons", "1");
				InputData.Add("displayteam", "2");
				InputData.Add("distance", "" + ButtonDist);
				InputData.Add("startactive", "1");
				InputData.Add("human_icon", "vgui/images/emptyimage");
				InputData.Add("zombie_icon", "vgui/images/emptyimage");
				InputData.Add("survivorlabel", "| " + WindBeaconLabels[Type] + " - " + formatInt(Cost) + "$ |");

				CBaseEntity@ pBeacon = EntityCreator::Create("info_beacon", Origin - Vector(0, 0, 16), QAngle(0, 0, 0), InputData);
				BeaconIndex = pBeacon.entindex();
			}
		}

		void KillButton()
		{
			if (Condition == WC_LISTEN)
			{
				Condition = WC_WATING;
				RemoveButton();
			}
		}

		private void RemoveButton()
		{
			CBaseEntity@ pButton = FindEntityByEntIndex(ButtonIndex);
			CBaseEntity@ pBeacon = FindEntityByEntIndex(BeaconIndex);

			if (pButton !is null)
			{
				ButtonIndex = -1;
				pButton.SUB_Remove();
			}

			if (pBeacon !is null)
			{
				BeaconIndex = -1;
				pBeacon.SUB_Remove();
			}
		}
	}
}

//------------------------------------------------------------------------
//END
//------------------------------------------------------------------------