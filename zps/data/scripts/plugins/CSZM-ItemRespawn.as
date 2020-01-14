bool bIsCSZM = false;

bool IsInvalidDeliver(CBaseEntity@ pEntity)
{
	return !(Utils.StrEql("iantidote", pEntity.GetEntityName()) || Utils.StrEql("item_adrenaline", pEntity.GetEntityName()));
}

int iDroppedAmmoCount = 0;
const int CONST_MAX_DROPPED_AMMO = 32;

const float CONST_ANTIDOTE_RT = 70.0f;
const float CONST_ADRENALINE_RT = 50.0f;
const float CONST_DEF_DELIVER_RT = 30.0f;

const int CONST_DT_OTHER = -1;
const int CONST_DT_NULL = 0;
const int CONST_DT_ANTIDOTE = 1;
const int CONST_DT_ADRENALINE = 2;

array<string> g_strAmmoClass =
{
	"item_ammo_pistol_clip",
	"item_ammo_rifle_clip",
	"item_ammo_revolver_clip",
	"item_ammo_shotgun_clip",
	"item_ammo_barricade_clip"
};

array<string> g_ItemClass =
{
	"item_ammo_pistol",
	"item_ammo_rifle",
	"item_ammo_shotgun",
	"item_ammo_barricade",
	"item_ammo_revolver",
	"item_armor",
	"item_deliver"
};

array<float> g_ItemRespawnTime =
{
	7.0f,
	22.0f,
	27.0f,
	20.1f,
	36.0f,
	39.0f,
	10.0f
};

array<CItemRespawn@> ItemRespawnArray;

class CItemRespawn
{
	int EntIndex;
	int ArrayPosition;
	float RespawnTime;
	string Classname;
	string Targetname;
	Vector Origin;
	QAngle Angles;
	int DeliverType;

	CItemRespawn(int EIndex, string Class, string Name, Vector ABSOrinig, QAngle ABSAngles)
	{
		EntIndex = EIndex;
		ArrayPosition = 0;
		RespawnTime = 0.0f;
		Classname = Class;
		Targetname = Name;
		Origin = ABSOrinig;
		Angles = ABSAngles;
		DeliverType = CONST_DT_NULL;
	}

	int GetIndex()
	{
		return EntIndex;
	}

	string GetClassname()
	{
		return Classname;
	}

	string GetEntityName()
	{
		return Targetname;
	}

	Vector GetAbsOrigin()
	{
		return Origin;
	}

	QAngle GetAbsAngles()
	{
		return Angles;
	}

	void SetEntIndex(int EIndex)
	{
		EntIndex = EIndex;
	}

	void Respawn(int AP, CBaseEntity@ pItem)
	{
		float NewTime;

		if (Utils.StrEql("item_deliver", Classname))
		{
			if (Utils.StrEql("iantidote", Targetname))
			{
				NewTime = CONST_ANTIDOTE_RT;
				DeliverType = CONST_DT_ANTIDOTE;
			}
			else if (Utils.StrEql("item_adrenaline", Targetname))
			{
				NewTime = CONST_ADRENALINE_RT;
				DeliverType = CONST_DT_ADRENALINE;
			}
		}
		else
		{
			uint iItemClassLength = g_ItemClass.length();
			
			for (uint i = 0; i < iItemClassLength; i++)
			{
				if (Utils.StrEql(g_ItemClass[i], Classname))
				{
					NewTime = g_ItemRespawnTime[i];
				}
			}
		}

		EntIndex = 0;
		ArrayPosition = AP;
		RespawnTime = Globals.GetCurrentTime() + NewTime;

		if (DeliverType == CONST_DT_NULL)
		{
			pItem.SUB_Remove();
		}
	}

	void Think()
	{
		if (RespawnTime <= Globals.GetCurrentTime() && RespawnTime != 0)
		{
			RespawnTime = 0.0f;
			switch(DeliverType)
			{
				case CONST_DT_ANTIDOTE:
					ReSpawnAntidote(ArrayPosition);
				break;

				case CONST_DT_ADRENALINE:
					ReSpawnAdrenaline(ArrayPosition);
				break;
				
				default:
					ReSpawnItem(ArrayPosition);
				break;
			}
		}
	}
}

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Items Respawn");

	Events::Entities::OnEntityCreation.Hook(@OnEntityCreation);
	Events::Entities::OnEntityDestruction.Hook(@OnEntityDestruction);
}

void OnProcessRound()
{
	if (bIsCSZM)
	{
		uint iIRALength = ItemRespawnArray.length();

		for (uint i = 0; i < iIRALength; i++)
		{
			CItemRespawn@ pItemRespawn = ItemRespawnArray[i];
			
			if (pItemRespawn !is null)
			{
				pItemRespawn.Think();
			}
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

void OnNewRound()
{
	if (bIsCSZM)
	{
		ClearIRArray();
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		iDroppedAmmoCount = 0;
		bIsCSZM = false;
		ClearIRArray();
	}
}

void OnMatchBegin()
{
	if (bIsCSZM)
	{
		Schedule::Task(0.65f, "CSZM_RI_FindItems");
	}
}

void RegisterPickup()
{
	if (bIsCSZM)
	{
		uint iItemClassLength = g_ItemClass.length();

		for (uint i = 0; i < iItemClassLength; i++)
		{
			Entities::RegisterPickup(g_ItemClass[i]);
		}
	}
}

HookReturnCode OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (bIsCSZM)
	{
		if (Utils.StrContains("weapon", strClassname) || Utils.StrContains("item", strClassname))
		{
			Engine.Ent_Fire_Ent(pEntity, "DisableDamageForces");
		}

		if (Utils.StrContains("clip", strClassname) /*&& strClassname != "item_ammo_barricade_clip"*/)
		{
			pEntity.SetEntityName("dropped_ammo");

			uint iType = 0;
			uint iAmmoClassLength = g_strAmmoClass.length();

			for (uint ui = 0; ui < iAmmoClassLength; ui++)
			{
				if (strClassname == g_strAmmoClass[ui])
				{
					iDroppedAmmoCount++;
					iType = ui;
				}
			}

			if (iDroppedAmmoCount > CONST_MAX_DROPPED_AMMO)
			{
				uint iResult = 1;
				if ((iDroppedAmmoCount - CONST_MAX_DROPPED_AMMO) > 0)
				{
					iResult = iDroppedAmmoCount - CONST_MAX_DROPPED_AMMO;
				}
				RemoveExtraClip(iResult);
			}
		}
	}
	
	return HOOK_CONTINUE;
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (bIsCSZM)
	{
		int iIndex = pEntity.entindex();
		uint iIRALength = ItemRespawnArray.length();

		for (uint i = 0; i < iIRALength; i++)
		{
			CItemRespawn@ pItemRespawn = ItemRespawnArray[i];
			
			if (pItemRespawn is null)
			{
				continue;
			}

			if (pItemRespawn.GetIndex() == iIndex)
			{
				pEntity.SetHealth(-1);
				pItemRespawn.Respawn(i ,pEntity);
			}
		}
	}
}

HookReturnCode OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (bIsCSZM)
	{
		RemoveObject(pEntity);

		if (Utils.StrContains("clip", strClassname) /*&& strClassname != "item_ammo_barricade_clip"*/)
		{
			uint iType = 0;
			uint iAmmoClassLength = g_strAmmoClass.length();

			for (uint ui = 0; ui < iAmmoClassLength; ui++)
			{
				if (Utils.StrEql(strClassname, g_strAmmoClass[ui]))
				{
					iDroppedAmmoCount--;
					if (iDroppedAmmoCount < 0)
					{
						iDroppedAmmoCount = 0;
					}
				}
			}
		}
	}

	return HOOK_CONTINUE;
}

void CSZM_RI_FindItems()
{
	ClearIRArray();
	CBaseEntity@ pEntity;
	uint iItemClassLength = g_ItemClass.length();

	for (uint i = 0; i < iItemClassLength; i++)
	{
		while ((@pEntity = FindEntityByClassname(pEntity, g_ItemClass[i])) !is null)
		{
			if (i == 6 && IsInvalidDeliver(pEntity)) // 6 = "item_deliver"
			{
				continue;
			}
			
			ItemRespawnArray.insertLast(CItemRespawn(pEntity.entindex(), pEntity.GetClassname(), pEntity.GetEntityName(), pEntity.GetAbsOrigin(), pEntity.GetAbsAngles()));
		}
	}
}

void ClearIRArray()
{
	ItemRespawnArray.removeRange(0, ItemRespawnArray.length());
	ItemRespawnArray.resize(0);
}

void RemoveObject(CBaseEntity@ pEntity)
{
	if (pEntity.GetHealth() != -1)
	{
		int iIndex = pEntity.entindex();
		uint iIRALength = ItemRespawnArray.length();

		for (uint i = 0; i < iIRALength; i++)
		{
			CItemRespawn@ pItemRespawn = ItemRespawnArray[i];

			if (pItemRespawn is null)
			{
				continue;
			}

			if (pItemRespawn.GetIndex() == iIndex)
			{
				ItemRespawnArray.removeAt(i);
				break;
			}
		}
	}
}

void ReSpawnItem(const int &in iArrayPos)
{
	CItemRespawn@ pItemRespawn = ItemRespawnArray[iArrayPos];

	if (pItemRespawn !is null)
	{
		string SI_Class = pItemRespawn.GetClassname();
		string SI_Name = pItemRespawn.GetEntityName();
		Vector SI_Origin = pItemRespawn.GetAbsOrigin();
		QAngle SI_Angles = pItemRespawn.GetAbsAngles();

		CEntityData@ ItemIPD = EntityCreator::EntityData();

		ItemIPD.Add("DisableDamageForces", "1", true);

		CBaseEntity@ pItem = EntityCreator::Create(SI_Class, SI_Origin, SI_Angles, ItemIPD);

		pItemRespawn.SetEntIndex(pItem.entindex());

		ReSpawnEffect(SI_Origin);
	}
}

void ReSpawnAntidote(const int &in iArrayPos)
{
	CItemRespawn@ pItemRespawn = ItemRespawnArray[iArrayPos];

	if (pItemRespawn !is null)
	{
		Vector SI_Origin = pItemRespawn.GetAbsOrigin();
		QAngle SI_Angles = pItemRespawn.GetAbsAngles();

		CEntityData@ AntidoteIPD = EntityCreator::EntityData();

		AntidoteIPD.Add("targetname", "iantidote");
		AntidoteIPD.Add("delivername", "Antidote");
		AntidoteIPD.Add("glowcolor", "5 250 121");
		AntidoteIPD.Add("itemstate", "1");
		AntidoteIPD.Add("model", "models/cszm/weapons/w_antidote.mdl");
		AntidoteIPD.Add("viewmodel", "models/cszm/weapons/v_antidote.mdl");
		AntidoteIPD.Add("printname", "vgui/images/weapons/inoculator");
		AntidoteIPD.Add("sound_pickup", "Deliver.PickupGeneric");
		AntidoteIPD.Add("weight", "0");

		AntidoteIPD.Add("DisableDamageForces", "1", true);

		CBaseEntity@ pItem = EntityCreator::Create("item_deliver", SI_Origin, SI_Angles, AntidoteIPD);

		pItemRespawn.SetEntIndex(pItem.entindex());

		ReSpawnEffect(SI_Origin);
	}
}

void ReSpawnAdrenaline(const int &in iArrayPos)
{
	CItemRespawn@ pItemRespawn = ItemRespawnArray[iArrayPos];

	if (pItemRespawn !is null)
	{
		Vector SI_Origin = pItemRespawn.GetAbsOrigin();
		QAngle SI_Angles = pItemRespawn.GetAbsAngles();

		CEntityData@ AdrenalineIPD = EntityCreator::EntityData();

		AdrenalineIPD.Add("targetname", "item_adrenaline");
		AdrenalineIPD.Add("delivername", "Adrenaline");
		AdrenalineIPD.Add("glowcolor", "5 250 121");
		AdrenalineIPD.Add("itemstate", "1");
		AdrenalineIPD.Add("model", "models/cszm/weapons/w_adrenaline.mdl");
		AdrenalineIPD.Add("viewmodel", "models/cszm/weapons/v_adrenaline.mdl");
		AdrenalineIPD.Add("printname", "vgui/images/adrenaline");
		AdrenalineIPD.Add("sound_pickup", "Deliver.PickupGeneric");
		AdrenalineIPD.Add("weight", "0");

		AdrenalineIPD.Add("DisableDamageForces", "1", true);

		CBaseEntity@ pItem = EntityCreator::Create("item_deliver", SI_Origin, SI_Angles, AdrenalineIPD);

		pItemRespawn.SetEntIndex(pItem.entindex());

		ReSpawnEffect(SI_Origin);
	}
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

	Engine.EmitSoundPosition(0, "items/suitchargeok1.wav", Origin, 0.695f, 75, Math::RandomInt(135, 165));
}

void RemoveExtraClip(const uint &in iUnit)
{
	array<CBaseEntity@> g_pAmmoEntity;
	CBaseEntity@ pAmmoEntity;

	while ((@pAmmoEntity = FindEntityByName(pAmmoEntity, "dropped_ammo")) !is null)
	{
		g_pAmmoEntity.insertLast(pAmmoEntity);
	}
	if (iUnit == 1)
	{
		g_pAmmoEntity[0].SUB_Remove();
	}
	else
	{
		for (uint uii = 0; uii <= iUnit; uii++)
		{
			g_pAmmoEntity[uii].SUB_Remove();
		}
	}
}