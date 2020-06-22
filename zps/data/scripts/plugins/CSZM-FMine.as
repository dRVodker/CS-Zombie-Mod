#include "./cszm_modules/teamnums.as"
#include "./cszm_modules/customitems.as"

const float CONST_FMINE_TIK = 0.05f;

int iMaxPlayers;
bool bIsCSZM = false;

array<CFragMine@> FMArray;

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Anti-personnel Mine");

	Events::Entities::OnEntityCreation.Hook(@CSZM_FM_OnEntityCreation);
	Events::Entities::OnEntityDestruction.Hook(@CSZM_FM_OnEntityDestruction);
	Events::Custom::OnEntityDamaged.Hook(@CSZM_FM_OnEntDamaged);
}

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;

		iMaxPlayers = Globals.GetMaxClients();

		Entities::RegisterUse("item_deliver");
		Entities::RegisterDrop("item_deliver");
		Entities::RegisterUse("npc_fragmine");

		Engine.PrecacheFile(sound, "weapons/slam/throw.wav");
		Engine.PrecacheFile(sound, "weapons/slam/mine_mode.wav");
		Engine.PrecacheFile(sound, "weapons/slam/buttonclick.wav");
		Engine.PrecacheFile(sound, "weapons/357/357_reload3.wav");

		Engine.PrecacheFile(model, "models/cszm/weapons/w_minefrag.mdl");
		Engine.PrecacheFile(model, "models/cszm/weapons/v_minefrag.mdl");

		SetUpIPD(1<<1);
	}
}

class CFragMine
{
	private int iOwnerIndex;
	private int iMineIndex;
	private int iMineTeam;
	private float flMineTimer;
	private float flTimer;

	CFragMine(int PlayerIndex, int EntIndex, int Team, float Time)
	{
		iOwnerIndex = PlayerIndex;
		iMineIndex = EntIndex;
		iMineTeam = Team;
		flMineTimer = Globals.GetCurrentTime() + Time;
		flTimer = 0;
	}

	int GetMineIndex() {return iMineIndex;}
	int GetOwnerIndex() {return iOwnerIndex;}
	int GetTeamNumber() {return iMineTeam;}

	private void LoseOwnerIndex()
	{
		CBaseEntity@ pFragMine = FindEntityByEntIndex(iMineIndex);
		iOwnerIndex = iMineIndex;
		pFragMine.SetEntityDescription(formatInt(iMineIndex));
		pFragMine.SetOutline(true, filter_team, TEAM_SURVIVORS, Color(245, 245, 245), 512.0f, false, true);
	}

	void Think()
	{
		CBaseEntity@ pOwnerEntity = FindEntityByEntIndex(iOwnerIndex);
		CBaseEntity@ pMineEntity = FindEntityByEntIndex(iMineIndex);

		if ((pOwnerEntity is null && iOwnerIndex != iMineIndex) || pOwnerEntity.GetTeamNumber() != iMineTeam || !pOwnerEntity.IsAlive())
		{
			LoseOwnerIndex();
			@pOwnerEntity = pMineEntity;
		}

		if (!pMineEntity.Intersects(pOwnerEntity) && pMineEntity.GetOwner() !is null)
		{
			pMineEntity.SetOwner(null);
		}

		if (flMineTimer <= Globals.GetCurrentTime() && flMineTimer != 0)
		{
			flMineTimer = 0;
			flTimer = Globals.GetCurrentTime() + CONST_FMINE_TIK;
			pMineEntity.SetSkin(1);
			Engine.EmitSoundPosition(iMineIndex, "weapons/slam/mine_mode.wav", pMineEntity.GetAbsOrigin(), 1.0f, 75, 105);

			if (pOwnerEntity.IsPlayer())
			{
				pMineEntity.SetOutline(true, filter_entity, iOwnerIndex, Color(245, 32, 64), 384.0f, false, true);
			}
		}

		if (flTimer <= Globals.GetCurrentTime() && flTimer != 0)
		{
			flTimer = Globals.GetCurrentTime() + CONST_FMINE_TIK;

			for (int i = 1; i <= iMaxPlayers; i++)
			{
				CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

				if (pPlayerEntity is null) {continue;}

				if ((pPlayerEntity.GetTeamNumber() == TEAM_ZOMBIES || i == iOwnerIndex) && pPlayerEntity.Intersects(pMineEntity) && pPlayerEntity.IsAlive())
				{
					flTimer = 0;

					CTakeDamageInfo DamageInfo;
					DamageInfo.SetInflictor(pOwnerEntity);
					DamageInfo.SetAttacker(pOwnerEntity);
					DamageInfo.SetDamage(pMineEntity.GetHealth());
					DamageInfo.SetDamageType(DMG_GENERIC);

					pMineEntity.TakeDamage(DamageInfo);
				}
			}
		}
	}
}

void OnMapShutdown()
{
	if (bIsCSZM) 
	{
		bIsCSZM = false;
		FMArray.removeRange(0, FMArray.length());
		ClearIPD();
	}
}

void OnNewRound()
{
	if (bIsCSZM) 
	{
		FMArray.removeRange(0, FMArray.length());
	}
}

void OnProcessRound()
{
	if (bIsCSZM)
	{
		uint iFMArrLength = FMArray.length();

		for (uint q = 0; q < iFMArrLength; q++)
		{
			(FMArray[q] !is null) ? FMArray[q].Think() : FMArray.removeAt(q);
		}
	}
}

HookReturnCode CSZM_FM_OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (bIsCSZM)
	{
		if (Utils.StrEql("weapon_machete", strClassname))
		{
			SpawnWepFragMine(pEntity);
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_FM_OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (Utils.StrEql(strClassname, "npc_fragmine"))
	{
		for (uint q = 0; q < FMArray.length(); q++)
		{
			CFragMine@ pFragMine = FMArray[q];
			if (pFragMine is null) { FMArray.removeAt(q); continue;}
			if (pFragMine.GetMineIndex() == pEntity.entindex()) { FMArray.removeAt(q); break; }
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_FM_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();
	int iAttackerIndex = pAttacker.entindex();
	int iAttackerTeam = pAttacker.GetTeamNumber();

	if (Utils.StrEql(pEntity.GetClassname(), "npc_fragmine"))
	{
		pEntity.Teleport(pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), Vector(0, 0, 0));

		DamageInfo.SetDamage(pEntity.GetHealth());
		DamageInfo.SetDamageType(1<<28);

		CFragMine@ pFragMine = FindFragMineByEntIndex(pEntity.entindex());
		CBaseEntity@ pOwnerEntity = FindEntityByEntIndex(pFragMine.GetOwnerIndex());

		if ((iAttackerTeam == TEAM_SURVIVORS && pAttacker.IsPlayer()) && iAttackerIndex != pFragMine.GetOwnerIndex() && pAttacker !is pEntity && pOwnerEntity !is pEntity)
		{
			DamageInfo.SetDamage(0);
			DamageInfo.SetDamageType(0);
		}
		else
		{
			if (pOwnerEntity is null || pOwnerEntity is pEntity)
			{
				pEntity.SetEntityDescription(formatInt(iAttackerIndex));
				@pOwnerEntity = pAttacker;
			}
			SpawnShrapnel(pOwnerEntity.entindex(), pEntity.GetAbsOrigin());	
			EmitFMineEffects(pEntity.GetAbsOrigin());			
		}
	}

	return HOOK_CONTINUE;
}

void SpawnShrapnel(const int &in iOwnerIndex, Vector Orinig)
{
	CEntityData@ ImputData = EntityCreator::EntityData();

	ImputData.Add("targetname", "frendly_shrapnel");
	ImputData.Add("model", "models/weapons/w_ppk.mdl");
	ImputData.Add("spawnflags", "256");
	ImputData.Add("disablebonefollowers", "1");
	ImputData.Add("disableshadows", "1");
	ImputData.Add("rendermode", "10");
	ImputData.Add("solid", "0");
	
	ImputData.Add("kill", "0", true, "0.01");

	CBaseEntity@ pShrapnel = EntityCreator::Create("prop_dynamic_override", Vector(0, 0, 0), QAngle(0, 0, 0), ImputData);

	pShrapnel.SetClassname("npc_shrapnel");
	pShrapnel.ChangeTeam(TEAM_SPECTATORS);
	pShrapnel.SetHealth(iOwnerIndex);

	Utils.CreateShrapnelEx(pShrapnel, 27, Orinig + Vector(0, 0, 1), 0.0f); 
}

void EmitFMineEffects(Vector Orinig)
{
	int iFree;
	int iUsed;

	Engine.EdictCount(iFree, iUsed);

	int iShowerCount = Math::RandomInt(1, 3);
	int iTracerCount = Math::RandomInt(18, 27);

	if (iUsed > 1964)
	{
		iShowerCount = 1;
		iTracerCount = -1;
	}

	while (iShowerCount > 0)
	{
		iShowerCount--;
		CBaseEntity@ pShower = EntityCreator::Create("spark_shower", Orinig, QAngle(0, 0, 0));
		Vector vUP;
		Globals.AngleVectors(QAngle(Math::RandomFloat(-55, -78), Math::RandomFloat(0, 270), Math::RandomFloat(0, 270)), vUP);
		pShower.SetAbsVelocity(vUP * Math::RandomInt(247, 389));
	}

	while (iTracerCount > 0)
	{
		iTracerCount--;
		CEntityData@ TracerIPD = EntityCreator::EntityData();
		TracerIPD.Add("rendercolor", "255 155 5");
		TracerIPD.Add("rendermode", "5");
		TracerIPD.Add("spritename", "sprites/xbeam2.vmt");
		TracerIPD.Add("endwidth", formatFloat(Math::RandomFloat(0.21, 0.37), 'l', 3, 3));
		TracerIPD.Add("lifetime", formatFloat(Math::RandomFloat(0.032, 0.196), 'l', 3, 3));
		TracerIPD.Add("renderamt", formatInt(Math::RandomInt(195, 235)));
		TracerIPD.Add("startwidth", formatFloat(Math::RandomFloat(1.85, 2.85), 'l', 2, 2));
		TracerIPD.Add("kill", "0", true, formatFloat(Math::RandomFloat(0.194, 0.842), 'l', 2, 2));

		CBaseEntity@ pTracer = EntityCreator::Create("env_spritetrail", Orinig, QAngle(0, 0, 0), TracerIPD);

		Vector vUP;
		pTracer.SetMoveType(MOVETYPE_FLYGRAVITY);
		Globals.AngleVectors(QAngle(Math::RandomFloat(-2, -72), Math::RandomFloat(0, 360), Math::RandomFloat(0, 360)), vUP);
		pTracer.SetAbsVelocity(vUP * Math::RandomInt(2750, 2995));
	}
}

void OnItemDeliverUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity, int &in iEntityOutput)
{
	if (!bIsCSZM || pPlayer is null || pEntity is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int iIndex = pBaseEnt.entindex();

	if (Utils.StrEql(pEntity.GetEntityName(), "weapon_fragmine"))
	{
		ThrowMine(iIndex, pPlayer, pEntity);
	}
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (!bIsCSZM || pPlayer is null || pEntity is null)
	{
		 return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();
	int iTeamNum = pBaseEnt.GetTeamNumber();
	
	if (Utils.StrEql(pEntity.GetClassname(), "npc_fragmine") && iTeamNum == TEAM_SURVIVORS)
	{
		uint iFMArrLength = FMArray.length();

		for (uint q = 0; q < iFMArrLength; q++)
		{
			CFragMine@ pFragMine = FMArray[q];

			if (pFragMine is null || pFragMine.GetMineIndex() != pEntity.entindex())
			{
				continue;
			}

			(pFragMine.GetOwnerIndex() == iIndex || pFragMine.GetOwnerIndex() == 0) ? DefuseFragMine(pEntity, pPlayer) : Chat.PrintToChatPlayer(pPlrEnt, "Эта мина одного из выживших, вы не можете обезвредить и забрать её!");
		}
	}
}

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (!bIsCSZM || pPlayer is null || pEntity is null)
	{
		return;
	}

	if (Utils.StrEql(pEntity.GetEntityName(), "wf_used"))
	{
		pEntity.SUB_Remove();
	}
}

void ThrowMine(const int &in iIndex, CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(iIndex);
	int iPlayerTeam = pPlayerEntity.GetTeamNumber();

	Vector vecMVelocity = pPlayerEntity.GetAbsVelocity();

	Globals.AngleVectors(pPlayerEntity.EyeAngles(), vecMVelocity);

	CEntityData@ FragMineIPD = EntityCreator::EntityData();
	FragMineIPD.Add("targetname", "test_fragmine");
	FragMineIPD.Add("model", "models/cszm/weapons/w_minefrag.mdl");
	FragMineIPD.Add("spawnflags", "10118");		//10114
	FragMineIPD.Add("skin", "0");
	FragMineIPD.Add("overridescript", "mass,60,rotdamping,10000,damping,0,inertia,0,");
	FragMineIPD.Add("nodamageforces", "1");
	FragMineIPD.Add("nofiresound", "1");
	FragMineIPD.Add("ExplodeDamage", "275");	//423
	FragMineIPD.Add("ExplodeRadius", "162");

	CBaseEntity@ pFragMine = EntityCreator::Create("prop_physics_override", Vector(0, 0, 0), QAngle(0, 0, 0), FragMineIPD);

	FMArray.insertLast(CFragMine(iIndex, pFragMine.entindex(), iPlayerTeam, 0.98f));
	pFragMine.SetClassname("npc_fragmine");
	pFragMine.SetOwner(pPlayerEntity);
	pFragMine.ChangeTeam(iPlayerTeam);
	pFragMine.SetEntityDescription(formatInt(iIndex));
	pFragMine.SetHealth(20);

	float angX = pPlayerEntity.EyeAngles().x;
	float angY = pPlayerEntity.EyeAngles().y;
	float angZ = pPlayerEntity.EyeAngles().z;

	if (angX > 30.0f)
	{
		angX = 30.0f;
	}

	if (angX < -30.0f)
	{
		angX = -30.0f;
	}

	pFragMine.SetOutline(true, filter_entity, pPlayerEntity.entindex(), Color(32, 245, 64), 384.0f, false, true);

	pFragMine.Teleport(Vector(pPlayerEntity.EyePosition().x, pPlayerEntity.EyePosition().y, pPlayerEntity.EyePosition().z - 12), QAngle(angX, angY, angZ), (pPlayerEntity.GetAbsVelocity() * 0.5f) + (vecMVelocity * 200));

	Engine.EmitSoundPosition(pFragMine.entindex(), "weapons/slam/throw.wav", Vector(pPlayerEntity.EyePosition().x, pPlayerEntity.EyePosition().y, pPlayerEntity.EyePosition().z - 12), 0.5f, 65, 85);

	pEntity.SetRenderMode(kRenderNone);
	pEntity.SetEntityName("wf_used" + formatInt(iIndex));

	Engine.Ent_Fire(pEntity.GetEntityName(), "addoutput", "itemstate 0");
	Engine.Ent_Fire(pEntity.GetEntityName(), "addoutput", "rendermode 10");
	Engine.Ent_Fire(pEntity.GetEntityName(), "kill", "0", "0.3");
}

void DefuseFragMine(CBaseEntity@ pFMine, CZP_Player@ pPlayer)
{
	Vector Origin = pFMine.GetAbsOrigin();
	CBaseEntity@ pMineEntity = SpawnWepFragMine(pFMine);

	Engine.EmitSoundPosition(pMineEntity.entindex(), "weapons/slam/buttonclick.wav", Origin, 0.85f, 60, 105);
	Engine.EmitSoundPosition(pMineEntity.entindex(), "weapons/357/357_reload3.wav", Origin, 0.9f, 70, 105);
	
	if (pPlayer !is null)
	{
		pPlayer.PutToInventory(pMineEntity);
	}
}

CFragMine@ FindFragMineByEntIndex(const int &in EntIndex)
{
	uint iFMArrLength = FMArray.length();

	for (uint q = 0; q < iFMArrLength; q++)
	{
		CFragMine@ pFragMine = FMArray[q];

		if (pFragMine !is null && pFragMine.GetMineIndex() == EntIndex)
		{
			return pFragMine;
		}
	}

	return null;
}