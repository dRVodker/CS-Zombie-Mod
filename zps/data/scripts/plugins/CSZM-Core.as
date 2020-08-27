//Counter-Strike Zombie Mode
//Core Script File

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Info
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	текстовые каналы (ИХ ВСЕГО 6)
	0 - время раунда/обратный отсчёт разминки
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
int iRoundTime = 270;				//Время в секундах отведённое на раунд.
int iZombieHealth = 500;			//HP зомби
int iZMRHealth = 5;					//Максимальное HP, восстанавливаемое регенерацие зомби за один так

float flZMRRate = 0.1f;				//Интервал времени регенерации зомби
float flZMRDamageDelay = 0.65f;		//Задержка регенерации после получения урона
float flInfectedExtraHP = 0.25f;	//Процент дополнительного HP для первых зараженных, от HP обычных зомби (от iZombieHealth)
float flInfectionPercent = 0.3f;	//Процент выживших, которые будут заражены в начале раунда
float flPSpeed = 0.22f;				//Часть скорости, которая останется у игрока после замедления
float flRecover = 0.028f;			//Время между прибавками скорости
float flCurrs = 1.125f;				//Часть от текущей скорости игрока, которая будет прибавляться для восстановления нормальной скорости игрока
float flPropHPPercent = 0.135f;		//Часть от текущего HP, которая будет умножена на количество игроков для получения итогового HP
float flBrushHPPercent = 0.314f;	//Часть от текущего HP, которая будет умножена на количество игроков для получения итогового HP

int iPreviousZombieVoiceIndex;		//Предыдущий номер голоса зомби
int iPreviousInfectIndex = -1;		//Предыдущий номер звука заражения
int iSeconds;						//Переменная используется для обратного отсчёта времени раунда
int iWUSeconds;						//Переменная используется для обратного отсчёта времени разминки
int iRoundTimeFull;					//Время в секундах отведённое на раунд (ПОЛНОЕ).
int iTurnTime;						//Время, когда превращаются зараженные

int ECO_DefaultCash = 300;			//Экономические переменные, говорят сами за себя
int ECO_StartingCash = 300;
int ECO_Human_Win = 750;
int ECO_Human_Kill = 250;
int ECO_Zombie_Win = 500;
int ECO_Zombie_Kill = 650;
int ECO_Lose = -1000;
int ECO_Suiside = -650;
float ECO_Damage_Multiplier = 0.085f;
float ECO_Health_Multiplier = 0.12f;

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
	bWarmUp = true;
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
	SetUpIPD((1<<1) + (1<<2) + (1<<3) + (1<<4));
	
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
	Schedule::Task(0.5f, "SpawnCashItem");

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

	private int WeaponIndex;

	bool Abuser;							//Игроки, злоупотребляющие механиками, получают этот флаг (Записывается в SteamIDArray)
	bool FirstInfected;						//Один из первых зараженных?

	private float ZombieRespawnTime;		//Время, по истечению которгого, зомби появится снова

	bool Cured;								//true - Если был вылечен администратором
	bool Spawn;								//true - Если возрадился играя за зомби

	int InfectResist;						//Сопротивление инфекции
	int InfectPoints;						//Чем больше значение, тем вероятнее заражение (Записывается в SteamIDArray)
	int CashBank;							//Деньги Деньги Деньги
	int ExtraLife;							//Extra Life
	int ExtraHealth;						//Дополнительное здоровье

	float Scale;							//Масштаб игрока

	array<TimeBasedDamage@> pTimeDamage;	//???
	private ShowHealthPoints@ pShowHP;		//Объект, который показывает оставшееся HP у ломающихся вещей

	Radio::BaseMenu@ pMenu;					//Слот для меню
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
			ZombieRespawnTime = PlusGT(CONST_SPAWN_DELAY - 0.1f);
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
			pPlayer.SetArmor(500);
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
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		float flZAResist = (pPlayer.GetArmor() > 0 && pPlayerEntity.GetTeamNumber() == TEAM_ZOMBIES) ? (flPSpeed * 1.275f) : 0;
		int NewSpeed = int(float(DefSpeed) * (flPSpeed + flZAResist));

		if (pPlayerEntity.GetTeamNumber() == TEAM_ZOMBIES)
		{
			VoiceTime += Math::RandomFloat(0.67f, 0.98f);
			RegenTime = (pPlayer.GetArmor() > 0) ? RegenTime : PlusGT(flZMRDamageDelay);
			UpdateOutline();
		}

		RecoverTime = PlusGT(flRecover);
		pPlayer.SetMaxSpeed(NewSpeed);
	}

	void AddMenu(Radio::BaseMenu@ nMenu)
	{
		@pMenu = nMenu;
		ToZPPlayer(PlayerIndex).RefuseWeaponSelection(true);
	}

	void ExitMenu()
	{
		@pMenu = null;
		ToZPPlayer(PlayerIndex).RefuseWeaponSelection(false);
	}

	void Input(const int nInput)
	{
		if (pMenu !is null)
		{
			pMenu.Input(nInput);
		}
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

		if (pMenu !is null && pMenu.CheckLife())
		{
			pMenu.CloseMenu();
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

				if (pPlayer.GetCurrentWeapon() !is null && LessThanGT(InfResShowTime) && Utils.StrContains("item_antidote", pPlayer.GetCurrentWeapon().GetEntityName()))
				{
					InfResShowTime = PlusGT(1.12f);
					Chat.CenterMessagePlayer(pBasePlayer, strInfRes + formatInt(InfectResist));
				}

				if (pPlayer.GetCurrentWeapon() !is null && pPlayer.GetCurrentWeapon().entindex() != WeaponIndex)
				{
					WeaponIndex = pPlayer.GetCurrentWeapon().entindex();
					if (Utils.StrEql("item_deliver", pPlayer.GetCurrentWeapon().GetClassname(), true))
					{
						Engine.Ent_Fire(pPlayer.GetCurrentWeapon().GetEntityName(), "addoutput", "effects 129", "0.00");
					}
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
	
		pPlayerEntity.SetOutline(true, filter_team, TEAM_ZOMBIES, Color(cRed, cGreen, cBlue), GLOW_BASE_DISTANCE, true, RenderUnOccluded);	
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Last includes
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

#include "./cszm_modules/misc.as"
#include "./cszm_modules/core_warmup.as"

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//GameText
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

namespace GameText
{
	const float AccCashLifeTime = 4.0f;
	const array<string> AMPExtra = 
	{
		"title",
		"holdtime",
		"fadeout",
		"<blank>",
		"<exit>"
	};
	const array<array<string>> gDefaultValues = 
	{
		{"title",		"holdtime",	"fadeout",	"<blank>",	"<exit>"},	//Keys
		{"Empty Title",	"10.0",		"0.0",		"",			"0. Exit"}	//Default values
	};
	const array<string> gMenuSchema = 
	{
		"title",
		"<blank>",
		"item1",
		"item2",
		"item3",
		"item4",
		"item5",
		"item6",
		"item7",
		"<blank>",
		"prev",
		"next",
		"<exit>"
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

		void AddPN(const int iType)
		{
			bool IsExist = false;
			if (iType == 0)
			{
				IsExist = (p_Key.find("next") > -1);
			}
			else if (iType == 1)
			{
				IsExist = (p_Key.find("prev") > -1);
			}

			if (!IsExist)
			{
				switch(iType)
				{
					case 0:
						p_Key.insertLast("next");
						p_Value.insertLast("9. Next\n");
					break;

					case 1:
						p_Key.insertLast("prev");
						p_Value.insertLast("8. Previous\n");
					break;
				}
			}
		}

		void Update(const string Key, const string Value)
		{
			int KeyIndex = p_Key.find(Key);
			(KeyIndex > -1) ? Assign(KeyIndex, Value) : Add(Key, Value);
		}

		private void Assign(const int KeyIndex, const string Value)
		{
			p_Value[KeyIndex] = Value;
		}

		string GetKeyValue(const string Key)
		{
			int KeyIndex = p_Key.find(Key);
			return (KeyIndex > -1) ? p_Value[KeyIndex] : DefaultVlaue(gDefaultValues[0].find(Key));
		}

		private string DefaultVlaue(const int Index)
		{
			string sResult = "null";
			if (Index > -1)
			{
				sResult = gDefaultValues[1][Index];
			}

			return sResult;
		}
	}

	class Menu
	{
		Menu(const int iPlrInd, MenuKeyValyes@ nParams)
		{
			string FullMSG = "";
			string sValue = "";

			for(int i = 0; i < 13; i++)
			{
				if (i == 1 || i == 9)
				{
					FullMSG += "\n";
					continue;
				}

				sValue = nParams.GetKeyValue(gMenuSchema[i]);

				if (Utils.StrEql("null", sValue, true))
				{
					continue;
				}

				FullMSG += sValue;
			}

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

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Radio
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

namespace Radio
{
	enum eSchemaSlots {SLOT_NAME, SLOT_COST, SLOT_TYPE, SLOT_CLASS}
	enum eItemTypes {IT_WEAPON, IT_AMMO, IT_DELIVER, IT_POWERUP, IT_DROP, IT_CAT, IT_LOBBY, IT_SPEC, IT_CALLFUNC}
	enum ePowerUpTypes {PUT_HEALTH, PUT_LIFE, PUT_ARMOR}
	enum eMenuIndexes {MI_CAT, MI_MELEE, MI_FIREARMS}
	enum eGoTo {GT_NEXT = 1, GT_PREV = -1}
	enum eInputs {IP_EXIT, IP_PREV = 8, IP_NEXT, IP_DROP = 11, IP_MENU}
	const int MaxItemsOnPage = 7;
	const int DefaultMenuHoldTime = 20;
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
	const array<string> gItemType = 
	{
		"weapon",
		"ammo",
		"deliver",
		"powerup",
		"drop",
		"cat",
		"lobby",
		"spec",
		"callfunc"
	};
	const array<array<string>> CATMenuSchema = 
	{
		{"Melee",		"0",	"cat",	"2"},
		{"Firearms",	"0",	"cat",	"3"},
		{"Ammo",		"0",	"cat",	"4"},
		{"Item",		"0",	"cat",	"5"},
		{"Drop Money",	"0",	"cat",	"6"}
	};
	const array<array<string>> MeleeMenuSchema = 
	{
		{"Hammer",			"150",	"weapon",	"weapon_barricade",		},
		{"Shovel",			"450",	"weapon",	"weapon_shovel",		},
		{"Sledgehammer",	"2000",	"weapon",	"weapon_sledgehammer",	}
	};
	const array<array<string>> FirearmsMenuSchema = 
	{	
		{"Glock18c",		"165",	"weapon",	"weapon_glock18c",		},
		{"Glock",			"105",	"weapon",	"weapon_glock",			},
		{"USP",				"110",	"weapon",	"weapon_usp",			},
		{"PPK",				"75",	"weapon",	"weapon_ppk",			},
		{"AK47",			"735",	"weapon",	"weapon_ak47",			},
		{"M4",				"675",	"weapon",	"weapon_m4",			},
		{"MP5",				"485",	"weapon",	"weapon_mp5",			},
		{"Remington 870",	"725",	"weapon",	"weapon_870",			},
		{"SuperShorty",		"385",	"weapon",	"weapon_supershorty",	},
		{"Winchester",		"345",	"weapon",	"weapon_winchester",	},
		{"Revolver",		"950",	"weapon",	"weapon_revolver",		}
	};
	const array<array<string>> AmmoMenuSchema = 
	{
		{"Pistol",		"85",	"ammo",	"0",	"15"},
		{"Rifle",		"190",	"ammo",	"3",	"30"},
		{"Shotgun",		"145",	"ammo",	"2",	"6"},
		{"Revovler",	"275",	"ammo",	"1",	"6"},
		{"Barricade",	"250",	"ammo",	"4",	"1"}
	};
	const array<array<string>> ItemsMenuSchema = 
	{
		{"Grenade",		"925",	"weapon",	"weapon_frag"},
		{"IED",			"1000",	"weapon",	"weapon_ied"},
		{"FragMine",	"875",	"deliver",	"1"},
		{"Adrenaline",	"850",	"deliver",	"2"},
		{"Antidote",	"1500",	"deliver",	"3"}
	};
	const array<array<string>> DropMenuSchema = 
	{
		{"",	"100",	"drop"},
		{"",	"200",	"drop"},
		{"",	"300",	"drop"},
		{"",	"400",	"drop"},
		{"",	"500",	"drop"}
	};
	const array<array<string>> ZombieMenuSchema = 
	{
		{"Extra HP",	"650",	"powerup",	"2"},
		{"Exrta Life",	"1000",	"powerup",	"5"},
		{"Armor",		"900",	"powerup",	"6"}
	};
	const array<array<string>> LobbyMenuSchema = 
	{
		{"Get a Snowball",		"",	"lobby",	"weapon_snowball"},
		{"Get a Tennis ball",	"",	"lobby",	"weapon_tennisball"},
		{"Become a Firefly",	"",	"lobby",	""},
		{"Reduce Scale",		"",	"lobby",	""},
		{"Increase Scale",		"",	"lobby",	""}
	};
	const array<array<string>> SpecMenuSchema = 
	{
		{"Become a Firefly",	"",	"spec"}
	};

	BaseMenu@ OpenMenuByIndex(const int &in nPlrInd, const int &in nMenuIndex, const bool &in IsOpenFromCAT)
	{
		BaseMenu@ pResult;
		switch(nMenuIndex)
		{
			case 1: @pResult = BaseMenu(nPlrInd, CATMenuSchema, "Menu", false); break;
			case 2: @pResult = BaseMenu(nPlrInd, MeleeMenuSchema, "Melee", IsOpenFromCAT); break;
			case 3: @pResult = BaseMenu(nPlrInd, FirearmsMenuSchema, "Firearms", IsOpenFromCAT); break;
			case 4: @pResult = BaseMenu(nPlrInd, AmmoMenuSchema, "Ammo", IsOpenFromCAT); break;
			case 5: @pResult = BaseMenu(nPlrInd, ItemsMenuSchema, "Items", IsOpenFromCAT); break;
			case 6: @pResult = BaseMenu(nPlrInd, DropMenuSchema, "Drop Money", IsOpenFromCAT); break;
			case 7: @pResult = BaseMenu(nPlrInd, ZombieMenuSchema, "Zombie Menu", false); break;
			case 8: @pResult = BaseMenu(nPlrInd, LobbyMenuSchema, "Lobby Menu", false); break;
			case 9: @pResult = BaseMenu(nPlrInd, SpecMenuSchema, "Spec Menu", false); break;
		}

		if (IsOpenFromCAT)
		{
			MenuFeedback(nPlrInd, 4);
		}

		return pResult;
	}

	int GetItemType(const string &in sType)
	{
		return gItemType.find(sType);
	}

	CEntityData@ GetInputData(const int nDeliverType)
	{
		return gCustomItemIPD[nDeliverType];
	}

	array<string> GetItemParams(const int &in iItemIndex, int &in iType, array<array<string>> &in nMenuData)
	{
		array<string> nParams;
		int Length = int(nMenuData[iItemIndex].length());

		if (Length > 3)
		{
			for (int i = 3; i < Length; i++)
			{
				nParams.insertLast(nMenuData[iItemIndex][i]);
			}
		}

		nParams.insertLast(formatInt(iItemIndex));

		return nParams;
	}

	int LobbyMenu(const int &in nPlrInd, const int &in nItemIndex, const string &in nClassname)
	{
		bool IsFailure = false;
		switch(nItemIndex)
		{
			case 0: NPZ::GiveThrowable(ToZPPlayer(nPlrInd), nClassname); break;
			case 1: NPZ::GiveThrowable(ToZPPlayer(nPlrInd), nClassname); break;
			case 2: IsFailure = !(NPZ::SetFirefly(FindEntityByEntIndex(nPlrInd), nPlrInd, 0, 0, 0)); break;
			case 3: IsFailure = !(Array_CSZMPlayer[nPlrInd].ChangeScale(-0.05f)); break;
			case 4: IsFailure = !(Array_CSZMPlayer[nPlrInd].ChangeScale(0.05f)); break;
		}

		return IsFailure ? MenuFeedback(nPlrInd, 7) : MenuFeedback(nPlrInd, 4);
	}

	int SpecMenu(const int &in nPlrInd, const int &in nItemIndex)
	{
		bool IsFailure = false;
		switch(nItemIndex)
		{
			case 0: IsFailure = !(NPZ::SetFirefly(FindEntityByEntIndex(nPlrInd), nPlrInd, 0, 0, 0)); break;
		}

		return IsFailure ? MenuFeedback(nPlrInd, 7) : MenuFeedback(nPlrInd, 4);
	}

	int GivePowerUp(const int &in nPlrInd, const int &in nCost, const int &in nPowerUpIndex, const int &in nTextIndex)
	{
		int iResult = -1;

		if (Array_CSZMPlayer[nPlrInd].CashBank < nCost)
		{
			MenuFeedback(nPlrInd, 0);
			iResult = 0;
		}
		else
		{
			bool IsPowerUpAdded = false;
			switch(nPowerUpIndex)
			{
				case PUT_HEALTH: IsPowerUpAdded = Array_CSZMPlayer[nPlrInd].AddExtraHealth(); break;
				case PUT_LIFE: IsPowerUpAdded = Array_CSZMPlayer[nPlrInd].AddExtraLife(); break;
				case PUT_ARMOR: IsPowerUpAdded = Array_CSZMPlayer[nPlrInd].AddZMArmor(); break;
			}

			iResult = IsPowerUpAdded ? (PayCost(nPlrInd, nCost) + 1) : MenuFeedback(nPlrInd, nTextIndex);
		}

		return iResult;
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

	class BaseMenu
	{
		string MenuTitle;
		int PlayerIndex;
		int TeamNum;
		int TotalItems;
		int TotalPages;
		int CurrentPage;
		float LifeTime;
		float RefreshTime;
		float InputDelay;
		float TextTime;
		bool OpenedFromCAT;

		GameText::MenuKeyValyes@ pMenuTextKV;
		array<array<string>> pMenuData;

		BaseMenu(const int nPlrInd, array<array<string>> nMenuData, const string nMenuTitle, const bool nOFCAT)
		{
			OpenedFromCAT = nOFCAT;
			PlayerIndex = nPlrInd;
			MenuTitle = nMenuTitle;
			pMenuData = nMenuData;
			FillMenu(float(DefaultMenuHoldTime));
		}

		private void FillMenu(const float nLifeTime)
		{
			ToZPPlayer(PlayerIndex).RefuseWeaponSelection(true);

			TeamNum = FindEntityByEntIndex(PlayerIndex).GetTeamNumber();
			RefreshTime = PlusGT(0.089f);
			TextTime = PlusGT(0.951f);
			LifeTime = PlusGT(nLifeTime);
			TotalItems = int(pMenuData.length());
			TotalPages = int(ceil(float(TotalItems) / float(MaxItemsOnPage)));
			CurrentPage = 1;

			if (Array_CSZMPlayer[PlayerIndex].ExtraHealth > 0 && Utils.StrEql("Extra HP", pMenuData[0][SLOT_NAME], true))
			{
				DoubelCostForHealth();
			}

			ShowMenu();
		}

		bool CheckLife()
		{
			bool bDead = ((LifeTime <= Globals.GetCurrentTime() && LifeTime != 0) || RoundManager.GetRoundState() == rs_RoundEnd_Post || TeamNum != FindEntityByEntIndex(PlayerIndex).GetTeamNumber() || (!FindEntityByEntIndex(PlayerIndex).IsAlive() && FindEntityByEntIndex(PlayerIndex).GetTeamNumber() != 1));
			if (bDead)
			{
				LifeTime = 0;
			}
			else if (LessThanGT(TextTime))
			{
				UpdateTextMenu();
			}

			return bDead;
		}

		void ShowMenu()
		{
			@pMenuTextKV = GameText::MenuKeyValyes();
			int iButtons = 0;
			int iLength = 1;
			int iStart = MaxItemsOnPage * CurrentPage - MaxItemsOnPage;
			int iSteps = (TotalItems > MaxItemsOnPage) ? MaxItemsOnPage : TotalItems;

			if (CurrentPage < TotalPages)
			{
				iSteps = MaxItemsOnPage;
			}
			else if (CurrentPage == TotalPages && CurrentPage * MaxItemsOnPage > TotalItems)
			{
				iSteps = TotalItems - iStart;
			}

			iLength = iStart + iSteps;

			pMenuTextKV.Add("holdtime", "1.1");
			pMenuTextKV.Add("fadeout", "0");
			pMenuTextKV.Add("title", "-=" + MenuTitle + "=-" + "\n");

			for (int i = iStart; i < iLength; i++)
			{
				string sItem = "";
				bool bAddChar;
				bool bHasCost = (Utils.StringToInt(pMenuData[i][SLOT_COST]) > 0);
				int iItemType = GetItemType(pMenuData[i][SLOT_TYPE]);

				iButtons++;
				sItem = formatInt(iButtons) + ". ";
				sItem += pMenuData[i][SLOT_NAME] + " ";
				sItem += (iItemType != IT_DROP && bHasCost) ? "- " : "";
				sItem += (bHasCost) ? (pMenuData[i][SLOT_COST] + "$") : "";
				sItem += "\n";
				pMenuTextKV.Add("item" + formatInt(iButtons), sItem);
			}

			if ((TotalPages != 1 && CurrentPage == TotalPages) || (OpenedFromCAT && CurrentPage == 1))
			{
				pMenuTextKV.AddPN(1);	// 1= previous
			}
			else if (CurrentPage < TotalPages)
			{
				pMenuTextKV.AddPN(0);	// 0= next
			}

			if (TotalPages > 1)
			{
				if (CurrentPage < TotalPages)
				{
					pMenuTextKV.AddPN(0);
				}
				else if (CurrentPage == TotalPages)
				{
					pMenuTextKV.AddPN(1);
				}
				else
				{
					pMenuTextKV.AddPN(1);
					pMenuTextKV.AddPN(0);
				}
			}

			if (OpenedFromCAT)
			{
				pMenuTextKV.AddPN(1);
			}

			GameText::Menu(PlayerIndex, pMenuTextKV);
		}

		void UpdateTextMenu()
		{
			TextTime = PlusGT(0.951f);
			GameText::Menu(PlayerIndex, pMenuTextKV);
		}

		void CloseMenu()
		{
			if (FindEntityByEntIndex(PlayerIndex).IsAlive() || FindEntityByEntIndex(PlayerIndex).GetTeamNumber() == TEAM_SPECTATORS)
			{
				MenuFeedback(PlayerIndex, 3);
			}

			pMenuTextKV.Update("holdtime", "0.0");
			pMenuTextKV.Update("fadeout", "0.15");
			GameText::Menu(PlayerIndex, pMenuTextKV);
			ToZPPlayer(PlayerIndex).RefuseWeaponSelection(false);
			Array_CSZMPlayer[PlayerIndex].ExitMenu();
		}

		private void GoToPage(int i)
		{
			MenuFeedback(PlayerIndex, 4);
			CurrentPage += i;
			ExtendLifeTime();
		}

		void Input(int InputIndex)
		{
			if (InputIndex == IP_DROP)
			{
				InputDelay = PlusGT(0.15f);
			}
			else if (InputIndex == IP_MENU)
			{
				InputIndex = IP_PREV;

				if (CurrentPage == 1 && !OpenedFromCAT)
				{
					InputIndex = IP_EXIT;
				}
			}

			if (!LessThanGT(InputDelay))
			{
				return;
			}

			InputDelay = PlusGT(0.1f);
			UseItem(InputIndex);
		}

		void UseItem(int nItemIndex)
		{
			if (nItemIndex == 0 || nItemIndex == 8 || nItemIndex == 9)
			{
				if (nItemIndex == IP_EXIT)
				{
					CloseMenu();
				}
				else if (IsNextPageExist() && nItemIndex == IP_NEXT)
				{
					GoToPage(GT_NEXT);
				}
				else if (nItemIndex == IP_PREV)
				{
					if (IsPrevPageExist())
					{
						GoToPage(GT_PREV);
					}
					else if (OpenedFromCAT)
					{
						Array_CSZMPlayer[PlayerIndex].AddMenu(OpenMenuByIndex(PlayerIndex, 1, true));
					}
				}

				return;
			}

			nItemIndex += (MaxItemsOnPage * CurrentPage - MaxItemsOnPage);
			nItemIndex--; 

			int iPurchaseResult = -1;
			int iItemType = GetItemType(pMenuData[nItemIndex][SLOT_TYPE]);
			int iCost = Utils.StringToInt(pMenuData[nItemIndex][SLOT_COST]);
			array<string> pItemParams = GetItemParams(nItemIndex, iItemType, pMenuData);

			switch(iItemType)
			{
				case IT_WEAPON: iPurchaseResult = PurchaseWeapon(PlayerIndex, pItemParams[0], iCost, GetInputData(0)); break;
				case IT_AMMO: iPurchaseResult = PurchaseAmmo(PlayerIndex, iCost, Utils.StringToInt(pItemParams[0]), Utils.StringToInt(pItemParams[1])); break;
				case IT_DELIVER: iPurchaseResult = PurchaseWeapon(PlayerIndex, "item_deliver", iCost, GetInputData(Utils.StringToInt(pItemParams[0]))); break;
				case IT_CAT: Array_CSZMPlayer[PlayerIndex].AddMenu(OpenMenuByIndex(PlayerIndex, Utils.StringToInt(pItemParams[0]), true)); break;
				case IT_POWERUP: iPurchaseResult = GivePowerUp(PlayerIndex, iCost, Utils.StringToInt(pItemParams[1]), Utils.StringToInt(pItemParams[0])); break;
				case IT_LOBBY: iPurchaseResult = LobbyMenu(PlayerIndex, Utils.StringToInt(pItemParams[1]), pItemParams[0]); break;
				case IT_SPEC: iPurchaseResult = SpecMenu(PlayerIndex, Utils.StringToInt(pItemParams[0])); break;
				case IT_DROP: iPurchaseResult = DropCash(PlayerIndex, iCost); break;
			}

			switch(iPurchaseResult)
			{
				case 1: ExtendLifeTime(); break;
				case 2: ExtendLTPowerUps(); break;
			}
		}

		private void ExtendLTPowerUps()
		{
			if (Array_CSZMPlayer[PlayerIndex].ExtraHealth > 0 && Utils.StrEql("Extra HP", pMenuData[0][SLOT_NAME], true))
			{
				DoubelCostForHealth();
			}
			ExtendLifeTime();
		}

		private void ExtendLifeTime()
		{
			LifeTime += 10.5f;
			ShowMenu();
		}

		private void DoubelCostForHealth()
		{
			pMenuData[0][SLOT_COST] = formatInt(int(Utils.StringToFloat(ZombieMenuSchema[0][SLOT_COST]) * 2.231f));
		}

		private bool IsNextPageExist()
		{
			return CurrentPage < TotalPages && TotalPages > 1;
		}

		private bool IsPrevPageExist()
		{
			return CurrentPage != 1 && TotalPages > 1;
		}
	}

	int PurchaseWeapon(const int &in nPlrInd, string &in nClassname, const int &in nCost, CEntityData@ pInputData)
	{
		int iResult = -1;
		CZP_Player@ pPlayer = ToZPPlayer(nPlrInd);
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(nPlrInd);
		CBaseEntity@ pGun = EntityCreator::Create(nClassname, pPlayerEntity.GetAbsOrigin(), pPlayerEntity.GetAbsAngles(), pInputData);

		if (Array_CSZMPlayer[nPlrInd].CashBank < nCost)
		{
			MenuFeedback(nPlrInd, 0);
			pGun.SUB_Remove();
		}
		else if (pPlayer.PutToInventory(pGun))
		{
			Engine.EmitSoundEntity(pPlayerEntity, "HL2Player.PickupWeapon");
			iResult = PayCost(nPlrInd, nCost);
		}
		else
		{
			pGun.SUB_Remove();
			iResult = 0;
			MenuFeedback(nPlrInd, 1);
		}

		return iResult;
	}

	int PurchaseAmmo(const int &in nPlrInd, int &in nCost, const int &in iType, const int &in iAmount)
	{
		int iResult = -1;

		if (Array_CSZMPlayer[nPlrInd].CashBank < nCost)
		{
			MenuFeedback(nPlrInd, 0);
			iResult = 0;
		}
		else
		{
			int SoldOutAmount = GiveAmmo(ToZPPlayer(nPlrInd), iType, iAmount);
			nCost = int(ceil((float(nCost) / float(iAmount)) * (float(SoldOutAmount) / float(nCost)) * float(nCost)));

			if (SoldOutAmount > 0)
			{
				(iType == 4) ? Engine.EmitSoundEntity(FindEntityByEntIndex(nPlrInd), "HL2Player.PickupWeapon") : Engine.EmitSoundEntity(FindEntityByEntIndex(nPlrInd), "ZPlayer.AmmoPickup");
				iResult = PayCost(nPlrInd, nCost);
			}
			else
			{
				MenuFeedback(nPlrInd, 1);
			}
		}

		return iResult;
	}

	int DropCash(const int &in nPlrInd, const int &in nCashToDrop)
	{
		int iResult = -1;

		if (!(nCashToDrop == 0 || FindEntityByEntIndex(nPlrInd) is null))
		{
			if (Array_CSZMPlayer[nPlrInd].CashBank < nCashToDrop)
			{
				MenuFeedback(nPlrInd, 0);
				iResult = 0;
			}
			else
			{
				Array_CSZMPlayer[nPlrInd].CashBank -= nCashToDrop;

				CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(nPlrInd);
				Vector Velocity;
				Vector Eyes = pPlayerEntity.EyePosition() - Vector(0, 0, Math::RandomFloat(4, 16));
				QAngle Angles = pPlayerEntity.EyeAngles() + QAngle(0, Math::RandomFloat(-5, 5), 0);
				Globals.AngleVectors(Angles, Velocity);
				Velocity = Velocity * Math::RandomInt(185, 265) + pPlayerEntity.GetAbsVelocity() * 0.5f;
				Angles *= QAngle(0, 1, 0);

				CEntityData@ MoneyIPD = gCustomItemIPD[4];
				MoneyIPD.Add("targetname", "dropped_money");

				CBaseEntity@ pMoney = EntityCreator::Create("prop_physics_override", Eyes, Angles, MoneyIPD);
				pMoney.SetClassname("item_money");
				pMoney.SetHealth(nCashToDrop);
				pMoney.Teleport(Eyes, (Angles + QAngle(0, 90, 0)), Velocity);
				pMoney.SetOutline(true, filter_team, TEAM_SURVIVORS, Color(235, 65, 175), 185.0f, false, true);

				Engine.EmitSoundEntity(pPlayerEntity, ")player/footsteps/sand2.wav");

				NetData nData;
				nData.Write(pMoney.entindex());
				nData.Write(nPlrInd);
				Network::CallFunction("OnCashDropped", nData);
				iResult = 1;
				MenuFeedback(nPlrInd, 4);
			}
		}

		return iResult;
	}

	int PayCost(const int &in nPlrInd, const int &in nCost)
	{
		Array_CSZMPlayer[nPlrInd].CashBank -= nCost;
		return MenuFeedback(nPlrInd, 4);
	}

	int MenuFeedback(const int &in nPlrInd, const int &in nFBType)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(nPlrInd);
		int iSoundIndex = -1;
		int iTextIndex = -1;
		int iResult = 0;

		switch(nFBType)
		{
			case 0:	//Нет денег
				iSoundIndex = 1;
				iTextIndex = 0;
			break;

			case 1:	//Нет места
				iSoundIndex = 1;
				iTextIndex = 1;
			break;

			case 2:	//Максимум дополнительного здоровья
				iSoundIndex = 1;
				iTextIndex = 2;
			break;

			case 3:	//закрыл меню
				iSoundIndex = 2;
			break;

			case 4:	//успех
				iSoundIndex = 0;
				iResult = 1;
			break;

			case 5:	//Максимум дополнительных жизней
				iSoundIndex = 1;
				iTextIndex = 3;
			break;

			case 6:	//Уже есть броня
				iSoundIndex = 1;
				iTextIndex = 4;
			break;

			case 7:	//Провал
				iSoundIndex = 1;
			break;
		}

		if (iSoundIndex > -1)
		{
			Engine.EmitSoundPlayer(ToZPPlayer(nPlrInd), gMenuSound[iSoundIndex]);
		}

		if (iTextIndex > -1)
		{
			Chat.PrintToChatPlayer(ToBasePlayer(nPlrInd), "{red}*{gold}" + gDeniedReason[iTextIndex]);
		}

		return iResult;
	}

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

			if (Array_CSZMPlayer[index].pMenu !is null)
			{
				Array_CSZMPlayer[nPlrInd].Input(IP_MENU);
			}
			else if (pPlayerEntity.IsAlive() || team == TEAM_SPECTATORS)
			{
				switch(team)
				{
					case TEAM_SURVIVORS: Array_CSZMPlayer[nPlrInd].AddMenu(OpenMenuByIndex(index, 1, false)); break;
					case TEAM_ZOMBIES: Array_CSZMPlayer[nPlrInd].AddMenu(OpenMenuByIndex(index, 7, false)); break;
					case TEAM_LOBBYGUYS: Array_CSZMPlayer[nPlrInd].AddMenu(OpenMenuByIndex(index, 8, false)); break;
					case TEAM_SPECTATORS: Array_CSZMPlayer[nPlrInd].AddMenu(OpenMenuByIndex(index, 9, false)); break;
				}
			}
		}
		else if (Utils.StrEql("ammo", pCC.Arg(0)) && team == TEAM_SURVIVORS && RoundManager.GetRoundState() != rs_RoundEnd_Post)
		{
			Array_CSZMPlayer[nPlrInd].AddMenu(OpenMenuByIndex(index, 4, false));
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
			if (Utils.StringToInt(pCC.Arg(1)) >= 100)
			{
				DropCash(index, Utils.StringToInt(pCC.Arg(1)));
			}
			else
			{
				Chat.PrintToChatPlayer(ToBasePlayer(index), strMinDrop);
			}
		}
		else
		{
			IsCommandExist = false;
		}

		return IsCommandExist;
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//MapPurchase
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void MapPurchase(NetObject@ pData)
{
	if (pData is null)
	{
		return;
	}

	string sFunc = "null";
	int iPlayerIndex = 0;
	int iCustomIndex = -1;
	int iCost = 0;

	if (pData.HasIndexValue(0) && pData.HasIndexValue(1) && pData.HasIndexValue(2) && pData.HasIndexValue(3))
	{
		sFunc = pData.GetString(0);
		iPlayerIndex = pData.GetInt(1);
		iCost = pData.GetInt(2);
		iCustomIndex = pData.GetInt(3);
	}

	if (Array_CSZMPlayer[iPlayerIndex].CashBank < iCost)
	{
		Engine.EmitSoundPlayer(ToZPPlayer(iPlayerIndex), Radio::gMenuSound[1]);
		Chat.PrintToChatPlayer(ToBasePlayer(iPlayerIndex), "{red}*{gold}" + Radio::gDeniedReason[0]);
	}
	else
	{
		Array_CSZMPlayer[iPlayerIndex].CashBank -= iCost;
		
		NetData PurchaseData;
		PurchaseData.Write(iCustomIndex);
		Network::CallFunction(sFunc, PurchaseData);
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//Lock and Load
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

void CSZM_LocknLoad()
{
	flRTWait = Globals.GetCurrentTime();

	Engine.EmitSoundPosition(0, g_LocknLoadSND[Math::RandomInt(0, g_LocknLoadSND.length() - 1)], Vector(0, 0, 0), 1.0f, 0, 100);

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

	if (Utils.StrEql("item_money", pEntity.GetClassname(), true))
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
			iHumanWin++;
			Engine.EmitSoundPosition(0, "@cszm_fx/misc/hwin.wav", Vector(0, 0, 0), 1.0f, 0, Math::RandomInt(75, 125));
		}
		else if (iWinState == STATE_ZOMBIE)
		{
			iZombieWin++;
			Engine.EmitSoundPosition(0, "@cszm_fx/misc/zwin.wav", Vector(0, 0, 0), 1.0f, 0, 100);
		}

		ApplyVictoryRewards(iWinState);
		SendGameText(any, "-=Счётчик побед=-" + "\n Люди: " + formatInt(iHumanWin) + "\n Зомби: " + formatInt(iZombieWin), 4, 0, 0, 0.35f, 0.25f, 0, 10.10f, Color(235, 235, 235), Color(255, 95, 5));
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerConnected(CZP_Player@ pPlayer) 
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int index = pBaseEnt.entindex();

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
				if (bWarmUp) {Array_CSZMPlayer[index].AddMenu(Radio::OpenMenuByIndex(index, 8, false));}
			break;

			case TEAM_SURVIVORS:
				Array_CSZMPlayer[index].SetDefSpeed(SPEED_HUMAN);
				if (!bIsPlayersSelected && !Array_CSZMPlayer[index].Cured) {Array_CSZMPlayer[index].AddMenu(Radio::OpenMenuByIndex(index, 1, false));}
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
			pVicCSZMPlayer.AddInfectPoints(3);
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
					pVicCSZMPlayer.AddInfectPoints(12);
					pAttCSZMPlayer.AddInfectPoints(-1);
				}
			}
		}
		else if (iVicTeam == TEAM_SURVIVORS && flDamage >= 10)
		{
			pVicCSZMPlayer.AddInfectPoints(1);
		}
		else if (iVicTeam == TEAM_ZOMBIES && pBaseEnt.IsAlive())
		{
			CBaseEntity@ pInflictor = DamageInfo.GetInflictor();

			if (pPlayer.GetArmor() > 0)
			{
				Engine.EmitSoundPosition(iVicIndex, "cszm_fx/player/plr_hitarmor1.wav", pBaseEnt.GetAbsOrigin(), 1.0f, 85, 105);
			}

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
				int iColorIndex = 0;
				if (pBaseEnt.GetHealth() <= DamageInfo.GetDamage())
				{
					iColorIndex = 2;
				}
				else if (pPlayer.GetArmor() > 0)
				{
					iColorIndex = 1;
				}

				ShowHitMarker(iAttIndex, iColorIndex);
				pAttCSZMPlayer.AddMoney(DamageToMoney(pBaseEnt.GetHealth(), DamageInfo.GetDamage()));
			}

			if (flDamage < pBaseEnt.GetHealth() && !bDamageType(iDamageType, 14) && ((iAttTeam == iVicTeam && iAttIndex == iVicIndex) || iAttTeam != iVicTeam))
			{
				//ZM ViewPunch
				bool bLeft = Math::RandomInt(0 , 1) > 0;
				float VP_X = bDamageType(iDamageType, 5) ? Math::RandomFloat(-0.1f, -0.2f) : Math::RandomFloat(-1.75f, 1.85f);
				float VP_Y = bDamageType(iDamageType, 5) ? Math::RandomFloat(-5.75f, -8.15f) : Math::RandomFloat(-1.75f, 1.85f);
				float VP_DAMP = bDamageType(iDamageType, 5) ? Math::RandomFloat(0.085f, 0.205f) : Math::RandomFloat(0.021f , 0.058f);
				float VP_KICK = Math::RandomFloat(0.25f , 0.95f);

				Utils.FakeRecoil(pPlayer, VP_KICK, VP_DAMP, VP_X, VP_Y, bLeft);
				pVicCSZMPlayer.EmitZombieSound(VOICE_ZM_PAIN);
			}
		}

		if (!(bDamageType(iDamageType, 17) && iVicTeam == TEAM_SURVIVORS))
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
	if (bIsCSZM && Utils.StrEql("npc_grenade_frag", strClassname, true))
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

	if (pAttacker.IsPlayer() && Utils.StrEql("weapon_sledgehammer", (ToZPPlayer(pAttacker).GetCurrentWeapon()).GetClassname(), true) && bDamageType(DamageInfo.GetDamageType() ,7) && pEntity.IsPlayer())
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

	//Slightly reduce input damage if it's "prop_barricade"
	if (Utils.StrEql(strEntClassname, "prop_barricade"))
	{
		DamageInfo.SetDamage(DamageInfo.GetDamage() * 0.8f);
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

		//If Damage Type is BULLET reduce amount of damage and increase force by mass
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
	Engine.EmitSoundPosition(0, "@cszm_fx/misc/suspense.wav", Vector(0, 0, 0), 1.0f, 0, Math::RandomInt(95, 105));
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
		pPlayer.SetVoice(eugene);
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