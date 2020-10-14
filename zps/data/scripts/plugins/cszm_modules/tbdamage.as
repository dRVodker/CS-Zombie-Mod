//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Time Based Damage
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

enum TBD_Types {TBD_BLEEDING}
const float TBD_TikTime = 0.74f;

class TimeBasedDamage
{
	private float WaitTime;
	int Tiks;
	private int AttakerIndex;
	private int Type;

	TimeBasedDamage(int nAttakerIndex, float nDamage, int nType)
	{
		Type = nType;
		WaitTime = Globals.GetCurrentTime() + TBD_TikTime;
		Tiks += int(ceil(nDamage / 121.0f * 20.0f));
		AttakerIndex = nAttakerIndex;
	}

	void Think(CBaseEntity@ pTarget)
	{
		if (WaitTime <= Globals.GetCurrentTime() && WaitTime != 0 && Tiks > 0 && pTarget !is null && pTarget.IsAlive())
		{
			WaitTime = Globals.GetCurrentTime() + TBD_TikTime;
			CBaseEntity@ pAttaker = FindEntityByEntIndex(AttakerIndex);

			if (pAttaker is null || (pAttaker.GetTeamNumber() == pTarget.GetTeamNumber() && pTarget.entindex() != AttakerIndex))
			{
				@pAttaker = pTarget;
				AttakerIndex = pTarget.entindex();
			}

			EmitEffects(pTarget.entindex());
			DoDamage(pTarget, pAttaker);
			Tiks--;
		}
	}

	private void DoDamage(CBaseEntity@ pVic, CBaseEntity@ pAtt)
	{
		CTakeDamageInfo DamageInfo;

		DamageInfo.SetAttacker(pAtt);
		DamageInfo.SetInflictor(pVic);
		DamageInfo.SetDamage(15);
		DamageInfo.SetDamageType((1<<17));//1<<28
		DamageInfo.SetDamageForce(Vector (0, 0, -128));
		DamageInfo.SetDamagePosition(pVic.EyePosition());

		pVic.TakeDamage(DamageInfo);
	}

	private void EmitEffects(int index)
	{
		switch(Type)
		{
			case TBD_BLEEDING: EmitBlood(index); break;
		}
	}
}

void EmitBlood(const int &in index)
{
	CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(index);

	Utils.ScreenFade(ToZPPlayer(index), Color(125, 35, 30, 75), 0.295f, 0, fade_in);
	Chat.CenterMessagePlayer(ToBasePlayer(index), "!! Кровотечение !!");

	CEntityData@ InputData = EntityCreator::EntityData();
	InputData.Add("amount", "128");
	InputData.Add("spawnflags", "8");
	InputData.Add("spraydir", "90 0 0");
	InputData.Add("color", "0");

	InputData.Add("EmitBlood", "0", true, "0.00");
	InputData.Add("kill", "0", true, "0.00");

	CBaseEntity@ pBlood = EntityCreator::Create("env_blood", pPlayerEntity.GetAbsOrigin() + Vector(0, 0, 14) + ((pPlayerEntity.EyePosition() - pPlayerEntity.GetAbsOrigin()) / 2), QAngle(90, 0, 0) , InputData);
	Engine.EmitSoundEntity(pBlood, "flesh_gibs_Head.OnHit");	
}