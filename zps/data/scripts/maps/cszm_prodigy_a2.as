#include "cszm_modules/newspawn"
#include "cszm_modules/cashmaker"

array<array<CSpawnPoint@>> PrimarySpawns =
{
	{
		CSpawnPoint(Vector(1781, 835, -375), QAngle(0, 30, 0)),
		CSpawnPoint(Vector(1533, -1229, -472), QAngle(0, 300, 0)),
		CSpawnPoint(Vector(2105, -1561, -472), QAngle(0, 165, 0)),
		CSpawnPoint(Vector(885, -1581, -392), QAngle(0, 30, 0)),
		CSpawnPoint(Vector(1503, -1410, -472), QAngle(0, 315, 0)),
		CSpawnPoint(Vector(1949, 442, -375), QAngle(0, 30, 0)),
		CSpawnPoint(Vector(2520, 484, -376), QAngle(0, 150, 0)),
		CSpawnPoint(Vector(669, 35, -248), QAngle(0, 135, 0)),
		CSpawnPoint(Vector(3114, -763, -472), QAngle(0, 45, 0)),
		CSpawnPoint(Vector(3031, -12, -472), QAngle(0, 345, 0)),
		CSpawnPoint(Vector(3297, 89, -472), QAngle(0, 240, 0)),
		CSpawnPoint(Vector(3321, -763.231, -472), QAngle(0, 135, 0)),
		CSpawnPoint(Vector(182.681, -786, -190), QAngle(0, 75, 0)),
		CSpawnPoint(Vector(-110, -319, -198), QAngle(0, 315, 0)),
		CSpawnPoint(Vector(599, -175, -285), QAngle(0, 225, 0)),
		CSpawnPoint(Vector(551, -925, -392), QAngle(0, 60, 0)),
		CSpawnPoint(Vector(373, 271, -288), QAngle(0, 60, 0)),
		CSpawnPoint(Vector(615, 731, -288), QAngle(0, 225, 0)),
		CSpawnPoint(Vector(99, 773, -288), QAngle(0, 315, 0)),
		CSpawnPoint(Vector(1464, -826, -279), QAngle(0, 315, 0)),
		CSpawnPoint(Vector(1790, -1108, -279), QAngle(0, 150, 0)),
		CSpawnPoint(Vector(1280, -1233, -279), QAngle(0, 59.9999, 0)),
		CSpawnPoint(Vector(1304, -642, -368), QAngle(0, 315, 0)),
		CSpawnPoint(Vector(2462, 996, -375), QAngle(0, 225, 0)),

		CSpawnPoint(Vector(2024, -752, -478), QAngle(0, 90, 0), "info_player_start"),
		CSpawnPoint(Vector(3328, -272, -479), QAngle(0, 270, 0), "info_player_start"),
		CSpawnPoint(Vector(816, -1280, -399), QAngle(0, 0, 0), "info_player_start")
	}
};

array<array<CSpawnPoint@>> SecondarySpawns =
{
	{
		CSpawnPoint(Vector(1115, 546, -248), QAngle(0, 165, 0)),
		CSpawnPoint(Vector(-5, 259, -287), QAngle(0, 45, 0)),
		CSpawnPoint(Vector(1781, 414, -376), QAngle(0, 0, 0)),
		CSpawnPoint(Vector(2524, 1015, -376), QAngle(0, 210, 0)),
		CSpawnPoint(Vector(29, 163, -248), QAngle(0, 315, 0)),
		CSpawnPoint(Vector(547, -927, -391), QAngle(0, 45, 0)),
		CSpawnPoint(Vector(2146, -989, -472), QAngle(0, 180, 0)),
		CSpawnPoint(Vector(3319, -403, -472), QAngle(0, 210, 0))
	}
};

void OnMapInit()
{
	CashDATA();
	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void SetUpStuff()
{
	//RemoveNativeSpawns("info_player_human");
	//RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(PrimarySpawns, true);

	Engine.Ent_Fire("tonemap", "SetAutoExposureMax", "1.05", "0");
	Engine.Ent_Fire("tonemap", "SetAutoExposureMin", "0.45", "0");
	Engine.Ent_Fire("tonemap", "SetBloomScale", "0.7", "0");

	ColorCorrection();
	ShadowControl();
	KillSprite();
}

void ShadowControl()
{
	CBaseEntity@ pShadow = FindEntityByClassname(null, "shadow_control");
	if (pShadow !is null)
	{
		Engine.Ent_Fire_Ent(pShadow, "Disable", "0", "0.00");
		Engine.Ent_Fire_Ent(pShadow, "AddOutput", "color 221 221 221", "0.05");
		Engine.Ent_Fire_Ent(pShadow, "AddOutput", "distance 32.5", "0.05");
		Engine.Ent_Fire_Ent(pShadow, "Enable", "0", "0.1");
	}
}

void ColorCorrection()
{
	CBaseEntity@ pColor = FindEntityByClassname(null, "color_correction");
	if (pColor !is null)
	{
		Engine.Ent_Fire_Ent(pColor, "Disable", "0", "0.00");
		Engine.Ent_Fire_Ent(pColor, "AddOutput", "maxweight 0.65", "0.05");
		Engine.Ent_Fire_Ent(pColor, "AddOutput", "fadeInDuration 0.01", "0.05");
		Engine.Ent_Fire_Ent(pColor, "AddOutput", "fadeOutDuration 0.01", "0.05");
		Engine.Ent_Fire_Ent(pColor, "Enable", "0", "0.1");
	}
}

void KillSprite()
{
	CBaseEntity@ pSprite = null;
	while ((@pSprite = FindEntityByClassname(pSprite, "env_sprite")) !is null)
	{
		if (pSprite.GetAbsOrigin() == Vector(7379, -376, 290))
		{
			pSprite.SetEntityName("bad_sprite");
			Engine.Ent_Fire("bad_sprite", "hidesprite", "0", "0.1");
			break;
		}
	}
}

void OnMatchBegin()
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SecondarySpawns, false);
}

void CashDATA()
{
	MaxRandomCash = 14;
	MinRandomCash = 8;

	MaxMoneyPerItem = 185.0f;
	MinMoneyPerItem = 45.0f;

	InsertToArray(1241, -1295, -284);
	InsertToArray(1593.2, -640.378, -460);
	InsertToArray(2144.06, -853.513, -475);
	InsertToArray(2371.97, -584.785, -414);
	InsertToArray(3312.25, -219.319, -429);
	InsertToArray(2637.5, -742, -476);
	InsertToArray(2756.1, -715.06, -373);
	InsertToArray(2816.12, -726.691, -424);
	InsertToArray(3081, -471.984, -477);
	InsertToArray(1867.59, -935.309, -430);
	InsertToArray(2141, -1465, -382);
	InsertToArray(1166.4, -1477.62, -375);
	InsertToArray(1490, -1294, -452);
	InsertToArray(1490, -1262, -429);
	InsertToArray(1863, -1262, -444);
	InsertToArray(1798, -1348, -389);
	InsertToArray(1826, -1178, -375);
	InsertToArray(1575, -1177, -375);
	InsertToArray(1483, -1178, -375);
	InsertToArray(1552, -1099, -453);
	InsertToArray(1772, -834, -483);
	InsertToArray(1544, -935, -396);
	InsertToArray(1570, -802, -483);
	InsertToArray(1814, -891, -383);
	InsertToArray(1037.9, -1608.49, -396);
	InsertToArray(2034, -1603, -238);
	InsertToArray(2382, -532.482, -139);
	InsertToArray(2349, -1353, -156);
	InsertToArray(2882, -721.526, -156);
	InsertToArray(1639, -948.05, -306);
	InsertToArray(1655, -1113, -331);
	InsertToArray(1296, -1306, -232);
	InsertToArray(1434.91, -1310.79, -277);
	InsertToArray(1752, -1312.63, -276);
	InsertToArray(1789, -965, -183);
	InsertToArray(1841, -1120, -283);
	InsertToArray(1726, -809, -236);
	InsertToArray(1525.75, -949.109, -259);
	InsertToArray(1428, -880, -278);
	InsertToArray(1580.22, -434.896, -195);
	InsertToArray(2115.91, -518.741, -278);
	InsertToArray(1784, -502, -285);
	InsertToArray(2211.5, -185.145, -216);
	InsertToArray(2276.7, -193.246, -183);
	InsertToArray(2097, -367, -383);
	InsertToArray(1899, -378, -412);
	InsertToArray(2268.33, -170, -405);
	InsertToArray(1697.86, -187.128, -334);
	InsertToArray(2435.65, -414.486, -280);
	InsertToArray(1303.77, -724, -141);
	InsertToArray(1387, -653.005, -140);
	InsertToArray(1387, -1116, -141);
	InsertToArray(707, -399, -287);
	InsertToArray(421.673, -520.623, -46);
	InsertToArray(498, -704, -163);
	InsertToArray(458.64, -369, -132);
	InsertToArray(436, -358.118, -205);
	InsertToArray(363, -372, -177);
	InsertToArray(472, -626, -197.501);
	InsertToArray(471, -629, -161.437);
	InsertToArray(117, -685, -168);
	InsertToArray(50, -646, -160);
	InsertToArray(-167.914, -378, -213);
	InsertToArray(-166.43, -473, -214);
	InsertToArray(-77.7349, -237, -166);

	InsertToArray(2225.39, 389, -300);
	InsertToArray(1785, 550, -377);
	InsertToArray(1951.95, 644, -378);
	InsertToArray(1809.19, 725, -376);
	InsertToArray(1128, 661.255, -252);
	InsertToArray(1113, 621, -182);
	InsertToArray(975, 443, -253);
	InsertToArray(3323.58, 84, -455);
	InsertToArray(3326, 25, -478);
	InsertToArray(1888.16, 141, -284);
	InsertToArray(2012, 61.7994, -413);
	InsertToArray(2215.64, 64, -412);
	InsertToArray(1755.92, 172, -348);
	InsertToArray(1900.14, 8, -384);
	InsertToArray(2015.3, 3, -412);
	InsertToArray(3288, 566, -381);
	InsertToArray(2929.13, 654, -343);
	InsertToArray(384.723, 16, -162);
	InsertToArray(428.045, 15, -251);
	InsertToArray(89, 182, -250);
	InsertToArray(-50.75, 36, -250);
	InsertToArray(276, 351, -171);
	InsertToArray(-95.0897, 633, -291);
	InsertToArray(-17.4473, 784, -292);
	InsertToArray(25.6151, 846, -194);
	InsertToArray(389.032, 797, -292);
	InsertToArray(91, 267.189, -289);
	InsertToArray(694.402, 740, -291);
	InsertToArray(534, 363, -293);
	InsertToArray(782.917, 640, -215);
	InsertToArray(816.762, 650, -251);
	InsertToArray(1075, 934.717, -142);
	InsertToArray(994.759, 844, -139);
	InsertToArray(982.853, 941, -208);
	InsertToArray(1774, 1029.51, -379);
	InsertToArray(1593, 849.571, -344);
	InsertToArray(1556, 847, -344);
	InsertToArray(1948, 711, -135);
	InsertToArray(1972.15, 718, -197);
	InsertToArray(2197, 711, -136);
	InsertToArray(2380, 420, -379);
	InsertToArray(2475, 400.647, -266);
	InsertToArray(2548, 420, -292);
	InsertToArray(2559, 956.807, -287);
	InsertToArray(2370, 1034, -380);
	InsertToArray(2246.23, 542.133, -384.75);
	InsertToArray(2175, 400, -331);
}