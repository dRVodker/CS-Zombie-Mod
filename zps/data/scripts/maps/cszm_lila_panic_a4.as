#include "cszm_modules/lobbyambient"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

const int TEAM_LOBBYGUYS = 0;
const int TEAM_SPECTATORS = 1;
const int TEAM_SURVIVORS = 2;

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