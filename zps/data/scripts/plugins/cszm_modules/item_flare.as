array<array<string>> g_RandomClassname =
{
	{
		"weapon_ppk",
		"weapon_usp",
		"weapon_glock",
		"weapon_glock18c",
		"weapon_revolver",
		"weapon_mp5",
		"weapon_m4",
		"weapon_ak47",
		"weapon_supershorty",
		"weapon_winchester",
		"weapon_870"
	},
	{
		"weapon_frag",
		"weapon_ied",
		"weapon_machete"
	},
	{
		"item_ammo_pistol",
		"item_ammo_rifle",
		"item_ammo_shotgun",
		"item_ammo_revolver"
	},
	{
		"item_pills",
		"item_healthkit",
		"item_armor"
	}
};

RandomItem@ pCSZMRandomItems;

class RandomItem
{
	private int previous;

	RandomItem()
	{
		previous = -1;	
	}

	void Spawn(CBaseEntity@ pEntity)
	{
		SpawnEnt(GetRandomClass(), pEntity.GetAbsOrigin(), pEntity.GetAbsAngles());
		pEntity.SUB_Remove();
	}

	void SpawnInOrigin(Vector nOrigin)
	{
		SpawnEnt(GetRandomClass(), nOrigin, QAngle(0, 0, 0));
	}

	void SpawnClassName(CBaseEntity@ pEntity, string nClassname)
	{
		SpawnEnt(nClassname, pEntity.GetAbsOrigin(), pEntity.GetAbsAngles());
	}

	private string GetRandomClass()
	{
		int random = previous;
		int randomclass = 0;

		while (random == previous)
		{
			random = Math::RandomInt(0, g_RandomClassname.length() - 1);
		}

		previous = random;
		randomclass = Math::RandomInt(0, g_RandomClassname[random].length() - 1);

		return g_RandomClassname[random][randomclass];
	}

	private void SpawnEnt(string nClassname, Vector nOrigin, QAngle nAngles)
	{
		CEntityData@ ItemIPD = EntityCreator::EntityData();
		ItemIPD.Add("origin", "" + nOrigin.x + " " + nOrigin.y + " " + nOrigin.z);
		ItemIPD.Add("disabledamageforces", "1", true);
		EntityCreator::Create(nClassname, nOrigin, nAngles, ItemIPD);
	}
}