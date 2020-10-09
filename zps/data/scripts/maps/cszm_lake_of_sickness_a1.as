#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iMaxPlayers;
float flWaitBeforeCollect = 0;

//------------------------------------------------------------------------
//Spawns SetUp
//------------------------------------------------------------------------

array<array<CSpawnPoint@>> PrimarySpawns =
{
	{
		CSpawnPoint(Vector(-939.246, 82.4492, -159.96), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1003.53, -6.06772, -159.96), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-977.687, -135.626, -156.757), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-876.31, -208.785, -153.535), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-799.806, -111.058, -159.45), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-822.244, -8.56953, -159.969), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-801.871, 70.0544, -159.969), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-729.083, -63.5339, -159.814), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-724.397, -215.073, -153.172), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1070.68, -198.609, -149.023), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1120.21, -95.9159, -159.73), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1108.82, 20.6364, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-1109.22, 85.4009, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-702.232, 17.1355, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-559.257, 77.6257, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-513.015, -47.7739, -159.964), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-566.524, -173.975, -153.728), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-654.145, -121.378, -159.196), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-633.67, 0.79066, -159.966), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-449.188, 38.6767, -159.966), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-406.699, -69.1795, -159.399), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-409.403, -194.431, -154.122), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-353.532, 38.3529, -159.953), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-249.355, -145.547, -156.83), QAngle(0, -2.75542, 0)),
		CSpawnPoint(Vector(-173.351, 24.6575, -159.969), QAngle(0, -2.75542, 0))
	},
	{
		CSpawnPoint(Vector(-857.994, 487.579, -110.969), QAngle(1.19788, 90.2354, 0)),
		CSpawnPoint(Vector(-865.056, 756.825, -110.969), QAngle(0.653375, -87.8887, 0)),
		CSpawnPoint(Vector(-313.391, 795.06, -110.969), QAngle(0.145173, -87.4896, 0)),
		CSpawnPoint(Vector(-284.172, 540.803, -110.969), QAngle(-1.19792, 100.703, -0)),
		CSpawnPoint(Vector(-553.866, 575.304, -110.969), QAngle(30.492, 111.303, 0)),
		CSpawnPoint(Vector(-1079.49, -1447.98, -150.969), QAngle(18.9848, -147.965, 0)),
		CSpawnPoint(Vector(-887.405, -1688.99, -150.969), QAngle(3.66623, 139.313, 0)),
		CSpawnPoint(Vector(-302.151, -1637.24, -22.9688), QAngle(2.21422, 124.77, 0)),
		CSpawnPoint(Vector(-507.546, -1390.99, -22.9688), QAngle(4.10181, -15.3847, 0)),
		CSpawnPoint(Vector(-835.109, -1328.56, -22.9688), QAngle(30.9275, -123.909, 0)),
		CSpawnPoint(Vector(1279.51, -1382.68, -102.969), QAngle(3.12167, 150.592, 0)),
		CSpawnPoint(Vector(1467.6, -1174.97, -102.969), QAngle(15.5, 123.439, 0)),
		CSpawnPoint(Vector(1688.31, -1205.31, -102.969), QAngle(15.8267, 45.1764, 0)),
		CSpawnPoint(Vector(1757.38, -1475.13, -102.969), QAngle(16.3711, -146.573, 0)),
		CSpawnPoint(Vector(1407.3, -1567.76, -102.969), QAngle(5.59002, 47.4274, 0)),
		CSpawnPoint(Vector(1496.9, 444.6, -118.969), QAngle(13.213, -145.035, 0)),
		CSpawnPoint(Vector(1201.47, 447.179, -118.969), QAngle(9.83713, -40.2008, 0)),
		CSpawnPoint(Vector(1286.17, 895.957, -151.878), QAngle(-0.0727746, -81.2327, 0)),
		CSpawnPoint(Vector(1301.76, 712.652, 612.031), QAngle(20.1099, 154.73, 0)),
		CSpawnPoint(Vector(1153.03, 890.065, 612.031), QAngle(34.5937, -167.155, 0)),
		CSpawnPoint(Vector(-866.478, 321.969, 49.0313), QAngle(28.7856, 60.0964, 0)),
		CSpawnPoint(Vector(-629.439, -1563.21, -22.9687), QAngle(0.471637, 118.285, 0)),
		CSpawnPoint(Vector(1155.31, -1204.69, -146.969), QAngle(-7.29658, -29.4326, -0)),
		CSpawnPoint(Vector(1345.61, 438.867, -118.969), QAngle(10.3452, -128.858, 0)),
		CSpawnPoint(Vector(239.298, -166.818, -156.408), QAngle(14.665, -163.343, 0))
	},
	{
		CSpawnPoint(Vector(-907.622, 307.757, 49.0313), QAngle(7.11455, 43.6393, 0)),
		CSpawnPoint(Vector(-444.298, 355.996, 49.0313), QAngle(15.4998, 139.762, 0)),
		CSpawnPoint(Vector(-481.508, 820.018, 49.0313), QAngle(9.07474, -78.8368, 0)),
		CSpawnPoint(Vector(-25.1232, 980.693, -110.969), QAngle(2.94012, -159.241, 0)),
		CSpawnPoint(Vector(-30.3014, 338.42, -110.969), QAngle(2.50452, 163.152, 0)),
		CSpawnPoint(Vector(-380.226, -1632.66, -22.9688), QAngle(16.3348, -109.002, 0)),
		CSpawnPoint(Vector(-531.032, -1445.88, -22.9688), QAngle(5.44481, 161.047, 0)),
		CSpawnPoint(Vector(-340.827, -1375.13, -22.9688), QAngle(23.2681, 35.2672, 0)),
		CSpawnPoint(Vector(-1103.12, -1328.68, -22.9688), QAngle(6.09818, -53.1601, 0)),
		CSpawnPoint(Vector(-829.272, -1304.86, -22.9688), QAngle(5.51737, -117.919, 0)),
		CSpawnPoint(Vector(-946.012, -1666.76, -150.969), QAngle(-13.9031, 98.4776, 0)),
		CSpawnPoint(Vector(-914.344, 1001.47, -110.969), QAngle(-11.7251, -44.3265, 0)),
		CSpawnPoint(Vector(1451.28, -1083.91, -102.969), QAngle(1.37921, -70.1357, 0)),
		CSpawnPoint(Vector(1456.94, -1273.02, -102.969), QAngle(3.88391, 69.1473, 0)),
		CSpawnPoint(Vector(1634.26, -1267.29, -102.969), QAngle(3.412, 58.5115, 0)),
		CSpawnPoint(Vector(1701.17, -1087.95, -102.969), QAngle(7.40502, -49.953, 0)),
		CSpawnPoint(Vector(1701.08, -1485.36, -102.969), QAngle(-22.7966, -63.4201, 0)),
		CSpawnPoint(Vector(1480.28, -1486.99, -102.969), QAngle(28.459, -55.7971, 0)),
		CSpawnPoint(Vector(1167.55, 451.254, -118.969), QAngle(19.1299, 153.001, 0)),
		CSpawnPoint(Vector(1222.85, 386.622, -118.969), QAngle(2.64968, 9.23954, 0)),
		CSpawnPoint(Vector(1490.86, 462.507, -118.969), QAngle(12.9226, -146.415, 0)),
		CSpawnPoint(Vector(1317.94, 841.479, 612.031), QAngle(13.7574, -66.1063, 0)),
		CSpawnPoint(Vector(1402.71, 741.528, 612.031), QAngle(8.748, 171.635, 0)),
		CSpawnPoint(Vector(1454.58, 625.009, 612.031), QAngle(26.3535, -126.328, 0)),
		CSpawnPoint(Vector(1495.23, 123.7, -162.969), QAngle(5.04536, -126.401, 0))
	}
};

array<array<CSpawnPoint@>> SecondarySpawns =
{
	{
		CSpawnPoint(Vector(756.267, -655.652, -313.832), QAngle(-7.55071, 51.2638, -0)),
		CSpawnPoint(Vector(440.164, -594.631, -308.089), QAngle(-7.98631, -142.482, -0)),
		CSpawnPoint(Vector(611.927, -221.94, -305.249), QAngle(-12.669, 144.373, 0)),
		CSpawnPoint(Vector(-45.9514, -194.779, -151.493), QAngle(-11.9067, 116.495, 0)),
		CSpawnPoint(Vector(-1479.01, 76.8038, -159.969), QAngle(-12.5601, 27.3056, 0)),
		CSpawnPoint(Vector(-1607.81, -673.054, -284.475), QAngle(3.0852, 0.98807, -0)),
		CSpawnPoint(Vector(-1595.89, -831.545, -277.935), QAngle(-6.6795, 17.5772, 0)),
		CSpawnPoint(Vector(-1646.86, -1809.98, -99.9035), QAngle(-2.90432, 37.3245, 0)),
		CSpawnPoint(Vector(-1449.83, -2062.27, -102.341), QAngle(-7.87742, 48.1782, 0)),
		CSpawnPoint(Vector(48.2263, -1911.21, -152.947), QAngle(3.15778, 110.614, -0)),
		CSpawnPoint(Vector(673.228, -2053.12, -99.3184), QAngle(6.60629, 94.6785, 0)),
		CSpawnPoint(Vector(1023.52, -1968.63, -103.785), QAngle(8.82059, 56.9265, 0)),
		CSpawnPoint(Vector(2164.29, -1785.36, -159.877), QAngle(-9.51089, 116.785, 0)),
		CSpawnPoint(Vector(1911.63, -1976.11, -159.969), QAngle(-5.9172, 127.99, 0)),
		CSpawnPoint(Vector(2169.72, -479.436, -98.8482), QAngle(9.4014, -159.398, 0)),
		CSpawnPoint(Vector(2108.98, -64.0316, -99.1018), QAngle(5.481, 143.756, 0)),
		CSpawnPoint(Vector(2049.23, 965.27, -284.035), QAngle(-15.3552, -124.659, 0)),
		CSpawnPoint(Vector(1698.46, 1347.15, -283.917), QAngle(-8.89382, -123.751, 0)),
		CSpawnPoint(Vector(903.138, 1272.88, -285.06), QAngle(-9.83762, -59.827, 0)),
		CSpawnPoint(Vector(666.587, 622.028, -277.955), QAngle(-11.4711, -42.5482, -0))
	},
	{
		CSpawnPoint(Vector(597.983, -683.697, -297.714), QAngle(-9.22052, -147.722, -0)),
		CSpawnPoint(Vector(430.705, -518.084, -284.521), QAngle(-12.1245, 151.548, 0)),
		CSpawnPoint(Vector(654.79, -365.861, -316.091), QAngle(-12.8142, 48.2022, 0)),
		CSpawnPoint(Vector(891.196, -587.769, -301.562), QAngle(-8.60342, -29.2257, 0)),
		CSpawnPoint(Vector(937.727, -429.792, -308.759), QAngle(-12.9957, 45.842, -0)),
		CSpawnPoint(Vector(767.864, -691.306, -314.989), QAngle(-11.9067, -105.904, -0)),
		CSpawnPoint(Vector(233.411, -726.25, -309.776), QAngle(-21.0543, -133.02, -0)),
		CSpawnPoint(Vector(161.487, -596.29, -302.588), QAngle(-13.1409, 117.971, -0)),
		CSpawnPoint(Vector(832.492, -201.652, -305.789), QAngle(-12.0882, 36.9857, -0)),
		CSpawnPoint(Vector(655.177, -551.688, -295.316), QAngle(-8.63968, -168.086, 0))
	}
};

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
	WindowBlocker::RegisterEnts();

	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
	flWaitBeforeCollect = Globals.GetCurrentTime() + 0.05f;
}

void OnMatchBegin()
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SecondarySpawns, false);
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

void SetUpStuff()
{
	PlayLobbyAmbient();
	CreateSpawnsFromArray(PrimarySpawns, true);
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

				CBaseEntity@ pBlock = EntityCreator::Create(GetBlockClassname(Type), Origin, QAngle(0, 0, 0), InputData);
				EntIndex = pBlock.entindex();
				pBlock.SetEntityDescription(formatInt(Type));

				if (MaterialType > MAT_NONE)
				{
					Engine.EmitSoundEntity(FindEntityByEntIndex(ButtonIndex), WindSetUpSND[MaterialType]);
				}

				if (Type == WT_SHUTTER)
				{
					Engine.Ent_Fire_Ent(pBlock, "addoutput", "origin " + Origin.x + " " + Origin.y + " " + (Origin.z - OriginOffset));
				}

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