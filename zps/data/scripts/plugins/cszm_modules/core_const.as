//GamePlay Consts and Variables
//Player Speed
const int SPEED_DEFAULT = 225;
const int SPEED_HUMAN = 212; 
const int SPEED_ZOMBIE = 185;
const int SPEED_CARRIER = 204;
const int SPEED_WEAK = 231;
const int SPEED_ADRENALINE = 75;
const int SPEED_MINIMUM = 80;

//Damage Slowdown
const float CONST_MAX_SLOWTIME = 2.0f;	//Maximum amount of seconds a zombie could be slowed down
const float CONST_RECOVER_UNIT = 0.101f;	//Speed recovery tick time
const int CONST_RECOVER_SPEED = 3;	//Amout of speed to recover per tick
const float CONST_SLOWDOWN_TIME = 0.2f;	//Amount of time zombie being slowed down (any damage)

//Other Consts
const float CONST_SPAWN_DELAY = 5.0f;	//Zombies spawn delay.
const int CONST_FI_HEALTH_MULT = 125;	//HP multiplier of first infected.
const int CONST_ZOMBIE_ADD_HP = 200;	//Additional HP to Max Health of a zombie.
const int CONST_WEAK_ZOMBIE_HP = 125;	//Health of the weak zombies
const int CONST_CARRIER_HP = 0;	//Additional HP to Max Health of the carrier.	(Currently equal 0 because the carrier is too OP)
const int CONST_REWARD_HEALTH = 125;	//Give that amount of HP as reward of successful infection.
const int CONST_GEARUP_TIME = 40;	//Time to gear up and find a good spot.
const int CONST_TURNING_TIME = 20;	//Turning time.
const int CONST_INFECT_DELAY = 2;	//Amount of rounds you have to wait to be the First Infected again.
const int CONST_WARMUP_TIME = 10;	//Time of the warmup in seconds.		(default value is 75)
const float CONST_WEAK_ZOMBIE_TIME = 45.0f;								
const int CONST_SUBTRACT_DEATH = 1;	//Amount of units subtract from the death counter
const int CONST_INFECT_ADDTIME = 15;	//Amount of time in seconds add to the round time in case of successful infection
const int CONST_DEATH_BONUS_HP = 75;	//Multiplier of death hp bonus.
const int CONST_DEATH_MAX = 8;	//Maximum amount of death to boost up the max health.
const int CONST_ROUND_TIME = 300;	//Round time in seconds.
const int CONST_ROUND_TIME_FULL = CONST_ROUND_TIME + CONST_GEARUP_TIME;	//Round time in seconds.
const int CONST_ZOMBIE_LIVES = 32;	//Hold Zombie Lives at this level (Zombie Lives unused in CSZM) 
const float CONST_ROUND_TIME_GAME = 300;	//Hold IN-Game Round timer at this level (IN-Game Round timer unused in CSZM)
const float CONST_SLOWDOWN_MULT = 40;	//Old value - 36.0f
const float CONST_SLOWDOWN_WEAKMULT = 30;
const float CONST_SLOWDOWN_CRITDMG = 68.0f;
const float CONST_ADRENALINE_DURATION = 12.0f;
const int CONST_MAX_INFECTRESIST = 2;
const float CONST_ARMOR_MULT = 2.0f;

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
const string MODEL_ZOMBIE_ARMS = "models/cszm/weapons/c_cszm_zombie_arms.mdl";
const string MODEL_HUMAN_ARMS = "models/cszm/weapons/c_cszm_arms.mdl";