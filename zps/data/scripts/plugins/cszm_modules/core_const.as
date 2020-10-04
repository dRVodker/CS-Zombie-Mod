//Постоянные игрового процесса
//Скорости движения игрока
const int SPEED_DEFAULT = 240;		//225
const int SPEED_HUMAN = 220;		//225
const int SPEED_ZOMBIE = 200;		//213
const int SPEED_CARRIER = 225;		//220
const int SPEED_ADRENALINE = 75;	//50

//Другие постоянные
const float CONST_SPAWN_DELAY = 5.1f;			//Время в секундах, которое должны будут ждать все убитые игроки, чтобы снова возродиться
const int CONST_REWARD_HEALTH = 125;			//Кол-во HP, которое зомби получит при удачном заражении человека.
const int CONST_INFECT_ADDTIME = 15;			//Кол-во времени в секундах, которое будет добавлятся к таймеру раунда при удачном заражении чеорвека (если время на таймере меньше чем "CONST_MIN_ROUNDTIMER")
const int CONST_ZOMBIE_LIVES = 0;				//Удерживать Жизни Зомби на этом уровне (Жизни Зомби не используются в CSZM) 
const int CONST_MAX_INFECTRESIST = 2;			//Максимальное сопротивление инфекции (кол-во ударов, которое может пережить выживший)
const float CONST_ADRENALINE_DURATION = 14.0f;	//Длительность действия адреналина в секундах
const float CONST_ARMOR_MULT = 3.15f;			//Множитель для вычисления дополнительного HP для превращенного выжившего, если у него был армор (ExtraHP = iArmor * CONST_ARMOR_MULT)
const float CONST_SWIPE_DELAY = 0.5f;			//Задержка чтоб предотвратить заражение более одного выжившего одним ударом
const float CONST_GAME_ROUND_TIME = 300.05;		//Удерживать внутриигровой таймер раунда на этом уровне (внутриигровой таймер раунда не используются в CSZM)
const int CONST_MIN_ROUNDTIMER = 35;			//Минимальное время таймера рауда, при котором разрешено добавлять время за заражение/убийство

enum AntidoteStates {AS_UNUSEABLE, AS_USEABLE}

//Пропы
const int PROP_MAX_HEALTH = 450;	//1250		//Максимальное HP для prop'ов
const int BRUSH_MAX_HEALTH = 500;				//Максимальное HP для брашей
const string EXPLOSIVES_PROP_MODELS = "propanecanister001a.mdl;oildrum001_explosive.mdl;fire_extinguisher.mdl;canister01a.mdl;canister02a.mdl;propane_tank001a.mdl;gascan001a.mdl";
const string JUNK_PROP_MODELS = "vent001.mdl;glassjug01.mdl;glassbottle01a.mdl;plasticcrate01a.mdl;popcan01a.mdl";

//Обводка зомби
const float GLOW_BASE_DISTANCE = 1415.0f;

//Голоса зомби
const int VOICE_MAX_INDEX = 3;
const string VOICE_ZM_PAIN = "CSPlayer.Pain";
const string VOICE_ZM_DIE = "CSPlayer.Die";
const string VOICE_ZM_IDLE = "CSPlayer.Idle";

//Некоторые модели
const string MODEL_HUMAN_ARMS = "models/weapons/arms/c_eugene.mdl";
const string MODEL_ZOMBIE_ARMS = "models/weapons/arms/c_carrier.mdl";
const string MODEL_KNIFE = "models/cszm/weapons/w_knife_t.mdl";
const string MODEL_PLAYER_CARRIER = "models/cszm/carrier.mdl";
const string MODEL_PLAYER_LOBBYGUY = "models/cszm/lobby_guy.mdl";
const string MODEL_PLAYER_CORPSE2 = "models/cszm/zombie_corpse2.mdl";

//Ентити, которым нужно установить HP
const array<string> g_strBreakableEntities =
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

//Список моделей, которые используются для зомби
const array<string> g_strModels = 
{
	"models/cszm/zombie_classic.mdl",
	"models/cszm/zombie_sci.mdl",
	"models/cszm/zombie_corpse1.mdl",
	"models/cszm/zombie_charple2.mdl",
	"models/cszm/zombie_charple1.mdl",
	"models/cszm/zombie_sawyer.mdl",
	"models/cszm/zombie_bald.mdl",
	"models/cszm/zombie_eugene.mdl"
};

array<string> g_strMDLToChoose;

const array<string> g_strBloodSND =
{
	")gibs/flesh_arm-01.wav",
	")gibs/flesh_arm-02.wav",
	")gibs/flesh_arm-03.wav",
	")gibs/flesh_arm-04.wav",
	")gibs/flesh_head-01.wav",
	")gibs/flesh_head-02.wav",
	")gibs/flesh_head-03.wav"
};

const array<string> g_strInfectSND =
{
	")cszm_fx/player/plr_infect1.wav",
	")cszm_fx/player/plr_infect2.wav",
	")cszm_fx/player/plr_infect3.wav"
};

const array<string> g_LocknLoadSND =
{
	"@cszm_fx/radio/gogogo.wav",
	"@cszm_fx/radio/letsgo.wav",
	"@cszm_fx/radio/locknload.wav",
	"@cszm_fx/radio/moveout.wav"
};

const array<string> g_strWeaponToStrip = 
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
	"weapon_tennisball"
};

array<string> g_strStartWeapons =
{
	"weapon_usp",
	"weapon_glock",
	"weapon_glock18c"
};

const int iStartWeaponLength = int(g_strStartWeapons.length());