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

bool bAllowDebug = false;				//Allow Debug?

//Some Data
CASConVar@ pSoloMode = null;
CASConVar@ pTestMode = null;
CASConVar@ pINGWarmUp = null;
CASConVar@ pFriendlyFire  = null;
CASConVar@ pInfectionRate   = null;

int iMaxPlayers;
int iDoorsState;

bool bIsCSZM;							//Is CSZM available? ( Depends on a map )

bool bIsFirstITurns;
bool bSpawnWeak = true;
bool bAllowCD;
bool bAllowZombieSpawn;
bool bAllowFZColor;
bool bAllowAddTime = true;				//Allow add time for successful infection
bool bAllowWarmUp = true;

//Win Countes
int iHumanWin;
int iZombieWin;

//GamePlay Consts
//Player Speed
const int iDefSpeed = 210;
const int iHumanSpeed = 197; 
const int iZombieSpeed = 170;
const int iCarrierSpeed = 189;
const int iWeakSpeed = 251;
const int iMinSpeed = 80;

//Damage Slowdown
const float flMaxSlowTime = 1.0f;
const float flRecoverUnit = 0.09f;

//Damage Slowdown arrays
array<int> g_iDefSpeed;
array<int> g_iSlowSpeed;
array<float> g_flSlowTime;
array<float> g_flAddTime;
array<float> g_flRecoverTime;

//Other Consts
const float flHPRDelay = 0.42f;									//Amount of time you have to wait to start HP Regeneration. ( Custom HP Regeneration )
const float flSpawnDelay = 5.00f;								//Zombies spawn delay.
const int iFirstInfectedHPMult = 125;							//HP multiplier of first infected.
const int iZombieMaxHP = 200;									//Additional HP to Max Health of a zombie.
const int iWeakZombieHP = 125;									//Health of the weak zombies
const int iHPReward = 125;										//Give that amount of HP as reward of successful infection.
const int iGearUpTime = 40;										//Time to gear up and find a good spot.
const int iTurningTime = 20;									//Turning time.
const int iInfectDelay = 3;										//Amount of rounds you have to wait to be the First Infected again.
const int iWUTime = 4;											//Time of the warmup in seconds.		( default value is 76 )

//New Consts
const bool bAllowTimeHP = true;									//Allow Time HP Bonus
const float flBlockZSTime = 45.00f;								//Amount of time in seconds which abusers must wait to join the zombie team.
const float flCSDDivider = 4.00f;								//Damage Slowdown divider of the carrier.
const float flFISDDivider = 1.85f;								//Damage Slowdown divider of the first infected.
const int iSubtractDeath = 2;									//Amount of units subtract from the death counter
const int iInfectionATSec = 15;									//Amount of time in seconds add to the round time in case of successful infection
const int iCarrierMaxHP = 0;									//Additional HP to Max Health of the carrier.	( Currently equal 0 because the carrier is too OP )
const int iDHPBonus = 100;										//Multiplier of death hp bonus.
const int iTHPBonus = 45;										//Multiplier of time hp bonus.
const int iMaxDeath = 7;										//Maximum amount of death to boost up the max health.
const int iDefaultTHPSeconds = 30;								//Amount of time in seconds to increase amount of the time hp bonus.
const int iRoundTime = 300 + iGearUpTime;						//Round time in seconds.
const int iSoT = iRoundTime - iGearUpTime + iTurningTime;		//Second of the turning time start countdown. DON'T TOUCH THIS!!!!
const float flBaseSDMult = 1.01f;								//Base value of the damage slowdown
const float flMaxSDMult = 0.25f;								//Maximum value of the damage slowdown
const float flBaseRecoverTime = 0.055f;							//Base recover Time

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
const string strHintF4WU = "F4 - Respawn";
const string strLastZLeave = "{red}WARNING{default}: Last player in the Zombie team has leave.\n{blue}Round Restarting....";
const string strAMP = "Awaiting More Players";
const string strWarmUp = "-= Warm Up! =-";
const string strWeakZombie = "{cornflowerblue}*You're spawned as weak zombie!";

//List of available ZM Player models ( make sure your server has it )
array<string> g_strModels = 
{
	"models/cszm/carrier.mdl",
	"models/cszm/zombie_classic.mdl",
	"models/cszm/zombie_sci.mdl",
	"models/cszm/zombie_corpse1.mdl",
	"models/cszm/zombie_charple2.mdl",
	"models/cszm/zombie_sawyer.mdl",
	"models/cszm/zombie_eugene.mdl"
};

array<bool> g_bIsModelNotUsed;

//Other arrays ( Don't even touch this )
array<float> g_flIdleTime;
array<float> g_flHPRDelay;
array<int> g_iInfectDelay;
array<int> g_iZMDeathCount;

array<int> g_iCVSIndex;
array<bool> g_bWasFirstInfected;
array<bool> g_bIsVolunteer;
array<bool> g_bIsSpawned;
array<bool> g_bIsFirstInfected;
array<bool> g_bIsAbuser;
array<bool> g_bIsWeakZombie;

//Other Data ( Don't even touch this )
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

#include "./cszm/misc.as"

void OnPluginInit()
{
	PluginData::SetVersion( "1.0");
	PluginData::SetAuthor( "dR.Vodker");
	PluginData::SetName( "Counter-Strike Zombie Mode");

	//Find 'sv_zps_solo' ConVar
	@pSoloMode = ConVar::Find( "sv_zps_solo" );
	if ( pSoloMode !is null ) ConVar::Register( pSoloMode, "ConVar_SoloMode" );

	//Find 'sv_testmode' ConVar
	@pTestMode = ConVar::Find( "sv_testmode" );
	if ( pTestMode !is null ) ConVar::Register( pTestMode, "ConVar_TestMode" );

	//Find 'sv_zps_warmup' ConVar
	@pINGWarmUp = ConVar::Find( "sv_zps_warmup" );
	if ( pINGWarmUp !is null ) ConVar::Register( pINGWarmUp, "ConVar_WarmUpTime" );

	//Find 'mp_friendlyfire' ConVar
	@pFriendlyFire = ConVar::Find( "mp_friendlyfire" );
	if ( pFriendlyFire !is null ) ConVar::Register( pFriendlyFire, "ConVar_FriendlyFire" );

	//Find 'sv_zps_infectionrate' ConVar
	@pInfectionRate = ConVar::Find( "sv_zps_infectionrate" );
	if ( pInfectionRate !is null ) ConVar::Register( pInfectionRate, "ConVar_InfectionRate" ); 

	//Events
	Events::Player::OnPlayerInfected.Hook( @OnPlayerInfected );
	Events::Player::OnPlayerConnected.Hook( @OnPlayerConnected );
	Events::Player::OnPlayerSpawn.Hook( @OnPlayerSpawn );
	Events::Entities::OnEntityCreation.Hook( @OnEntityCreation );
	Events::Player::OnPlayerDamaged.Hook( @OnPlayerDamaged );
	Events::Player::OnPlayerKilled.Hook( @OnPlayerKilled );
	Events::Player::OnPlayerDisonnected.Hook( @OnPlayerDisonnected );
	Events::Rounds::RoundWin.Hook( @RoundWin );
	Events::Player::OnPlayerRagdollCreate.Hook( @OnPlayerRagdollCreate );
	Events::Player::OnConCommand.Hook( @OnConCommand );
}

void OnMapInit()
{
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		Log.PrintToServerConsole( LOGTYPE_INFO, "CSZM", "[CSZM] Current map is valid for 'Counter-Strike Zombie Mode'");
		bIsCSZM = true;

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
		g_flIdleTime.resize( iMaxPlayers + 1 );
		g_iCVSIndex.resize( iMaxPlayers + 1 );
		g_bWasFirstInfected.resize( iMaxPlayers + 1 );
		g_bIsFirstInfected.resize( iMaxPlayers + 1 );
		g_bIsAbuser.resize( iMaxPlayers + 1 );
		g_bIsWeakZombie.resize( iMaxPlayers + 1 );
		g_bIsVolunteer.resize( iMaxPlayers + 1 );
		g_flHPRDelay.resize( iMaxPlayers + 1 );
		g_iInfectDelay.resize( iMaxPlayers + 1 );
		g_iZMDeathCount.resize( iMaxPlayers + 1 );
		g_bIsSpawned.resize( iMaxPlayers + 1 );
		g_iAntidote.resize( iMaxPlayers + 1 );
		g_iKills.resize( iMaxPlayers + 1 );
		g_iVictims.resize( iMaxPlayers + 1 );

		//Resize Damage Slowdown arrays
		g_iDefSpeed.resize( iMaxPlayers + 1 );
		g_iSlowSpeed.resize( iMaxPlayers + 1 );
		g_flSlowTime.resize( iMaxPlayers + 1 );
		g_flRecoverTime.resize( iMaxPlayers + 1 );
		g_flAddTime.resize( iMaxPlayers + 1 );
		
		g_bIsModelNotUsed.resize( g_strModels.length() );
		
		for ( uint i = 0; i <= g_strModels.length() - 1; i++ )
		{
			g_bIsModelNotUsed[i] = true;
		}
		
		//Set Doors Filter to 0 ( any team )
		if ( bAllowWarmUp == true ) SetDoorFilter( 0 );
	
	}
	else
	{
		Log.PrintToServerConsole( LOGTYPE_INFO, "CSZM", "[CSZM] Current map is not valid for 'Counter-Strike Zombie Mode'");
	}
}

void OnMapShutdown()
{
	if ( bIsCSZM == true )
	{
		pSoloMode.SetValue( "0" );

		bIsCSZM = false;
		Engine.EnableCustomSettings( false );
		iSeconds = 0;
		iSAt = 0;
		iFZTurningTime = 0;
		iFZIndex = 0;
		iTimeHPBonus = 0;
		iTimeHPBonusSeconds = iDefaultTHPSeconds;
		iWUSeconds = iWUTime;

		iHumanWin = 0;
		iZombieWin = 0;
		
		Entities::RemoveRegisterPickup( "item_deliver" );
		Entities::RemoveRegisterUse( "item_deliver" );
		Entities::RemoveRegisterDrop( "item_deliver" );
		
		bAllowCD = false;
		bIsFirstITurns = false;
		bSpawnWeak = true;
		bAllowZombieSpawn = false;
		bAllowFZColor = false;
		bETimeHP = false;
		bAllowWarmUp = true;
		
		ClearBoolArray( g_bWasFirstInfected );
		ClearBoolArray( g_bIsFirstInfected );
		ClearBoolArray( g_bIsAbuser );
		ClearBoolArray( g_bIsWeakZombie );
		ClearBoolArray( g_bIsVolunteer );
		ClearBoolArray( g_bIsSpawned );
		ClearBoolArray( g_bIsModelNotUsed );
		ClearIntArray( g_iKills );
		ClearIntArray( g_iVictims );
		ClearIntArray( g_iCVSIndex );
		ClearIntArray( g_iInfectDelay );
		ClearIntArray( g_iZMDeathCount );
		ClearIntArray( g_iAntidote );
		ClearIntArray( g_iDefSpeed );
		ClearIntArray( g_iSlowSpeed );
		ClearFloatArray( g_flHPRDelay );
		ClearFloatArray( g_flSlowTime );
		ClearFloatArray( g_flRecoverTime );
		ClearFloatArray( g_flAddTime );
		ClearFloatArray( g_flIdleTime );
	}
}


HookReturnCode OnPlayerRagdollCreate( CZP_Player@ pPlayer, bool &in bHeadshot, bool &out bExploded )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( Utils.StrContains( "cszm", pBaseEnt.GetModelName() ) ) bHeadshot = false;

	return HOOK_CONTINUE;
}

HookReturnCode RoundWin( const string &in strMapname, RoundWinState iWinState )
{
	if ( bIsCSZM == true )
	{
		bAllowCD = false;
		ShowRTL( 0, 0, 15 );

		if ( iWinState == STATE_HUMAN ) Engine.EmitSound( "CS_HumanWin" );
		if ( iWinState == STATE_ZOMBIE ) Engine.EmitSound( "CS_ZombieWin" );

		if ( iWinState == STATE_HUMAN ) iHumanWin++;
		if ( iWinState == STATE_ZOMBIE ) iZombieWin++;
		
		string strHW = "\n  Humans Win - " + iHumanWin;
		string strZW = "\n  Zombies Win - " + iZombieWin;
		
		SendGameText( any, "-=Win Counter=-" + strHW + strZW, 4, 0.00f, 0, 0.35f, 0.25f, 0.00f, 10.10f, Color( 235, 235, 235 ), Color( 255, 95, 5 ) );

		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerConnected( CZP_Player@ pPlayer ) 
{
	if ( bIsCSZM == true )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

        const int iIndex = pBaseEnt.entindex();
		
		g_flIdleTime[iIndex] = 0.0f;
		g_iInfectDelay[iIndex] = 0;
		g_iAntidote[iIndex] = 0;
		g_iZMDeathCount[iIndex] = -1;
		g_flHPRDelay[iIndex] = 0.0f;
		g_iCVSIndex[iIndex] = Math::RandomInt( 1, 3 );

		g_iKills[iIndex] = 0;
		g_iVictims[iIndex] = 0;
			
		g_bWasFirstInfected[iIndex] = false;
		g_bIsFirstInfected[iIndex] = false;
		g_bIsAbuser[iIndex] = false;
		g_bIsWeakZombie[iIndex] = true;
		g_bIsVolunteer[iIndex] = false;
		g_bIsSpawned[iIndex] = false;

		ZeroingSlowdown( iIndex, true );
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnConCommand( CZP_Player@ pPlayer, CASCommand@ pArgs )
{
	if ( bIsCSZM == true )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if ( RoundManager.IsRoundOngoing( false ) == false )
		{
			if ( Utils.StrContains( "choose", pArgs.Arg( 0 ) ) && bAllowWarmUp == true ) 
			{
				if ( Utils.StrEql( "choose4", pArgs.Arg( 0 ) ) ) PutPlrToPlayZone( pBaseEnt );
				return HOOK_HANDLED;
			}

			if ( Utils.StrEql( "choose2", pArgs.Arg( 0 ) ) )
			{
				if ( pBaseEnt.GetTeamNumber() == 0 )
				{
					if ( g_iInfectDelay[pBaseEnt.entindex()] > 0 )
					{
						Chat.PrintToChatPlayer( pPlrEnt, strCannotPlayFI );
						return HOOK_HANDLED;
					}
					else
					{
						Chat.PrintToChatPlayer( pPlrEnt, strChooseToPlayFI );
						if ( g_bIsVolunteer[pBaseEnt.entindex()] != true ) g_bIsVolunteer[pBaseEnt.entindex()] = true;
					}
				}
			}
		}

		else
		{
			if ( Utils.StrEql( "choose1", pArgs.Arg( 0 ) ) || Utils.StrEql( "choose2", pArgs.Arg( 0 ) ) )
			{
				if ( bAllowZombieSpawn == false && pBaseEnt.GetTeamNumber() == 0)
				{
					pBaseEnt.ChangeTeam(2);
					pPlayer.ForceRespawn();
					pPlayer.SetHudVisibility(true);
					return HOOK_HANDLED;
				}
			}
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerSpawn( CZP_Player@ pPlayer )
{
	if ( bIsCSZM == true )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		RemoveProp( pBaseEnt );
		
		int iIndex = pBaseEnt.entindex();
		
		Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Mute" );

		ZeroingSlowdown( iIndex, false );

		switch( pBaseEnt.GetTeamNumber() )
		{
			case 2:
				g_iDefSpeed[iIndex] = iHumanSpeed;
			break;
			
			case 3:
				if ( pPlayer.IsCarrier() == true ) g_iDefSpeed[iIndex] = iCarrierSpeed;
				else g_iDefSpeed[iIndex] = iZombieSpeed;
			break;
			
			default:
				g_iDefSpeed[iIndex] = iDefSpeed;
			break;
		}

		pPlayer.SetMaxSpeed( g_iDefSpeed[iIndex] );

		if ( pBaseEnt.GetTeamNumber() != 3 ) pPlayer.SetArmModel( "models/cszm/weapons/c_css_arms.mdl" );
		else pPlayer.SetArmModel( "models/cszm/weapons/c_css_zombie_arms.mdl" );
		
		if ( pBaseEnt.GetTeamNumber() == 0 )
		{
			pBaseEnt.SetModel( "models/cszm/lobby_guy.mdl" );
			pPlayer.SetVoice( eugene );
			if ( bAllowWarmUp == false ) lobby_hint( pPlayer );
			else lobby_hint_wu( pPlayer );
		}
		
		if ( pBaseEnt.GetTeamNumber() == 1 && bAllowWarmUp == false ) spec_hint( pPlayer );
		
		if ( bAllowWarmUp == false )
		{
			if ( g_bIsFirstInfected[iIndex] == true ) g_bIsFirstInfected[iIndex] = false;
		
			if ( pBaseEnt.GetTeamNumber() != 3 && g_iZMDeathCount[iIndex] < 0 ) g_iZMDeathCount[iIndex] = -1;
			
			if ( pBaseEnt.GetTeamNumber() == 2 )
			{
				if ( g_iAntidote[iIndex] > 0 ) g_iAntidote[iIndex] = 0;
				if ( g_iInfectDelay[iIndex] > 0 ) g_iInfectDelay[iIndex]--;
				return HOOK_HANDLED;
			}
			
			if ( pBaseEnt.GetTeamNumber() == 3 && bAllowZombieSpawn == false )
			{				
				Chat.PrintToChatPlayer( pBaseEnt, strCannotJoinZT0 );
				MovePlrToSpec( pBaseEnt );
					
				return HOOK_HANDLED;
			}
			
			if ( pBaseEnt.GetTeamNumber() == 3 && bAllowZombieSpawn == true )
			{
				g_flIdleTime[iIndex] = Globals.GetCurrentTime() + 0.1f;
				g_flHPRDelay[iIndex] = Globals.GetCurrentTime() + 0.25f;

				EmitBloodExp( pPlayer, true );

				if ( bSpawnWeak == true && g_bIsWeakZombie[iIndex] ) SpawnWeakZombie( pPlayer );
				
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
			if ( pPlrEnt.IsBot() == true )							//Delete me
			{														//This is for debug purposes with bots
				pBaseEnt.ChangeTeam( 0 );							//Unused in actual gameplay
				pPlayer.ForceRespawn();
				pBaseEnt.SetModel( "models/cszm/lobby_guy.mdl" );
			}

			PutPlrToPlayZone( pBaseEnt );

			if ( CountPlrs( 0 ) <= 2 && iWUSeconds == iWUTime ) Schedule::Task( 0.00f, "WarmUpTimer" );
			
			return HOOK_HANDLED;
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerDamaged( CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo )
{
	if ( bIsCSZM == true )
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

		if ( pEntityAttacker.IsPlayer() == true ) 
		{
			@pPlrAttacker = ToZPPlayer( iAttIndex );
			strAN = pPlrAttacker.GetPlayerName();
		}

        const string strAttName = strAN;

		if ( iVicTeam == 2 && iDamageType == 8196 && flDamage > 20 )
		{
			if ( g_iAntidote[iVicIndex] > 2 ) g_iAntidote[iVicIndex] = 2;
			
			if ( g_iAntidote[iVicIndex] > 0 )
			{
				g_iAntidote[iVicIndex]--;
				if ( g_iAntidote[iVicIndex] <= 1 ) SetAntidoteState( iVicIndex, 1 );

				return HOOK_HANDLED;
			}
			else if ( g_iAntidote[iVicIndex] <= 0 )
			{
				g_iVictims[iAttIndex]++;
				ShowKills( pPlrAttacker, g_iVictims[iAttIndex], true );
                KillFeed( strAttName, iAttTeam, strVicName, iVicTeam, true, false );
				GotVictim( pPlrAttacker, pEntityAttacker );
				TurnToZ( iVicIndex );
			}
			
			return HOOK_HANDLED;
		}

		if ( iVicTeam == 3 ) g_flHPRDelay[iVicIndex] = Globals.GetCurrentTime() + 2.14f;
		
		if ( iVicTeam == 3 && pBaseEnt.IsAlive() == true )
		{
			if ( pPlayer.IsCarrier() != true && flDamage > 0)
			{
				Engine.EmitSoundEntity( pBaseEnt, "CSPlayer_Z.Pain" + g_iCVSIndex[iVicIndex] );
				g_flIdleTime[iVicIndex] = Globals.GetCurrentTime() + Math::RandomFloat( 4.85f, 9.95f );
			}

			AddSlowdown( iVicIndex, flDamage, iDamageType );

			return HOOK_HANDLED;
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerInfected( CZP_Player@ pPlayer, InfectionState iState )
{
	if ( iState != state_none && bIsCSZM == true ) pPlayer.SetInfection( false, 0.0f );

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerKilled( CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo ) 
{
	if ( bIsCSZM == true )
	{
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
		
		if ( pEntityAttacker.IsPlayer() == true ) 
		{
			@pPlrAttacker = ToZPPlayer( iAttIndex );
			strAN = pPlrAttacker.GetPlayerName();
		}

		const string strAttName = strAN;

		if ( iAttIndex == iVicIndex || pEntityAttacker.IsPlayer() == false ) KillFeed( "", 0, strVicName, iVicTeam, false, true );
		else if ( iAttIndex != iVicIndex ) KillFeed( strAttName, iAttTeam, strVicName, iVicTeam, false, false );

		if ( g_bIsVolunteer[iVicIndex] == true ) g_bIsVolunteer[iVicIndex] = false;
		
		if ( iVicTeam == 3 )
		{
			if ( pPlayer.IsCarrier() != true ) Engine.EmitSoundEntity( pBaseEnt, "CSPlayer_Z.Die" + g_iCVSIndex[iVicIndex] );

			if ( g_iZMDeathCount[iAttIndex] < iMaxDeath && g_bIsFirstInfected[iVicIndex] == false ) g_iZMDeathCount[iVicIndex]++;

			g_iKills[iAttIndex]++;

			if ( iAttTeam != 3 ) ShowKills( pPlrAttacker, g_iKills[iAttIndex], false );
		}

		if ( iVicTeam == 2 && iAttTeam == 3 )
		{
			g_iVictims[iAttIndex]++;
			ShowKills( pPlrAttacker, g_iVictims[iAttIndex], true );
			g_bIsWeakZombie[iVicIndex] == false;
			GotVictim( pPlrAttacker, pEntityAttacker );
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerDisonnected( CZP_Player@ pPlayer )
{
	if ( bIsCSZM == true )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if ( iFZIndex == pBaseEnt.entindex() ) iFZIndex = 0;
		
		if ( pBaseEnt.GetTeamNumber() == 3 && Utils.GetNumPlayers( zombie, false ) <= 1 && RoundManager.IsRoundOngoing( false ) == true )
		{
			Engine.EmitSound( "common/warning.wav" );
			RoundManager.SetWinState( STATE_STALEMATE );
			SD( strLastZLeave );
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode OnEntityCreation( const string &in strClassname, CBaseEntity@ pEntity )
{
	if ( bIsCSZM == true )
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

			CBaseEntity @pEntTrail = EntityCreator::Create( "env_spritetrail", pEntity.GetAbsOrigin(), QAngle( 0, 0, 0 ), SPRTrailIPD );
			CBaseEntity @pEntSprite = EntityCreator::Create( "env_sprite", pEntity.GetAbsOrigin(), QAngle( 0, 0, 0 ), SpriteIPD );
			CBaseEntity @pDLight = EntityCreator::Create( "light_dynamic", pEntity.GetAbsOrigin(), QAngle( 0, 0, 0 ), DLightIPD );

			pEntTrail.SetParent( pEntity );
			pEntSprite.SetParent( pEntity );
			pDLight.SetParent( pEntity );
		}

		else if ( strClassname == "item_healthkit" ) SpawnAntidote( pEntity );

		else if ( strClassname == "item_armor" ) pEntity.SUB_Remove();				//Armor is not allowed
	}

	return HOOK_CONTINUE;
}

//CSZM Related Funcs
void OnProcessRound()
{
	if ( bIsCSZM == true )
	{
		RoundManager.SetCurrentRoundTime( 300.f + Globals.GetCurrentTime() );
		RoundManager.SetZombieLives( 32 );

		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			CZP_Player@ pPlayer = ToZPPlayer( i );
							
			if ( pPlayer is null ) continue;
							
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if ( g_flSlowTime[i] <= Globals.GetCurrentTime() && g_flSlowTime[i] != 0 )
			{
				g_flSlowTime[i] = 0.0f;
				g_flAddTime[i] = 0.0f;
				g_flRecoverTime[i] = Globals.GetCurrentTime() + flRecoverUnit;
			}

			if ( g_flRecoverTime[i] <= Globals.GetCurrentTime() && g_flRecoverTime[i] != 0 )
			{
				g_flRecoverTime[i] = Globals.GetCurrentTime() + flRecoverUnit;
				g_iSlowSpeed[i] += 2;

				if ( g_iSlowSpeed[i] >= g_iDefSpeed[i] )
				{
					g_flRecoverTime[i] = 0;
					g_iSlowSpeed[i] = 0;
					pPlayer.SetMaxSpeed( g_iDefSpeed[i] );
				}
					
				else
				{
					pPlayer.SetMaxSpeed( g_iSlowSpeed[i] );
				}
			}

			if ( pBaseEnt.GetTeamNumber() == 3 && pPlayer.IsCarrier() != true && pBaseEnt.IsAlive() == true )
			{
				if ( g_flIdleTime[i] <= Globals.GetCurrentTime() && g_flIdleTime[i] != 0 )
				{
					Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Idle" + g_iCVSIndex[pBaseEnt.entindex()] );
					switch( g_iCVSIndex[i] )
					{
						case 2:
							g_flIdleTime[i] = Globals.GetCurrentTime() + Math::RandomFloat( 3.00f, 6.65f );
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

			if ( g_flHPRDelay[i] <= Globals.GetCurrentTime() && g_flHPRDelay[i] != 0 && pBaseEnt.GetHealth() != pBaseEnt.GetMaxHealth() && pBaseEnt.IsAlive() == true)
			{
				g_flHPRDelay[i] = Globals.GetCurrentTime() + flHPRDelay;
				int iRHP = 1;
				if ( pPlayer.IsCarrier() == true ) iRHP = 5;
								
				int iCurHP = pBaseEnt.GetHealth();
				if ( iCurHP < pBaseEnt.GetMaxHealth() ) pBaseEnt.SetHealth( iCurHP + iRHP );
			}
		}
	}
}

void OnNewRound()
{
	if ( bIsCSZM == true )
	{
		bAllowCD = false;
		bIsFirstITurns = false;
		bSpawnWeak = true;
		bAllowZombieSpawn = false;
		bAllowFZColor = false;
		bETimeHP = false;
		iFZTurningTime = 0;
		iFZIndex = 0;
		iTimeHPBonus = 0;
		iTimeHPBonusSeconds = iDefaultTHPSeconds;
		iSAt = 0;
		
		ShowRTL( 0, 0, 300 );
		
		for ( int i = 1; i <= iMaxPlayers; i++) 
		{
			g_iAntidote[i] = 0;
			g_iZMDeathCount[i] = -1;
			g_flHPRDelay[i] = 0.0f;

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
	if ( bIsCSZM == true )
	{
		bAllowZombieSpawn = false;
		pSoloMode.SetValue( "1" );
		ShowRTL( 0, 0, 15 );
	}
}

void OnMatchBegin() 
{
	if ( bIsCSZM == true )
	{
		Schedule::Task( 0.5f, "LocknLoad" );
		Schedule::Task( ( 0.75f ), "RemoveExtraPills" );

		if ( iWUSeconds == 0 )
		{
			PutPlrToLobby( null );
			SetDoorFilter( 1 );
			iWUSeconds = iWUTime;
		}
	}
}

void LocknLoad()
{
	if ( bAllowCD != true ) bAllowCD = true;
	
	iSeconds = iRoundTime;
	
	RoundManager.SetRounds( 10 );
	RoundManager.SetCurrentRoundTime( 2700 );

	RoundTimeLeft();
	Engine.EmitSound( "CS_MatchBeginRadio" );
	
	Globals.SetPlayerRespawnDelay( true, flSpawnDelay );
	
	ShowChatMsg( strRoundBegun, 2 );
}

void OnMatchEnded() 
{
	if ( bIsCSZM == true )
	{
		pSoloMode.SetValue( "0" );
		bAllowZombieSpawn = false;

		for ( int i = 1; i <= iMaxPlayers; i++ ) 
		{
			CZP_Player@ pPlr = ToZPPlayer( i );

			if ( pPlr is null ) continue;

			ShowStatsEnd( pPlr, g_iKills[i], g_iVictims[i] );
		}
	}
}

void AddSlowdown( const int &in iIndex, const float &in flDamage, const int &in iDamageType )
{
	CZP_Player@ pPlayer = ToZPPlayer( iIndex );

	if ( pPlayer is null ) return;
	if ( g_bIsWeakZombie[iIndex] == true && bSpawnWeak == true ) return;

	g_flRecoverTime[iIndex] = 0.0f;

	int iSpeed = int( floor( ( flDamage / 5.0f ) * 2 ) );

	float flSlowTime = 0.15f;

	if ( flDamage < 5 ) iSpeed = 1;

	g_flAddTime[iIndex] += flSlowTime;

	if ( g_flAddTime[iIndex] > flMaxSlowTime ) g_flAddTime[iIndex] = flMaxSlowTime;

	switch( iDamageType )
	{
		case 8320:							//melee
			iSpeed = 100;
			g_flAddTime[iIndex] = 2.15f;
		break;

		case 32:							//fall
			iSpeed = 60;
			g_flAddTime[iIndex] = 0.78f;
		break;

		case 64:							//blast
			iSpeed = 75;
			g_flAddTime[iIndex] = 2.35f;
		break;

		case 134217792:						//explosive barrels and other
			iSpeed = 65;
			g_flAddTime[iIndex] = 1.35f;
		break;

		case 536879106:						//buckshot 
			iSpeed += Math::RandomInt( 2, 6 );
			g_flAddTime[iIndex] += Math::RandomFloat( 0.05f, 0.30f );
		break;
	}

	if ( flDamage >= 75 ) g_flAddTime[iIndex] += 0.25f;

	g_iSlowSpeed[iIndex] = pPlayer.GetMaxSpeed() - iSpeed;

	g_flSlowTime[iIndex] = Globals.GetCurrentTime() + g_flAddTime[iIndex];

	if ( g_iSlowSpeed[iIndex] < iMinSpeed ) g_iSlowSpeed[iIndex] = iMinSpeed;

	pPlayer.SetMaxSpeed( g_iSlowSpeed[iIndex] );
}

void ZeroingSlowdown( const int &in iIndex, const bool &in bIsConnected )
{
	if ( bIsConnected == true ) g_iDefSpeed[iIndex] = iDefSpeed;
	g_flSlowTime[iIndex] = 0.0f;
	g_flRecoverTime[iIndex] = 0.0f;
	g_flAddTime[iIndex] = 0.0f;
	g_iSlowSpeed[iIndex] = 0;
}

void GotVictim( CZP_Player@ pAttacker, CBaseEntity@ pBaseEntA )
{
	if ( g_iZMDeathCount[pBaseEntA.entindex()] >= 0 ) g_iZMDeathCount[pBaseEntA.entindex()] -= iSubtractDeath;
	
	if ( bAllowDebug == true ) SD( "g_iZMDeathCount: " + g_iZMDeathCount[pBaseEntA.entindex()] );
		
	if ( pBaseEntA.IsAlive() == true ) pBaseEntA.SetHealth( pBaseEntA.GetHealth() + iHPReward );

	AddTime( iInfectionATSec );
}

//Need to rewrite RoundTimeLeft function
void RoundTimeLeft()
{
	if ( Utils.GetNumPlayers( survivor, false ) == 0 ) RoundManager.SetWinState( STATE_STALEMATE );
	
	if ( bAllowCD == true )
	{
		TimeHPBonus();
		
		float fShowHour = floor( iSeconds / 3600 );
		float fShowMin = floor( ( iSeconds - fShowHour * 3600 ) / 60 );
		float fShowSec = floor( iSeconds - ( fShowHour * 3600 ) - ( fShowMin * 60 ) );

		ShowRTL( fShowMin, fShowSec, 0 );
		Schedule::Task( 1.00f, "RoundTimeLeft" );
		
		if ( iSeconds <= iSoT && bIsFirstITurns != true )
		{
			if ( bAllowFZColor == false ) 
			{
				bAllowFZColor = true;
				iSAt = iSeconds - iTurningTime;
			}
			iFZTurningTime = ( iSAt - iSeconds ) * - 1;
			FZColor();
			Schedule::Task( 0.0f, "FirstInfected" );	//Fix Me
//			FirstInfected();
			if ( iFZTurningTime <= 10 && iFZTurningTime > 0 ) EmitCountdownSound( iFZTurningTime );
		}
		
		if ( iSeconds == 0 )
		{
			bAllowCD = false;
			Schedule::Task( 1.00f, "CSZMTimeUp" );
		}	
		
		iSeconds--;
	}
}

void TimeHPBonus()
{
	if ( bAllowTimeHP == true && bETimeHP == true )
	{
		iTimeHPBonusSeconds--;
		
		if ( iTimeHPBonusSeconds <=0 )
		{
			iTimeHPBonusSeconds = iDefaultTHPSeconds;
			iTimeHPBonus += iTHPBonus;
		}
	}
}

void ShowRTL( float &in fShowMin, float &in fShowSec, float &in flHoldTime )
{
	string SZero = "0";
	string MZero = "0";
	
	if ( fShowMin <= 9 ) MZero = "0";
	else MZero = "";
	
	if ( fShowSec <= 9 ) SZero = "0";
	else SZero = "";

	string TimerText = MZero + fShowMin + ":" + SZero + fShowSec;

	if ( flHoldTime <= 0 ) flHoldTime = 1.15;
	
	SendGameText( any, "| " + TimerText + " |", 0, 1, -1, 0, 0, 0, flHoldTime, Color( 235, 235, 235 ), Color( 0, 0, 0 ) );
}

void CSZMTimeUp()
{
	if ( iSeconds > 0 )
	{
		bAllowCD = true;
		RoundTimeLeft();
	}
	else if ( Utils.GetNumPlayers( survivor, true ) > 0 ) RoundManager.SetWinState( STATE_HUMAN );
}

void AddTime( const int &in iTime )
{
	int iOverTimeMult = 1;
	
	if ( iSeconds <= 0 ) iOverTimeMult = 3;
	
	if ( iSeconds < 41 && iTime > 0 && bAllowAddTime == true )
	{
		iSeconds += ( iTime * iOverTimeMult );
		
		float fShowHour = floor( iSeconds / 3600 );
		float fShowMin = floor( ( iSeconds - fShowHour * 3600 ) / 60 );
		float fShowSec = floor( iSeconds - ( fShowHour * 3600 ) - ( fShowMin * 60 ) );
		
		ShowRTL( fShowMin, fShowSec + 1, 0 );
		
		SendGameText( any, "\n+ "+( iTime * iOverTimeMult )+" Seconds", 1, 1, -1, 0.0025f, 0, 0.35f, 1.75f, Color( 255, 175, 85 ), Color( 0, 0, 0 ) );
	}
}

//Need to rewrite FZColor and FirstInfected functions
void FZColor()
{
	if ( bAllowFZColor == true && bIsFirstITurns != true )
	{
		Schedule::Task( 0.05f, "FirstInfected" );
		Schedule::Task( 0.05f, "FZColor" );
	}
}

void FirstInfected()
{
	if ( iFZTurningTime > 0 )
	{
		if ( iFZIndex != 0 )
		{	
			CZP_Player@ pPlayer = ToZPPlayer( iFZIndex );

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if ( pBaseEnt.IsAlive() == true && pBaseEnt.GetTeamNumber() == 2 )
			{
				string strPTMAddon = strBecomFI;
				string strPreTurnMsg = strPTMAddon + strTurningIn + iFZTurningTime + strSecs;
				if ( iFZTurningTime == 1 ) strPreTurnMsg = strPTMAddon + strTurningIn + iFZTurningTime + strSec;
				
				int iR = Math::RandomInt( 0, 128 );
				int iG = Math::RandomInt( 135, 255 );
				int iB = Math::RandomInt( 135, 255 );
				
				SendGameTextPlayer( pPlayer, strPreTurnMsg, 1, 0, -1, 0.35, 0, 0, 0.075, Color( iR, iG, iB ), Color( 0, 0, 0 ) );
			}
			else
			{
				iFZIndex = ChooseVolunteer();
				if ( iFZIndex == 0 ) iFZIndex = ChooseFirstInfected();
				FirstInfected();
			}
		}
		else
		{
			iFZIndex = ChooseVolunteer();
			if ( iFZIndex == 0 ) iFZIndex = ChooseFirstInfected();
			FirstInfected();
		}
	}
	else
	{
		Schedule::Task( iDefaultTHPSeconds, "TurnOnTHPBonus" );
		TurnToZ( iFZIndex );
		ShowOutbreak( iFZIndex );
	}
}

void TurnOnTHPBonus()
{
	bETimeHP = true;
}

void TurnToZ( const int &in iIndex )
{
	if ( iIndex != 0 && iIndex > 0 )
	{
		CZP_Player@ pPlayer = ToZPPlayer( iIndex );

		if ( pPlayer !is null )
		{
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if ( bIsFirstITurns != true )
			{
				pSoloMode.SetValue( "0" );
				bAllowZombieSpawn = true;
				bIsFirstITurns = true;
				Engine.EmitSound( "CS_FirstTurn" );
				g_bWasFirstInfected[iIndex] = true;
				g_bIsFirstInfected[iIndex] = true;
				Schedule::Task( flBlockZSTime, "DisallowWeakZombie" );
				FirstInfectedHP();
			}

			g_bIsWeakZombie[iIndex] = false;

			g_flIdleTime[iIndex] = Globals.GetCurrentTime() + Math::RandomFloat( 3.15f, 12.10f );
			g_flHPRDelay[iIndex] = Globals.GetCurrentTime() + 0.25f;

			g_iDefSpeed[iIndex] = iZombieSpeed;
			pPlayer.SetMaxSpeed( iZombieSpeed );

			pPlayer.SetArmModel( "models/cszm/weapons/c_css_zombie_arms.mdl" );

			EmitBloodExp( pPlayer, false );

			pPlayer.CompleteInfection();

			Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Mute" );
			Engine.EmitSoundEntity( pBaseEnt, "Flesh.HeadshotExplode" );
			Engine.EmitSoundEntity( pBaseEnt, "CSPlayer.Turn" );

			RndZModel( pPlayer, pBaseEnt );
			SetZMHealth( pBaseEnt );
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

void FirstInfectedHP()
{
	int iSurvCount = Utils.GetNumPlayers( survivor, true );
	if ( iSurvCount < 4 ) iSurvCount = 4;
	iFirstInfectedHP = iFirstInfectedHPMult * iSurvCount;
}

void SpawnWeakZombie( CZP_Player@ pPlayer )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	const int iIndex = pBaseEnt.entindex();

	if ( pPlayer.IsCarrier() == true ) pBaseEnt.SetModel( g_strModels[0] );
	else pBaseEnt.SetModel( "models/cszm/zombie_charple.mdl" );
	Utils.CosmeticWear( pPlayer, "models/cszm/weapons/w_knife_t.mdl" );
	pBaseEnt.SetMaxHealth( 1 );
	pBaseEnt.SetHealth( iWeakZombieHP );
	pPlayer.SetMaxSpeed( iWeakSpeed );
	g_iCVSIndex[iIndex] = 2;

	Chat.PrintToChatPlayer( pPlrEnt, strWeakZombie );
}

void EmitBloodExp( CZP_Player@ pPlayer, const bool &in bIsSilent )
{
	if ( pPlayer is null ) return;

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
	if ( bIsSilent == false ) Engine.EmitSoundEntity( pBaseEnt, "Flesh.HeadshotExplode" );
}

void RndZModel( CZP_Player@ pPlayer, CBaseEntity@ pEntPlr )
{
	Utils.CosmeticWear( pPlayer, "models/cszm/weapons/w_knife_t.mdl" );
	
	int iRND_CVS = Math::RandomInt( 1, 3 );
	
	if ( iRND_CVS_PV == iRND_CVS )
	{
		for ( int i = 1; iRND_CVS_PV == iRND_CVS; i++ )
		{
			iRND_CVS = Math::RandomInt( 1, 3 );
		}
	}

	g_iCVSIndex[pEntPlr.entindex()] = iRND_CVS;
	
	iRND_CVS_PV = iRND_CVS;
	
	if ( g_bIsFirstInfected[pEntPlr.entindex()] == true ) pEntPlr.SetModel( "models/cszm/zombie_morgue.mdl" );

	else 
	{	
		if ( pPlayer.IsCarrier() == true ) pEntPlr.SetModel( g_strModels[0] );

		else
		{
			uint iMCount = 0;

			for ( uint i = 1; i <= g_strModels.length() - 1; i++ )
			{
				if ( g_bIsModelNotUsed[i] == false ) iMCount++;
			}
			
			if ( iMCount == g_strModels.length() - 1 )
			{
				for ( uint i = 1; i <= g_strModels.length() - 1; i++ )
				{
					if ( g_bIsModelNotUsed[i] == false ) g_bIsModelNotUsed[i] = true;
				}
			}
			
			int iRND_MDL = 0;
			
			for ( int i = 0; iRND_MDL == 0; i++ )
			{
				iRND_MDL = Math::RandomInt( 1, g_strModels.length() - 1 );

				if ( g_bIsModelNotUsed[iRND_MDL] == false ) iRND_MDL = 0;

				else
				{
					g_bIsModelNotUsed[iRND_MDL] = false;
					pEntPlr.SetModel( g_strModels[iRND_MDL] );
				}
			}
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
			flMultiplier = 1.85f;
		break;
		
		case 2:
			flMultiplier = 0.85f;
		break;
		
		default:
			flMultiplier = 0.5;
		break;
	}

	if ( bAllowDebug == true ) SD( "g_iZMDeathCount: " + g_iZMDeathCount[pEntPlr.entindex()] );
	
	if ( g_iZMDeathCount[pEntPlr.entindex()] < 0) g_iZMDeathCount[pEntPlr.entindex()] = 0;
	
	int iHPBonus = g_iZMDeathCount[pEntPlr.entindex()] * iDHPBonus;
	
	CZP_Player@ pPlayer = ToZPPlayer( pEntPlr );
	
	if ( pPlayer.IsCarrier() == false )
	{
		if ( g_bIsFirstInfected[pEntPlr.entindex()] == true )
		{
			pEntPlr.SetMaxHealth( iFirstInfectedHP / 3 );
			pEntPlr.SetHealth( iFirstInfectedHP );
		}
		else
		{
			pEntPlr.SetMaxHealth( pEntPlr.GetMaxHealth() + iTimeHPBonus + iZombieMaxHP + iHPBonus );
			pEntPlr.SetHealth( pEntPlr.GetHealth() + iTimeHPBonus + ( iZombieMaxHP / 4 ) + iHPBonus );
		}
	}
	else
	{
		pEntPlr.SetMaxHealth( pEntPlr.GetMaxHealth() + iTimeHPBonus + int( float( iCarrierMaxHP ) + ( float( iHPBonus ) * flMultiplier ) ) );
		pEntPlr.SetHealth( pEntPlr.GetHealth() + iTimeHPBonus + int( float( iCarrierMaxHP ) + ( float( iHPBonus ) * flMultiplier ) ) );
	}
}

void ShowOutbreak( int &in iIndex )
{
	CZP_Player@ pFirstInf = ToZPPlayer( iIndex );
	string strColor = "blue";
	if ( g_bIsVolunteer[iIndex] == true ) strColor = "violet";
	
	for ( int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
		
		if ( pPlayer is null ) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		if ( i != iIndex ) Chat.PrintToChatPlayer( pPlrEnt, "{" + strColor + "}" + pFirstInf.GetPlayerName() + strBecameFi );
	}

	SendGameText( any, strOutbreakMsg, 1, 0, -1, 0.175, 0, 0.35, 6.75, Color( 64, 255, 128 ), Color( 0, 255, 0 ) );
	
	iFZIndex = 0;
}

int ChooseVolunteer()
{
	int iCount = 0;
	int iVolunteerIndex = 0;
	int iRND;
	
	array<CBaseEntity@> g_pVolunteer = {null};
	
	for ( int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
		
		if ( pPlayer is null ) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		if ( g_bIsVolunteer[i] == true && pBaseEnt.GetTeamNumber() == 2 && pBaseEnt.IsAlive() == true )
		{
			iCount++;
			g_pVolunteer.insertLast( pBaseEnt );
		}
	}
	
	if ( iCount != 0 )
	{
		int iLength = g_pVolunteer.length() - 1;
		if ( iLength <= 1 ) iVolunteerIndex = g_pVolunteer[1].entindex();
		else iVolunteerIndex = g_pVolunteer[Math::RandomInt( 1, iLength )].entindex();
		g_iInfectDelay[iVolunteerIndex] += iInfectDelay;
	}
	
	return iVolunteerIndex;
}

int ChooseFirstInfected()
{
	CheckPlr();

	int iCount = 0;
	int iChoosenIndex = 0;
	int iRND;
	
	array<CBaseEntity@> g_pVictim = {null};
	
	for ( int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
		
		if ( pPlayer is null ) continue;
		
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		if ( g_bWasFirstInfected[i] == false && pBaseEnt.IsAlive() == true && g_iInfectDelay[i] < 2 )
		{
			iCount++;
			g_pVictim.insertLast( pBaseEnt );
		}
	}
	
	if ( iCount != 0 )
	{
		int iLength = g_pVictim.length() - 1;
		if ( iLength > 1 )iChoosenIndex = g_pVictim[Math::RandomInt( 1, iLength )].entindex();
		else iChoosenIndex = g_pVictim[1].entindex();
		g_iInfectDelay[iChoosenIndex] += 1;
	}

	if ( iCount == 0 )
	{
		CZP_Player@ pVictim = GetRandomPlayer( survivor, true );
		CBasePlayer@ pVPlrEnt = pVictim.opCast();
		CBaseEntity@ pVBaseEnt = pVPlrEnt.opCast();

		iChoosenIndex = pVBaseEnt.entindex();
	}
	
	return iChoosenIndex;
}

void CheckPlr()
{
	int iPlrWasFZ = 0;
	int iPlr = 0;
	
	for ( int i = 1; i <= iMaxPlayers; i++)
	{
		CZP_Player@ pPlayer = ToZPPlayer( i );
		
		if ( pPlayer is null ) continue;
		
		iPlr++;
		if ( g_bWasFirstInfected[i] == true ) iPlrWasFZ++;
	}
	
	if ( iPlrWasFZ >= iPlr )
	{
		for ( int i = 1; i <= iMaxPlayers; i++)
		{
			g_bWasFirstInfected[i] = false;
		}
	}
}

//WarmUp Related Funcs
void WarmUpTimer()
{
	int iNumPlrs = 0;
	iNumPlrs += CountPlrs( 0 );

	if ( bAllowWarmUp == true && iNumPlrs >= 2 && iWUSeconds != 0 )
	{
		iWUSeconds--;

		string TimerText = "\n\n\n"+strWarmUp+"\n| "+iWUSeconds+" |";
		SendGameText( any, TimerText, 1, 0.00f, -1, 0.00f, 0.00f, 0.00f, 1.10f, Color( 255, 175, 85 ), Color( 255, 95, 5 ) );
		Schedule::Task( 1.00f, "WarmUpTimer" );

		if ( iWUSeconds == 0 ) Schedule::Task( 1, "WarmUpEnd" );
	}
	else if ( iNumPlrs <= 1 )
	{
		iWUSeconds = iWUTime;
		SendGameText( any, strAMP, 1, 0.00f, -1, 0.00f, 0.00f, 0.00f, 600.00f, Color( 255, 255, 255 ), Color( 255, 95, 5 ) );
	}
}

void WarmUpEnd()
{
	if ( bAllowWarmUp == true ) bAllowWarmUp = false;
	
	Engine.EmitSound( "@buttons/button3.wav" );
	
	SendGameText( any, "", 1, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, Color( 0, 0, 0 ), Color( 0, 0, 0 ) );
	SendGameText( any, "", 3, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, Color( 0, 0, 0 ), Color( 0, 0, 0 ) );

	SendGameText( any, strHintF1, 3, 0.00f, 0.05f, 0.10f, 0.00f, 2.00f, 120.00f, Color( 64, 128, 255 ), Color( 255, 95, 5 ) );
	SendGameText( any, "\n\n" + strHintF3, 4, 0.00f, 0.05f, 0.085f, 0.00f, 2.00f, 120.00f, Color( 255, 255, 255 ), Color( 255, 95, 5 ) );
}

void lobby_hint( CZP_Player@ pPlayer )
{
	SendGameTextPlayer( pPlayer, strHintF1, 3, 0.00f, 0.05f, 0.10f, 0.00f, 2.00f, 120.00f, Color( 64, 128, 255 ), Color( 255, 95, 5 ) );
	SendGameTextPlayer( pPlayer, "\n\n" + strHintF3, 4, 0.00f, 0.05f, 0.085f, 0.00f, 2.00f, 120.00f, Color( 255, 255, 255 ), Color( 255, 95, 5 ) );
}

void lobby_hint_wu( CZP_Player@ pPlayer )
{
	SendGameTextPlayer( pPlayer, strHintF4WU, 3, 0.00f, 0.05f, 0.10f, 0.00f, 2.00f, 120.00f, Color( 64, 255, 128 ), Color( 255, 95, 5 ) );
}

void spec_hint( CZP_Player@ pPlayer )
{
	SendGameTextPlayer( pPlayer, strHintF4, 3, 0.00f, 0.05f, 0.10f, 0.00f, 2.00f, 15.00f, Color( 64, 255, 128 ), Color( 255, 95, 5 ) );
}

void PutPlrToLobby( CBaseEntity@ pEntPlayer )
{
	array<CBaseEntity@> g_pLobbySpawn = {null};
	CBaseEntity@ pEntity;
	
	while ( ( @pEntity = FindEntityByClassname( pEntity, "info_player_commons" ) ) !is null )
	{
		g_pLobbySpawn.insertLast( pEntity );
	}

	int iLength = g_pLobbySpawn.length() - 1;
	
	if ( pEntPlayer is null )
	{
		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			CZP_Player@ pPlayer = ToZPPlayer( i );
			
			if ( pPlayer is null ) continue;
			
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if ( pBaseEnt.GetTeamNumber() == 1 || pBaseEnt.GetTeamNumber() == 0 )
			{
				pBaseEnt.SetAbsOrigin( g_pLobbySpawn[Math::RandomInt( 1, iLength )].GetAbsOrigin() );
			}
		}
	}
	else
	{
		pEntPlayer.SetAbsOrigin( g_pLobbySpawn[Math::RandomInt( 1, iLength )].GetAbsOrigin() );
	}
}

void PutPlrToPlayZone( CBaseEntity@ pEntPlayer )
{
	array<CBaseEntity@> g_pOtherSpawn = {null};
	CBaseEntity@ pEntity;
	
	while ( ( @pEntity = FindEntityByClassname( pEntity, "info_player_human" ) ) !is null )
	{
		g_pOtherSpawn.insertLast( pEntity );
	}
	
	while ( ( @pEntity = FindEntityByClassname( pEntity, "info_player_zombie" ) ) !is null )
	{
		g_pOtherSpawn.insertLast( pEntity );
	}
	
	while ( ( @pEntity = FindEntityByClassname( pEntity, "info_player_start" ) ) !is null )
	{
		g_pOtherSpawn.insertLast( pEntity );
	}

	int iLength = g_pOtherSpawn.length() - 1;
	
	if ( pEntPlayer is null )
	{
		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			CZP_Player@ pPlayer = ToZPPlayer( i );
			
			if ( pPlayer is null ) continue;
			
			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
			
			if ( pBaseEnt.GetTeamNumber() == 1 || pBaseEnt.GetTeamNumber() == 0 )
			{
				pBaseEnt.SetAbsOrigin( g_pOtherSpawn[Math::RandomInt( 1, iLength )].GetAbsOrigin() );
			}
		}
	}
	else
	{
		pEntPlayer.SetAbsOrigin( g_pOtherSpawn[Math::RandomInt( 1, iLength )].GetAbsOrigin() );
	}
}