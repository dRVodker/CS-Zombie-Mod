//some data
bool bIsCSZM = false;
bool bAllowEvents = false;

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iUNum = 0; 
float flWaitSpawnTime = 0;
const float flRemoveTime = 15.00f;

array<string> g_strCName =
{
	"null", //0
	"item_ammo_pistol", //1
	"item_ammo_rifle", //2
	"item_ammo_shotgun", //3
	"item_ammo_revolver", //4
	"item_armor" //5
};

array<float> g_flSTime =
{
	0.0f, //0
	5.0f, //1
	22.5f, //2
	22.5f, //3
	32.5f, //4
	10.0f //5
};

array<float> g_flSpawnTime = {0.0f};
array<string> g_strClassname = {""};
array<Vector> g_vecOrigin = {Vector(0, 0, 0)};
array<QAngle> g_angleAngles = {QAngle(0, 0, 0)};
array<bool> g_bIsSpawned = {true};

void ClearArrays()
{
	g_flSpawnTime.removeRange(0, g_flSpawnTime.length());
	g_strClassname.removeRange(0, g_strClassname.length());
	g_vecOrigin.removeRange(0, g_vecOrigin.length());
	g_angleAngles.removeRange(0, g_angleAngles.length());
	g_bIsSpawned.removeRange(0, g_bIsSpawned.length());
}

void OnPluginInit()
{
	//Events
	Events::Entities::OnEntityDestruction.Hook(@OnEntityDestruction);
	Events::Entities::OnEntityCreation.Hook(@OnEntityCreation);
	Events::Player::PlayerSay.Hook(@PlayerSay);
}

void OnMapInit()
{		
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		flWaitSpawnTime = 0;
		bIsCSZM = true;
		Entities::RegisterPickup("item_ammo_pistol");
		Entities::RegisterPickup("item_ammo_revolver");
		Entities::RegisterPickup("item_ammo_rifle");
		Entities::RegisterPickup("item_ammo_shotgun");
		Entities::RegisterPickup("item_armor");
		
		Engine.PrecacheFile(sound, "items/suitchargeok1.wav");
		
		ClearArrays();
	}
}

void OnNewRound()
{
	if(bIsCSZM == true)
	{
		iUNum = 0;
		ClearArrays();
	}
}

void OnMapShutdown()
{
	iUNum = 0;
	bIsCSZM = false;
	bAllowEvents = false;
	ClearArrays();
	
	Entities::RemoveRegisterPickup("item_ammo_pistol");
	Entities::RemoveRegisterPickup("item_ammo_revolver");
	Entities::RemoveRegisterPickup("item_ammo_rifle");
	Entities::RemoveRegisterPickup("item_ammo_shotgun");
	Entities::RemoveRegisterPickup("item_armor");
}

void OnMatchBegin()
{
	bAllowEvents = true;
}

void OnMatchEnded()
{
	bAllowEvents = false;
}

void OnProcessRound()
{
	if(bIsCSZM == true)
	{
		if(flWaitSpawnTime <= Globals.GetCurrentTime())
		{
			flWaitSpawnTime = Globals.GetCurrentTime() + 0.01f;
			
			for(uint i = 0; i <= g_flSpawnTime.length(); i++)
			{
				if(g_bIsSpawned[i] == true) continue;
					
				if(g_flSpawnTime[i] > 0)
				{
					g_flSpawnTime[i] -= 0.01f;
					continue;
				}
				if(g_flSpawnTime[i] < 0)
				{
					g_flSpawnTime[i] = 0;
					continue;
				}
				if(g_flSpawnTime[i] == 0)
				{
					SpawnThing(i);
					continue;
				}
			}
		}
	}
}

void SpawnThing(const int &in iIndex)
{
	if(g_bIsSpawned[iIndex] == false)
	{
		if(g_strClassname[iIndex] == "item_ammo_pistol")
		{
//			SD("Index: "+iIndex+"\nClass: "+g_strClassname[iIndex]+"\nRTime: "+g_flSpawnTime[iIndex]+"\nSpawned: "+g_bIsSpawned[iIndex]);
			CBaseEntity@ pMakerAmmoPistol;
			@pMakerAmmoPistol = FindEntityByName(pMakerAmmoPistol, "-maker_item_ammo_pistol");
			pMakerAmmoPistol.SetAbsAngles(g_angleAngles[iIndex]);
			pMakerAmmoPistol.SetAbsOrigin(g_vecOrigin[iIndex]);
			Engine.Ent_Fire_Ent(pMakerAmmoPistol, "ForceSpawn");
			g_bIsSpawned[iIndex] = true;
		}
		else if(g_strClassname[iIndex] == "item_ammo_rifle")
		{
			CBaseEntity@ pMakerAmmoRifle;
			@pMakerAmmoRifle = FindEntityByName(pMakerAmmoRifle, "-maker_item_ammo_rifle");
			pMakerAmmoRifle.SetAbsAngles(g_angleAngles[iIndex]);
			pMakerAmmoRifle.SetAbsOrigin(g_vecOrigin[iIndex]);
			Engine.Ent_Fire_Ent(pMakerAmmoRifle, "ForceSpawn");
			g_bIsSpawned[iIndex] = true;
		}
		else if(g_strClassname[iIndex] == "item_ammo_revolver")
		{
			CBaseEntity@ pMakerAmmoRevolver;
			@pMakerAmmoRevolver = FindEntityByName(pMakerAmmoRevolver, "-maker_item_ammo_revolver");
			pMakerAmmoRevolver.SetAbsAngles(g_angleAngles[iIndex]);
			pMakerAmmoRevolver.SetAbsOrigin(g_vecOrigin[iIndex]);
			Engine.Ent_Fire_Ent(pMakerAmmoRevolver, "ForceSpawn");
			g_bIsSpawned[iIndex] = true;
		}
		else if(g_strClassname[iIndex] == "item_ammo_shotgun")
		{
			CBaseEntity@ pMakerAmmoShotgun;
			@pMakerAmmoShotgun = FindEntityByName(pMakerAmmoShotgun, "-maker_item_ammo_shotgun");
			pMakerAmmoShotgun.SetAbsAngles(g_angleAngles[iIndex]);
			pMakerAmmoShotgun.SetAbsOrigin(g_vecOrigin[iIndex]);
			Engine.Ent_Fire_Ent(pMakerAmmoShotgun, "ForceSpawn");
			g_bIsSpawned[iIndex] = true;
		}
		else if(g_strClassname[iIndex] == "item_armor")
		{
			CBaseEntity@ pMakerArmor;
			@pMakerArmor = FindEntityByName(pMakerArmor, "-maker_item_armor");
			pMakerArmor.SetAbsAngles(g_angleAngles[iIndex]);
			pMakerArmor.SetAbsOrigin(g_vecOrigin[iIndex]);
			Engine.Ent_Fire_Ent(pMakerArmor, "ForceSpawn");
			g_bIsSpawned[iIndex] = true;
		}
	}
}

HookReturnCode OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if(bIsCSZM == true && bAllowEvents == true)
	{
		if(Utils.StrContains("weapon", strClassname) || Utils.StrContains("item", strClassname)) Engine.Ent_Fire_Ent(pEntity, "DisableDamageForces");

		if(Utils.StrContains("clip", strClassname) && strClassname != "item_ammo_barricade_clip")
		{
			pEntity.SetEntityName("_remove_me");
			Schedule::Task(0.15f, "RemoveThing");
			
			return HOOK_HANDLED;
		}
		
		if(Utils.StrContains("base_item", pEntity.GetEntityName()))
		{
			for(uint i = 1; i <= g_strCName.length(); i++)
			{
				if(strClassname == g_strCName[i])
				{
					Engine.EmitSoundEntity(pEntity, "CS.ItemMaterialize");
					if(pEntity.GetEntityName() == "base_item_rot_armor")
					{
						Engine.Ent_Fire("-maker_spark", "ForceSpawnAtEntityOrigin", ""+pEntity.GetEntityName());
					}
					else
					{
						iUNum++;
						pEntity.SetEntityName("RE-ITEM"+iUNum);
						Engine.Ent_Fire("-maker_spark", "ForceSpawnAtEntityOrigin", "RE-ITEM"+iUNum);
					}
					
					return HOOK_HANDLED;
				}
			}
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode PlayerSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pBasePlayer = pPlayer.opCast();
		
		if(Utils.StrEql("!arr", pArgs.Arg(1)))
		{
			for(uint i = 0; i <= g_bIsSpawned.length() - 1; i++)
			{
				Chat.PrintToChatPlayer(pBasePlayer, "g_bIsSpawned["+i+"] = " + g_bIsSpawned[i]);
			}
			
			return HOOK_HANDLED;
		}

	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if(bIsCSZM == true && bAllowEvents == true)
	{
		for(uint i = 1; i <= g_strCName.length(); i++)
		{
			if(strClassname == g_strCName[i])
			{
				g_flSpawnTime.insertLast(g_flSTime[i] + Math::RandomFloat(0.05f, 1.25f));
				g_strClassname.insertLast(strClassname);
				g_vecOrigin.insertLast(pEntity.GetAbsOrigin());
				g_angleAngles.insertLast(pEntity.GetAbsAngles());
				g_bIsSpawned.insertLast(false);
					
				return HOOK_HANDLED;
			}
		}
	}

	return HOOK_CONTINUE;
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if(bIsCSZM == true)
	{
		if(Utils.StrContains("item_ammo", pEntity.GetClassname()) || Utils.StrContains("item_armor", pEntity.GetClassname()))
		{
			pEntity.SUB_Remove();
		}
	}
}

void RemoveThing()
{
	CBaseEntity@ pEntity;
	while((@pEntity = FindEntityByName(pEntity, "_remove_me")) !is null)
	{
		pEntity.SetEntityName("");
		pEntity.SUB_StartFadeOut(flRemoveTime, false);
	}
}