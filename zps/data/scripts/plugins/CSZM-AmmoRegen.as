//CSZM-AmmoRegen.as
bool bIsCSZM = false;
int iMaxPlayers;
const int CONST_AK_PTS_MAX = 100;

array<int> g_AmmoRegen_Index;
array<CAmmoRegen@> g_AmmoRegen;

CAmmoRegen@ GetAmmoRegen(const int &in Index)
{
	CAmmoRegen@ pAmmoRegen = null;
	int length = int(g_AmmoRegen.length());
	for(int i = 0; i < length; i++)
	{
		if (Index == g_AmmoRegen[i].entindex())
		{
			g_AmmoRegen[i].SetArrayPos(i);
			@pAmmoRegen = g_AmmoRegen[i];
			break;
		}
	}

	return pAmmoRegen;
}

bool bDamageType(int &in iSubjectDT, int &in iDMGNum)
{
	return iSubjectDT & (1<<iDMGNum) == (1<<iDMGNum);;
}

class CAmmoRegen
{
	private int iEntIndex;
	private int iOwnerIndex;
	private int iArrPos;
	private float flDelay;
	private float flAmmoRegenPoints;

	CAmmoRegen(int ItemIndex)
	{
		iEntIndex = ItemIndex;
		iOwnerIndex = 0;
		iArrPos = 0;
		flDelay = 0;
		flAmmoRegenPoints = 100.0f;	//100.0f
	}

	int entindex()
	{
		return iEntIndex;
	}

	void SetArrayPos(int ArrPos)
	{
		iArrPos = ArrPos;
	}

 	int GetArrayPos()
	{
		return iArrPos;
	}

	void AddPoints(float Points)
	{
		flAmmoRegenPoints += Points;
		if (flAmmoRegenPoints > CONST_AK_PTS_MAX)
		{
			flAmmoRegenPoints = CONST_AK_PTS_MAX;
		}
		this.ShowChargeLevel();
	}

	void SetPoints(float Points)
	{
		flAmmoRegenPoints = Points;
		if (flAmmoRegenPoints > CONST_AK_PTS_MAX)
		{
			flAmmoRegenPoints = CONST_AK_PTS_MAX;
		}
		else if (flAmmoRegenPoints <= 0)
		{
			this.Remove();
		}
	}

	float GetPoints()
	{
		return flAmmoRegenPoints;
	}

	void RegenAmmo(int DamageType)
	{
		if (bDamageType(DamageType, 1) && flDelay <= Globals.GetCurrentTime())
		{
			flDelay = Globals.GetCurrentTime() + 0.01f;
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(iOwnerIndex);
			string WeaponName = (ToZPPlayer(iOwnerIndex).GetCurrentWeapon()).GetClassname();
			float SubtractAmmo = 1.85f;
			CZP_Player@ pOwnerPlayer = ToZPPlayer(iOwnerIndex);
			pOwnerPlayer.AmmoWeapon(add, 1);

			if (bDamageType(DamageType, 29))
			{
				SubtractAmmo = 21.21f;
			}
			else if (WeaponName == "weapon_revolver")
			{
				SubtractAmmo = 19.85f;
			}
			else if (WeaponName == "weapon_m4" || WeaponName == "weapon_ak47" || WeaponName == "weapon_mp5")
			{
				SubtractAmmo = 3.02f;
			}
			else if (WeaponName == "weapon_ppk")
			{
				SubtractAmmo = 0.99f;
			}

			flAmmoRegenPoints -= SubtractAmmo;

			this.ShowChargeLevel();

			if (flAmmoRegenPoints < 1)
			{
				this.Remove();
			}
			else
			{
				Engine.EmitSoundEntity(pPlayerEntity, "Weapon_Glock18c.SlideBack");
			}
		}
	}

	void PickUp(int PlayerIndex, int ArrPos)
	{
		if (g_AmmoRegen_Index[PlayerIndex] != -1)
		{
			CAmmoRegen@ pPlayerAmmoRegen = g_AmmoRegen[g_AmmoRegen_Index[PlayerIndex]];
			CBaseEntity@ pAmmoRegenEntity = FindEntityByEntIndex(iEntIndex);
			float PickUpPts = pPlayerAmmoRegen.GetPoints();

			pPlayerAmmoRegen.AddPoints(flAmmoRegenPoints);

			PickUpPts += flAmmoRegenPoints;
			PickUpPts -= CONST_AK_PTS_MAX;

			if (PickUpPts > 0)
			{
				pAmmoRegenEntity.SetEntityName("drop_ammoregen");
				this.SetPoints(PickUpPts);
				this.Drop(PlayerIndex);
			}
			else
			{
				CBaseEntity@ pEntity = FindEntityByEntIndex(iEntIndex);
				pEntity.SetEntityName("empty");
				Engine.Ent_Fire("empty", "kill");
			}
		}
		else
		{
			g_AmmoRegen_Index[PlayerIndex] = ArrPos;
			iOwnerIndex = PlayerIndex;
			CBaseEntity@ pAmmoRegenEntity = FindEntityByEntIndex(iEntIndex);
			pAmmoRegenEntity.SetEntityName("ammoregen" + PlayerIndex);
			this.ShowChargeLevel();			
		}
	}

	void Drop(int PlayerIndex)
	{
		CZP_Player@ pOwnerPlayer = ToZPPlayer(PlayerIndex);
		pOwnerPlayer.DropWeapon(pOwnerPlayer.GetWeaponSlot("drop_ammoregen"));
	}

	void Dropped()
	{
		g_AmmoRegen_Index[iOwnerIndex] = -1;
		iOwnerIndex = 0;	
	}

	void ShowChargeLevel()
	{
		CBaseEntity@ pAmmoRegenEntity = FindEntityByEntIndex(iEntIndex);
		CBasePlayer@ pOwnerBasePlayer = ToBasePlayer(iOwnerIndex);
		CZP_Player@ pOwnerPlayer = ToZPPlayer(iOwnerIndex);
		int Percents = int((flAmmoRegenPoints / float(CONST_AK_PTS_MAX)) * 100.0f);

		HudTextParams Params;
		Params.x = -1;
		Params.y = 0.895f;
		Params.channel = 4;
		Params.fadeinTime = 0.0f;
		Params.fadeoutTime = 0.25f;
		Params.holdTime = 1.0f;
		Params.fxTime = 0.0f;
		Params.SetColor(Color(34, 84, 185));
		Params.SetColor2(Color(25, 66, 123));

		if ((flAmmoRegenPoints < 1 && flAmmoRegenPoints > 0) || flAmmoRegenPoints <= 0)
		{
			Percents = 0;
			Params.SetColor(Color(185, 28, 28));
			Params.holdTime = 1.95f;
		}
        else
        {
 		    Engine.Ent_Fire("ammoregen" + iOwnerIndex, "addoutput", "delivername Ammo Regen "+Percents+"%", "0.00");           
        }

		Utils.GameTextPlayer(pOwnerPlayer, "Ammo Regen "+Percents+"%", Params);
	}

	void Remove()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(iOwnerIndex);
		CBaseEntity@ pEntity = FindEntityByEntIndex(iEntIndex);
		g_AmmoRegen_Index[iOwnerIndex] = -1;
		pEntity.SetEntityName("empty");
		Engine.Ent_Fire("empty", "kill");

		Engine.EmitSoundEntity(pPlayerEntity, "Buttons.snd19");
		int length = int(g_AmmoRegen.length());
		for(int i = 0; i < length; i++)
		{
			if (g_AmmoRegen[i] is this)
			{
				g_AmmoRegen_Index[iOwnerIndex] = -1;
				g_AmmoRegen.removeAt(i);
				break;
			}
		}			
	}
}

void OnPluginInit()
{
	PluginData::SetVersion("1.0.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - AmmoRegen");

	Engine.EnableCustomSettings(true);
	iMaxPlayers = Globals.GetMaxClients();

	Events::Player::OnPlayerDamaged.Hook(@AmmoRegen_OnPlrDamaged);
	Events::Entities::OnEntityCreation.Hook(@AmmoRegen_OnEntDamaged);

	Engine.PrecacheFile(sound, "buttons/button19.wav");

	Entities::RegisterDrop("item_deliver");
	Entities::RegisterPickup("item_deliver");

	Entities::RegisterDrop("item_ammoregen");
	Entities::RegisterPickup("item_ammoregen");

    OnMapInit();
}

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
        iMaxPlayers = Globals.GetMaxClients();
		g_AmmoRegen.removeRange(0, g_AmmoRegen.length());
        g_AmmoRegen_Index.resize(iMaxPlayers + 1);

        for (int i = 1; i <= iMaxPlayers; i++)
        {
            g_AmmoRegen_Index[i] = -1;
        }
	}
}

void OnNewRound()
{
	if (bIsCSZM) 
	{
		g_AmmoRegen.removeRange(0, g_AmmoRegen.length());
		
		for (int i = 1; i <= iMaxPlayers; i++)
        {
            g_AmmoRegen_Index[i] = -1;
        }
	}
}

void OnMapShutdown()
{
	bIsCSZM = false;
}

HookReturnCode AmmoRegen_OnEntDamaged(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (!bIsCSZM)
	{
		return HOOK_CONTINUE;
	}

	if (pEntity.GetClassname() == "weapon_pipe")
	{
		CreateAmmoRegenItem(pEntity);
	}

	return HOOK_CONTINUE;
}

HookReturnCode AmmoRegen_OnPlrDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &in info)
{
	if (!bIsCSZM)
	{
		return HOOK_CONTINUE;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	CBaseEntity@ pAttacker = info.GetAttacker();

	if (pBaseEnt.GetTeamNumber() == 3 && pAttacker.GetTeamNumber() == 2 && pAttacker.IsPlayer())
	{
		CZP_Player@ pPlayerAttacker = ToZPPlayer(pAttacker);
		CAmmoRegen@ pAmmoRegen = g_AmmoRegen[g_AmmoRegen_Index[pAttacker.entindex()]];
		if (pAmmoRegen !is null)
		{
			pAmmoRegen.RegenAmmo(info.GetDamageType());
		}
	}

	return HOOK_CONTINUE;	
}

CBaseEntity@ CreateAmmoRegenItem(CBaseEntity@ pEntity)
{
	CEntityData@ AmmoRegenIDP = EntityCreator::EntityData();
	AmmoRegenIDP.Add("targetname", "ammoregen");
	AmmoRegenIDP.Add("viewmodel", "models/weapons/w_empty.mdl");
	AmmoRegenIDP.Add("model", "models/items/boxsrounds.mdl");
	AmmoRegenIDP.Add("itemstate", "0");
	AmmoRegenIDP.Add("isimportant", "1");
	AmmoRegenIDP.Add("carrystate", "0");
	AmmoRegenIDP.Add("glowcolor", "255 128 0");
	AmmoRegenIDP.Add("delivername", "Ammo Regen 100%");
	AmmoRegenIDP.Add("sound_pickup", "BaseCombatCharacter.AmmoPickup");
	AmmoRegenIDP.Add("printname", "vgui/images/hud/ammobank/ammo_icons/rifle");
	AmmoRegenIDP.Add("weight", "15");
	AmmoRegenIDP.Add("DisableDamageForces", "0", true);

	CBaseEntity@ pAmmoRegenItem = EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), AmmoRegenIDP);

    pAmmoRegenItem.SetClassname("item_ammoregen");
    g_AmmoRegen.insertLast(CAmmoRegen(pAmmoRegenItem.entindex()));

	pEntity.SUB_Remove();

	return pAmmoRegenItem;
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (!bIsCSZM)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	int iPlayerIndex = pBaseEnt.entindex();

	if (pEntity.GetClassname() == "item_ammoregen")
	{
		CAmmoRegen@ pAmmoRegen = GetAmmoRegen(pEntity.entindex());

		if (pAmmoRegen !is null)
		{
			pAmmoRegen.PickUp(iPlayerIndex, pAmmoRegen.GetArrayPos());
		}
	}
}

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (!bIsCSZM)
	{
		return;
	}
	
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	int iPlayerIndex = pBaseEnt.entindex();

	if (pEntity.GetClassname() == "item_ammoregen")
	{
		CAmmoRegen@ pAmmoRegen = GetAmmoRegen(pEntity.entindex());

		if (pAmmoRegen !is null)
		{
			pAmmoRegen.Dropped();
		}
	}

	if (pEntity.GetEntityName() == "drop_ammoregen")
	{
		pEntity.SetEntityName("ammoregen");
	}
}
