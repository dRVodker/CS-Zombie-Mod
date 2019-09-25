#include "./cszm_modules/teamnums.as"

bool bIsCSZM = false;

bool bDamageType(int &in iSubjectDT, int &in iDMGNum)
{
	bool bIsDTValid = false;

	if (iSubjectDT & (1<<iDMGNum) == (1<<iDMGNum))
	{
		bIsDTValid = true;
	}

	return bIsDTValid;
}

array<string> g_strEntities = 
{
	"prop_door_rotating", //0
	"prop_physics_multiplayer", //1
	"prop_physics_override", //2
	"prop_physics", //3
	"func_door_rotating", //4
	"func_door", //5
	"func_breakable", //6
	"func_physbox", //7
	"prop_barricade" //8
};

array<int> g_PhysTPIndex;
array<int> g_PhysTPOwner;

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Show HP of Breakables");

	//Events
	Events::Custom::OnEntityDamaged.Hook(@CSZM_SHP_OnEntDamaged);
	Events::Custom::OnPlayerDamagedCustom.Hook(@CSZM_SHP_OnPlrDamaged);
}

void OnMapInit()
{	
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		bIsCSZM = false;
		OnNewRound();	
	}
}

void OnNewRound()
{
	g_PhysTPIndex.removeRange(0, g_PhysTPIndex.length());
	g_PhysTPOwner.removeRange(0, g_PhysTPOwner.length());
}

HookReturnCode CSZM_SHP_OnPlrDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &out DamageInfo)
{
	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (Utils.StrContains("physics", pAttacker.GetClassname()) || Utils.StrContains("physbox", pAttacker.GetClassname()))
	{
		for (uint i = 0; i < g_PhysTPIndex.length(); i++)
		{
			if (pAttacker.entindex() == g_PhysTPIndex[i])
			{
				CBaseEntity@ pNewAttacker = FindEntityByEntIndex(g_PhysTPOwner[i]);
				
				if (pNewAttacker !is null) 
				{
					DamageInfo.SetInflictor(pNewAttacker);
					DamageInfo.SetAttacker(pNewAttacker);
				}
			}
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_SHP_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	if (!bIsCSZM)
	{
		return HOOK_HANDLED;
	}

	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();
	bool bIsUnbreakable = false; 

	if (Utils.StrContains("unbrk", pEntity.GetEntityName()) || Utils.StrContains("unbreakable", pEntity.GetEntityName()))
	{
		bIsUnbreakable = true;
	}

	//50% of damage resist for "prop_barricade"
	if (Utils.StrEql(pEntity.GetClassname(), "prop_barricade"))
	{
		DamageInfo.SetDamage(DamageInfo.GetDamage() * 0.5f);
	}

	//Show HP
	if (pAttacker.IsPlayer() && pAttacker.GetTeamNumber() == TEAM_ZOMBIES && !bIsUnbreakable)
	{
		int iSlot = pAttacker.entindex();
		bool bIsValid = false;

		for (uint i = 0; i < g_strEntities.length(); i++)
		{
			if (bIsValid)
			{
				continue;
			}

			if (Utils.StrEql(pEntity.GetClassname(), g_strEntities[i]))
			{
				bIsValid = true;
			}
		}

		if (bIsValid)
		{
			bool bLeft = false;
			float flDMG = DamageInfo.GetDamage();
			float flHP = pEntity.GetHealth();
			float flResult = flHP - flDMG;

			if (flDMG > 0)
			{
				bLeft = true;
			}

			if (flResult > 0)
			{
				ShowHP(ToBasePlayer(iSlot), int(flResult), bLeft, false);
			}

			else
			{
				ShowHP(ToBasePlayer(iSlot), int(flResult), bLeft, true);
			}
		}
	}

	//Other stuff
	//Rule to prevent TK with physics
	if (Utils.StrContains("physics", pEntity.GetClassname()) || Utils.StrContains("physbox", pEntity.GetClassname()))
	{
		if (pAttacker.IsPlayer())
		{
			int iIndex = pEntity.entindex();
			bool bIsIndexValid = false;

			pEntity.ChangeTeam(pAttacker.GetTeamNumber());

			if (g_PhysTPIndex.length() > 0)
			{
				for (uint i = 0; i < g_PhysTPIndex.length(); i++)
				{
					if (bIsIndexValid)
					{
						continue;
					}

					if (iIndex == g_PhysTPIndex[i])
					{
						 bIsIndexValid = true;
						g_PhysTPOwner[i] = pAttacker.entindex();
					}
				}
			}

			if (bIsIndexValid == false)
			{
				g_PhysTPIndex.insertLast(iIndex);
				g_PhysTPOwner.insertLast(pAttacker.entindex());
			}
		}
	}

	//Special rule for prop_physics
	if (Utils.StrContains("physics", pEntity.GetClassname()))
	{
		//Getting some important data there
		string MDLName = pEntity.GetModelName();
		int DMGType = DamageInfo.GetDamageType();
		float DMG = DamageInfo.GetDamage();
		float flMultiplier = 22.0f;

		//Only for survivors
		if (pAttacker.IsPlayer() && pAttacker.GetTeamNumber() == TEAM_SURVIVORS)
		{
			//If Damage Type is BULLET reduce amount of damage and increase force
			if (bDamageType(DMGType, 1))
			{
				//If revolver bullet
				if (bDamageType(DMGType, 13) && DMG > 30)
				{
					flMultiplier = 8.0f;
				}

				//If buckshot
				else if (bDamageType(DMGType, 29))
				{
					flMultiplier = 1.02f;
				}

				//Set DMG_BULLET Damage Type, otherwise it won't push
				DamageInfo.SetDamageType(1<<1);
				DamageInfo.SetDamageForce(DamageInfo.GetDamageForce() * flMultiplier);

				//Do not reduce damage if explosive props
				if (Utils.StrContains("propanecanister001a", MDLName) ||
				Utils.StrContains("oildrum001_explosive", MDLName) ||
				Utils.StrContains("fire_extinguisher", MDLName) ||
				Utils.StrContains("vent001", MDLName) ||
				Utils.StrContains("canister01a", MDLName) ||
				Utils.StrContains("canister02a", MDLName) ||
				Utils.StrContains("propane_tank001a", MDLName) ||
				Utils.StrContains("gascan001a", MDLName))
				{
					return HOOK_HANDLED;
				}
				
				DamageInfo.SetDamage(DMG * 0.021f);
			}
		}
	}

	//Break "prop_itemcrate" if punt
	if (Utils.StrEql(pEntity.GetClassname(), "prop_itemcrate") && DamageInfo.GetDamageType() == (1<<23))
	{
		DamageInfo.SetDamageType(1<<13);
		DamageInfo.SetDamage(pEntity.GetHealth());
		return HOOK_HANDLED;
	}

	//Don't deal any damage if unbreakable
	if (bIsUnbreakable)
	{
		DamageInfo.SetDamage(0);
		return HOOK_HANDLED;
	}

	//Don't push weapons and items
	if (Utils.StrContains("weapon", pEntity.GetClassname()) || Utils.StrContains("item", pEntity.GetClassname()))
	{
		DamageInfo.SetDamageType((1<<11));
		DamageInfo.SetDamageForce(Vector(0, 0, 0));
		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

void ShowHP(CBasePlayer@ pBasePlayer, const int &in iHP, const bool &in bLeft, const bool &in bHide)
{
	if (bHide)
	{
		Chat.CenterMessagePlayer(pBasePlayer, "");
	}

	else
	{
		string strLeft = "";

		if (bLeft)
		{
			strLeft = " Left";
		}

		Chat.CenterMessagePlayer(pBasePlayer, iHP + " HP" + strLeft);
	}
}