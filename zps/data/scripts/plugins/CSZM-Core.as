/*
///////////////////////////////////////////////////////////////////
/////////////////| Counter-Strike Zombie Mode  |///////////////////
/////////////////|         Core Script         |///////////////////
///////////////////////////////////////////////////////////////////
*/

#include "../SendGameText"
#include "./cszm/cache.as"
#include "./cszm/antidote.as"
#include "./cszm/killfeed.as"
#include "./cszm/chat.as"
#include "./cszm/rprop.as"

//Some Data
CASConVar@ pSoloMode = null;
CASConVar@ pTestMode = null;
CASConVar@ pINGWarmUp = null;
CASConVar@ pFriendlyFire  = null;
CASConVar@ pInfectionRate   = null;

int iMaxPlayers;
int iDoorsState;						//Used for warm up ( to allow everyone to open doors )

bool bIsCSZM;							//Is CSZM available? ( Depends on a map )
bool bAllowAddTime = true;				//Allow add time for successful infection

bool bSpawnWeak = true;
bool bAllowZombieSpawn;
bool bWarmUp = true;

//Win Countes
int iHumanWin;
int iZombieWin;

//GamePlay Consts and Variables
//Player Speed
const int SPEED_DEFAULT = 220;
const int SPEED_HUMAN = 207; 
const int SPEED_ZOMBIE = 180;
const int SPEED_CARRIER = 199;
const int SPEED_WEAK = 231;
const int SPEED_MINIMUM = 80;

//Damage Slowdown
const float CONST_MAX_SLOWTIME = 2.0f;		//Maximum amount of seconds a zombie could be slowed down
const float CONST_RECOVER_UNIT = 0.05f;		//Amount of time in one tick of a speed recovery

//Team Consts
const int TEAM_LOBBYGUYS = 0;
const int TEAM_SPECTATORS = 1;
const int TEAM_SURVIVORS = 2;
const int TEAM_ZOMBIES = 3;

//Other Consts
const float CONST_SPAWN_DELAY = 5.0f;		//Zombies spawn delay.
const int CONST_FI_HEALTH_MULT = 125;		//HP multiplier of first infected.
const int CONST_ZOMBIE_ADD_HP = 200;		//Additional HP to Max Health of a zombie.
const int CONST_WEAK_ZOMBIE_HP = 125;		//Health of the weak zombies
const int CONST_CARRIER_HP = 0;				//Additional HP to Max Health of the carrier.	( Currently equal 0 because the carrier is too OP )
const int CONST_REWARD_HEALTH = 125;		//Give that amount of HP as reward of successful infection.
const int CONST_GEARUP_TIME = 40;			//Time to gear up and find a good spot.
const int CONST_TURNING_TIME = 20;			//Turning time.
const int CONST_INFECT_DELAY = 2;			//Amount of rounds you have to wait to be the First Infected again.
const int CONST_WARMUP_TIME = 10;			//Time of the warmup in seconds.		( default value is 75 )

//Other Consts
const float CONST_WEAK_ZOMBIE_TIME = 45.0f;								
const int CONST_SUBTRACT_DEATH = 2;												//Amount of units subtract from the death counter
const int CONST_INFECT_ADD_TIME = 15;											//Amount of time in seconds add to the round time in case of successful infection
const int CONST_DEATH_BONUS_HP = 100;											//Multiplier of death hp bonus.
const int CONST_DEATH_MAX = 7;													//Maximum amount of death to boost up the max health.
const int CONST_ROUND_TIME = 300;												//Round time in seconds.
const int CONST_ROUND_TIME_FULL = CONST_ROUND_TIME + CONST_GEARUP_TIME;			//Round time in seconds.
const int CONST_ZOMBIE_LIVES = 32;												//Hold Zombie Lives at this level ( Zombie Lives unused in CSZM ) 
const float CONST_ROUND_TIME_GAME = 300.0f;										//Hold IN-Game Round timer at this level ( IN-Game Round timer unused in CSZM )
const float CONST_SLOWDOWN_MULT = 40.0f;										//36.0f
const float CONST_SLOWDOWN_WEAKMULT = 30.0f;
const float CONST_SLOWDOWN_CRITDMG = 45.0f;

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

//List of available ZM Player models ( make sure your server has it )
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

//Damage Slowdown arrays
array<int> g_iNormalSpeed;
array<int> g_iSlowSpeed;
array<float> g_flSlowTime;
array<float> g_flAddTime;
array<float> g_flRecoverTime;

//Other arrays ( Don't even touch this )
array<float> g_flFRespawnCD;
array<float> g_flIdleTime;
array<int> g_CONST_INFECT_DELAY;
array<int> g_iZMDeathCount;

array<int> g_iCVSIndex;
array<bool> g_bWasFirstInfected;
array<bool> g_bIsVolunteer;
array<bool> g_bIsFirstInfected;
array<bool> g_bIsAbuser;
array<bool> g_bIsWeakZombie;

//Other Data ( Don't even touch this )
int iFirstInfectedHP;
int iStartCoundDown;
int iSeconds;
int iFZIndex = 0;
int iRND_CVS_PV;
int iWUSeconds = CONST_WARMUP_TIME;

float flRTWait;
float flWUWait;
float flShowSeconds;
float flShowMinutes;
float flShowHours;
float flWeakZombieWait;

#include "./cszm/misc.as"

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "Counter-Strike Zombie Mode" );

	//Find 'sv_zps_solo' ConVar
	@pSoloMode = ConVar::Find( "sv_zps_solo" );
	if ( pSoloMode !is null )
	{
		ConVar::Register( pSoloMode, "ConVar_SoloMode" );
	}

	//Find 'sv_testmode' ConVar
	@pTestMode = ConVar::Find( "sv_testmode" );
	if ( pTestMode !is null )
	{
		ConVar::Register( pTestMode, "ConVar_TestMode" );
	}

	//Find 'sv_zps_warmup' ConVar
	@pINGWarmUp = ConVar::Find( "sv_zps_warmup" );
	if ( pINGWarmUp !is null )
	{
		ConVar::Register( pINGWarmUp, "ConVar_WarmUpTime" );
	}

	//Find 'mp_friendlyfire' ConVar
	@pFriendlyFire = ConVar::Find( "mp_friendlyfire" );
	if ( pFriendlyFire !is null )
	{
		ConVar::Register( pFriendlyFire, "ConVar_FriendlyFire" );
	}

	//Find 'sv_zps_infectionrate' ConVar
	@pInfectionRate = ConVar::Find( "sv_zps_infectionrate" );
	if ( pInfectionRate !is null )
	{
		ConVar::Register( pInfectionRate, "ConVar_InfectionRate" ); 
	}

	//Events
	Events::Player::OnPlayerInfected.Hook( @CSZM_OnPlayerInfected );
	Events::Player::OnPlayerConnected.Hook( @CSZM_OnPlayerConnected );
	Events::Player::OnPlayerSpawn.Hook( @CSZM_OnPlayerSpawn );
	Events::Entities::OnEntityCreation.Hook( @CSZM_OnEntityCreation );
	Events::Custom::OnPlayerDamagedCustom.Hook( @CSZM_OnPlayerDamaged );
	Events::Player::OnPlayerKilled.Hook( @CSZM_OnPlayerKilled );
	Events::Player::OnPlayerDisonnected.Hook( @CSZM_OnPlayerDisonnected );
	Events::Rounds::RoundWin.Hook( @CSZM_RoundWin );
	Events::Player::OnPlayerRagdollCreate.Hook( @CSZM_OnPlayerRagdollCreate );
	Events::Player::OnConCommand.Hook( @CSZM_OnConCommand );
}

void OnMapInit()
{
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		Log.PrintToServerConsole( LOGTYPE_INFO, "CSZM", "[CSZM] Current map is valid for 'Counter-Strike Zombie Mode'" );
		bIsCSZM = true;
		flWeakZombieWait = 0;
		flRTWait = 0;
		flWUWait = 0;

		Engine.EnableCustomSettings( true );
		
		//Set some ConVar to 0
		pSoloMode.SetValue( "0" );
		pTestMode.SetValue( "0" );
		pINGWarmUp.SetValue( "0" );
		pFriendlyFire.SetValue( "0" );
		pInfectionRate.SetValue( "0" );
		
		//Cache
		CacheModels();
		CacheSounds();

		//Get MaxPlayers
		iMaxPlayers = Globals.GetMaxClients();
		
		//Entities
		Entities::RegisterPickup( "item_deliver" );
		Entities::RegisterUse( "item_deliver" );
		Entities::RegisterDrop( "item_deliver" );
		
		//Resize
		g_flFRespawnCD.resize( iMaxPlayers + 1 );
		g_flIdleTime.resize( iMaxPlayers + 1 );
		g_iCVSIndex.resize( iMaxPlayers + 1 );
		g_bWasFirstInfected.resize( iMaxPlayers + 1 );
		g_bIsFirstInfected.resize( iMaxPlayers + 1 );
		g_bIsAbuser.resize( iMaxPlayers + 1 );
		g_bIsWeakZombie.resize( iMaxPlayers + 1 );
		g_bIsVolunteer.resize( iMaxPlayers + 1 );
		g_CONST_INFECT_DELAY.resize( iMaxPlayers + 1 );
		g_iZMDeathCount.resize( iMaxPlayers + 1 );
		g_iAntidote.resize( iMaxPlayers + 1 );
		g_iKills.resize( iMaxPlayers + 1 );
		g_iVictims.resize( iMaxPlayers + 1 );

		//Resize Damage Slowdown arrays
		g_iNormalSpeed.resize( iMaxPlayers + 1 );
		g_iSlowSpeed.resize( iMaxPlayers + 1 );
		g_flSlowTime.resize( iMaxPlayers + 1 );
		g_flRecoverTime.resize( iMaxPlayers + 1 );
		g_flAddTime.resize( iMaxPlayers + 1 );
		
		//Set Doors Filter to 0 ( any team )
		if ( bWarmUp )
		{
			SetDoorFilter( TEAM_LOBBYGUYS );
		}
	
	}
	else Log.PrintToServerConsole( LOGTYPE_INFO, "CSZM", "[CSZM] Current map is not valid for 'Counter-Strike Zombie Mode'" );
}

void OnMapShutdown()
{
	if ( bIsCSZM )
	{
		pSoloMode.SetValue( "0" );

		bIsCSZM = false;
		Engine.EnableCustomSettings( false );
		iSeconds = 0;
		iFZIndex = 0;
		iWUSeconds = CONST_WARMUP_TIME;

		flWeakZombieWait = 0;
		flRTWait = 0;
		flWUWait = 0;

		iHumanWin = 0;
		iZombieWin = 0;
		
		Entities::RemoveRegisterPickup( "item_deliver" );
		Entities::RemoveRegisterUse( "item_deliver" );
		Entities::RemoveRegisterDrop( "item_deliver" );
		
		bSpawnWeak = true;
		bAllowZombieSpawn = false;
		bWarmUp = true;
		
		ClearBoolArray( g_bWasFirstInfected );
		ClearBoolArray( g_bIsFirstInfected );
		ClearBoolArray( g_bIsAbuser );
		ClearBoolArray( g_bIsWeakZombie );
		ClearBoolArray( g_bIsVolunteer );
		ClearIntArray( g_iKills );
		ClearIntArray( g_iVictims );
		ClearIntArray( g_iCVSIndex );
		ClearIntArray( g_CONST_INFECT_DELAY );
		ClearIntArray( g_iZMDeathCount );
		ClearIntArray( g_iAntidote );
		ClearIntArray( g_iNormalSpeed );
		ClearIntArray( g_iSlowSpeed );
		ClearFloatArray( g_flSlowTime );
		ClearFloatArray( g_flRecoverTime );
		ClearFloatArray( g_flAddTime );
		ClearFloatArray( g_flIdleTime );
		ClearFloatArray( g_flFRespawnCD );
	}
}


HookReturnCode CSZM_OnPlayerRagdollCreate( CZP_Player@ pPlayer, bool &in bHeadshot, bool &out bExploded )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( Utils.StrContains( "cszm", pBaseEnt.GetModelName() ) )
	{
		bHeadshot = false;
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_RoundWin( const string &in strMapname, RoundWinState iWinState )
{
	if ( bIsCSZM )
	{

		flRTWait = 0;
		ShowTimer( 10.25f );

		if ( iWinState == STATE_HUMAN )
		{
			Engine.EmitSound( "CS_HumanWin" );
		}

		if ( iWinState == STATE_ZOMBIE )
		{
			Engine.EmitSound( "CS_ZombieWin" );
		}

		if ( iWinState == STATE_HUMAN )
		{
			iHumanWin++;
		}
		
		if ( iWinState == STATE_ZOMBIE )
		{
			iZombieWin++;
		}
		
		string strHW = "\n  Humans Win - " + iHumanWin;
		string strZW = "\n  Zombies Win - " + iZombieWin;
		
		SendGameText( any, "-=Win Counter=-" + strHW + strZW, 4, 0.0f, 0, 0.35f, 0.25f, 0.0f, 10.10f, Color( 235, 235, 235 ), Color( 255, 95, 5 ) );

		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerConnected( CZP_Player@ pPlayer ) 
{
	if ( bIsCSZM )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

        const int iIndex = pBaseEnt.entindex();
		
		g_flFRespawnCD[iIndex] = 0.0f;
		g_flIdleTime[iIndex] = 0.0f;
		g_CONST_INFECT_DELAY[iIndex] = 0;
		g_iAntidote[iIndex] = 0;
		g_iZMDeathCount[iIndex] = -1;
		g_iCVSIndex[iIndex] = Math::RandomInt( 1, 3 );

		g_iKills[iIndex] = 0;
		g_iVictims[iIndex] = 0;
			
		g_bWasFirstInfected[iIndex] = false;
		g_bIsFirstInfected[iIndex] = false;
		g_bIsAbuser[iIndex] = false;
		g_bIsWeakZombie[iIndex] = true;
		g_bIsVolunteer[iIndex] = false;

		ZeroingSlowdown( iIndex, true );
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnConCommand( CZP_Player@ pPlayer, CASCommand@ pArgs )
{
	if ( bIsCSZM )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int iIndex = pBaseEnt.entindex();

		if ( !RoundManager.IsRoundOngoing( false ) )
		{
			if ( Utils.StrContains( "choose", pArgs.Arg( 0 ) ) && pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS ) 
			{
				if ( bWarmUp )
				{
					if ( Utils.StrEql( "choose4", pArgs.Arg( 0 ) ) && g_flFRespawnCD[iIndex] <= Globals.GetCurrentTime() )
					{
						g_flFRespawnCD[iIndex] = Globals.GetCurrentTime() + 0.45f;
						pPlayer.ForceRespawn();
					}
					
					return HOOK_HANDLED;
				}
				else
				{
					if ( Utils.StrEql( "choose2", pArgs.Arg( 0 ) ) )
					{
						if ( g_CONST_INFECT_DELAY[iIndex] > 0 )
						{
							Chat.PrintToChatPlayer( pPlrEnt, strCannotPlayFI );
							return HOOK_HANDLED;
						}
						
						else
						{
							Chat.PrintToChatPlayer( pPlrEnt, strChooseToPlayFI );
							if ( !g_bIsVolunteer[iIndex] )
							{
								g_bIsVolunteer[iIndex] = true;
							}
						}
					}
				}
			}				
		}

		else
		{
			if ( Utils.StrEql( "choose1", pArgs.Arg( 0 ) ) || Utils.StrEql( "choose2", pArgs.Arg( 0 ) ) )
			{
				if ( pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS )
				{
					if ( !bAllowZombieSpawn )
					{
						if ( g_bIsAbuser[iIndex] )
						{
							Chat.PrintToChatPlayer( pPlrEnt, strCannotJoinGame );
							Engine.EmitSoundPlayer( pPlayer, "common/wpn_denyselect.wav" );
							return HOOK_HANDLED;
						}

						if ( !g_bIsAbuser[iIndex] )
						{
							pBaseEnt.ChangeTeam( TEAM_SURVIVORS );
							pPlayer.ForceRespawn();
							pPlayer.SetHudVisibility( true );
							return HOOK_HANDLED;
						}
					}

					else if ( g_bIsAbuser[iIndex] )
					{
						pBaseEnt.ChangeTeam( TEAM_ZOMBIES );
						pPlayer.ForceRespawn();
						pPlayer.SetHudVisibility( true );
						return HOOK_HANDLED;
					}
				}
			}
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerSpawn( CZP_Player@ pPlayer )
{
	if ( bIsCSZM )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		RemoveProp( pBaseEnt );
		
		int iIndex = pBaseEnt.entindex();

		Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Mute" );

		ZeroingSlowdown( iIndex, false );
		//Apply the custom movement speed
		switch( pBaseEnt.GetTeamNumber() )
		{
			case TEAM_SURVIVORS:
				g_iNormalSpeed[iIndex] = SPEED_HUMAN;
			break;
			
			case TEAM_ZOMBIES:
				if ( pPlayer.IsCarrier() )
				{
					g_iNormalSpeed[iIndex] = SPEED_CARRIER;
				}

				else
				{
					g_iNormalSpeed[iIndex] = SPEED_ZOMBIE;
				}
			break;
			
			default:
				g_iNormalSpeed[iIndex] = SPEED_DEFAULT;
			break;
		}

		pPlayer.SetMaxSpeed( g_iNormalSpeed[iIndex] );

		//Set CSS Arms (human type) if not zombie
		if ( pBaseEnt.GetTeamNumber() != TEAM_ZOMBIES )
		{
			pPlayer.SetArmModel( "models/cszm/weapons/c_css_arms.mdl" );
		}

		else
		{
			//Don't set CSS Arms (zombie type) to The Carrier
			if ( !pPlayer.IsCarrier() )
			{
				pPlayer.SetArmModel( "models/cszm/weapons/c_css_zombie_arms.mdl" );
			}
			//Give zomies some ammo to drop
			if ( Math::RandomInt( 1, 100 ) > 59 )
			{
				int iRNG = Math::RandomInt( 0, 3 );	//RNG Ammo type 0 - Pistol, 1 - Revolver, 2 - Shotgun, 4 - Rifle
				int iAmmoCount = Math::RandomInt( 21, 43 );

				switch( iRNG )
				{
					case 1:	//Revolver ammo
						iAmmoCount = Math::RandomInt( 4, 12 );
					break;
					
					case 2:	//Shotgun ammo
						iAmmoCount = Math::RandomInt( 3, 9 );
					break;
				}

				AmmoBankSetValue iAmmoType = AmmoBankSetValue( iRNG );
				pPlayer.AmmoBank( add, iAmmoType, iAmmoCount );
			}
		}
		//If in lobby team set the lobby guy player model
		if ( pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS )
		{
			pBaseEnt.SetModel( "models/cszm/lobby_guy.mdl" );
			pPlayer.SetVoice( eugene );

			if ( !bWarmUp )
			{
				lobby_hint( pPlayer );
			}

			else
			{
				lobby_hint_wu( pPlayer );
			}
		}
		
		if ( pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS && !bWarmUp )
		{
			spec_hint( pPlayer );
		}
		
		if ( !bWarmUp )
		{
			if ( pBaseEnt.GetTeamNumber() != TEAM_ZOMBIES && g_iZMDeathCount[iIndex] < 0 )
			{
				g_iZMDeathCount[iIndex] = -1;
			}
			
			if ( pBaseEnt.GetTeamNumber() == TEAM_SURVIVORS )
			{
				if ( g_iAntidote[iIndex] > 0 ) g_iAntidote[iIndex] = 0;
				return HOOK_HANDLED;
			}
			
			if ( pBaseEnt.GetTeamNumber() == TEAM_ZOMBIES && !bAllowZombieSpawn )
			{				
				Chat.PrintToChatPlayer( pBaseEnt, strCannotJoinZT0 );
				MovePlrToSpec( pBaseEnt );
				Engine.EmitSoundPlayer( pPlayer, "common/wpn_denyselect.wav" );

				return HOOK_HANDLED;
			}
			
			if ( pBaseEnt.GetTeamNumber() == TEAM_ZOMBIES && bAllowZombieSpawn )
			{
				g_flIdleTime[iIndex] = Globals.GetCurrentTime() + 0.1f;

				EmitBloodExp( pPlayer, true );

				if ( !bSpawnWeak && g_bIsWeakZombie[iIndex] )
				{
					g_bIsWeakZombie[iIndex] = false;
				}

				if ( bSpawnWeak && g_bIsWeakZombie[iIndex] )
				{
					SpawnWeakZombie( pPlayer );
				}
				
				else
				{
					RndZModel( pPlayer, pBaseEnt );
					SetZMHealth( pBaseEnt );
				}
				
				return HOOK_HANDLED;
			}
		}

		else
		{
			if ( pPlrEnt.IsBot() )									
			{														//For debug purposes
				pBaseEnt.ChangeTeam( TEAM_LOBBYGUYS );				//Unused in actual gameplay
				pPlayer.ForceRespawn();
				pBaseEnt.SetModel( "models/cszm/lobby_guy.mdl" );
			}

			PutPlrToPlayZone( pBaseEnt );

			if ( CountPlrs( 0 ) <= 2 && iWUSeconds == CONST_WARMUP_TIME )
			{
				flWUWait = Globals.GetCurrentTime();
			}
			
			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerDamaged( CZP_Player@ pPlayer, CTakeDamageInfo &out DamageInfo )
{
	if ( bIsCSZM )
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

//		CBaseEntity@ pWeapon = DamageInfo.GetWeapon();

		const int iAttIndex = pEntityAttacker.entindex();
		const int iAttTeam = pEntityAttacker.GetTeamNumber();

		if ( Utils.StrEql( pEntityAttacker.GetEntityName(), "frendly_shrapnel" ) && iVicTeam == 2 )
		{
			DamageInfo.SetDamageType( 0 );
			DamageInfo.SetDamage( 0 );
			return HOOK_HANDLED;
		}

		if ( iAttTeam == iVicTeam && pBaseEnt !is pEntityAttacker )
		{
			DamageInfo.SetDamageType( 0 );
			DamageInfo.SetDamage( 0 );
			return HOOK_HANDLED;
		}

		if ( pEntityAttacker.IsPlayer() ) 
		{
			@pPlrAttacker = ToZPPlayer( iAttIndex );
			strAN = pPlrAttacker.GetPlayerName();
		}

        const string strAttName = strAN;

		if ( iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && iDamageType == 8196 )
		{
			if ( g_iAntidote[iVicIndex] > 2 )
			{
				g_iAntidote[iVicIndex] = 1;
			}
			
			if ( g_iAntidote[iVicIndex] > 0 )
			{
				g_iAntidote[iVicIndex]--;
				if ( g_iAntidote[iVicIndex] <= 1 )
				{
					SetAntidoteState( iVicIndex, 1 );
				}

				return HOOK_HANDLED;
			}

			else if ( g_iAntidote[iVicIndex] <= 0 )
			{
				DamageInfo.SetDamage( 0 );
				g_iVictims[iAttIndex]++;
				ShowKills( pPlrAttacker, g_iVictims[iAttIndex], true );
                KillFeed( strAttName, iAttTeam, strVicName, iVicTeam, true, false );
				GotVictim( pPlrAttacker, pEntityAttacker );
				TurnToZ( iVicIndex );
			}
			
			return HOOK_HANDLED;
		}
		
		if ( iVicTeam == TEAM_ZOMBIES && pBaseEnt.IsAlive() )
		{
			bool bLeft = false;

			float VP_X = 0.0f;
			float VP_Y = 0.0f;
			float VP_DAMP = Math::RandomFloat( 0.047f , 0.095f );
			float VP_KICK = Math::RandomFloat( 0.25f , 1.35f );

			if ( bDamageType( iDamageType, 5 ) )
			{
				VP_X = Math::RandomFloat( -1.75f, -5.15f );
				VP_Y = Math::RandomFloat( -1.75f, -5.15f );
				VP_DAMP = Math::RandomFloat( 0.0f , 0.015f );
			}

			else 
			{
				VP_X = Math::RandomFloat( -3.75f, 3.85f );
				VP_Y = Math::RandomFloat( -3.75f, 3.85f );
			}

			if ( Math::RandomInt( 0 , 1 ) > 0 )
			{
				bLeft = true;
			}

			Utils.FakeRecoil( pPlayer, VP_KICK, VP_DAMP, VP_X, VP_Y, bLeft );
/*
			if ( pWeapon !is null )
			{
				if ( Utils.StrEql( "weapon_sledgehammer", pWeapon.GetClassname() ) )
				{
					DamageInfo.SetDamage( pBaseEnt.GetHealth() + 200 );
					DamageInfo.SetDamageType( 1 ); 
				}
			}
*/
			bool bAllowPainSound = false;

			if ( pPlayer.IsCarrier() && g_bIsFirstInfected[iVicIndex] )
			{
				bAllowPainSound = true;
			}

			if ( !pPlayer.IsCarrier() )
			{
				bAllowPainSound = true;
			}

			if ( bAllowPainSound && flDamage > 0 && flDamage < pBaseEnt.GetHealth() && flDamage > 0.5f && pBaseEnt.GetWaterLevel() != WL_Eyes )
			{
				Engine.EmitSoundEntity( pBaseEnt, "CSPlayer_Z.Pain" + g_iCVSIndex[iVicIndex] );
				g_flIdleTime[iVicIndex] = Globals.GetCurrentTime() + Math::RandomFloat( 4.85f, 9.95f );
			}

			AddSlowdown( iVicIndex, flDamage, iDamageType );

			return HOOK_HANDLED;
		}
	}

	return HOOK_HANDLED;
}

HookReturnCode CSZM_OnPlayerInfected( CZP_Player@ pPlayer, InfectionState iState )
{
	if ( iState != state_none && bIsCSZM ) pPlayer.SetInfection( false, 0.0f );

	return HOOK_HANDLED;
}

HookReturnCode CSZM_OnPlayerKilled( CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo ) 
{
	if ( bIsCSZM )
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

		ZeroingSlowdown( iVicIndex, false );
		
		if ( pEntityAttacker.IsPlayer() ) 
		{
			@pPlrAttacker = ToZPPlayer( iAttIndex );
			strAN = pPlrAttacker.GetPlayerName();
		}

		const string strAttName = strAN;

		if ( iAttIndex == iVicIndex || !pEntityAttacker.IsPlayer() )
		{
			KillFeed( "", 0, strVicName, iVicTeam, false, true );
			bSuicide = true;
		}

		else if ( iAttIndex != iVicIndex && pEntityAttacker.IsPlayer() )
		{
			KillFeed( strAttName, iAttTeam, strVicName, iVicTeam, false, false );
		}

		if ( iVicTeam == TEAM_ZOMBIES )
		{
			bool bAllowDieSound = false;

			if ( pPlayer.IsCarrier() && g_bIsFirstInfected[iVicIndex] )
			{
				bAllowDieSound = true;
			}

			if ( !pPlayer.IsCarrier() )
			{
				bAllowDieSound = true;
			}

			if ( bAllowDieSound && pBaseEnt.GetWaterLevel() != WL_Eyes )
			{
				Engine.EmitSoundEntity( pBaseEnt, "CSPlayer_Z.Die" + g_iCVSIndex[iVicIndex] );
			}

			if ( !bSuicide )
			{
				if ( g_iZMDeathCount[iVicIndex] < CONST_DEATH_MAX && !g_bIsFirstInfected[iVicIndex] )
				{
					g_iZMDeathCount[iVicIndex]++;
				}

				g_iKills[iAttIndex]++;

				if ( iAttTeam != TEAM_ZOMBIES )
				{
					ShowKills( pPlrAttacker, g_iKills[iAttIndex], false );
				}
			}
		}

		if ( iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && pEntityAttacker.IsPlayer() )
		{
			g_iVictims[iAttIndex]++;
			ShowKills( pPlrAttacker, g_iVictims[iAttIndex], true );
			g_bIsWeakZombie[iVicIndex] = false;
			GotVictim( pPlrAttacker, pEntityAttacker );
		}

		if ( g_bIsVolunteer[iVicIndex] )
		{
			g_bIsVolunteer[iVicIndex] = false;
		}

		if ( g_bIsFirstInfected[iVicIndex] )
		{
			g_bIsFirstInfected[iVicIndex] = false;
		}

		if ( iVicTeam == TEAM_ZOMBIES && bSpawnWeak )
		{
			g_bIsAbuser[iVicIndex] = true;
		}

		if ( iFZIndex == iVicIndex )
		{
			iFZIndex = 0;
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerDisonnected( CZP_Player@ pPlayer )
{
	if ( bIsCSZM )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if ( iFZIndex == pBaseEnt.entindex() )
		{
			iFZIndex = 0;
		}
		
		if ( pBaseEnt.GetTeamNumber() == TEAM_ZOMBIES && Utils.GetNumPlayers( zombie, false ) <= 1 && RoundManager.IsRoundOngoing( false ) )
		{
			Engine.EmitSound( "common/warning.wav" );
			RoundManager.SetWinState( STATE_STALEMATE );
			SD( strLastZLeave );
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnEntityCreation( const string &in strClassname, CBaseEntity@ pEntity )
{
	if ( bIsCSZM )
	{
		if ( strClassname == "npc_grenade_frag" )
		{
			CEntityData@ SPRTrailIPD = EntityCreator::EntityData();
			SPRTrailIPD.Add( "lifetime", "0.25" );
			SPRTrailIPD.Add( "renderamt", "255" );
			SPRTrailIPD.Add( "rendercolor", "245 16 16" );
			SPRTrailIPD.Add( "rendermode", "5" );
			SPRTrailIPD.Add( "spritename", "sprites/lgtning.vmt" );
			SPRTrailIPD.Add( "startwidth", "3.85" );

			CEntityData@ SpriteIPD = EntityCreator::EntityData();
			SpriteIPD.Add( "spawnflags", "1" );
			SpriteIPD.Add( "GlowProxySize", "4" );
			SpriteIPD.Add( "scale", "0.35" );
			SpriteIPD.Add( "rendermode", "9" );
			SpriteIPD.Add( "rendercolor", "245 16 16" );
			SpriteIPD.Add( "renderamt", "255" );
			SpriteIPD.Add( "model", "sprites/light_glow01.vmt" );
			SpriteIPD.Add( "renderfx", "0" );

			CEntityData@ DLightIPD = EntityCreator::EntityData();
			DLightIPD.Add( "_cone", "0" );
			DLightIPD.Add( "_inner_cone", "0" );
			DLightIPD.Add( "pitch", "0" );
			DLightIPD.Add( "spawnflags", "0" );
			DLightIPD.Add( "spotlight_radius", "0" );
			DLightIPD.Add( "style", "0" );
			DLightIPD.Add( "_light", "245 8 8 200" );
			DLightIPD.Add( "brightness", "4" );
			DLightIPD.Add( "distance", "48" );

			CBaseEntity@ pEntTrail = EntityCreator::Create( "env_spritetrail", pEntity.GetAbsOrigin(), QAngle( 0, 0, 0 ), SPRTrailIPD );
			CBaseEntity@ pEntSprite = EntityCreator::Create( "env_sprite", pEntity.GetAbsOrigin(), QAngle( 0, 0, 0 ), SpriteIPD );
			CBaseEntity@ pDLight = EntityCreator::Create( "light_dynamic", pEntity.GetAbsOrigin(), QAngle( 0, 0, 0 ), DLightIPD );

			pEntTrail.SetParent( pEntity );
			pEntSprite.SetParent( pEntity );
			pDLight.SetParent( pEntity );
		}

		else if ( strClassname == "item_healthkit" )
		{
			SpawnAntidote( pEntity );
		}
	}

	return HOOK_CONTINUE;
}

//CSZM Related Funcs
void OnProcessRound()
{
	if ( bIsCSZM )
	{
		RoundManager.SetCurrentRoundTime( CONST_ROUND_TIME_GAME + Globals.GetCurrentTime() );
		RoundManager.SetZombieLives( CONST_ZOMBIE_LIVES );

		if ( flRTWait != 0 && flRTWait <= Globals.GetCurrentTime() )
		{
			RoundTimer();
		}

		if ( flWUWait != 0 && flWUWait <= Globals.GetCurrentTime() )
		{
			WarmUpTimer();
		}

		if ( flWeakZombieWait != 0 && flWeakZombieWait <= Globals.GetCurrentTime() )
		{
			bSpawnWeak = false;
		}

		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			CZP_Player@ pPlayer = ToZPPlayer( i );
							
			if ( pPlayer is null )
			{
				continue;
			}
							
			CBaseEntity@ pBaseEnt = FindEntityByEntIndex( i );

			if ( g_flSlowTime[i] <= Globals.GetCurrentTime() && g_flSlowTime[i] != 0 )
			{
				g_flSlowTime[i] = 0.0f;
				g_flAddTime[i] = 0.0f;
				g_flRecoverTime[i] = Globals.GetCurrentTime() + CONST_RECOVER_UNIT;
			}

			if ( g_flRecoverTime[i] <= Globals.GetCurrentTime() && g_flRecoverTime[i] != 0 )
			{
				g_flRecoverTime[i] = Globals.GetCurrentTime() + CONST_RECOVER_UNIT;
				g_iSlowSpeed[i] += 2;

				if ( g_iSlowSpeed[i] >= g_iNormalSpeed[i] )
				{
					g_flRecoverTime[i] = 0;
					g_iSlowSpeed[i] = 0;
					pPlayer.SetMaxSpeed( g_iNormalSpeed[i] );
				}
					
				else pPlayer.SetMaxSpeed( g_iSlowSpeed[i] );
			}

			if ( pBaseEnt.GetTeamNumber() == TEAM_ZOMBIES && pBaseEnt.IsAlive() )
			{
				bool bAllowIdleSound = false;

				if ( pPlayer.IsCarrier() && g_bIsFirstInfected[i] )
				{
					bAllowIdleSound = true;
				}

				if ( !pPlayer.IsCarrier() )
				{
					bAllowIdleSound = true;
				}

				if ( bAllowIdleSound && g_flIdleTime[i] <= Globals.GetCurrentTime() && g_flIdleTime[i] != 0 )
				{
					if ( pBaseEnt.GetWaterLevel() != WL_Eyes )
					{
						Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Idle" + g_iCVSIndex[pBaseEnt.entindex()] );
					}

					switch( g_iCVSIndex[i] )
					{
						case 2:
							g_flIdleTime[i] = Globals.GetCurrentTime() + Math::RandomFloat( 3.0f, 6.65f );
						break;
						
						case 3:
							g_flIdleTime[i] = Globals.GetCurrentTime() + Math::RandomFloat( 3.75f, 9.75f );
						break;

						default:
							g_flIdleTime[i] = Globals.GetCurrentTime() + Math::RandomFloat( 3.15f, 12.10f );
						break;	
					}
				}
			}
		}
	}
}

void OnNewRound()
{
	if ( bIsCSZM )
	{
		bSpawnWeak = true;
		bAllowZombieSpawn = false;
		iFZIndex = 0;
		flRTWait = 0;
		flWUWait = 0;
		flWeakZombieWait = 0;
		
		for ( int i = 1; i <= iMaxPlayers; i++ ) 
		{
			g_iAntidote[i] = 0;
			g_iZMDeathCount[i] = -1;

			g_iKills[i] = 0;
			g_iVictims[i] = 0;
				
			g_bIsFirstInfected[i] = false;
			g_bIsVolunteer[i] = false;
			g_bIsAbuser[i] = false;
			g_bIsWeakZombie[i] = true;

			ZeroingSlowdown( i, true );
		}
	}
}

void OnMatchStarting()
{
	if ( bIsCSZM )
	{
		bAllowZombieSpawn = false;
		pSoloMode.SetValue( "1" );

		iStartCoundDown = CONST_ROUND_TIME + CONST_TURNING_TIME;
		iSeconds = CONST_ROUND_TIME_FULL;
		ShowTimer( 10.25f );
	}
}

void OnMatchBegin() 
{
	if ( bIsCSZM )
	{
		Schedule::Task( 0.5f, "LocknLoad" );
		Schedule::Task( ( 0.75f ), "RemoveExtraPills" );

		if ( iWUSeconds == 0 )
		{
			PutPlrToLobby( null );
			SetDoorFilter( TEAM_SPECTATORS );
			iWUSeconds = CONST_WARMUP_TIME;
		}
	}
}

void LocknLoad()
{
	flRTWait = Globals.GetCurrentTime();
	
	RoundManager.SetRounds( 10 );
	RoundManager.SetCurrentRoundTime( 2700 );

	Engine.EmitSound( "CS_MatchBeginRadio" );
	
	Globals.SetPlayerRespawnDelay( true, CONST_SPAWN_DELAY );
	
	ShowChatMsg( strRoundBegun, TEAM_SURVIVORS );

	DecideFirstInfected();

	for( int i = 1; i <= iMaxPlayers; i++ )
	{
		CBaseEntity@ pEntPlayer = FindEntityByEntIndex( i );

		if ( pEntPlayer is null )
		{
			continue;
		}

		if ( pEntPlayer.GetTeamNumber() == TEAM_LOBBYGUYS )
		{
			lobby_hint( ToZPPlayer( i ) );
			continue;
		}

		if ( pEntPlayer.GetTeamNumber() == TEAM_SURVIVORS && g_CONST_INFECT_DELAY[i] > 0 )
		{
			g_CONST_INFECT_DELAY[i]--;
		}
	}
}

void OnMatchEnded() 
{
	if ( bIsCSZM )
	{
		pSoloMode.SetValue( "0" );

		for ( int i = 1; i <= iMaxPlayers; i++ ) 
		{
			CZP_Player@ pPlr = ToZPPlayer( i );

			if ( pPlr is null )
			{
				continue;
			}

			ShowStatsEnd( pPlr, g_iKills[i], g_iVictims[i] );
		}
	}
}

int ChooseVolunteer()
{
	int iCount = 0;
	int iVIndex = 0;
	
	array<int> p_VolunteerIndex = {0};
	
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
        CBaseEntity@ pPlrEntity = FindEntityByEntIndex( i );
		
		if ( pPlrEntity is null )
		{
			continue;
		}
		
		if ( g_bIsVolunteer[i] && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS && pPlrEntity.IsAlive() )
		{
			iCount++;
			p_VolunteerIndex.insertLast( i );
		}
	}
	
	if ( iCount != 0 )
	{
		int iLength = p_VolunteerIndex.length() - 1;

		if ( iLength == 1 )
		{
			iVIndex = p_VolunteerIndex[1];
		}

		else
		{
			iVIndex = p_VolunteerIndex[Math::RandomInt( 1, iLength )];
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
	
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CBaseEntity@ pPlrEntity = FindEntityByEntIndex( i );
		
		if ( pPlrEntity is null )
		{
			continue;
		}
		
		if ( !g_bWasFirstInfected[i] && pPlrEntity.IsAlive() && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS && g_CONST_INFECT_DELAY[i] < 2 )
		{
			iCount++;
			p_VictimIndex.insertLast( i );
		}
	}
	
	if ( iCount != 0 )
	{
		int iLength = p_VictimIndex.length() - 1;
		if ( iLength > 1 )
		{
			iVicIndex = p_VictimIndex[Math::RandomInt( 1, iLength )];
		}

		else
		{
			iVicIndex = p_VictimIndex[1];
		}
	}

	if ( iCount == 0 )
	{
		CZP_Player@ pVictim = GetRandomPlayer( survivor, true );
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
	
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
		
		if ( pPlayer is null )
		{
			continue;
		}
		
		iPlr++;
		if ( g_bWasFirstInfected[i] )
		{
			iPlrWasFZ++;
		}
	}
	
	if ( iPlrWasFZ >= iPlr )
	{
		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			g_bWasFirstInfected[i] = false;
		}
	}

	if ( iFZIndex == 0 )
	{
		iFZIndex = ChooseVolunteer();
	}

	if ( iFZIndex == 0 )
	{
		iFZIndex = ChooseVictim();
	}
}

void RoundTimer()
{
	if ( Utils.GetNumPlayers( survivor, false ) == 0 )
	{
		RoundManager.SetWinState( STATE_STALEMATE );
	}

	float flHTime = 0.0f;

	flRTWait = Globals.GetCurrentTime() + 1.0f;

	if ( iSeconds <= iStartCoundDown && iSeconds >= CONST_ROUND_TIME )
	{
		ShowFICountdown();
	}

	if ( iSeconds == CONST_ROUND_TIME )
	{
		TurnFirstInfected();
	}

	if ( iSeconds - CONST_ROUND_TIME <= 10 && iSeconds > CONST_ROUND_TIME )
	{
		EmitCountdownSound( iSeconds - CONST_ROUND_TIME );
	}

	if ( iSeconds == 0 )
	{
		flRTWait = 0;
		flHTime = 10.25f;
		EndGame();
	}

	ShowTimer( flHTime );

	if ( iSeconds > 0 )
	{
		iSeconds--;
	}
}

void ShowFICountdown()
{
	if ( iFZIndex != 0 )
	{
		CBaseEntity@ pPlrEntity = FindEntityByEntIndex( iFZIndex );
		CZP_Player@ pPlayer = ToZPPlayer( pPlrEntity );

		if ( pPlrEntity.IsAlive() && pPlrEntity.GetTeamNumber() == TEAM_SURVIVORS )
		{
			string strPTMAddon = strBecomFI;
			string strPreTurnMsg = strPTMAddon + strTurningIn + flShowSeconds + strSecs;
			if ( flShowSeconds == 1 )
			{
				strPreTurnMsg = strPTMAddon + strTurningIn + flShowSeconds + strSec;
			}
				
			int iR = Math::RandomInt( 0, 128 );
			int iG = Math::RandomInt( 135, 255 );
			int iB = Math::RandomInt( 135, 255 );
				
			SendGameTextPlayer( pPlayer, strPreTurnMsg, 1, 0, -1, 0.35, 0, 0, 0.075, Color( iR, iG, iB ), Color( 0, 0, 0 ) );
		}

		if ( iSeconds >= CONST_ROUND_TIME && iSeconds <= iStartCoundDown )
		{
			Schedule::Task( 0.05f, "ShowFICountdown" );
		}
	}
	else
	{
		DecideFirstInfected();
	}
}

void SetShowTime()
{
	flShowHours = floor( iSeconds / 3600 );
	flShowMinutes = floor( ( iSeconds - flShowHours * 3600 ) / 60 );
	flShowSeconds = floor( iSeconds - ( flShowHours * 3600 ) - ( flShowMinutes * 60 ) );
}

void ShowTimer( float &in flHoldTime )
{
	SetShowTime();

	string SZero = "0";
	string MZero = "0";
	
	if ( flShowMinutes <= 9 )
	{
		MZero = "0";
	}

	else
	{
		MZero = "";
	}
	
	if ( flShowSeconds <= 9 )
	{
		SZero = "0";
	}

	else
	{
		SZero = "";
	}

	string TimerText = MZero + flShowMinutes + ":" + SZero + flShowSeconds;

	if ( flHoldTime <= 0 )
	{
		flHoldTime = 1.08f;
	}
	
	SendGameText( any, TimerText, 0, 1, -1, 0, 0, 0, flHoldTime, Color( 235, 235, 235 ), Color( 0, 0, 0 ) );
}

void ShowOutbreak( int &in iIndex )
{
	CZP_Player@ pFirstInf = ToZPPlayer( iIndex );
	string strColor = "blue";
	if ( g_bIsVolunteer[iIndex] )
	{
		strColor = "violet";
	}
	
	for ( int i = 1; i <= iMaxPlayers; i++ )
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
		
		if ( pPlayer is null )
		{
			continue;
		}
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if ( i != iIndex )
		{
			Chat.PrintToChatPlayer( pPlrEnt, "{" + strColor + "}" + pFirstInf.GetPlayerName() + strBecameFi );
		}
	}

	SendGameText( any, strOutbreakMsg, 1, 0, -1, 0.175, 0, 0.35, 6.75, Color( 64, 255, 128 ), Color( 0, 255, 0 ) );
}

void EndGame()
{
	if ( Utils.GetNumPlayers( survivor, true ) > 0 ) 
	{
		RoundManager.SetWinState( ws_HumanWin );
	}

	else if ( Utils.GetNumPlayers( zombie, true ) == 0 ) 
	{
		RoundManager.SetWinState( ws_Stalemate );
	}

	else
	{
		RoundManager.SetWinState( ws_ZombieWin );
	}
}

void AddSlowdown( const int &in iIndex, const float &in flDamage, const int &in iDamageType )
{
	CZP_Player@ pPlayer = ToZPPlayer( iIndex );

	if ( pPlayer is null )
	{
		return;
	}

	CBaseEntity@ pPlayerEntity = FindEntityByEntIndex( iIndex );

	g_flRecoverTime[iIndex] = 0.0f;

	bool bFreeze = false;
	int iSpeed = int( ( g_iNormalSpeed[iIndex] * 0.01 ) * CONST_SLOWDOWN_MULT );
	float p_flAddTime = 0.0f;

	//Reduce the slowdown speed if weak zombie
	if ( g_bIsWeakZombie[iIndex] )
	{
		iSpeed * CONST_SLOWDOWN_WEAKMULT;
	}

	//Add time if critical dmg
	if ( flDamage > CONST_SLOWDOWN_CRITDMG )
	{
		p_flAddTime = 0.35f;
	}

	//Melee
	if ( bDamageType( iDamageType, 7 ) )
	{
		bFreeze = true;
		p_flAddTime = 2.0f;
	}

	//Blast
	if ( bDamageType( iDamageType, 6 ) )
	{
		bFreeze = true;
		p_flAddTime = 1.85f;
	}

	//Blast Surface
	if ( bDamageType( iDamageType, 27 ) )
	{
		bFreeze = true;
		p_flAddTime = 1.40f;
	}

	//Fall
	if ( bDamageType( iDamageType, 5 ) )
	{
		bFreeze = true;
		p_flAddTime = 0.65f;
	}

	//If First infected - reduce iSpeed
	//if ( g_bIsFirstInfected[iIndex] ) iSpeed = int( floor( iSpeed * 0.85f ) );

	//If Carrier - reduce iSpeed
	//if ( pPlayer.IsCarrier() && !g_bIsFirstInfected[iIndex] ) iSpeed = int( floor( iSpeed * 0.65f ) );

	g_iSlowSpeed[iIndex] = g_iNormalSpeed[iIndex] - iSpeed;

	g_flAddTime[iIndex] += p_flAddTime;

	if ( g_flAddTime[iIndex] > CONST_MAX_SLOWTIME )
	{
		g_flAddTime[iIndex] = CONST_MAX_SLOWTIME;
	}

	g_flSlowTime[iIndex] = Globals.GetCurrentTime() + g_flAddTime[iIndex];

	if ( g_iSlowSpeed[iIndex] < SPEED_MINIMUM )
	{
		g_iSlowSpeed[iIndex] = SPEED_MINIMUM;
	}

	pPlayer.SetMaxSpeed( g_iSlowSpeed[iIndex] );

	if ( bFreeze )
	{
		pPlayerEntity.SetAbsVelocity( Vector( 0, 0, 0 ) );
	}

/*	SD("------------------------------");
	SD( "iSpeed: " + iSpeed + "\ng_iSlowSpeed: " + g_iSlowSpeed[iIndex] + "\ng_flAddTime: " + g_flAddTime[iIndex] + "\ng_iNormalSpeed: " + g_iNormalSpeed[iIndex] );
	SD("------------------------------");*/
}

void ZeroingSlowdown( const int &in iIndex, const bool &in bIsConnected )
{
	if ( bIsConnected )
	{
		g_iNormalSpeed[iIndex] = SPEED_DEFAULT;
	}

	g_flSlowTime[iIndex] = 0.0f;
	g_flRecoverTime[iIndex] = 0.0f;
	g_flAddTime[iIndex] = 0.0f;
	g_iSlowSpeed[iIndex] = 0;
}

void GotVictim( CZP_Player@ pAttacker, CBaseEntity@ pBaseEntA )
{
	if ( g_iZMDeathCount[pBaseEntA.entindex()] >= 0 )
	{
		g_iZMDeathCount[pBaseEntA.entindex()] -= CONST_SUBTRACT_DEATH;
	}
		
	if ( pBaseEntA.IsAlive() )
	{
		pBaseEntA.SetHealth( pBaseEntA.GetHealth() + CONST_REWARD_HEALTH );
	}

	AddTime( CONST_INFECT_ADD_TIME );
}

void AddTime( const int &in iTime )
{
	if ( RoundManager.IsRoundOngoing( false ) && Utils.GetNumPlayers( survivor, true ) > 1 && bAllowAddTime )
	{
		int iOverTimeMult = 1;
	
		if ( iSeconds <= 0 )
		{
			iOverTimeMult = 3;
		}
	
		if ( iSeconds < 35 && iTime > 0 )
		{
			iSeconds += ( iTime * iOverTimeMult );
			ShowTimer( 0 );
			SendGameText( any, "\n+ "+( iTime * iOverTimeMult )+" Seconds", 1, 1, -1, 0.0025f, 0, 0.35f, 1.75f, Color( 255, 175, 85 ), Color( 0, 0, 0 ) );
		}
	}
}

void TurnFirstInfected()
{
	int iSurvCount = Utils.GetNumPlayers( survivor, true );
	if ( iSurvCount < 4 )
	{
		iSurvCount = 4;
	}

	iFirstInfectedHP = CONST_FI_HEALTH_MULT * iSurvCount;
	flWeakZombieWait = Globals.GetCurrentTime() + CONST_WEAK_ZOMBIE_TIME;

	if ( iFZIndex == 0 )
	{
		CZP_Player@ pVictim = GetRandomPlayer( survivor, true );
		CBasePlayer@ pVPlrEnt = pVictim.opCast();
		CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();

		iFZIndex = pVBaseEnt.entindex();
	}

	int iInfDelay = 1;
	if ( g_bIsVolunteer[iFZIndex] ) 
	{
		g_bIsVolunteer[iFZIndex] = false;
		iInfDelay = CONST_INFECT_DELAY;
	}
	g_bIsFirstInfected[iFZIndex] = true;
	g_CONST_INFECT_DELAY[iFZIndex] += iInfDelay;
	ShowOutbreak( iFZIndex );
	TurnToZ( iFZIndex );

	for( int i = 1; i <= iMaxPlayers; i++ )
	{
		CBaseEntity@ pEntPlayer = FindEntityByEntIndex( i );

		if ( pEntPlayer is null )
		{
			continue;
		}

		if ( pEntPlayer.GetTeamNumber() != TEAM_LOBBYGUYS )
		{
			continue;
		}
	
		lobby_hint( ToZPPlayer( i ) );
	}
}

void TurnToZ( const int &in iIndex )
{
	if ( iIndex != 0 && iIndex > 0 )
	{
		if ( iIndex == iFZIndex )
		{
			iFZIndex = 0;
		}

		CZP_Player@ pPlayer = ToZPPlayer( iIndex );

		if ( pPlayer !is null )
		{
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if ( g_bIsFirstInfected[iIndex] )
			{
				pSoloMode.SetValue( "0" );
				bAllowZombieSpawn = true;
				Engine.EmitSound( "CS_FirstTurn" );
				g_bWasFirstInfected[iIndex] = true;
			}

			g_bIsWeakZombie[iIndex] = false;

			g_flIdleTime[iIndex] = Globals.GetCurrentTime() + Math::RandomFloat( 3.15f, 12.10f );

			g_iNormalSpeed[iIndex] = SPEED_ZOMBIE;
			pPlayer.SetMaxSpeed( SPEED_ZOMBIE );

			pPlayer.SetArmModel( "models/cszm/weapons/c_css_zombie_arms.mdl" );

			EmitBloodExp( pPlayer, false );

			pPlayer.CompleteInfection();

			if ( g_bIsFirstInfected[iIndex] )
			{
				pPlayer.SetCarrier( true );
			}

			Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Mute" );
			Engine.EmitSoundEntity( pBaseEnt, "Flesh.HeadshotExplode" );
			Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Turn" );

			RndZModel( pPlayer, pBaseEnt );
			SetZMHealth( pBaseEnt );
		}
	}
}

void SpawnWeakZombie( CZP_Player@ pPlayer )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	const int iIndex = pBaseEnt.entindex();

	if ( pPlayer.IsCarrier() ) 
	{
		pBaseEnt.SetModel( "models/cszm/carrier.mdl" );
		pPlayer.SetArmModel( "models/weapons/arms/c_carrier.mdl" );
	}
	
	else 
	{
		pBaseEnt.SetModel( "models/cszm/zombie_charple.mdl" );
		pPlayer.SetArmModel( "models/cszm/weapons/c_css_zombie_arms.mdl" );
	}

	Utils.CosmeticWear( pPlayer, "models/cszm/weapons/w_knife_t.mdl" );
	pBaseEnt.SetMaxHealth( 15 );
	pBaseEnt.SetHealth( CONST_WEAK_ZOMBIE_HP );
	pPlayer.SetMaxSpeed( SPEED_WEAK );
	g_iCVSIndex[iIndex] = 2;
	g_iNormalSpeed[iIndex] = SPEED_WEAK;

	Chat.PrintToChatPlayer( pPlrEnt, strWeakZombie );
}

void EmitBloodExp( CZP_Player@ pPlayer, const bool &in bIsSilent )
{
	if ( pPlayer is null )
	{
		return;
	}

	Utils.ScreenFade( pPlayer, Color( 125, 35, 30, 145 ), 0.375, 0.0, fade_in );

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	CEntityData@ CameraBloodIPD = EntityCreator::EntityData();
	CameraBloodIPD.Add( "targetname", "PS-Turn-Head" );
	CameraBloodIPD.Add( "flag_as_weather", "0" );
	CameraBloodIPD.Add( "start_active", "1" );
	CameraBloodIPD.Add( "effect_name", "blood_impact_red_01_headshot" );

	CameraBloodIPD.Add( "kill", "0", true, "0.05" );

	CEntityData@ BodyBloodIPD = EntityCreator::EntityData();
	BodyBloodIPD.Add( "targetname", "PS-Turn" );
	BodyBloodIPD.Add( "flag_as_weather", "0" );
	BodyBloodIPD.Add( "start_active", "1" );
	BodyBloodIPD.Add( "effect_name", "blood_explode_01" );

	BodyBloodIPD.Add( "kill", "0", true, "0.05" );

	EntityCreator::Create( "info_particle_system", pBaseEnt.EyePosition(), pBaseEnt.EyeAngles(), CameraBloodIPD );
	EntityCreator::Create( "info_particle_system", pBaseEnt.GetAbsOrigin(), pBaseEnt.GetAbsAngles(), BodyBloodIPD );
	
	if ( !bIsSilent )
	{
		Engine.EmitSoundEntity( pBaseEnt, "Flesh.HeadshotExplode" );
	}
}

void RndZModel( CZP_Player@ pPlayer, CBaseEntity@ pEntPlr )
{
	Utils.CosmeticWear( pPlayer, "models/cszm/weapons/w_knife_t.mdl" );
	
	int iRND_CVS = Math::RandomInt( 1, 3 );
	
	if ( iRND_CVS_PV == iRND_CVS )
	{
		while ( iRND_CVS_PV == iRND_CVS )
		{
			iRND_CVS = Math::RandomInt( 1, 3 );
		}
	}

	g_iCVSIndex[pEntPlr.entindex()] = iRND_CVS;
	iRND_CVS_PV = iRND_CVS;
	
	if ( g_bIsFirstInfected[pEntPlr.entindex()] )
	{
		pEntPlr.SetModel( "models/cszm/zombie_morgue.mdl" );
	}

	else 
	{	
		if ( pPlayer.IsCarrier() )
		{
			pEntPlr.SetModel( "models/cszm/carrier.mdl" );
		}

		else
		{
			if( g_strMDLToUse.length() == 0 )
			{
				for ( uint i = 0; i < g_strModels.length(); i++ )
				{
					g_strMDLToUse.insertLast( g_strModels[i] );
				}
			}

			int iRNG = Math::RandomInt( 0, g_strMDLToUse.length() - 1 );

			pEntPlr.SetModel( g_strMDLToUse[iRNG] );
			g_strMDLToUse.removeAt( iRNG );
		}
	}
}

void SetZMHealth( CBaseEntity@ pEntPlr )
{
	int iZombCount = Utils.GetNumPlayers( zombie, false );
	float flMultiplier = 0.5;
	
	switch( iZombCount )
	{
		case 1:
			flMultiplier = 1.95f;
		break;
		
		case 2:
			flMultiplier = 0.95f;
		break;
		
		default:
			flMultiplier = 0.5;
		break;
	}
	
	if ( g_iZMDeathCount[pEntPlr.entindex()] < 0 )
	{
		g_iZMDeathCount[pEntPlr.entindex()] = 0;
	}
	
	int iHPBonus = g_iZMDeathCount[pEntPlr.entindex()] * CONST_DEATH_BONUS_HP;
	
	CZP_Player@ pPlayer = ToZPPlayer( pEntPlr );

	int iArmor = pPlayer.GetArmor();

	if ( iArmor > 0 )
	{
		pPlayer.SetArmor( 0 );
	}
	
	if ( !pPlayer.IsCarrier() )
	{
		pEntPlr.SetMaxHealth( pEntPlr.GetMaxHealth() + CONST_ZOMBIE_ADD_HP + iHPBonus );
		pEntPlr.SetHealth( pEntPlr.GetHealth() + ( CONST_ZOMBIE_ADD_HP / 4 ) + iHPBonus + iArmor );
	}

	else if ( pPlayer.IsCarrier() && !g_bIsFirstInfected[pEntPlr.entindex()] )
	{
		pEntPlr.SetMaxHealth( pEntPlr.GetMaxHealth() + int( float( CONST_CARRIER_HP ) + ( float( iHPBonus ) * flMultiplier ) ) );
		pEntPlr.SetHealth( pEntPlr.GetHealth() + int( float( CONST_CARRIER_HP ) + ( float( iHPBonus ) * flMultiplier ) ) + iArmor );
	}

	else
	{
		pEntPlr.SetMaxHealth( iFirstInfectedHP / 3 );
		pEntPlr.SetHealth( iFirstInfectedHP + iArmor );
	}
}

//WarmUp Related Funcs
void WarmUpTimer()
{
	int iNumPlrs = 0;
	iNumPlrs += CountPlrs( 0 );

	if ( bWarmUp && iNumPlrs >= 2 )
	{
		flWUWait = Globals.GetCurrentTime() + 1.0f;

		string TimerText = "\n\n\n"+strWarmUp+"\n| "+iWUSeconds+" |";
		SendGameText( any, TimerText, 1, 0.0f, -1, 0.0f, 0.0f, 0.0f, 1.10f, Color( 255, 175, 85 ), Color( 255, 95, 5 ) );

		if ( iWUSeconds == 0 )
		{
			WarmUpEnd();
		}

		if ( iWUSeconds > 0 )
		{
			iWUSeconds--;
		}
	}
	else if ( iNumPlrs <= 1 )
	{
		flWUWait = 0;
		iWUSeconds = CONST_WARMUP_TIME;
		SendGameText( any, strAMP, 1, 0.0f, -1, 0.0f, 0.0f, 0.0f, 600.0f, Color( 255, 255, 255 ), Color( 255, 95, 5 ) );
	}
}

void WarmUpEnd()
{
	if ( bWarmUp )
	{
		bWarmUp = false;
	}
	
	flWUWait = 0;

	Engine.EmitSound( "@buttons/button3.wav" );
	
	string TimerText = "\n\n\n"+strWarmUp+"\n| 0 |";
	SendGameText( any, TimerText, 1, 0.0f, -1, 0.0f, 0.0f, 0.35f, 0.05f, Color( 255, 175, 85 ), Color( 255, 95, 5 ) );

	SendGameText( any, "", 3, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, Color( 0, 0, 0 ), Color( 0, 0, 0 ) );

	SendGameText( any, strHintF1, 3, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color( 64, 128, 255 ), Color( 255, 95, 5 ) );

	if ( !RoundManager.IsRoundOngoing( false ) )
	{
		SendGameText( any, "\n" + strHintF2Inf, 4, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color( 255, 32, 64 ), Color( 255, 95, 5 ) );
	}

	else
	{
		SendGameText( any, "\n" + strHintF2, 4, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color( 255, 32, 64 ), Color( 255, 95, 5 ) );
	}

	SendGameText( any, "\n\n" + strHintF3, 5, 0.0f, 0.05f, 0.10f, 0.0f, 2.0f, 120.0f, Color( 255, 255, 255 ), Color( 255, 95, 5 ) );
}