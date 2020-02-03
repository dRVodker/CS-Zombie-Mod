//Counter-Strike Zombie Mode
//Core Script File

#include "./cszm_modules/balance_arrays.as"
#include "./cszm_modules/balance_funcs.as"

#include "../SendGameText"
#include "./cszm_modules/chat.as"
#include "./cszm_modules/cache.as"
#include "./cszm_modules/killfeed.as"
#include "./cszm_modules/rprop.as"
#include "./cszm_modules/item_flare.as"
#include "./cszm_modules/teamnums.as"
#include "./cszm_modules/core_text.as"
#include "./cszm_modules/core_const.as"

#include "./cszm_modules/download_table.as"

CASConVar@ pSoloMode = null;
CASConVar@ pTestMode = null;
CASConVar@ pINGWarmUp = null;
CASConVar@ pFriendlyFire = null;
CASConVar@ pInfectionRate = null;
CASConVar@ pZPSHardcore = null;

CBaseEntity@ pL_Eye = null;
CBaseEntity@ pR_Eye = null;

int iMaxPlayers;

bool bIsCSZM;	//Это CSZM карта?
bool bAllowAddTime = true;	//Позволить добавлять время за удачное заражение

bool bSpawnWeak = true;
bool bAllowZombieSpawn;
bool bWarmUp = true;

//Счётчики побед
int iHumanWin;
int iZombieWin;

//Ентити, которым нужно установить HP
array<string> g_strBreakableEntities =
{
	"prop_physics",
	"prop_physics_multiplayer",
	"prop_physics_override",
	"prop_door_rotating",
	"func_breakable",
	"func_physbox",
	"func_door_rotating",
	"func_door"
};

//Ентити, которые будут показывать своё HP зомби
array<string> g_strEntities = 
{
	"prop_door_rotating", //0
	"prop_physics_multiplayer", //1
	"prop_physics_override", //2
	"prop_physics", //3
	"func_door_rotating", //4
	"func_door", //5
	"func_breakable", //6
	"func_physbox", //7
	"prop_barricade" //8
};

//Список моделей, которые используются для зомби
array<string> g_strModels = 
{
	"models/cszm/zombie_classic.mdl",
	"models/cszm/zombie_sci.mdl",
	"models/cszm/zombie_corpse1.mdl",
	"models/cszm/zombie_charple2.mdl",
	"models/cszm/zombie_sawyer.mdl",
	"models/cszm/zombie_bald.mdl",
	"models/cszm/zombie_eugene.mdl"
};

array<string> g_strMDLToChoose;

//Массивы объектов
array<CSZMPlayer@> CSZMPlayerArray;
array<CShowDamage@> ShowDamageArray;

//Массив для SteamID (Хранит значения некоторых переменных игрока)
array<string> SteamIDArray;

//Другое
int iPreviousZMVoiceIndex;
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

class CShowDamage
{
	private int PlayerIndex;
	private int VicIndex; 
	private int Hits;
	private float DamageDealt;
	private float Reset;
	private float Wait;

	CShowDamage(int index)
	{
		PlayerIndex = index;
		VicIndex = 0;
		Hits = 0;
		DamageDealt = 0;
		Reset = 0;
		Wait = 0;
	}

	void AddDamage(float flDamage, CBaseEntity@ pVictim)
	{	
		if (pVictim is null || flDamage < 1)
		{
			return;
		}

		int VicHP = pVictim.GetHealth();
		VicIndex = pVictim.entindex();
		Hits++;
		Reset = Globals.GetCurrentTime() + CONST_SHOWDMG_RESET;
		Wait = Globals.GetCurrentTime() + CONST_SHOWDMG_WAIT;

		if (VicHP - flDamage <= 0)
		{
			DamageDealt += VicHP;
		}
		else
		{
			DamageDealt += flDamage;
		}
	}

	void Think()
	{
		if (Reset <= Globals.GetCurrentTime() && Reset != 0)
		{
			Reset = 0;
			VicIndex = 0;
			DamageDealt = 0;
			Hits = 0;
			Wait = 0;
		}

		if (Wait <= Globals.GetCurrentTime() && Wait != 0)
		{
			Wait = 0;

			CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
			CBaseEntity@ pVictim = FindEntityByEntIndex(VicIndex);

			int VicHP = pVictim.GetHealth();

			if (pPlayerEntity is null)
			{
				return;
			}

			if (VicHP < 0)
			{
				VicHP = 0;
			}

			string strHits = " hits";

			if (Hits == 1)
			{
				strHits = " hit";
			}

			if (pPlayerEntity.GetTeamNumber() == TEAM_SURVIVORS)
			{
				Chat.CenterMessagePlayer(pBasePlayer, "Damage dealt: " + int(DamageDealt) + "\nin " + Hits + strHits + "\nHealth left: " + VicHP);
			}
		}
	}
}

class CSZMPlayer
{
	private string SteamID;
	private int PlayerIndex;			//entindex игрока
	private int SlowSpeed;				//Скорость, которая вычитается из "DefSpeed"
	private int DefSpeed;				//Обычная скорость движения игрока
	private int Voice;					//Номер голоса для зомби (3 максимально кол-во)
	private int PreviousVoice;			//Номер предыдущего голоса
	private int InfectResist;			//Сопротивление инфекции
	private int PreviousHP;				//Предыдущее HP, используется для обводки зомби
	private int InfectDelay;			//Кол-во раундов, которое игрок должен отыграть за выжевшего, чтобы сновы начать раунд как Первый зараженный
	private int ZMDeathCount;			//Счётчик смертей зомби, используется для вычисления бонусного HP для зомби

	private float SlowTime;				//Время, которое должен ждать зомби, чтобы начать восстанавливать скорость
	private float SpeedRT;				//Время, по истечению которого зомби получет определенное кол-во скорости
	private float VoiceTime;			//Временные промежутки между IDLE звуками зомби
	private float AdrenalineTime;		//Время действия адреналина
	private float IRITime;				//Время, по истечению которого показывается сообщение об кол-ве сопротивления инфекции
	private float MeleeFreezeTime;		//Время, на протяжении которого на зомби будет действовать сильное замедление (ступор)
	private float OutlineTime;			//Время, по истечению которого обновляется обводка зомби
	private float LobbyRespawnDelay;	//Время, которое должен ждать игрок в лобби, чтобы сново использовать "F4 Respawn"

	private bool Volunteer;				//Доброволец на роль Первого зараженного
	private bool WeakZombie;			//Слабый зомби
	private bool Abuser;				//Злоупотребляет механиками
	private bool FirstInfected;			//Является Первый зараженным
	private bool WasFInfectedInSession;	//Был Первым зараженным в сессии

	CSZMPlayer(int index, CZP_Player@ pPlayer)
	{
		SteamID = pPlayer.GetSteamID64();
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
		InfectDelay = 0;
		ZMDeathCount = 0;
		Volunteer = false;
		Abuser = false;
		FirstInfected = false;
		WasFInfectedInSession = false;

		if (bSpawnWeak)
		{
			WeakZombie = true;
		}
		else
		{
			WeakZombie = false;
		}

		this.CheckSM();
	}

	private void CheckSM()
	{
		int iLength = int(SteamIDArray.length());
		for (int i = 0; i < iLength; i++)
		{
			if (Utils.StrContains(SteamID, SteamIDArray[i]))
			{
				CASCommand@ pSplited = StringToArgSplit(SteamIDArray[i], ";");
				InfectDelay = Utils.StringToInt(pSplited.Arg(1));

				if(RoundManager.IsRoundOngoing(false))
				{
					Abuser = (pSplited.Arg(2) == "true");
				}

				WasFInfectedInSession = (pSplited.Arg(3) == "true");
				SteamIDArray.removeAt(i);
				break;
			}
		}
	}

	void WriteSteamIDToArray()
	{
		string STR_SteamID = SteamID;
		string STR_ABUSER = "" + Abuser;
		string STR_INF_DELAY = "" + InfectDelay;
		string STR_WAS_FI_INF = "" + WasFInfectedInSession;
		SteamIDArray.insertLast(STR_SteamID + ";" + STR_INF_DELAY + ";" + STR_ABUSER + ";" + STR_WAS_FI_INF);
	}

	void Reset()
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		pPlayer.DoPlayerDSP(0);

		AdrenalineTime = 0;
		VoiceTime = 0;
		SlowTime = 0;
		SlowSpeed = 0;
		InfectResist = 0;
		IRITime = 0;
		MeleeFreezeTime = 0;
		PreviousHP = 0;
		LobbyRespawnDelay = 0;
		Volunteer = false;
		WeakZombie = true;
		Abuser = false;
		FirstInfected = false;
		ZMDeathCount = -1;
	}

	void DeathReset()
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		pPlayer.DoPlayerDSP(0);

		Volunteer = false;
		FirstInfected = false;
		LobbyRespawnDelay = 0;
		MeleeFreezeTime = 0;
		InfectResist = 0;
		SlowSpeed = 0;
		SlowTime = Globals.GetCurrentTime();
		VoiceTime = Globals.GetCurrentTime();
		AdrenalineTime = Globals.GetCurrentTime();

		if (!bSpawnWeak)
		{
			WeakZombie = false;
		}
	}

	bool WasFirstInfected()
	{
		return WasFInfectedInSession;
	}

	void SetFInfectedState(bool WFI)
	{
		WasFInfectedInSession = WFI;
	}

	bool IsFirstInfected()
	{
		return FirstInfected;
	}

	void SetFirstInfected(bool SFI)
	{
		FirstInfected = SFI;
	}

	bool IsAbuser()
	{
		return Abuser;
	}

	void SetAbuser(bool SA)
	{
		Abuser = SA;
	}

	void SetVoiceTime(float NewTime)
	{
		VoiceTime = Globals.GetCurrentTime() + NewTime;
	}

	int GetHPBonus()
	{
		int HPBonus = 0;

		if (ZMDeathCount > 0)
		{
			HPBonus = ZMDeathCount * CONST_DEATH_BONUS_HP;
		}

		return HPBonus;
	}

	void DecreaseZMDC()
	{
		if (ZMDeathCount > 0)
		{
			ZMDeathCount -= CONST_SUBTRACT_DEATH;

			if (ZMDeathCount < 0)
			{
				ZMDeathCount = 0;
			}
		}
	}

	void IncreaseZMDC()
	{
		if (!FirstInfected)
		{
			ZMDeathCount++;

			if (ZMDeathCount > CONST_DEATH_MAX)
			{
				ZMDeathCount = CONST_DEATH_MAX;
			}
		}
	}

	bool IsVolunteer()
	{
		return Volunteer;
	}

	bool IsWeakZombie()
	{
		return WeakZombie;
	}

	void SetWeakZombie(bool SWZ)
	{
		WeakZombie = SWZ;
	}

	void SetVolunteer(bool SetV)
	{
		Volunteer = SetV;
	}

	bool ChooseInfect()
	{
		CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
		bool Handled = false;

		if (InfectDelay > 0)
		{
			Chat.PrintToChatPlayer(pBasePlayer, strCannotPlayFI);
			Handled = true;

			return Handled;
		}
		else
		{
			Chat.PrintToChatPlayer(pBasePlayer, strChooseToPlayFI);

			if (!Volunteer)
			{
				Volunteer = true;
			}
		}

		return Handled;
	}

	int GetInfectDelay()
	{
		return InfectDelay;
	}

	void SubtractInfectDelay()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);

		if (InfectDelay > 0 && pPlayerEntity.GetTeamNumber() == TEAM_SURVIVORS)
		{
			InfectDelay--;
		}
	}

	void AddInfectDelay(int Delay)
	{
		if (Delay < 0)
		{
			Delay = CONST_INFECT_DELAY;
		}

		InfectDelay += Delay;
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

	void SetDefSpeed(int NewSpeed)
	{
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);
		pPlayer.SetMaxSpeed(NewSpeed);

		DefSpeed = NewSpeed;
		SlowSpeed = 0;
		SlowTime = 0;
		SpeedRT = 0;
	}

	void SetZMVoice(int VoiceIndex)
	{
		VoiceTime = Globals.GetCurrentTime() + Math::RandomFloat(5.15f, 14.2f);

		if (WeakZombie && !FirstInfected)
		{
			Voice = 2;
			PreviousVoice = 2;
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

			PreviousVoice = VoiceIndex;
			Voice = VoiceIndex;
		}
	}

	void EmitZMSound(string ZM_Sound)
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

	void AddSlowdown(float flDamage, int iDamageType)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		VoiceTime += Math::RandomFloat(0.67f, 0.98f);	//Увеличить таймер "VoiceTime" если замедлился / получил урон
		SpeedRT = Globals.GetCurrentTime() + 0.125f;

		const int MinSlowSpeed = int((DefSpeed * 0.01) * CONST_SLOWDOWN_MULT);	//Минимальная скорость для замедленного зомби
		int NewSlowSpeed;								//Переменная для вычисления новой скорости
		float NewFreezeTime = 0;						//Переменная для вычисления нового времени ступора
		float CurrentFreezeTime = MeleeFreezeTime - Globals.GetCurrentTime();
		float WeakP = 0.0f;

		if (CurrentFreezeTime <= 0)
		{
			CurrentFreezeTime = 0;
		}

		if (SlowTime < Globals.GetCurrentTime())
		{
			SlowTime = Globals.GetCurrentTime();
		}

		if (WeakZombie)
		{
			WeakP = 21.95f;
		}
		else if (FirstInfected)
		{
			WeakP = -1.14f;
		}
		else if (pPlayer.IsCarrier())
		{
			WeakP = -3.75f;
		}

		SlowTime += CONST_SLOWDOWN_TIME;
		NewSlowSpeed = int(((DefSpeed * 0.000127f) * (CONST_SLOWDOWN_MULT + WeakP)) * ((flDamage / CONST_SLOWDOWN_HEALTH) * 100));

		if (flDamage < 2)
		{
			NewSlowSpeed += 1;
		}

		if (bDamageType(iDamageType, 6))		//Blast
		{
			SlowTime += 1.7f;
			NewFreezeTime += 0.275f;
		}
		else if (bDamageType(iDamageType, 27))	//Blast Surface
		{
			SlowTime += 0.20f;
			NewFreezeTime += 0.075f;
		}
		else if (bDamageType(iDamageType, 5))	//Fall
		{
			NewSlowSpeed += 25;
			SlowTime += 1.32f;
			NewFreezeTime += 0.15f;
		}

		if (flDamage > CONST_SLOWDOWN_CRITDMG)	//Add time if critical dmg
		{
			SlowTime += 0.78f;
			NewFreezeTime += 0.175f;
		}

		//Cap slowdown time to our MAX
		if (SlowTime - Globals.GetCurrentTime() > CONST_MAX_SLOWTIME)
		{
			SlowTime = Globals.GetCurrentTime() + CONST_MAX_SLOWTIME;
		}

		if (bDamageType(iDamageType, 7))		//Melee
		{
			SlowTime += 4.0f;
			NewFreezeTime += 1.15f;
		}

		if (NewFreezeTime > 0)
		{
			NewFreezeTime += CurrentFreezeTime;

			if (NewFreezeTime > CONST_MAX_SLOWTIME)
			{
				NewFreezeTime = CONST_MAX_SLOWTIME;
			}

			MeleeFreezeTime = Globals.GetCurrentTime() + NewFreezeTime;
		}

		SlowSpeed += NewSlowSpeed;

/*		if (WeakZombie)
		{
			SlowTime = Globals.GetCurrentTime() - 0.01f;
			MeleeFreezeTime = 0;
			NewSlowSpeed = int(float(NewSlowSpeed) * 0.3f);
		}*/

		if (SlowSpeed > MinSlowSpeed)
		{
			SlowSpeed = MinSlowSpeed;
		}

		pPlayer.SetMaxSpeed(DefSpeed - SlowSpeed);
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

		Utils.ScreenFade(pPlayer, Color(30, 125, 35, 75), 0.25, 0, fade_in);
		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + Math::RandomInt(15, 25));
		Engine.EmitSoundPosition(PlayerIndex, "items/smallmedkit1.wav", pPlayerEntity.EyePosition(), 0.5f, 75, 100);

		SetUsed(PlayerIndex, pItemAntidote);

		if (InfectResist >= CONST_MAX_INFECTRESIST) 
		{
			InfectResist = CONST_MAX_INFECTRESIST;
			Chat.CenterMessagePlayer(pBasePlayer, "You got Maximum Infection Resist: " + InfectResist);
			SetAntidoteState(PlayerIndex, AS_UNUSEABLE);
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

		SetUsed(PlayerIndex, pItemAdrenaline);

		pPlayerEntity.SetMaxHealth(pPlayerEntity.GetMaxHealth() - AdrenaDamage);

		CTakeDamageInfo AdrenaDMG;

		AdrenaDMG.SetInflictor(pPlayerEntity);
		AdrenaDMG.SetAttacker(pPlayerEntity);
		AdrenaDMG.SetWeapon(null);
		AdrenaDMG.SetDamage(AdrenaDamage);
		AdrenaDMG.SetDamageType(DMG_POISON);

		pPlayerEntity.TakeDamage(AdrenaDMG);
	}

	void SpawnWeakZombie()
	{
		if (bSpawnWeak && WeakZombie)
		{
			CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
			CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
			CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

			if (pPlayer.IsCarrier()) 
			{
				pPlayerEntity.SetModel("models/cszm/carrier.mdl");
				pPlayer.SetArmModel("models/weapons/arms/c_carrier.mdl");
			}
			else 
			{
				pPlayerEntity.SetModel("models/cszm/zombie_charple1.mdl");
				pPlayer.SetArmModel(MODEL_ZOMBIE_ARMS);
			}

			Utils.CosmeticWear(pPlayer, "models/cszm/weapons/w_knife_t.mdl");
			pPlayerEntity.SetMaxHealth(15);
			pPlayerEntity.SetHealth(CONST_WEAK_ZOMBIE_HP);
			this.SetDefSpeed(SPEED_WEAK);
			this.SetZMVoice(2);
			Chat.PrintToChatPlayer(pBasePlayer, strWeakZombie);
		}
	}

	void Think()
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(PlayerIndex);
		CBasePlayer@ pBasePlayer = ToBasePlayer(PlayerIndex);
		CZP_Player@ pPlayer = ToZPPlayer(PlayerIndex);

		int TeamNum = pPlayerEntity.GetTeamNumber();

		if (TeamNum == TEAM_ZOMBIES)
		{
			if (OutlineTime <= Globals.GetCurrentTime())
			{
				if (pPlayerEntity.GetHealth() != PreviousHP || pPlayer.IsCarrier())
				{
					OutlineTime = Globals.GetCurrentTime() + 0.02f;
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

					if (HPP < 1 && !WeakZombie)
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

					if (WeakZombie)
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

			if (SlowTime <= Globals.GetCurrentTime() && SlowTime != 0 && SpeedRT <= Globals.GetCurrentTime() && SpeedRT != 0 && SlowSpeed != 0)
			{

				int NewSpeed;

				SpeedRT = Globals.GetCurrentTime() + CONST_RECOVER_TIME;
				SlowSpeed -= CONST_RECOVER_SPEED;

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

					if (WeakZombie)
					{
						Time_Low *= 0.5f;
						Time_High *= 0.6f;
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

//misc.as
#include "./cszm_modules/misc.as"
#include "./cszm_modules/core_warmup.as"

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
	Events::Player::OnPlayerDamaged.Hook(@CSZM_POST_OnPlayerDamaged);
	Events::Player::OnPlayerKilled.Hook(@CSZM_OnPlayerKilled);
	Events::Player::OnPlayerDisonnected.Hook(@CSZM_OnPlayerDisonnected);
	Events::Rounds::RoundWin.Hook(@CSZM_RoundWin);
	Events::Player::OnConCommand.Hook(@CSZM_OnConCommand);

}

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		if (Utils.StrContains("heavyice", Globals.GetCurrentMapName()))
		{
			UnlimitedRandom = true;
		}
		else
		{
			UnlimitedRandom = false;
		}

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
		
		//Resize
		g_iKills.resize(iMaxPlayers + 1);
		g_iVictims.resize(iMaxPlayers + 1);

		//CSZM Player array resize
		CSZMPlayerArray.resize(iMaxPlayers + 1);
		ShowDamageArray.resize(iMaxPlayers + 1);
		
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
		ShowDamageArray.removeRange(0, ShowDamageArray.length());
		SteamIDArray.removeRange(0, SteamIDArray.length());
		
		ClearIntArray(g_iKills);
		ClearIntArray(g_iVictims);
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
				Chat.CenterMessagePlayer(pPlrEnt, "You already has maximum of Infection Resist");
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

HookReturnCode CSZM_RoundWin(const string &in strMapname, RoundWinState iWinState)
{
	if (bIsCSZM)
	{
		flRTWait = 0;
		ShowTimer(10.25f);

		if (iWinState == STATE_HUMAN)
		{
			Engine.EmitSound("CS_HumanWin");
			iHumanWin++;
		}
		else if (iWinState == STATE_ZOMBIE)
		{
			Engine.EmitSound("CS_ZombieWin");
			iZombieWin++;
		}

		string strHW = "\n Humans Win - " + iHumanWin;
		string strZW = "\n Zombies Win - " + iZombieWin;
		
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

		CShowDamage@ pShowDamage = CShowDamage(index);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayer(index, pPlayer);

		@CSZMPlayerArray[index] = pCSZMPlayer;
		@ShowDamageArray[index] = pShowDamage;

		g_iKills[index] = 0;
		g_iVictims[index] = 0;
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

		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

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
						if (!pCSZMPlayer.ChooseInfect())
						{
							StripBalls(pPlayer);
						}
						else
						{
							HOOK_RESULT = HOOK_HANDLED;
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
						if (pCSZMPlayer.IsAbuser())
						{
							Chat.PrintToChatPlayer(pPlrEnt, strCannotJoinGame);
							Engine.EmitSoundPlayer(pPlayer, "buttons/combine_button_locked.wav");

							HOOK_RESULT = HOOK_HANDLED;
						}
						else
						{
							StripBalls(pPlayer);
							pBaseEnt.ChangeTeam(TEAM_SURVIVORS);
							pPlayer.ForceRespawn();
							pPlayer.SetHudVisibility(true);

							HOOK_RESULT = HOOK_HANDLED;
						}
					}
					else if (pCSZMPlayer.IsAbuser())
					{
						StripBalls(pPlayer);
						pBaseEnt.ChangeTeam(TEAM_ZOMBIES);
						pPlayer.ForceRespawn();
						pPlayer.SetHudVisibility(true);

						HOOK_RESULT = HOOK_HANDLED;
					}
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
			pPlayer.SetArmModel(MODEL_HUMAN_ARMS);
		}
		else
		{
			//Keep The Carrier with his own arms model
			if (!pPlayer.IsCarrier())
			{
				//CSS Arms model (zombie skin)
				pPlayer.SetArmModel(MODEL_ZOMBIE_ARMS);
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
		
		if (!bWarmUp)
		{
			if (TeamNum == TEAM_SPECTATORS)
			{
				spec_hint(pPlayer); //Hint for spectator, probably not working
			}

			if (TeamNum == TEAM_ZOMBIES)
			{
				if (bAllowZombieSpawn)
				{
					if (!pPlayer.IsCarrier())
					{
						pPlayer.SetVoice(eugene);
					}

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
					
					RndZModel(pPlayer, pBaseEnt);
					SetZMHealth(pBaseEnt);

					EmitBloodEffect(pPlayer, true);
					pCSZMPlayer.SpawnWeakZombie();
					pCSZMPlayer.SetVoiceTime(0.075f);
				}
				else
				{
					Chat.PrintToChatPlayer(pBaseEnt, strCannotJoinZT0);
					MovePlrToSpec(pBaseEnt);
					Engine.EmitSoundPlayer(pPlayer, "buttons/combine_button_locked.wav");
				}
			}
		}
		else
		{
			if (pPlrEnt.IsBot())									
			{
				pBaseEnt.ChangeTeam(TEAM_LOBBYGUYS);
				pPlayer.ForceRespawn();
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
		CSZMPlayer@ pAttCSZMPlayer = null;
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

//		SD("{violet}Attacker: {cyan}" + pEntityAttacker.GetClassname() + "\n{violet}Index: {cyan}" + pEntityAttacker.entindex());

		if (!pEntityAttacker.IsPlayer())
		{
			bool bSetZeroDMG = false;
			bSetZeroDMG = Utils.StrEql(pEntityAttacker.GetClassname(), "worldspawn");

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
			@pAttCSZMPlayer = CSZMPlayerArray[iAttIndex];
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			strAN = pPlrAttacker.GetPlayerName();
		}

		const string strAttName = strAN;

		if (Utils.StrContains("physics", pEntityAttacker.GetClassname()) || Utils.StrContains("physbox", pEntityAttacker.GetClassname()))
		{
			string AttInfo = GetAttackerInfo(pEntityAttacker.GetEntityDescription());
			CASCommand@ pSplitArgs = StringToArgSplit(AttInfo, ":");
			int iPhysAttacker = Utils.StringToInt(pSplitArgs.Arg(0));

			if (iPhysAttacker > 0)
			{
				CBaseEntity@ pNewPhysAttacker = FindEntityByEntIndex(iPhysAttacker);
				DamageInfo.SetAttacker(pNewPhysAttacker);
			}
		}

		if (iVicTeam == TEAM_SURVIVORS && iAttTeam == TEAM_ZOMBIES && iDamageType == 8196) //Damage Type: DMG_ALWAYSGIB + DMG_SLASH
		{
			if (InfRes > 0)
			{
				pVicCSZMPlayer.SubtractInfectResist();
			}
			else if (InfRes <= 0)
			{
				DamageInfo.SetDamage(0);
				g_iVictims[iAttIndex]++;
				ShowKills(pPlrAttacker, g_iVictims[iAttIndex], true);
				KillFeed(strAttName, iAttTeam, strVicName, iVicTeam, true, false);
				GotVictim(pPlrAttacker, pEntityAttacker, pAttCSZMPlayer.IsWeakZombie());
				ZombiePoints(pPlrAttacker);
				TurnToZ(iVicIndex);
			}
		}
		
		if (iVicTeam == TEAM_ZOMBIES && pBaseEnt.IsAlive())
		{
			if (flDamage < pBaseEnt.GetHealth() && flDamage >= 1.0f)
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

				pVicCSZMPlayer.EmitZMSound(VOICE_ZM_PAIN);
				pVicCSZMPlayer.AddSlowdown(flDamage, iDamageType);
			}
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_POST_OnPlayerDamaged(CZP_Player@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	if (bIsCSZM)
	{
		CZP_Player@ pPlrAttacker = null;

		CBasePlayer@ pBPlrAttacker = null;

		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		CBaseEntity@ pEntityAttacker = DamageInfo.GetAttacker();
		
		const int iVicIndex = pBaseEnt.entindex();
		const int iVicTeam = pBaseEnt.GetTeamNumber();
		const int iAttIndex = pEntityAttacker.entindex();
		const bool bIsAttPlayer = pEntityAttacker.IsPlayer();

		CShowDamage@ pShowDamage = ShowDamageArray[iAttIndex];

		if (bIsAttPlayer)
		{
			@pPlrAttacker = ToZPPlayer(iAttIndex);
			@pBPlrAttacker = ToBasePlayer(iAttIndex);
		}
		else
		{
			return HOOK_HANDLED;
		}

		if (pEntityAttacker.GetTeamNumber() == TEAM_SURVIVORS && iVicTeam == TEAM_ZOMBIES)
		{
			pShowDamage.AddDamage(DamageInfo.GetDamage(), pBaseEnt);
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnPlayerInfected(CZP_Player@ pPlayer, InfectionState iState)
{
	//Built-in infection is not allowed
	if (iState != state_none && bIsCSZM)
	{
		pPlayer.SetInfection(true, 1200.0f);
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

		const int iDamageType = DamageInfo.GetDamageType();
		
		if (pEntityAttacker.IsPlayer()) 
		{
			@pAttCSZMPlayer = CSZMPlayerArray[iAttIndex];
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
			if (pVicCSZMPlayer.IsFirstInfected())
			{
				pBaseEnt.SetBodyGroup("EyesGlow", 0);
				pBaseEnt.SetSkin(0);

				@pR_Eye = FindEntityByName(null, "RighrEye");
				@pL_Eye = FindEntityByName(null, "LeftEye");

				if (pR_Eye !is null)
				{
					pR_Eye.SUB_Remove();
					@pR_Eye = null;
				}
				if (pL_Eye !is null)
				{
					pL_Eye.SUB_Remove();
					@pL_Eye = null;
				}
			}

			//Don't emit die sound if blowed up
			if (!bDamageType(iDamageType, 6))
			{
				pVicCSZMPlayer.EmitZMSound(VOICE_ZM_DIE);
			}

			if (!bSuicide)
			{
				pVicCSZMPlayer.IncreaseZMDC();

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
			pVicCSZMPlayer.SetWeakZombie(false);
			GotVictim(pPlrAttacker, pEntityAttacker, pAttCSZMPlayer.IsWeakZombie());
		}

		if (iVicTeam == TEAM_SURVIVORS && bSpawnWeak)
		{
			pVicCSZMPlayer.SetAbuser(true);
		}

		if (iFZIndex == iVicIndex)
		{
			iFZIndex = 0;
			pVicCSZMPlayer.AddInfectDelay(5);
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

		if (iFZIndex == index)
		{
			iFZIndex = 0;
			CSZMPlayerArray[index].AddInfectDelay(5);
		}

		CSZMPlayerArray[index].WriteSteamIDToArray();
		@CSZMPlayerArray[index] = null;
		@ShowDamageArray[index] = null;
		
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
			SpawnRandomItem(pEntity);
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
				CZP_Player@ pPlayerOwner = ToZPPlayer(pOwner);
				pPlayerOwner.AmmoWeapon(set, 15);
			}
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	if (!bIsCSZM)
	{
		return HOOK_HANDLED;
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

	//Slightly reduce input damage if it's "prop_barricade"
	if (Utils.StrEql(strEntClassname, "prop_barricade"))
	{
		DamageInfo.SetDamage(DamageInfo.GetDamage() * 0.91f);
	}

	//Show HP to zombie attacker
	if (pAttacker.IsPlayer() && pAttacker.GetTeamNumber() == TEAM_ZOMBIES && !bIsUnbreakable)
	{
		int iSlot = iAttakerIndex;
		bool bIsValid = false;
		uint iEntsLength = g_strEntities.length();

		for (uint i = 0; i < iEntsLength; i++)
		{
			if (Utils.StrEql(strEntClassname, g_strEntities[i]))
			{
				bIsValid = true;
				break;
			}
		}

		if (bIsValid)
		{
			bool bLeft = false;
			int iDMG = int(DamageInfo.GetDamage());
			int iHP = pEntity.GetHealth();
			int iResult = iHP - iDMG;

			if (iDMG > 0)
			{
				bLeft = true;
			}
			if (iResult > 0)
			{
				ShowHP(ToBasePlayer(iSlot), iResult, bLeft, false);
			}
			else
			{
				ShowHP(ToBasePlayer(iSlot), iResult, bLeft, true);
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

	//Special rule for prop_physics
	if (Utils.StrContains("physics", strEntClassname))
	{
		//Getting some important data there
		float flMass = pEntity.GetMass();
		float flForceMultiplier = 1.0f;

		//Only for survivors
		//If Damage Type is BULLET reduce amount of damage and increase force by fake mass
		if (bDamageType(iDMGType, 1) && pAttacker.IsPlayer() && pAttacker.GetTeamNumber() == TEAM_SURVIVORS)
		{
			string WeaponName = (ToZPPlayer(pAttacker).GetCurrentWeapon()).GetClassname();
			Vector DamageForce = DamageInfo.GetDamageForce();
				
			//Set DMG_BULLET Damage Type, otherwise it won't push
			DamageInfo.SetDamageType(1<<1);
			DamageInfo.ScaleDamageForce(1.0f);

			if (Utils.StrEql("weapon_glock", WeaponName) || Utils.StrEql("weapon_usp", WeaponName) || Utils.StrEql("weapon_glock18c", WeaponName) || Utils.StrEql("weapon_mp5", WeaponName))
			{
				flForceMultiplier = 0.585f;
			}
			else if (Utils.StrEql("weapon_ppk", WeaponName))
			{
				flForceMultiplier = 1.85f;
			}
			else if (Utils.StrEql("weapon_m4", WeaponName) || Utils.StrEql("weapon_ak47", WeaponName))
			{
				flForceMultiplier = 0.91f;
			}
			else if (Utils.StrEql("weapon_870", WeaponName) || Utils.StrEql("weapon_winchester", WeaponName))
			{
				flForceMultiplier = 0.175f;
			}
			else if (Utils.StrEql("weapon_supershorty", WeaponName))
			{
				flForceMultiplier = 0.2525f;
			}
			else if (Utils.StrEql("weapon_revolver", WeaponName))
			{
				flForceMultiplier = 0.17f;
			}

			flForceMultiplier *= (flMass * 0.25f);

			DamageInfo.SetDamageForce((DamageForce * flForceMultiplier));

			//Do not reduce damage if explosive props or junk
			if (!bIsJunk)
			{
				if (!bIsExplosive)
				{
					DamageInfo.SetDamage(DamageInfo.GetDamage() * 0.0225f);				
				}
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

		if (flWeakZombieWait != 0 && bSpawnWeak && flWeakZombieWait <= Globals.GetCurrentTime())
		{
			bSpawnWeak = false;
		}

		for (int i = 1; i <= iMaxPlayers; i++) 
		{
			CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];
			CShowDamage@ pShowDamage = ShowDamageArray[i];

			if (pCSZMPlayer !is null)
			{
				pCSZMPlayer.Think();
			}

			if (pShowDamage !is null)
			{
				pShowDamage.Think();
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
			g_iKills[i] = 0;
			g_iVictims[i] = 0;

			CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];

			if (pCSZMPlayer !is null)
			{
				pCSZMPlayer.Reset();
			}
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

	Engine.EmitSound("CS_MatchBeginRadio");
	Globals.SetPlayerRespawnDelay(false, CONST_SPAWN_DELAY);
	ShowChatMsg(strRoundBegun, TEAM_SURVIVORS);
	DecideFirstInfected();
	HealthSettings();

	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[i];

		if (pPlayerEntity is null)
		{
			continue;
		}

		if (pCSZMPlayer !is null)
		{
			pCSZMPlayer.SubtractInfectDelay();
		}

		if (pPlayerEntity.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			lobby_hint(ToZPPlayer(i));
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
			CZP_Player@ pPlayer = ToZPPlayer(i);

			if (pPlayer is null)
			{
				continue;
			}

			ShowStatsEnd(pPlayer, g_iKills[i], g_iVictims[i]);
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

void GotVictim(CZP_Player@ pAttacker, CBaseEntity@ pPlayerEntity, const bool &in bZMWeak)
{
	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[pPlayerEntity.entindex()];
	pCSZMPlayer.DecreaseZMDC();
		
	if (pPlayerEntity.IsAlive() && !bZMWeak)
	{
		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + CONST_REWARD_HEALTH);
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
	
		if (iSeconds < CONST_MIN_ROUNDTIMER && iTime > 0)
		{
			iSeconds += (iTime * iOverTimeMult);
			ShowTimer(0);
			SendGameText(any, "\n+ "+(iTime * iOverTimeMult)+" Seconds", 1, 1, -1, 0.0025f, 0, 0.35f, 1.75f, Color(255, 175, 85), Color(0, 0, 0));
		}
	}
}

void TurnFirstInfected()
{
	CSZMPlayer@ pCSZMPlayer;

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

	@pCSZMPlayer = CSZMPlayerArray[iFZIndex];

	if (pCSZMPlayer.IsVolunteer()) 
	{
		pCSZMPlayer.SetVolunteer(false);
	}

	pCSZMPlayer.SetFirstInfected(true);
	pCSZMPlayer.AddInfectDelay(-1);

	ShowOutbreak(iFZIndex);
	TurnToZ(iFZIndex);

	for(int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);

		if (pPlayerEntity is null || pPlayerEntity.GetTeamNumber() != TEAM_LOBBYGUYS)
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

		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(index);
		CZP_Player@ pPlayer = ToZPPlayer(index);
		CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];

		if (pPlayer !is null)
		{
			if (pCSZMPlayer.IsFirstInfected())
			{
				bAllowZombieSpawn = true;
				pSoloMode.SetValue("0");
				Engine.EmitSound("CS_FirstTurn");
				pCSZMPlayer.SetFInfectedState(true);
			}

			EmitBloodEffect(pPlayer, false);
			pCSZMPlayer.SetWeakZombie(false);
			pPlayerEntity.SetModel("models/characters/survivors/eugene.mdl");
			pPlayer.SetVoice(eugene);
			pPlayer.CompleteInfection();
			pPlayer.SetVoice(eugene);
			pPlayer.SetArmModel(MODEL_ZOMBIE_ARMS);
			pCSZMPlayer.SetDefSpeed(SPEED_ZOMBIE);

			RndZModel(pPlayer, pPlayerEntity);
			SetZMHealth(pPlayerEntity);

			Engine.EmitSoundEntity(pPlayerEntity, "CSPlayer.Mute");
			Engine.EmitSoundEntity(pPlayerEntity, "Flesh.HeadshotExplode");
			Engine.EmitSoundEntity(pPlayerEntity, "CSPlayer.Turn");

			if (pCSZMPlayer.IsFirstInfected())
			{
				pPlayer.SetCarrier(true);
			}
		}
	}
}

void RndZModel(CZP_Player@ pPlayer, CBaseEntity@ pPlayerEntity)
{
	Utils.CosmeticWear(pPlayer, "models/cszm/weapons/w_knife_t.mdl");
	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[pPlayerEntity.entindex()];

	int iRNG_ZM_Voice = Math::RandomInt(1, VOICE_MAX_INDEX);

	if (iRNG_ZM_Voice == iPreviousZMVoiceIndex)
	{
		iRNG_ZM_Voice = Math::RandomInt(1, VOICE_MAX_INDEX);
	}

	iPreviousZMVoiceIndex = iRNG_ZM_Voice;
	pCSZMPlayer.SetZMVoice(iRNG_ZM_Voice);
	
	if (pCSZMPlayer.IsFirstInfected())
	{
		pPlayerEntity.SetModel("models/cszm/zombie_corpse2.mdl");
		pPlayerEntity.SetBodyGroup("EyesGlow", 1);
		pPlayerEntity.SetSkin(1);

		AttachEyesLights(pPlayerEntity);
	}
	else 
	{	
		if (pPlayer.IsCarrier())
		{
			pPlayerEntity.SetModel("models/cszm/carrier.mdl");
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

			int iRNG = Math::RandomInt(0, g_strMDLToChoose.length() - 1);

			pPlayerEntity.SetModel(g_strMDLToChoose[iRNG]);
			g_strMDLToChoose.removeAt(iRNG);
		}
	}
}

void SetZMHealth(CBaseEntity@ pPlayerEntity)
{
	int index = pPlayerEntity.entindex();

	CZP_Player@ pPlayer = ToZPPlayer(index);
	CSZMPlayer@ pCSZMPlayer = CSZMPlayerArray[index];
	
	int iHPBonus = pCSZMPlayer.GetHPBonus();
	int iArmor = int(float(pPlayer.GetArmor()) * (CONST_ARMOR_MULT + Math::RandomFloat(0.0f, 1.0f)));

	if (iArmor > 0)
	{
		pPlayer.SetArmor(0);
	}

	if (pCSZMPlayer.IsFirstInfected())
	{
		pPlayerEntity.SetMaxHealth(int(iFirstInfectedHP * 0.785));
		pPlayerEntity.SetHealth(iFirstInfectedHP + iArmor + Math::RandomInt(5, 20));
	}
	else if (pPlayer.IsCarrier())
	{
		int iZombCount = Utils.GetNumPlayers(zombie, false);
		float flAloneMult = 0.5;
		
		switch(iZombCount)
		{
			case 1:
				flAloneMult = 2.175f;
			break;
			
			case 2:
				flAloneMult = 1.05f;
			break;

			case 3:
				flAloneMult = 0.525f;
			break;

			case 12:
				flAloneMult = 0.427f;
			break;
		}

		pPlayerEntity.SetMaxHealth(pPlayerEntity.GetMaxHealth() + int(float(CONST_CARRIER_HP) + (float(iHPBonus) * flAloneMult)));
		pPlayerEntity.SetHealth(pPlayerEntity.GetHealth() + int(float(CONST_CARRIER_HP) + (float(iHPBonus) * flAloneMult)) + iArmor);
	}
	else
	{
		pPlayerEntity.SetMaxHealth(pPlayerEntity.GetMaxHealth() + CONST_ZOMBIE_ADD_HP + iHPBonus);
		pPlayerEntity.SetHealth(int(float(pPlayerEntity.GetHealth()) * 0.95 ) + int(CONST_ZOMBIE_ADD_HP * 0.125) + iHPBonus + iArmor);
	}
}