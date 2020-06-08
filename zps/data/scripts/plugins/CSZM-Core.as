//Counter-Strike Zombie Mode
//Core Script File

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Includes and DATA
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#include "./cszm_modules/balance_arrays.as"
#include "./cszm_modules/balance_funcs.as"

#include "../SendGameText"
#include "./cszm_modules/chat.as"
#include "./cszm_modules/cache.as"
#include "./cszm_modules/killfeed.as"
#include "./cszm_modules/rprop.as"
#include "./cszm_modules/item_flare.as"
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

bool bWarmUp = true;
bool bIsPlayersSelected;

HUDTimer@ pCSZMTimer = null;

array<CSZMPlayer@> Array_CSZMPlayer;
array<array<string>> Array_SteamID;

bool bIsCSZM;							//Это CSZM карта?
bool bAllowAddTime = true;				//Разрешить добавлять время за удачное заражение	
bool bAllowZombieRespawn = false;		//Разрешить респавн для зомби
int iWarmUpTime = 3;					//Время разминки в секундах.	(значение по умолчанию - 75)
int iGearUpTime = 30;					//Время в секундах, через которое превратится Первый зараженный.
int iRoundTime = 150;					//Время в секундах отведённое на раунд.
int iZombieHealth = 500;				//HP зомби
int iZMRHealth = 5;						//Кол-во HP, восстанавливаемое регенерацие зомби
float flZMRRate = 0.1f;					//Интервал времени регенерации зомби
float flZMRDamageDelay = 0.65f;			//Задержка регенерации после получения урона
float flInfectedExtraHP = 0.25f;		//Процент дополнительного HP для первых зараженных, от HP обычных зомби (от iZombieHealth)
float flInfectionPercent = 0.3f;		//Процент выживших, которые будут заражены в начале раунда
float flPSpeed = 0.22f;					//Часть скорости, которая останется у игрока после замедления
float flRecover = 0.028f;				//Время между прибавками скорости
float flCurrs = 1.125f;					//Часть от текущей скорости игрока, которая будет использована для восстановления нормальной скорости игрока

int iPreviousZombieVoiceIndex;			//Предыдущий номер голоса зомби
int iPreviousInfectIndex = -1;			//Предыдущий номер звука заражения
int iSeconds;							//Переменная используется для обратного отсчёта времени раунда
int iWUSeconds;							//Переменная используется для обратного отсчёта времени разминки
int iRoundTimeFull;						//Время в секундах отведённое на раунд (ПОЛНОЕ).
int iTurnTime;							//Время, когда превращаются зараженные

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Classes
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

class HUDTimer
{
	private float RPBaseTime;
	private float RPTime;
	private float WaitTime;
	private float HoldTime;
	private string Timer;
	private int Red;
	private int Green;
	private int Blue;
	private bool IsRed;

	HUDTimer()
	{
		WaitTime = Globals.GetCurrentTime();
		RPBaseTime = 0;
		RPTime = 0;
		HoldTime = 10.0f;

		Red = 255;
		Green = 255;
		Blue = 255;

		IsRed = false;

		UpdateTimer(iSeconds);
	}

	void StopHUDTimer()
	{
		WaitTime = 0;
		RPBaseTime = 0;
		HoldTime = 10.25f;

		if (iSeconds > 0)
		{
			Red = 255;
			Green = 255;
			Blue = 255;
			IsRed = false;			
		}

		ShowHUDTime();
	}

	private void RedPulse()
	{
		if (IsRed)
		{
			IsRed = false;
			Red = 255;
			Green = 255;
			Blue = 255;
		}
		else
		{
			IsRed = true;
			Red = 255;
			Green = 45;
			Blue = 45;
		}
	}

	private void UpdateTimer(int Seconds)
	{
		float ShowHours = floor(iSeconds / 3600);
		float ShowMinutes = floor((iSeconds - ShowHours * 3600) / 60);
		float ShowSeconds = floor(iSeconds - (ShowHours * 3600) - (ShowMinutes * 60));

		string SZero = "";
		string MZero = "";

		if (ShowMinutes <= 9)
		{
			MZero = "0";
		}
		if (ShowSeconds <= 9)
		{
			SZero = "0";
		}

		Timer = MZero + ShowMinutes + ":" + SZero + ShowSeconds;

		PeekColor(Seconds);
		ShowHUDTime();
	}

	private void PeekColor(int Seconds)
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

		if (Seconds > 15)
		{
			RPBaseTime = 0;
			IsRed = false;
			Red = 255;
			Green = 255;
			Blue = 255;
		}
		else if (Seconds <= 0)
		{
			RPBaseTime = 0;
			IsRed = true;
			Red = 255;
			Green = 45;
			Blue = 45;
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
		pTimerParameters.SetColor(Color(Red, Green, Blue));
		pTimerParameters.SetColor2(Color(0, 0, 0));

		Utils.GameText(any, Timer, pTimerParameters);
	}

	void Think()
	{
		if (WaitTime <= Globals.GetCurrentTime() && WaitTime != 0)
		{
			WaitTime = Globals.GetCurrentTime() + 0.1f;
			HoldTime = 0.1f;
			UpdateTimer(iSeconds);
		}
		
		if (RPTime <= Globals.GetCurrentTime() && RPBaseTime != 0)
		{
			RPTime = Globals.GetCurrentTime() + RPBaseTime;
			RedPulse();
			ShowHUDTime();
		}
	}
}

class CSZMPlayer
{
	private string SteamID;					//SteamID, Что тут ещё добавить?
	private int PlayerIndex;				//entindex игрока
	private int DefSpeed;					//Обычная скорость движения игрока
	private int Voice;						//Номер голоса для зомби (3 максимально кол-во)
	private int PreviousVoice;				//Номер предыдущего голоса
	private int InfectResist;				//Сопротивление инфекции
	private int PreviousHealth;				//Предыдущее HP, используется для обводки зомби
	private int InfectPoints;				//Чем больше значение, тем вероятнее заражение (Записывается в SteamIDArray)
	private int PropHealth;

	private int Kills;						//Убийства в раунде
	private int Victims;					//Заражения или убийства выживших в раунде

	private float SwipeDelay;				//Задержка между заражениями, эта задержка не даст заразить двух и более выживших одним ударом
	private float RegenTime;				//Промежутки времени между добавлением HP
	private float RecoverTime;				//Промежутки времени между добавлением Скорости

	private float VoiceTime;				//Время между IDLE звуками зомби
	private float AdrenalineTime;			//Время действия адреналина
	private float IRITime;					//Время, по истечению которого показывается сообщение об кол-ве сопротивления инфекции
	private float OutlineTime;				//Время, по истечению которого обновляется обводка зомби
	private float LobbyRespawnDelay;		//Время, которое должен ждать игрок в лобби, чтобы сново использовать "F4 Respawn"

	private bool Abuser;					//Игроки, злоупотребляющие механиками, получают этот флаг (Записывается в SteamIDArray)
	private bool FirstInfected;				//Один из первых зараженных?

	private int DieTeam;					//Индекс команды на момент смерти
	private float ZombieRespawnTime;		//???

	bool Cured;								//true - Если был вылечен администратором
	bool Spawn;								//true - Если возрадился играя за зомби

	TimeBasedDamage@ pBleeding;

	CSZMPlayer(int index, CZP_Player@ pPlayer)
	{
		SteamID = pPlayer.GetSteamID64();
		PlayerIndex = index;
		DefSpeed = SPEED_DEFAULT;
		RecoverTime = 0;
		Voice = 0;
		PreviousVoice = 0;
		VoiceTime = 0;
		RegenTime = 0;
		AdrenalineTime = 0;
		InfectResist = 0;
		IRITime = 0;
		OutlineTime = 0;
		PreviousHealth = 0;
		LobbyRespawnDelay = 0;
		SwipeDelay = 0;
		PropHealth = 0;

		DieTeam = -1;
		ZombieRespawnTime = 0;

		Kills = 0;
		Victims = 0;

		FirstInfected = false;
		Cured = false;
		Spawn = false;

		@pBleeding = null;

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
		DieTeam = -1;
		ZombieRespawnTime = 0;

		Kills = 0;
		Victims = 0;

		PropHealth = 0;

		IRITime = 0;
		PreviousHealth = 0;
		Abuser = false;

		RecoverTime = 0;
		AdrenalineTime = 0;
		VoiceTime = 0;
	}

	void DeathReset()
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);

		DieTeam = pPlayerEntity.GetTeamNumber();

		pPlayer.DoPlayerDSP(0);

		Cured = false;
		Spawn = false;
		FirstInfected = false;
		LobbyRespawnDelay = 0;
		InfectResist = 0;
		RecoverTime = Globals.GetCurrentTime();
		VoiceTime = Globals.GetCurrentTime();
		AdrenalineTime = Globals.GetCurrentTime();

		@pBleeding = null;

		if (DieTeam == TEAM_ZOMBIES && bAllowZombieRespawn && pPlayerEntity.GetTeamNumber() != TEAM_SURVIVORS)
		{
			ZombieRespawnTime = Globals.GetCurrentTime() + CONST_SPAWN_DELAY - 0.05f;
		}
	}

	bool AllowToInfect()
	{
		bool b = false;
		if (SwipeDelay <= Globals.GetCurrentTime())
		{
			b = true;
			SwipeDelay = Globals.GetCurrentTime() + CONST_SWIPE_DELAY;
		}

		return b;
	}

	void SetDefSpeed(int NewSpeed)
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		pPlayer.SetMaxSpeed(NewSpeed);

		DefSpeed = NewSpeed;
	}

	void SetZombieVoice(int VoiceIndex)
	{
		VoiceTime = Globals.GetCurrentTime() + Math::RandomFloat(5.15f, 14.2f);

		if (VoiceIndex == PreviousVoice)
		{
			while (VoiceIndex == PreviousVoice)
			{
				VoiceIndex = Math::RandomInt(1, VOICE_MAX_INDEX);
			}
		}

		PreviousVoice = VoiceIndex;
		Voice = VoiceIndex;
	}

	void SetFirstInfected(bool SFI)
	{
		FirstInfected = SFI;
	}

	void SetAbuser(bool SA)
	{
		Abuser = SA;
		WriteToSteamID();
	}

	bool IsFirstInfected()
	{
		return FirstInfected;
	}

	bool IsAbuser()
	{
		return Abuser;
	}

	void RespawnLobby()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);

		if (LobbyRespawnDelay <= Globals.GetCurrentTime() && pPlayerEntity.GetTeamNumber() == TEAM_LOBBYGUYS) 
		{
			CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
			LobbyRespawnDelay = Globals.GetCurrentTime() + 0.3f;
			pPlayer.ForceRespawn();
		}	
	}

	void EmitZombieSound(string ZM_Sound)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		bool bAllowPainSound = false;

		bAllowPainSound = (pPlayer.IsCarrier() && FirstInfected);

		if (!pPlayer.IsCarrier())
		{
			bAllowPainSound = true;
		}

		if (bAllowPainSound && pPlayerEntity.GetWaterLevel() != WL_Eyes)
		{
			Engine.EmitSoundEntity(pPlayerEntity, ZM_Sound + Voice);
		}
	}

	void AddPropHealth(int HP)
	{
		PropHealth += HP;
		if (PropHealth >= 300)
		{
			PropHealth -= 300;
			AddInfectPoints(-1);
		}
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
			RegenTime = Globals.GetCurrentTime() + flZMRDamageDelay;			
		}

		RecoverTime = Globals.GetCurrentTime() + flRecover;
		pPlayer.SetMaxSpeed(NewSpeed);
	}

	int GetInfectPoints()
	{
		return InfectPoints;
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
			SetAntidoteState(PlayerIndex, AS_USEABLE);
		}
	}

	void InjectAntidote(CBaseEntity@ pItemAntidote)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		IRITime = Globals.GetCurrentTime() + 1.12f;
		InfectResist++;
	
		AddInfectPoints(-1);

		Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0, fade_in);
		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + Math::RandomInt(15, 25));
		Engine.EmitSoundPosition(PlayerIndex, "items/smallmedkit1.wav", pPlayerEntity.EyePosition(), 0.5f, 75, 100);

		SetUsed(PlayerIndex, pItemAntidote);

		if (InfectResist >= CONST_MAX_INFECTRESIST) 
		{
			InfectResist = CONST_MAX_INFECTRESIST;
			Chat.CenterMessagePlayer(pBasePlayer, strMaxInfRes + formatInt(InfectResist));
			SetAntidoteState(PlayerIndex, AS_UNUSEABLE);
		}
		else 
		{
			Chat.CenterMessagePlayer(pBasePlayer, strInfRes + formatInt(InfectResist));
		}
	}

	void InjectAdrenaline(CBaseEntity@ pItemAdrenaline)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		int AdrenaDamage = Math::RandomInt(20, 25);
		float flADuration = CONST_ADRENALINE_DURATION + Math::RandomFloat(0.25f, 3.15f);

		if (AdrenalineTime > Globals.GetCurrentTime())
		{
			AdrenaDamage *= 2;
		}

		int NewSpeed = pPlayer.GetMaxSpeed() + SPEED_ADRENALINE;

		if (NewSpeed > SPEED_ADRENALINE + SPEED_HUMAN)
		{
			NewSpeed = SPEED_ADRENALINE + SPEED_HUMAN;
		}

		pPlayer.SetMaxSpeed(NewSpeed);
		pPlayer.DoPlayerDSP(34);
		Utils.ScreenFade(pPlayer, Color(8, 16, 64, 50), 0.25f, (flADuration - 0.25f), fade_in);
		Engine.EmitSoundPlayer(pPlayer, "ZPlayer.Panic");
		AdrenalineTime = Globals.GetCurrentTime() + flADuration;

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

	void ShowHitMarker(bool CriticalDamage)
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		int R = 0;
		int G = 155;
		int B = 255;
		float Alpha = 0.75f;

		if (CriticalDamage)
		{
			R = 255;
			G = 75;
			B = 75;
		}

		R = int(R * Alpha);
		G = int(G * Alpha);
		B = int(B * Alpha);

		HudTextParams pParams;
		pParams.x = -1;
		pParams.y = -1;
		pParams.channel = 3;
		pParams.fadeinTime = 0.0f;
		pParams.fadeoutTime = 0.2f;
		pParams.holdTime = 0.075f;
		pParams.fxTime = 0.0f;
		pParams.SetColor(Color(R, G, B));
		pParams.SetColor2(Color(0, 0, 0));
		Utils.GameTextPlayer(pPlayer, "+", pParams);
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
		string strStats = "";
		strStats = strStatsHead + " Убийства зомби: " + formatInt(Kills) + "\n Заражение людей: " + formatInt(Victims);

		ShowTextPlr(ToZPPlayer(PlayerIndex), strStats, 2, 0.00f, 0, 0.25f, 0.25f, 0.00f, 10.10f, Color(205, 205, 220), Color(255, 95, 5));
	}

	void GiveStartGear()
	{
		if (!(Cured || Spawn) && RoundManager.IsRoundOngoing(false))
		{
			CZP_Player@ pPlayer = ToBasePlayer(PlayerIndex);
			string firearm = g_strStartWeapons[Math::RandomInt(0, (g_strStartWeapons.length() - 1))];
			int pistol_ammo_count = 15;

			if (iSeconds < iRoundTimeFull)
			{
				firearm = "weapon_ppk";
				pistol_ammo_count = 7;
			}

			pPlayer.AmmoBank(set, pistol, pistol_ammo_count);
			pPlayer.GiveWeapon("weapon_barricade");
			pPlayer.GiveWeapon(firearm);		
		}
	}

	void AddBleeding(const int nAttackerIndex, const float nDamage)
	{
		if (pBleeding is null)
		{
			@pBleeding = TimeBasedDamage(nAttackerIndex, nDamage, TBD_BLEEDING);
		}
		else
		{
			pBleeding.UpdateInfo(nAttackerIndex, nDamage);
		}
	}

	void Think()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		int TeamNum = pPlayerEntity.GetTeamNumber();

		if (pBleeding !is null)
		{
			bool delete = (pBleeding.Think(FindEntityByEntIndex(PlayerIndex)) || pPlayerEntity.GetTeamNumber() != TEAM_ZOMBIES);
			if (delete)
			{
				@pBleeding = null;
			}
		}

		if (ZombieRespawnTime <= Globals.GetCurrentTime() && ZombieRespawnTime != 0)
		{
			ZombieRespawnTime = 0;
			if (bAllowZombieRespawn && RoundManager.IsRoundOngoing(false))
			{
				Spawn = true;
				pPlayerEntity.ChangeTeam(TEAM_SURVIVORS);
				pPlayer.ForceRespawn();
				pPlayer.SetHudVisibility(true);
				TurnToZombie(PlayerIndex);				
			}
		}

		if (RecoverTime <= Globals.GetCurrentTime() && RecoverTime != 0 && pPlayerEntity.IsAlive())
		{
			RecoverTime = Globals.GetCurrentTime() + flRecover;

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
			if (pPlayerEntity.IsAlive())
			{
				if (OutlineTime <= Globals.GetCurrentTime())
				{
					if (pPlayerEntity.GetHealth() != PreviousHealth || pPlayer.IsCarrier())
					{
						OutlineTime = Globals.GetCurrentTime() + 0.02f;
						PreviousHealth = pPlayerEntity.GetHealth();
	
						float MaxHP = pPlayerEntity.GetMaxHealth();
						float HP = pPlayerEntity.GetHealth();
						float HPP = (HP / MaxHP);
						float BaseCChanel = 255;
						int cRed = 0;
						int cGreen = 255;
						int cBlue = 16;
						float ExtraDistance = 0;
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
	
						if (pPlayer.IsCarrier())
						{
							ExtraDistance = GLOW_CARRIER_ADD_DISTANCE;
	
							if (pPlayer.IsRoaring())
							{
								RenderUnOccluded = true;
								ExtraDistance = GLOW_CARRIER_ROAR_DISTANCE;
							}
						}
	
						pPlayerEntity.SetOutline(true, filter_team, TEAM_ZOMBIES, Color(cRed, cGreen, cBlue), GLOW_BASE_DISTANCE + ExtraDistance, true, RenderUnOccluded);
					}
				}

				if (VoiceTime <= Globals.GetCurrentTime())
				{
					EmitZombieSound(VOICE_ZM_IDLE);

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

				if (pPlayerEntity.GetHealth() < pPlayerEntity.GetMaxHealth())
				{
					if (RegenTime <= Globals.GetCurrentTime())
					{
						RegenTime = Globals.GetCurrentTime() + flZMRRate;	//0.1f

						int RegenHealth = pPlayerEntity.GetHealth() + Math::RandomInt(1, iZMRHealth);;	//1

						if (RegenHealth > pPlayerEntity.GetMaxHealth())
						{
							RegenHealth = pPlayerEntity.GetMaxHealth();
						}

						pPlayerEntity.SetHealth(RegenHealth);	
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

			if (IRITime <= Globals.GetCurrentTime() && Utils.StrContains("item_antidote", pWeapon.GetEntityName()))
			{
				IRITime = Globals.GetCurrentTime() + 1.12f;

				string sMax = "";

				if (InfectResist == CONST_MAX_INFECTRESIST)
				{
					sMax = strMax;
				}

				Chat.CenterMessagePlayer(pBasePlayer, strInfRes + formatInt(InfectResist) + sMax);
			}
		}
	}
}

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Last includes
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

#include "./cszm_modules/misc.as"
#include "./cszm_modules/core_warmup.as"

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Forwards
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("Counter-Strike Zombie Mode");

	//Find 'sv_zps_solo' ConVar
	@pSoloMode = ConVar::Find("sv_zps_solo");

	//Find 'sv_testmode' ConVar
	@pTestMode = ConVar::Find("sv_testmode");

	//Find 'sv_zps_warmup' ConVar
	@pINGWarmUp = ConVar::Find("sv_zps_warmup");

	//Find 'mp_friendlyfire' ConVar
	@pFriendlyFire = ConVar::Find("mp_friendlyfire");

	//Find 'sv_zps_infectionrate' ConVar
	@pInfectionRate = ConVar::Find("sv_zps_infectionrate");

	//Find 'sv_zps_hardcore' ConVar
	@pZPSHardcore = ConVar::Find("sv_zps_hardcore");

	//Events
	Events::Player::OnPlayerInfected.Hook(@CSZM_OnPlayerInfected);
	Events::Player::OnPlayerConnected.Hook(@CSZM_OnPlayerConnected);
	Events::Player::OnPlayerSpawn.Hook(@CSZM_OnPlayerSpawn);
	Events::Entities::OnEntityCreation.Hook(@CSZM_OnEntityCreation);
	Events::Custom::OnEntityDamaged.Hook(@CSZM_OnEntDamaged);
	Events::Custom::OnPlayerDamagedCustom_PRE.Hook(@CSZM_OnPlayerDamaged);
	Events::Player::OnPlayerKilled.Hook(@CSZM_OnPlayerKilled);
	Events::Player::OnPlayerDisonnected.Hook(@CSZM_OnPlayerDisonnected);
	Events::Rounds::RoundWin.Hook(@CSZM_RoundWin);
	Events::Player::OnConCommand.Hook(@CSZM_OnConCommand);
	Events::Player::PlayerSay.Hook(@CSZM_CORE_PlrSay);
}

void OnMapInit()
{
	const string MapName = Globals.GetCurrentMapName();
	if (Utils.StrContains("cszm", MapName))
	{
		if (!bIsCSZM)
		{
			CheckForHoldout(MapName);

			Log.PrintToServerConsole(LOGTYPE_INFO, "CSZM", "[CSZM] Current map is valid for 'Counter-Strike Zombie Mode'");
			bIsCSZM = true;
			bIsPlayersSelected = false;
			iWUSeconds = iWarmUpTime;
			flRTWait = 0;
			flWUWait = 0;
			flSoloTime = 0;

			Engine.EnableCustomSettings(true);
			Utils.ForceCollision(TEAM_SURVIVORS, true);
			Utils.ForceCollision(TEAM_ZOMBIES, true);
			
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

			@pCSZMRandomItems = RandomItem();
			
			//Set Doors Filter to 0 (any team)
			if (bWarmUp)
			{
				SetDoorFilter(TEAM_LOBBYGUYS);
			}			
		}
	}
	else
	{
		Log.PrintToServerConsole(LOGTYPE_INFO, "CSZM", "[CSZM] Current map is not valid for \"Counter-Strike Zombie Mode\"");
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		pSoloMode.SetValue("0");

		bIsCSZM = false;

		Engine.EnableCustomSettings(false);
		Utils.ForceCollision(TEAM_SURVIVORS, false);
		Utils.ForceCollision(TEAM_ZOMBIES, false);

		iSeconds = 0;
		iWUSeconds = iWarmUpTime;
		flRTWait = 0;
		flWUWait = 0;
		flSoloTime = 0;
		iHumanWin = 0;
		iZombieWin = 0;
		
		bWarmUp = true;

		Array_CSZMPlayer.removeRange(0, Array_CSZMPlayer.length());
		Array_SteamID.removeRange(0, Array_SteamID.length());

		@pCSZMTimer = null;
		@pCSZMRandomItems = null;
	}
}

void OnProcessRound()
{
	if (bIsCSZM)
	{
		RoundManager.SetCurrentRoundTime(CONST_GAME_ROUND_TIME + Globals.GetCurrentTime());
		RoundManager.SetZombieLives(CONST_ZOMBIE_LIVES);

		if (flRTWait != 0 && flRTWait <= Globals.GetCurrentTime())
		{
			flRTWait = Globals.GetCurrentTime() + 1.0f;
			RoundTimer();
		}

		if (flWUWait != 0 && flWUWait <= Globals.GetCurrentTime())
		{
			WarmUpTimer();
		}

		if (flSoloTime != 0 && flSoloTime != -1 && flSoloTime <= Globals.GetCurrentTime())
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
}

void OnNewRound()
{
	if (bIsCSZM)
	{
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
}

void OnMatchStarting()
{
	if (bIsCSZM)
	{
		pSoloMode.SetValue("1");

		int flGUT_iPortion = int(ceil(iGearUpTime * 0.214f));
		int iPortion = Math::RandomInt(-1 * flGUT_iPortion, flGUT_iPortion);

		int p_iRoundTime = iRoundTime - iPortion;
		int p_iGearUpTime = iGearUpTime + iPortion;

		iRoundTimeFull = p_iRoundTime + p_iGearUpTime;
		iTurnTime = p_iRoundTime;

		iSeconds = iRoundTimeFull;
		@pCSZMTimer = HUDTimer();
	}
}

void OnMatchBegin() 
{
	if (bIsCSZM)
	{
		LogicPlayerManager();
		Schedule::Task(0.5f, "CSZM_LocknLoad");
		Schedule::Task(0.35f, "CSZM_StartGear");

		if (iWUSeconds == 0)
		{
			PutPlrToLobby(null);
			SetDoorFilter(TEAM_SPECTATORS);
			iWUSeconds = iWarmUpTime;
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
			if (Array_CSZMPlayer[i] !is null)
			{
				Array_CSZMPlayer[i].ShowStatsEnd();
			}
		}
	}
}

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

void CSZM_StartGear()
{
	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);
							
		if (pPlayerEntity is null)
		{
			continue;
		}

		if (pPlayerEntity.GetTeamNumber() == TEAM_SURVIVORS)
		{
			Array_CSZMPlayer[i].GiveStartGear();
		}
	}
}

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

		if (pPlayerEntity is null)
		{
			continue;
		}

		if (pPlayerEntity.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			lobby_hint(ToZPPlayer(i));
		}
	}
}

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Entities Forwards
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

void OnEntityPickedUp(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if (pEntity is null || pPlayer is null)
	{
		return;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int index = pBaseEnt.entindex();

	CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[index];
	CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

	if (Utils.StrEql("item_antidote", pEntity.GetEntityName(), true))
	{
		pEntity.SetEntityName("antidote" + formatInt(index));
		pEntity.SetEntityDescription(formatInt(index));
		
		if (pCSZMPlayer.GetInfectResist() >= CONST_MAX_INFECTRESIST)
		{
			if (!Utils.StrContains("antidote", pWeapon.GetEntityName()))
			{
				Chat.CenterMessagePlayer(pPlrEnt, strMaxInfResPickUp);
			}
			Engine.Ent_Fire("antidote" + formatInt(index), "addoutput", "itemstate 0", "0.00");
			Engine.Ent_Fire("antidote" + formatInt(index), "addoutput", "targetname item_antidote", "0.01");
		}
		else
		{
			Engine.Ent_Fire("antidote" + formatInt(index), "addoutput", "itemstate 1", "0.00");
			Engine.Ent_Fire("antidote" + formatInt(index), "addoutput", "targetname item_antidote", "0.01");
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

	if (Utils.StrContains("item_antidote", pEntity.GetEntityName()) && Utils.StringToInt(pEntity.GetEntityDescription()) == index)
	{
		pEntity.SetEntityName("antidote" + formatInt(index));
		pEntity.SetEntityDescription("None");

		Engine.Ent_Fire("antidote" + formatInt(index), "addoutput", "itemstate 1", "0.00");
		Engine.Ent_Fire("antidote" + formatInt(index), "addoutput", "targetname item_antidote", "0.01");
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

	CSZMPlayer@ pCSZMPlayer = Array_CSZMPlayer[index];

	string Targetname = pEntity.GetEntityName();

	if (Utils.StrContains("item_antidote", Targetname))
	{
		pCSZMPlayer.InjectAntidote(pEntity);
	}

	if (Utils.StrEql("item_adrenaline", Targetname))
	{
		pCSZMPlayer.InjectAdrenaline(pEntity);
	}
}

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Hooks
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

HookReturnCode CSZM_RoundWin(const string &in strMapname, RoundWinState iWinState)
{
	if (bIsCSZM)
	{
		flRTWait = 0;
		pCSZMTimer.StopHUDTimer();
		@pCSZMTimer = null;

		if (iWinState == STATE_HUMAN)
		{
			HumanVictoryRewards();
			Engine.EmitSoundPosition(0, "@cszm_fx/misc/hwin.wav", Vector(0, 0, 0), 1.0f, 0, Math::RandomInt(75, 125));
			iHumanWin++;
		}
		else if (iWinState == STATE_ZOMBIE)
		{
			ZombieVictoryRewards();
			Engine.EmitSoundPosition(0, "@cszm_fx/misc/zwin.wav", Vector(0, 0, 0), 1.0f, 0, 100);
			iZombieWin++;
		}

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
					}
				}
			}				
		}
		else
		{
			if ((Utils.StrEql("choose1", pArgs.Arg(0)) || Utils.StrEql("choose2", pArgs.Arg(0))) && pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
			{
				if (pCSZMPlayer.IsAbuser())
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

		switch(TeamNum)
		{
			case TEAM_SPECTATORS:
				if (!bWarmUp)
				{
					spec_hint(pPlayer);
				}
			break;

			case TEAM_LOBBYGUYS:
				Array_CSZMPlayer[index].SetDefSpeed(SPEED_DEFAULT);
				pPlayer.SetArmModel(MODEL_HUMAN_ARMS);
				pBaseEnt.SetModel(MODEL_PLAYER_LOBBYGUY);
				pPlayer.SetVoice(eugene);
				if (!bWarmUp)
				{
					lobby_hint(pPlayer);
				}
				else
				{
					lobby_hint_wu(pPlayer);
				}
			break;

			case TEAM_SURVIVORS:
				Array_CSZMPlayer[index].SetDefSpeed(SPEED_HUMAN);
				Array_CSZMPlayer[index].GiveStartGear();
				pPlayer.SetArmModel(MODEL_HUMAN_ARMS);
			break;
			
			case TEAM_ZOMBIES:
				if (pPlayer.IsCarrier())
				{
					Array_CSZMPlayer[index].SetDefSpeed(SPEED_CARRIER);
				}
				else
				{
					Array_CSZMPlayer[index].SetDefSpeed(SPEED_ZOMBIE);
					pPlayer.SetArmModel(MODEL_ZOMBIE_ARMS);
				}
			break;
		}

		if (bWarmUp)
		{
			PutPlrToPlayZone(pBaseEnt);

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

		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();

		int iAttIndex = pEntityAttacker.entindex();
		int iAttTeam = pEntityAttacker.GetTeamNumber();

		CSZMPlayer@ pVicCSZMPlayer = Array_CSZMPlayer[iVicIndex];

		int InfRes = pVicCSZMPlayer.GetInfectResist();

		if (!pEntityAttacker.IsPlayer())
		{
			bool bSetZeroDMG = false;
			bSetZeroDMG = (Utils.StrEql(pEntityAttacker.GetClassname(), "worldspawn") && bDamageType(iDamageType, 0));

			if (Utils.StrEql(pEntityAttacker.GetClassname(), "npc_fragmine"))
			{
				int iOwnerIndex = Utils.StringToInt(pEntityAttacker.GetEntityDescription());
				CBaseEntity@ pMineOwner = FindEntityByEntIndex(iOwnerIndex);

				if (DamageInfo.GetDamage() > 100)
				{
					DamageInfo.SetDamage(100);
				}

				if (pMineOwner !is null)
				{
					DamageInfo.SetAttacker(pMineOwner);
					DamageInfo.SetInflictor(pMineOwner);
					@pEntityAttacker = pMineOwner;
					iAttTeam = pMineOwner.GetTeamNumber();
					iAttIndex = iOwnerIndex;
					@pAttCSZMPlayer = Array_CSZMPlayer[iOwnerIndex];
				}
			}
			else if (Utils.StrEql(pEntityAttacker.GetEntityName(), "frendly_shrapnel") && iVicTeam == TEAM_SURVIVORS)
			{
				bSetZeroDMG = true;
			}
			else if (iAttTeam == iVicTeam)
			{
				bSetZeroDMG = true;
			}

			if (bSetZeroDMG)
			{
				DamageInfo.SetDamageType(0);
				DamageInfo.SetDamage(0);
			}
		}
		else
		{
			@pAttCSZMPlayer = Array_CSZMPlayer[iAttIndex];
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			strAttName = pPlrAttacker.GetPlayerName();
		}

		if (Utils.StrContains("physics", pEntityAttacker.GetClassname()) || Utils.StrContains("physbox", pEntityAttacker.GetClassname()))
		{
			string AttInfo = GetAttackerInfo(pEntityAttacker.GetEntityDescription());
			CASCommand@ pSplitArgs = StringToArgSplit(AttInfo, ":");
			int iPhysAttacker = Utils.StringToInt(pSplitArgs.Arg(0));

			if (iPhysAttacker > 0)
			{
				@pEntityAttacker = FindEntityByEntIndex(iPhysAttacker);
				@pAttCSZMPlayer = Array_CSZMPlayer[iPhysAttacker];
				iAttIndex = iPhysAttacker;
				iAttTeam = pEntityAttacker.GetTeamNumber();
				DamageInfo.SetAttacker(pEntityAttacker);
			}
		}

		if (iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && bDamageType(iDamageType, 2)) //Damage Type: DMG_ALWAYSGIB + DMG_SLASH
		{
			DamageInfo.SetDamage(Math::RandomInt(15, 20));
			DamageInfo.SetDamageType((1<<9));

			if (Utils.GetNumPlayers(survivor, true) == 1)
			{
				DamageInfo.SetDamage(flDamage);
			}
			else if (InfRes > 0)
			{
				pVicCSZMPlayer.SubtractInfectResist();
			}
			else if (InfRes <= 0 && pAttCSZMPlayer.AllowToInfect())
			{
				pVicCSZMPlayer.Spawn = false;
				DamageInfo.SetDamage(0);
				pAttCSZMPlayer.AddVictim();
				KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, true, false);
				GotVictim(pPlrAttacker, pEntityAttacker);
				TurnToZombie(iVicIndex);

				if (!pVicCSZMPlayer.Cured)
				{
					pVicCSZMPlayer.AddInfectPoints(10);	
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
				pVicCSZMPlayer.AddBleeding(iAttIndex, flDamage);
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

			if (iAttTeam == TEAM_SURVIVORS && pAttCSZMPlayer !is null)
			{
				pAttCSZMPlayer.ShowHitMarker(pBaseEnt.GetHealth() < DamageInfo.GetDamage());
			}

			if (flDamage < pBaseEnt.GetHealth() && flDamage >= 1.0f && !bDamageType(iDamageType, 14))
			{
				//ZM ViewPunch
				bool bLeft = false;
				float VP_X = 0;
				float VP_Y = 0;
				float VP_DAMP = Math::RandomFloat(0.038f , 0.075f);
				float VP_KICK = Math::RandomFloat(0.25f , 0.95f);

				if (bDamageType(iDamageType, 5))	//Fall DamageType
				{
					VP_X = Math::RandomFloat(-3.75f, -6.15f);
					VP_Y = Math::RandomFloat(-3.75f, -6.15f);
					VP_DAMP = Math::RandomFloat(0 , 0.015f);
				}
				else 								//Other DamageTypes
				{
					VP_X = Math::RandomFloat(-1.75f, 1.85f);
					VP_Y = Math::RandomFloat(-1.75f, 1.85f);
				}

				if (Math::RandomInt(0 , 1) > 0)
				{
					bLeft = true;
				}

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
	if (iState != state_none && bIsCSZM)
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
		
		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
		
		int iAttIndex = pEntityAttacker.entindex();
		int iAttTeam = pEntityAttacker.GetTeamNumber();

		CSZMPlayer@ pVicCSZMPlayer = Array_CSZMPlayer[iVicIndex];

		int iDamageType = DamageInfo.GetDamageType();
		
		if (pEntityAttacker.IsPlayer()) 
		{
			@pAttCSZMPlayer = Array_CSZMPlayer[iAttIndex];
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			strAttName = pPlrAttacker.GetPlayerName();
		}

		if (iAttIndex == iVicIndex || !pEntityAttacker.IsPlayer())
		{
			KillFeed("", 0, strVicName, iVicTeam, false, true);
			bSuicide = true;
			pVicCSZMPlayer.AddInfectPoints(25);
		}
		else if (iAttIndex != iVicIndex && pEntityAttacker.IsPlayer())
		{
			KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, false, false);
		}

		if (iVicTeam == TEAM_ZOMBIES)
		{
			if (pVicCSZMPlayer.IsFirstInfected())
			{
				DetachEyesLights(pBaseEnt);
			}

			//Don't emit die sound if blowed up or crushed
			if (!(bDamageType(iDamageType, 6) || bDamageType(iDamageType, 0)))
			{
				pVicCSZMPlayer.EmitZombieSound(VOICE_ZM_DIE);
			}

			if (!bSuicide)
			{
				pAttCSZMPlayer.AddKill();
				if (!pVicCSZMPlayer.Spawn)
				{
					pAttCSZMPlayer.AddInfectPoints(-5);
					pVicCSZMPlayer.AddInfectPoints(10);					
				}
			}
		}

		if (iVicTeam == TEAM_SURVIVORS)
		{
			if (Utils.GetNumPlayers(survivor, false) == 1 && Utils.GetNumPlayers(zombie, false) > 0)
			{
				RoundManager.SetWinState(ws_ZombieWin);
			}

			if (iAttTeam == TEAM_ZOMBIES && pEntityAttacker.IsPlayer())
			{
				GotVictim(pPlrAttacker, pEntityAttacker);
				pAttCSZMPlayer.AddVictim();
				if (!pVicCSZMPlayer.Cured)
				{
					pAttCSZMPlayer.AddInfectPoints(-10);
					pVicCSZMPlayer.AddInfectPoints(15);					
				}
			}

			if (bSuicide)
			{
				pVicCSZMPlayer.SetAbuser(true);
			}
		}

		pVicCSZMPlayer.DeathReset();
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerDisonnected(CZP_Player@ pPlayer)
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int index = pBaseEnt.entindex();

		if (Array_CSZMPlayer[index].IsFirstInfected())
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
			pCSZMRandomItems.Spawn(pEntity);
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

HookReturnCode CSZM_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	if (!bIsCSZM)
	{
		return HOOK_CONTINUE;
	}

	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();
	int EntIndex = pEntity.entindex();
	int iDMGType = DamageInfo.GetDamageType();
	int iAttakerIndex = pAttacker.entindex();
	int iAttakerTeam = pAttacker.GetTeamNumber();

	bool bIsUnbreakable = bIsPropUnbreakable(pEntity); 
	bool bIsJunk = bIsPropJunk(pEntity);
	bool bIsExplosive = bIsPropExplosive(pEntity);

	string strEntClassname = pEntity.GetClassname();

	//Some custom shit for a shrapnel of the FragMine
	if (Utils.StrEql(pAttacker.GetEntityName(), "frendly_shrapnel"))
	{
		DamageInfo.SetDamage(15 + Math::RandomInt(7, 18));

		if (pAttacker.GetHealth() > 0)
		{
			CBaseEntity@ pNewAttacker = FindEntityByEntIndex(pAttacker.GetHealth());

			DamageInfo.SetAttacker(pNewAttacker);
			DamageInfo.SetInflictor(pAttacker);
			DamageInfo.SetWeapon(pAttacker);
		}
		else if (pEntity.GetTeamNumber() == TEAM_SURVIVORS && pEntity.IsPlayer())
		{
			DamageInfo.SetDamage(0);
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
	if (pAttacker.IsPlayer() && iAttakerTeam == TEAM_ZOMBIES && !bIsUnbreakable)
	{
		uint iEntsLength = g_strEntities.length();

		for (uint i = 0; i < iEntsLength; i++)
		{
			if (Utils.StrEql(strEntClassname, g_strEntities[i]))
			{
				int iDMG = int(DamageInfo.GetDamage());
				int iHP = pEntity.GetHealth();
				int iResult = iHP - iDMG;

				bool bLeft = (iDMG > 0);
				bool bHide = (iResult <= 0);

				ShowHP(ToBasePlayer(iAttakerIndex), iResult, bLeft, bHide);
				break;
			}
		}
	}

	//Other stuff
	//Rule to prevent TK with physics
	if (Utils.StrContains("physics", strEntClassname) || Utils.StrContains("physbox", strEntClassname))
	{
		if (pAttacker.IsPlayer())
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
				pEntity.SetEntityDescription(EntDesc + "|" + iAttakerIndex + ":" + "" + (Globals.GetCurrentTime() + 7.04f) + "|");
			}
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
		DamageInfo.SetDamageType(1<<13);
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

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
//Rest funcs
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/

void RoundTimer()
{
	if (Utils.GetNumPlayers(survivor, false) == 0)
	{
		RoundManager.SetWinState(STATE_STALEMATE);
	}

	if (iSeconds <= iTurnTime && !bIsPlayersSelected)
	{
		SelectPlrsForInfect();
	}

	if (iSeconds == 0)
	{
		flRTWait = 0;
		CSZM_EndGame();
	}

	if (iSeconds > 0)
	{
		iSeconds--;
	}
}

void GotVictim(CZP_Player@ pAttacker, CBaseEntity@ pPlayerEntity)
{
	if (pPlayerEntity.IsAlive())
	{
		float portion = ceil(CONST_REWARD_HEALTH * 0.375f);

		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + (CONST_REWARD_HEALTH + Math::RandomInt(int(-1 * portion), int(portion))));
	}

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

		p_BaseArrays.insertLast({i,Array_CSZMPlayer[i].GetInfectPoints()});
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

		Array_CSZMPlayer[iPlayerIndex].AddInfectPoints(-15);
		Array_CSZMPlayer[iPlayerIndex].SetFirstInfected(true);
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

		CBaseEntity@ pCurrentWeapon = pPlayer.GetCurrentWeapon();

		if (!(Utils.StrEql("weapon_phone", pCurrentWeapon.GetClassname(), true) || Utils.StrEql("weapon_emptyhands", pCurrentWeapon.GetClassname(), true)))
		{
			string CurrentName = pCurrentWeapon.GetEntityName();

			if (Utils.StrEql("", pCurrentWeapon.GetEntityName(), true))
			{
				CurrentName = "wep_plr_";
			}

			pCurrentWeapon.SetEntityName(CurrentName + formatInt(index));
			pPlayer.DropWeapon(pPlayer.GetWeaponSlot(CurrentName + formatInt(index)));
			pCurrentWeapon.SetEntityName(CurrentName);	
		}

		if (Array_CSZMPlayer[index].IsFirstInfected())
		{
			flSoloTime = Globals.GetCurrentTime() + 0.1f;
		}

		EmitBloodEffect(pPlayer, Array_CSZMPlayer[index].Spawn);
		pPlayerEntity.ChangeTeam(TEAM_ZOMBIES);
		pPlayer.StripWeapon("weapon_phone");
		pPlayer.StripWeapon("weapon_emptyhands");
		pPlayer.GiveWeapon("weapon_arms");
		pPlayer.SetVoice("eugene_z");
		Engine.EmitSoundEntity(pPlayerEntity, "CSPlayer.Mute");	
		pPlayer.SetArmModel(MODEL_ZOMBIE_ARMS);
		Array_CSZMPlayer[index].SetDefSpeed(SPEED_ZOMBIE);

		RandomZombieModel(pPlayer, pPlayerEntity);
		SetZombieHealth(pPlayerEntity);

		while (iRandomSound == iPreviousInfectIndex)
		{
			iRandomSound = Math::RandomInt(0, g_strInfectSND.length() - 1);
		}

		iPreviousInfectIndex = iRandomSound;

		if (!Array_CSZMPlayer[index].Spawn)
		{
			Engine.EmitSoundPosition(index, g_strInfectSND[iRandomSound], pPlayerEntity.GetAbsOrigin(), 1.0f, 85, Math::RandomInt(99, 107));			
		}
		else
		{
			Engine.EmitSoundPosition(index, ")npc/zombie/zombie_alert" + formatInt(Math::RandomInt(1, 3)) + ".wav", pPlayerEntity.GetAbsOrigin(), 1.0f, 80, Math::RandomInt(100, 105));
		}

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
	
	if (pPlayer.IsCarrier())
	{
		pPlayerEntity.SetModel(MODEL_PLAYER_CARRIER);
	}
	else if (pCSZMPlayer.IsFirstInfected())
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

	if (iArmor > 0)
	{
		pPlayer.SetArmor(0);
	}

	if (Array_CSZMPlayer[index].IsFirstInfected())
	{
		pPlayerEntity.SetMaxHealth(iZombieHealth);
		pPlayerEntity.SetHealth(iZombieHealth + int(float(iZombieHealth) * flInfectedExtraHP) + iArmor);
	}
	else
	{
		pPlayerEntity.SetMaxHealth(iZombieHealth);
		pPlayerEntity.SetHealth(int(float(iZombieHealth) * 0.42f) + iArmor);
	}
}