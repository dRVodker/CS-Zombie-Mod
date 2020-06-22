//Counter-Strike Zombie Mode
//Core Script File

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Info
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	текстовые каналы 
	0 - таймер/обратный отсчёт разминки
	1 - добавочное время/статистика в конце раунда/хитмаркер
	2 - меню
	3 - деньги
	4 - счётчик побед/подсказка в лобби
	5 - убийста/жертвы/подсказка в лобби
*/
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Includes and DATA
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

#include "./cszm_modules/noitems.as"

#include "../SendGameText"
#include "./cszm_modules/chat.as"
#include "./cszm_modules/cache.as"
#include "./cszm_modules/killfeed.as"
#include "./cszm_modules/rprop.as"
#include "./cszm_modules/tbdamage.as"
#include "./cszm_modules/customitems.as"
#include "./cszm_modules/teamnums.as"
#include "./cszm_modules/core_text.as"
#include "./cszm_modules/core_const.as"
#include "./cszm_modules/admin_chatcom.as"

#include "./cszm_modules/download_table.as"

CASConVar@ pSoloMode = null;
CASConVar@ pTestMode = null;
CASConVar@ pINGWarmUp = null;
CASConVar@ pFriendlyFire = null;
CASConVar@ pInfectionRate = null;
CASConVar@ pZPSHardcore = null;

int iMaxPlayers;
int iHumanWin;
int iZombieWin;

float flRTWait;
float flWUWait;
float flSoloTime;

bool bWarmUp;
bool bIsPlayersSelected;

HUDTimer@ pCSZMTimer = null;

array<CSZMPlayer@> Array_CSZMPlayer;
array<array<string>> Array_SteamID;

bool bIsCSZM;						//Это CSZM карта?
bool bAllowAddTime = true;			//Разрешить добавлять время за удачное заражение
bool bAllowZombieRespawn;			//Разрешить респавн для зомби

int iWarmUpTime = 5;				//Время разминки в секундах. (значение по умолчанию - 75)
int iGearUpTime = 30;				//Время в секундах, через которое превратится Первый зараженный.
int iRoundTime = 150;				//Время в секундах отведённое на раунд.
int iZombieHealth = 500;			//HP зомби
int iZMRHealth = 5;					//Максимальное HP, восстанавливаемое регенерацие зомби за один так

float flZMRRate = 0.1f;				//Интервал времени регенерации зомби
float flZMRDamageDelay = 0.65f;		//Задержка регенерации после получения урона
float flInfectedExtraHP = 0.25f;	//Процент дополнительного HP для первых зараженных, от HP обычных зомби (от iZombieHealth)
float flInfectionPercent = 0.3f;	//Процент выживших, которые будут заражены в начале раунда
float flPSpeed = 0.22f;				//Часть скорости, которая останется у игрока после замедления
float flRecover = 0.028f;			//Время между прибавками скорости
float flCurrs = 1.125f;				//Часть от текущей скорости игрока, которая будет прибавляться для восстановления нормальной скорости игрока

int iPreviousZombieVoiceIndex;		//Предыдущий номер голоса зомби
int iPreviousInfectIndex = -1;		//Предыдущий номер звука заражения
int iSeconds;						//Переменная используется для обратного отсчёта времени раунда
int iWUSeconds;						//Переменная используется для обратного отсчёта времени разминки
int iRoundTimeFull;					//Время в секундах отведённое на раунд (ПОЛНОЕ).
int iTurnTime;						//Время, когда превращаются зараженные

int ECO_DefaultCash = 600;
int ECO_StartingCash = 400;
int ECO_Human_Win = 600;
int ECO_Human_Kill = 300;
int ECO_Zombie_Win = 500;
int ECO_Zombie_Kill = 750;
int ECO_Lose = -1000;
int ECO_Suiside = -600;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Forwards
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("Counter-Strike Zombie Mode");

	@pSoloMode = ConVar::Find("sv_zps_solo");
	@pTestMode = ConVar::Find("sv_testmode");
	@pINGWarmUp = ConVar::Find("sv_zps_warmup");
	@pFriendlyFire = ConVar::Find("mp_friendlyfire");
	@pInfectionRate = ConVar::Find("sv_zps_infectionrate");
	@pZPSHardcore = ConVar::Find("sv_zps_hardcore");

	Events::Player::OnPlayerInfected.Hook(@CSZM_OnPlayerInfected);
	Events::Player::OnPlayerConnected.Hook(@CSZM_OnPlayerConnected);
	Events::Player::OnPlayerSpawn.Hook(@CSZM_OnPlayerSpawn);
	Events::Entities::OnEntityCreation.Hook(@CSZM_OnEntityCreation);
	Events::Entities::OnEntityDestruction.Hook(@CSZM_OnEntityDestruction);
	Events::Custom::OnEntityDamaged.Hook(@CSZM_OnEntDamaged);
	Events::Custom::OnPlayerDamagedCustom_PRE.Hook(@CSZM_OnPlayerDamaged);
	Events::Player::OnPlayerKilled.Hook(@CSZM_OnPlayerKilled);
	Events::Player::OnPlayerDisconnected.Hook(@CSZM_OnPlayerDisconnected);
	Events::Rounds::RoundWin.Hook(@CSZM_RoundWin);
	Events::Player::OnConCommand.Hook(@CSZM_OnConCommand);
	Events::Player::PlayerSay.Hook(@CSZM_CORE_PlrSay);
}

void OnMapInit()
{
	if (!Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		return;
	}

	bIsCSZM = true;
	bWarmUp =  true;
	bIsPlayersSelected = false;
	iWUSeconds = iWarmUpTime;
	flRTWait = 0;
	flWUWait = 0;
	flSoloTime = 0;

	Engine.EnableCustomSettings(true);
	Utils.ForceCollision(TEAM_SURVIVORS, false);
	Utils.ForceCollision(TEAM_ZOMBIES, false);
	
	//Set some ConVar to 0
	pSoloMode.SetValue("0");
	pTestMode.SetValue("0");
	pINGWarmUp.SetValue("0");
	pFriendlyFire.SetValue("0");
	pInfectionRate.SetValue("0");
	pZPSHardcore.SetValue("0");
	
	//Cache
	CacheModels();
	CacheSounds();
	CacheMaterials();

	//Add all custom files of CSZM to Download Table
	//Sounds, materials, models
	AddToDownloadTable();

	//Get MaxPlayers
	iMaxPlayers = Globals.GetMaxClients();
	
	//Entities
	RegisterEntities();

	//CSZM Player array resize
	Array_CSZMPlayer.resize(iMaxPlayers + 1);

	AutoMap();
	SetUpIPD((1<<1) + (1<<2) + (1<<3));
	
	//Set Doors Filter to 0 (any team)
	SetDoorFilter(TEAM_LOBBYGUYS);
}

void OnMapShutdown()
{
	if (!bIsCSZM)
	{
		return;
	}

	pSoloMode.SetValue("0");

	bIsCSZM = false;
	bWarmUp = true;

	iWUSeconds = iWarmUpTime;
	iSeconds = 0;
	flRTWait = 0;
	flWUWait = 0;
	flSoloTime = 0;
	iHumanWin = 0;
	iZombieWin = 0;

	Array_CSZMPlayer.removeRange(0, Array_CSZMPlayer.length());
	Array_SteamID.removeRange(0, Array_SteamID.length());
	ClearIPD();

	Engine.EnableCustomSettings(false);
	Utils.ForceCollision(TEAM_SURVIVORS, false);
	Utils.ForceCollision(TEAM_ZOMBIES, false);

	@pCSZMTimer = null;
}

void OnProcessRound()
{
	if (!bIsCSZM)
	{
		return;
	}

	RoundManager.SetCurrentRoundTime(PlusGT(CONST_GAME_ROUND_TIME));
	RoundManager.SetZombieLives(CONST_ZOMBIE_LIVES);

	if (LessThanGTZ(flRTWait))
	{
		flRTWait = PlusGT(1.0f);
		RoundTimer();
	}

	if (LessThanGTZ(flWUWait))
	{
		WarmUpTimer();
	}

	if (flSoloTime != -1 && LessThanGTZ(flSoloTime))
	{
		flSoloTime = -1;
		pSoloMode.SetValue("0");
	}

	if (pCSZMTimer !is null)
	{
		pCSZMTimer.Think();
	}

	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		if (Array_CSZMPlayer[i] !is null)
		{
			Array_CSZMPlayer[i].Think();
		}
	}
}

void OnNewRound()
{
	if (!bIsCSZM)
	{
		return;
	}

	AutoMap();

	flRTWait = 0;
	flWUWait = 0;

	bIsPlayersSelected = false;

	@pCSZMTimer = null;
	
	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		if (Array_CSZMPlayer[i] !is null)
		{
			Array_CSZMPlayer[i].Reset();
		}
	}
}

void OnMatchStarting()
{
	if (!bIsCSZM)
	{
		return;
	}

	pSoloMode.SetValue("1");

	int flGUT_iPercent = int(ceil(iGearUpTime * 0.214f));
	int iPercent = Math::RandomInt(-1 * flGUT_iPercent, flGUT_iPercent);

	int p_iRoundTime = iRoundTime - iPercent;
	int p_iGearUpTime = iGearUpTime + iPercent;

	iRoundTimeFull = p_iRoundTime + p_iGearUpTime;
	iTurnTime = p_iRoundTime;

	iSeconds = iRoundTimeFull;
	@pCSZMTimer = HUDTimer();

	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		if (Array_CSZMPlayer[i] !is null)
		{
			Array_CSZMPlayer[i].AddMoney(ECO_StartingCash);
		}
	}
}

void OnMatchBegin() 
{
	if (!bIsCSZM)
	{
		return;
	}

	LogicPlayerManager();
	Schedule::Task(0.5f, "CSZM_LocknLoad");

	if (iWUSeconds == 0)
	{
		PutPlrToLobby(null);
		SetDoorFilter(TEAM_SPECTATORS);
		iWUSeconds = iWarmUpTime;
	}
}

void OnMatchEnded() 
{
	if (!bIsCSZM)
	{
		return;
	}

	pSoloMode.SetValue("0");

	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		if (Array_CSZMPlayer[i] !is null)
		{
			Array_CSZMPlayer[i].ShowStatsEnd();
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Classes
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

class HUDTimer
{
	private float RPBaseTime;
	private float RPTime;
	private float WaitTime;
	private float HoldTime;
	private string Timer;
	private float Alpha;

	HUDTimer()
	{
		WaitTime = Globals.GetCurrentTime();
		RPBaseTime = 0;
		RPTime = 0;
		HoldTime = 10.0f;
		Alpha = 1.0f;

		UpdateTimer(iSeconds);
	}

	void StopHUDTimer()
	{
		WaitTime = 0;
		RPBaseTime = 0;
		HoldTime = 10.25f;
		Alpha = (iSeconds > 0) ? 1.0f : 0.1765f;

		ShowHUDTime();
	}

	private void UpdateTimer(int Seconds)
	{
		float ShowHours = floor(iSeconds / 3600);
		float ShowMinutes = floor((iSeconds - ShowHours * 3600) / 60);
		float ShowSeconds = floor(iSeconds - (ShowHours * 3600) - (ShowMinutes * 60));

		string SZero = (ShowSeconds <= 9) ? "0" : "";
		string MZero = (ShowMinutes <= 9) ? "0" : "";

		Timer = MZero + formatFloat(ShowMinutes, 'l', 0, 0) + ":" + SZero + formatFloat(ShowSeconds, 'l', 0, 0);
		RedPulseTime(Seconds);
		ShowHUDTime();
	}

	private void RedPulseTime(int Seconds)
	{
		if (Seconds <= 5)
		{
			RPBaseTime = 0.075f;
		}
		else if (Seconds <= 10)
		{
			RPBaseTime = 0.17f;
		}
		else if (Seconds <= 15)
		{
			RPBaseTime = 0.4f;
		}
		else
		{
			RPBaseTime = 0;
		}
	}

	private void ShowHUDTime()
	{
		HudTextParams pTimerParameters;

		pTimerParameters.x = -1;
		pTimerParameters.y = 0;
		pTimerParameters.channel = 0;
		pTimerParameters.fadeinTime = 0.0f;
		pTimerParameters.fadeoutTime = 0.0f;
		pTimerParameters.holdTime = HoldTime + 0.15f;
		pTimerParameters.fxTime = 0;
		pTimerParameters.SetColor(Color(255, int(ceil(255 * Alpha)), int(ceil(255 * Alpha))));
		pTimerParameters.SetColor2(Color(0, 0, 0));

		Utils.GameText(any, Timer, pTimerParameters);
	}

	void Think()
	{
		if (LessThanGTZ(WaitTime))
		{
			WaitTime = PlusGT(0.1);
			HoldTime = 0.1f;
			UpdateTimer(iSeconds);
		}
		
		if (LessThanGT(RPTime) && RPBaseTime != 0)
		{
			RPTime = PlusGT(RPBaseTime);
			Alpha = (Alpha != 1.0f) ? 1.0f : 0.1765f;
			ShowHUDTime();
		}
	}
}

class ShowHealthPoints
{
	private array<string> Lines;
	float lifetime;

	ShowHealthPoints(CBasePlayer@ pPlayer, string sHP)
	{
		UpdateInfo(pPlayer, sHP);
	}

	void UpdateInfo(CBasePlayer@ pPlayer, string sHP)
	{
		Lines.insertLast(sHP);
		lifetime = PlusGT(0.2f);
		Show(pPlayer);
	}

	private void Show(CBasePlayer@ pPlayer)
	{
		string MSG;

		for (uint i = 0; i < Lines.length(); i++)
		{
			if (i == 0)
			{
				MSG += Lines[i];
				continue;
			}

			MSG += "\n" + Lines[i];
		}

		Chat.CenterMessagePlayer(pPlayer, MSG);
	}
}

class CSZMPlayer
{
	private string SteamID;					//SteamID, Что тут ещё добавить?
	private int PlayerIndex;				//entindex игрока
	private int DefSpeed;					//Обычная скорость движения игрока
	private int Voice;						//Номер голоса для зомби (3 максимально кол-во)
	private int PreviousVoice;				//Номер предыдущего голоса
	private int PropHealth;

	private int Kills;						//Убийства в раунде
	private int Victims;					//Заражения или убийства выживших в раунде

	private float SwipeDelay;				//Задержка между заражениями, эта задержка не даст заразить двух и более выживших одним ударом
	private float RegenTime;				//Промежутки времени между добавлением HP
	private float RecoverTime;				//Промежутки времени между добавлением Скорости

	private float VoiceTime;				//Время между IDLE звуками зомби
	private float AdrenalineTime;			//Время действия адреналина
	private float InfResShowTime;			//Время, по истечению которого показывается сообщение об кол-ве сопротивления инфекции
	private float LobbyRespawnDelay;		//Время, которое должен ждать игрок в лобби, чтобы сново использовать "F4 Respawn"

	bool Abuser;							//Игроки, злоупотребляющие механиками, получают этот флаг (Записывается в SteamIDArray)
	bool FirstInfected;						//Один из первых зараженных?

	private float ZombieRespawnTime;		//???

	bool Cured;								//true - Если был вылечен администратором
	bool Spawn;								//true - Если возрадился играя за зомби

	int InfectResist;						//Сопротивление инфекции
	int InfectPoints;						//Чем больше значение, тем вероятнее заражение (Записывается в SteamIDArray)
	int CashBank;							//Деньги Деньги Деньги
	int ExtraLife;							//Extra Life
	int ExtraHealth;						//Дополнительное здоровье

	float Scale;							//???

	array<TimeBasedDamage@> pTimeDamage;	//???
	private ShowHealthPoints@ pShowHP;		//???

	Radio::Menu@ pMenu;						//Слот для меню
	GameText::Cash@ pCash;					//Показывает деньги

	CSZMPlayer(int index, CZP_Player@ pPlayer)
	{
		CashBank = ECO_DefaultCash;
		@pMenu = null;
		@pCash = GameText::Cash(index, CashBank);

		SteamID = pPlayer.GetSteamID64();
		PlayerIndex = index;
		DefSpeed = SPEED_DEFAULT;

		Scale = 1.0f;

		int iArrayElement = CheckSteamID(SteamID);

		if (iArrayElement == -1)
		{
			Abuser = false;
			InfectPoints = Math::RandomInt(72, 78);
			Array_SteamID.insertLast({SteamID, "false", formatInt(InfectPoints)});
		}
		else
		{
			Abuser = (Utils.StrEql("true", Array_SteamID[iArrayElement][1], true) && RoundManager.IsRoundOngoing(false));
			InfectPoints = Utils.StringToInt(Array_SteamID[iArrayElement][2]);
		}
	}

	void WriteToSteamID()
	{
		int iArrayElement = CheckSteamID(SteamID);

		if (iArrayElement != -1)
		{
			Array_SteamID[iArrayElement][1] = BoolToString(Abuser);
			Array_SteamID[iArrayElement][2] = formatInt(InfectPoints);
		}
	}

	void Reset()
	{
		DeathReset();

		Abuser = false;

		ZombieRespawnTime = 0;
		Kills = 0;
		Victims = 0;
		InfResShowTime = 0;
		PropHealth = 0;
		RecoverTime = 0;
		VoiceTime = 0;
		ExtraHealth = 0;
		ExtraLife = 0;
	}

	void DeathReset()
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		pPlayer.DoPlayerDSP(0);
		pPlayer.SetMaxSpeed(DefSpeed);

		Cured = false;
		Spawn = false;
		FirstInfected = false;
		LobbyRespawnDelay = 0;
		InfectResist = 0;
		AdrenalineTime = 0;
		RecoverTime = Globals.GetCurrentTime();
		VoiceTime = Globals.GetCurrentTime();

		Scale = 1.0f;

		pTimeDamage.removeRange(0, pTimeDamage.length());
		@pShowHP = null;

		if (pPlayerEntity.GetTeamNumber() == TEAM_ZOMBIES && (bAllowZombieRespawn || ExtraLife > 0))
		{
			ZombieRespawnTime = PlusGT(CONST_SPAWN_DELAY - 0.05f);
		}
	}

	bool CanInfect()
	{
		bool b = false;

		if (LessThanGT(SwipeDelay))
		{
			b = true;
			SwipeDelay = PlusGT(CONST_SWIPE_DELAY);
		}

		return b;
	}

	void SetDefSpeed(int NewSpeed)
	{
		ToZPPlayer(PlayerIndex).SetMaxSpeed(NewSpeed);
		DefSpeed = NewSpeed;
	}

	void SetZombieVoice(int VoiceIndex)
	{
		VoiceTime = PlusGT(Math::RandomFloat(5.15f, 14.2f));

		while (VoiceIndex == PreviousVoice)
		{
			VoiceIndex = Math::RandomInt(1, VOICE_MAX_INDEX);
		}
		
		PreviousVoice = VoiceIndex;
		Voice = VoiceIndex;
	}

	void SetAbuser(bool SA)
	{
		Abuser = SA;
		WriteToSteamID();
	}

	void RespawnLobby()
	{
		if (LessThanGT(LobbyRespawnDelay) && FindEntityByEntIndex(PlayerIndex).GetTeamNumber() == TEAM_LOBBYGUYS) 
		{
			LobbyRespawnDelay = PlusGT(0.3f);
			ToZPPlayer(PlayerIndex).ForceRespawn();
		}
	}

	void EmitZombieSound(string ZM_Sound)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		if (pPlayerEntity.GetWaterLevel() != WL_Eyes)
		{
			Engine.EmitSoundEntity(pPlayerEntity, ZM_Sound + formatInt(Voice));
		}
	}

	bool SetScale(float nScale)
	{
		bool IsScaleChanged = false;

		if (nScale >= 0.05f && nScale <= 2.0f)
		{
			Scale = nScale;
			Engine.Ent_Fire_Ent(FindEntityByEntIndex(PlayerIndex), "SetModelScale", formatFloat(Scale, 'l', 2, 2));
			Chat.CenterMessagePlayer(ToBasePlayer(PlayerIndex), "| Выш масштаб изменён до " + formatFloat(Scale, 'l', 2, 2) + " |");
			IsScaleChanged = true;
		}

		return IsScaleChanged;
	}

	bool ChangeScale(float nScale)
	{
		bool IsScaleChanged = false;

		if (Scale + nScale > 0.05f && Scale + nScale < 2.0f)
		{
			IsScaleChanged = SetScale(Scale + nScale);
		}

		return IsScaleChanged;
	}

	bool AddExtraHealth()
	{
		bool IsExtraHealthAdded = false;

		if (ExtraHealth < 2)
		{
			ExtraHealth++;
			FindEntityByEntIndex(PlayerIndex).SetMaxHealth(int(ceil(iZombieHealth + iZombieHealth * 0.45f * ExtraHealth)));
			Engine.EmitSoundPosition(PlayerIndex, "npc/zombie_poison/pz_alert2.wav", FindEntityByEntIndex(PlayerIndex).EyePosition(), 0.925f, 70, Math::RandomInt(90, 105));
			EmitBloodEffect(ToZPPlayer(PlayerIndex), true);
			ShakeInfected(FindEntityByEntIndex(PlayerIndex));
			IsExtraHealthAdded = true;
		}

		return IsExtraHealthAdded;
	}

	bool AddExtraLife()
	{
		bool IsExtraLifeAdded = false;

		if (ExtraLife < 5)
		{
			ExtraLife++;
			Chat.CenterMessagePlayer(ToBasePlayer(PlayerIndex), "| Extra Life: "+ExtraLife+" |");
			IsExtraLifeAdded = true;
		}

		return IsExtraLifeAdded;
	}

	bool AddZMArmor()
	{
		bool IsArmorAdded = false;

		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		int iArmor = pPlayer.GetArmor();

		if (iArmor == 0)
		{
			pPlayer.SetArmor(650);
			Engine.EmitSoundEntity(FindEntityByEntIndex(PlayerIndex), "ZPlayer.ArmorPickup");
			IsArmorAdded = true;
		}
		return IsArmorAdded;
	}

	void AddMoney(const int nCash)
	{
		CashBank += nCash;
		if (CashBank < 0)
		{
			CashBank = 0;
		}
	}

	void AddPropHealth(const int nHP)
	{
		PropHealth += nHP;
		if (PropHealth >= 300)
		{
			PropHealth -= 300;
			AddInfectPoints(-1);
		}
		
		CashBank += PropHealthToMoney(nHP);
	}

	void AddInfectPoints(int AIC)
	{
		if (RoundManager.IsRoundOngoing(false))
		{
			InfectPoints += AIC;
			WriteToSteamID();
		}
	}

	void AddSlowdown()
	{
		int NewSpeed = int(float(DefSpeed) * flPSpeed);

		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);

		if (pPlayerEntity.GetTeamNumber() == TEAM_ZOMBIES)
		{
			VoiceTime += Math::RandomFloat(0.67f, 0.98f);
			RegenTime = (pPlayer.GetArmor() > 0) ? RegenTime : PlusGT(flZMRDamageDelay);
			UpdateOutline();
		}

		RecoverTime = PlusGT(flRecover);
		pPlayer.SetMaxSpeed(NewSpeed);
	}

	void AddMenu(Radio::Menu@ nShop)
	{
		@pMenu = nShop;
	}

	void ExitMenu()
	{
		@pMenu = null;
	}

	bool Input(const int nInput)
	{
		bool IsMenuExist = (pMenu !is null);
		if (IsMenuExist)
		{
			pMenu.Input(nInput);
		}
		return IsMenuExist;
	}

	void SubtractInfectResist()
	{
		if (InfectResist > 0)
		{
			InfectResist--;
		}
	}

	void InjectAntidote(CBaseEntity@ pItemAntidote)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		InfResShowTime = PlusGT(1.12f);
		InfectResist++;
	
		AddInfectPoints(-1);

		Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0, fade_in);
		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + 5);
		Engine.EmitSoundPosition(PlayerIndex, "items/smallmedkit1.wav", pPlayerEntity.EyePosition(), 0.5f, 75, 100);

		SetUsed(PlayerIndex, pItemAntidote);

		Chat.CenterMessagePlayer(pBasePlayer, strInfRes + formatInt(InfectResist));
	}

	void InjectAdrenaline(CBaseEntity@ pItemAdrenaline)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		int AdrenaDamage = Math::RandomInt(15, 25);
		float flADuration = CONST_ADRENALINE_DURATION + Math::RandomFloat(0.25f, 3.15f);
		int NewSpeed = pPlayer.GetMaxSpeed() + SPEED_ADRENALINE;

		if (NewSpeed > SPEED_ADRENALINE + SPEED_HUMAN)
		{
			NewSpeed = SPEED_ADRENALINE + SPEED_HUMAN;
		}

		pPlayer.SetMaxSpeed(NewSpeed);
		pPlayer.DoPlayerDSP(34);
		Utils.ScreenFade(pPlayer, Color(8, 16, 64, 50), 0.25f, (flADuration - 0.25f), fade_in);
		Engine.EmitSoundPlayer(pPlayer, "ZPlayer.Panic");
		AdrenalineTime = PlusGT(flADuration);
		AddInfectPoints(1);
		pPlayerEntity.SetMaxHealth(pPlayerEntity.GetMaxHealth() - AdrenaDamage);

		CTakeDamageInfo AdrenaDMG;

		AdrenaDMG.SetInflictor(pPlayerEntity);
		AdrenaDMG.SetAttacker(pPlayerEntity);
		AdrenaDMG.SetWeapon(pItemAdrenaline);
		AdrenaDMG.SetDamage(AdrenaDamage);
		AdrenaDMG.SetDamageType(DMG_POISON);

		pPlayerEntity.TakeDamage(AdrenaDMG);

		SetUsed(PlayerIndex, pItemAdrenaline);
	}

	void ShowHealthLeft(int damage, int health)
	{
		string FullMSG = (damage > health) ? "- -" : "Health: " + formatInt(health - damage);

		if (pShowHP is null)
		{
			@pShowHP = ShowHealthPoints(ToBasePlayer(PlayerIndex), FullMSG);
		}
		else
		{
			pShowHP.UpdateInfo(ToBasePlayer(PlayerIndex), FullMSG);
		}
	}

	void AddKill()
	{
		Kills++;
		ShowKills(ToZPPlayer(PlayerIndex), Kills, false);
	}

	void AddVictim()
	{
		Victims++;
		ShowKills(ToZPPlayer(PlayerIndex), Victims, true);
	}

	void ShowStatsEnd()
	{
		string strStatsHead = "Ваша статистика раунда:\n";
		string strStats = strStatsHead + " Убийства зомби: " + formatInt(Kills) + "\n Заражение людей: " + formatInt(Victims);
		ShowTextPlr(ToZPPlayer(PlayerIndex), strStats, 1, 0.00f, 0, 0.25f, 0.25f, 0.00f, 10.10f, Color(205, 205, 220), Color(255, 95, 5));
	}

	void Think()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		int TeamNum = pPlayerEntity.GetTeamNumber();

		if (pTimeDamage.length() > 0)
		{
			for (uint i = 0; i < pTimeDamage.length(); i++)
			{
				if (pTimeDamage[i].Tiks == 0 || pPlayerEntity.GetTeamNumber() != TEAM_ZOMBIES)
				{
					@pTimeDamage[i] is null;
					pTimeDamage.removeAt(i);
					continue;
				}

				pTimeDamage[i].Think(pPlayerEntity);
			}
		}

		if (pShowHP !is null && pShowHP.lifetime < Globals.GetCurrentTime())
		{
			@pShowHP = null;
		}

		if (pMenu !is null)
		{
			pMenu.Think();
		}

		if (pCash !is null)
		{
			pCash.Think();
		}

		if (LessThanGTZ(ZombieRespawnTime))
		{
			ZombieRespawnTime = 0;
			if (RoundManager.IsRoundOngoing(false) && (bAllowZombieRespawn || ExtraLife > 0))
			{
				Spawn = true;
				pPlayerEntity.ChangeTeam(TEAM_SURVIVORS);
				pPlayer.ForceRespawn();
				pPlayer.SetHudVisibility(true);
				TurnToZombie(PlayerIndex);

				if (!bAllowZombieRespawn)
				{
					ExtraLife--;
					Chat.CenterMessagePlayer(pBasePlayer, "| Extra Life: "+ExtraLife+" |");
				}
			}
		}

		if (pPlayerEntity.IsAlive())
		{
			if (LessThanGTZ(RecoverTime))
			{
				RecoverTime = PlusGT(flRecover);

				float CurrSpeed = float(pPlayer.GetMaxSpeed());
				int NewSpeed = int(CurrSpeed * flCurrs);

				if (NewSpeed > DefSpeed)
				{
					NewSpeed = DefSpeed;
					RecoverTime = -1;

					if (AdrenalineTime > Globals.GetCurrentTime() && pPlayerEntity.GetTeamNumber() == TEAM_SURVIVORS)
					{
						NewSpeed += SPEED_ADRENALINE;
					}
				}

				pPlayer.SetMaxSpeed(NewSpeed);
			}

			if (TeamNum == TEAM_ZOMBIES)
			{
				if (LessThanGT(VoiceTime))
				{
					EmitZombieSound(VOICE_ZM_IDLE);

					float Time_Low = 5.24f;
					float Time_High = 14.25f;

					switch(Voice) { case 2: Time_Low = 5.05f; Time_High = 12.05f; break; case 3: Time_Low = 5.65f; Time_High = 11.92f; break; }

					VoiceTime = PlusGT(Math::RandomFloat(Time_Low, Time_High));
				}

				if (LessThanGT(RegenTime) && pPlayerEntity.GetHealth() < pPlayerEntity.GetMaxHealth())
				{
					RegenTime = PlusGT(flZMRRate - (flZMRRate * 0.25f * ExtraHealth));	//0.1f
					int RegenHealth = pPlayerEntity.GetHealth() + Math::RandomInt(1, iZMRHealth);;	//1

					if (RegenHealth > pPlayerEntity.GetMaxHealth())
					{
						RegenHealth = pPlayerEntity.GetMaxHealth();
					}

					pPlayerEntity.SetHealth(RegenHealth);
					UpdateOutline();	
				}
			}
			else if (TeamNum == TEAM_SURVIVORS)
			{
				if (LessThanGTZ(AdrenalineTime))
				{
					AdrenalineTime = 0;
					pPlayer.SetMaxSpeed(DefSpeed);
					pPlayer.DoPlayerDSP(0);
				}

				if (LessThanGT(InfResShowTime) && Utils.StrContains("item_antidote", pPlayer.GetCurrentWeapon().GetEntityName()))
				{
					InfResShowTime = PlusGT(1.12f);
					Chat.CenterMessagePlayer(pBasePlayer, strInfRes + formatInt(InfectResist));
				}
			}
		}
	}

	void UpdateOutline()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		float MaxHP = pPlayerEntity.GetMaxHealth();
		float HP = pPlayerEntity.GetHealth();
		float HPP = (HP / MaxHP);
		float BaseCChanel = 255.0f;
		float ExtraDistance = 0.0f;
		int cRed = 0;
		int cGreen = 255;
		int cBlue = 16;
		bool RenderUnOccluded = false;
	
		if (HPP < 1)
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
	
		pPlayerEntity.SetOutline(true, filter_team, TEAM_ZOMBIES, Color(cRed, cGreen, cBlue), GLOW_BASE_DISTANCE + ExtraDistance, true, RenderUnOccluded);	
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Last includes
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

#include "./cszm_modules/misc.as"
#include "./cszm_modules/core_warmup.as"

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//GameText/RadioMenu/NonPlayZone
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

namespace GameText
{
	const float AccCashLifeTime = 4.0f;
	const array<string> AMPExtra = 
	{
		"title",
		"holdtime",
		"fadeout"
	};
	const array<string> AMPItem = 
	{
		"item1",
		"item2",
		"item3",
		"item4",
		"item5",
		"item6",
		"item7"
	};

	class MenuKeyValyes
	{
		private array<string> p_Key;
		private array<string> p_Value;

		void Add(const string Key, const string Value)
		{
			p_Key.insertLast(Key);
			p_Value.insertLast(Value);
		}

		void Update(const string Key, const string Value)
		{
			int KeyIndex = p_Key.find(Key);

			if (KeyIndex > -1)
			{
				p_Value[KeyIndex] = Value;
			}
			else
			{
				Add(Key, Value);
			}
		}

		string GetKeyValue(const string Key)
		{
			string sResult = "null";
			int KeyIndex = p_Key.find(Key);

			if (KeyIndex > -1)
			{
				sResult = p_Value[KeyIndex];
			}
			else
			{
				switch(AMPExtra.find(Key))
				{
					case 0: sResult = "Empty Title"; break;
					case 1: sResult = "10.0"; break;
					case 2: sResult = "0.0"; break;
				}
			}

			return sResult;
		}
	}

	class Menu
	{
		Menu(const int iPlrInd, MenuKeyValyes@ nParams)
		{
			string FullMSG = "";

			FullMSG += nParams.GetKeyValue("title") + "\n";

			for (uint i = 0; i < AMPItem.length(); i++)
			{
				string MI_Value = nParams.GetKeyValue(AMPItem[i]);

				if (MI_Value != "null")
				{
					FullMSG += "\n" + formatInt(i + 1) + ". " + MI_Value;
				}

				if (i == AMPItem.length() - 1)
				{
					FullMSG += "\n";
				}
			}

			if (Utils.StrEql("true", nParams.GetKeyValue("prev")))
			{
				FullMSG +="\n8. Previous";
			}

			if (Utils.StrEql("true", nParams.GetKeyValue("next")))
			{
				FullMSG +="\n9. Next";
			}

			FullMSG +="\n0. Close";

			DrawMenu(ToZPPlayer(iPlrInd), FullMSG, Utils.StringToFloat(nParams.GetKeyValue("holdtime")), Utils.StringToFloat(nParams.GetKeyValue("fadeout")));
		}

		void DrawMenu(CZP_Player@ pPlayer, const string strMessage, const float flHoldTime, const float flFadeOutTime)
		{
			HudTextParams pParams;
			pParams.x = 0.00725f;
			pParams.y = 0.185f;
			pParams.channel = 2;
			pParams.fadeoutTime = flFadeOutTime;
			pParams.holdTime = flHoldTime + 0.01f;
			pParams.SetColor(Color(255, 255, 255));
			Utils.GameTextPlayer(pPlayer, strMessage, pParams);
		}
	}

	class Cash
	{
		int PlrInd;
		float Alpha;
		int AccumulateCash;
		int PrevCash;
		float LifeTime;
		float ShowTime;

		Cash(const int nPlayer, const int nCash)
		{
			PlrInd = nPlayer;
			ShowTime = PlusGT(0.0991f);
			PrevCash = nCash;
			LifeTime = AccCashLifeTime;
		}

		void CheckCash()
		{
			if (PrevCash != Array_CSZMPlayer[PlrInd].CashBank)
			{
				AccumulateCash = (LifeTime >= AccCashLifeTime / 2) ? 0 : AccumulateCash;
				AccumulateCash = ((AccumulateCash > 0) == (Array_CSZMPlayer[PlrInd].CashBank - PrevCash > 0)) ? AccumulateCash : 0;

				AccumulateCash += Array_CSZMPlayer[PlrInd].CashBank - PrevCash;
				PrevCash = Array_CSZMPlayer[PlrInd].CashBank;
				Alpha = 0.0f;
				LifeTime = 0.0f;
			}
			Show();
		}

		void Think()
		{
			if (LifeTime < AccCashLifeTime)
			{
				LifeTime += 0.0149254f;

				if (LifeTime > AccCashLifeTime)
				{
					LifeTime = AccCashLifeTime;
				}

				Alpha = (LifeTime / 100.0f / 0.04f);
			}

			if (LessThanGTZ(ShowTime))
			{
				ShowTime = PlusGT(0.0991f);
				CheckCash();
			}
		}

		private void Show()
		{
			string FullMSG = formatInt(Array_CSZMPlayer[PlrInd].CashBank) + "$";
			int Red = 255;
			int Green = 255;
			int Blue = 255;

			if (LifeTime < AccCashLifeTime)
			{
				if (AccumulateCash < 0)
				{
					Green = int(Green * Alpha);
					Blue = int(Blue * Alpha);
				}
				else
				{
					Red = int(Red * Alpha);
					Blue = int(Blue * Alpha);
				}
			}

			if (LifeTime < AccCashLifeTime / 2)
			{
				if (AccumulateCash < 0)
				{
					int LocalAC = AccumulateCash * -1;
					FullMSG += "\n- " + formatInt(LocalAC) + "$";
				}
				else
				{
					FullMSG += "\n+ " + formatInt(AccumulateCash) + "$";
				}
			}

			HudTextParams pParams;
			pParams.x = 0.025f;
			pParams.y = 0.80999f;
			pParams.channel = 3;
			pParams.holdTime = 0.14f;
			pParams.SetColor(Color(Red, Green, Blue));
			Utils.GameTextPlayer(ToZPPlayer(PlrInd), FullMSG, pParams);
		}
	}
}

namespace Radio
{
	enum Menu_Inputs {IP_CLOSE, IP_PREV = 8, IP_NEXT, IP_MENU, IP_DROP}
	enum MenuSound_Indexes {SF_ACCEPT, SF_DENIED, SF_CLOSE}
	enum MenuGoTo {PAGE_PREV = -1, PAGE_NEXT = 1}
	enum Denied_Reasons {DR_EMPTY = -1, DR_NOCASH, DR_NOSPACE, DR_MAXEHP, DR_MAXLIFE, DR_MAXARMOR}
	enum RadioMenu_Types {RS_CAT, RS_MELEE, RS_FIREARMS, RS_AMMO, RS_ITEMS, RS_DROP, RS_ZOMBIE, RS_LOBBY, RS_SPEC}
	const int MAX_ITEMS_ON_PAGE = 7;
	const array<string> gMenuTitle =
	{
		"Menu",
		"Melee",
		"Firearms",
		"Ammo",
		"Items",
		"Drop Money",
		"Zombie Menu",
		"Lobby Menu",
		"Spectator Menu"
	};
	const array<string> gDeniedReason = 
	{
		"Недостаточно средств!",
		"Нет свободного места!",
		"Максимум доп. здоровья!",
		"Максимум доп. жизней!",
		"У вас уже есть броня!"
	};
	const array<string> gMenuSound = 
	{
		"buttons/button14.wav",
		"buttons/combine_button_locked.wav",
		"buttons/combine_button7.wav"
	};
	const array<array<array<string>>> gMenuData = 
	{
		{
			{"Melee",		"1"},
			{"Firearms",	"2"},
			{"Ammo",		"3"},
			{"Items",		"4"},
			{"Drop Money",	"5"}
		},
		{
			{"Hammer",			"150",		"weapon_barricade"},
			{"Shovel",			"450",		"weapon_shovel"},
			{"Sledgehammer",	"2000",		"weapon_sledgehammer"}
		},	
		{	
			{"Glock18c",		"165",		"weapon_glock18c"},
			{"Glock",			"105",		"weapon_glock"},
			{"USP",				"110",		"weapon_usp"},
			{"PPK",				"75",		"weapon_ppk"},
			{"AK47",			"625",		"weapon_ak47"},
			{"M4",				"575",		"weapon_m4"},
			{"MP5",				"425",		"weapon_mp5"},
			{"Remington 870",	"725",		"weapon_870"},
			{"SuperShorty",		"385",		"weapon_supershorty"},
			{"Winchester",		"345",		"weapon_winchester"},
			{"Revolver",		"900",		"weapon_revolver"}
		},
		{
			{"Pistol",		"75",	"15"},
			{"Revovler",	"295",	"6"},
			{"Shotgun",		"105",	"6"},
			{"Rifle",		"175",	"30"},
			{"Barricade",	"250",	"1"}
		},
		{
			{"Grenade",		"925",		"weapon_frag",	"0"},
			{"IED",			"1000",		"weapon_ied", 	"0"},
			{"FragMine",	"875",		"item_deliver",	"1"},
			{"Adrenaline",	"850",		"item_deliver",	"2"},
			{"Antidote",	"1500",		"item_deliver", "3"}
		},	
		{
			{"",	"100"},
			{"",	"150"},
			{"",	"200"},
			{"",	"250"},
			{"",	"300"}
		},
		{
			{"Extra HP",	"1150"},
			{"Exrta Life",	"1500"},
			{"Armor",		"850"}
		},
		{
			{"Get a Snowball",		"weapon_snowball"},
			{"Get a Tennis ball",	"weapon_tennisball"},
			{"Become a Firefly",	""},
			{"Reduce Scale",		""},
			{"Increase Scale",		""}
		},
		{
			{"Become a Firefly",	""}
		}
	};

	bool Command(const int &in nPlrInd, CASCommand@ pCC)
	{
		bool IsCommandExist = true;

		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(nPlrInd);
		int index = pPlayerEntity.entindex();
		int team = pPlayerEntity.GetTeamNumber();

		if (Utils.StrEql("firefly", pCC.Arg(0)) && team < TEAM_SURVIVORS)
		{
			NPZ::SetFirefly(pPlayerEntity, index, Utils.StringToInt(pCC.Arg(1)), Utils.StringToInt(pCC.Arg(2)), Utils.StringToInt(pCC.Arg(3)));
		}
		else if (Utils.StrEql("enhancevision", pCC.Arg(0)) && team == TEAM_LOBBYGUYS)
		{
			NPZ::DLight(pPlayerEntity, index);
		}
		else if (Utils.StrEql("dropweapon", pCC.Arg(0)))
		{
			Array_CSZMPlayer[nPlrInd].Input(IP_DROP);
			IsCommandExist = false;
		}
		else if (Utils.StrEql("as_slot", pCC.Arg(0)))
		{
			Array_CSZMPlayer[nPlrInd].Input(Utils.StringToInt(pCC.Arg(1)));
		}
		else if ((Utils.StrEql("taunt", pCC.Arg(0)) || Utils.StrEql("menu", pCC.Arg(0))) && RoundManager.GetRoundState() != rs_RoundEnd_Post)
		{
			IsCommandExist = !Utils.StrEql("taunt", pCC.Arg(0));
			if (!Array_CSZMPlayer[nPlrInd].Input(IP_MENU) && (pPlayerEntity.IsAlive() || team == TEAM_SPECTATORS))
			{
				switch(team)
				{
					case TEAM_SURVIVORS: Array_CSZMPlayer[nPlrInd].AddMenu(Radio::Menu(nPlrInd, Radio::RS_CAT)); break;
					case TEAM_ZOMBIES: Array_CSZMPlayer[nPlrInd].AddMenu(Radio::Menu(nPlrInd, Radio::RS_ZOMBIE)); break;
					case TEAM_LOBBYGUYS: Array_CSZMPlayer[nPlrInd].AddMenu(Radio::Menu(nPlrInd, Radio::RS_LOBBY)); break;
					case TEAM_SPECTATORS: Array_CSZMPlayer[nPlrInd].AddMenu(Radio::Menu(nPlrInd, Radio::RS_SPEC)); break;
				}
			}
		}
		else if (Utils.StrEql("ammo", pCC.Arg(0)) && team == TEAM_SURVIVORS && RoundManager.GetRoundState() != rs_RoundEnd_Post)
		{
			Array_CSZMPlayer[nPlrInd].AddMenu(Radio::Menu(nPlrInd, Radio::RS_AMMO));
		}
		else if (Utils.StrContains("holster", pCC.Arg(0)) && team == TEAM_LOBBYGUYS)
		{
			CBaseEntity@ pCurWep = ToZPPlayer(nPlrInd).GetCurrentWeapon();
			const string CWClassname = pCurWep.GetClassname();
			if (!Utils.StrEql("weapon_emptyhand", CWClassname))
			{
				NPZ::StripWeapon(ToZPPlayer(nPlrInd), CWClassname);
			}
		}
		else if (Utils.StrEql("dropcash", pCC.Arg(0)) && team == TEAM_SURVIVORS && Array_CSZMPlayer[index].CashBank - Utils.StringToInt(pCC.Arg(1)) > 0 && Utils.StringToInt(pCC.Arg(1)) != 0)
		{
			(Utils.StringToInt(pCC.Arg(1)) > 100) ? DropCash(index, Utils.StringToInt(pCC.Arg(1))) : Chat.PrintToChatPlayer(ToBasePlayer(index), strMinDrop);
		}
		else
		{
			IsCommandExist = false;
		}

		return IsCommandExist;
	}

	CEntityData@ GetInputData(const int nDeliverType)
	{
		CEntityData@ pResult = EntityCreator::EntityData();

		switch(nDeliverType)
		{
			case 1: @pResult = gFragMineIPD; break;
			case 2: @pResult = gAdrenalineIPD; break;
			case 3: @pResult = gAntidoteIPD; break;
		}
		return pResult;
	}

	void DropCash(const int &in PlrInd, const int &in nCashToDrop)
	{
		if (nCashToDrop == 0 || FindEntityByEntIndex(PlrInd) is null)
		{
			return;
		}

		Array_CSZMPlayer[PlrInd].CashBank -= nCashToDrop;

		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlrInd);

		Vector Velocity;
		Vector Eyes = pPlayerEntity.EyePosition() - Vector(0, 0, Math::RandomFloat(4, 16));
		QAngle Angles = pPlayerEntity.EyeAngles() + QAngle(0, Math::RandomFloat(-5, 5), 0);
		Globals.AngleVectors(Angles, Velocity);
		Velocity = Velocity * Math::RandomInt(185, 265) + pPlayerEntity.GetAbsVelocity() * 0.5f;
		Angles *= QAngle(0, 1, 0);

		CEntityData@ MoneyIPD = EntityCreator::EntityData();

		MoneyIPD.Add("targetname", "dropped_money");
		MoneyIPD.Add("canfirehurt", "0");
		MoneyIPD.Add("minhealthdmg", "1000");
		MoneyIPD.Add("model", "models/zp_props/100dollar/100dollar.mdl");
		MoneyIPD.Add("nodamageforces", "1");
		MoneyIPD.Add("nofiresound", "1");
		MoneyIPD.Add("physdamagescale", "0");
		MoneyIPD.Add("spawnflags", "8582");
		MoneyIPD.Add("unbreakable", "1");
		MoneyIPD.Add("overridescript", "mass,1,");

		CBaseEntity@ pMoney = EntityCreator::Create("prop_physics_override", Eyes, Angles, MoneyIPD);

		pMoney.SetClassname("item_money");
		pMoney.SetHealth(nCashToDrop);
		pMoney.Teleport(Eyes, (Angles +  QAngle(0, 90, 0)), Velocity);
		pMoney.SetOutline(true, filter_team, TEAM_SURVIVORS, Color(235, 65, 175), 185.0f, false, true);

		Engine.EmitSoundEntity(pPlayerEntity, ")player/footsteps/sand2.wav");

		NetData nData;
		nData.Write(pMoney.entindex());
		nData.Write(PlrInd);
		Network::CallFunction("OnItemCashCreation", nData);
	}

	int GiveAmmo(CZP_Player@ pPlayer, const int &in nAmmoType, const int &in nAmount)
	{
		int iResult = 0;

		for (int i = 0; i < nAmount; i++)
		{
			if (!pPlayer.AmmoBank(add, AmmoBankSetValue(nAmmoType), 1))
			{
				break;
			}

			iResult++;
		}

		return iResult;
	}

	class Menu
	{
		private int MenuType;
		private int PlrInd;
		private int TeamNum;
		private int TotalItems;
		private int TotalPages;
		private int CurrentPage;
		private int Start;
		private int Steps;
		private int SoundIndex;
		private float InputDelay;
		private float LifeTime;
		private float RefreshTime;
		private GameText::MenuKeyValyes@ pMParams;

		Menu(const int nPlrInd, const int nType)
		{
			PlrInd = nPlrInd;
			MenuType = nType;
			FillMenu(-1);
		}

		Menu(const int nPlrInd, const int nType, const int nLifeTime)
		{
			PlrInd = nPlrInd;
			MenuType = nType;
			FillMenu(nLifeTime);
		}

		private void FillMenu(const int nLifeTime)
		{
			ToZPPlayer(PlrInd).RefuseWeaponSelection(true);
			TeamNum = FindEntityByEntIndex(PlrInd).GetTeamNumber();
			SoundIndex = -1;
			Start = 0;
			CurrentPage = 1;
			RefreshTime = Globals.GetCurrentTime() + 0.089f;
			TotalItems = int(gMenuData[MenuType].length());
			TotalPages = int(ceil(float(TotalItems) / float(MAX_ITEMS_ON_PAGE)));
			Steps = (TotalItems > MAX_ITEMS_ON_PAGE) ? MAX_ITEMS_ON_PAGE : TotalItems;

			UpdateMenu(nLifeTime);
		}

		private void UpdatePage()
		{
			Start = 7 * CurrentPage - 7;

			if (CurrentPage < TotalPages)
			{
				Steps = MAX_ITEMS_ON_PAGE;
			}
			else if (CurrentPage == TotalPages && CurrentPage * MAX_ITEMS_ON_PAGE > TotalItems)
			{
				Steps = TotalItems - Start;
			}

			UpdateMenu(-1);
		}

		private void UpdateMenu(float nLifeTime)
		{
			@pMParams = GameText::MenuKeyValyes();

			int length = Start + Steps;
			int Num = 0;
			pMParams.Add("title", "-= " + gMenuTitle[MenuType] + " =-");
			pMParams.Add("holdtime", "0.12");

			for (int i = Start; i < length; i++)
			{
				string dItem = gMenuData[MenuType][i][0];

				if (Utils.StringToInt(gMenuData[MenuType][i][1]) > 0 && MenuType != RS_CAT)
				{
					dItem += " - " + gMenuData[MenuType][i][1] + "$";
				}

				Num++;
				pMParams.Add("item" + formatInt(Num), dItem);
			}

			if (TotalPages > 1)
			{
				if (CurrentPage < TotalPages)
				{
					pMParams.Add("next", "true");
				}
				else if (CurrentPage == TotalPages)
				{
					pMParams.Add("prev", "true");
				}
				else
				{
					pMParams.Add("next", "true");
					pMParams.Add("prev", "true");
				}
			}

			if (IsAllowedGetBackToCAT())
			{
				pMParams.Update("prev", "true");
			}

			if (LifeTime == Globals.GetCurrentTime())
			{
				pMParams.Add("fadeout", "0.2");
			}

			SendMenu(nLifeTime);
		}

		void Input(int iSlot)
		{
			if (!LessThanGT(InputDelay))
			{
				return;
			}

			InputDelay = PlusGT(0.04f);
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlrInd);
			SoundIndex = -1;

			if (iSlot == IP_MENU)
			{
				iSlot = (IsAllowedGetBackToCAT() || IsPrevPageExist()) ? IP_PREV : IP_CLOSE;
			}

			if (iSlot == IP_CLOSE)
			{
				SendExit(false);
			}
			else if (iSlot == IP_NEXT && IsNextPageExist())
			{
				GoToPage(PAGE_NEXT);
			}
			else if (iSlot == IP_PREV)
			{
				if (IsPrevPageExist())
				{
					GoToPage(PAGE_PREV);
				}
				else if (IsAllowedGetBackToCAT())
				{
					SoundIndex = SF_ACCEPT;
					Array_CSZMPlayer[PlrInd].AddMenu(Radio::Menu(PlrInd, RS_CAT));
				}
			}
			else if (iSlot <= Steps)
			{
				SoundIndex = SF_ACCEPT;
				Select(Start + iSlot - 1);
			}

			PlaySound();
		}

		void Select(const int iItemIndex)
		{
			CZP_Player@ pPlayer = ToZPPlayer(PlrInd);
			int CashToPay = Utils.StringToInt(gMenuData[MenuType][iItemIndex][1]);

			if (MenuType != RS_CAT && Array_CSZMPlayer[PlrInd].CashBank < CashToPay)
			{
				Denied(DR_NOCASH);
				CashToPay = 0;
			}
			else if (MenuType == RS_CAT)
			{
				Array_CSZMPlayer[PlrInd].AddMenu(Radio::Menu(PlrInd, CashToPay));
				CashToPay = 0;
			}
			else if (MenuType == RS_FIREARMS || MenuType == RS_MELEE || MenuType == RS_ITEMS)
			{
				CBaseEntity@ pGun = (MenuType == RS_ITEMS) ? EntityCreator::Create(gMenuData[MenuType][iItemIndex][2], Vector(0, 0, 0), QAngle(0, 0, 0), GetInputData(Utils.StringToInt(gMenuData[MenuType][iItemIndex][3]))) : EntityCreator::Create(gMenuData[MenuType][iItemIndex][2], Vector(0, 0, 0), QAngle(0, 0, 0));
				if (pPlayer.PutToInventory(pGun))
				{
					Engine.EmitSoundEntity(FindEntityByEntIndex(PlrInd), "HL2Player.PickupWeapon");
				}
				else
				{
					pGun.SUB_Remove();
					Denied(DR_NOSPACE);
					CashToPay = 0;
				}
			}
			else if (MenuType == RS_AMMO)
			{
				int Amount = Utils.StringToInt(gMenuData[MenuType][iItemIndex][2]);
				int SoldOutAmount = GiveAmmo(pPlayer, iItemIndex, Amount);
				int NewCost = int(ceil((float(CashToPay) / float(Amount)) * (float(SoldOutAmount) / float(CashToPay)) * float(CashToPay)));

				if (SoldOutAmount > 0)
				{
					(iItemIndex == 4) ? Engine.EmitSoundEntity(FindEntityByEntIndex(PlrInd), "HL2Player.PickupWeapon") : Engine.EmitSoundEntity(FindEntityByEntIndex(PlrInd), "ZPlayer.AmmoPickup");
					CashToPay = NewCost;
				}
				else
				{
					Denied(DR_NOSPACE);
					CashToPay = 0;
				}
			}
			else if (MenuType == RS_DROP)
			{
				DropCash(PlrInd, CashToPay);
				CashToPay = 0;
			}
			else if (MenuType == RS_ZOMBIE)
			{
				switch(iItemIndex)
				{
					case 0: Array_CSZMPlayer[PlrInd].AddExtraHealth() ? TakeCost(CashToPay) : Denied(DR_MAXEHP); break;
					case 1: Array_CSZMPlayer[PlrInd].AddExtraLife() ? TakeCost(CashToPay) : Denied(DR_MAXLIFE); break;
					case 2: Array_CSZMPlayer[PlrInd].AddZMArmor() ? TakeCost(CashToPay) : Denied(DR_MAXARMOR); break;
				}
				CashToPay = 0;
			}
			else if (MenuType == RS_LOBBY)
			{
				switch(iItemIndex)
				{
					case 0: NPZ::GiveThrowable(pPlayer, gMenuData[MenuType][iItemIndex][1]); break;
					case 1: NPZ::GiveThrowable(pPlayer, gMenuData[MenuType][iItemIndex][1]); break;
					case 2: if (!NPZ::SetFirefly(FindEntityByEntIndex(PlrInd), PlrInd, 0, 0, 0)) {Denied(DR_EMPTY);} break;
					case 3: if (!Array_CSZMPlayer[PlrInd].ChangeScale(-0.05f)) {Denied(DR_EMPTY);} break;
					case 4: if (!Array_CSZMPlayer[PlrInd].ChangeScale(0.05f)) {Denied(DR_EMPTY);} break;
				}
			}
			else if (MenuType == RS_SPEC)
			{
				switch(iItemIndex)
				{
					case 0: if (!NPZ::SetFirefly(FindEntityByEntIndex(PlrInd), PlrInd, 0, 0, 0)) {Denied(DR_EMPTY);} break;
				}
			}

			TakeCost(CashToPay);
			SendMenu(-1);
		}

		private void TakeCost(const int iCost)
		{
			if (iCost != 0)
			{
				Array_CSZMPlayer[PlrInd].CashBank -= iCost;
				Array_CSZMPlayer[PlrInd].pCash.CheckCash();
			}
		}

		private void Denied(const int iReason)
		{
			SoundIndex = SF_DENIED;
			if (iReason > DR_EMPTY)
			{
				Chat.PrintToChatPlayer(ToBasePlayer(PlrInd), "{red}*{gold}" + gDeniedReason[iReason]);
			}
		}

		private void GoToPage(int i)
		{
			SoundIndex = SF_ACCEPT;
			CurrentPage += i;
			UpdatePage();
		}

		private void SendMenu(float nLifeTime)
		{
			LifeTime = (nLifeTime < 0) ? PlusGT(10.0f) : PlusGT(nLifeTime);
			GameText::Menu(PlrInd, pMParams);
		}

		private void SendExit(bool bSilent)
		{
			if (!bSilent)
			{
				SoundIndex = SF_CLOSE;
			}

			pMParams.Update("holdtime", "0.0");
			pMParams.Update("fadeout", "0.15");
			GameText::Menu(PlrInd, pMParams);
			ToZPPlayer(PlrInd).RefuseWeaponSelection(false);
			Array_CSZMPlayer[PlrInd].ExitMenu();
		}

		private void PlaySound()
		{
			if (SoundIndex == -1)
			{
				return;
			}

			Engine.EmitSoundPlayer(ToZPPlayer(PlrInd), gMenuSound[SoundIndex]);
		}

		private bool IsNextPageExist()
		{
			return CurrentPage < TotalPages && TotalPages > 1;
		}

		private bool IsPrevPageExist()
		{
			return CurrentPage != 1 && TotalPages > 1;
		}

		private bool IsAllowedGetBackToCAT()
		{
			return (MenuType == RS_FIREARMS || MenuType == RS_DROP || MenuType == RS_AMMO || MenuType == RS_MELEE || MenuType == RS_ITEMS) && CurrentPage == 1;
		}

		void Think()
		{
			if (LessThanGT(RefreshTime) && pMParams !is null)
			{
				RefreshTime = PlusGT(0.089f);
				GameText::Menu(PlrInd, pMParams);

				if ((!FindEntityByEntIndex(PlrInd).IsAlive() && FindEntityByEntIndex(PlrInd).GetTeamNumber() != TEAM_SPECTATORS) || FindEntityByEntIndex(PlrInd).GetTeamNumber() != TeamNum)
				{
					SendExit(true);
				}
			}

			if (LessThanGT(LifeTime))
			{
				SendExit(false);
				PlaySound();
			}
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Lock and Load
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void CSZM_LocknLoad()
{
	flRTWait = Globals.GetCurrentTime();

	Engine.EmitSound("CS_MatchBeginRadio");

	Globals.SetPlayerRespawnDelay(false, CONST_SPAWN_DELAY);
	Globals.SetPlayerRespawnDelay(true, CONST_SPAWN_DELAY);

	HealthSettings();

	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() != TEAM_LOBBYGUYS)
		{
			continue;
		}

		lobby_hint(ToZPPlayer(i));
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Entities Forwards
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (!bIsCSZM || pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (Utils.StrContains("used", pEntity.GetEntityName()))
	{
		pEntity.SUB_Remove();
	}
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (!bIsCSZM || pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
	int index = pPlayerEntity.entindex();

	if (Utils.StrEql("dropped_money", pEntity.GetEntityName(), true))
	{
		Engine.EmitSoundPosition(pPlayerEntity.entindex(), ")cszm_fx/items/gunpickup1.wav", pPlayerEntity.GetAbsOrigin() + Vector(0, 0, 16), 0.7f, 65, 110);
		Array_CSZMPlayer[index].CashBank += pEntity.GetHealth();
		pEntity.SUB_Remove();
	}
}

void OnItemDeliverUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity, int &in iEntityOutput)
{
	if (!bIsCSZM || pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	int index = pBaseEnt.entindex();
	string Targetname = pEntity.GetEntityName();
	CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[index];

	if (Utils.StrContains("item_antidote", Targetname))
	{
		pCSZMPlayer.InjectAntidote(pEntity);
	}

	if (Utils.StrEql("item_adrenaline", Targetname))
	{
		pCSZMPlayer.InjectAdrenaline(pEntity);
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Hooks
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

HookReturnCode CSZM_RoundWin(const string &in strMapname, RoundWinState iWinState)
{
	if (bIsCSZM)
	{
		flRTWait = 0;
		pCSZMTimer.StopHUDTimer();
		@pCSZMTimer = null;

		if (iWinState == STATE_HUMAN)
		{
			Engine.EmitSoundPosition(0, "@cszm_fx/misc/hwin.wav", Vector(0, 0, 0), 1.0f, 0, Math::RandomInt(75, 125));
			iHumanWin++;
		}
		else if (iWinState == STATE_ZOMBIE)
		{
			Engine.EmitSoundPosition(0, "@cszm_fx/misc/zwin.wav", Vector(0, 0, 0), 1.0f, 0, 100);
			iZombieWin++;
		}

		ApplyVictoryRewards(iWinState);

		string strHW = "\n Люди: " + formatInt(iHumanWin);
		string strZW = "\n Зомби: " + formatInt(iZombieWin);
		
		SendGameText(any, "-=Счётчик побед=-" + strHW + strZW, 4, 0, 0, 0.35f, 0.25f, 0, 10.10f, Color(235, 235, 235), Color(255, 95, 5));
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

		@Array_CSZMPlayer[index] = CSZMPlayer(index, pPlayer);
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnConCommand(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HOOK_RESULT = HOOK_CONTINUE;

	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int index = pBaseEnt.entindex();

		CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[index];

		if (!RoundManager.IsRoundOngoing(false))
		{
			if (Utils.StrContains("choose", pArgs.Arg(0)) && pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS) 
			{
				if (bWarmUp)
				{
					HOOK_RESULT = HOOK_HANDLED;
					if (Utils.StrEql("choose4", pArgs.Arg(0)))
					{
						pCSZMPlayer.RespawnLobby();
					}
				}
				else
				{
					if (Utils.StrEql("choose2", pArgs.Arg(0)))
					{
						HOOK_RESULT = HOOK_HANDLED;
						pPlayer.ConsoleCommand("choose1");
					}
				}
			}
		}
		else
		{
			if ((Utils.StrEql("choose1", pArgs.Arg(0)) || Utils.StrEql("choose2", pArgs.Arg(0))) && pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
			{
				if (pCSZMPlayer.Abuser || bIsPlayersSelected)
				{
					pPlayer.ConsoleCommand("choose3");
					HOOK_RESULT = HOOK_HANDLED;
				}
				else
				{
					pBaseEnt.ChangeTeam(TEAM_SURVIVORS);
					pPlayer.ForceRespawn();
					pPlayer.SetHudVisibility(true);
					HOOK_RESULT = HOOK_HANDLED;
				}
			}
		}

		HOOK_RESULT = (Admin::Command(pPlrEnt, pArgs, false) || HOOK_RESULT == HOOK_HANDLED) ? HOOK_HANDLED : HOOK_CONTINUE;
		HOOK_RESULT = (Radio::Command(index, pArgs) || HOOK_RESULT == HOOK_HANDLED) ? HOOK_HANDLED : HOOK_CONTINUE;
	}

	return HOOK_RESULT;
}

HookReturnCode CSZM_OnPlayerSpawn(CZP_Player@ pPlayer)
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int index = pBaseEnt.entindex();
		int TeamNum = pBaseEnt.GetTeamNumber();

		if (Array_CSZMPlayer[index].Scale != 1.0f)
		{
			Array_CSZMPlayer[index].SetScale(1.0f);
		}

		if (TeamNum != TEAM_LOBBYGUYS)
		{
			CBaseEntity@ pPlrDlight = FindEntityByName(null, (formatInt(index) + "dlight_origin"));
			if (pPlrDlight !is null)
			{
				Engine.EmitSoundEntity(pBaseEnt, "Buttons.snd14");
				pPlrDlight.SUB_Remove();
			}
		}

		if (TeamNum != TEAM_SPECTATORS)
		{
			CBaseEntity@ pSpriteEnt = FindEntityByName(pSpriteEnt, formatInt(index) + "firefly_sprite");
			if (pSpriteEnt !is null)
			{
				pSpriteEnt.SUB_Remove();
			}
		}

		switch(TeamNum)
		{
			case TEAM_SPECTATORS:
				spec_hint(pPlayer);
			break;

			case TEAM_LOBBYGUYS:
				(bWarmUp) ? lobby_hint_wu(pPlayer) : lobby_hint(pPlayer);
				pPlayer.SetVoice(eugene);
				Array_CSZMPlayer[index].SetDefSpeed(SPEED_DEFAULT);
				pPlayer.SetArmModel(MODEL_HUMAN_ARMS);
				pBaseEnt.SetModel(MODEL_PLAYER_LOBBYGUY);
				if (bWarmUp) {Array_CSZMPlayer[index].AddMenu(Radio::Menu(index, Radio::RS_LOBBY, 20.0f));}
			break;

			case TEAM_SURVIVORS:
				Array_CSZMPlayer[index].SetDefSpeed(SPEED_HUMAN);
				if (!bIsPlayersSelected && !Array_CSZMPlayer[index].Cured) {Array_CSZMPlayer[index].AddMenu(Radio::Menu(index, Radio::RS_CAT, 30.0f));}
			break;
		}

		if (bWarmUp)
		{
			if (TeamNum != TEAM_SPECTATORS)
			{
				PutPlrToPlayZone(pBaseEnt);
			}

			if (pPlrEnt.IsBot())
			{
				pBaseEnt.ChangeTeam(TEAM_LOBBYGUYS);
				pPlayer.ForceRespawn();
				pBaseEnt.SetModel(MODEL_PLAYER_LOBBYGUY);
			}

			if (CountPlrs(TEAM_LOBBYGUYS) <= 2 && iWUSeconds == iWarmUpTime)
			{
				flWUWait = Globals.GetCurrentTime();
			}
		}

		RemoveProp(pBaseEnt);
		Engine.EmitSoundEntity(pBaseEnt, "CSPlayer.Mute");
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &out DamageInfo)
{
	if (bIsCSZM)
	{
		CZP_Player@ pPlrAttacker = null;
		CSZMPlayer@ pAttCSZMPlayer = null;
		string strAttName = "";

		float flDamage = DamageInfo.GetDamage();
		int iDamageType = DamageInfo.GetDamageType();

		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		int iVicIndex = pBaseEnt.entindex();
		int iVicTeam = pBaseEnt.GetTeamNumber();
		string strVicName = pPlayer.GetPlayerName();

		CBaseEntity@ pAttackerEntity = DamageInfo.GetAttacker();

		int iAttIndex = pAttackerEntity.entindex();
		int iAttTeam = pAttackerEntity.GetTeamNumber();

		CSZMPlayer@ pVicCSZMPlayer = Array_CSZMPlayer[iVicIndex];

		if (Utils.StrContains("physics", pAttackerEntity.GetClassname()) || Utils.StrContains("physbox", pAttackerEntity.GetClassname()))
		{
			string AttInfo = GetAttackerInfo(pAttackerEntity.GetEntityDescription());
			CASCommand@ pSplitArgs = StringToArgSplit(AttInfo, ":");
			int iPhysAttacker = Utils.StringToInt(pSplitArgs.Arg(0));

			if (iPhysAttacker > 0)
			{
				@pAttackerEntity = FindEntityByEntIndex(iPhysAttacker);
				@pAttCSZMPlayer = Array_CSZMPlayer[iPhysAttacker];
				iAttIndex = iPhysAttacker;
				iAttTeam = pAttackerEntity.GetTeamNumber();
				DamageInfo.SetAttacker(pAttackerEntity);
			}
		}

		if (!pAttackerEntity.IsPlayer())
		{
			if ((Utils.StrEql(pAttackerEntity.GetClassname(), "worldspawn") && bDamageType(iDamageType, 0)) || (Utils.StrEql(pAttackerEntity.GetEntityName(), "frendly_shrapnel") && iVicTeam == TEAM_SURVIVORS) || (iAttTeam == iVicTeam && iAttIndex != iVicIndex))
			{
				DamageInfo.SetDamageType(1<<9);
				DamageInfo.SetDamage(0);
			}
		}
		else
		{
			@pAttCSZMPlayer = Array_CSZMPlayer[iAttIndex];
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			strAttName = pPlrAttacker.GetPlayerName();
		}

		if (iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && bDamageType(iDamageType, 2))
		{
			DamageInfo.SetDamage(Math::RandomInt(15, 20));
			DamageInfo.SetDamageType((1<<9));

			if (Utils.GetNumPlayers(survivor, true) == 1)
			{
				DamageInfo.SetDamage(flDamage);
			}
			else if (pVicCSZMPlayer.InfectResist > 0)
			{
				pVicCSZMPlayer.SubtractInfectResist();
			}
			else if (pVicCSZMPlayer.InfectResist <= 0 && pAttCSZMPlayer.CanInfect())
			{
				pVicCSZMPlayer.Spawn = false;
				DamageInfo.SetDamage(0);
				pAttCSZMPlayer.AddVictim();
				KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, true, false);
				GotVictim(pPlrAttacker, pAttackerEntity);
				TurnToZombie(iVicIndex);

				if (!pVicCSZMPlayer.Cured)
				{
					pVicCSZMPlayer.AddInfectPoints(15);
					pAttCSZMPlayer.AddInfectPoints(-1);
				}
			}
		}
		
		if (iVicTeam == TEAM_ZOMBIES && pBaseEnt.IsAlive())
		{
			CBaseEntity@ pInflictor = DamageInfo.GetInflictor();

			if (pInflictor !is null && Utils.StrEql("npc_grenade_frag", pInflictor.GetClassname(), true) && iDamageType == 1)
			{
				Engine.Ent_Fire_Ent(pInflictor, "settimer", "0", "0");
			}

			if (bDamageType(DamageInfo.GetDamageType(), 7) && DamageInfo.GetDamage() < pBaseEnt.GetHealth())
			{
				pVicCSZMPlayer.pTimeDamage.insertLast(TimeBasedDamage(iAttIndex, flDamage, TBD_BLEEDING));
			}

			if (bDamageType(iDamageType, 29) && flDamage >= 150 && pBaseEnt.GetHealth() <= flDamage && Math::RandomInt(0, 100) <= 70)
			{
				float NewDamage = flDamage;

				if (NewDamage > 200)
				{
					NewDamage = 200;
				}

				DamageInfo.SetDamage(NewDamage);
				DamageInfo.SetDamageType(1<<0);
			}

			if (iAttTeam == TEAM_SURVIVORS)
			{
				ShowHitMarker(iAttIndex, (pBaseEnt.GetHealth() <= DamageInfo.GetDamage()));
				pAttCSZMPlayer.AddMoney(DamageToMoney(pBaseEnt.GetHealth(), int(DamageInfo.GetDamage())));
			}

			if (flDamage < pBaseEnt.GetHealth() && !bDamageType(iDamageType, 14) && ((iAttTeam == iVicTeam && iAttIndex == iVicIndex) || iAttTeam != iVicTeam))
			{
				//ZM ViewPunch
				bool bLeft = Math::RandomInt(0 , 1) > 0;
				float VP_X = bDamageType(iDamageType, 5) ? Math::RandomFloat(-0.15f, -0.30f) : Math::RandomFloat(-1.75f, 1.85f);
				float VP_Y = bDamageType(iDamageType, 5) ? Math::RandomFloat(-4.75f, -7.15f) : Math::RandomFloat(-1.75f, 1.85f);
				float VP_DAMP = bDamageType(iDamageType, 5) ? Math::RandomFloat(0 , 0.015f) : Math::RandomFloat(0.038f , 0.075f);
				float VP_KICK = Math::RandomFloat(0.25f , 0.95f);

				Utils.FakeRecoil(pPlayer, VP_KICK, VP_DAMP, VP_X, VP_Y, bLeft);
				pVicCSZMPlayer.EmitZombieSound(VOICE_ZM_PAIN);
			}
		}

		if (!bDamageType(iDamageType, 17))
		{
			pVicCSZMPlayer.AddSlowdown();
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerInfected(CZP_Player@ pPlayer, InfectionState iState)
{
	//Built-in infection is not allowed
	if (bIsCSZM && iState != state_none)
	{
		pPlayer.SetInfection(true, 2.0f);
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
		CSZMPlayer@ pAttCSZMPlayer = null;
		string strAttName = "";
	
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
		
		int iVicIndex = pBaseEnt.entindex();
		int iVicTeam = pBaseEnt.GetTeamNumber();
		string strVicName = pPlayer.GetPlayerName();
		
		CBaseEntity@ pAttackerEntity = DamageInfo.GetAttacker();
		
		int iAttIndex = pAttackerEntity.entindex();
		int iAttTeam = pAttackerEntity.GetTeamNumber();

		CSZMPlayer@ pVicCSZMPlayer = Array_CSZMPlayer[iVicIndex];

		int iDamageType = DamageInfo.GetDamageType();
		
		if (pAttackerEntity.IsPlayer()) 
		{
			@pAttCSZMPlayer = Array_CSZMPlayer[iAttIndex];
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			strAttName = pPlrAttacker.GetPlayerName();
		}

		if (iAttIndex == iVicIndex || !pAttackerEntity.IsPlayer())
		{
			bSuicide = true;

			if (iSeconds > 0)
			{
				KillFeed("", 0, strVicName, iVicTeam, false, true);
			}

			if (iVicTeam > TEAM_SPECTATORS && RoundManager.GetRoundState() == rs_RoundOnGoing)
			{
				pVicCSZMPlayer.AddMoney(ECO_Suiside);
				Chat.PrintToChatPlayer(pPlrEnt, "{red}" + formatInt(ECO_Suiside) + "$ {gold}За самоубийство!");
			}
			/*if (!pVicCSZMPlayer.Spawn)
			{
				pVicCSZMPlayer.AddInfectPoints(25);
			}*/
		}
		else if (iAttIndex != iVicIndex && pAttackerEntity.IsPlayer())
		{
			KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, false, false);
		}

		if (iVicTeam == TEAM_ZOMBIES)
		{
			if (pVicCSZMPlayer.FirstInfected)
			{
				DetachEyesLights(pBaseEnt);
			}

			if (!(bDamageType(iDamageType, 6) || bDamageType(iDamageType, 0)))
			{
				pVicCSZMPlayer.EmitZombieSound(VOICE_ZM_DIE);
			}

			if (!bSuicide)
			{
				pAttCSZMPlayer.AddMoney(ECO_Human_Kill);
				pAttCSZMPlayer.AddKill();

				if (!pVicCSZMPlayer.Spawn)
				{
					pAttCSZMPlayer.AddInfectPoints(-5);
					pVicCSZMPlayer.AddInfectPoints(15);
				}
			}
		}

		if (iVicTeam == TEAM_SURVIVORS)
		{
			if (Utils.GetNumPlayers(survivor, false) == 1 && Utils.GetNumPlayers(zombie, false) > 0)
			{
				RoundManager.SetWinState(ws_ZombieWin);
			}

			if (iAttTeam == TEAM_ZOMBIES && pAttackerEntity.IsPlayer())
			{
				GotVictim(pPlrAttacker, pAttackerEntity);
				pAttCSZMPlayer.AddVictim();

				if (!pVicCSZMPlayer.Cured)
				{
					pAttCSZMPlayer.AddInfectPoints(-10);
					pVicCSZMPlayer.AddInfectPoints(20);
				}
			}

			pVicCSZMPlayer.SetAbuser(bSuicide);
		}

		pVicCSZMPlayer.DeathReset();
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerDisconnected(CZP_Player@ pPlayer)
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int index = pBaseEnt.entindex();

		if (Array_CSZMPlayer[index].FirstInfected)
		{
			Array_CSZMPlayer[index].AddInfectPoints(50);
			Array_CSZMPlayer[index].SetAbuser(true);
		}

		@Array_CSZMPlayer[index] = null;
		
		if (pBaseEnt.GetTeamNumber() == TEAM_ZOMBIES && Utils.GetNumPlayers(zombie, false) <= 1 && RoundManager.IsRoundOngoing(false))
		{
			Engine.EmitSound("buttons/button8.wav");
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
			AttachTrail(pEntity, "245 16 16");
		}
		else if (Utils.StrEql("projectile_nonhurtable", strClassname) && Utils.StrEql("models/weapons/w_snowball.mdl", pEntity.GetModelName()))
		{
			AttachTrail(pEntity, "16 137 255");
		}
		else if (Utils.StrEql("projectile_nonhurtable", strClassname) && Utils.StrEql("models/weapons/w_tennisball.mdl", pEntity.GetModelName()))
		{
			AttachTrail(pEntity, "255 230 0");
		}
		else if (Utils.StrContains("prop_barricade", strClassname))
		{
			Engine.Ent_Fire_Ent(pEntity, "DisableShadow");
		}
		else if (Utils.StrContains("prop", strClassname))
		{
			CheckProp(pEntity, strClassname);
		}

		if (Utils.StrEql("projectile_nonhurtable", strClassname))
		{
			CBaseEntity@ pOwner = pEntity.GetOwner();

			if (pOwner !is null && pOwner.IsPlayer() && pOwner.GetTeamNumber() == TEAM_LOBBYGUYS)
			{
				(ToZPPlayer(pOwner)).AmmoWeapon(set, 15);
			}
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnEntityDestruction(const string &in strClassname, CBaseEntity@ pEntity)
{
	if (Utils.StrEql("npc_grenade_frag", strClassname, true))
	{
		ShootTracers(pEntity.GetAbsOrigin());
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	if (!bIsCSZM)
	{
		return HOOK_CONTINUE;
	}

	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();

	if (pAttacker.IsPlayer() && Utils.StrEql("weapon_sledgehammer", (ToZPPlayer(pAttacker).GetCurrentWeapon()).GetClassname(), true) && pEntity.IsPlayer())
	{
		ToZPPlayer(pEntity).SetArmor(0);
		DamageInfo.SetDamage(pEntity.GetHealth() * 2 + 200);
		DamageInfo.SetDamageType(1);
	}

	DamageInfo.SetDamage(floor(DamageInfo.GetDamage()));

	int EntIndex = pEntity.entindex();
	int iDMGType = DamageInfo.GetDamageType();
	int iAttakerIndex = pAttacker.entindex();
	int iAttakerTeam = pAttacker.GetTeamNumber();

	bool bIsUnbreakable = bIsPropUnbreakable(pEntity); 
	bool bIsJunk = bIsPropJunk(pEntity);
	bool bIsExplosive = bIsPropExplosive(pEntity);

	string strEntClassname = pEntity.GetClassname();

	if (Utils.StrEql(pAttacker.GetEntityName(), "frendly_shrapnel"))
	{
		DamageInfo.SetDamage(15 + Math::RandomInt(7, 18));

		if (pAttacker.GetHealth() > 0)
		{
			CBaseEntity@ pNewAttacker = FindEntityByEntIndex(pAttacker.GetHealth());

			@pAttacker = pNewAttacker;
			DamageInfo.SetAttacker(pNewAttacker);
			DamageInfo.SetInflictor(pAttacker);
			DamageInfo.SetWeapon(pAttacker);
		}
		else if (pEntity.GetTeamNumber() == TEAM_SURVIVORS && pEntity.IsPlayer())
		{
			DamageInfo.SetDamage(0);
		}
	}
	else if (Utils.StrEql(pAttacker.GetClassname(), "npc_fragmine"))
	{
		CBaseEntity@ pMineOwner = FindEntityByEntIndex(Utils.StringToInt(pAttacker.GetEntityDescription()));

		if (pMineOwner !is null)
		{
			@pAttacker = pMineOwner;
			DamageInfo.SetAttacker(pMineOwner);
			DamageInfo.SetInflictor(pMineOwner);
			iAttakerTeam = pMineOwner.GetTeamNumber();
			iAttakerIndex = pMineOwner.entindex();
		}
	}

	//Reduce input damage if it's "prop_door_rotating" and a damage type is BULLET
	if (Utils.StrEql("prop_door_rotating", strEntClassname))
	{
		if (bDamageType(iDMGType, 1))	//If damage type is BULLET
		{
			DamageInfo.SetDamage(DamageInfo.GetDamage() * 0.25f);		
		}
		else if (bDamageType(iDMGType, 6))	//If damage type is BLAST
		{
			DamageInfo.SetDamage(DamageInfo.GetDamage() * 0.5f);
			DamageInfo.SetDamageType(0);
		}
	}

	//Slightly increas input damage if it's "prop_barricade"
	if (Utils.StrEql(strEntClassname, "prop_barricade"))
	{
		DamageInfo.SetDamage(DamageInfo.GetDamage() * 1.21f);
	}

	//Show HP to zombie attacker
	if (pAttacker.IsPlayer() && iAttakerTeam == TEAM_ZOMBIES && !(bIsUnbreakable || bIsExplosive) && pEntity.GetMaxHealth() > 25 && !pEntity.IsPlayer() && bDamageType(DamageInfo.GetDamageType(), 2) && !Utils.StrContains("weapon", strEntClassname))
	{
		Array_CSZMPlayer[iAttakerIndex].ShowHealthLeft(int(DamageInfo.GetDamage()), pEntity.GetHealth());
	}

	//Other stuff
	//Rule to prevent TK with physics
	if ((Utils.StrContains("physics", strEntClassname) || Utils.StrContains("physbox", strEntClassname)) && pAttacker.IsPlayer())
	{
		string EntDesc = pEntity.GetEntityDescription();
		string AttInfo = GetAttackerInfo(EntDesc);
		CASCommand@ pSplitArgs = StringToArgSplit(AttInfo, ":");
		bool bSetNewAttacker = true;
		EntDesc = EraseAttackerInfo(EntDesc);
		if (pSplitArgs.Args() > 1)
		{
			if (Utils.StringToFloat(pSplitArgs.Arg(1)) > Globals.GetCurrentTime() && Utils.StringToInt(pSplitArgs.Arg(0)) != iAttakerIndex)
			{
				bSetNewAttacker = false;
			}
		}

		if (bSetNewAttacker)
		{
			pEntity.ChangeTeam(iAttakerTeam);
			pEntity.SetEntityDescription(EntDesc + "|" + iAttakerIndex + ":" + "" + (PlusGT(7.04f)) + "|");
		}
	}

	//Only for survivors
	//Special rule for prop_physics
	if (Utils.StrContains("physics", strEntClassname) && iAttakerTeam == TEAM_SURVIVORS)
	{
		//Getting some important data there
		float flMass = pEntity.GetMass();
		float flForceMultiplier = 1.0f;

		//If Damage Type is BULLET reduce amount of damage and increase force by fake mass
		if (bDamageType(iDMGType, 1) && pAttacker.IsPlayer())
		{
			string WeaponName = (ToZPPlayer(pAttacker).GetCurrentWeapon()).GetClassname();
			Vector DamageForce = DamageInfo.GetDamageForce();

			//Set DMG_BULLET Damage Type, otherwise it won't push
			DamageInfo.SetDamageType(1<<1);
			DamageInfo.ScaleDamageForce(1.0f);

			if (Utils.StrEql("weapon_glock", WeaponName) || Utils.StrEql("weapon_usp", WeaponName) || Utils.StrEql("weapon_glock18c", WeaponName) || Utils.StrEql("weapon_mp5", WeaponName))
			{
				flForceMultiplier = 0.59f;
			}
			else if (Utils.StrEql("weapon_ppk", WeaponName))
			{
				flForceMultiplier = 1.85f;
			}
			else if (Utils.StrEql("weapon_m4", WeaponName) || Utils.StrEql("weapon_ak47", WeaponName))
			{
				flForceMultiplier = 0.98f;
			}
			else if (Utils.StrEql("weapon_870", WeaponName) || Utils.StrEql("weapon_winchester", WeaponName))
			{
				flForceMultiplier = 0.195f;
			}
			else if (Utils.StrEql("weapon_supershorty", WeaponName))
			{
				flForceMultiplier = 0.2675f;
			}
			else if (Utils.StrEql("weapon_revolver", WeaponName))
			{
				flForceMultiplier = 0.18f;
			}

			flForceMultiplier *= (flMass * 0.25f);

			DamageInfo.SetDamageForce((DamageForce * flForceMultiplier));

			//Do not reduce damage if explosive props or junk
			if (!(bIsJunk || bIsExplosive))
			{
				DamageInfo.SetDamage(DamageInfo.GetDamage() * 0.0225f);	
			}
		}
	}

	//Break "prop_itemcrate" if punt
	if (Utils.StrEql("prop_itemcrate", strEntClassname) && DamageInfo.GetDamageType() == (1<<23))
	{
		DamageInfo.SetDamageType(1<<13);
		DamageInfo.SetDamage(pEntity.GetHealth());
	}

	//Don't deal any damage if unbreakable
	if (bIsUnbreakable)
	{
		DamageInfo.SetDamageType(1<<28);
		DamageInfo.SetDamage(0);
	}

	if (bIsExplosive && pEntity.GetHealth() > 20)
	{
		pEntity.SetHealth(19);
	}

	//Don't push weapons and items
	if (Utils.StrContains("weapon", strEntClassname) || Utils.StrContains("item", strEntClassname))
	{
		DamageInfo.SetDamageType((1<<11));
		DamageInfo.SetDamageForce(Vector(0, 0, 0));
	}

	if (!pEntity.IsPlayer() && iAttakerTeam == TEAM_ZOMBIES)
	{
		int iPropHealth = int(DamageInfo.GetDamage());

		if (iPropHealth > pEntity.GetHealth())
		{
			iPropHealth = pEntity.GetHealth();
		}

		Array_CSZMPlayer[iAttakerIndex].AddPropHealth(iPropHealth);
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_CORE_PlrSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HOOK_RESULT = HOOK_CONTINUE;
	if (!bIsCSZM || pArgs is null) 
	{
		return HOOK_RESULT;
	}

	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();

	int index = pPlayerEntity.entindex();
	string ARG = pArgs.Arg(1);

	if (ARG.findFirst("/", 0) == 0 && ARG.length() > 1 && AdminSystem.PlayerHasFlag(pPlayer, GetAdminFlag(gAdminFlagRoot)))
	{
		HOOK_RESULT = HOOK_HANDLED;
		ARG = Utils.StrReplace(ARG, "/", "");
		CASCommand@ pARGSplited = StringToArgSplit(ARG, " ");
		Admin::Command(pPlayerBase, pARGSplited, true);
	}
	else if (ARG.findFirst("!", 0) == 0 && ARG.length() > 1)
	{
		ARG = Utils.StrReplace(ARG, "!", "");
		CASCommand@ pARGSplited = StringToArgSplit(ARG, " ");
		HOOK_RESULT = (Radio::Command(index, pARGSplited)) ? HOOK_HANDLED : HOOK_CONTINUE;
	}

	return HOOK_RESULT;	
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Other funcs
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void RoundTimer()
{
	if (Utils.GetNumPlayers(survivor, false) < 1 || (Utils.GetNumPlayers(survivor, false) < 2 && !bIsPlayersSelected) || (Utils.GetNumPlayers(zombie, false) < 1 && bIsPlayersSelected))
	{
		RoundManager.SetWinState(STATE_STALEMATE);
	}

	if (iSeconds <= iTurnTime && !bIsPlayersSelected)
	{
		SelectPlrsForInfect();
	}

	if (iSeconds <= 0)
	{
		flRTWait = 0;
		CSZM_EndGame();
	}
	else
	{
		iSeconds--;
	}
}

void GotVictim(CZP_Player@ pAttacker, CBaseEntity@ pPlayerEntity)
{
	if (pPlayerEntity.IsAlive())
	{
		float percent = ceil(CONST_REWARD_HEALTH * 0.375f);

		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + (CONST_REWARD_HEALTH + Math::RandomInt(int(-1 * percent), int(percent))));
	}

	Array_CSZMPlayer[pPlayerEntity.entindex()].AddMoney(ECO_Zombie_Kill);
	pAttacker.AddScore(100, null);
	AddTime(CONST_INFECT_ADDTIME);
}

void AddTime(int &in iTime)
{
	if (RoundManager.IsRoundOngoing(false) && Utils.GetNumPlayers(survivor, true) > 1 && bAllowAddTime && iSeconds < CONST_MIN_ROUNDTIMER)
	{
		if (iSeconds <= 0)
		{
			iTime *= 3;
		}
	
		iSeconds += iTime;
		SendGameText(any, "\n+ " + formatInt(iTime) + " Секунд", 1, 1, -1, 0.0025f, 0, 0.35f, 1.75f, Color(255, 175, 85), Color(0, 0, 0));
	}
}

void SelectPlrsForInfect()
{
	if (bIsPlayersSelected)
	{
		return;
	}

	bIsPlayersSelected = true;
	int iInfected = 0;
	float flIP = flInfectionPercent;

	if (flIP > 0.45f)
	{
		flIP = 0.45f;
	}
	else if (flIP < 0.01f)
	{
		flIP = 0.01f;
	}

	int iSurvCount = Utils.GetNumPlayers(survivor, true);
	int iInfectedCount = int(ceil(flIP * iSurvCount));

	array<array<int>> p_BaseArrays;
	array<array<int>> p_Survivors;

	for (int i = 1; i <= iMaxPlayers; i++) 
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() != TEAM_SURVIVORS || !pPlayerEntity.IsAlive())
		{
			continue;
		}

		p_BaseArrays.insertLast({i,Array_CSZMPlayer[i].InfectPoints});
	}

	int iBaseArraysLength = int(p_BaseArrays.length());

	while (int(p_Survivors.length()) != iBaseArraysLength)
	{
		int iRandomElement = Math::RandomInt(0, p_BaseArrays.length() - 1);

		p_Survivors.insertLast(p_BaseArrays[iRandomElement]);
		p_BaseArrays.removeAt(iRandomElement);
	}

	while (iInfected != iInfectedCount)
	{
		iInfected++;
		
		int iInfectPoints = p_Survivors[0][1];
		int iPlayerIndex = p_Survivors[0][0];
		int iArrayElement = 0;

		for (uint i = 0; i < p_Survivors.length(); i++)
		{
			if (p_Survivors[i][1] > iInfectPoints)
			{
				iInfectPoints = p_Survivors[i][1];
				iPlayerIndex = p_Survivors[i][0];
				iArrayElement = i;
			}
		}

		p_Survivors.removeAt(iArrayElement);
		Array_CSZMPlayer[iPlayerIndex].AddInfectPoints(-21);
		Array_CSZMPlayer[iPlayerIndex].FirstInfected = true;
		TurnToZombie(iPlayerIndex);
	}

	SD(strCSZM + "{gold}Произошла мутация зараженных ({red}" + formatInt(iInfected) + " {gold}из {blue}" + formatInt(iSurvCount) + "{gold})");
	Engine.EmitSound("CS_FirstTurn");
}

void TurnToZombie(const int &in index)
{
	CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(index);

	if (pPlayerEntity !is null)
	{
		int iRandomSound = 0;
		CZP_Player@ pPlayer = ToZPPlayer(index);

		NPZ::StripWeapon(pPlayer, "weapon_phone");
		NPZ::StripWeapon(pPlayer, "weapon_emptyhands");

		CBaseEntity@ pCurrentWeapon = pPlayer.GetCurrentWeapon();
		string CurrentName = pCurrentWeapon.GetEntityName();

		if (Utils.StrEql("", pCurrentWeapon.GetEntityName(), true))
		{
			CurrentName = "wep_plr_";
		}

		pCurrentWeapon.SetEntityName(CurrentName + formatInt(index));
		pPlayer.DropWeapon(pPlayer.GetWeaponSlot(CurrentName + formatInt(index)));
		pCurrentWeapon.SetEntityName(CurrentName);

		if (Array_CSZMPlayer[index].FirstInfected)
		{
			flSoloTime = PlusGT(0.1f);
		}

		EmitBloodEffect(pPlayer, Array_CSZMPlayer[index].Spawn);
		pPlayerEntity.ChangeTeam(TEAM_ZOMBIES);
		pPlayer.GiveWeapon("weapon_arms");
		pPlayer.SetVoice("eugene_z");
		Engine.EmitSoundEntity(pPlayerEntity, "CSPlayer.Mute");
		pPlayer.SetArmModel(MODEL_ZOMBIE_ARMS);
		Array_CSZMPlayer[index].SetDefSpeed(SPEED_ZOMBIE);
		Array_CSZMPlayer[index].UpdateOutline();

		RandomZombieModel(pPlayer, pPlayerEntity);
		SetZombieHealth(pPlayerEntity);

		while (iRandomSound == iPreviousInfectIndex)
		{
			iRandomSound = Math::RandomInt(0, g_strInfectSND.length() - 1);
		}

		iPreviousInfectIndex = iRandomSound;
		!Array_CSZMPlayer[index].Spawn ? Engine.EmitSoundPosition(index, g_strInfectSND[iRandomSound], pPlayerEntity.GetAbsOrigin(), 1.0f, 85, Math::RandomInt(99, 107)) : Engine.EmitSoundPosition(index, ")npc/zombie/zombie_alert" + formatInt(Math::RandomInt(1, 3)) + ".wav", pPlayerEntity.GetAbsOrigin(), 1.0f, 80, Math::RandomInt(100, 105));
		ShakeInfected(pPlayerEntity);
	}
}

void RandomZombieModel(CZP_Player@ pPlayer, CBaseEntity@ pPlayerEntity)
{
	CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[pPlayerEntity.entindex()];

	int iRNG_ZM_Voice = Math::RandomInt(1, VOICE_MAX_INDEX);

	if (iRNG_ZM_Voice == iPreviousZombieVoiceIndex)
	{
		iRNG_ZM_Voice = Math::RandomInt(1, VOICE_MAX_INDEX);
	}

	iPreviousZombieVoiceIndex = iRNG_ZM_Voice;
	pCSZMPlayer.SetZombieVoice(iRNG_ZM_Voice);
	
	if (pCSZMPlayer.FirstInfected)
	{
		pPlayerEntity.SetModel(MODEL_PLAYER_CORPSE2);
		pPlayerEntity.SetBodyGroup("EyesGlow", 1);
		pPlayerEntity.SetSkin(1);
		AttachEyesLights(pPlayerEntity);
	}
	else
	{
		if (g_strMDLToChoose.length() == 0)
		{
			int iModelsLength = int(g_strModels.length());

			for (int i = 0; i < iModelsLength; i++)
			{
				g_strMDLToChoose.insertLast(g_strModels[i]);
			}
		}

		int iRNG = Math::RandomInt(0, int(g_strMDLToChoose.length()) - 1);

		pPlayerEntity.SetModel(g_strMDLToChoose[iRNG]);
		g_strMDLToChoose.removeAt(iRNG);
	}

	Utils.CosmeticWear(pPlayer, MODEL_KNIFE);
}

void SetZombieHealth(CBaseEntity@ pPlayerEntity)
{
	int index = pPlayerEntity.entindex();

	CZP_Player@ pPlayer = ToZPPlayer(index);
	
	int iArmor = int(ceil(pPlayer.GetArmor() * (CONST_ARMOR_MULT + Math::RandomFloat(0.0f, 1.0f))));
	int iExtraHealth = int(ceil(iZombieHealth * 0.45f * Array_CSZMPlayer[index].ExtraHealth));

	if (iArmor > 0)
	{
		pPlayer.SetArmor(0);
	}

	if (Array_CSZMPlayer[index].FirstInfected)
	{
		pPlayerEntity.SetMaxHealth(iZombieHealth + iExtraHealth);
		pPlayerEntity.SetHealth(iZombieHealth + int((iZombieHealth + iExtraHealth) * flInfectedExtraHP) + iArmor);
	}
	else
	{
		pPlayerEntity.SetMaxHealth(iZombieHealth + iExtraHealth);
		pPlayerEntity.SetHealth(int((iZombieHealth + iExtraHealth) * 0.42f) + iArmor);
	}
}