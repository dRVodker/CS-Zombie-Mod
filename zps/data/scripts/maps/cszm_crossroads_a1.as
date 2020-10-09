#include "cszm_modules/lobbyambient"
#include "cszm_modules/newspawn"

const int TEAM_LOBBYGUYS = 0;

array<array<CSpawnPoint@>> PrimaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(-1478.02, 2210.76, -215.969), QAngle(-1.92386, -18.6582, 0)),
		CSpawnPoint(Vector(-1465.67, 2059.49, -215.969), QAngle(3.12183, 19.5294, 0)),
		CSpawnPoint(Vector(-1388.63, 2144.01, -215.969), QAngle(-0.0725655, -32.3433, 0)),
		CSpawnPoint(Vector(-1268.53, 2181.46, -215.969), QAngle(-2.97657, -65.2311, 0)),
		CSpawnPoint(Vector(-1372.62, 2047.18, -215.969), QAngle(1.74243, 3.66628, 0)),
		CSpawnPoint(Vector(-1298.52, 1989.17, -215.969), QAngle(-2.94027, 4.31968, 0)),
		CSpawnPoint(Vector(-1275.44, 2083.91, -215.969), QAngle(0.653437, -8.13122, 0)),
		CSpawnPoint(Vector(-1492.02, 1958.49, -215.969), QAngle(0.834913, 27.2976, 0)),
		CSpawnPoint(Vector(-1378.03, 2217.18, -215.969), QAngle(0.363015, -24.7567, 0)),
		CSpawnPoint(Vector(-1227.68, 1991.78, -215.969), QAngle(-1.45198, 9.03867, 0)),
		CSpawnPoint(Vector(-1220.31, 2203.33, -215.969), QAngle(-8.53048, -24.9018, 0)),
		CSpawnPoint(Vector(882.217, 2197.89, -215.969), QAngle(0.943807, -177.652, -0)),
		CSpawnPoint(Vector(886.314, 2005.79, -215.969), QAngle(0.943807, -177.652, -0)),
		CSpawnPoint(Vector(968.31, 2070.75, -215.969), QAngle(0.943807, -177.652, -0)),
		CSpawnPoint(Vector(1010.45, 2178.69, -215.969), QAngle(-4.13819, -177.652, 0)),
		CSpawnPoint(Vector(1061.15, 1997.24, -215.969), QAngle(-5.98949, 150.331, 0)),
		CSpawnPoint(Vector(1070.03, 2101.52, -215.969), QAngle(-3.62999, -163.894, 0)),
		CSpawnPoint(Vector(1081.4, 2209.73, -215.969), QAngle(-2.8314, -151.335, 0)),
		CSpawnPoint(Vector(1088.97, 1359.64, -215.969), QAngle(0.399307, 167.247, 0)),
		CSpawnPoint(Vector(1043.9, 1439.65, -215.969), QAngle(-3.12179, -160.664, 0)),
		CSpawnPoint(Vector(1099.98, 1549.36, -215.969), QAngle(-1.08899, -171.517, 0)),
		CSpawnPoint(Vector(1015.3, 1578.83, -215.969), QAngle(-1.96019, -136.379, 0)),
		CSpawnPoint(Vector(1027.16, 1350.22, -215.969), QAngle(0.290415, 160.641, 0)),
		CSpawnPoint(Vector(1124.69, 1413.82, -215.969), QAngle(-1.8513, 166.412, 0)),
		CSpawnPoint(Vector(991.56, 1487.48, -215.969), QAngle(-4.86422, -174.929, 0)),

		CSpawnPoint(Vector(276.738, -301.631, 136.031), QAngle(-4.35604, 120.045,  0), "info_player_start"),
		CSpawnPoint(Vector(440.109, 157.718, 136.031), QAngle(-5.04573, 141.897,   0), "info_player_start"),
		CSpawnPoint(Vector(-633.054, -134.401, 8.03125), QAngle(-4.68274, 47.3722, 0), "info_player_start")
	}
};

array<array<CSpawnPoint@>> SecondaryHumanSpawns =
{
	{
		CSpawnPoint(Vector(250.37, -283.944, 136.031), QAngle(-1.12535, 90.1828, 0)),
		CSpawnPoint(Vector(163.352, -280.812, 136.031), QAngle(11.4345, 80.418, -0)),
		CSpawnPoint(Vector(104.417, -217.856, 136.031), QAngle(-1.01645, 83.3584, -0)),
		CSpawnPoint(Vector(249.794, -197.94, 136.031), QAngle(5.19085, 122.526, -0)),
		CSpawnPoint(Vector(130.816, -156.729, 136.031), QAngle(6.13465, 69.3465, 0)),
		CSpawnPoint(Vector(224.556, -102.991, 136.031), QAngle(3.88405, 97.0797, 0)),
		CSpawnPoint(Vector(426.772, 158.189, 136.031), QAngle(-5.98953, 171.095, 0)),
		CSpawnPoint(Vector(400.366, 316.855, 136.031), QAngle(4.53746, -152.206, 0)),
		CSpawnPoint(Vector(262.305, 408.293, 136.031), QAngle(-3.04923, -72.3093, 0)),
		CSpawnPoint(Vector(358.776, 199.245, 136.031), QAngle(1.56086, 150.731, 0)),
		CSpawnPoint(Vector(289.303, 267.98, 136.031), QAngle(-3.73893, 153.925, 0)),
		CSpawnPoint(Vector(-621.839, -119.481, 8.03125), QAngle(-4.93684, 76.6061, 0)),
		CSpawnPoint(Vector(-471.115, -109.191, 8.03125), QAngle(-1.19794, 106.445, 0)),
		CSpawnPoint(Vector(-387.001, -84.3635, 8.03125), QAngle(1.16156, 99.9833, 0)),
		CSpawnPoint(Vector(-446.427, 7.31889, 8.03125), QAngle(-1.23424, 3.2075, 0)),
		CSpawnPoint(Vector(-435.831, 131.73, 8.03125), QAngle(-2.68624, -20.4601, 0)),
		CSpawnPoint(Vector(-514.809, 3.51513, 8.03125), QAngle(-6.96964, 98.0594, 0)),
		CSpawnPoint(Vector(-606.657, -38.8573, 8.03125), QAngle(-0.653439, 82.3415, -0)),
		CSpawnPoint(Vector(-605.092, 96.0082, 8.03125), QAngle(-8.67574, 81.4703, -0)),
		CSpawnPoint(Vector(-507.239, 154.457, 8.03125), QAngle(-3.88414, 92.1425, -0)),
		CSpawnPoint(Vector(-610.671, 232.464, 8.03125), QAngle(-4.53754, -51.061, -0)),
		CSpawnPoint(Vector(-376.1, 248.616, 8.03125), QAngle(-1.59725, -108.814, 0))
	}
};

void OnMapInit()
{
	Events::Player::OnPlayerSpawn.Hook(@OnPlrSpawn);
	OnNewRound();
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	RemoveNativeSpawns("info_player_human");
	CreateSpawnsFromArray(SecondaryHumanSpawns, false);
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
	Engine.Ent_Fire("Precache", "Kill");
	
	PropSkins();
	OpenDoors();
	PlayLobbyAmbient();

	RemoveNativeSpawns("info_player_human");
	RemoveNativeSpawns("info_player_zombie");
	CreateSpawnsFromArray(PrimaryHumanSpawns, true);
}

HookReturnCode OnPlrSpawn(CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
	{
		PlayLobbyAmbient();
	}

	return HOOK_HANDLED;
}

void OpenDoors()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		Engine.Ent_Fire_Ent(pEntity, "FireUser1");
	}
	
	Engine.Ent_Fire("H-OF*", "Kill", "0", "0.85");
}

void PropSkins()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_physics_multiplayer")) !is null)
	{
		if(Utils.StrContains("vending_machine", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", formatInt(Math::RandomInt(0, 2)));
		}

		else if(Utils.StrContains("oildrum001", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "Skin", formatInt(Math::RandomInt(0, 5)));
		}
	}
}