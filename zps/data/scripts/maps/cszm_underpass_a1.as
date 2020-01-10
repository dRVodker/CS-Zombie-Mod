void OnMapInit()
{
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnNewRound()
{	
	Schedule::Task(0.05f, "SetUpStuff");
}

void OnMatchBegin() 
{
	Schedule::Task(0.5f, "SpawnBarricades");
}

void SetUpStuff()
{
	Engine.Ent_Fire("screenoverlay", "StartOverlays");
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