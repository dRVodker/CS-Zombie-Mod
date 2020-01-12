//Постоянные игрового процесса
//Скорости игрока
const int SPEED_DEFAULT = 225;
const int SPEED_HUMAN = 205;
const int SPEED_ZOMBIE = 190;
const int SPEED_CARRIER = 200;
const int SPEED_WEAK = 230;
const int SPEED_ADRENALINE = 70;
const int SPEED_MINIMUM = 80;

//Damage Slowdown
const float CONST_MAX_SLOWTIME = 2.0f;	//Максимальное время в секундах, которое зомби может быть замедлен
const float CONST_RECOVER_UNIT = 0.12f;	//Кол-во времени, которое должно пройти, чтобы добавить "CONST_RECOVER_SPEED" к скорости зомби
const int CONST_RECOVER_SPEED = 3;	//Кол-во скорости, которое зомби получает по истечении "CONST_RECOVER_UNIT"
const float CONST_SLOWDOWN_TIME = 0.1425f;	//Время замедления, которое получает зомби при получении любого урона
const int CONST_SLOWDOWN_HEALTH = 250;  //Кол-во HP, которое нужно нанести зомби, чтобы максимально замедлить его
const float CONST_SLOWDOWN_MULT = 38.38f;    //Процент от максимальной скорости зомби, который будет ониматься при получении урона равному "CONST_SLOWDOWN_HEALTH"
const float CONST_SLOWDOWN_CRITDMG = 68.0f; //Значение урона, до которого зомби не будет стопарится

//Другие постоянные
const float CONST_SPAWN_DELAY = 5.0f;	//Время в секундах, которое должны будут ждать все погибшие игроки, чтобы снова возродиться
const int CONST_FI_HEALTH_MULT = 125;	//Множитель HP для Первого зараженного (умножается на кол-во игроков)
const int CONST_ZOMBIE_ADD_HP = 200;	//Дополнительные HP для максимального HP обычного зомби. (Zombie's max health + CONST_ZOMBIE_ADD_HP)
const int CONST_WEAK_ZOMBIE_HP = 135;	//Здоровье слабых зомби
const int CONST_CARRIER_HP = 0;	//Дополнительные HP для максимального HP белого зомби.
const int CONST_REWARD_HEALTH = 125;	//Кол-во HP, которое зомби получит при удачном человека.
const int CONST_GEARUP_TIME = 45;	//Время, через которое превратится Первый зараженный.
const int CONST_TURNING_TIME = 20;	//Время превращения (Первый зараженный будет видеть обратный отсчёт этого времени).
const int CONST_INFECT_DELAY = 2;	//Кол-во раундов, которое игрок должен ждать(играть за человека), чтобы снова зайти как Первый зараженный.
const int CONST_WARMUP_TIME = 10;	//Время разминки в секундах.		(значение по умолчанию - 75)
const float CONST_WEAK_ZOMBIE_TIME = 50.0f;		//Время в секундах после превращения Первого зараженного, на протяжении которого, все вновь присоединившиеся зомби будут спавниться как соабые зомби						
const int CONST_SUBTRACT_DEATH = 1;	//Кол-во смертей, которое будет отниматься за удачное заражение человека
const int CONST_INFECT_ADDTIME = 15;	//Кол-во времени в секундах, которое будет добавлятся к таймеру раунда при удачном заражении чеорвека (если время на таймере меньше чем "CONST_MIN_ROUNDTIMER")
const int CONST_MIN_ROUNDTIMER = 35;    //Минимальное время таймера рауда, при котором разрешено добавлять время за заражение
const int CONST_DEATH_BONUS_HP = 75;	//Множитель HP, который умноается на счётчик смертей для определения бонусного HP
const int CONST_DEATH_MAX = 8;	//Максималное значение счётчика смертей.
const int CONST_ROUND_TIME = 300;	//Время в секундах отведённое на раунд.
const int CONST_ROUND_TIME_FULL = CONST_ROUND_TIME + CONST_GEARUP_TIME;	//Время в секундах отведённое на раунд (ПОЛНОЕ).
const int CONST_ZOMBIE_LIVES = 32;	//Удерживать Зижни Зомби на этом уровне (Зижни Зомби не используются в CSZM) 
const float CONST_ROUND_TIME_GAME = 300.05;	//Удерживать внутриигровой таймер раунда на этом уровне (внутриигровой таймер раунда не используются в CSZM)
const float CONST_ADRENALINE_DURATION = 12.0f;  //Длительность действия адреналина в секундах
const int CONST_MAX_INFECTRESIST = 2;   //Максимальное сопротивление инфекции
const float CONST_ARMOR_MULT = 2.0f;
const float CONST_SHOWDMG_RESET = 1.35f;    //Время в секундах, по истечению которого ShowDamage обнуляется
const float CONST_SHOWDMG_WAIT = 0.001f;    //Задержка показа урона

//PROPS
const int PROP_MAX_HEALTH = 1250;

//Antidote state
const int ANTIDOTE_STATE_UNUSEABLE = 0;
const int ANTIDOTE_STATE_USEABLE = 1;

//Zombie outline consts
const float GLOW_BASE_DISTANCE = 1684.0f;
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