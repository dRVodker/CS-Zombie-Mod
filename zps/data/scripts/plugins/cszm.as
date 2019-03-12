/*
///////////////////////////////////////////////////////////////////
/////////////////| Counter-Strike Zombie Mode  |///////////////////
/////////////////|        Alpha Version        |///////////////////
///////////////////////////////////////////////////////////////////
*/

#include "../SendGameText"
#include "./cszm/cache.as"
#include "./cszm/armor.as"

//MyDebugFunc
void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void ShowChatMsg(const string &in strMsg, const int &in iTeamNum)
{
	if(iTeamNum != -1)
	{
		for(int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);

			if(pPlayer is null) continue;

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if(pBaseEnt.GetTeamNumber() == iTeamNum)
			{
				Chat.PrintToChatPlayer(pPlrEnt, strMsg);
			}
		}
	}
	else Chat.PrintToChat(all, strMsg);
}

void EmitCountdownSound(const int &in iNumber)
{
	Engine.EmitSound("CS_FVox" + iNumber);
}

bool bAllowDebug = false;				//Allow Debug?

//Some Data
CASConVar@ pSoloMode = null;
CASConVar@ pTestMode = null;
CASConVar@ pINGWarmUp = null;
CASConVar@ pFriendlyFire  = null;
int iUNum;
int iMaxPlayers;
int iDoorsState;

bool bIsCSZM;							//Is CSZM available? (Depends on a map)

bool bIsFirstITurns;
bool bAZSProgress;
bool bAllowCD;
bool bAllowZS;
bool bAllowZMIdleSND;
bool bAllowZMSlowD;
bool bAllowFZColor;
bool bAllowAddTime = true;				//Allow add time for successful infection
bool bAllowWarmUp = true;

//GamePlay Consts
//Slowdown Multipliers
//const float flMaxSDMult = 1.500f;		//Maximum slow down multiplier.
const float flSDMult = 0.02f;			//Any other type of a damage.
const float flSDMultSG = 0.12f;
const float flSDMultEXP = 0.3f;
const float flSDMultMAG = 0.17f;
const float flSDMultMEL = 0.3f;
const float flSDMultFALL = 0.15f;

//Slowdown Time
//const float flSDTime = 0.125f;		//Any other type of a damage.
const float flSDTime = 0.27f;			//Maximum slow down time.
const float flSDTimeSG = 0.36f;
const float flSDTimeMAG = 0.47f;
const float flSDTimeFALL = 0.5f;
const float flSDTimeMEL = 1.25f;
const float flSDTimeEXP = 2.0f;

//Other Consts
const float flHPRDelay = 0.42f;			//Amount of time you have to wait to start HP Regeneration. (Custom HP Regeneration)
const float flSpawnDelay = 3.00f;		//Zombies spawn delay.
const int iFirstInfectedHPMult = 125;	//HP multiplier of first infected.
const int iZombieMaxHP = 200;			//Additional HP to Max Health of a zombie.
const int iHPReward = 125;				//Give that amount of HP as reward of successful infection.
const int iGearUpTime = 40;				//Time to gear up and find a good spot.
const int iTurningTime = 20;			//Turning time.
const int iInfectDelay = 3;				//Amount of rounds you have to wait to be the First Infected again.
const int iWUTime = 4;					//Time of the warmup in seconds.		(default value is 76)

//New Consts
const bool bAllowTimeHP = true;			//Allow Time HP Bonus
const float flBlockZSTime = 35.00f;		//Amount of time in seconds which abusers must wait to join the zombie team.
const float flCSDDivider = 4.00f;		//Slowdown divider of the carrier.
const float flFISDDivider = 1.85f;		//Slowdown divider of the first infected.
const int iSubtractDeath = 2;			//Amount of units subtract from the death counter
const int iInfectionATSec = 15;			//Amount of time in seconds add to the round time in case of successful infection
const int iCarrierMaxHP = 0;			//Additional HP to Max Health of the carrier.	(Currently equal 0 because the carrier is too OP)
const int iDHPBonus = 100;				//Multiplier of death hp bonus.
const int iTHPBonus = 45;				//Multiplier of time hp bonus.
const int iMaxDeath = 7;				//Maximum amount of death to boost up the max health.
const int iDefaultTHPSeconds = 30;		//Amount of time in seconds to increase amount of the time hp bonus.

const int iRoundTime = 300 + iGearUpTime;						//Round time in seconds.
const int iSoT = iRoundTime - iGearUpTime + iTurningTime;		//Second at which the turning time start countdown. don't touch this.

const float flBaseSDMult = 1.01f;		//Base value of slowdown
const float flMaxSDMult = 0.25f;		//Maximum value of slowdown
const float flBaseRecoverTime = 0.055f;	//Base recover Time

//Some text over here
const string strRoundBegun = "{default}Round has begun, you have {lightgreen}"+iGearUpTime+" seconds{default} to gear up before the {lightseagreen}first infected{default} turns.";
const string strCannotPlayFI = "{default}You cannot play as the {lightseagreen}first infected{default} every round...";
const string strChooseToPlayFI = "{default}You choose to play as the {lightseagreen}first infected{default}.";
const string strOnlyInLobby = "{default}Command should only be used in the {green}ready room{default}.";
const string strBecomFI = "- You will become the first infected -\n";
const string strTurningIn = "Turning in ";
const string strSecs = " seconds...";
const string strSec = " second...";
const string strOutbreakMsg = "!!! Outbreak has begun !!!";
const string strBecameFi = " {default}became the {lightseagreen}first infected{default}.";
const string strCannotJoinZT0 = "{default}You cannot join the {red}zombie team{default} until the {lightseagreen}first infected{default} turns...";
const string strCannotJoinZT1 = "{default}Round is already in progress, you cannot join the {red}zombie team{default} right now.";
const string strHintF1 = "F1 - Join the game";
const string strHintF3 = "F3 - Spectate";
const string strHintF4 = "F4 - Back to the Lobby";
const string strLastZLeave = "{red}WARNING{default}: Last player in the Zombie team has leave.\n{blue}Round Restarting....";
const string strAMP = "Awaiting More Players";
const string strWarmUp = "-= Warm Up! =-";

//List of available ZM Player models (make sure your server has it)
array<string> g_strModels = 
{
	"models/cszm/carrier.mdl",
	"models/cszm/zombie_classic.mdl",
	"models/cszm/zombie_sci.mdl",
	"models/cszm/zombie_corpse1.mdl",
	"models/cszm/zombie_charple.mdl",
	"models/cszm/zombie_charple2.mdl",
	"models/cszm/zombie_sawyer.mdl",
	"models/cszm/zombie_eugene.mdl"
};

array<bool> g_bAModels;

//Other arrays (Don't even touch this)
array<float> g_flIdleTime;
array<float> g_flSDTime;
array<float> g_flSDMulti;
array<float> g_flHPRDelay;
array<int> g_iInfectDelay;
array<int> g_iZMDeathCount;

array<int> g_iCVSIndex;
array<bool> g_bWasFirstInfected;
array<bool> g_bIsVolunteer;
array<bool> g_bIsSpawned;
array<bool> g_bIsFirstInfected;
array<bool> g_bIsAbuser;

//Other Data (Don't even touch this)
bool bETimeHP;
int iTimeHPBonusSeconds = iDefaultTHPSeconds;
int iTimeHPBonus = 0;
int iFirstInfectedHP;
int iSeconds;
int iSAt;
int iFZTurningTime = 0;
int iFZIndex = 0;
int iRND_CVS_PV;
int iWUSeconds = iWUTime;
float flIdleTimer;
float flSloDTimer;
float flSloDRecoreTime;
float flHPRegenTime;

void OnPluginInit()
{
	//Find 'sv_zps_solo' ConVar
	@pSoloMode = ConVar::Find("sv_zps_solo");
	if(pSoloMode !is null) ConVar::Register(pSoloMode, "ConVar_SoloMode");

	//Find 'sv_testmode' ConVar
	@pTestMode = ConVar::Find("sv_testmode");
	if(pTestMode !is null) ConVar::Register(pTestMode, "ConVar_TestMode");

	//Find 'sv_zps_warmup' ConVar
	@pINGWarmUp = ConVar::Find("sv_zps_warmup");
	if(pINGWarmUp !is null) ConVar::Register(pINGWarmUp, "ConVar_WarmUpTime");

	//Find 'mp_friendlyfire' ConVar
	@pFriendlyFire = ConVar::Find("sv_zps_warmup");
	if(pFriendlyFire !is null) ConVar::Register(pFriendlyFire, "ConVar_FriendlyFire");

	//Events
	Events::Player::OnPlayerInfected.Hook(@OnPlayerInfected);
	Events::Player::OnPlayerConnected.Hook(@OnPlayerConnected);
	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Events::Entities::OnEntityCreation.Hook(@OnEntityCreation);
	Events::Player::OnPlayerDamaged.Hook(@OnPlayerDamaged);
	Events::Player::OnPlayerKilled.Hook(@OnPlayerKilled);
	Events::Player::OnPlayerDisonnected.Hook(@OnPlayerDisonnected);
	Events::Rounds::RoundWin.Hook(@RoundWin);
	Events::Player::OnPlayerRagdollCreate.Hook(@OnPlayerRagdollCreate);
	Events::Player::OnConCommand.Hook(@OnConCommand);
}

HookReturnCode OnPlayerRagdollCreate(CZP_Player@ pPlayer, bool &in bHeadshot, bool &out bExploded)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if(Utils.StrContains("cszm", pBaseEnt.GetModelName())) bHeadshot = false;	//Disabled headshots cuz it fucked up in the game

	return HOOK_CONTINUE;
}

void OnMapInit()
{
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		Log.PrintToServerConsole( LOGTYPE_INFO, "CSZM", "[CSZM] Current map is valid for 'Counter-Strike Zombie Mode'" );
		bIsCSZM = true;
		
		//Set some ConVar to 0
		pSoloMode.SetValue("0");
		pTestMode.SetValue("0");
		pINGWarmUp.SetValue("0");
		pFriendlyFire.SetValue("0");
		
		//Cache
		CacheModels();
		CacheSounds();
		
		//Get MaxPlayers
		iMaxPlayers = Globals.GetMaxClients();
		
		//Entities
		Entities::RegisterPickup("item_armor");
		
		//Resize
		g_flIdleTime.resize(iMaxPlayers + 1);
		g_flSDTime.resize(iMaxPlayers + 1);		
		g_flSDMulti.resize(iMaxPlayers + 1);
		g_iCVSIndex.resize(iMaxPlayers + 1);
		g_bWasFirstInfected.resize(iMaxPlayers + 1);
		g_bIsFirstInfected.resize(iMaxPlayers + 1);
		g_bIsAbuser.resize(iMaxPlayers + 1);
		g_bIsVolunteer.resize(iMaxPlayers + 1);
		g_flHPRDelay.resize(iMaxPlayers + 1);
		g_iInfectDelay.resize(iMaxPlayers + 1);
		g_iZMDeathCount.resize(iMaxPlayers + 1);
		g_bIsSpawned.resize(iMaxPlayers + 1);
		g_iArmor.resize(iMaxPlayers + 1);
		
		g_bAModels.resize(g_strModels.length());
		
		for(uint i = 0; i <= g_strModels.length() - 1; i++)
		{
			g_bAModels[i] = true;
		}
		
		//Set Wait Time
		flIdleTimer = Globals.GetCurrentTime() + 0.10f;
		flSloDTimer = Globals.GetCurrentTime() + 0.01f;
		flHPRegenTime = Globals.GetCurrentTime() + 0.15f;
		flSloDRecoreTime = Globals.GetCurrentTime() + flBaseRecoverTime;
		
		//Set Doors Filter to 0 (any team)
		if(bAllowWarmUp == true) SetDoorFilter(0);
	
	}
	else
	{
		Log.PrintToServerConsole( LOGTYPE_INFO, "CSZM", "[CSZM] Current map is not valid for 'Counter-Strike Zombie Mode'" );
	}
}

void OnMapShutdown()
{
	pSoloMode.SetValue("0");

	bIsCSZM = false;
	iSeconds = 0;
	iSAt = 0;
	iFZTurningTime = 0;
	iFZIndex = 0;
	iTimeHPBonus = 0;
	iTimeHPBonusSeconds = iDefaultTHPSeconds;
	iWUSeconds = iWUTime;
	
	iUNum = 0;
	
	Entities::RemoveRegisterPickup("item_armor");
	
	bAllowCD = false;
	bIsFirstITurns = false;
	bAZSProgress = false;
	bAllowZS = false;
	bAllowZMIdleSND = false;
	bAllowZMSlowD = false;
	bAllowFZColor = false;
	bETimeHP = false;
	bAllowWarmUp = true;
	
	ClearBoolArray(g_bWasFirstInfected);
	ClearBoolArray(g_bIsFirstInfected);
	ClearBoolArray(g_bIsAbuser);
	ClearBoolArray(g_bIsVolunteer);
	ClearBoolArray(g_bIsSpawned);
	ClearBoolArray(g_bAModels);
	ClearIntArray(g_iCVSIndex);
	ClearIntArray(g_iInfectDelay);
	ClearIntArray(g_iZMDeathCount);
	ClearIntArray(g_iArmor);
	ClearFloatArray(g_flHPRDelay);
	ClearFloatArray(g_flSDMulti);
	ClearFloatArray(g_flSDTime);
	ClearFloatArray(g_flIdleTime);
}

void ClearIntArray(array<int> &iTarget)
{
    while(iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

void ClearFloatArray(array<float> &iTarget)
{
    while(iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

void ClearBoolArray(array<bool> &iTarget)
{
    while(iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

//CSZM Related Funcs
void OnProcessRound()
{
	if(bIsCSZM == true)
	{
		if(flIdleTimer <= Globals.GetCurrentTime())
		{
			flIdleTimer = Globals.GetCurrentTime() + 0.10f;

			for(int i = 1; i <= iMaxPlayers; i++)
			{
				CZP_Player@ pPlayer = ToZPPlayer(i);

				if(pPlayer is null) continue;

				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

				if(g_flIdleTime[i] <= 0 && pBaseEnt.GetTeamNumber() == 3 && pPlayer.IsCarrier() != true && pBaseEnt.IsAlive() == true)
				{
					Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Idle" + g_iCVSIndex[pBaseEnt.entindex()]);
					switch(g_iCVSIndex[i])
					{
						case 2:
							g_flIdleTime[i] = Math::RandomFloat(3.00f, 6.25f);
						break;
						
						case 3:
							g_flIdleTime[i] = Math::RandomFloat(3.75f, 9.15f);
						break;
						
						default:
							g_flIdleTime[i] = Math::RandomFloat(3.15f, 11.10f);
						break;	
					}
				}

				if(g_flIdleTime[i] > 0 && pBaseEnt.GetTeamNumber() == 3 && pPlayer.IsCarrier() != true && pBaseEnt.IsAlive() == true)
				{
					g_flIdleTime[i] -=0.10f;
				}
			}
		}
		
		if(flSloDTimer <= Globals.GetCurrentTime())
		{
			flSloDTimer = Globals.GetCurrentTime() + 0.01f;
		
			for(int i = 1; i <= iMaxPlayers; i++)
			{
				CZP_Player@ pPlayer = ToZPPlayer(i);
					
				if(pPlayer is null) continue;
					
				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
					
				if(g_flSDMulti[i] < 0)
				{
					g_flSDMulti[i] = 0.0f;
					continue;
				}
					
				if(g_flSDMulti[i] > 0 && pBaseEnt.IsAlive() == true)
				{
					float x = pBaseEnt.GetAbsVelocity().x;
					float y = pBaseEnt.GetAbsVelocity().y;
					float z = pBaseEnt.GetAbsVelocity().z;
					
					if(pBaseEnt.IsGrounded() == true)
					{
						x = pBaseEnt.GetAbsVelocity().x / (flBaseSDMult + g_flSDMulti[i]);
						y = pBaseEnt.GetAbsVelocity().y / (flBaseSDMult + g_flSDMulti[i]);

						pBaseEnt.SetAbsVelocity(Vector(x, y, z));
					}
						
					g_flSDTime[i] -= 0.01f;
						
					if(g_flSDTime[i] < 0) g_flSDTime[i] = 0.0f;
					
					if(bAllowDebug == true) Chat.CenterMessagePlayer(pPlrEnt, "SDMulti = "+g_flSDMulti[i]+"\nSDTime = "+g_flSDTime[i]);
				}
			}
			
			for(int i = 1; i <= iMaxPlayers; i++) 
			{
				CZP_Player@ pPlayer = ToZPPlayer(i);

				if(pPlayer is null) continue;

				if(g_flHPRDelay[i] > 0)
				{
					g_flHPRDelay[i] -= 0.01f;
					if(g_flHPRDelay[i] < 0) g_flHPRDelay[i] = 0;
				}
			}
		}
		
		if(flSloDRecoreTime <= Globals.GetCurrentTime())
		{
			flSloDRecoreTime = Globals.GetCurrentTime() + flBaseRecoverTime;
			
			for(int i = 1; i <= iMaxPlayers; i++)
			{
				CZP_Player@ pPlayer = ToZPPlayer(i);
					
				if(pPlayer is null) continue;
					
				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
				
				if(g_flSDTime[i] <= 0 && g_flSDMulti[i] > 0) g_flSDMulti[i] -= 0.01f;
				
				if(g_flSDMulti[i] < 0) g_flSDMulti[i] = 0.0f;
			}
		}
		
		if(flHPRegenTime <= Globals.GetCurrentTime())
		{
			flHPRegenTime = Globals.GetCurrentTime() + 0.25f;
			
			for(int i = 1; i <= iMaxPlayers; i++) 
			{
				CZP_Player@ pPlayer = ToZPPlayer(i);

				if(pPlayer is null) continue;

				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
				
				if(pBaseEnt.GetTeamNumber() == 3 && pBaseEnt.GetHealth() != pBaseEnt.GetMaxHealth() && g_flHPRDelay[i] <= 0 && pBaseEnt.IsAlive() == true)
				{
					int iRHP = 1;
					if(pPlayer.IsCarrier() == true) iRHP = 5;
					
					int iCurHP = pBaseEnt.GetHealth();
					if(iCurHP < pBaseEnt.GetMaxHealth()) pBaseEnt.SetHealth(iCurHP + iRHP);
				}
			}
		}

		RoundManager.SetCurrentRoundTime(300.f + Globals.GetCurrentTime());
	}
}

void OnNewRound()
{
	if(bIsCSZM == true)
	{
		bAllowCD = false;
		bIsFirstITurns = false;
		bAZSProgress = false;
		bAllowZS = false;
		bAllowZMIdleSND = false;
		bAllowZMSlowD = false;
		bAllowFZColor = false;
		bETimeHP = false;
		iFZTurningTime = 0;
		iFZIndex = 0;
		iTimeHPBonus = 0;
		iTimeHPBonusSeconds = iDefaultTHPSeconds;
		iSAt = 0;
		
		flIdleTimer = Globals.GetCurrentTime() + 0.10f;
		flSloDTimer = Globals.GetCurrentTime() + 0.01f;
		flHPRegenTime = Globals.GetCurrentTime() + 0.15f;
		flSloDRecoreTime = Globals.GetCurrentTime() + flBaseRecoverTime;
		
		ShowRTL(0, 0, 300);
		
		for ( int i = 1; i <= iMaxPlayers; i++ ) 
		{
			g_iArmor[i] = 0;
			g_flSDTime[i] = 0.0f;
			g_flSDMulti[i] = 0.0f;
			g_iZMDeathCount[i] = -1;
			g_flHPRDelay[i] = 0.00f;
				
			g_bIsFirstInfected[i] = false;
			g_bIsVolunteer[i] = false;
			g_bIsAbuser[i] = false;
		}
	}
}

void OnMatchStarting()
{
	if(bIsCSZM == true)
	{
		bAllowZS = false;
		pSoloMode.SetValue("1");
		ShowRTL(0, 0, 15);
	}
}

void OnMatchBegin() 
{
	if(bIsCSZM == true)
	{
		Schedule::Task(0.50f, "LocknLoad");
		Schedule::Task((iGearUpTime - 5.00f), "FirstInfectedHP");
		
		ComparePlr();
		if(iWUSeconds == 0)
		{
			PutPlrToLobby(null);
			SetDoorFilter(1);
			iWUSeconds = iWUTime;
		}
	}
}

void LocknLoad()
{
	if(bAllowCD != true) bAllowCD = true;
	
	iSeconds = iRoundTime;
	
	RoundManager.SetRounds(10);
	RoundManager.SetCurrentRoundTime(2700);

	RoundTimeLeft();
	Engine.EmitSound("CS_MatchBeginRadio");
	
	Globals.SetPlayerRespawnDelay(true, flSpawnDelay);
	
	ShowChatMsg(strRoundBegun, 2);
}

void OnMatchEnded() 
{
	if(bIsCSZM == true)
	{
		pSoloMode.SetValue("0");
		bAllowZS = false;
	}
}

void FirstInfectedHP()
{
	int iSurvCount = Utils.GetNumPlayers(survivor, true);
	if(iSurvCount < 4) iSurvCount = 4;
	iFirstInfectedHP = iFirstInfectedHPMult * iSurvCount;
}

void ComparePlr()
{
	int iPlrWasFZ = 0;
	int iPlr = 0;
	
	for( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if(pPlayer is null) continue;
		
		iPlr++;
		if(g_bWasFirstInfected[i] == true) iPlrWasFZ++;
	}
	
	if(iPlrWasFZ >= iPlr)
	{
		for(int i = 1; i <= iMaxPlayers; i++ )
		{
			g_bWasFirstInfected[i] = false;
		}
	}
}

HookReturnCode OnPlayerConnected(CZP_Player@ pPlayer) 
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		g_flIdleTime[pBaseEnt.entindex()] = Math::RandomFloat(1.7f, 7.4f);
		g_flSDTime[pBaseEnt.entindex()] = 0.0f;
		g_flSDMulti[pBaseEnt.entindex()] = 0.0f;
		g_iInfectDelay[pBaseEnt.entindex()] = 0;
		g_iArmor[pBaseEnt.entindex()] = 0;
		g_iZMDeathCount[pBaseEnt.entindex()] = -1;
		g_flHPRDelay[pBaseEnt.entindex()] = 0.00f;
		g_iCVSIndex[pBaseEnt.entindex()] = Math::RandomInt(1, 3);
			
		g_bWasFirstInfected[pBaseEnt.entindex()] = false;
		g_bIsFirstInfected[pBaseEnt.entindex()] = false;
		g_bIsAbuser[pBaseEnt.entindex()] = false;
		g_bIsVolunteer[pBaseEnt.entindex()] = false;
		g_bIsSpawned[pBaseEnt.entindex()] = false;

		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnConCommand(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	if(bIsCSZM == true)
	{
		if(Utils.StrEql("choose2", pArgs.Arg(0)))
		{
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if(pBaseEnt.GetTeamNumber() == 0)
			{
				if(g_iInfectDelay[pBaseEnt.entindex()] > 0)
				{
					Chat.PrintToChatPlayer(pPlrEnt, strCannotPlayFI);
				}
				else
				{
					Chat.PrintToChatPlayer(pPlrEnt, strChooseToPlayFI);
					if(g_bIsVolunteer[pBaseEnt.entindex()] != true) g_bIsVolunteer[pBaseEnt.entindex()] = true;
				}
			}
			
			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerSpawn(CZP_Player@ pPlayer)
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		int iIndex = pBaseEnt.entindex();
		
		Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Mute");
		
		if(pBaseEnt.GetTeamNumber() == 0)
		{
			pBaseEnt.SetModel("models/cszm/lobby_guy.mdl");
			pPlayer.SetVoice(eugene);
			if(bAllowWarmUp == false) lobby_hint(pPlayer);
		}
		
		if(pBaseEnt.GetTeamNumber() == 1 && bAllowWarmUp == false) spec_hint(pPlayer);
		
		if(bAllowWarmUp == false)
		{
			if(g_bIsFirstInfected[iIndex] == true) g_bIsFirstInfected[iIndex] = false;
		
			if(pBaseEnt.GetTeamNumber() != 3 && g_iZMDeathCount[iIndex] < 0) g_iZMDeathCount[iIndex] = -1;
			
			if(pBaseEnt.GetTeamNumber() == 2)
			{
				if(g_iArmor[iIndex] > 0) g_iArmor[iIndex] = 0;
				if(g_iInfectDelay[iIndex] > 0) g_iInfectDelay[iIndex]--;
				return HOOK_HANDLED;
			}
			
			if(pBaseEnt.GetTeamNumber() == 3 && bAllowZS == false)
			{				
				Chat.PrintToChatPlayer(pBaseEnt, strCannotJoinZT0);
				MovePlrToSpec(pBaseEnt);
					
				return HOOK_HANDLED;
			}
			
			if(pBaseEnt.GetTeamNumber() == 3 && bAZSProgress == false && g_bIsAbuser[iIndex] == true)
			{
				Chat.PrintToChatPlayer(pBaseEnt, strCannotJoinZT1);
				MovePlrToSpec(pBaseEnt);
					
				return HOOK_HANDLED;
			}
			
			if(pBaseEnt.GetTeamNumber() == 3 && bAllowZS != false)
			{
				if(g_flSDMulti[iIndex] != 0) g_flSDMulti[iIndex] = 0.0f;
				if(g_flSDTime[iIndex] != 0) g_flSDTime[iIndex] = 0.0f;
				g_flIdleTime[iIndex] = 0.1f;
				
				RndZModel(pPlayer, pBaseEnt);
				SetZMHealth(pBaseEnt);
				
				return HOOK_HANDLED;
			}
		}
		else
		{
			if(g_bIsSpawned[iIndex] == true) pBaseEnt.ChangeTeam(1);
			else Schedule::Task(0.00f, "MakeThemSpec");
			if(pPlrEnt.IsBot() == true) pBaseEnt.ChangeTeam(1);	//Delete me
			if(CountPlrs(0) <= 2 || CountPlrs(1) <= 2)
			{
				if(iWUSeconds == iWUTime) Schedule::Task(0.00f, "WarmUpTimer");
			}
			PutPlrToPlayZone(pBaseEnt);
			pBaseEnt.SetModel("models/cszm/lobby_guy.mdl");
			pPlayer.SetVoice(eugene);
			
			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	if(bIsCSZM == true)
	{
		const float flDamage = DamageInfo.GetDamage();
		float flDivisor = 1.0f;
		float flLocalSDMult = 0.0f;
		float flLocalSDTime = 0.0f;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		int iIndex = pBaseEnt.entindex();
		int iDamageType = DamageInfo.GetDamageType();
		int iTeamNum = pBaseEnt.GetTeamNumber();
		
		bool bIsFall = false;
		
		if(iTeamNum == 2 && iDamageType == 8196 && flDamage > 20)
		{
			if(g_iArmor[iIndex] > 2) g_iArmor[iIndex] = 1;
			
			if(g_iArmor[iIndex] > 0)
			{
				g_iArmor[iIndex]--;
				return HOOK_HANDLED;
			}
			else if(g_iArmor[iIndex] <= 0)
			{
				CZP_Player@ pAttacker = ToZPPlayer(DamageInfo.GetAttacker());
				CBasePlayer@ pBasePlrA = pAttacker.opCast();
				CBaseEntity@ pBaseEntA = pBasePlrA.opCast();
				

				GotVictim(pAttacker, pBaseEntA);
				TurnToZ(iIndex);
			}
			
			return HOOK_HANDLED;
		}
		
		if(iTeamNum == 3) g_flHPRDelay[iIndex] = flHPRDelay;
		
		if(iTeamNum == 3 && pBaseEnt.IsAlive() == true)
		{
			if(pPlayer.IsCarrier() != true)
			{
				g_flIdleTime[iIndex] += 0.82f;
				Engine.EmitSoundEntity(pBaseEnt, "CSPlayer_Z.Pain" + g_iCVSIndex[iIndex]);
			}

			if(pPlayer.IsCarrier() == true) flDivisor = flCSDDivider;
			if(g_bIsFirstInfected[iIndex] == true) flDivisor = flFISDDivider;
				
			switch(iDamageType)
			{
				case 536879106:	//Buckshot DT
					flLocalSDMult += flSDMultSG / flDivisor;
					flLocalSDTime = flSDTimeSG;
				break;
					
				case 64:		//Blast DT
					flLocalSDMult += flSDMultEXP / flDivisor;
					flLocalSDTime = flSDTimeEXP;
				break;
					
				case 134217792:	//Explosive Barrels DT
					flLocalSDMult += flSDMultEXP / flDivisor;
					flLocalSDTime = flSDTimeEXP;
				break;
					
				case 8320:		//Melee DT
					flLocalSDMult += flSDMultMEL / flDivisor;
					flLocalSDTime = flSDTimeMEL;
				break;
				
				case 8194:		//Revolver and Rifles DT
					if(flDamage > 79)
					{
						flLocalSDMult += flSDMultMAG / flDivisor;
						flLocalSDTime = flSDTimeMAG;
					}
					else
					{
						flLocalSDMult += flSDMult / flDivisor;
					}
				break;
				
				case 32:
					flLocalSDMult += flSDMultFALL;
					flLocalSDTime = flSDTimeFALL;
					bIsFall = true;
				break;
					
				default:		//Any other DT
					flLocalSDMult += flSDMult / flDivisor;
				break;
			}
				
				if(pBaseEnt.IsGrounded() == true || bIsFall == true)
				{
					g_flSDMulti[iIndex] += flLocalSDMult;
					
					if(g_flSDTime[iIndex] < flLocalSDTime) g_flSDTime[iIndex] = flLocalSDTime;
					
					if(g_flSDTime[iIndex] < flSDTime) g_flSDTime[iIndex] = flSDTime;
					
					if(g_flSDMulti[iIndex] > flMaxSDMult) g_flSDMulti[iIndex] = flMaxSDMult;
				}
				
			}
			
		return HOOK_HANDLED;
		}
		
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerInfected(CZP_Player@ pPlayer, InfectionState iState)
{
	if(iState != state_none) pPlayer.SetInfection(false, 1.0f);

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerKilled(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo) 
{
	if(bIsCSZM == true)
	{
		CZP_Player@ pPlrAttacker = null;
	
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		const int iVicIndex = pBaseEnt.entindex();
		const int iVicTeam = pBaseEnt.GetTeamNumber();
		
		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
		
		const int iAttIndex = pEntityAttacker.entindex();
		const int iAttTeam = pEntityAttacker.GetTeamNumber();
		
		if(pEntityAttacker.IsPlayer() == true) @pPlrAttacker = ToZPPlayer(iAttIndex);

		if(g_bIsFirstInfected[iVicIndex] == true)
		{
			pBaseEnt.SetEntityName("");
			Engine.Ent_Fire("FI-DLight", "kill");
		}

		if(g_bIsVolunteer[iVicIndex] == true) g_bIsVolunteer[iVicIndex] = false;
		
		if(iVicTeam == 3 && pPlayer.IsCarrier() != true)
		{
			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer_Z.Die" + g_iCVSIndex[iVicIndex]);
			g_flSDTime[iVicIndex] = 0.0f;
			g_flSDMulti[iVicIndex] = 0.0f;
		}
		
		else
		{
			if(iVicTeam == 3)
			{
				pBaseEnt.ChangeTeam(2);
				Schedule::Task(0.0f, "MovePlrToZombieTeam");	
			}
//			pPlayer.AddScore(-5, null);
			return HOOK_HANDLED;
		}

		if(iVicIndex == iAttIndex)
		{
			if(iVicTeam == 3)
			{
				pBaseEnt.ChangeTeam(2);
				Schedule::Task(0.0f, "MovePlrToZombieTeam");	
			}
//			pPlayer.AddScore(-5, null);
			return HOOK_HANDLED;
		}
		
		if(iVicTeam == 3)
		{
			if(g_iZMDeathCount[iAttIndex] < iMaxDeath && g_bIsFirstInfected[iVicIndex] == false) g_iZMDeathCount[iVicIndex]++;
			
			pBaseEnt.ChangeTeam(2);
			Schedule::Task(0.0f, "MovePlrToZombieTeam");
		}
		
		if(iVicTeam == 2 && iAttTeam == 3) GotVictim(pPlrAttacker, pEntityAttacker);
	}

	return HOOK_CONTINUE;
}

void GotVictim(CZP_Player@ pAttacker, CBaseEntity@ pBaseEntA)
{
	if(g_iZMDeathCount[pBaseEntA.entindex()] >= 0) g_iZMDeathCount[pBaseEntA.entindex()] -= iSubtractDeath;
	
	if(bAllowDebug == true) SD("g_iZMDeathCount: " + g_iZMDeathCount[pBaseEntA.entindex()]);
		
	if(pBaseEntA.IsAlive() == true) pBaseEntA.SetHealth(pBaseEntA.GetHealth() + iHPReward);
	
	pAttacker.AddScore(5, null);

	AddTime(iInfectionATSec);
}

void MovePlrToZombieTeam()
{
	for( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if(pPlayer is null) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if(pBaseEnt.GetTeamNumber() == 2 && pBaseEnt.IsAlive() == false) pBaseEnt.ChangeTeam(3);
	}
}

HookReturnCode OnPlayerDisonnected(CZP_Player@ pPlayer)
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if(g_bIsFirstInfected[pBaseEnt.entindex()] == true) 
		{
			g_bIsFirstInfected[pBaseEnt.entindex()] = false;
			Engine.Ent_Fire("FI-DLight", "kill");
		}

		if(iFZIndex == pBaseEnt.entindex()) iFZIndex = 0;
		
		if(pBaseEnt.GetTeamNumber() == 3 && Utils.GetNumPlayers(zombie, false) <= 1)
		{
			Engine.EmitSound("common/warning.wav");
			RoundManager.SetWinState(STATE_STALEMATE);
			SD(strLastZLeave);
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if(bIsCSZM == true)
	{
		if(strClassname == "npc_grenade_frag")
		{
			iUNum++;
			pEntity.SetEntityName("frag-grenade"+iUNum);

			CEntityData@ SPRTrailIPD = EntityCreator::EntityData();
			SPRTrailIPD.Add("targetname", "frag-grenade-trail"+iUNum);
			SPRTrailIPD.Add("lifetime", "0.25");
			SPRTrailIPD.Add("renderamt", "255");
			SPRTrailIPD.Add("rendercolor", "245 16 16");
			SPRTrailIPD.Add("rendermode", "5");
			SPRTrailIPD.Add("spritename", "sprites/lgtning.vmt");
			SPRTrailIPD.Add("startwidth", "3.85");

			CEntityData@ SpriteIPD = EntityCreator::EntityData();
			SpriteIPD.Add("targetname", "frag-grenade-sprite"+iUNum);

			SpriteIPD.Add("spawnflags", "1");
			SpriteIPD.Add("GlowProxySize", "4");
			SpriteIPD.Add("scale", "0.35");
			SpriteIPD.Add("rendermode", "9");
			SpriteIPD.Add("rendercolor", "245 16 16");
			SpriteIPD.Add("renderamt", "255");
			SpriteIPD.Add("model", "sprites/light_glow01.vmt");
			SpriteIPD.Add("renderfx", "0");

			CEntityData@ DLightIPD = EntityCreator::EntityData();
			DLightIPD.Add("targetname", "frag-grenade-dlight"+iUNum);

			DLightIPD.Add("_cone", "0");
			DLightIPD.Add("_inner_cone", "0");
			DLightIPD.Add("pitch", "0");
			DLightIPD.Add("spawnflags", "0");
			DLightIPD.Add("spotlight_radius", "0");
			DLightIPD.Add("style", "0");
			DLightIPD.Add("_light", "245 8 8 200");
			DLightIPD.Add("brightness", "4");
			DLightIPD.Add("distance", "48");

			EntityCreator::Create("env_spritetrail", pEntity.GetAbsOrigin(), QAngle(0, 0, 0), SPRTrailIPD);
			EntityCreator::Create("env_sprite", pEntity.GetAbsOrigin(), QAngle(0, 0, 0), SpriteIPD);
			EntityCreator::Create("light_dynamic", pEntity.GetAbsOrigin(), QAngle(0, 0, 0), DLightIPD);

			ParentTrail(iUNum, pEntity);
		}
	}

	return HOOK_CONTINUE;
}

void ParentTrail(const int &in iNum, CBaseEntity@ pEntity)
{
	CBaseEntity@ pEntTrail = null;
	CBaseEntity@ pEntSprite = null;
	CBaseEntity@ pDLight = null;

	@pEntTrail = FindEntityByName(pEntTrail, "frag-grenade-trail"+iNum);
	@pEntSprite = FindEntityByName(pEntSprite, "frag-grenade-sprite"+iNum);
	@pDLight = FindEntityByName(pDLight, "frag-grenade-dlight"+iNum);

	if(pEntTrail !is null && pEntSprite !is null && pDLight !is null)
	{
		pEntTrail.SetParent(pEntity);
		pEntSprite.SetParent(pEntity);
		pDLight.SetParent(pEntity);
	}
}

HookReturnCode RoundWin(const string &in strMapname, RoundWinState iWinState)
{
	if(bIsCSZM == true)
	{
		bAllowCD = false;
		ShowRTL(0, 0, 15);

		if(iWinState == STATE_HUMAN) Engine.EmitSound("CS_HumanWin");
		if(iWinState == STATE_ZOMBIE) Engine.EmitSound("CS_ZombieWin");

		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

void RoundTimeLeft()
{
	if(Utils.GetNumPlayers(survivor, false) == 0) RoundManager.SetWinState(STATE_STALEMATE);
	
	if(bAllowCD == true)
	{
		TimeHPBonus();
		
		float fShowHour = floor(iSeconds / 3600);
		float fShowMin = floor((iSeconds - fShowHour * 3600) / 60);
		float fShowSec = floor(iSeconds - (fShowHour * 3600) - (fShowMin * 60));

		ShowRTL(fShowMin, fShowSec, 0);
		Schedule::Task(1.00f, "RoundTimeLeft");
		
		if(iSeconds <= iSoT && bIsFirstITurns != true)
		{
			if(bAllowFZColor == false) 
			{
				bAllowFZColor = true;
				iSAt = iSeconds - iTurningTime;
			}
			iFZTurningTime = (iSAt - iSeconds) * - 1;
			FZColor();
			Schedule::Task(0.0f, "FirstInfected");	//Fix Me
//			FirstInfected();
			if(iFZTurningTime <= 10 && iFZTurningTime > 0) EmitCountdownSound(iFZTurningTime);
		}
		
		if(iSeconds == 0)
		{
			bAllowCD = false;
			Schedule::Task(1.00f, "TimesUp");
		}	
		
		iSeconds--;
	}
}

void TimeHPBonus()
{
	if(bAllowTimeHP == true && bETimeHP == true)
	{
		iTimeHPBonusSeconds--;
		
		if(iTimeHPBonusSeconds <=0)
		{
			iTimeHPBonusSeconds = iDefaultTHPSeconds;
			iTimeHPBonus += iTHPBonus;

			SD("{Default}Time Health Bonus: {cyan}"+iTimeHPBonus+" HP");
		}
	}
}

void ShowRTL(float &in fShowMin, float &in fShowSec, float &in flHoldTime)
{
	string SZero = "0";
	string MZero = "0";
	
	if(fShowMin <= 9) MZero = "0";
	else MZero = "";
	
	if(fShowSec <= 9) SZero = "0";
	else SZero = "";

	string TimerText = MZero + fShowMin + ":" + SZero + fShowSec;

	if(flHoldTime <= 0) flHoldTime = 1.15;
	
	SendGameText(any, "| " + TimerText + " |", 0, 1, -1, 0, 0, 0, flHoldTime, Color(235, 235, 235), Color(0, 0, 0));
}

void TimesUp()
{
	if(iSeconds > 0)
	{
		bAllowCD = true;
		RoundTimeLeft();
	}
	else if(Utils.GetNumPlayers(survivor, true) > 0) RoundManager.SetWinState(STATE_HUMAN);
}

void AddTime(const int &in iTime)
{
	int iOverTimeMult = 1;
	
	if(iSeconds <= 0) iOverTimeMult = 3;
	
	if(iSeconds < 41 && iTime > 0 && bAllowAddTime == true)
	{
		iSeconds += (iTime * iOverTimeMult);
		
		float fShowHour = floor(iSeconds / 3600);
		float fShowMin = floor((iSeconds - fShowHour * 3600) / 60);
		float fShowSec = floor(iSeconds - (fShowHour * 3600) - (fShowMin * 60));
		
		ShowRTL(fShowMin, fShowSec + 1, 0);
		
		SendGameText(any, "\n+ "+(iTime * iOverTimeMult)+" Seconds", 1, 1, -1, 0.0025f, 0, 0.35f, 1.75f, Color(255, 175, 85), Color(0, 0, 0));
	}
}

void FZColor()
{
	if(bAllowFZColor == true && bIsFirstITurns != true)
	{
		Schedule::Task(0.05f, "FirstInfected");
		Schedule::Task(0.05f, "FZColor");
	}
}

void FirstInfected()
{
	if(iFZTurningTime > 0)
	{
		if(iFZIndex != 0)
		{	
			CZP_Player@ pPlayer = ToZPPlayer(iFZIndex);
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if(pBaseEnt.IsAlive() == true && pBaseEnt.GetTeamNumber() == 2)
			{
				string strPTMAddon = strBecomFI;
				string strPreTurnMsg = strPTMAddon + strTurningIn + iFZTurningTime + strSecs;
				if(iFZTurningTime == 1) strPreTurnMsg = strPTMAddon + strTurningIn + iFZTurningTime + strSec;
				
				int iR = Math::RandomInt(0, 128);
				int iG = Math::RandomInt(135, 255);
				int iB = Math::RandomInt(135, 255);
				
				SendGameTextPlayer(pPlayer, strPreTurnMsg, 1, 0, -1, 0.35, 0, 0, 0.075, Color(iR, iG, iB), Color(0, 0, 0));
			}
			else
			{
				iFZIndex = ChooseVolunteer();
				if(iFZIndex == 0) iFZIndex = ChooseFirstInfected();
				FirstInfected();
			}
		}
		else
		{
			iFZIndex = ChooseVolunteer();
			if(iFZIndex == 0) iFZIndex = ChooseFirstInfected();
			FirstInfected();
		}
	}
	else
	{
		Schedule::Task(iDefaultTHPSeconds, "TurnOnTHPBonus");
		TurnToZ(iFZIndex);
		ShowOutbreak(iFZIndex);
	}
}

void TurnOnTHPBonus()
{
	bETimeHP = true;
}

void TurnToZ(const int &in iIndex)
{
	if(iIndex != 0 && iIndex > 0)
	{
		CZP_Player@ pPlayer = ToZPPlayer(iIndex);

		if(pPlayer !is null)
		{
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if(bIsFirstITurns != true)
			{
				pSoloMode.SetValue("0");
				bAllowZS = true;
				bIsFirstITurns = true;
				Engine.EmitSound("CS_FirstTurn");
				g_bWasFirstInfected[iIndex] = true;
				g_bIsFirstInfected[iIndex] = true;
				Schedule::Task(0.1f, "FirstInfDistinctive");
				Schedule::Task(flBlockZSTime, "AllowZSProgress");
				MakeThemAbuser();
			}
			
			EmitBloodExp(pPlayer);

			pPlayer.CompleteInfection();

			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Mute");
			Engine.EmitSoundEntity(pBaseEnt, "Flesh.HeadshotExplode");
			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Turn");

			RndZModel(pPlayer, pBaseEnt);
			SetZMHealth(pBaseEnt);
		}
		else
		{
			GetRandomVictim();
		}
	}
	else
	{
		GetRandomVictim();
	}
}

void FirstInfDistinctive()
{
	CBaseEntity@ pCosMerge = null;

	@pCosMerge = FindEntityByClassname(pCosMerge, "cos_merge");

	if(pCosMerge is null) return;

	pCosMerge.SetEntityName("FirstKnife");

	CBaseEntity@ pParent = null;

	@pParent = pCosMerge.GetParent();

	if(pParent !is null)
	{
		CEntityData@ DLightIPD = EntityCreator::EntityData();
		DLightIPD.Add("targetname", "FI-DLight");

		DLightIPD.Add("_cone", "0");
		DLightIPD.Add("_inner_cone", "0");
		DLightIPD.Add("pitch", "0");
		DLightIPD.Add("spotlight_radius", "0");
		DLightIPD.Add("style", "0");
		DLightIPD.Add("_light", "245 32 16 200");
		DLightIPD.Add("brightness", "8");
		DLightIPD.Add("distance", "20");
		DLightIPD.Add("spawnflags", "1");

		DLightIPD.Add("addoutput", "spawnflags 1", true);

		EntityCreator::Create("light_dynamic", pParent.EyePosition(), QAngle(0, 0, 0), DLightIPD);

		CBaseEntity@ pDlight = FindEntityByName(pDlight, "FI-DLight");

		pDlight.SetParent(pParent);
		pDlight.SetParentAttachment("anim_attachment_RH", false);
	}
}

void EmitBloodExp(CZP_Player@ pPlayer)
{
	if(pPlayer is null) return;

	Utils.ScreenFade(pPlayer, Color(125, 35, 30, 145), 0.375, 0.0, fade_in);

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	CEntityData@ CameraBloodIPD = EntityCreator::EntityData();
	CameraBloodIPD.Add("targetname", "PS-Turn-Head");
	CameraBloodIPD.Add("flag_as_weather", "0");
	CameraBloodIPD.Add("start_active", "1");
	CameraBloodIPD.Add("effect_name", "blood_impact_red_01_headshot");

	CameraBloodIPD.Add("kill", "0", true, "0.01");

	CEntityData@ BodyBloodIPD = EntityCreator::EntityData();
	BodyBloodIPD.Add("targetname", "PS-Turn");
	BodyBloodIPD.Add("flag_as_weather", "0");
	BodyBloodIPD.Add("start_active", "1");
	BodyBloodIPD.Add("effect_name", "blood_explode_01");

	BodyBloodIPD.Add("kill", "0", true, "0.01");

	EntityCreator::Create("info_particle_system", pBaseEnt.EyePosition(), pBaseEnt.EyeAngles(), CameraBloodIPD);
	EntityCreator::Create("info_particle_system", pBaseEnt.GetAbsOrigin(), pBaseEnt.GetAbsAngles(), BodyBloodIPD);
	Engine.EmitSoundEntity(pBaseEnt, "Flesh.HeadshotExplode");
}

void GetRandomVictim()
{
	CZP_Player@ pVictim = GetRandomPlayer(survivor, true);
	CBasePlayer@ pVPlrEnt = pVictim.opCast();
	CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();
	TurnToZ(pVBaseEnt.entindex());
}

void AllowZSProgress()
{
	bAZSProgress = true;
}

void RndZModel(CZP_Player@ pPlayer, CBaseEntity@ pEntPlr)
{
	Utils.CosmeticWear(pPlayer, "models/cszm/weapons/w_knife_t.mdl");
	
	int iRND_CVS = Math::RandomInt(1, 3);
	
	if(iRND_CVS_PV == iRND_CVS)
	{
		for(int i = 1; iRND_CVS_PV == iRND_CVS; i++)
		{
			iRND_CVS = Math::RandomInt(1, 3);
		}
	}

	g_iCVSIndex[pEntPlr.entindex()] = iRND_CVS;
	
	iRND_CVS_PV = iRND_CVS;
	
	if(g_bIsFirstInfected[pEntPlr.entindex()] == true) pEntPlr.SetModel(g_strModels[6]);
	else 
	{	
		uint iMCount = 0;
		for(uint i = 0; i <= g_strModels.length() - 1; i++)
		{
			if(g_bAModels[i] == false) iMCount++;
		}
		
		if(iMCount == g_strModels.length() - 1)
		{
			iMCount = 0;
			
			for(uint i = 0; i <= g_strModels.length() - 1; i++)
			{
				if(g_bAModels[i] == false) g_bAModels[i] = true;
			}
		}
		
		int iRND_MDL = 0;
		
		for(int i = 0; iRND_MDL == 0; i++)
		{
			iRND_MDL = Math::RandomInt(1, g_strModels.length() - 1);
			if(g_bAModels[iRND_MDL] == false) iRND_MDL = 0;
			else g_bAModels[iRND_MDL] = false;
		}
		
		if(pPlayer.IsCarrier() == true) pEntPlr.SetModel(g_strModels[0]);
		else pEntPlr.SetModel(g_strModels[iRND_MDL]);
	}
}

void SetZMHealth(CBaseEntity@ pEntPlr)
{
	int iZombCount = Utils.GetNumPlayers(zombie, false);
	float flMultiplier = 0.5;
	switch(iZombCount)
	{
		case 1:
			flMultiplier = 1.75f;
		break;
		
		case 2:
			flMultiplier = 0.75f;
		break;
		
		default:
			flMultiplier = 0.5;
		break;
	}

	if(bAllowDebug == true) SD("g_iZMDeathCount: " + g_iZMDeathCount[pEntPlr.entindex()]);
	
	if(g_iZMDeathCount[pEntPlr.entindex()] < 0 ) g_iZMDeathCount[pEntPlr.entindex()] = 0;
	
	int iHPBonus = g_iZMDeathCount[pEntPlr.entindex()] * iDHPBonus;
	
	CZP_Player@ pPlayer = ToZPPlayer(pEntPlr);
	
	if(pPlayer.IsCarrier() == false)
	{
		if(g_bIsFirstInfected[pEntPlr.entindex()] == true)
		{
			pEntPlr.SetMaxHealth(iFirstInfectedHP / 3);
			pEntPlr.SetHealth(iFirstInfectedHP);
		}
		else
		{
			pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + iTimeHPBonus + iZombieMaxHP + iHPBonus);
			pEntPlr.SetHealth(pEntPlr.GetHealth() + iTimeHPBonus + (iZombieMaxHP / 4) + iHPBonus);
		}
	}
	else
	{
		pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + iTimeHPBonus + int(float(iCarrierMaxHP) + (float(iHPBonus) * flMultiplier)));
		pEntPlr.SetHealth(pEntPlr.GetHealth() + iTimeHPBonus + int(float(iCarrierMaxHP) + (float(iHPBonus) * flMultiplier)));
	}
}

void ShowOutbreak(int &in iIndex)
{
	CZP_Player@ pFirstInf = ToZPPlayer(iIndex);
	string strColor = "blue";
	if(g_bIsVolunteer[iIndex] == true) strColor = "violet";
	
	for(int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if(pPlayer is null) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if(i != iIndex) Chat.PrintToChatPlayer(pPlrEnt, "{" + strColor + "}" + pFirstInf.GetPlayerName() + strBecameFi);
	}

	SendGameText(any, strOutbreakMsg, 1, 0, -1, 0.175, 0, 0.35, 6.75, Color(64, 255, 128), Color(0, 255, 0));
	
	iFZIndex = 0;
}

int ChooseVolunteer()
{
	int iCount = 0;
	int iVolunteerIndex = 0;
	int iRND;
	
	array<CBaseEntity@> g_pVolunteer = {null};
	
	for(int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if(pPlayer is null) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		if(g_bIsVolunteer[i] == true && pBaseEnt.GetTeamNumber() == 2 && pBaseEnt.IsAlive() == true)
		{
			iCount++;
			g_pVolunteer.insertLast(pBaseEnt);
		}
	}
	
	if(iCount != 0)
	{
		int iLength = g_pVolunteer.length() - 1;
		if(iLength <= 1) iVolunteerIndex = g_pVolunteer[1].entindex();
		else iVolunteerIndex = g_pVolunteer[Math::RandomInt(1, iLength)].entindex();
		g_iInfectDelay[iVolunteerIndex] += iInfectDelay;
	}
	
	return iVolunteerIndex;
}

int ChooseFirstInfected()
{
	int iCount = 0;
	int iChoosenIndex = 0;
	int iRND;
	
	array<CBaseEntity@> g_pVictim = {null};
	
	for(int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if(pPlayer is null) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		if(g_bWasFirstInfected[i] == false && pBaseEnt.IsAlive() == true && g_iInfectDelay[i] < 2)
		{
			iCount++;
			g_pVictim.insertLast(pBaseEnt);
		}
	}
	
	if(iCount != 0)
	{
		int iLength = g_pVictim.length() - 1;
		if(iLength > 1)iChoosenIndex = g_pVictim[Math::RandomInt(1, iLength)].entindex();
		else iChoosenIndex = g_pVictim[1].entindex();
		g_iInfectDelay[iChoosenIndex] += 1;
	}

	if(iCount == 0)
	{
		CZP_Player@ pVictim = GetRandomPlayer(survivor, true);
		CBasePlayer@ pVPlrEnt = pVictim.opCast();
		CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();
		iChoosenIndex = pVBaseEnt.entindex();
	}
	
	return iChoosenIndex;
}

void MovePlrToSpec(CBaseEntity@ pEntPlr)
{
	//Usually a "trigger_joinspectatorteam" hasn't an origin coordinates (it's equal "0 0 0" by default)
	//and you cannot get correct coordinates with a ".GetAbsOrigin()" func...
	//so, this solution won't work for every single map, keep it in mind.
	CBaseEntity@ pSpecTrigger = FindEntityByClassname(pSpecTrigger, "trigger_joinspectatorteam");
	pEntPlr.ChangeTeam(0);
	pEntPlr.SetAbsOrigin(pSpecTrigger.GetAbsOrigin());
	CBasePlayer@ pPlayer = ToBasePlayer(pEntPlr.entindex());
}

//WarmUp Related Funcs
void WarmUpTimer()
{
	int iNumPlrs = 0;
	iNumPlrs += CountPlrs(1);
	iNumPlrs += CountPlrs(0);

	if(bAllowWarmUp == true && iNumPlrs >= 2)
	{
		iWUSeconds--;

		string TimerText = "\n\n\n"+strWarmUp+"\n| "+iWUSeconds+" |";
		SendGameText(any, TimerText, 1, 0.00f, -1, 0.00f, 0.00f, 0.00f, 1.10f, Color(255, 175, 85), Color(255, 95, 5));
		Schedule::Task(1.00f, "WarmUpTimer");

		if(iWUSeconds == 0)
		{
			bAllowWarmUp = false;
			Schedule::Task(1, "WarmUpEnd");
		}
	}
	else if (iNumPlrs <= 1)
	{
		iWUSeconds = iWUTime;
		SendGameText(any, strAMP, 1, 0.00f, -1, 0.00f, 0.00f, 0.00f, 600.00f, Color(255, 255, 255), Color(255, 95, 5));
	}
}

void WarmUpEnd()
{
	if(bAllowWarmUp == true) bAllowWarmUp = false;
	
	Engine.EmitSound("@buttons/button3.wav");
	
	SendGameText(any, "", 1, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, Color(0, 0, 0), Color(0, 0, 0));
	
	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
	
		if(pPlayer is null) continue;
			
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if(pBaseEnt.GetTeamNumber() == 1)
		{
			lobby_hint(pPlayer);
			pBaseEnt.ChangeTeam(0);
		}
	}	
}

int CountPlrs(const int &in iTeamNum)
{
	int iCount = 0;
	
	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
	
		if(pPlayer is null) continue;
			
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if(pBaseEnt.GetTeamNumber() == iTeamNum)
		{
			iCount++;
		}
	}
	
	return iCount;
}

void lobby_hint(CZP_Player@ pPlayer)
{
	SendGameTextPlayer(pPlayer, strHintF1, 3, 0.00f, 0.05f, 0.10f, 0.00f, 2.00f, 120.00f, Color(64, 128, 255), Color(255, 95, 5));
	SendGameTextPlayer(pPlayer, "\n\n" + strHintF3, 4, 0.00f, 0.05f, 0.085f, 0.00f, 2.00f, 120.00f, Color(255, 255, 255), Color(255, 95, 5));
}

void spec_hint(CZP_Player@ pPlayer)
{
	SendGameTextPlayer(pPlayer, strHintF4, 3, 0.00f, 0.05f, 0.10f, 0.00f, 2.00f, 15.00f, Color(64, 255, 128), Color(255, 95, 5));
}

void MakeThemSpec()
{
	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
	
		if(pPlayer is null)
		{
			g_bIsSpawned[i] = false;
			continue;
		}
			
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if(pBaseEnt.GetTeamNumber() == 0 && g_bIsSpawned[i] == false)
		{
			g_bIsSpawned[i] = true;
			pBaseEnt.ChangeTeam(1);
		}
	}
}

void MakeThemAbuser()
{
	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
	
		if(pPlayer is null) continue;
			
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if(pBaseEnt.GetTeamNumber() == 0 || pBaseEnt.GetTeamNumber() == 1) g_bIsAbuser[i] = true;
	}
}

void PutPlrToLobby(CBaseEntity@ pEntPlayer)
{
	array<CBaseEntity@> g_pLobbySpawn = {null};
	CBaseEntity@ pEntity;
	
	while((@pEntity = FindEntityByClassname(pEntity, "info_player_commons")) !is null)
	{
		g_pLobbySpawn.insertLast(pEntity);
	}

	int iLength = g_pLobbySpawn.length() - 1;
	
	if(pEntPlayer is null)
	{
		for(int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);
			
			if(pPlayer is null) continue;
			
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if(pBaseEnt.GetTeamNumber() == 1 || pBaseEnt.GetTeamNumber() == 0)
			{
				pBaseEnt.SetAbsOrigin(g_pLobbySpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
			}
		}
	}
	else
	{
		pEntPlayer.SetAbsOrigin(g_pLobbySpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
	}
}

void PutPlrToPlayZone(CBaseEntity@ pEntPlayer)
{
	array<CBaseEntity@> g_pOtherSpawn = {null};
	CBaseEntity@ pEntity;
	
	while((@pEntity = FindEntityByClassname(pEntity, "info_player_human")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}
	
	while((@pEntity = FindEntityByClassname(pEntity, "info_player_zombie")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}
	
	while((@pEntity = FindEntityByClassname(pEntity, "info_player_start")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}

	int iLength = g_pOtherSpawn.length() - 1;
	
	if(pEntPlayer is null)
	{
		for(int i = 1; i <= iMaxPlayers; i++)
		{
			CZP_Player@ pPlayer = ToZPPlayer(i);
			
			if(pPlayer is null) continue;
			
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if(pBaseEnt.GetTeamNumber() == 1 || pBaseEnt.GetTeamNumber() == 0)
			{
				pBaseEnt.SetAbsOrigin(g_pOtherSpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
			}
		}
	}
	else
	{
		pEntPlayer.SetAbsOrigin(g_pOtherSpawn[Math::RandomInt(1, iLength)].GetAbsOrigin());
	}
}

void SetDoorFilter(const int &in iFilter)
{
	CBaseEntity@ pEntity;
	while((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "AddOutput", "doorfilter " + iFilter);
	}
}