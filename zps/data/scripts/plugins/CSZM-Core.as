/*
///////////////////////////////////////////////////////////////////
/////////////////| Counter-Strike Zombie Mode  |///////////////////
/////////////////|		 Core Script		 |///////////////////
///////////////////////////////////////////////////////////////////
*/

#include "../SendGameText"
#include "./cszm_modules/chat.as"
#include "./cszm_modules/cache.as"
#include "./cszm_modules/killfeed.as"
#include "./cszm_modules/rprop.as"
#include "./cszm_modules/entities.as"
#include "./cszm_modules/antidote.as"
#include "./cszm_modules/item_flare.as"
#include "./cszm_modules/teamnums.as"
#include "./cszm_modules/core_text.as"
#include "./cszm_modules/core_const.as"

CASConVar@ pSoloMode = null;
CASConVar@ pTestMode = null;
CASConVar@ pINGWarmUp = null;
CASConVar@ pFriendlyFire  = null;
CASConVar@ pInfectionRate   = null;

int iMaxPlayers;
int iDoorsState;	//Used for warm up (to allow everyone to open doors)

bool bIsCSZM;	//Is CSZM available? (Depends on a map)
bool bAllowAddTime = true;	//Allow add time for successful infection

bool bSpawnWeak = true;
bool bAllowZombieSpawn;
bool bWarmUp = true;

//Win Countes
int iHumanWin;
int iZombieWin;

//List of available ZM Player models (make sure your server has it)
array<string> g_strModels = 
{
	"models/cszm/zombie_classic.mdl",
	"models/cszm/zombie_sci.mdl",
	"models/cszm/zombie_corpse1.mdl",
	"models/cszm/zombie_charple2.mdl",
	"models/cszm/zombie_sawyer.mdl",
	"models/cszm/zombie_eugene.mdl"
};

array<string> g_strMDLToUse;

//Other arrays (Don't even touch this)
array<int> g_iInfectDelay;
array<int> g_iZMDeathCount;

array<bool> g_bWasFirstInfected;
array<bool> g_bIsVolunteer;
array<bool> g_bIsFirstInfected;
array<bool> g_bIsAbuser;
array<bool> g_bIsWeakZombie;

//CSZM Player Array
array<CSZMPlayer@> CSZMPlayerArray;

//Other Data (Don't even touch this)
int iFirstInfectedHP;
int iStartCoundDown;
int iSeconds;
int iFZIndex;
int iWUSeconds = CONST_WARMUP_TIME;

float flRTWait;
float flWUWait;
float flShowSeconds;
float flShowMinutes;
float flShowHours;
float flWeakZombieWait;

//misc.as
#include "./cszm_modules/misc.as"
#include "./cszm_modules/core_warmup.as"

class CSZMPlayer
{
	int PlayerIndex;
	float SlowTime;
	int SlowSpeed;
	int DefSpeed;
	float SpeedRT;
	int Voice;
	int PreviousVoice;
	float VoiceTime;
	float AdrenalineTime;
	int InfectResist;
	float IRITime;
	float MeleeFreezeTime;
	float OutlineTime;
	int PreviousHP;
	float LobbyRespawnDelay;

	CSZMPlayer(int index)
	{
		PlayerIndex = index;
		SlowTime = 0;
		SlowSpeed = 0;
		DefSpeed = SPEED_DEFAULT;
		SpeedRT = 0;
		Voice = 0;
		PreviousVoice = 0;
		VoiceTime = 0;
		AdrenalineTime = 0;
		InfectResist = 0;
		IRITime = 0;
		MeleeFreezeTime = 0;
		OutlineTime = 0;
		PreviousHP = 0;
		LobbyRespawnDelay = 0;
	}

	void Reset()
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		AdrenalineTime = 0;
		VoiceTime = 0;
		SlowTime = 0;
		InfectResist = 0;
		IRITime = 0;
		MeleeFreezeTime = 0;
		PreviousHP = 0;
		LobbyRespawnDelay = 0;
		pPlayer.DoPlayerDSP(0);
	}

	bool AllowLobbyRespawn()
	{
		bool ALR = false;
		
		if (LobbyRespawnDelay <= Globals.GetCurrentTime()) 
		{
			LobbyRespawnDelay = Globals.GetCurrentTime() + 0.3f;
			ALR = true;
		}
		
		return ALR;
	}

	void SetDefSpeed(int NewSpeed)
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		pPlayer.SetMaxSpeed(NewSpeed);

		DefSpeed = NewSpeed;
		SlowSpeed = NewSpeed;
		SlowTime = 0;
		SpeedRT = 0;
	}

	void SetZMVoice(int VoiceIndex)
	{
		VoiceTime = Globals.GetCurrentTime() + Math::RandomFloat(5.15f, 14.2f);

		if (VoiceIndex < 0)
		{
			Voice = 2;
		}

		else
		{
			if (VoiceIndex == PreviousVoice)
			{
				while(VoiceIndex == PreviousVoice)
				{
					VoiceIndex = Math::RandomInt(1, VOICE_MAX_INDEX);
				}
			}

			Voice = VoiceIndex;
		}
	}

	void EmitZMSound(string ZM_Sound)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		bool bAllowPainSound = false;

		if (pPlayer.IsCarrier() && g_bIsFirstInfected[PlayerIndex])
		{
			bAllowPainSound = true;
		}

		if (!pPlayer.IsCarrier())
		{
			bAllowPainSound = true;
		}

		if (bAllowPainSound && pPlayerEntity.GetWaterLevel() != WL_Eyes)
		{
			Engine.EmitSoundEntity(pPlayerEntity, ZM_Sound + Voice);
		}
	}

	void AddSlowdown(float flDamage, int iDamageType)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		VoiceTime += Math::RandomFloat(0.52f, 0.83f); //Increase VoiceTime if slowed down/took damage

		float CurrentTime = SlowTime - Globals.GetCurrentTime();
		float NewTime;	//Amount of time zombie being slowed down until start recovering a normal speed
		int NewSpeed;	//Variabel to calculate new speed

		NewTime = CONST_SLOWDOWN_TIME;

		//Add time if critical dmg
		if (flDamage > CONST_SLOWDOWN_CRITDMG)
		{
			NewTime = 0.51f;
			MeleeFreezeTime = Globals.GetCurrentTime() + 0.285f;
		}

		//Melee
		if (bDamageType(iDamageType, 7))
		{
			NewTime = 2.0f;
			MeleeFreezeTime = Globals.GetCurrentTime() + 0.851f;
		}

		//Blast
		if (bDamageType(iDamageType, 6))
		{
			NewTime = 1.85f;
			MeleeFreezeTime = Globals.GetCurrentTime() + 0.275f;
		}

		//Blast Surface
		if (bDamageType(iDamageType, 27))
		{
			NewTime = 1.40f;
			MeleeFreezeTime = Globals.GetCurrentTime() + 0.21f;
		}

		//Fall
		if (bDamageType(iDamageType, 5))
		{
			NewTime = 0.65f;
			MeleeFreezeTime = Globals.GetCurrentTime() + 0.05f;
		}

		if (NewTime < CurrentTime)
		{
			NewTime = CurrentTime; 
		}

		//Cap slowdown time to our MAX
		if (NewTime > CONST_MAX_SLOWTIME)
		{
			NewTime = CONST_MAX_SLOWTIME;
		}

		SlowSpeed = int((DefSpeed * 0.01) * CONST_SLOWDOWN_MULT);

		//Reduce the slowdown speed if weak zombie
		if (g_bIsWeakZombie[PlayerIndex])
		{
			SlowSpeed * CONST_SLOWDOWN_WEAKMULT;
		}

		SlowTime = Globals.GetCurrentTime() + NewTime;
		SpeedRT = Globals.GetCurrentTime() + CONST_RECOVER_UNIT;

		NewSpeed = DefSpeed - SlowSpeed;

		pPlayer.SetMaxSpeed(NewSpeed);
	}

	int GetInfectResist()
	{
		return InfectResist;
	}

	void SubtractInfectResist()
	{
		InfectResist--;

		if (InfectResist < 0)
		{
			InfectResist = 0;
		}

		if (InfectResist < CONST_MAX_INFECTRESIST && InfectResist > CONST_MAX_INFECTRESIST - 2)
		{
			SetAntidoteState(PlayerIndex, ANTIDOTE_STATE_USEABLE);
		}
	}

	void InjectAntidote(CBaseEntity@ pItemAntidote)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CBasePlayer@ pBasePlayer =  ToBasePlayer(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		IRITime = Globals.GetCurrentTime() + 1.12f;
		InfectResist++;

		Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0, fade_in);
		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + Math::RandomInt(15, 25));
		Engine.EmitSoundPosition(PlayerIndex, "items/smallmedkit1.wav", pPlayerEntity.EyePosition(), 0.5f, 75, 100);

		SetUsed(PlayerIndex, pItemAntidote);

		if (InfectResist >= CONST_MAX_INFECTRESIST) 
		{
			InfectResist = CONST_MAX_INFECTRESIST;
			Chat.CenterMessagePlayer(pBasePlayer, "You got Maximum Infection Resist: " + InfectResist);
			SetAntidoteState(PlayerIndex, ANTIDOTE_STATE_UNUSEABLE);
		}

		else 
		{
			Chat.CenterMessagePlayer(pBasePlayer, "Infection Resist: " + InfectResist);
		}
	}

	void InjectAdrenaline(CBaseEntity@ pItemAdrenaline)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		int NewSpeed = pPlayer.GetMaxSpeed() + SPEED_ADRENALINE;

		if (NewSpeed > SPEED_ADRENALINE + SPEED_HUMAN)
		{
			NewSpeed = SPEED_ADRENALINE + SPEED_HUMAN;
		}

		pPlayer.SetMaxSpeed(NewSpeed);
		pPlayer.DoPlayerDSP(34);
		Utils.ScreenFade(pPlayer, Color(8, 16, 64, 50), 0.25f, 11.75f, fade_in);
		Engine.EmitSoundPlayer(pPlayer, "ZPlayer.Panic");
		AdrenalineTime = Globals.GetCurrentTime() + CONST_ADRENALINE_DURATION;

		SetUsed(PlayerIndex, pItemAdrenaline);
	}

	void Think()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CBasePlayer@ pBasePlayer =  ToBasePlayer(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		int TeamNum = pPlayerEntity.GetTeamNumber();

		if (TeamNum == TEAM_ZOMBIES)
		{
			if (OutlineTime <= Globals.GetCurrentTime())
			{
				if (pPlayerEntity.GetHealth() != PreviousHP || pPlayer.IsCarrier())
				{
					OutlineTime = Globals.GetCurrentTime() + 0.075f;
					PreviousHP = pPlayerEntity.GetHealth();

					float MaxHP = pPlayerEntity.GetMaxHealth();
					float HP = pPlayerEntity.GetHealth();
					float HPP = (HP / MaxHP);
					float BaseCChanel = 255;
					int cRed = 0;
					int cGreen = 255;
					int cBlue = 16;
					float ExtraDistance = 0;
					bool RenderUnOccluded = false;

					if (HPP < 1 && !g_bIsWeakZombie[PlayerIndex])
					{
						BaseCChanel = (2.55f * HPP * 100);
						cRed = int(255 - BaseCChanel);
						cGreen = int(BaseCChanel);
					}

					else if (HPP > 1.115f)
					{
						cRed = 125;
						cGreen = 0;
						cBlue = 255;
					}

					if (pPlayer.IsCarrier())
					{
						ExtraDistance = GLOW_CARRIER_ADD_DISTANCE;

						if (pPlayer.IsRoaring())
						{
							RenderUnOccluded = true;
							ExtraDistance = GLOW_CARRIER_ROAR_DISTANCE;
						}
					}

					if (g_bIsWeakZombie[PlayerIndex])
					{
						cRed = 84;
						cGreen = 135;
						cBlue = 198;
						ExtraDistance = GLOW_WEAK_ADD_DISTANCE;
					}

					pPlayerEntity.SetOutline(true, filter_team, TEAM_ZOMBIES, Color(cRed, cGreen, cBlue), GLOW_BASE_DISTANCE + ExtraDistance, true, RenderUnOccluded);
				}
			}

			if (MeleeFreezeTime > Globals.GetCurrentTime())
			{
				float x = 0;
				float y = 0;
				float z = pPlayerEntity.GetAbsVelocity().z;

				if (z > 0)
				{
					z = 0;
				}

				pPlayerEntity.SetAbsVelocity(Vector(x, y, z));
			}

			if (SlowTime <= Globals.GetCurrentTime() && SlowTime != 0 && SlowSpeed != 0)
			{
				if (SpeedRT <= Globals.GetCurrentTime() && SpeedRT != 0)
				{
					int NewSpeed;
					SpeedRT = Globals.GetCurrentTime() + CONST_RECOVER_UNIT;
					SlowSpeed -= 5;

					if (SlowSpeed < 0)
					{
						SlowSpeed = 0;
					}

					NewSpeed = DefSpeed - SlowSpeed;

					if (NewSpeed > DefSpeed)
					{
						NewSpeed = DefSpeed;
					}

					pPlayer.SetMaxSpeed(NewSpeed);
				}
			}

			if (pPlayerEntity.IsAlive())
			{
				if (VoiceTime <= Globals.GetCurrentTime())
				{
					this.EmitZMSound(VOICE_ZM_IDLE);

					float Time_Low = 5.24f;
					float Time_High = 14.25f;

					switch(Voice)
					{
						case 2:
							Time_Low = 5.05f;
							Time_High = 12.05f;
						break;
						
						case 3:
							Time_Low = 5.65f;
							Time_High = 11.92f;
						break;
					}

					VoiceTime = Globals.GetCurrentTime() + Math::RandomFloat(Time_Low, Time_High);
				}
			}
		}

		else if (TeamNum == TEAM_SURVIVORS)
		{
			if (AdrenalineTime <= Globals.GetCurrentTime() && AdrenalineTime != 0)
			{
				AdrenalineTime = 0;
				pPlayer.SetMaxSpeed(DefSpeed);
				pPlayer.DoPlayerDSP(0);
			}

			CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

			if (IRITime <= Globals.GetCurrentTime() && Utils.StrContains("iantidote", pWeapon.GetEntityName()))
			{
				IRITime = Globals.GetCurrentTime() + 1.12f;

				string strMax = "";

				if (InfectResist == CONST_MAX_INFECTRESIST)
				{
					strMax = " (Maximum)";
				}

				Chat.CenterMessagePlayer(pBasePlayer, "Infection Resist: " + InfectResist + strMax);
			}
		}
	}
}

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("Counter-Strike Zombie Mode");

	//Find 'sv_zps_solo' ConVar
	@pSoloMode = ConVar::Find("sv_zps_solo");
	if (pSoloMode !is null)
	{
		ConVar::Register(pSoloMode, "ConVar_SoloMode");
	}

	//Find 'sv_testmode' ConVar
	@pTestMode = ConVar::Find("sv_testmode");
	if (pTestMode !is null)
	{
		ConVar::Register(pTestMode, "ConVar_TestMode");
	}

	//Find 'sv_zps_warmup' ConVar
	@pINGWarmUp = ConVar::Find("sv_zps_warmup");
	if (pINGWarmUp !is null)
	{
		ConVar::Register(pINGWarmUp, "ConVar_WarmUpTime");
	}

	//Find 'mp_friendlyfire' ConVar
	@pFriendlyFire = ConVar::Find("mp_friendlyfire");
	if (pFriendlyFire !is null)
	{
		ConVar::Register(pFriendlyFire, "ConVar_FriendlyFire");
	}

	//Find 'sv_zps_infectionrate' ConVar
	@pInfectionRate = ConVar::Find("sv_zps_infectionrate");
	if (pInfectionRate !is null)
	{
		ConVar::Register(pInfectionRate, "ConVar_InfectionRate"); 
	}

	//Events
	Events::Player::OnPlayerInfected.Hook(@CSZM_OnPlayerInfected);
	Events::Player::OnPlayerConnected.Hook(@CSZM_OnPlayerConnected);
	Events::Player::OnPlayerSpawn.Hook(@CSZM_OnPlayerSpawn);
	Events::Entities::OnEntityCreation.Hook(@CSZM_OnEntityCreation);
	Events::Custom::OnPlayerDamagedCustom.Hook(@CSZM_OnPlayerDamaged);
	Events::Player::OnPlayerKilled.Hook(@CSZM_OnPlayerKilled);
	Events::Player::OnPlayerDisonnected.Hook(@CSZM_OnPlayerDisonnected);
	Events::Rounds::RoundWin.Hook(@CSZM_RoundWin);
	Events::Player::OnPlayerRagdollCreate.Hook(@CSZM_OnPlayerRagdollCreate);
	Events::Player::OnConCommand.Hook(@CSZM_OnConCommand);
}

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		Log.PrintToServerConsole(LOGTYPE_INFO, "CSZM", "[CSZM] Current map is valid for 'Counter-Strike Zombie Mode'");
		bIsCSZM = true;
		flWeakZombieWait = 0;
		flRTWait = 0;
		flWUWait = 0;

		Engine.EnableCustomSettings(true);
		
		//Set some ConVar to 0
		pSoloMode.SetValue("0");
		pTestMode.SetValue("0");
		pINGWarmUp.SetValue("0");
		pFriendlyFire.SetValue("0");
		pInfectionRate.SetValue("0");
		
		//Cache
		CacheModels();
		CacheSounds();

		//Get MaxPlayers
		iMaxPlayers = Globals.GetMaxClients();
		
		//Entities
		RegisterEntities();
		
		//Resize
		g_bWasFirstInfected.resize(iMaxPlayers + 1);
		g_bIsFirstInfected.resize(iMaxPlayers + 1);
		g_bIsAbuser.resize(iMaxPlayers + 1);
		g_bIsWeakZombie.resize(iMaxPlayers + 1);
		g_bIsVolunteer.resize(iMaxPlayers + 1);
		g_iInfectDelay.resize(iMaxPlayers + 1);
		g_iZMDeathCount.resize(iMaxPlayers + 1);
		g_iKills.resize(iMaxPlayers + 1);
		g_iVictims.resize(iMaxPlayers + 1);

		//CSZM Player array resize
		CSZMPlayerArray.resize(iMaxPlayers + 1);
		
		//Set Doors Filter to 0 (any team)
		if (bWarmUp)
		{
			SetDoorFilter(TEAM_LOBBYGUYS);
		}
	
	}

	else
	{
		Log.PrintToServerConsole(LOGTYPE_INFO, "CSZM", "[CSZM] Current map is not valid for 'Counter-Strike Zombie Mode'");
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		pSoloMode.SetValue("0");

		bIsCSZM = false;
		Engine.EnableCustomSettings(false);
		iSeconds = 0;
		iFZIndex = 0;
		iWUSeconds = CONST_WARMUP_TIME;

		flWeakZombieWait = 0;
		flRTWait = 0;
		flWUWait = 0;

		iHumanWin = 0;
		iZombieWin = 0;
		
		bSpawnWeak = true;
		bAllowZombieSpawn = false;
		bWarmUp = true;

		CSZMPlayerArray.removeRange(0, CSZMPlayerArray.length());
		
		ClearBoolArray(g_bWasFirstInfected);
		ClearBoolArray(g_bIsFirstInfected);
		ClearBoolArray(g_bIsAbuser);
		ClearBoolArray(g_bIsWeakZombie);
		ClearBoolArray(g_bIsVolunteer);
		ClearIntArray(g_iKills);
		ClearIntArray(g_iVictims);
		ClearIntArray(g_iInfectDelay);
		ClearIntArray(g_iZMDeathCount);
	}
}

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int index = pBaseEnt.entindex();

	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];
	CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

	int InfRes = pCSZMPlayer.GetInfectResist();

	if (Utils.StrEql("iantidote", pEntity.GetEntityName()))
	{
		pEntity.SetEntityName(index + "iantidote");
		
		if (InfRes >= CONST_MAX_INFECTRESIST)
		{
			if (!Utils.StrContains("iantidote", pWeapon.GetEntityName()))
			{
				Chat.CenterMessagePlayer(pPlrEnt, "You got Maximum Infection Resist: " + InfRes);
			}

			Engine.Ent_Fire(index + "iantidote", "addoutput", "itemstate 0");
		}

		else
		{
			Engine.Ent_Fire(index + "iantidote", "addoutput", "itemstate 1");
		}
	}	
}

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int index = pBaseEnt.entindex();

	if (Utils.StrContains("iantidote", pEntity.GetEntityName()) && Utils.StringToInt(pEntity.GetEntityName()) == index)
	{
		pEntity.SetEntityName("iantidote");
	}

	if (Utils.StrContains("used", pEntity.GetEntityName()))
	{
		pEntity.SUB_Remove();
	}
}

void OnItemDeliverUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity, int &in iEntityOutput)
{
	if (pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int index = pBaseEnt.entindex();

	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

	string Targetname = pEntity.GetEntityName();

	if (Utils.StrContains("iantidote", Targetname))
	{
		pCSZMPlayer.InjectAntidote(pEntity);
	}

	if (Utils.StrEql("item_adrenaline", Targetname))
	{
		pCSZMPlayer.InjectAdrenaline(pEntity);
	}
}

HookReturnCode CSZM_OnPlayerRagdollCreate(CZP_Player@ pPlayer, bool &in bHeadshot, bool &out bExploded)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	//Disable the headshot effects if cszm player model
	if (Utils.StrContains("cszm", pBaseEnt.GetModelName()))
	{
		bHeadshot = false;
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_RoundWin(const string &in strMapname, RoundWinState iWinState)
{
	if (bIsCSZM)
	{
		flRTWait = 0;
		ShowTimer(10.25f);

		if (iWinState == STATE_HUMAN)
		{
			Engine.EmitSound("CS_HumanWin");
		}

		if (iWinState == STATE_ZOMBIE)
		{
			Engine.EmitSound("CS_ZombieWin");
		}

		if (iWinState == STATE_HUMAN)
		{
			iHumanWin++;
		}
		
		if (iWinState == STATE_ZOMBIE)
		{
			iZombieWin++;
		}
		
		string strHW = "\n  Humans Win - " + iHumanWin;
		string strZW = "\n  Zombies Win - " + iZombieWin;
		
		SendGameText(any, "-=Win Counter=-" + strHW + strZW, 4, 0, 0, 0.35f, 0.25f, 0, 10.10f, Color(235, 235, 235), Color(255, 95, 5));
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerConnected(CZP_Player@ pPlayer) 
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		const int index = pBaseEnt.entindex();

		//Before inserting remove everything at this index
		CSZMPlayerArray.removeAt(index);
		CSZMPlayerArray.insertAt(index, CSZMPlayer(index));
		
		g_iInfectDelay[index] = 0;
		g_iZMDeathCount[index] = -1;

		g_iKills[index] = 0;
		g_iVictims[index] = 0;
			
		g_bWasFirstInfected[index] = false;
		g_bIsFirstInfected[index] = false;
		g_bIsAbuser[index] = false;
		g_bIsWeakZombie[index] = true;
		g_bIsVolunteer[index] = false;
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnConCommand(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int index = pBaseEnt.entindex();

		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

		if (!RoundManager.IsRoundOngoing(false))
		{
			if (Utils.StrContains("choose", pArgs.Arg(0)) && pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS) 
			{
				if (bWarmUp)
				{
					if (Utils.StrEql("choose4", pArgs.Arg(0)) && pCSZMPlayer.AllowLobbyRespawn())
					{
						pPlayer.ForceRespawn();
					}
					
					return HOOK_HANDLED;
				}

				else
				{
					if (Utils.StrEql("choose2", pArgs.Arg(0)))
					{
						if (g_iInfectDelay[index] > 0)
						{
							Chat.PrintToChatPlayer(pPlrEnt, strCannotPlayFI);

							return HOOK_HANDLED;
						}
						
						else
						{
							Chat.PrintToChatPlayer(pPlrEnt, strChooseToPlayFI);

							if (!g_bIsVolunteer[index])
							{
								g_bIsVolunteer[index] = true;
							}
						}
					}
				}
			}				
		}

		else
		{
			if (Utils.StrEql("choose1", pArgs.Arg(0)) || Utils.StrEql("choose2", pArgs.Arg(0)))
			{
				if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
				{
					if (!bAllowZombieSpawn)
					{
						if (g_bIsAbuser[index])
						{
							Chat.PrintToChatPlayer(pPlrEnt, strCannotJoinGame);
							Engine.EmitSoundPlayer(pPlayer, "common/wpn_denyselect.wav");

							return HOOK_HANDLED;
						}

						if (!g_bIsAbuser[index])
						{
							pBaseEnt.ChangeTeam(TEAM_SURVIVORS);
							pPlayer.ForceRespawn();
							pPlayer.SetHudVisibility(true);

							return HOOK_HANDLED;
						}
					}

					else if (g_bIsAbuser[index])
					{
						pBaseEnt.ChangeTeam(TEAM_ZOMBIES);
						pPlayer.ForceRespawn();
						pPlayer.SetHudVisibility(true);

						return HOOK_HANDLED;
					}
				}
			}
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerSpawn(CZP_Player@ pPlayer)
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int index = pBaseEnt.entindex();
        int TeamNum = pBaseEnt.GetTeamNumber();

		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

		RemoveProp(pBaseEnt);
		Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Mute");

		//Apply the custom movement speed
		switch(TeamNum)
		{
			case TEAM_SURVIVORS:
				pCSZMPlayer.SetDefSpeed(SPEED_HUMAN);
			break;
			
			case TEAM_ZOMBIES:
				if (pPlayer.IsCarrier())
				{
					pCSZMPlayer.SetDefSpeed(SPEED_CARRIER);
				}
				else
				{
					pCSZMPlayer.SetDefSpeed(SPEED_ZOMBIE);
				}
			break;
			
			default:
				pCSZMPlayer.SetDefSpeed(SPEED_DEFAULT);
			break;
		}

		//Set CSS Arms model
		if (TeamNum != TEAM_ZOMBIES)
		{
			pPlayer.SetArmModel("models/cszm/weapons/c_css_arms.mdl");
		}

		else
		{
			//Keep The Carrier with his own arms model
			if (!pPlayer.IsCarrier())
			{
				//CSS Arms model (zombie skin)
				pPlayer.SetArmModel("models/cszm/weapons/c_css_zombie_arms.mdl");
			}
		}

		//If 'InLobby' team set the lobby guy player model
		if (TeamNum == TEAM_LOBBYGUYS)
		{
			pBaseEnt.SetModel("models/cszm/lobby_guy.mdl");
			pPlayer.SetVoice(eugene);

			if (!bWarmUp)
			{
				lobby_hint(pPlayer);
			}

			else
			{
				lobby_hint_wu(pPlayer);
			}
		}
		
		if (!bWarmUp) // Is Warm Up = FALSE
		{
			if (TeamNum == TEAM_SPECTATORS)
			{
				spec_hint(pPlayer); //Hint for spectator, probably not working
			}

			if (TeamNum == TEAM_ZOMBIES)
			{
				if (bAllowZombieSpawn)
				{
					//Give zomies some ammo to drop
					if (Math::RandomInt(1, 100) > 47)
					{
						int iRNG = Math::RandomInt(0, 3);	//RNG Ammo type: 0 - Pistol, 1 - Revolver, 2 - Shotgun, 4 - Rifle
						int iAmmoCount = Math::RandomInt(21, 43);

						switch(iRNG)
						{
							case 1:	//Revolver ammo
								iAmmoCount = Math::RandomInt(4, 12);
							break;
							
							case 2:	//Shotgun ammo
								iAmmoCount = Math::RandomInt(3, 9);
							break;
						}

						AmmoBankSetValue iAmmoType = AmmoBankSetValue(iRNG);
						pPlayer.AmmoBank(add, iAmmoType, iAmmoCount);
					}

					if (!bSpawnWeak && g_bIsWeakZombie[index])
					{
						g_bIsWeakZombie[index] = false;
					}

					if (bSpawnWeak && g_bIsWeakZombie[index])
					{
						SpawnWeakZombie(pPlayer);
					}
					
					else
					{
						RndZModel(pPlayer, pBaseEnt);
						SetZMHealth(pBaseEnt);
					}

					EmitBloodEffect(pPlayer, true);
				}
				
				else
				{
					Chat.PrintToChatPlayer(pBaseEnt, strCannotJoinZT0);
					MovePlrToSpec(pBaseEnt);
					Engine.EmitSoundPlayer(pPlayer, "common/wpn_denyselect.wav");
				}
			}

			else if (TeamNum != TEAM_ZOMBIES && g_iZMDeathCount[index] < 0)
			{
				g_iZMDeathCount[index] = -1;
			}
		}

		else
		{
			if (pPlrEnt.IsBot())									
			{
				pBaseEnt.ChangeTeam(TEAM_LOBBYGUYS);	//For debug purposes
				pPlayer.ForceRespawn();					//Unused in actual gameplay
				pBaseEnt.SetModel("models/cszm/lobby_guy.mdl");
			}

			PutPlrToPlayZone(pBaseEnt);

			if (CountPlrs(TEAM_LOBBYGUYS) <= 2 && iWUSeconds == CONST_WARMUP_TIME)
			{
				flWUWait = Globals.GetCurrentTime();
			}
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &out DamageInfo)
{
	if (bIsCSZM)
	{
		CZP_Player@ pPlrAttacker = null;
		string strAN = "";

		const float flDamage = DamageInfo.GetDamage();
		const int iDamageType = DamageInfo.GetDamageType();

		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		const int iVicIndex = pBaseEnt.entindex();
		const int iVicTeam = pBaseEnt.GetTeamNumber();
		const string strVicName = pPlayer.GetPlayerName();

		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();

		const int iAttIndex = pEntityAttacker.entindex();
		const int iAttTeam = pEntityAttacker.GetTeamNumber();

		CSZMPlayer@ pVicCSZMPlayer = CSZMPlayerArray[iVicIndex];

		int InfRes = pVicCSZMPlayer.GetInfectResist();

		if (Utils.StrEql(pEntityAttacker.GetEntityName(), "frendly_shrapnel") && iVicTeam == TEAM_SURVIVORS)
		{
			DamageInfo.SetDamageType(0);
			DamageInfo.SetDamage(0);

			return HOOK_HANDLED;
		}

		if (iAttTeam == iVicTeam && pBaseEnt !is pEntityAttacker)
		{
			DamageInfo.SetDamageType(0);
			DamageInfo.SetDamage(0);

			return HOOK_HANDLED;
		}

		if (pEntityAttacker.IsPlayer()) 
		{
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			strAN = pPlrAttacker.GetPlayerName();
		}

		const string strAttName = strAN;

		if (iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && iDamageType == 8196) //Damage Type: DMG_ALWAYSGIB + DMG_SLASH
		{
			if (InfRes > 0)
			{
				pVicCSZMPlayer.SubtractInfectResist();
				return HOOK_HANDLED;
			}

			else if (InfRes <= 0)
			{
				DamageInfo.SetDamage(0);
				g_iVictims[iAttIndex]++;
				ShowKills(pPlrAttacker, g_iVictims[iAttIndex], true);
				KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, true, false);
				GotVictim(pPlrAttacker, pEntityAttacker);
				TurnToZ(iVicIndex);
			}
		}
		
		if (iVicTeam == TEAM_ZOMBIES && pBaseEnt.IsAlive())
		{
			bool bLeft = false;

			float VP_X = 0;
			float VP_Y = 0;
			float VP_DAMP = Math::RandomFloat(0.047f , 0.095f);
			float VP_KICK = Math::RandomFloat(0.25f , 1.35f);

			//Fall DamageType
			if (bDamageType(iDamageType, 5))
			{
				VP_X = Math::RandomFloat(-1.75f, -5.15f);
				VP_Y = Math::RandomFloat(-1.75f, -5.15f);
				VP_DAMP = Math::RandomFloat(0 , 0.015f);
			}

			else 
			{
				VP_X = Math::RandomFloat(-3.75f, 3.85f);
				VP_Y = Math::RandomFloat(-3.75f, 3.85f);
			}

			if (Math::RandomInt(0 , 1) > 0)
			{
				bLeft = true;
			}

			Utils.FakeRecoil(pPlayer, VP_KICK, VP_DAMP, VP_X, VP_Y, bLeft);

			if (flDamage < pBaseEnt.GetHealth() && flDamage > 0.5f)
			{
				pVicCSZMPlayer.EmitZMSound(VOICE_ZM_PAIN);
			}

			pVicCSZMPlayer.AddSlowdown(flDamage, iDamageType);
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerInfected(CZP_Player@ pPlayer, InfectionState iState)
{
	//Builtins infection is not allowed
	if (iState != state_none && bIsCSZM)
	{
		pPlayer.SetInfection(false, 0);
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerKilled(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo) 
{
	if (bIsCSZM)
	{
		bool bSuicide = false;

		CZP_Player@ pPlrAttacker = null;
		string strAN = "";
	
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		const int iVicIndex = pBaseEnt.entindex();
		const int iVicTeam = pBaseEnt.GetTeamNumber();
		const string strVicName = pPlayer.GetPlayerName();
		
		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
		
		const int iAttIndex = pEntityAttacker.entindex();
		const int iAttTeam = pEntityAttacker.GetTeamNumber();

		CSZMPlayer@ pVicCSZMPlayer = CSZMPlayerArray[iVicIndex];

		pVicCSZMPlayer.Reset();
		
		if (pEntityAttacker.IsPlayer()) 
		{
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			strAN = pPlrAttacker.GetPlayerName();
		}

		const string strAttName = strAN;

		if (iAttIndex == iVicIndex || !pEntityAttacker.IsPlayer())
		{
			KillFeed("", 0, strVicName, iVicTeam, false, true);
			bSuicide = true;
		}

		else if (iAttIndex != iVicIndex && pEntityAttacker.IsPlayer())
		{
			KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, false, false);
		}

		if (iVicTeam == TEAM_ZOMBIES)
		{
			pVicCSZMPlayer.EmitZMSound(VOICE_ZM_DIE);

			if (!bSuicide)
			{
				if (g_iZMDeathCount[iVicIndex] < CONST_DEATH_MAX && !g_bIsFirstInfected[iVicIndex])
				{
					g_iZMDeathCount[iVicIndex]++;
				}

				g_iKills[iAttIndex]++;

				if (iAttTeam != TEAM_ZOMBIES)
				{
					ShowKills(pPlrAttacker, g_iKills[iAttIndex], false);
				}
			}
		}

		if (iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && pEntityAttacker.IsPlayer())
		{
			g_iVictims[iAttIndex]++;
			ShowKills(pPlrAttacker, g_iVictims[iAttIndex], true);
			g_bIsWeakZombie[iVicIndex] = false;
			GotVictim(pPlrAttacker, pEntityAttacker);
		}

		if (g_bIsVolunteer[iVicIndex])
		{
			g_bIsVolunteer[iVicIndex] = false;
		}

		if (g_bIsFirstInfected[iVicIndex])
		{
			g_bIsFirstInfected[iVicIndex] = false;
		}

		if (iVicTeam == TEAM_ZOMBIES && bSpawnWeak)
		{
			g_bIsAbuser[iVicIndex] = true;
		}

		if (iFZIndex == iVicIndex)
		{
			iFZIndex = 0;
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerDisonnected(CZP_Player@ pPlayer)
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if (iFZIndex == pBaseEnt.entindex())
		{
			iFZIndex = 0;
		}
		
		if (pBaseEnt.GetTeamNumber() == TEAM_ZOMBIES && Utils.GetNumPlayers(zombie, false) <= 1 && RoundManager.IsRoundOngoing(false))
		{
			Engine.EmitSound("common/warning.wav");
			RoundManager.SetWinState(STATE_STALEMATE);
			SD(strLastZLeave);
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (bIsCSZM)
	{
		if (Utils.StrEql("npc_grenade_frag", strClassname))
		{
			AttachTrail(pEntity);
		}

		else if (Utils.StrEql("item_healthkit", strClassname))
		{
			SpawnAntidote(pEntity);
		}

		else if (Utils.StrEql("item_pills", strClassname))
		{
			SpawnAdrenaline(pEntity);
		}

		else if (Utils.StrEql("item_ammo_flare", strClassname))
		{
			SpawnRandomItem(pEntity);
		}
	}

	return HOOK_CONTINUE;
}

//CSZM Related Funcs
void OnProcessRound()
{
	if (bIsCSZM)
	{
		RoundManager.SetCurrentRoundTime(CONST_ROUND_TIME_GAME + Globals.GetCurrentTime());
		RoundManager.SetZombieLives(CONST_ZOMBIE_LIVES);

		if (flRTWait != 0 && flRTWait <= Globals.GetCurrentTime())
		{
			RoundTimer();
		}

		if (flWUWait != 0 && flWUWait <= Globals.GetCurrentTime())
		{
			WarmUpTimer();
		}

		if (flWeakZombieWait != 0 && flWeakZombieWait <= Globals.GetCurrentTime())
		{
			bSpawnWeak = false;
		}

		for (int i = 1; i <= iMaxPlayers; i++) 
		{
			CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];

			if (pCSZMPlayer !is null)
			{
				pCSZMPlayer.Think();
			}
		}
	}
}

void OnNewRound()
{
	if (bIsCSZM)
	{
		bSpawnWeak = true;
		bAllowZombieSpawn = false;
		iFZIndex = 0;
		flRTWait = 0;
		flWUWait = 0;
		flWeakZombieWait = 0;
		
		for (int i = 1; i <= iMaxPlayers; i++) 
		{
			CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];

			if (pCSZMPlayer !is null)
			{
				pCSZMPlayer.Reset();
			}

			g_iZMDeathCount[i] = -1;

			g_iKills[i] = 0;
			g_iVictims[i] = 0;
				
			g_bIsFirstInfected[i] = false;
			g_bIsVolunteer[i] = false;
			g_bIsAbuser[i] = false;
			g_bIsWeakZombie[i] = true;
		}
	}
}

void OnMatchStarting()
{
	if (bIsCSZM)
	{
		bAllowZombieSpawn = false;
		pSoloMode.SetValue("1");

		iStartCoundDown = CONST_ROUND_TIME + CONST_TURNING_TIME;
		iSeconds = CONST_ROUND_TIME_FULL;
		ShowTimer(10.25f);
	}
}

void OnMatchBegin() 
{
	if (bIsCSZM)
	{
		Schedule::Task(0.5f, "LocknLoad");
		Schedule::Task((0.75f), "RemoveExtraPills");

		if (iWUSeconds == 0)
		{
			PutPlrToLobby(null);
			SetDoorFilter(TEAM_SPECTATORS);
			iWUSeconds = CONST_WARMUP_TIME;
		}
	}
}

void LocknLoad()
{
	flRTWait = Globals.GetCurrentTime();
	
	RoundManager.SetRounds(10);
	RoundManager.SetCurrentRoundTime(2700);

	Engine.EmitSound("CS_MatchBeginRadio");
	Globals.SetPlayerRespawnDelay(true, CONST_SPAWN_DELAY);
	ShowChatMsg(strRoundBegun, TEAM_SURVIVORS);
	DecideFirstInfected();

	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pEntPlayer = FindEntityByEntIndex(i);

		if (pEntPlayer is null)
		{
			continue;
		}

		if (pEntPlayer.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			lobby_hint(ToZPPlayer(i));
			continue;
		}

		if (pEntPlayer.GetTeamNumber() == TEAM_SURVIVORS && g_iInfectDelay[i] > 0)
		{
			g_iInfectDelay[i]--;
		}
	}
}

void ShowChatMsg(const string &in strMsg, const int &in iTeamNum)
{
	if (iTeamNum != -1)
	{
		for (int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);

			if (pPlayer is null)
			{
				continue;
			}

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if (pBaseEnt.GetTeamNumber() == iTeamNum)
			{
				Chat.PrintToChatPlayer(pPlrEnt, strMsg);
			}
		}
	}
	
	else
	{
		Chat.PrintToChat(all, strMsg);
	}
}

void OnMatchEnded() 
{
	if (bIsCSZM)
	{
		pSoloMode.SetValue("0");

		for (int i = 1; i <= iMaxPlayers; i++) 
		{
			CZP_Player@ pPlr = ToZPPlayer(i);

			if (pPlr is null)
			{
				continue;
			}

			ShowStatsEnd(pPlr, g_iKills[i], g_iVictims[i]);
		}
	}
}

void RoundTimer()
{
	if (Utils.GetNumPlayers(survivor, false) == 0)
	{
		RoundManager.SetWinState(STATE_STALEMATE);
	}

	float flHTime = 0;

	flRTWait = Globals.GetCurrentTime() + 1.0f;

	if (iSeconds <= iStartCoundDown && iSeconds >= CONST_ROUND_TIME)
	{
		ShowFICountdown();
	}

	if (iSeconds == CONST_ROUND_TIME)
	{
		TurnFirstInfected();
	}

	if (iSeconds - CONST_ROUND_TIME <= 10 && iSeconds > CONST_ROUND_TIME)
	{
		EmitCountdownSound(iSeconds - CONST_ROUND_TIME);
	}

	if (iSeconds == 0)
	{
		flRTWait = 0;
		flHTime = 10.25f;
		CSZM_EndGame();
	}

	ShowTimer(flHTime);

	if (iSeconds > 0)
	{
		iSeconds--;
	}
}

void ShowFICountdown()
{
	if (iFZIndex != 0)
	{
		CBaseEntity@ pPlrEntity = FindEntityByEntIndex(iFZIndex);
		CZP_Player@ pPlayer = ToZPPlayer(pPlrEntity);

		if (pPlrEntity.IsAlive() && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS)
		{
			string strPTMAddon = strBecomFI;
			string strPreTurnMsg = strPTMAddon + strTurningIn + flShowSeconds + strSecs;

			if (flShowSeconds == 1)
			{
				strPreTurnMsg = strPTMAddon + strTurningIn + flShowSeconds + strSec;
			}
				
			int iR = Math::RandomInt(0, 128);
			int iG = Math::RandomInt(135, 255);
			int iB = Math::RandomInt(135, 255);
				
			SendGameTextPlayer(pPlayer, strPreTurnMsg, 1, 0, -1, 0.35, 0, 0, 0.075, Color(iR, iG, iB), Color(0, 0, 0));
		}

		if (iSeconds >= CONST_ROUND_TIME && iSeconds <= iStartCoundDown)
		{
			Schedule::Task(0.05f, "ShowFICountdown");
		}
	}

	else
	{
		DecideFirstInfected();
	}
}

void GotVictim(CZP_Player@ pAttacker, CBaseEntity@ pBaseEntA)
{
	if (g_iZMDeathCount[pBaseEntA.entindex()] >= 0)
	{
		g_iZMDeathCount[pBaseEntA.entindex()] -= CONST_SUBTRACT_DEATH;
	}
		
	if (pBaseEntA.IsAlive())
	{
		pBaseEntA.SetHealth(pBaseEntA.GetHealth() + CONST_REWARD_HEALTH);
	}

	AddTime(CONST_INFECT_ADDTIME);
}

void AddTime(const int &in iTime)
{
	if (RoundManager.IsRoundOngoing(false) && Utils.GetNumPlayers(survivor, true) > 1 && bAllowAddTime)
	{
		int iOverTimeMult = 1;
	
		if (iSeconds <= 0)
		{
			iOverTimeMult = 3;
		}
	
		if (iSeconds < 35 && iTime > 0)
		{
			iSeconds += (iTime * iOverTimeMult);
			ShowTimer(0);
			SendGameText(any, "\n+ "+(iTime * iOverTimeMult)+" Seconds", 1, 1, -1, 0.0025f, 0, 0.35f, 1.75f, Color(255, 175, 85), Color(0, 0, 0));
		}
	}
}

void TurnFirstInfected()
{
	int iSurvCount = Utils.GetNumPlayers(survivor, true);
	
	if (iSurvCount < 4)
	{
		iSurvCount = 4;
	}

	iFirstInfectedHP = CONST_FI_HEALTH_MULT * iSurvCount;
	flWeakZombieWait = Globals.GetCurrentTime() + CONST_WEAK_ZOMBIE_TIME;

	if (iFZIndex == 0)
	{
		CZP_Player@ pVictim = GetRandomPlayer(survivor, true);
		CBasePlayer@ pVPlrEnt = pVictim.opCast();
		CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();

		iFZIndex = pVBaseEnt.entindex();
	}

	int iInfDelay = 1;

	if (g_bIsVolunteer[iFZIndex]) 
	{
		g_bIsVolunteer[iFZIndex] = false;
		iInfDelay = CONST_INFECT_DELAY;
	}

	g_bIsFirstInfected[iFZIndex] = true;
	g_iInfectDelay[iFZIndex] += iInfDelay;
	ShowOutbreak(iFZIndex);
	TurnToZ(iFZIndex);

	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null)
		{
			continue;
		}

		if (pPlayerEntity.GetTeamNumber() != TEAM_LOBBYGUYS)
		{
			continue;
		}
	
		lobby_hint(ToZPPlayer(i));
	}
}

void TurnToZ(const int &in index)
{
	if (index != 0 && index > 0)
	{
		if (index == iFZIndex)
		{
			iFZIndex = 0;
		}

		CZP_Player@ pPlayer = ToZPPlayer(index);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

		if (pPlayer !is null)
		{
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if (g_bIsFirstInfected[index])
			{
				pSoloMode.SetValue("0");
				bAllowZombieSpawn = true;
				Engine.EmitSound("CS_FirstTurn");
				g_bWasFirstInfected[index] = true;
			}

			g_bIsWeakZombie[index] = false;
			pPlayer.SetArmModel("models/cszm/weapons/c_css_zombie_arms.mdl");
			EmitBloodEffect(pPlayer, false);
			pPlayer.CompleteInfection();
			pCSZMPlayer.SetDefSpeed(SPEED_ZOMBIE);

			if (g_bIsFirstInfected[index])
			{
				pPlayer.SetCarrier(true);
			}

			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Mute");
			Engine.EmitSoundEntity(pBaseEnt, "Flesh.HeadshotExplode");
			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Turn");

			RndZModel(pPlayer, pBaseEnt);
			SetZMHealth(pBaseEnt);
		}
	}
}

void SpawnWeakZombie(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	const int index = pBaseEnt.entindex();

	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

	if (pPlayer.IsCarrier()) 
	{
		pBaseEnt.SetModel("models/cszm/carrier.mdl");
		pPlayer.SetArmModel("models/weapons/arms/c_carrier.mdl");
	}
	
	else 
	{
		pBaseEnt.SetModel("models/cszm/zombie_charple.mdl");
		pPlayer.SetArmModel("models/cszm/weapons/c_css_zombie_arms.mdl");
	}

	Utils.CosmeticWear(pPlayer, "models/cszm/weapons/w_knife_t.mdl");
	pBaseEnt.SetMaxHealth(15);
	pBaseEnt.SetHealth(CONST_WEAK_ZOMBIE_HP);
	pCSZMPlayer.SetDefSpeed(SPEED_WEAK);
	pCSZMPlayer.SetZMVoice(-1);
	Chat.PrintToChatPlayer(pPlrEnt, strWeakZombie);
}

void RndZModel(CZP_Player@ pPlayer, CBaseEntity@ pPlayerEntity)
{
	Utils.CosmeticWear(pPlayer, "models/cszm/weapons/w_knife_t.mdl");
	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[pPlayerEntity.entindex()];

	pCSZMPlayer.SetZMVoice(Math::RandomInt(1,3));
	
	if (g_bIsFirstInfected[pPlayerEntity.entindex()])
	{
		pPlayerEntity.SetModel("models/cszm/zombie_morgue.mdl");
	}

	else 
	{	
		if (pPlayer.IsCarrier())
		{
			pPlayerEntity.SetModel("models/cszm/carrier.mdl");
		}

		else
		{
			if(g_strMDLToUse.length() == 0)
			{
				for (uint i = 0; i < g_strModels.length(); i++)
				{
					g_strMDLToUse.insertLast(g_strModels[i]);
				}
			}

			int iRNG = Math::RandomInt(0, g_strMDLToUse.length() - 1);

			pPlayerEntity.SetModel(g_strMDLToUse[iRNG]);
			g_strMDLToUse.removeAt(iRNG);
		}
	}
}

void SetZMHealth(CBaseEntity@ pEntPlr)
{
	int index = pEntPlr.entindex();

	if (g_iZMDeathCount[index] < 0)
	{
		g_iZMDeathCount[index] = 0;
	}
	
	int iHPBonus = int(g_iZMDeathCount[index] * CONST_DEATH_BONUS_HP);
	CZP_Player@ pPlayer = ToZPPlayer(pEntPlr);
	int iArmor = pPlayer.GetArmor();

	if (iArmor > 0)
	{
		pPlayer.SetArmor(0);
	}
	
	if (!pPlayer.IsCarrier())
	{
		pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + CONST_ZOMBIE_ADD_HP + iHPBonus);
		pEntPlr.SetHealth(pEntPlr.GetHealth() + (CONST_ZOMBIE_ADD_HP / 4) + iHPBonus + (iArmor * 2));
	}

	else if (pPlayer.IsCarrier() && !g_bIsFirstInfected[index])
	{
		int iZombCount = Utils.GetNumPlayers(zombie, false);
		float flAloneMult = 0.5;
		
		switch(iZombCount)
		{
			case 1:
				flAloneMult = 1.95f;
			break;
			
			case 2:
				flAloneMult = 0.95f;
			break;
		}

		pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + int(float(CONST_CARRIER_HP) + (float(iHPBonus) * flAloneMult)));
		pEntPlr.SetHealth(pEntPlr.GetHealth() + int(float(CONST_CARRIER_HP) + (float(iHPBonus) * flAloneMult)) + iArmor);
	}

	else
	{
		pEntPlr.SetMaxHealth(iFirstInfectedHP / 3);
		pEntPlr.SetHealth(iFirstInfectedHP + iArmor);
	}
}