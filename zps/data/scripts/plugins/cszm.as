/*
///////////////////////////////////////////////////////////////////
/////////////////| Counter-Strike Zombie Mode  |///////////////////
/////////////////|        Alpha Version        |///////////////////
///////////////////////////////////////////////////////////////////
*/

#include "../SendGameText"

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
bool bAllowWarmUp = true;

//GameText Related Stuff
string strMessage;
int iChannel;
float flxTime;
float flxPos;
float flyPos;
float flFadeIn;
float flFadeOut;
float flHoldTime;

//GamePlay Consts
//Slowdown Multipliers
const float flMaxSDMult = 1.700f;		//Maximum slow down multiplier.
const float flSDMult = 0.027f;			//Any other type of a damage.
const float flSDMultSG = 0.115f;
const float flSDMultEXP = 0.300f;
const float flSDMultMAG = 0.150f;
const float flSDMultMEL = 0.800f;
const float flSDMultFALL = 0.180f;

//Slowdown Time
const float flMaxSDTime = 1.125f;		//Maximum slow down time.
const float flSDTime = 0.125f;			//Any other type of a damage.
const float flSDTimeSG = 0.485f;
const float flSDTimeEXP = 1.025f;
const float flSDTimeMAG = 0.750f;
const float flSDTimeMEL = 1.015f;
const float flSDTimeFALL = 0.505f;

//Other Consts
const float flHPRDelay = 0.42f;			//Amount of time you have to wait to start HP Regeneration. (Custom HP Regeneration)
const float flSpawnDelay = 5.00f;		//Zombies spawn delay.
const int iFirstInfectedHPMult = 125;	//HP multiplier of first infected.
const int iZMMaxHPBoost = 100;			//Additional HP to Max Health of a zombie.
const int iHPReward = 75;				//Give that amount of HP as reward of successful infection.
const int iGearUpTime = 40;				//Time to gear up and find a good spot.
const int iTurningTime = 15;			//Turning time.
const int iInfectDelay = 3;				//Amount of rounds you have to wait to be the First Infected again.
const int iWUTime = 76;					//Time of the warmup in seconds.		(default value is 76)

//New Consts
const float flBlockZSTime = 35.00f;		//Amount of time in seconds which abusers must wait to join the zombie team.
const float flCSDDivider = 8.125f;		//Slowdown divider of the carrier.
const float flFISDDivider = 3.250f;		//Slowdown divider of the first infected.
const int iCMaxHPBoost = 0;				//Additional HP to Max Health of the carrier.	//Currently equal 0 because the carrier is too OP.
const int iDeathHPBonus = 100;			//Multiplier of death hp bonus.
const int iMaxDeath = 9;				//Maximum amount of death to boost up the max health.
const int iRoundTime = 300 + iGearUpTime;	//Round time in seconds.
const int iSoT = iRoundTime - iGearUpTime + iTurningTime;		//Second at which the turning time start countdown. don't touch this.

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
array<float> g_flSDBonus;
array<float> g_flSDMulti;
array<float> g_flHPRDelay;
array<int> g_iInfectDelay;
array<int> g_iZMDeathCount;

array<int> g_iCVSIndex;
array<bool> g_bWasFirstZombie;
array<bool> g_bIsVolunteer;
array<bool> g_bIsSpawned;
array<bool> g_bIsFirstZombie;
array<bool> g_bIsAbuser;

//Other Data (Don't even touch this)
int iFirstInfectedHP;
int iSeconds;
int iSAt;
int iFZTurningTime = 0;
int iFZIndex = 0;
int iRND_CVS_PV;
int iWUSeconds = iWUTime;
float flExtendTime;
float flIdleTimer;
float flSloDTimer;
float flHPRegenTime;
float flCITime;

void OnPluginInit()
{
	//Find 'sv_zps_solo' ConVar
	@pSoloMode = ConVar::Find("sv_zps_solo");
	if(pSoloMode !is null) ConVar::Register(pSoloMode, "ConVar_SoloMode");

	//Events
	Events::Player::OnPlayerConnected.Hook(@OnPlayerConnected);
	Events::Player::OnPlayerSpawn.Hook(@OnPlayerSpawn);
	Events::Entities::OnEntityCreation.Hook(@OnEntityCreation);
	Events::Player::OnPlayerDamaged.Hook(@OnPlayerDamaged);
	Events::Player::OnPlayerKilled.Hook(@OnPlayerKilled);
	Events::Player::OnPlayerDisonnected.Hook(@OnPlayerDisonnected);
	Events::Rounds::RoundWin.Hook(@RoundWin);
	Events::Player::OnPlayerRagdollCreated.Hook(@OnPlayerRagdollCreated);
	Events::Player::PlayerSay.Hook(@PlayerSay);
}

HookReturnCode OnPlayerRagdollCreated(CZP_Player@ pPlayer, bool &in bHeadshot, bool &out bExploded)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	if(Utils.StrContains("cszm", pBaseEnt.GetModelName()))
	{
		bHeadshot = false;
	}
	
	return HOOK_CONTINUE;
}

void OnMapInit()
{
	if(Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		Log.PrintToServerConsole( LOGTYPE_INFO, "CSZM", "[CSZM] Current map is valid for 'Counter-Strike Zombie Mode'" );
		bIsCSZM = true;
		
		//Set 'sv_zps_solo' to 0
		pSoloMode.SetValue("0");
		
		//Boom HeadShot
		Engine.PrecacheFile(sound, ")impacts/flesh_impact_headshot-01.wav");
		
		//ZM First Turn Sound
		Engine.PrecacheFile(sound, "@cszm_fx/misc/suspense.wav");
		
		//ZM WarmUp End Sound
		Engine.PrecacheFile(sound, "@buttons/button3.wav");
		
		//ZM Countdown Sounds
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv10.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv9.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv8.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv7.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv6.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv5.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv4.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv3.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv2.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv1.wav");
		
		//ZM Turn Sounds
		Engine.PrecacheFile(sound, "cszm_fx/player/plr_scream1.wav");
		Engine.PrecacheFile(sound, "cszm_fx/player/plr_scream2.wav");
		
		//ZM Die Sounds
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_die1.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_die2.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_die3.wav");
		
		//ZM Pain Sounds
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain1.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain2.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain3.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain4.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain5.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain6.wav");
		
		//ZM Idle Sounds
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle1.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle2.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle3.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle4.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle5.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle6.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle7.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle8.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle9.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle10.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle11.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle12.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle13.wav");
		Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle14.wav");
		
		//ZM Pain2 Sounds
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_01.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_02.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_03.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_04.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_05.wav");

		//ZM Die2 Sounds
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_01.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_02.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_03.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_04.wav");
		
		//ZM Idle2 Sounds
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_01.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_02.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_03.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_04.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_05.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_06.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_07.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_08.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_09.wav");
		
		//ZM Pain3 Sounds
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain01.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain02.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain03.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain04.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain05.wav");
		
		//ZM Die3 Sounds
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death01.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death02.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death03.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death04.wav");
		
		//ZM Idle3 Sounds
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle03.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle04.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle05.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle06.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle07.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle08.wav");
		Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle09.wav");
		
		//ZM Player Models
		Engine.PrecacheFile(model, "models/cszm/carrier.mdl");
		Engine.PrecacheFile(model, "models/cszm/zombie_classic.mdl");
		Engine.PrecacheFile(model, "models/cszm/zombie_sci.mdl");
		Engine.PrecacheFile(model, "models/cszm/zombie_corpse1.mdl");
		Engine.PrecacheFile(model, "models/cszm/zombie_charple.mdl");
		Engine.PrecacheFile(model, "models/cszm/zombie_charple2.mdl");
		Engine.PrecacheFile(model, "models/cszm/zombie_sawyer.mdl");
		Engine.PrecacheFile(model, "models/cszm/zombie_eugene.mdl");
		
		//ZM Lobby Guy Model
		Engine.PrecacheFile(model, "models/cszm/lobby_guy.mdl");
		
		//ZM Knife Model
		Engine.PrecacheFile(model, "models/cszm/weapons/w_knife_t.mdl");
		
		//ZM Radio Sounds
		Engine.PrecacheFile(sound, "@cszm_fx/radio/gogogo.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/radio/moveout.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/radio/letsgo.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/radio/locknload.wav");
		
		//ZM Win Sounds
		Engine.PrecacheFile(sound, "@cszm_fx/misc/hwin.wav");
		Engine.PrecacheFile(sound, "@cszm_fx/misc/zwin.wav");
		
		//ZM Weapon Impact Sounds	
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard1.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard2.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard3.wav");		
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft1.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft2.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft3.wav");	
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard1.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard2.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard3.wav");	
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft1.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft2.wav");
		Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft3.wav");
		
		//COMMA
		Engine.PrecacheFile(sound, "npc/combine_soldier/vo/_comma.wav");
		
		//Get MaxPlayers
		iMaxPlayers = Globals.GetMaxClients();
		
		//Resize
		g_flIdleTime.resize(iMaxPlayers + 1);
		g_flSDTime.resize(iMaxPlayers + 1);		
		g_flSDBonus.resize(iMaxPlayers + 1);
		g_flSDMulti.resize(iMaxPlayers + 1);
		g_iCVSIndex.resize(iMaxPlayers + 1);
		g_bWasFirstZombie.resize(iMaxPlayers + 1);
		g_bIsFirstZombie.resize(iMaxPlayers + 1);
		g_bIsAbuser.resize(iMaxPlayers + 1);
		g_bIsVolunteer.resize(iMaxPlayers + 1);
		g_flHPRDelay.resize(iMaxPlayers + 1);
		g_iInfectDelay.resize(iMaxPlayers + 1);
		g_iZMDeathCount.resize(iMaxPlayers + 1);
		g_bIsSpawned.resize(iMaxPlayers + 1);
		
		g_bAModels.resize(g_strModels.length());
		
		for(uint i = 0; i <= g_strModels.length() - 1; i++)
		{
			g_bAModels[i] = true;
		}
		
		//Set Wait Time
		flIdleTimer = Globals.GetCurrentTime() + 0.10f;
		flSloDTimer = Globals.GetCurrentTime() + 0.01f;
		flHPRegenTime = Globals.GetCurrentTime() + 0.15f;
		flCITime = Globals.GetCurrentTime() + 0.5f;
		
		//Set Doors Filter to 0 (any team)
		if(bAllowWarmUp == true) SetDoors(0);
	
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
	iWUSeconds = iWUTime;
	
	iUNum = 0;
	
	bAllowCD = false;
	bIsFirstITurns = false;
	bAZSProgress = false;
	bAllowZS = false;
	bAllowZMIdleSND = false;
	bAllowZMSlowD = false;
	bAllowFZColor = false;
	bAllowWarmUp = true;
	
	ClearBoolArray(g_bWasFirstZombie);
	ClearBoolArray(g_bIsFirstZombie);
	ClearBoolArray(g_bIsAbuser);
	ClearBoolArray(g_bIsVolunteer);
	ClearBoolArray(g_bIsSpawned);
	ClearBoolArray(g_bAModels);
	ClearIntArray(g_iCVSIndex);
	ClearIntArray(g_iInfectDelay);
	ClearIntArray(g_iZMDeathCount);
	ClearFloatArray(g_flHPRDelay);
	ClearFloatArray(g_flSDMulti);
	ClearFloatArray(g_flSDBonus);
	ClearFloatArray(g_flSDTime);
	ClearFloatArray(g_flIdleTime);
}

void ClearIntArray(array<int> &iTarget)
{
    while (iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

void ClearFloatArray(array<float> &iTarget)
{
    while (iTarget.length() > 0)
    {
        iTarget.removeAt(0);
    }
}

void ClearBoolArray(array<bool> &iTarget)
{
    while (iTarget.length() > 0)
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
							g_flIdleTime[i] = Math::RandomFloat(2.30f, 7.10f);
						break;
						
						case 3:
							g_flIdleTime[i] = Math::RandomFloat(4.20f, 12.40f);
						break;
						
						default:
							g_flIdleTime[i] = Math::RandomFloat(2.00f, 15.10f);
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
				
				if(g_flSDTime[i] <= 0) g_flSDMulti[i] = 1.00f;
				
				if(g_flSDTime[i] < 0) g_flSDTime[i] = 0.000f;
				
				if(g_flSDTime[i] > 0 && pBaseEnt.GetTeamNumber() == 3 && pBaseEnt.IsAlive() == true)
				{
					float x = pBaseEnt.GetAbsVelocity().x;
					float y = pBaseEnt.GetAbsVelocity().y;
					float z = pBaseEnt.GetAbsVelocity().z;
					
					if(g_flSDMulti[i] < 1) g_flSDMulti[i] = 1.000f;
					
					x = pBaseEnt.GetAbsVelocity().x / g_flSDMulti[i];
					y = pBaseEnt.GetAbsVelocity().y / g_flSDMulti[i];
					
					pBaseEnt.SetAbsVelocity(Vector(x, y, z));
					
					g_flSDTime[i]-=0.01f;
					
					if(g_flSDTime[i] < 0) g_flSDTime[i] = 0;
					
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
		
		if(flCITime <= Globals.GetCurrentTime())
		{
			flCITime = Globals.GetCurrentTime() + 0.5f;
			
			for(int i = 1; i <= iMaxPlayers; i++) 
			{
				CZP_Player@ pPlayer = ToZPPlayer(i);

				if(pPlayer is null) continue;

				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
				
				if(pPlayer.IsInfected() == true)
				{
					TurnToZ(pBaseEnt.entindex());
				}
			}
		}
		
		if(flExtendTime <= Globals.GetCurrentTime())
		{
			flExtendTime = Globals.GetCurrentTime() + 1.00f;
			Engine.ExtendGame(2, 1);
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
		g_flSDBonus[pBaseEnt.entindex()] = 0.00f;
		g_flSDMulti[pBaseEnt.entindex()] = 1.000f;
		g_iInfectDelay[pBaseEnt.entindex()] = 0;
		g_iZMDeathCount[pBaseEnt.entindex()] = -1;
		g_flHPRDelay[pBaseEnt.entindex()] = 0.00f;
		g_iCVSIndex[pBaseEnt.entindex()] = Math::RandomInt(1, 3);
			
		g_bWasFirstZombie[pBaseEnt.entindex()] = false;
		g_bIsFirstZombie[pBaseEnt.entindex()] = false;
		g_bIsAbuser[pBaseEnt.entindex()] = false;
		g_bIsVolunteer[pBaseEnt.entindex()] = false;
		g_bIsSpawned[pBaseEnt.entindex()] = false;

		return HOOK_HANDLED;
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode PlayerSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	if(bIsCSZM == true)
	{
		if(Utils.StrEql("!infect", pArgs.Arg(1)))
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
			else
			{
				Chat.PrintToChatPlayer(pPlrEnt, strOnlyInLobby);
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
		
		Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Mute");
		
		if(pBaseEnt.GetTeamNumber() == 0)
		{
			pBaseEnt.SetModel("models/cszm/lobby_guy.mdl");
			if(bAllowWarmUp == false) lobby_hint(pPlayer);
		}
		
		if(pBaseEnt.GetTeamNumber() == 1)
		{
			if(bAllowWarmUp == false) spec_hint(pPlayer);
		}
		
		if(bAllowWarmUp == false)
		{
			if(g_bIsFirstZombie[pBaseEnt.entindex()] == true) g_bIsFirstZombie[pBaseEnt.entindex()] = false;
		
			if(pBaseEnt.GetTeamNumber() != 3 && g_iZMDeathCount[pBaseEnt.entindex()] < 0) g_iZMDeathCount[pBaseEnt.entindex()] = -1;

			if(pBaseEnt.GetTeamNumber() == 2)
			{
				if(g_iInfectDelay[pBaseEnt.entindex()] > 0) g_iInfectDelay[pBaseEnt.entindex()]--;
				return HOOK_HANDLED;
			}
			
			if(pBaseEnt.GetTeamNumber() == 3 && bAllowZS == false)
			{				
				Chat.PrintToChatPlayer(pBaseEnt, strCannotJoinZT0);
				MovePlrToSpec(pBaseEnt);
					
				return HOOK_HANDLED;
			}
			
			if(pBaseEnt.GetTeamNumber() == 3 && bAZSProgress == false && g_bIsAbuser[pBaseEnt.entindex()] == true)
			{
				Chat.PrintToChatPlayer(pBaseEnt, strCannotJoinZT1);
				MovePlrToSpec(pBaseEnt);
					
				return HOOK_HANDLED;
			}
			
			if(pBaseEnt.GetTeamNumber() == 3 && bAllowZS != false)
			{
				RndZModel(pPlayer, pBaseEnt);
				SetZMHealth(pBaseEnt);
				
				return HOOK_HANDLED;
			}
		}
		else
		{
			if(g_bIsSpawned[pBaseEnt.entindex()] == true) pBaseEnt.ChangeTeam(1);
			else Schedule::Task(0.00f, "MakeThemSpec");
			if(pPlrEnt.IsBot() == true) pBaseEnt.ChangeTeam(1);	//Delete me
			if(CountPlrs(0) <= 2 || CountPlrs(1) <= 2) Schedule::Task(0.00f, "WarmUpTimer");
			PutPlrToPlayZone(pBaseEnt);
			pBaseEnt.SetModel("models/cszm/lobby_guy.mdl");
			
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
		float flDivisor = 1.0000f;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if(bAllowDebug == true)
		{
			SD("Damage Type: "+DamageInfo.GetDamageType());
			SD("Damage: "+flDamage);
		}

		if(pBaseEnt.GetTeamNumber() == 3) g_flHPRDelay[pBaseEnt.entindex()] = flHPRDelay;
		
		if(pBaseEnt.GetTeamNumber() == 3 && pBaseEnt.IsAlive() == true)
		{
			if(pPlayer.IsCarrier() != true)
			{
				g_flIdleTime[pBaseEnt.entindex()] += 0.40f;
				Engine.EmitSoundEntity(pBaseEnt, "CSPlayer_Z.Pain" + g_iCVSIndex[pBaseEnt.entindex()]);
			}

			if(g_flSDMulti[pBaseEnt.entindex()] < 1) g_flSDMulti[pBaseEnt.entindex()] = 1.000f;
			if(g_flSDMulti[pBaseEnt.entindex()] > 1.35 && pPlayer.IsCarrier() == false) flDivisor = 2.000f;
			if(pPlayer.IsCarrier() == true) flDivisor = flCSDDivider;
			if(g_bIsFirstZombie[pBaseEnt.entindex()] == true) flDivisor = flFISDDivider;
			
			if(bAllowDebug == true) SD("flDivisor = " + flDivisor);
			
			switch(DamageInfo.GetDamageType())
			{
				case 536879106: //Buckshot DT
					g_flSDMulti[pBaseEnt.entindex()] += flSDMultSG / flDivisor;
					g_flSDTime[pBaseEnt.entindex()] += flSDTimeSG;
				break;
				
				case 64: //Blast DT
					g_flSDMulti[pBaseEnt.entindex()] += flSDMultEXP / flDivisor;
					g_flSDTime[pBaseEnt.entindex()] += flSDTimeEXP;
				break;
				
				case 134217792: //Explosive Barrels DT
					g_flSDMulti[pBaseEnt.entindex()] += flSDMultEXP / flDivisor;
					g_flSDTime[pBaseEnt.entindex()] += flSDTimeEXP;
				break;
				
				case 8320: //Melee DT
					g_flSDMulti[pBaseEnt.entindex()] += flSDMultMEL / flDivisor;
					g_flSDTime[pBaseEnt.entindex()] += flSDTimeMEL;
				break;
			
				case 8194: //Revolver and Rifles DT
					if(flDamage > 79)
					{
						g_flSDMulti[pBaseEnt.entindex()] += flSDMultMAG / flDivisor;
						g_flSDTime[pBaseEnt.entindex()] += flSDTimeMAG;
					}
					else
					{
						g_flSDMulti[pBaseEnt.entindex()] += flSDMult / flDivisor;
						g_flSDTime[pBaseEnt.entindex()] += flSDTime;
					}
				break;
				
				case 32:
					g_flSDMulti[pBaseEnt.entindex()] += flSDMultFALL;
					g_flSDTime[pBaseEnt.entindex()] += flSDTimeFALL;
				break;
				
				default: //Any other DT
					g_flSDMulti[pBaseEnt.entindex()] += flSDMult / flDivisor;
					g_flSDTime[pBaseEnt.entindex()] += flSDTime;
				break;
			}
			
			if(g_flSDMulti[pBaseEnt.entindex()] > flMaxSDMult) g_flSDMulti[pBaseEnt.entindex()] = flMaxSDMult;
			if(g_flSDTime[pBaseEnt.entindex()] > flMaxSDTime) g_flSDTime[pBaseEnt.entindex()] = flMaxSDTime;
			
			return HOOK_HANDLED;
		}
		
		if(pBaseEnt.GetTeamNumber() ==  2 && DamageInfo.GetDamageType() == 8196 && flDamage > 20)
		{		
			CZP_Player@ pAttacker = ToZPPlayer(DamageInfo.GetAttacker());
			CBasePlayer@ pBasePlrA = pAttacker.opCast();
			CBaseEntity@ pBaseEntA = pBasePlrA.opCast();
			
			GotVictim(pAttacker, pBaseEntA);
			TurnToZ(pBaseEnt.entindex());
			
			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerKilled(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo) 
{
	if(bIsCSZM == true)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		CBaseEntity@ pEntAttacker = DamageInfo.GetAttacker();
		CZP_Player@ pPlrAttacker = ToZPPlayer(pEntAttacker);
		
		if(g_bIsVolunteer[pBaseEnt.entindex()] == true) g_bIsVolunteer[pBaseEnt.entindex()] = false;
		
		if(pBaseEnt.GetTeamNumber() == 3 && pPlayer.IsCarrier() != true)
		{
			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer_Z.Die" + g_iCVSIndex[pBaseEnt.entindex()]);
			g_flSDTime[pBaseEnt.entindex()] = 0;
			g_flSDMulti[pBaseEnt.entindex()] = 0;
		}
		
		if(pBaseEnt.entindex() == pEntAttacker.entindex()) pPlayer.AddScore(-5);
		
		if(pBaseEnt.GetTeamNumber() == 3 && pBaseEnt.entindex() != pEntAttacker.entindex() && g_bIsFirstZombie[pBaseEnt.entindex()] == false)
		{
			if(g_iZMDeathCount[pEntAttacker.entindex()] < iMaxDeath) g_iZMDeathCount[pBaseEnt.entindex()]++;
			if(pBaseEnt.GetTeamNumber() != pEntAttacker.GetTeamNumber()) pPlrAttacker.AddScore(1);
			
			if(Utils.GetNumPlayers(zombie, false) >= 2)
			{
				pBaseEnt.ChangeTeam(2);
				Schedule::Task(0.001f, "MovePlrToZombieTeam");
			}
		}
		
		if(pBaseEnt.GetTeamNumber() == 2 && pEntAttacker.GetTeamNumber() == 3 && pEntAttacker.IsPlayer() == true)
		{
			GotVictim(ToZPPlayer(pEntAttacker), pEntAttacker);
		}
	}

	return HOOK_CONTINUE;
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
		if(iFZIndex == pBaseEnt.entindex()) iFZIndex = 0;
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnEntityCreation(const string &in strClassname, CBaseEntity@ pEntity)
{
	if(bIsCSZM == true)
	{
		if(strClassname == "npc_grenade_frag")
		{
			Engine.Ent_Fire_Ent(pEntity, "AddOutput", "Effects 4");	//DLight for npc_grenade_frag
			return HOOK_HANDLED;
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode RoundWin(const string &in strMapname, RoundWinState iWinState)
{
	if(bIsCSZM == true)
	{
		bAllowCD = false;
		ShowRTL(0, 0, 15);

		if(iWinState == STATE_HUMAN)
		{
			Engine.EmitSound("CS_HumanWin");
			return HOOK_HANDLED;
		}

		if(iWinState == STATE_ZOMBIE)
		{
			Engine.EmitSound("CS_ZombieWin");
			return HOOK_HANDLED;
		}
	}

	return HOOK_CONTINUE;
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
		iFZTurningTime = 0;
		iFZIndex = 0;
		iSAt = 0;
		
		flIdleTimer = Globals.GetCurrentTime() + 0.10f;
		flSloDTimer = Globals.GetCurrentTime() + 0.01f;
		flHPRegenTime = Globals.GetCurrentTime() + 0.15f;
		flCITime = Globals.GetCurrentTime() + 0.5f;
		
		ShowRTL(0, 0, 300);
		
		for ( int i = 1; i <= iMaxPlayers; i++ ) 
		{
			g_flSDTime[i] = 0.0f;
			g_flSDBonus[i] = 0.00f;
			g_flSDMulti[i] = 1.000f;
			g_iZMDeathCount[i] = -1;
			g_flHPRDelay[i] = 0.00f;
				
			g_bIsFirstZombie[i] = false;
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
			SetDoors(1);
			iWUSeconds = iWUTime;
		}
	}
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
		if(g_bWasFirstZombie[i] == true) iPlrWasFZ++;
	}
	
	if(iPlrWasFZ >= iPlr)
	{
		for(int i = 1; i <= iMaxPlayers; i++ )
		{
			g_bWasFirstZombie[i] = false;
		}
	}
}

void RoundTimeLeft()
{
	if(Utils.GetNumPlayers(survivor, false) <= 1) RoundManager.SetWinState(STATE_STALEMATE);
	
	if(bAllowCD == true)
	{
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
			Schedule::Task(0.0f, "FirstZombie");	//Fix Me
//			FirstZombie();
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
	
	iChannel = 0;
	flFadeIn = 0;
	flFadeOut = 0;
	flxPos = -1;
	flyPos = 0;
	flxTime = 1;
	
	strMessage = ("| " + TimerText + " |");
	
	SendGameText(any, strMessage, iChannel, flxTime, flxPos, flyPos, flFadeIn, flFadeOut, flHoldTime, Color(235, 235, 235), Color(0, 0, 0));
}

void TimesUp()
{
	if(Utils.GetNumPlayers(survivor, true) > 0) RoundManager.SetWinState(STATE_HUMAN);
}

void FZColor()
{
	if(bAllowFZColor == true && bIsFirstITurns != true)
	{
		Schedule::Task(0.05f, "FirstZombie");
		Schedule::Task(0.05f, "FZColor");
	}
}

void FirstZombie()
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
				
				SendGameTextPlayer(
				pPlayer,
				strPreTurnMsg,
				1,
				0,
				-1,
				0.175,
				0,
				0,
				0.075,
				Color(iR, iG, iB),
				Color(0, 0, 0)
				);
			}
			else
			{
				iFZIndex = ChooseVolunteer();
				if(iFZIndex == 0) iFZIndex = ChooseFirstZombie();
				FirstZombie();
			}
		}
		else
		{
			iFZIndex = ChooseVolunteer();
			if(iFZIndex == 0) iFZIndex = ChooseFirstZombie();
			FirstZombie();
		}
	}
	else
	{
		TurnToZ(iFZIndex);
		ShowOutbreak(iFZIndex);
	}
}

void TurnToZ(const int &in iIndex)
{
	if(iIndex != 0 && iIndex > 0)
	{
		CZP_Player@ pPlayer = ToZPPlayer(iIndex);
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if(pPlayer !is null)
		{
			if(bIsFirstITurns != true)
			{
				pSoloMode.SetValue("0");
				bAllowZS = true;
				bIsFirstITurns = true;
				Engine.EmitSound("CS_FirstTurn");
				g_bWasFirstZombie[iIndex] = true;
				g_bIsFirstZombie[iIndex] = true;
				Schedule::Task(flBlockZSTime, "AllowZSProgress");
				MakeThemAbuser();
			}
			
			pPlayer.CompleteInfection();
			Engine.EmitSoundEntity(pBaseEnt, "Flesh.HeadshotExplode");
			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Turn");
			RndZModel(pPlayer, pBaseEnt);
			SetZMHealth(pBaseEnt);

			Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Mute");
			
			iUNum++;
			pBaseEnt.SetEntityName("PlrTurn"+iUNum);
			Engine.Ent_Fire("PlrTurn"+iUNum, "AddOutput", "OnUser1 BadRed-Fade:fade:0:0:1");
			Engine.Ent_Fire("maker_ps-turn", "ForceSpawnAtEntityOrigin", "PlrTurn"+iUNum);
			Engine.Ent_Fire("maker_trigger", "ForceSpawnAtEntityOrigin", "PlrTurn"+iUNum);
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
	
	iRND_CVS_PV = iRND_CVS;
}

void SetZMHealth(CBaseEntity@ pEntPlr)
{
	if(bAllowDebug == true) SD("g_iZMDeathCount: " + g_iZMDeathCount[pEntPlr.entindex()]);
	
	if(g_iZMDeathCount[pEntPlr.entindex()] < 0 ) g_iZMDeathCount[pEntPlr.entindex()] = 0;
	
	int iHPBonus = g_iZMDeathCount[pEntPlr.entindex()] * iDeathHPBonus;
	
	CZP_Player@ pPlayer = ToZPPlayer(pEntPlr);
	
	if(pPlayer.IsCarrier() == false)
	{
		if(g_bIsFirstZombie[pEntPlr.entindex()] == true)
		{
			pEntPlr.SetMaxHealth(iFirstInfectedHP / 3);
			pEntPlr.SetHealth(iFirstInfectedHP);
		}
		else
		{
			pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + iZMMaxHPBoost + iHPBonus);
			pEntPlr.SetHealth(pEntPlr.GetHealth() + (iZMMaxHPBoost / 4) + iHPBonus);
		}
	}
	else
	{
		pEntPlr.SetMaxHealth(pEntPlr.GetMaxHealth() + iCMaxHPBoost + (iHPBonus / 2));
		pEntPlr.SetHealth(pEntPlr.GetHealth() + iCMaxHPBoost + (iHPBonus / 2));
	}
}

void GetRandomVictim()
{
	CZP_Player@ pVictim = GetRandomPlayer(survivor, true);
	CBasePlayer@ pVPlrEnt = pVictim.opCast();
	CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();
	TurnToZ(pVBaseEnt.entindex());
}

void ShowOutbreak(int &in iIndex)
{
	CZP_Player@ pFirstInf = ToZPPlayer(iIndex);
	
	for(int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer(i);
		
		if(pPlayer is null) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if(i != iIndex) Chat.PrintToChatPlayer(pPlrEnt, "{violet}" + pFirstInf.GetPlayerName() + strBecameFi);
		
		SendGameTextPlayer(
		pPlayer,
		strOutbreakMsg,
		1,
		0,
		-1,
		0.175,
		0,
		0.35,
		6.75,
		Color(64, 255, 128),
		Color(0, 255, 0)
		);
	}
	
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

int ChooseFirstZombie()
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
		if(g_bWasFirstZombie[i] == false && pBaseEnt.IsAlive() == true && g_iInfectDelay[i] < 2)
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
	//Usually a 'trigger_joinspectatorteam' hasn't an origin coordinates (it's equal '0 0 0' by default)
	//and you cannot get correct coordinates with a '.GetAbsOrigin()' func...
	//so, this solution won't work for every single map, keep it in mind.
	CBaseEntity@ pSpecTrigger = FindEntityByClassname(pSpecTrigger, "trigger_joinspectatorteam");
	pEntPlr.ChangeTeam(0);
	pEntPlr.SetAbsOrigin(pSpecTrigger.GetAbsOrigin());
	CBasePlayer@ pPlayer = ToBasePlayer(pEntPlr.entindex());
}

void LocknLoad()
{
	if(bAllowCD != true) bAllowCD = true;
	
	iSeconds = iRoundTime;
	
	Engine.ExtendGame(2, 9999);

	RoundTimeLeft();
	Engine.EmitSound("CS_MatchBeginRadio");
	
	Globals.SetPlayerRespawnDelay(true, flSpawnDelay);
	
	ShowChatMsg(strRoundBegun, 2);
}

//WarmUp Funcs
void WarmUpTimer()
{
	int iNumPlrs = 0;
	iNumPlrs += CountPlrs(1);
	iNumPlrs += CountPlrs(0);

	if(bAllowWarmUp == true && iNumPlrs >= 2)
	{
		iWUSeconds--;

		string TimerText = "\n\n\n-= Warm Up! =-\n| "+iWUSeconds+" |";
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
		SendGameText(any, "Awaiting More Players", 1, 0.00f, -1, 0.00f, 0.00f, 0.00f, 600.00f, Color(255, 255, 255), Color(255, 95, 5));
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
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_commons")) !is null)
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
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_human")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_zombie")) !is null)
	{
		g_pOtherSpawn.insertLast(pEntity);
	}
	
	while ((@pEntity = FindEntityByClassname(pEntity, "info_player_start")) !is null)
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

void SetDoors(const int &in iFilter)
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "AddOutput", "doorfilter " + iFilter);
	}
}

void GotVictim(CZP_Player@ pAttacker, CBaseEntity@ pBaseEntA)
{
	if(g_iZMDeathCount[pBaseEntA.entindex()] >= 0) g_iZMDeathCount[pBaseEntA.entindex()] -= 4;
	
	if(bAllowDebug == true) SD("g_iZMDeathCount: " + g_iZMDeathCount[pBaseEntA.entindex()]);
		
	if(pBaseEntA.IsAlive() == true) pBaseEntA.SetHealth(pBaseEntA.GetHealth() + iHPReward);
	pAttacker.AddScore(5);
}