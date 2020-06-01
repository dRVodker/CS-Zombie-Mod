#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

array<array<CSpawnPoint@>> LilaPanic_Spawns =
{
	{ 
		CSpawnPoint(Vector(220.033, 353.216, -15.6758)),
		CSpawnPoint(Vector(137.999, 451.719, -26.5645)),
		CSpawnPoint(Vector(-15.8676, 272.031, 0.03125)),
		CSpawnPoint(Vector(-85.0366, 421.796, -23.8358)),
		CSpawnPoint(Vector(-233.28, 491.414, -16.5886)),
		CSpawnPoint(Vector(-252.021, 344.16, -10.751)),
		CSpawnPoint(Vector(-262.527, 557.142, 0.03125)),
		CSpawnPoint(Vector(-296.32, 261.339, 0.03125)),
		CSpawnPoint(Vector(191.65, 575.458, 0.03125)),
		CSpawnPoint(Vector(229.572, 273.143, 0.03125)),
		CSpawnPoint(Vector(415.321, 472.96, -16.9434)),
		CSpawnPoint(Vector(411.718, 321.621, -23.9989)),
		CSpawnPoint(Vector(769.578, -2.2591, -11.1434), QAngle(25.3011, -135.121, 0)),
		CSpawnPoint(Vector(492.976, -301.617, -37.4048), QAngle(-26.6443, -66.0421, 0)),
		CSpawnPoint(Vector(302.361, -646.933, -15.7145), QAngle(10.3091, 26.7046, 0)),
		CSpawnPoint(Vector(778.527, -868.421, 412.031), QAngle(35.9731, 145.237, 0)),
		CSpawnPoint(Vector(-354.505, -343.678, -13.543), QAngle(14.048, 127.087, 0)),
		CSpawnPoint(Vector(-686.873, -209.036, -32.9034), QAngle(3.12166, 6.93392, 0)),
		CSpawnPoint(Vector(-660.848, 37.9535, -26.5589), QAngle(5.66265, -52.5255, 0)),
		CSpawnPoint(Vector(-868.293, 744.445, 0.03125), QAngle(0.834755, -38.9855, 0)),
		CSpawnPoint(Vector(-669.887, 881.331, 0.03125), QAngle(7.91326, -101.93, 0)),
		CSpawnPoint(Vector(-325.869, -68.6789, 0.03125), QAngle(24.1757, 54.8139, 0)),
		CSpawnPoint(Vector(895.969, 885.758, 0.03125), QAngle(-16.7707, -133.959, 0)),
		CSpawnPoint(Vector(755.716, 757.057, -3.7192), QAngle(4.71884, -74.8991, 0)),
	},
	{
		CSpawnPoint(Vector(635.931, 1110.52, -127.969), QAngle(20.4006, 177.712, 0)),
		CSpawnPoint(Vector(471.466, 1352.03, -127.969), QAngle(4.24708, 40.462, 0)),
		CSpawnPoint(Vector(521.91, 1534.97, -127.969), QAngle(2.14166, -92.2873, 0)),
		CSpawnPoint(Vector(609.25, 1369.28, -127.969), QAngle(19.5656, 26.1596, 0)),
		CSpawnPoint(Vector(667.58, 1509.8, -127.969), QAngle(-0.580899, 123.335, 0)),
		CSpawnPoint(Vector(607.119, 1632.65, -127.969), QAngle(28.5317, 50.9528, 0)),
		CSpawnPoint(Vector(550.353, 1703.09, -127.969), QAngle(10.7447, -63.042, 0)),
		CSpawnPoint(Vector(771.455, 1480.29, -127.969), QAngle(1.23412, 166.859, 0)),
		CSpawnPoint(Vector(806.784, 1641.9, -127.969), QAngle(-0.145275, -177.024, 0)),
		CSpawnPoint(Vector(-281.062, 1484.67, -255.969), QAngle(8.31268, -131.939, 0)),
		CSpawnPoint(Vector(-149.869, 1433.21, -255.969), QAngle(7.47779, -121.57, 0)),
		CSpawnPoint(Vector(-221.439, 1521.79, -255.969), QAngle(2.46839, 33.008, 0)),
		CSpawnPoint(Vector(206.156, 1297.67, -255.969), QAngle(8.45784, -57.4879, 0)),
		CSpawnPoint(Vector(237.909, 1486.33, -255.969)),
		CSpawnPoint(Vector(-437.737, 1469.82, -255.969)),
		CSpawnPoint(Vector(-852.774, 1886.77, -255.969)),
		CSpawnPoint(Vector(-903.905, 1260.96, -255.969)),
		CSpawnPoint(Vector(-402.814, 848.632, -255.969)),
		CSpawnPoint(Vector(386.033, 941.346, -255.969)),
	},
	{
		CSpawnPoint(Vector(-192.051, 429.092, -26.7485), QAngle(-0.0363, 90, 0)),
		CSpawnPoint(Vector(0.00457764, 432, -23.3661), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(192.005, 432, -28.2612), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-96, 496, -12.2286), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-128.444, 430.935, -23.4369), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(96, 496, -14.1861), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-32, 496, -12.2286), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(224.005, 352, -14.1861), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-95.9954, 352, -18.5061), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(32, 496, -12.2286), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-223.995, 352, -10.4061), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-224, 496, -14.1861), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(160.005, 352, -14.1861), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(64.087, 431.366, -25.62), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(224, 496, -14.1861), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(128.095, 431.457, -28.5595), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-63.9954, 432, -20.8686), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-31.9954, 352, -16.2787), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(32.0046, 352, -16.2787), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(-160, 496, -12.2286), QAngle(0, -90, 0)),
		CSpawnPoint(Vector(-255.995, 432, -25.9986), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(-159.995, 352, -12.2286), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(96.0046, 352, -14.1861), QAngle(0, 90, 0)),
		CSpawnPoint(Vector(160, 496, -16.2787), QAngle(0, -90, 0)),
	}
};

array<array<CSpawnPoint@>> LilaPanic_ZombieSpawn =
{
	{
		CSpawnPoint(Vector(-1366.65, 397.243, -119.969), "info_player_zombie"), 
		CSpawnPoint(Vector(-1368.57, 585.057, -119.969), "info_player_zombie"), 
		CSpawnPoint(Vector(-1338.11, 509.419, -119.969), "info_player_zombie")
	}
};

enum Teams {TEAM_LOBBYGUYS, TEAM_SPECTATORS, TEAM_SURVIVORS}

int iMaxPlayers;

CBrushDoor@ pCDoor1;
CBrushDoor@ pCDoor2;

class CBrushDoor
{
	CBaseEntity@ pDoorEntity;
	CBaseEntity@ pButtonEntity;
	int iDoorIndex;
	bool bAllowUse;

	CBrushDoor(int EntIndex, CBaseEntity@ pDoor, CBaseEntity@ pButton)
	{
		@pDoorEntity = pDoor;
		@pButtonEntity = pButton;
		iDoorIndex = EntIndex;
		bAllowUse = true;
	}

	void Toggle()
	{
		if (bAllowUse)
		{
			bAllowUse = false;
			Engine.Ent_Fire_Ent(pDoorEntity, "Toggle");
		}
	}

	void UpdateButton()
	{
		pButtonEntity.SetAbsAngles(pDoorEntity.GetAbsAngles());
		bAllowUse = true;
	}

	void Remove(int EntIndex)
	{
		if (EntIndex == iDoorIndex)
		{
			pButtonEntity.SUB_Remove();
			this is null;
		}
	}
}

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Events::Trigger::OnStartTouch.Hook(@OnStartTouch);
	Events::Entities::OnEntityDestruction.Hook(@OnEntityDestruction);

	Entities::RegisterUse("spec_button");

	Entities::RegisterUse("func_button");

	Entities::RegisterOutput("OnFullyClosed", "func_door_rotating");
	Entities::RegisterOutput("OnFullyOpen", "func_door_rotating");

	Engine.Ent_Fire("breencrate", "FireUser1", "", "0.01");
	Schedule::Task(0.05f, "SetUpStuff");
}

HookReturnCode OnPlayerSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	int iTeamNum = pBaseEnt.GetTeamNumber();

	if (iTeamNum != TEAM_LOBBYGUYS)
	{
		Engine.Ent_Fire_Ent(pBaseEnt, "SetFogController", "main_insta_fog");
	}

	else
	{
		PlayLobbyAmbient();
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (pEntity.GetTeamNumber() == TEAM_LOBBYGUYS && pEntity.IsPlayer() && Utils.StrEql(strEntityName, "fog_volume_lobby"))
	{
		Engine.Ent_Fire_Ent(pEntity, "SetFogController", "lobby_fog");
	}

	return HOOK_HANDLED;
}

HookReturnCode OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (Utils.StrEql(strClassname, "func_door_rotating"))
	{
		pCDoor1.Remove(pEntity.entindex());
		pCDoor2.Remove(pEntity.entindex());
	}

	return HOOK_CONTINUE;
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity is null || pPlayer is null) 
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	int iTeamNum = pBaseEnt.GetTeamNumber();

	if (iTeamNum == TEAM_SURVIVORS)
	{
		if (Utils.StrEql(pEntity.GetEntityName(), "CBD_Button1"))
		{
			pCDoor1.Toggle();
		}

		else if (Utils.StrEql(pEntity.GetEntityName(), "CBD_Button2"))
		{
			pCDoor2.Toggle();
		} 
	}
}

void OnEntityOutput(const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller)
{
	if (pActivator is null || pCaller is null)
	{
		 return;
	}

	if (Utils.StrEql(pCaller.GetEntityName(), "ContainerBDoor1"))
	{
		pCDoor1.UpdateButton();
	}

	else if (Utils.StrEql(pCaller.GetEntityName(), "ContainerBDoor2"))
	{
		pCDoor2.UpdateButton();
	}
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	FindCDoors();
}

void SetUpStuff()
{
	VMSkins();
	RandomizePropCrate();
	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_human");
	RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(LilaPanic_Spawns);
	CreateSpawnsFromArray(LilaPanic_ZombieSpawn);
}

// Random Skins for the vending machines
void VMSkins()
{
	for (int i = 1; i <= 10; i++)
	{
		Engine.Ent_Fire("vm"+i, "Skin", ""+Math::RandomInt(0, 2));
	}
}

//Setting a random count of items to 'prop_itemcrate'
void RandomizePropCrate()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_itemcrate")) !is null)
	{
		if (Math::RandomInt(1, 100) < 15 && !Utils.StrEql("breencrate", pEntity.GetEntityName()))
		{
			pEntity.SUB_Remove();
			continue;
		}

		else
		{
			int RNG = Math::RandomInt(1, 6);

			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemCount " + RNG);
			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "ItemClass item_ammo_flare");
		}
	}
}

void FindCDoors()
{
	pCDoor1 is null;
	pCDoor2 is null;

	CBaseEntity@ pDoor;
	CBaseEntity@ pButton;

	@pDoor = FindEntityByName(null, "ContainerBDoor1");
	@pButton = FindEntityByName(null, "CBD_Button1");

	if (pDoor !is null && pButton !is null)
	{
		@pCDoor1 = CBrushDoor(pDoor.entindex(), pDoor, pButton);
	}

	@pDoor = FindEntityByName(null, "ContainerBDoor2");
	@pButton = FindEntityByName(null, "CBD_Button2");

	if (pDoor !is null && pButton !is null)
	{
		@pCDoor2 = CBrushDoor(pDoor.entindex(), pDoor, pButton);
	}
}