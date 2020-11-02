#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"
#include "../SendGameText"

array<array<CSpawnPoint@>> PrimaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(259.547, -114.76, 1.93385), QAngle(0, 0.729034, 0)),
		CSpawnPoint(Vector(294.14, -212.306, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(235.933, -303.819, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(159.715, -232.424, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(144.341, -93.9918, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(206.254, -23.1631, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(308.61, -57.7765, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(307.963, 42.9897, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(195.293, 40.3531, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(202.266, 143.264, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(318.659, 122.068, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(284.793, 217.013, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(151.103, 244.933, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(94.2148, 170.81, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(115.002, 83.4414, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(101.74, -0.659506, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(96.8663, -165.748, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(195.589, -160.433, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(108.878, -294.05, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(282.264, -314.357, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(64.2579, 53.0798, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(41.8497, -44.1998, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(44.1491, -225.881, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(19.8529, -134.068, 0.03125), QAngle(0, 0.725098, 0)),
		CSpawnPoint(Vector(-6.80286, 76.9038, 0.03125), QAngle(0, 0.725098, 0)),

		CSpawnPoint(Vector(-790.015, 271.488, 0.03125), QAngle(-3.70256, -28.4604, 0), "info_player_start"),
		CSpawnPoint(Vector(1251.7, 213.692, 96.0313), QAngle(4.7916, -151.711, 0), "info_player_start"),
		CSpawnPoint(Vector(921.306, -1129.64, 0.03125), QAngle(0, 89.7279, 0), "info_player_start")
	}
};

array<array<CSpawnPoint@>> SecondaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(-763.741, -293.029, 0.03125), QAngle(-1.0164, 6.53305, 0)),
		CSpawnPoint(Vector(-714.146, 24.7035, 0.03125), QAngle(0.471912, -7.40609, 0)),
		CSpawnPoint(Vector(-721.794, 264.074, 0.03125), QAngle(0.0726124, -11.6169, 0)),
		CSpawnPoint(Vector(-541.322, 233.624, 0.03125), QAngle(-1.52459, -6.89788, 0)),
		CSpawnPoint(Vector(-540.67, 5.27567, 0.03125), QAngle(0.108906, 2.39492, 0)),
		CSpawnPoint(Vector(-613.058, -224.64, 0.03125), QAngle(2.9766, -5.26435, 0)),
		CSpawnPoint(Vector(455.125, -397.625, 0.03125), QAngle(-3.77522, 28.1316, 0)),
		CSpawnPoint(Vector(351.35, -374.803, 0.03125), QAngle(4.02927, 19.819, 0)),
		CSpawnPoint(Vector(492.384, 337.148, 0.03125), QAngle(-0.471926, -26.1367, 0)),
		CSpawnPoint(Vector(367.789, 335.458, 0.03125), QAngle(4.10187, -32.7071, 0)),
		CSpawnPoint(Vector(305.708, 331.487, 272.031), QAngle(-0.326764, -29.9847, 0)),
		CSpawnPoint(Vector(16.0235, 320.539, 272.031), QAngle(28.8584, -143.966, 0)),
		CSpawnPoint(Vector(-231.155, 311.456, 272.031), QAngle(11.7248, -14.6656, 0)),
		CSpawnPoint(Vector(-431.876, -399.312, 272.031), QAngle(13.1042, 20.7996, 0)),
		CSpawnPoint(Vector(-156.924, -408.955, 272.031), QAngle(12.959, 39.4579, 0)),
		CSpawnPoint(Vector(398.114, -363.902, 272.031), QAngle(37.4979, 97.4653, -0)),
		CSpawnPoint(Vector(283.25, -161.674, 0.03125), QAngle(1.12533, 3.44823, 0)),
		CSpawnPoint(Vector(279.409, 89.515, 0.03125), QAngle(2.17803, -21.4899, 0)),
		CSpawnPoint(Vector(85.2011, -12.8814, 0.03125), QAngle(6.82443, -0.689943, -0)),
		CSpawnPoint(Vector(627.483, 579.567, 0.03125), QAngle(3.30333, -40.4749, 0)),
		CSpawnPoint(Vector(1202.61, 451.575, 0.03125), QAngle(5.62654, -133.221, 0)),
		CSpawnPoint(Vector(1257.28, 80.688, 0.03125), QAngle(-0.254078, 160.132, 0)),
		CSpawnPoint(Vector(1595.28, 131.542, 0.03125), QAngle(13.7578, -139.332, 0)),
		CSpawnPoint(Vector(1419.97, -130.839, 0.03125), QAngle(1.0528, -150.041, 0)),
		CSpawnPoint(Vector(1515.2, -356.898, 0.03125), QAngle(3.33968, 172.316, 0)),
		CSpawnPoint(Vector(1592.57, -537.584, 8.03125), QAngle(2.94037, 137.141, 0)),
		CSpawnPoint(Vector(1733.42, -208.373, 0.03125), QAngle(5.40875, 177.061, 0)),
		CSpawnPoint(Vector(1225.62, -953.171, 0.03125), QAngle(2.86776, 28.4963, 0)),
		CSpawnPoint(Vector(1249.92, -618.09, 0.03125), QAngle(5.00946, -41.1997, 0)),
		CSpawnPoint(Vector(1247.27, -1500.11, 0.03125), QAngle(3.59376, 131.492, 0)),
		CSpawnPoint(Vector(1239.83, -1349.64, 0.03125), QAngle(2.64996, 135.485, 0)),
		CSpawnPoint(Vector(1144.53, -1483.31, 0.03125), QAngle(4.42865, 114.976, 0)),
		CSpawnPoint(Vector(776.211, -1474.44, 0.03125), QAngle(2.94034, 54.972, -0)),
		CSpawnPoint(Vector(592.031, -1330.2, 0.03125), QAngle(4.13824, 50.4344, 0)),
		CSpawnPoint(Vector(727.66, -1334.49, 0.03125), QAngle(3.30333, 46.6229, 0)),
		CSpawnPoint(Vector(636.031, -655.582, 0.03125), QAngle(3.52113, 40.9511, 0)),
		CSpawnPoint(Vector(854.789, -851.892, 0.03125), QAngle(8.31273, 48.9461, 0)),
		CSpawnPoint(Vector(1243.67, -1195.9, 109.031), QAngle(21.0178, 106.01, 0)),
		CSpawnPoint(Vector(642.297, -990.534, 109.031), QAngle(9.11133, 41.3596, 0)),
		CSpawnPoint(Vector(632.712, -803.869, 109.031), QAngle(13.6851, -11.2028, 0)),
		CSpawnPoint(Vector(632.519, -640.953, 109.031), QAngle(15.2097, -2.38189, 0)),
		CSpawnPoint(Vector(1203.73, 1022.58, 0.28125), QAngle(1.7424, -120.792, 0)),
		CSpawnPoint(Vector(1139.97, 720.9, 0.28125), QAngle(4.86421, 65.1, 0)),
		CSpawnPoint(Vector(729.013, 754.775, 0.03125), QAngle(8.92982, -10.1505, 0)),
		CSpawnPoint(Vector(901.232, 733.206, 0.03125), QAngle(15.5727, 91.3808, 0)),
		CSpawnPoint(Vector(1167.54, 996.5, 160.031), QAngle(7.80453, 163.498, 0)),
		CSpawnPoint(Vector(1180.89, 733.25, 160.031), QAngle(10.5633, 144.138, 0)),
		CSpawnPoint(Vector(1240.12, 1045.47, 362.031), QAngle(17.3152, -116.569, 0)),
		CSpawnPoint(Vector(751.728, 920.63, 336.548), QAngle(16.1535, -76.675, -0)),
		CSpawnPoint(Vector(1173.82, 861.77, 343.515), QAngle(13.685, -98.1643, -0)),
		CSpawnPoint(Vector(853.696, 846.346, 338.575), QAngle(11.1803, -85.9671, 0)),
		CSpawnPoint(Vector(1235.73, 169.33, 128.031), QAngle(44.2497, -156.752, 0)),
		CSpawnPoint(Vector(832.838, -205.367, 128.031), QAngle(33.1056, -33.731, 0)),
		CSpawnPoint(Vector(1026.63, -383.251, 0.03125), QAngle(14.0481, -48.5051, 0)),
		CSpawnPoint(Vector(1716.66, -675.446, 0.03125), QAngle(1.96021, 91.4446, 0)),
		CSpawnPoint(Vector(1513.49, -774.706, 0.131248), QAngle(4.28339, 51.7687, 0)),
		CSpawnPoint(Vector(1540.52, -933.669, 0.03125), QAngle(2.83142, 161.141, 0)),
		CSpawnPoint(Vector(1479.66, -925.525, 136.031), QAngle(21.8889, -14.8054, 0)),
		CSpawnPoint(Vector(1633.88, -913.657, 136.031), QAngle(3.59366, -162.437, 0)),
		CSpawnPoint(Vector(1448.76, -677.954, 136.031), QAngle(22.978, -13.8123, 0)),
		CSpawnPoint(Vector(1723.06, -695.75, 136.031), QAngle(11.2167, 153.24, 0)),
		CSpawnPoint(Vector(1700.11, -428.529, 136.031), QAngle(8.82094, -127.565, 0)),
		CSpawnPoint(Vector(1580.6, -530.156, 136.031), QAngle(30.9277, 138.636, 0)),
		CSpawnPoint(Vector(1534.71, -954.411, 308.031), QAngle(17.2063, 142.327, 0)),
		CSpawnPoint(Vector(1545.37, -738.518, 308.031), QAngle(29.5846, 152.128, 0)),
		CSpawnPoint(Vector(1747.93, -786.615, 308.031), QAngle(24.0306, 148.244, 0)),
		CSpawnPoint(Vector(1739.93, -450.135, 308.031), QAngle(30.7461, 171.876, 0))
	}
};

int CHP(int &in iMulti) 
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);

	if (iSurvNum < 4) 
	{
		iSurvNum = 5;
	}

	iHP = iSurvNum * iMulti;
	
	return iHP;
}

enum ZPS_Teams {TEAM_LOBBYGUYS, TEAM_SURVIVORS = 2, TEAM_ZOMBIES}

int iMaxPlayers;
int iMysticismAttackerIndex = 0;
float flExpBarrelsWaitTime = 0;

array<float> g_TeleportDelay;

array<string> g_BreakName = 
{
	"mysticism",
	"powerbox_small",
	"powerbox_large",
	"Tram-Ceiling",
	"RoofAccess"
};

array<int> g_BreakIndex;

array<Vector> g_CeilingOrigin;
array<QAngle> g_CeilingAngles;
array<string> g_CeilingModel;

array<Vector> g_MadLaughOrigin =
{
	Vector(-323.900269, 279.813934, 377.814850),
	Vector(-59.336475, -334.928619, 314.448883),
	Vector(456.075470, 169.799622, 106.704620),
	Vector(907.733032, -401.066986, 65.747391),
	Vector(1255.201050, -1501.076172, 129.978668),
	Vector(589.242004, -1518.316528, 228.332870),
	Vector(762.574524, -781.900208, 168.850510),
	Vector(1173.709106, -734.399170, 206.043930),
	Vector(1408.999634, -985.120850, 157.446930),
	Vector(1762.769409, -770.424072, 245.177979),
	Vector(1439.726685, -646.239563, 18.549292),
	Vector(1250.507202, -89.147224, 340.220245),
	Vector(1569.919922, -740.280701, 530.952454),
	Vector(1485.243652, 1397.473999, 579.283630),
	Vector(611.066589, 1055.873657, 183.812958),
	Vector(620.445984, 938.652222, 25.580721),
	Vector(1408.424316, 8.112995, 28.450911),
	Vector(1680.077271, -78.585167, 13.082731)
};

array<Vector> g_MExplosionOrigin =
{
	Vector(1325.097290, -184.277893, 33.307758),
	Vector(1011.827515, -473.509094, 25.607576),
	Vector(237.346741, -270.756866, 107.647110),
	Vector(445.926788, 111.564972, 38.406864),
	Vector(-467.867188, 329.295929, 25.406727),
	Vector(-234.909424, -203.461777, 37.532677),
	Vector(828.984375, -224.542496, 153.126038),
	Vector(1004.267151, 316.870239, 40.513008),
	Vector(1194.631348, -571.635010, 43.626965),
	Vector(1210.464233, -1468.295776, 25.819437),
	Vector(761.654358, -1202.981323, 24.974453),
	Vector(1018.534973, -886.281372, 323.325500),
	Vector(790.314209, 226.318451, 201.898056)
};

array<Vector> g_vecActiveOrigin;

array<string> g_FuncBreakName =
{
	"wood",//0
	"glass",//1
	"BalconyGrate",//2
	"UppedBoards",//3
	"mysticism",//4
	"BalconyFloor",//5
	"Tram-Ceiling",//6
	"BalconyFenceSmall",//7
	"RoofAccess",//8
	"powerbox_small",//9
	"powerbox_large",//10
	"HiddenPath",//11
	"Dick-Hook",//12
	"Tram-Stair"//13
};

array<int> g_FuncBreakHP =
{
	64,//0
	1,//1
	84,//2
	3,//3
	42,//4
	24,//5
	41,//6
	35,//7
	43,//8
	17,//9
	32,//10
	20,//11
	25,//12
	21//13
};

array<CExpBarrel@> Array_ExpBarrel;

class CExpBarrel
{
	private int arraypos;
	int entindex;
	private float respawntime;
	private Vector Origin;
	private QAngle Angles;

	CExpBarrel(int nEntIndex, Vector nOrigin, QAngle nAngles)
	{
		arraypos = -1;
		respawntime = 0;
		entindex = nEntIndex;
		Origin = nOrigin;
		Angles = nAngles;
	}

	private void DoRespawn()
	{
		CEntityData@ ExpBarrelIPD = EntityCreator::EntityData();
		ExpBarrelIPD.Add("targetname", "ExpBarrels");
		ExpBarrelIPD.Add("model", "models/props_heavyice/oildrum001_explosive.mdl");
		ExpBarrelIPD.Add("nofiresound", "1");
		ExpBarrelIPD.Add("physicsmode", "1");

		ExpBarrelIPD.Add("AddOutput", "ExplodeDamage 185", true);
		ExpBarrelIPD.Add("AddOutput", "ExplodeRadius 300", true);

		CBaseEntity@ pExpBarrel = EntityCreator::Create("prop_physics_multiplayer", Origin, Angles, ExpBarrelIPD);

		Engine.EmitSoundPosition(pExpBarrel.entindex(), "weapons/crossbow/fire1.wav", Origin + Vector(0, 0, 16), 1.0f, 65, Math::RandomInt(125, 140));

		entindex = pExpBarrel.entindex();
	}

	void Respawn()
	{
		if (entindex != -1)
		{
			entindex = -1;			
			respawntime = Globals.GetCurrentTime() + 25.13f;			
		}
	}

	void Think()
	{
		if (respawntime != 0 && respawntime <= Globals.GetCurrentTime())
		{
			respawntime = 0;
			DoRespawn();
		}
	}
}

CAntidote@ pAntidote;

class CAntidote
{
	int EIndex;
	private Vector Origin;
	private QAngle Angles;

	CAntidote(int nIndex)
	{
		EIndex = nIndex;
		Origin = Vector(832.0f, -224.0f, 149.0f);
		Angles = QAngle(90, 0, 0);
	}

	void Rotate()
	{
		if (FindEntityByEntIndex(EIndex) is null || FindEntityByEntIndex(EIndex).GetOwner() !is null)
		{
			EIndex = -1;
			return;
		}

		Angles += QAngle(0, 2.5f, 0);
		FindEntityByEntIndex(EIndex).Teleport(Origin, Angles, Vector(0, 0, 0));
	}
}

void OnMapInit()
{
	iMaxPlayers = Globals.GetMaxClients();

	Engine.PrecacheFile(sound, "ambient/explosions/explode_1.wav");
	Engine.PrecacheFile(sound, "ambient/explosions/explode_2.wav");
	Engine.PrecacheFile(sound, "ambient/explosions/explode_3.wav");
	Engine.PrecacheFile(sound, "ambient/explosions/explode_4.wav");
	Engine.PrecacheFile(sound, "ambient/explosions/explode_5.wav");
	Engine.PrecacheFile(sound, "ambient/explosions/explode_6.wav");
	Engine.PrecacheFile(sound, "ambient/explosions/explode_7.wav");
	Engine.PrecacheFile(sound, "ambient/explosions/explode_8.wav");
	Engine.PrecacheFile(sound, "@heavyice_ambient/vo/sometimes01.wav");
	Engine.PrecacheFile(sound, "@heavyice_ambient/vo/no01.wav");
	Engine.PrecacheFile(sound, "@heavyice_ambient/vo/no02.wav");
	Engine.PrecacheFile(sound, "npc/fast_zombie/wake1.wav");
	Engine.PrecacheFile(sound, "ambient/levels/labs/electric_explosion1.wav");
	Engine.PrecacheFile(sound, "weapons/crossbow/fire1.wav");
	Engine.PrecacheFile(sound, "heavyice_ambient/vo/hello1.wav");
	Engine.PrecacheFile(sound, "doors/default_stop.wav");
	Engine.PrecacheFile(sound, "doors/default_move.wav");

	Entities::RegisterOutput("OnBreak", "cheese");
	Entities::RegisterOutput("OnBreak", "func_breakable");
	Entities::RegisterOutput("OnBreak", "ExpBarrels");

	Entities::RegisterOutput("OnAwakened", "heavy_props1");
	Entities::RegisterOutput("OnAwakened", "heavy_props2");

	Entities::RegisterUse("teleport_door");

	Events::Trigger::OnEndTouch.Hook(@HI_OnEndTouch);
	Events::Trigger::OnStartTouch.Hook(@HI_OnStartTouch);

	Events::Custom::OnEntityDamaged.Hook(@HI_OnEntDamaged);
	Events::Player::OnPlayerSpawn.Hook(@HI_OnPlrSpawn);

	g_TeleportDelay.resize(iMaxPlayers + 1);
	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchEnded()
{
	Array_ExpBarrel.removeRange(0, Array_ExpBarrel.length());
	g_CeilingAngles.removeRange(0, g_CeilingAngles.length());
	g_CeilingOrigin.removeRange(0, g_CeilingOrigin.length());
	g_CeilingModel.removeRange(0, g_CeilingModel.length());

	@pAntidote is null;
}

void OnMatchBegin()
{
	Schedule::Task(1.00f, "DisableDamageForces");
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SecondaryHumanSpawns, false);
}

void OnProcessRound()
{
	if (pAntidote !is null)
	{
		if (pAntidote.EIndex == -1)
		{
			@pAntidote is null;
		}
		else
		{
			pAntidote.Rotate();
		}
	}

	for (uint b = 0; b < Array_ExpBarrel.length(); b++)
	{
		CExpBarrel@ pBarrel = Array_ExpBarrel[b];

		if (pBarrel !is null)
		{
			pBarrel.Think();
		}
	}

	for (int i = 1; i <= iMaxPlayers; i++)
	{
		CBaseEntity@ pPlayerEntity = FindEntityByEntIndex(i);
		CZP_Player@ pPlayer = ToZPPlayer(i);

		if (pPlayerEntity is null)
		{
			continue;
		}

		if (g_TeleportDelay[i] != 0 && g_TeleportDelay[i] <= Globals.GetCurrentTime())
		{
			g_TeleportDelay[i] = 0;

			if (pPlayerEntity.GetTeamNumber() == TEAM_LOBBYGUYS)
			{
				Utils.ScreenFade(pPlayer, Color(0, 0, 0, 255), 0.175f, 0.01f, fade_in);
				pPlayerEntity.SetMoveType(MOVETYPE_WALK);
				pPlayerEntity.Teleport(Vector(544, -480, 385), QAngle(0, 45, 0), Vector(0, 0, 0));
				Engine.EmitSoundPosition(i, "doors/default_stop.wav", pPlayerEntity.EyePosition(), 1.0f, 60, 105);

				CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

				if (!Utils.StrEql("weapon_snowball", pWeapon.GetClassname()))
				{
					pPlayer.GiveWeapon("weapon_snowball");
				}
			}
		}
	}
}

HookReturnCode HI_OnPlrSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (pBaseEnt.GetTeamNumber() == TEAM_ZOMBIES || pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
	{
		LittleStar(pBaseEnt);
	}

	if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
	{
		PlayLobbyAmbient();
	}

	return HOOK_HANDLED;
}

HookReturnCode HI_OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (pEntity.IsPlayer())
	{
		CZP_Player@ pPlayer = ToZPPlayer(pEntity);

		if (pTrigger.GetAbsOrigin() == Vector(-4792, -1008, -524))
		{	
			if (pPlayer !is null)
			{
				pPlayer.GiveWeapon("weapon_snowball");
				LittleStar(pEntity);
			}
		}

		else if (pTrigger.GetAbsOrigin() == Vector(624, -958, 164) && pEntity.GetTeamNumber() == TEAM_SURVIVORS)
		{	
			pEntity.SetEntityName("BalconyPlr" + pEntity.entindex());
			Engine.Ent_Fire("BalconyPlr" + pEntity.entindex(), "AddOutput", "physdamagescale 0");
		}

		else if (pTrigger.GetAbsOrigin() == Vector(812, 768, 235.5))
		{	
			Engine.EmitSoundPosition(0, "heavyice_ambient/vo/hello1.wav", Vector(812, 810, 251), 1.0f, 75, 100);
			Engine.Ent_Fire("say_hello", "Disable");
			Engine.Ent_Fire("say_hello", "Enable", "0", "25.0");
		}
	}

	return HOOK_HANDLED;
}

HookReturnCode HI_OnEndTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
	if (pEntity.IsPlayer())
	{
		CZP_Player@ pPlayer = ToZPPlayer(pEntity);

		if (pTrigger.GetAbsOrigin() == Vector(624, -958, 164))
		{	
			pEntity.SetEntityName("BalconyPlr" + pEntity.entindex());
			Engine.Ent_Fire("BalconyPlr" + pEntity.entindex(), "AddOutput", "physdamagescale 0.1");
		}
	}

	return HOOK_HANDLED;
}

HookReturnCode HI_OnEntDamaged(CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo)
{
	if (Utils.StrEql(pEntity.GetEntityName(), "bust_junk") && DamageInfo.GetDamage() > 1)
	{
		DamageInfo.SetDamage(0);
		Engine.EmitSoundEntity(pEntity, "HeavyIce.BustPain");
	}

	else if (Utils.StrEql(pEntity.GetEntityName(), "cheese") && DamageInfo.GetDamageType() == (1<<23))
	{
		DamageInfo.SetDamage(25);
		Engine.Ent_Fire("cheese_voice", "PlaySound");
	}

	return HOOK_HANDLED;
}

void OnEntityUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	int iIndex = pBaseEnt.entindex();

	if (Utils.StrEql(pEntity.GetEntityName(), "teleport_door") && g_TeleportDelay[iIndex] == 0)
	{
		Vector Start = pBaseEnt.GetAbsOrigin();
		Vector End;
		Vector Down;

		Globals.AngleVectors(QAngle(90, 0, 0), Down);

		End = Start + Down * 256;

		CGameTrace trace;

		Utils.TraceLine(Start, End, MASK_ALL, pBaseEnt, COLLISION_GROUP_NONE, trace);

		pBaseEnt.Teleport(trace.endpos, pBaseEnt.EyeAngles(), Vector(0, 0, 0));

		pBaseEnt.SetAbsVelocity(Vector(0, 0, 0));
		g_TeleportDelay[iIndex] = Globals.GetCurrentTime() + 1.485f;
		Utils.ScreenFade(pPlayer, Color(0, 0, 0, 255), 1.175f, 0.395f, fade_out);
		pBaseEnt.SetMoveType(MOVETYPE_NONE);
		Engine.EmitSoundPosition(iIndex, "doors/default_move.wav", pBaseEnt.EyePosition(), 1.0f, 60, 105);
	}
}

void OnEntityOutput(const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller)
{
	if (Utils.StrEql(strOutput, "OnBreak"))
	{
		if (Utils.StrEql(pCaller.GetEntityName(), "cheese"))
		{
			Engine.Ent_Fire("cheese_voice", "volume", "0");
			Engine.Ent_Fire("cheese_voice", "kill", "0", "0.05");
			Schedule::Task(0.25f, "CheeseNoNo");
			Schedule::Task(1.9f, "CheeseNooo");
		}

		else if (Utils.StrEql(pCaller.GetEntityName(), "ExpBarrels"))
		{
			uint AEB_Length = Array_ExpBarrel.length();
			
			for (uint i = 0; i < AEB_Length; i++)
			{
				if (Array_ExpBarrel[i] !is null && Array_ExpBarrel[i].entindex == pCaller.entindex())
				{
					Array_ExpBarrel[i].Respawn();
					break;
				}
			}	
		}

		else if (Utils.StrEql(pCaller.GetClassname(), "func_breakable"))
		{
			int ilength = int(g_BreakIndex.length());

			for (int i = 0; i < ilength; i++)
			{
				if (pCaller.entindex() == g_BreakIndex[i])
				{
					if (i == 0 && pActivator.IsPlayer())
					{
						g_BreakIndex[i] = 0;
						Mysticism(pActivator);

						break;
					}

					if (i == 1)
					{
						g_BreakIndex[i] = 0;
						PowerBoxExplode(pCaller.GetAbsOrigin());
						Engine.Ent_Fire("ho1_light", "FadeToPattern", "a");
						Engine.EmitSoundPosition(0, "ambient/levels/labs/electric_explosion1.wav", Vector(1761.4, -790.36, 256), 1.0f, 135, Math::RandomInt(90, 125));

						break;
					}

					if (i == 2)
					{
						g_BreakIndex[i] = 0;
						PowerBoxExplode(pCaller.GetAbsOrigin());

						if (g_BreakIndex[0] != 0)
						{
							Engine.Ent_Fire("ho2_light", "FadeToPattern", "a");
							Engine.Ent_Fire("securitybutton1", "kill");
							Engine.Ent_Fire("securitybutton_prop1", "skin", "1");
							Engine.Ent_Fire("powerbox_shake", "powerbox_shake");
						}

						break;
					}

					if (i == 3)
					{
						g_BreakIndex[i] = 0;
						SpawnCeilingEnts();

						break;
					}

					if (i == 4)
					{
						g_BreakIndex[i] = 0;
						Engine.EmitSoundPosition(0, "npc/fast_zombie/wake1.wav", Vector(630, 808, 309), 1.0f, 75, 100);

						break;
					}
				}
			}
		}
	}

	else if (Utils.StrEql(strOutput, "OnAwakened"))
	{
		if (Utils.StrContains("heavy_props", pCaller.GetModelName()))
		{
			Engine.Ent_Fire(pCaller.GetEntityName(), "Wake");
		}
	}
}

void LittleStar(CBaseEntity@ pPlayerEntity)
{
	float flRNG = Math::RandomFloat(0, 100);
	int iIndex = pPlayerEntity.entindex();

	if (flRNG < 2.147f)
	{
		pPlayerEntity.SetEntityName("plr_ littlestar" + iIndex);
		Engine.Ent_Fire("plr_ littlestar" + iIndex, "SetLightingOrigin", "littlestar_lighting");
	}
}

void DisableDamageForces()
{
	Engine.Ent_Fire("item*", "DisableDamageForces", "1");
	Engine.Ent_Fire("weapon*", "DisableDamageForces", "1");
}

void SetUpStuff()
{
	int ilength = int(g_MExplosionOrigin.length());

	iMysticismAttackerIndex = 0;

	flExpBarrelsWaitTime = Globals.GetCurrentTime() + 0.1f;
	
	Engine.Ent_Fire("Precache", "kill", "", "0");
	Engine.Ent_Fire("vrad_shadows", "kill", "", "0");
	Engine.Ent_Fire("_td", "kill", "", "0");
	Engine.Ent_Fire("temp_expbarrel*", "ForceSpawn", "", "0");
	Engine.Ent_Fire("trigger_lobby_*", "Disable", "", "0");
	Engine.Ent_Fire("shading", "StartOverlays", "", "0");

	Engine.Ent_Fire("ld_doors", "Open", "", "0");
	Engine.Ent_Fire("dr_vodker", "Disable", "", "0");
	Engine.Ent_Fire("hi_greenhouse", "Enable", "", "0");
	Engine.Ent_Fire("hi_greenhouse_nm", "Disable", "", "0");
	Engine.Ent_Fire("KD-Core", "Open", "", "0");
	Engine.Ent_Fire("sky_light1", "FadeToPattern", "f", "0");
	Engine.Ent_Fire("Tram-Stair*", "AddOutput", "targetname Tram-Stair", "0");
	Engine.Ent_Fire("hooks_special*", "AddOutput", "spawnflags 1024", "0");

	Engine.Ent_Fire("watermelon_junk", "SetLightingOrigin", "", "10");
	Engine.Ent_Fire("watermelon_junk", "SetLightingOrigin", "armor_lighting", "0");

	Engine.Ent_Fire("BalconyFloor", "AddOutput", "health 1750", "0");
	Engine.Ent_Fire("Tram-Beams", "SetDamageFilter", "GodMode", "0");
	Engine.Ent_Fire("wdoor*", "SetDamageFilter", "GodMode", "0");
	Engine.Ent_Fire("wdoor*", "AddOutput", "dmg 50", "0");

	Engine.Ent_Fire("bh_tv", "AddOutput", "health 875", "0");
	Engine.Ent_Fire("gh_tv", "AddOutput", "health 875", "0");

	Engine.Ent_Fire("iantidote*", "AddOutput", "targetname item_antidote", "1.75");

	SpawnCheese();

	switch(Math::RandomInt(1, 3))
	{
		case 1: Engine.Ent_Fire("trigger_lobby_knockknock", "Enable", "", "0"); break;
		case 2: Engine.Ent_Fire("trigger_lobby_raul", "Enable", "", "0"); break;	
		case 3: Engine.Ent_Fire("trigger_lobby_deepcover", "Enable", "", "0"); break;
	}

	g_vecActiveOrigin.removeRange(0, g_vecActiveOrigin.length());

	for (int i = 0; i < ilength; i++)
	{
		g_vecActiveOrigin.insertLast(g_MExplosionOrigin[i]);
	}

	FindBreakIndexes();
	FindCeilingEnts();
	FindExpBarrels();
	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_human");
	RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(PrimaryHumanSpawns, true);
	FindAntidote();
}

void FindAntidote()
{
	CBaseEntity@ pAntidoteEntity = FindEntityByClassname(null, "item_deliver");

	if (pAntidoteEntity !is null)
	{
		@pAntidote = CAntidote(pAntidoteEntity.entindex());
	}
}

void FindExpBarrels()
{
	CBaseEntity@ pBarrel = null;
	while ((@pBarrel = FindEntityByName(pBarrel, "ExpBarrels")) !is null)
	{
		Array_ExpBarrel.insertLast(CExpBarrel(pBarrel.entindex(), pBarrel.GetAbsOrigin(), pBarrel.GetAbsAngles()));
		Engine.Ent_Fire_Ent(pBarrel, "AddOutput", "ExplodeDamage 185");
		Engine.Ent_Fire_Ent(pBarrel, "AddOutput", "ExplodeRadius 300");
	}
}

void FindBreakIndexes()
{
	int ilength = int(g_BreakName.length());
	g_BreakIndex.resize(g_BreakName.length());

	for (int i = 0; i < ilength; i++)
	{
		CBaseEntity@ pEntity;
		@pEntity = FindEntityByName(pEntity, g_BreakName[i]);

		if (pEntity is null)
		{
			continue;
		}

		if (Utils.StrEql(pEntity.GetEntityName(), g_BreakName[i]))
		{
			g_BreakIndex[i] = pEntity.entindex();
		}
	}
}

void FindCeilingEnts()
{
	CBaseEntity@ pEntity;

	while ((@pEntity = FindEntityByName(pEntity, "CeilingProps")) !is null)
	{
		g_CeilingAngles.insertLast(pEntity.GetAbsAngles());
		g_CeilingOrigin.insertLast(pEntity.GetAbsOrigin());
		g_CeilingModel.insertLast(pEntity.GetModelName());
		pEntity.SUB_Remove();
	}

	while ((@pEntity = FindEntityByName(pEntity, "CeilingWeapons")) !is null)
	{
		g_CeilingAngles.insertLast(pEntity.GetAbsAngles());
		g_CeilingOrigin.insertLast(pEntity.GetAbsOrigin());
		g_CeilingModel.insertLast(pEntity.GetClassname());
		pEntity.SUB_Remove();
	}
}

void PowerBoxExplode(Vector &in Origin)
{
	CEntityData@ SparksIPD = EntityCreator::EntityData();
	SparksIPD.Add("spawnflags", "0");
	SparksIPD.Add("Magnitude", "8");
	SparksIPD.Add("TrailLength", "3");
	SparksIPD.Add("SparkOnce", "0", true);
	SparksIPD.Add("kill", "0", true, "0.50");

	CEntityData@ ExplodeIPD = EntityCreator::EntityData();
	ExplodeIPD.Add("spawnflags", "1");
	ExplodeIPD.Add("iMagnitude", "5");
	ExplodeIPD.Add("Explode", "0", true);

	EntityCreator::Create("env_spark", Origin, QAngle(0, 0, 0), SparksIPD);
	EntityCreator::Create("env_explosion", Origin, QAngle(0, 0, 0), ExplodeIPD);

	Engine.EmitSoundPosition(0, "ambient/levels/labs/electric_explosion1.wav", Origin, 1.0f, 135, Math::RandomInt(90, 125));
}

void SpawnCeilingEnts()
{
	int ilength = int(g_CeilingModel.length());

	for (int i = 0; i < ilength; i++)
	{
		if (Utils.StrContains("weapon_", g_CeilingModel[i]))
		{
			EntityCreator::Create(g_CeilingModel[i], g_CeilingOrigin[i], g_CeilingAngles[i]);
		}

		else
		{
			CEntityData@ PropIPD = EntityCreator::EntityData();
			PropIPD.Add("damagefilter", "filter_no_human");
			PropIPD.Add("overridescript", "mass,500,");
			PropIPD.Add("targetname", "CeilingProps");
			PropIPD.Add("Damagetype", "1");
			PropIPD.Add("model", g_CeilingModel[i]);

			CBaseEntity@ pProp = EntityCreator::Create("prop_physics", g_CeilingOrigin[i], g_CeilingAngles[i], PropIPD);
		}
	}

	Engine.Ent_Fire("BalconyTrigger", "Disable", "0", "1.74");
	Engine.Ent_Fire("BalconyTrigger", "kill", "0", "1.83");
}

void SpawnCheese()
{
	Vector NewOrigin = Vector(680, 688, 165.25);

	CEntityData@ CheeseIPD = EntityCreator::EntityData();
	CheeseIPD.Add("targetname", "cheese");
	CheeseIPD.Add("model", "models/props_heavyice/cheese.mdl");
	CheeseIPD.Add("overridescript", "surfaceprop,watermelon,");
	CheeseIPD.Add("puntsound", "Flesh_Zombie.BulletImpact");
	CheeseIPD.Add("spawnflags", "256");

	CEntityData@ CheeseVoiceIPD = EntityCreator::EntityData();
	CheeseVoiceIPD.Add("targetname", "cheese_voice");
	CheeseVoiceIPD.Add("message", "@heavyice_ambient/vo/sometimes01.wav");
	CheeseVoiceIPD.Add("pitch", "75");
	CheeseVoiceIPD.Add("pitchstart", "75");
	CheeseVoiceIPD.Add("spawnflags", "49");
	CheeseVoiceIPD.Add("health", "10");
	CheeseVoiceIPD.Add("radius", "1024");

	CBaseEntity@ pCheese = EntityCreator::Create("prop_physics_multiplayer", NewOrigin, QAngle(0, 66, 0), CheeseIPD);
	CBaseEntity@ pCheeseVoice = EntityCreator::Create("ambient_generic", NewOrigin, QAngle(0, 0, 0), CheeseVoiceIPD);

	pCheese.SetMaxHealth(256);
	pCheese.SetHealth(256);
}

void CheeseNoNo()
{
	Engine.EmitSoundPosition(0, "@heavyice_ambient/vo/no01.wav", Vector(0, 0, 0), 1.0f, 0, 95);
	SendGameText(any, "The Cheese . . . .", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.0f, 10.0f, Color(255, 0, 0), Color(0, 0, 0));
}

void CheeseNooo()
{
	Engine.EmitSoundPosition(0, "@heavyice_ambient/vo/no02.wav", Vector(0, 0, 0), 1.0f, 0, 95);
	SendGameText(any, "The Cheese . . . .\nAre broken!!!", 2, 0.0f, 0.3f, 0.75f, 0.0f, 0.45f, 2.24f, Color(255, 0, 0), Color(0, 0, 0));
}

void Mysticism(CBaseEntity@ pActivator)
{
	CZP_Player@ pPlayer = ToZPPlayer(pActivator);

	iMysticismAttackerIndex = pActivator.entindex();
	
	Utils.ScreenFade(pPlayer, Color(255, 0, 0, 150), 0.5f, 0.0f, fade_in);

	Engine.EmitSoundPlayer(pPlayer, "npc/stalker/go_alert2a.wav");
	
	Engine.Ent_Fire("ho2_light", "FadeToPattern", "a");
	Engine.Ent_Fire("mysticism_fireligth", "FadeToPattern", "a");
	Engine.Ent_Fire("hi_greenhouse_nm", "FireUser1");
	Engine.Ent_Fire("hi_greenhouse", "FireUser1");
	Engine.Ent_Fire("mysticism_shake", "StartShake");
	Engine.Ent_Fire("fire_small", "stop");
	Engine.Ent_Fire("mysticism_blood", "EmitBlood");
	Engine.Ent_Fire("ho2_light", "FadeToPattern", "z");
	Engine.Ent_Fire("ho2_light", "FadeToPattern", "vgdbertywbhtrjuynrtikjgpvjedbndbzhgdgqbedfvhtyfbfntjdsghfebhrewerttryhtrd", "2.00");
	Engine.Ent_Fire("mysticism_light1", "TurnOn", "0", "2.00");

	MysticismSpawnExplosion();
	MadLaugh();
}

void MysticismSpawnExplosion()
{
	if (g_vecActiveOrigin.length() > 0)
	{
		Schedule::Task(0.4f, "MysticismSpawnExplosion");

		int iRNG = Math::RandomInt(0, g_vecActiveOrigin.length() - 1);

		CEntityData@ ExplosionIPD = EntityCreator::EntityData();
		ExplosionIPD.Add("iMagnitude", "150");
		ExplosionIPD.Add("spawnflags", "80");
		ExplosionIPD.Add("Explode", "0", true);

		CBaseEntity@ pExplosion = EntityCreator::Create("env_explosion", g_vecActiveOrigin[iRNG], QAngle(0, 0, 0), ExplosionIPD);
		Engine.EmitSoundPosition(0, "ambient/explosions/explode_" + Math::RandomInt(1, 9) + ".wav", g_MExplosionOrigin[iRNG], 1.0f, 145, Math::RandomInt(95, 105));

		CBaseEntity@ pActivator = FindEntityByEntIndex(iMysticismAttackerIndex);

		if (pActivator !is null)
		{
			pExplosion.SetOwner(pActivator);
		}

		g_vecActiveOrigin.removeAt(iRNG);
	}

	else
	{
		iMysticismAttackerIndex = 0;
	}

	Engine.Ent_Fire("mysticism_blood", "EmitBlood");
}

void MadLaugh()
{
	int ilength = int(g_MadLaughOrigin.length());

	for (int i = 0; i < ilength; i++)
	{
		CEntityData@ MadLaughIPD = EntityCreator::EntityData();
		MadLaughIPD.Add("targetname", "MadLaugh_SND");
		MadLaughIPD.Add("message", "heavyice_ambient/vo/madlaugh03.wav");
		MadLaughIPD.Add("pitch", "80");
		MadLaughIPD.Add("pitchstart", "80");
		MadLaughIPD.Add("spawnflags", "0");
		MadLaughIPD.Add("health", "5");
		MadLaughIPD.Add("radius", "9000");

		CBaseEntity@ pMadLaugh = EntityCreator::Create("ambient_generic", g_MadLaughOrigin[i], QAngle(0, 0, 0), MadLaughIPD);
	}

	Engine.Ent_Fire("MadLaugh_SND", "Kill", "0", "7.14");
}