/*
///////////////////////////////////////////////////////////////////
/////////////////| Counter-Strike Zombie Mode  |///////////////////
/////////////////|		 Core Script		 |///////////////////
///////////////////////////////////////////////////////////////////
*/

#include "../SendGameText"
#include "./cszm_modules/cache.as"
#include "./cszm_modules/killfeed.as"
#include "./cszm_modules/chat.as"
#include "./cszm_modules/rprop.as"
#include "./cszm_modules/entities.as"
#include "./cszm_modules/antidote.as"
#include "./cszm_modules/item_flare.as"

//Some Data
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

//GamePlay Consts and Variables
//Player Speed
const int SPEED_DEFAULT = 225;
const int SPEED_HUMAN = 212; 
const int SPEED_ZOMBIE = 185;
const int SPEED_CARRIER = 204;
const int SPEED_WEAK = 231;
const int SPEED_ADRENALINE = 80;
const int SPEED_MINIMUM = 80;

//Damage Slowdown
const float CONST_MAX_SLOWTIME = 2.0f;	//Maximum amount of seconds a zombie could be slowed down
const float CONST_RECOVER_UNIT = 0.285f;	//Amount of time in one tick of a speed recovery
const float CONST_SLOWDOWN_TIME = 0.2f;	//Amount of time in one tick of a speed recovery

//Team Consts
const int TEAM_LOBBYGUYS = 0;
const int TEAM_SPECTATORS = 1;
const int TEAM_SURVIVORS = 2;
const int TEAM_ZOMBIES = 3;

//Other Consts
const float CONST_SPAWN_DELAY = 5.0f;	//Zombies spawn delay.
const int CONST_FI_HEALTH_MULT = 125;	//HP multiplier of first infected.
const int CONST_ZOMBIE_ADD_HP = 200;	//Additional HP to Max Health of a zombie.
const int CONST_WEAK_ZOMBIE_HP = 125;	//Health of the weak zombies
const int CONST_CARRIER_HP = 0;	//Additional HP to Max Health of the carrier.	(Currently equal 0 because the carrier is too OP)
const int CONST_REWARD_HEALTH = 125;	//Give that amount of HP as reward of successful infection.
const int CONST_GEARUP_TIME = 40;	//Time to gear up and find a good spot.
const int CONST_TURNING_TIME = 20;	//Turning time.
const int CONST_INFECT_DELAY = 2;	//Amount of rounds you have to wait to be the First Infected again.
const int CONST_WARMUP_TIME = 10;	//Time of the warmup in seconds.		(default value is 75)
const float CONST_WEAK_ZOMBIE_TIME = 45.0f;								
const int CONST_SUBTRACT_DEATH = 1;	//Amount of units subtract from the death counter
const int CONST_INFECT_ADDTIME = 15;	//Amount of time in seconds add to the round time in case of successful infection
const int CONST_DEATH_BONUS_HP = 75;	//Multiplier of death hp bonus.
const int CONST_DEATH_MAX = 8;	//Maximum amount of death to boost up the max health.
const int CONST_ROUND_TIME = 300;	//Round time in seconds.
const int CONST_ROUND_TIME_FULL = CONST_ROUND_TIME + CONST_GEARUP_TIME;	//Round time in seconds.
const int CONST_ZOMBIE_LIVES = 32;	//Hold Zombie Lives at this level (Zombie Lives unused in CSZM) 
const float CONST_ROUND_TIME_GAME = 300;	//Hold IN-Game Round timer at this level (IN-Game Round timer unused in CSZM)
const float CONST_SLOWDOWN_MULT = 40;	//36.0f
const float CONST_SLOWDOWN_WEAKMULT = 30;
const float CONST_SLOWDOWN_CRITDMG = 45.0f;
const float CONST_ADRENALINE_DURATION = 12.0f;
const int CONST_MAX_INFECTRESIST = 2;
const float CONST_ZO_DISTANCE = 2000.0f;

//ZM Voice related stuff
const int CONST_MAX_VOICEINDEX = 3;
const string CONST_ZM_PAIN = "CSPlayer_Z.Pain";
const string CONST_ZM_DIE = "CSPlayer_Z.Die";
const string CONST_ZM_IDLE = "CSPlayer.Idle";

//Some text over here
const string strRoundBegun = "{default}Round has begun, you have {lightgreen}"+CONST_GEARUP_TIME+" seconds{default} to gear up before the {lightseagreen}first infected{default} turns.";
const string strCannotPlayFI = "{default}You cannot play as the {lightseagreen}first infected{default} every round...";
const string strChooseToPlayFI = "{default}You choose to play as the {lightseagreen}first infected{default}.";
const string strOnlyInLobby = "{default}Command should only be used in the {green}ready room{default}.";
const string strBecomFI = "- You are the first infected -\n";
const string strTurningIn = "Turning in ";
const string strSecs = " seconds...";
const string strSec = " second...";
const string strOutbreakMsg = "!!! Outbreak has begun !!!";
const string strBecameFi = " {default}became the {lightseagreen}first infected{default}.";
const string strCannotJoinGame = "{default}You cannot join the game until the {lightseagreen}first infected{default} turns...";
const string strCannotJoinZT0 = "{default}You cannot join the {red}zombie team{default} until the {lightseagreen}first infected{default} turns...";
const string strCannotJoinZT1 = "{default}Round is already in progress, you cannot join the {red}zombie team{default} right now.";
const string strHintF1 = "F1 - Humans Team";
const string strHintF2Inf = "F2 - Be The First Infected";
const string strHintF2 = "F2 - Zombie Team";
const string strHintF3 = "F3 - Spectate";
const string strHintF4 = "F4 - Back to the Lobby";
const string strHintF4WU = "F4 - Respawn";
const string strLastZLeave = "{red}WARNING{default}: Last player in the Zombie team has leave.\n{blue}Round Restarting....";
const string strAMP = "Awaiting More Players";
const string strWarmUp = "-= Warm Up! =-";
const string strWeakZombie = "{cornflowerblue}*You're spawned as weak zombie!";

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
array<float> g_flFRespawnCD;
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

	CSZMPlayer(int index, int NormSpeed)
	{
		PlayerIndex = index;
		SlowTime = 0;
		SlowSpeed = 0;
		DefSpeed = NormSpeed;
		SpeedRT = 0;
		Voice = 0;
		PreviousVoice = 0;
		VoiceTime = 0;
		AdrenalineTime = 0;
		InfectResist = 0;
		IRITime = 0;
		MeleeFreezeTime = 0;
		OutlineTime = 0;
	}

	void Zeroing()
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		AdrenalineTime = 0;
		VoiceTime = 0;
		SlowTime = 0;
		InfectResist = 0;
		IRITime = 0;
		MeleeFreezeTime = 0;
		pPlayer.DoPlayerDSP(0);
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
					VoiceIndex = Math::RandomInt(1, CONST_MAX_VOICEINDEX);
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

		VoiceTime += Math::RandomFloat(0.24f, 0.33f);

		float CurrentTime = SlowTime - Globals.GetCurrentTime();
		float NewTime;
		int NewSpeed;

		NewTime = CONST_SLOWDOWN_TIME;

		//Add time if critical dmg
		if (flDamage > CONST_SLOWDOWN_CRITDMG)
		{
			NewTime = 0.45f;
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
			SetAntidoteState(PlayerIndex, 1);
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
			SetAntidoteState(PlayerIndex, 0);
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
				OutlineTime = Globals.GetCurrentTime() + 0.1f;
				int cRed = 0;
				int cGreen = 127;
				int cBlue = 101;
				float ExtraDistance = 0;

				if (pPlayer.IsCarrier() && !g_bIsFirstInfected[PlayerIndex])
				{
					cRed = 190;
					cGreen = 95;
					cBlue = 0;
					ExtraDistance = 347.0f;
				}

				if (g_bIsFirstInfected[PlayerIndex])
				{
					cRed = 145;
					cGreen = 95;
					cBlue = 215;
					ExtraDistance = 724.0f;
				}

				if (g_bIsWeakZombie[PlayerIndex])
				{
					cRed = 82;
					cGreen = 125;
					cBlue = 191;
					ExtraDistance = -256.0f;
				}

				pPlayerEntity.SetOutline(true, filter_team, TEAM_ZOMBIES, Color(cRed, cGreen, cBlue), CONST_ZO_DISTANCE + ExtraDistance, true, false);
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
					bool bAllowIdleSound = false;

					if (pPlayer.IsCarrier() && g_bIsFirstInfected[PlayerIndex])
					{
						bAllowIdleSound = true;
					}

					if (!pPlayer.IsCarrier())
					{
						bAllowIdleSound = true;
					}

					if (bAllowIdleSound)
					{
						if (pPlayerEntity.GetWaterLevel() != WL_Eyes)
						{
							Engine.EmitSoundEntity(pPlayerEntity, CONST_ZM_IDLE + Voice);
						}

						float Time_Low = 3.15f;
						float Time_High = 12.10f;

						switch(Voice)
						{
							case 2:
								Time_Low = 3.0f;
								Time_High = 6.65f;
							break;
							
							case 3:
								Time_Low = 3.75f;
								Time_High = 9.75f;
							break;
						}

						VoiceTime = Globals.GetCurrentTime() + Math::RandomFloat(Time_Low, Time_High);
					}
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

			if ( IRITime <= Globals.GetCurrentTime() && Utils.StrContains("iantidote", pWeapon.GetEntityName()))
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
		g_flFRespawnCD.resize(iMaxPlayers + 1);
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
		ClearFloatArray(g_flFRespawnCD);
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

void SetUsed(const int &in index, CBaseEntity@ pItemDeliver)
{
	pItemDeliver.SetEntityName("used" + index);
	Engine.Ent_Fire("used" + index, "addoutput", "itemstate 0");
	Engine.Ent_Fire("used" + index, "kill", "0", "0.5");	
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
		CSZMPlayerArray.insertAt(index, CSZMPlayer(index, SPEED_DEFAULT));
		
		g_flFRespawnCD[index] = 0;
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
					if (Utils.StrEql("choose4", pArgs.Arg(0)) && g_flFRespawnCD[index] <= Globals.GetCurrentTime())
					{
						g_flFRespawnCD[index] = Globals.GetCurrentTime() + 0.45f;
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

		//Set CSS Arms (human type) if not zombie
		if (TeamNum != TEAM_ZOMBIES)
		{
			pPlayer.SetArmModel("models/cszm/weapons/c_css_arms.mdl");
		}

		//Don't set CSS Arms (zombie type) to The Carrier
		else
		{
			if (!pPlayer.IsCarrier())
			{
				pPlayer.SetArmModel("models/cszm/weapons/c_css_zombie_arms.mdl");
			}
		}

		//If in lobby team set the lobby guy player model
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
		
		if (!bWarmUp)
		{
			if (TeamNum == TEAM_SPECTATORS)
			{
				spec_hint(pPlayer);
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

					EmitBloodExp(pPlayer, true);
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

			if (CountPlrs(0) <= 2 && iWUSeconds == CONST_WARMUP_TIME)
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

		if (Utils.StrEql(pEntityAttacker.GetEntityName(), "frendly_shrapnel") && iVicTeam == 2)
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

		if (iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && iDamageType == 8196)
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
				pVicCSZMPlayer.EmitZMSound(CONST_ZM_PAIN);
			}

			pVicCSZMPlayer.AddSlowdown(flDamage, iDamageType);
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerInfected(CZP_Player@ pPlayer, InfectionState iState)
{
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

		pVicCSZMPlayer.Zeroing();
		
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
			pVicCSZMPlayer.EmitZMSound(CONST_ZM_DIE);

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
				pCSZMPlayer.Zeroing();
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

int ChooseVolunteer()
{
	int iCount = 0;
	int iVIndex = 0;
	
	array<int> p_VolunteerIndex = {0};
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlrEntity = FindEntityByEntIndex(i);
		
		if (pPlrEntity is null)
		{
			continue;
		}
		
		if (g_bIsVolunteer[i] && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS && pPlrEntity.IsAlive())
		{
			iCount++;
			p_VolunteerIndex.insertLast(i);
		}
	}
	
	if (iCount != 0)
	{
		int iLength = p_VolunteerIndex.length() - 1;

		if (iLength == 1)
		{
			iVIndex = p_VolunteerIndex[1];
		}

		else
		{
			iVIndex = p_VolunteerIndex[Math::RandomInt(1, iLength)];
		}
	}
	
	return iVIndex;
}

int ChooseVictim()
{
	int iCount = 0;
	int iVicIndex = 0;
	int iRND;
	
	array<int> p_VictimIndex = {0};
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlrEntity = FindEntityByEntIndex(i);
		
		if (pPlrEntity is null)
		{
			continue;
		}
		
		if (!g_bWasFirstInfected[i] && pPlrEntity.IsAlive() && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS && g_iInfectDelay[i] < 2)
		{
			iCount++;
			p_VictimIndex.insertLast(i);
		}
	}
	
	if (iCount != 0)
	{
		int iLength = p_VictimIndex.length() - 1;

		if (iLength > 1)
		{
			iVicIndex = p_VictimIndex[Math::RandomInt(1, iLength)];
		}

		else
		{
			iVicIndex = p_VictimIndex[1];
		}
	}

	if (iCount == 0)
	{
		CZP_Player@ pVictim = GetRandomPlayer(survivor, true);
		CBasePlayer@ pVPlrEnt = pVictim.opCast();
		CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();

		iVicIndex = pVBaseEnt.entindex();
	}
	
	return iVicIndex;
}

void DecideFirstInfected()
{
	int iPlrWasFZ = 0;
	int iPlr = 0;
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if (pPlayer is null)
		{
			continue;
		}
		
		iPlr++;

		if (g_bWasFirstInfected[i])
		{
			iPlrWasFZ++;
		}
	}
	
	if (iPlrWasFZ >= iPlr)
	{
		for (int i = 1; i <= iMaxPlayers; i++)
		{
			g_bWasFirstInfected[i] = false;
		}
	}

	if (iFZIndex == 0)
	{
		iFZIndex = ChooseVolunteer();
	}

	if (iFZIndex == 0)
	{
		iFZIndex = ChooseVictim();
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
		EndGame();
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

void SetShowTime()
{
	flShowHours = floor(iSeconds / 3600);
	flShowMinutes = floor((iSeconds - flShowHours * 3600) / 60);
	flShowSeconds = floor(iSeconds - (flShowHours * 3600) - (flShowMinutes * 60));
}

void ShowTimer(float &in flHoldTime)
{
	SetShowTime();

	string SZero = "0";
	string MZero = "0";
	
	if (flShowMinutes <= 9)
	{
		MZero = "0";
	}

	else
	{
		MZero = "";
	}
	
	if (flShowSeconds <= 9)
	{
		SZero = "0";
	}

	else
	{
		SZero = "";
	}

	string TimerText = MZero + flShowMinutes + ":" + SZero + flShowSeconds;

	if (flHoldTime <= 0)
	{
		flHoldTime = 1.08f;
	}
	
	SendGameText(any, TimerText, 0, 1, -1, 0, 0, 0, flHoldTime, Color(235, 235, 235), Color(0, 0, 0));
}

void ShowOutbreak(int &in index)
{
	CZP_Player@ pFirstInf = ToZPPlayer(index);
	string strColor = "blue";

	if (g_bIsVolunteer[index])
	{
		strColor = "violet";
	}
	
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if (pPlayer is null)
		{
			continue;
		}
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if (i != index)
		{
			Chat.PrintToChatPlayer(pPlrEnt, "{" + strColor + "}" + pFirstInf.GetPlayerName() + strBecameFi);
		}
	}

	SendGameText(any, strOutbreakMsg, 1, 0, -1, 0.175, 0, 0.35, 6.75, Color(64, 255, 128), Color(0, 255, 0));
}

void EndGame()
{
	if (Utils.GetNumPlayers(survivor, true) > 0) 
	{
		RoundManager.SetWinState(ws_HumanWin);
	}

	else if (Utils.GetNumPlayers(zombie, true) == 0) 
	{
		RoundManager.SetWinState(ws_Stalemate);
	}

	else
	{
		RoundManager.SetWinState(ws_ZombieWin);
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
		CBaseEntity@ pEntPlayer = FindEntityByEntIndex(i);

		if (pEntPlayer is null)
		{
			continue;
		}

		if (pEntPlayer.GetTeamNumber() != TEAM_LOBBYGUYS)
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
			pCSZMPlayer.SetDefSpeed(SPEED_ZOMBIE);
			pPlayer.SetArmModel("models/cszm/weapons/c_css_zombie_arms.mdl");
			EmitBloodExp(pPlayer, false);
			pPlayer.CompleteInfection();

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

void EmitBloodExp(CZP_Player@ pPlayer, const bool &in bSilent)
{
	if (pPlayer is null)
	{
		return;
	}

	Utils.ScreenFade(pPlayer, Color(125, 35, 30, 145), 0.375, 0, fade_in);

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	CEntityData@ CameraBloodIPD = EntityCreator::EntityData();
	CameraBloodIPD.Add("targetname", "PS-Turn-Head");
	CameraBloodIPD.Add("flag_as_weather", "0");
	CameraBloodIPD.Add("start_active", "1");
	CameraBloodIPD.Add("effect_name", "blood_impact_red_01_headshot");
	CameraBloodIPD.Add("kill", "0", true, "0.05");

	CEntityData@ BodyBloodIPD = EntityCreator::EntityData();
	BodyBloodIPD.Add("targetname", "PS-Turn");
	BodyBloodIPD.Add("flag_as_weather", "0");
	BodyBloodIPD.Add("start_active", "1");
	BodyBloodIPD.Add("effect_name", "blood_explode_01");
	BodyBloodIPD.Add("kill", "0", true, "0.05");

	EntityCreator::Create("info_particle_system", pBaseEnt.EyePosition(), pBaseEnt.EyeAngles(), CameraBloodIPD);
	EntityCreator::Create("info_particle_system", pBaseEnt.GetAbsOrigin(), pBaseEnt.GetAbsAngles(), BodyBloodIPD);
	
	if (!bSilent)
	{
		Engine.EmitSoundEntity(pBaseEnt, "Flesh.HeadshotExplode");
	}
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
	
	int iHPBonus = g_iZMDeathCount[index] * CONST_DEATH_BONUS_HP;
	CZP_Player@ pPlayer = ToZPPlayer(pEntPlr);
	int iArmor = pPlayer.GetArmor();

	if (iArmor > 0)
	{
		pPlayer.SetArmor(0);
	}
	
	if (!pPlayer.IsCarrier())
	{
		pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + CONST_ZOMBIE_ADD_HP + iHPBonus);
		pEntPlr.SetHealth(pEntPlr.GetHealth() + (CONST_ZOMBIE_ADD_HP / 4) + iHPBonus + iArmor);
	}

	else if (pPlayer.IsCarrier() && !g_bIsFirstInfected[index])
	{
		int iZombCount = Utils.GetNumPlayers(zombie, false);
		float flMultiplier = 0.5;
		
		switch(iZombCount)
		{
			case 1:
				flMultiplier = 1.95f;
			break;
			
			case 2:
				flMultiplier = 0.95f;
			break;
		}

		pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + int(float(CONST_CARRIER_HP) + (float(iHPBonus) * flMultiplier)));
		pEntPlr.SetHealth(pEntPlr.GetHealth() + int(float(CONST_CARRIER_HP) + (float(iHPBonus) * flMultiplier)) + iArmor);
	}

	else
	{
		pEntPlr.SetMaxHealth(iFirstInfectedHP / 3);
		pEntPlr.SetHealth(iFirstInfectedHP + iArmor);
	}
}

//WarmUp Related Funcs
void WarmUpTimer()
{
	int iNumPlrs = 0;
	iNumPlrs += CountPlrs(0);

	if (bWarmUp && iNumPlrs >= 2)
	{
		flWUWait = Globals.GetCurrentTime() + 1.0f;

		string TimerText = "\n\n\n"+strWarmUp+"\n| "+iWUSeconds+" |";
		SendGameText(any, TimerText, 1, 0, -1, 0, 0, 0, 1.10f, Color(255, 175, 85), Color(255, 95, 5));

		if (iWUSeconds == 0)
		{
			WarmUpEnd();
		}

		if (iWUSeconds > 0)
		{
			iWUSeconds--;
		}
	}
	
	else if (iNumPlrs <= 1)
	{
		flWUWait = 0;
		iWUSeconds = CONST_WARMUP_TIME;
		SendGameText(any, strAMP, 1, 0, -1, 0, 0, 0, 600, Color(255, 255, 255), Color(255, 95, 5));
	}
}

void WarmUpEnd()
{
	if (bWarmUp)
	{
		bWarmUp = false;
	}
	
	flWUWait = 0;
	Engine.EmitSound("@buttons/button3.wav");
	string TimerText = "\n\n\n"+strWarmUp+"\n| 0 |";
	SendGameText(any, TimerText, 1, 0, -1, 0, 0, 0.35f, 0.05f, Color(255, 175, 85), Color(255, 95, 5));
	SendGameText(any, "", 3, 0, 0, 0, 0, 0, 0, Color(0, 0, 0), Color(0, 0, 0));
	SendGameText(any, strHintF1, 3, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(64, 128, 255), Color(255, 95, 5));

	if (!RoundManager.IsRoundOngoing(false))
	{
		SendGameText(any, "\n" + strHintF2Inf, 4, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(255, 32, 64), Color(255, 95, 5));
	}

	else
	{
		SendGameText(any, "\n" + strHintF2, 4, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(255, 32, 64), Color(255, 95, 5));
	}

	SendGameText(any, "\n\n" + strHintF3, 5, 0, 0.05f, 0.10f, 0, 2.0f, 120, Color(255, 255, 255), Color(255, 95, 5));
}