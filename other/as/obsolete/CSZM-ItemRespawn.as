bool bIsCSZM = false;

int iDroppedAmmoCount = 0;
float flRespawnMultiple = 1.0f;
const int CONST_MAX_DROPPED_AMMO = 64;

float GetRespawnTime(const string &in sClass, const string &in sValue)
{
	return Utils.StringToFloat(sValue) * flRespawnMultiple;
}

array<string> Array_ItemClass =
{
	"item_ammo_pistol:35.0",
	"item_ammo_rifle:45.0",
	"item_ammo_shotgun:60.0",
	"item_ammo_barricade:50.0",
	"item_ammo_revolver:70.0",
	"item_armor:45.0"
};

array<string> Array_ClipClass =
{
	"item_ammo_pistol_clip",
	"item_ammo_rifle_clip",
	"item_ammo_shotgun_clip",
	"item_ammo_barricade_clip",
	"item_ammo_revolver_clip"
};

array<ItemRespawn@> Array_ItemRespawn;

class ItemRespawn
{
	int EIndex;
	private string Classname;
	private float RespawnTime;
	private float Timer;

	private Vector Origin;
	private QAngle Angles;

	ItemRespawn(CBaseEntity@ pItem, const float nRTime)
	{
		RespawnTime = nRTime;
		EIndex = pItem.entindex();
		Classname = pItem.GetClassname();

		Origin = pItem.GetAbsOrigin();
		Angles = pItem.GetAbsAngles();
	}

	void Respawn()
	{
		if (Timer == 0)
		{
			CBaseEntity@ pItem = FindEntityByEntIndex(EIndex);
			pItem.SetHealth(-2);
			Timer = Globals.GetCurrentTime() + RespawnTime;
		}
	}

	void Think()
	{
		if (Timer <= Globals.GetCurrentTime() && Timer != 0)
		{
			Timer = 0;
			CBaseEntity@ pEntity = FindEntityByEntIndex(EIndex);
			if (pEntity !is null && Utils.StrEql(Classname, pEntity.GetClassname(), true) && pEntity.GetHealth() == -2)
			{
				pEntity.SUB_Remove();
			}
			EIndex = ReSpawnItem(Classname, Origin, Angles);
		}
	}
}

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Items Respawn");

	Events::Entities::OnEntityCreation.Hook(@CSZM_RI_OnEntityCreation);
	Events::Entities::OnEntityDestruction.Hook(@CSZM_RI_OnEntityDestruction);
}

void OnProcessRound()
{
	if (bIsCSZM)
	{
		for (uint i = 0; i < Array_ItemRespawn.length(); i++)
		{
			if (Array_ItemRespawn[i] is null)
			{
				Array_ItemRespawn.removeAt(i);
				continue;
			}

			Array_ItemRespawn[i].Think();
		}
	}
}

void OnMapInit()
{		
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
		iDroppedAmmoCount = 0;
		
		RegisterPickup();
		Engine.PrecacheFile(sound, "items/suitchargeok1.wav");
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		iDroppedAmmoCount = 0;
		bIsCSZM = false;
		Array_ItemRespawn.removeRange(0, Array_ItemRespawn.length());
	}
}

void OnMatchBegin()
{
	if (bIsCSZM)
	{
		Schedule::Task(0.65f, "CSZM_RI_FindItems");
	}
}

HookReturnCode CSZM_RI_OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (bIsCSZM && Utils.StrContains("clip", strClassname))
	{
		pEntity.SetEntityName("dropped_item");

		uint iAmmoClassLength = Array_ClipClass.length();

		for (uint i = 0; i < iAmmoClassLength; i++)
		{
			if (Utils.StrEql(strClassname, Array_ClipClass[i], true))
			{
				iDroppedAmmoCount++;
				break;
			}
		}

		if (iDroppedAmmoCount > CONST_MAX_DROPPED_AMMO)
		{
			RemoveExtraClip(iDroppedAmmoCount - CONST_MAX_DROPPED_AMMO);
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_RI_OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (bIsCSZM && Utils.StrContains("clip", strClassname))
	{
		uint iAmmoClassLength = Array_ClipClass.length();

		for (uint i = 0; i < iAmmoClassLength; i++)
		{
			if (Utils.StrEql(strClassname, Array_ClipClass[i], true) && iDroppedAmmoCount > 0)
			{
				iDroppedAmmoCount--;
				break;						
			}
		}
	}

	return HOOK_CONTINUE;
}

void CSZM_RI_FindItems()
{
	if (!bIsCSZM)
	{
		return;
	}

	Array_ItemRespawn.removeRange(0, Array_ItemRespawn.length());

	uint iItemClassLength = Array_ItemClass.length();
	CASCommand@ pSplited;
	CBaseEntity@ pItem;

	for (uint i = 0; i < iItemClassLength; i++)
	{
		@pSplited = StringToArgSplit(Array_ItemClass[i], ":");
		while ((@pItem = FindEntityByClassname(pItem, pSplited.Arg(0))) !is null)
		{
			Array_ItemRespawn.insertLast(ItemRespawn(pItem, GetRespawnTime(pSplited.Arg(0), pSplited.Arg(1))));
		}
	}
}

void CSZM_RI_SetRespawnMultiple(NetObject@ pData)
{
	if (pData is null)
	{
		return;
	}
	
	flRespawnMultiple = Utils.StringToFloat(pData.GetString(0));
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	int iIndex = pEntity.entindex();

	for (uint i = 0; i < Array_ItemRespawn.length(); i++)
	{
		if (Array_ItemRespawn[i] is null)
		{
			Array_ItemRespawn.removeAt(i);
			continue;
		}

		if (Array_ItemRespawn[i].EIndex == iIndex)
		{
			pEntity.SetHealth(-1);
			Array_ItemRespawn[i].Respawn();
		}
	}
}

void RemoveExtraClip(const int &in iUnit)
{
	array<CBaseEntity@> g_pAmmoEntity;
	CBaseEntity@ pAmmoEntity;

	while ((@pAmmoEntity = FindEntityByName(pAmmoEntity, "dropped_item")) !is null)
	{
		g_pAmmoEntity.insertLast(pAmmoEntity);
	}

	for (int i = 0; i < iUnit; i++)
	{
		g_pAmmoEntity[i].SUB_Remove();
	}
}

void RegisterPickup()
{
	int iLength = int(Array_ItemClass.length());
	CASCommand@ pSplited;

	for (int i = 0; i < iLength; i++)
	{
		@pSplited = StringToArgSplit(Array_ItemClass[i], ":");
		Entities::RegisterPickup(pSplited.Arg(0));

	}
}

int ReSpawnItem(const string &in Classname, Vector &in Origin, QAngle &in Angles)
{
	CEntityData@ ItemIPD = EntityCreator::EntityData();
	ItemIPD.Add("DisableDamageForces", "1", true);
	CBaseEntity@ pItem = EntityCreator::Create(Classname, Origin, Angles, ItemIPD);
	ReSpawnEffect(Origin + Vector(0, 0, 4));
	return pItem.entindex();
}

void ReSpawnEffect(Vector &in Origin)
{
	CEntityData@ SparkIPD = EntityCreator::EntityData();
	SparkIPD.Add("spawnflags", "896");
	SparkIPD.Add("magnitude", "1");
	SparkIPD.Add("trailLength", "1");
	SparkIPD.Add("maxdelay", "0");

	SparkIPD.Add("SparkOnce", "0", true);
	SparkIPD.Add("kill", "0", true);

	EntityCreator::Create("env_spark", Origin, QAngle(-90, 0, 0), SparkIPD);	

	Engine.EmitSoundPosition(0, "items/suitchargeok1.wav", Origin, 0.85f, 80, Math::RandomInt(135, 165));
}