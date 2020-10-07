//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Data
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

int MaxRandomCash = 10;
int MinRandomCash = 3;

int MaxSpecialCash = -1;
int MinSpecialCash = -1;

float MaxMoneyPerItem = 200.0f;
float MinMoneyPerItem = 25.0f;

array<SpawnCash@> g_RandomCash;
array<SpawnCash@> g_SpecialCash;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Classes
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

class InsertToArray
{
	InsertToArray(const float nX, const float nY, const float nZ)
	{
		Insert(nX, nY, nZ, 0);
	}

	InsertToArray(const float nX, const float nY, const float nZ, const int nA)
	{
		Insert(nX, nY, nZ, nA);
	}

	private void Insert(const float nX, const float nY, const float nZ, const int nA)
	{
		nA > 0 ? g_SpecialCash.insertLast(SpawnCash(nX, nY, nZ, nA)) : g_RandomCash.insertLast(SpawnCash(nX, nY, nZ));
	}
}

class SpawnCash
{
	private float X;
	private float Y;
	private float Z;
	private int Amount;

	SpawnCash(const float nX, const float nY, const float nZ)
	{
		Amount = -1;
		SetOrigin(nX, nY, nZ);
	}

	SpawnCash(const float nX, const float nY, const float nZ, const int nA)
	{
		Amount = nA;
		SetOrigin(nX, nY, nZ);
	}

	int GetMoneyCount()
	{
		return Amount;
	}

	Vector GetOrigin()
	{
		return Vector(X, Y, Z);
	}

	private void SetOrigin(const float nX, const float nY, const float nZ)
	{
		X = nX;
		Y = nY;
		Z = nZ;
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Action
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void SpawnCashItems()
{
	SpawnRandomCash();
	SpawnSpecialCash();
}

void SpawnRandomCash()
{
	if (g_RandomCash.length() > 0)
	{
		uint iItemsCount = Math::RandomInt(MinRandomCash, MaxRandomCash);
		uint iLength = g_RandomCash.length();
		array<SpawnCash@> p_RandomCash;

		if (iItemsCount > iLength || (MinRandomCash == -1 || MaxRandomCash == -1))
		{
			iItemsCount = iLength;
		}

		for (uint i = 0; i < iLength; i++)
		{
			p_RandomCash.insertLast(g_RandomCash[i]);
		}

		while (iItemsCount != 0)
		{
			int RND_ArrPos = Math::RandomInt(0, p_RandomCash.length() - 1);

			CBaseEntity@ pMoneyItem = SpawnCashEntity(Vector(p_RandomCash[RND_ArrPos].GetOrigin()));
			pMoneyItem.SetHealth(int(floor(Math::RandomFloat(MinMoneyPerItem, MaxMoneyPerItem) / 5) * 5));
			p_RandomCash.removeAt(RND_ArrPos);

			iItemsCount--;
		}
	}
}

void SpawnSpecialCash()
{
	if (g_SpecialCash.length() > 0)
	{
		uint iItemsCount = Math::RandomInt(MinSpecialCash, MaxSpecialCash);
		uint iLength = g_SpecialCash.length();
		array<SpawnCash@> p_SpecialCash;

		if (iItemsCount > iLength || (MinSpecialCash == -1 || MaxSpecialCash == -1))
		{
			iItemsCount = iLength;
		}

		for (uint i = 0; i < iLength; i++)
		{
			p_SpecialCash.insertLast(g_SpecialCash[i]);
		}

		while (iItemsCount != 0)
		{
			int RND_ArrPos = Math::RandomInt(0, p_SpecialCash.length() - 1);

			CBaseEntity@ pMoneyItem = SpawnCashEntity(Vector(p_SpecialCash[RND_ArrPos].GetOrigin()));
			pMoneyItem.SetHealth(p_SpecialCash[RND_ArrPos].GetMoneyCount());
			p_SpecialCash.removeAt(RND_ArrPos);

			iItemsCount--;
		}
	}
}

CBaseEntity@ SpawnCashEntity(Vector nOrigin)
{
	CEntityData@ InputData = EntityCreator::EntityData();

	InputData.Add("canfirehurt", "0");
	InputData.Add("minhealthdmg", "1000");
	InputData.Add("model", "models/zp_props/100dollar/100dollar.mdl");
	InputData.Add("nodamageforces", "1");
	InputData.Add("nofiresound", "1");
	InputData.Add("physdamagescale", "0");
	InputData.Add("spawnflags", "8582");
	InputData.Add("unbreakable", "1");
	InputData.Add("overridescript", "mass,1,");
	InputData.Add("DisableDamageForces", "0", true);

	CBaseEntity@ pMoneyItem = EntityCreator::Create("prop_physics_override", nOrigin, QAngle(0, Math::RandomFloat(-180.0f, 180.0f), 0), InputData);
	pMoneyItem.SetClassname("item_money");
	pMoneyItem.SetOutline(true, filter_team, 2, Color(235, 65, 175), 185.0f, false, true);

	return pMoneyItem;
}