#include "./cszm/spawnad.as"

//some data
bool bIsCSZM = false;
bool bAllowEvents = false;

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

int iUNum = 0; 
float flWaitSpawnTime = 0;

int iDroppedAmmoCount = 0;
const int iMaxDroppedAmmo = 45;

array<string> g_strAmmoClass =
{
	"item_ammo_pistol_clip",
	"item_ammo_rifle_clip",
	"item_ammo_revolver_clip",
	"item_ammo_shotgun_clip"
};

array<string> g_strCName =
{
	"null", //0
	"item_ammo_pistol", //1
	"item_ammo_rifle", //2
	"item_ammo_shotgun", //3
	"item_ammo_revolver", //4
	"item_pills" //5
};

array<float> g_flSTime =
{
	0.0f, //0
	5.5f, //1
	20.0f, //2
	25.0f, //3
	35.0f, //4
	43.0f //5
};

array<float> g_flSpawnTime = {0.0f};
array<string> g_strClassname = {""};
array<Vector> g_vecOrigin = {Vector(0, 0, 0)};
array<QAngle> g_angAngles = {QAngle(0, 0, 0)};
array<bool> g_bIsSpawned = {true};

void ClearArrays()
{
	g_flSpawnTime.removeRange(0, g_flSpawnTime.length());
	g_strClassname.removeRange(0, g_strClassname.length());
	g_vecOrigin.removeRange(0, g_vecOrigin.length());
	g_angAngles.removeRange(0, g_angAngles.length());
	g_bIsSpawned.removeRange(0, g_bIsSpawned.length());
}

void OnPluginInit()
{
	//Events
	Events::Entities::OnEntityDestruction.Hook(@OnEntityDestruction);
	Events::Entities::OnEntityCreation.Hook(@OnEntityCreation);
}

void OnMapInit()
{		
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		flWaitSpawnTime = 0;
		iDroppedAmmoCount =0;
		bIsCSZM = true;
		Entities::RegisterPickup("item_ammo_pistol");
		Entities::RegisterPickup("item_ammo_revolver");
		Entities::RegisterPickup("item_ammo_rifle");
		Entities::RegisterPickup("item_ammo_shotgun");
		
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
	iDroppedAmmoCount = 0;
	bIsCSZM = false;
	bAllowEvents = false;
	ClearArrays();
	
	Entities::RemoveRegisterPickup("item_ammo_pistol");
	Entities::RemoveRegisterPickup("item_ammo_revolver");
	Entities::RemoveRegisterPickup("item_ammo_rifle");
	Entities::RemoveRegisterPickup("item_ammo_shotgun");
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
				if(g_bIsSpawned[i] == false)
				{
					if(g_flSpawnTime[i] <= Globals.GetCurrentTime())
					{
						g_bIsSpawned[i] = true;
						SpawnItem(i);
					}
				}
			}
		}
	}
}

void SpawnItem(const int &in iID)
{
	CEntityData@ inputdata = EntityCreator::EntityData();
	inputdata.Add("targetname", "item-respawned");

	inputdata.Add("DisableDamageForces", "1", true);

	EntityCreator::Create(g_strClassname[iID], g_vecOrigin[iID], g_angAngles[iID], inputdata);
}

void EnvSpark(const Vector &in vecOrigin)
{
	CEntityData@ inputdata = EntityCreator::EntityData();
	inputdata.Add("targetname", "item-respawn-spark");
	inputdata.Add("spawnflags", "896");
	inputdata.Add("Magnitude", "1");
	inputdata.Add("TrailLength", "1");
	inputdata.Add("MaxDelay", "0");

	inputdata.Add("SparkOnce", "0", true);
	inputdata.Add("kill", "0", true);

	EntityCreator::Create("env_spark", vecOrigin, QAngle(-90, 0, 0), inputdata);	
}

HookReturnCode OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if(bIsCSZM == true && bAllowEvents == true)
	{
		if(Utils.StrContains("weapon", strClassname) || Utils.StrContains("item", strClassname)) Engine.Ent_Fire_Ent(pEntity, "DisableDamageForces");

		if(Utils.StrContains("clip", strClassname) && strClassname != "item_ammo_barricade_clip")
		{
			uint iType = 0;

			for(uint ui = 0; ui < g_strAmmoClass.length(); ui++)
			{
				if(strClassname == g_strAmmoClass[ui])
				{
					iDroppedAmmoCount++;
					iType = ui;
				}
			}

			if(iDroppedAmmoCount > iMaxDroppedAmmo)
			{
				uint iResult = 1;
				if((iDroppedAmmoCount - iMaxDroppedAmmo) > 0) iResult = iDroppedAmmoCount - iMaxDroppedAmmo;
				RemoveExtraClip(iResult);
			}

			return HOOK_HANDLED;
		}
		
		if(Utils.StrContains("item-respawned", pEntity.GetEntityName()))
		{
			for(uint i = 1; i <= g_strCName.length(); i++)
			{
				if(strClassname == g_strCName[i])
				{
					Engine.EmitSoundEntity(pEntity, "CS.ItemMaterialize");
					EnvSpark(pEntity.GetAbsOrigin());
				}
			}
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if(bIsCSZM == true && bAllowEvents == true)
	{
		if(Utils.StrContains("clip", strClassname) && strClassname != "item_ammo_barricade_clip")
		{
			uint iType = 0;

			for(uint ui = 0; ui < g_strAmmoClass.length(); ui++)
			{
				if(strClassname == g_strAmmoClass[ui])
				{
					iDroppedAmmoCount--;
					if(iDroppedAmmoCount < 0) iDroppedAmmoCount = 0;
				}
			}

			return HOOK_HANDLED;
		}

		for(uint i = 1; i <= g_strCName.length(); i++)
		{
			if(strClassname == g_strCName[i])
			{
				g_flSpawnTime.insertLast(Globals.GetCurrentTime() + g_flSTime[i]);
				g_strClassname.insertLast(pEntity.GetClassname());
				g_vecOrigin.insertLast(pEntity.GetAbsOrigin());
				g_angAngles.insertLast(pEntity.GetAbsAngles());
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
		if(Utils.StrContains("item_ammo", pEntity.GetClassname())) pEntity.SUB_Remove();
	}
}

void RemoveExtraClip(const uint &in iUnit)
{
	array<CBaseEntity@> g_pAmmoEntity;
	CBaseEntity@ pAmmoEntity;

	for(uint ui = 0; ui < g_strAmmoClass.length(); ui++)
	{
		while((@pAmmoEntity = FindEntityByClassname(pAmmoEntity, g_strAmmoClass[ui])) !is null)
		{
				g_pAmmoEntity.insertLast(pAmmoEntity);
		}
	}

	if(iUnit == 1) g_pAmmoEntity[0].SUB_Remove();
	else
	{
		for(uint uii = 0; uii <= iUnit; uii++)
		{
			g_pAmmoEntity[uii].SUB_Remove();
		}
	}
}