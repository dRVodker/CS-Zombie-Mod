#include "cszm_modules/spawncrates"
#include "cszm_modules/tspawn"

void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void OnMapInit()
{	
	Schedule::Task(0.05f, "SetUpStuff");

	iMinCrates = 0;
	iMaxCrates = 4;

	//Spawn points for "prop_itemcrate"
	g_PICOrigin.insertLast(Vector(-3260.25, 1504.83, 780.466));
	g_PICAngles.insertLast(QAngle(0, -37.24, 0));

	g_PICOrigin.insertLast(Vector(-2807.68, 2142.01, 969.004));
	g_PICAngles.insertLast(QAngle(-0.0368034, -27.3475, 0.0120844));

	g_PICOrigin.insertLast(Vector(-1755.55, 1475.33, 1261.0));
	g_PICAngles.insertLast(QAngle(0, 57.6366, 0));

	g_PICOrigin.insertLast(Vector(-972.825, 1840.93, 888.455));
	g_PICAngles.insertLast(QAngle(0, -33.8835, 0));

	g_PICOrigin.insertLast(Vector(-2612.6, 1289.8, 720.479));
	g_PICAngles.insertLast(QAngle(0, 31.2687, 0));

	g_PICOrigin.insertLast(Vector(-1695.06, 3252.04, 1097.11));
	g_PICAngles.insertLast(QAngle(0, 40.387, 0));

	g_PICOrigin.insertLast(Vector(-1858.55, 2268.52, 1032.42));
	g_PICAngles.insertLast(QAngle(0, 127.438, 0));

	g_PICOrigin.insertLast(Vector(-3250.75, 2402.12, 912.5));
	g_PICAngles.insertLast(QAngle(0, -131.857, -180));

	TerroristsSpawn.insertLast("270|-1176 2784 889|-1176 2832 889|-1128 2832 889|-1128 2784 889|-1080 2784 889|-1080 2832 889");
	TerroristsSpawn.insertLast("90|-2090 1920 849|-2042 1920 849|-2042 1872 849|-2090 1872 849|-2090 1824 849|-2042 1824 849");
	TerroristsSpawn.insertLast("270|-3104 3360 889|-3152 3360 889|-3152.01 3408 889|-3104 3408 889|-3056 3408 889|-3056 3360 889");
}

void OnNewRound()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnCrates");
	CreateTerroristsSpawn();
}

void SetUpStuff()
{
	int iRNDPitch = Math::RandomInt(65, 135);
	
	Engine.Ent_Fire("teleport_ambient", "Pitch", ""+iRNDPitch);
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitchstart "+iRNDPitch);
	Engine.Ent_Fire("teleport_ambient", "AddOutput", "pitch "+iRNDPitch);
	
	Engine.Ent_Fire("teleport_ambient", "PlaySound");
	Engine.Ent_Fire("teleport_ambient", "Volume", "10");
	
	Engine.Ent_Fire("shading", "StartOverlays");
	
	Engine.Ent_Fire("HumanSpawn*", "AddOutput", "OnPlayerSpawn !self:kill:0:0:1");
	
	CreatedByColors();
}

void CreatedByColors()
{
	float flFireTime = Math::RandomFloat(0.10f, 1.20f);
	
	Schedule::Task(flFireTime, "CreatedByColors");
	
	int iR = Math::RandomInt(32, 255);
	int iG = Math::RandomInt(32, 255);
	int iB = Math::RandomInt(32, 255);
	
	Engine.Ent_Fire("created_by", "color", ""+iR+" "+iG+" "+iB);
}