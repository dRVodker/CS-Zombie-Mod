/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Time Based Damage
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

enum TBD_Types {TBD_BLEEDING}

array<int> g_TBD_DamageType = {(1<<28)};
array<float> g_TBD_TikTime = {0.91f};
array<float> g_TBD_Damage = {10.0f};

int GetTiksCount(float nDamage)
{
	return int(ceil(nDamage / 150 * 100 * 0.1f));
}

class TimeBasedDamage
{
	private float WaitTime;
	private int Tiks;
	private int AttakerIndex;
	private int Type;

	TimeBasedDamage(int nAttakerIndex, float nDamage, int nType)
	{
		Type = nType;
		WaitTime = Globals.GetCurrentTime() + g_TBD_TikTime[Type];
		UpdateInfo(nAttakerIndex, nDamage);
	}

	void UpdateInfo(int nAttakerIndex, float nDamage)
	{
		Tiks += GetTiksCount(nDamage);
		AttakerIndex = nAttakerIndex;
	}

	bool Think(CBaseEntity@ pTarget)
	{
		if (WaitTime <= Globals.GetCurrentTime() && WaitTime != 0 && Tiks > 0 && pTarget !is null && pTarget.IsAlive())
		{
			CBaseEntity@ pAttaker = FindEntityByEntIndex(AttakerIndex);

			if (pAttaker is null)
			{
				@pAttaker = pTarget;
				AttakerIndex = pTarget.entindex();
			}

			EmitEffects(pTarget.entindex());

			WaitTime = Globals.GetCurrentTime() + g_TBD_TikTime[Type];
			Tiks--;
			
			DoDamage(pTarget, pAttaker);
		}

		return (Tiks == 0 || !pTarget.IsAlive());
	}

	private void DoDamage(CBaseEntity@ pVic, CBaseEntity@ pAtt)
	{
		CTakeDamageInfo DamageInfo;

		DamageInfo.SetAttacker(pAtt);
		DamageInfo.SetInflictor(pVic);
		DamageInfo.SetDamage(g_TBD_Damage[Type]);
		DamageInfo.SetDamageType(g_TBD_DamageType[Type]);
		DamageInfo.SetDamageForce(Vector (0, 0, -128));
		DamageInfo.SetDamagePosition(pVic.EyePosition());

		pVic.TakeDamage(DamageInfo);
	}

	private void EmitEffects(int index)
	{
		switch(Type)
		{
			case TBD_BLEEDING:
				EmitBlood(index);
			break;
		}
	}
}

void EmitBlood(const int &in index)
{
	CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(index);

	Utils.ScreenFade(ToZPPlayer(index), Color(125, 35, 30, 75), 0.295f, 0, fade_in);
	Chat.CenterMessagePlayer(ToBasePlayer(index), "!! Bleeding !!");

	CEntityData@ InputData = EntityCreator::EntityData();
	InputData.Add("amount", "64");
	InputData.Add("spawnflags", "8");
	InputData.Add("spraydir", "90 0 0");
	InputData.Add("color", "0");

	InputData.Add("EmitBlood", "0", true, "0.00");
	InputData.Add("kill", "0", true, "0.00");

	EntityCreator::Create("env_blood", pPlayerEntity.GetAbsOrigin() + Vector(0, 0, 2), QAngle(90, 0, 0) , InputData);
}