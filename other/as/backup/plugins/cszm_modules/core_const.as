//Постоянные игрового процесса
//Скорости игрока
const int SPEED_DEFAULT = 225;
const int SPEED_HUMAN = 225;
const int SPEED_ZOMBIE = 198;
const int SPEED_CARRIER = 205;
const int SPEED_WEAK = 215;
const int SPEED_ADRENALINE = 50;

//Damage Slowdown
const float CONST_MAX_SLOWTIME = 2.0f;									//Максимальное время замедления в секундах
const float CONST_SLOWDOWN_TIME = 0.1445f;								//Время замедления, которое получает зомби от любого урона
const float CONST_RECOVER_TIME = 0.115f;								//Время, которое должно пройти, чтобы добавить "CONST_RECOVER_SPEED" к скорости зомби
const int CONST_RECOVER_SPEED = 3;										//Кол-во скорости, которое зомби получает по истечении "CONST_RECOVER_TIME"
const int CONST_SLOWDOWN_HEALTH = 245;									//Кол-во HP, которое нужно нанести зомби, чтобы максимально замедлить его
const float CONST_SLOWDOWN_MULT = 44.81f;   							//Процент максимальной скорости, которая вычитается при замедлении
const float CONST_SLOWDOWN_CRITDMG = 91.0f;								//Значение урона, до которого зомби не будет стопарится

//Другие постоянные
const float CONST_SPAWN_DELAY = 5.0f;									//Время в секундах, которое должны будут ждать все убитые игроки, чтобы снова возродиться
const int CONST_FI_HEALTH_MULT = 135;									//Множитель HP для Первого зараженного (умножается на кол-во игроков)
const int CONST_ZOMBIE_ADD_HP = 200;									//Дополнительные HP для максимального HP обычного зомби. (Zombie's max health + CONST_ZOMBIE_ADD_HP)
const int CONST_WEAK_ZOMBIE_HP = 125;									//Здоровье слабых зомби
const int CONST_CARRIER_HP = 25;										//Дополнительные HP для максимального HP белого зомби.
const int CONST_REWARD_HEALTH = 115;									//Кол-во HP, которое зомби получит при удачном заражении человека.
const int CONST_GEARUP_TIME = 45;										//Время в секундах, через которое превратится Первый зараженный.
const int CONST_TURNING_TIME = 20;										//Время превращения в секундах (Первый зараженный будет видеть обратный отсчёт этого времени).
const int CONST_INFECT_DELAY = 3;										//Кол-во раундов, которое игрок должен ждать(играть за человека), чтобы снова играть за Первого зараженного.
const int CONST_WARMUP_TIME = 3;										//Время разминки в секундах.		(значение по умолчанию - 75)
const float CONST_WEAK_ZOMBIE_TIME = 50.0f;								//Время в секундах после превращения Первого зараженного, на протяжении которого, все вновь присоединившиеся зомби будут спавниться как соабые зомби						
const int CONST_SUBTRACT_DEATH = 1;										//Кол-во смертей, которое будет отниматься за удачное заражение человека
const int CONST_INFECT_ADDTIME = 15;									//Кол-во времени в секундах, которое будет добавлятся к таймеру раунда при удачном заражении чеорвека (если время на таймере меньше чем "CONST_MIN_ROUNDTIMER")
const int CONST_MIN_ROUNDTIMER = 35;									//Минимальное время таймера рауда, при котором разрешено добавлять время за заражение/убийство
const int CONST_DEATH_BONUS_HP = 80;									//Множитель HP, который умножается на счётчик смертей для определения бонусного HP
const int CONST_DEATH_MAX = 12;											//Максималное значение счётчика смертей.
const int CONST_ROUND_TIME = 300;										//Время в секундах отведённое на раунд.
const int CONST_ZOMBIE_LIVES = 32;										//Удерживать Жизни Зомби на этом уровне (Жизни Зомби не используются в CSZM) 
const float CONST_ROUND_TIME_GAME = 300.05;								//Удерживать внутриигровой таймер раунда на этом уровне (внутриигровой таймер раунда не используются в CSZM)
const float CONST_ADRENALINE_DURATION = 14.0f;							//Длительность действия адреналина в секундах
const int CONST_MAX_INFECTRESIST = 2;									//Максимальное сопротивление инфекции (кол-во ударов, которое может пережить выживший)
const float CONST_ARMOR_MULT = 2.0f;									//Множитель для вычисления дополнительного HP для превращенного выжившего, если у него был армор (ExtraHP = iArmor * CONST_ARMOR_MULT)
const float CONST_SHOWDMG_RESET = 1.35f;								//Время в секундах, по истечению которого "ShowDamage" обнуляется
const float CONST_SHOWDMG_WAIT = 0.001f;								//Задержка показа урона
const float CONST_SWIPE_DELAY = 0.5f;
const int CONST_ROUND_TIME_FULL = CONST_ROUND_TIME + CONST_GEARUP_TIME;	//Время в секундах отведённое на раунд (ПОЛНОЕ).

//PROPS
const int PROP_MAX_HEALTH = 1250;										//Максимальное HP для prop'ов
const string EXPLOSIVES_PROP_MODELS = "propanecanister001a.mdl;oildrum001_explosive.mdl;fire_extinguisher.mdl;canister01a.mdl;canister02a.mdl;propane_tank001a.mdl;gascan001a.mdl";
const string JUNK_PROP_MODELS = "vent001.mdl;glassjug01.mdl;glassbottle01a.mdl;plasticcrate01a.mdl;popcan01a.mdl";

//Antidote state
const int AS_UNUSEABLE = 0;
const int AS_USEABLE = 1;

//Zombie outline consts
const float GLOW_BASE_DISTANCE = 1475.0f;
const float GLOW_CARRIER_ADD_DISTANCE = 512.0f;
const float GLOW_CARRIER_ROAR_DISTANCE = 10000.0f;
const float GLOW_WEAK_ADD_DISTANCE = -128.0f;

//ZM Voice related stuff
const int VOICE_MAX_INDEX = 3;
const string VOICE_ZM_PAIN = "CSPlayer_Z.Pain";
const string VOICE_ZM_DIE = "CSPlayer_Z.Die";
const string VOICE_ZM_IDLE = "CSPlayer.Idle";

//CSZM Arms models
const string MODEL_HUMAN_ARMS = "models/cszm/weapons/c_cszm_human_arms.mdl";
const string MODEL_ZOMBIE_ARMS = "models/cszm/weapons/c_cszm_zombie_arms.mdl";

array<string> g_strWeaponToStrip = 
{
	"weapon_baguette",
	"weapon_crowbar",
	"weapon_pot",
	"weapon_spanner",
	"weapon_fryingpan",
	"weapon_pipewrench",
	"weapon_wrench",
	"weapon_racket",
	"weapon_plank",
	"weapon_keyboard",
	"weapon_ppk",
	"weapon_usp",
	"weapon_glock",
	"weapon_snowball",
	"weapon_snowball",
	"weapon_tennisball"
};

array<string> g_strStartWeapons =
{
	"weapon_usp",
	"weapon_glock",
	"weapon_glock18c"
};

const int iStartWeaponLength = int(g_strStartWeapons.length());