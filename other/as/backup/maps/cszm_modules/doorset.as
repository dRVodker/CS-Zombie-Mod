//Setiing HP of 'prop_door_rotating'
void PropDoorHP()
{
	CBaseEntity@ pEntity;
	while ((@pEntity = FindEntityByClassname(pEntity, "prop_door_rotating")) !is null)
	{
		if(Utils.StrContains("doormainmetal01.mdl", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + PlrCountHP(7), "0.25");
		}
		else if(Utils.StrContains("doormain01.mdl", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + PlrCountHP(6), "0.25");
		}
		else if(Utils.StrContains("door_zps_wood.mdl", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + PlrCountHP(5), "0.25");
		}
		else if(Utils.StrContains("door_zps_metal.mdl", pEntity.GetModelName()))
		{
			Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + PlrCountHP(8), "0.25");
		}
		else
		{
			Engine.Ent_Fire_Ent(pEntity, "SetDoorHealth", "" + PlrCountHP(6), "0.25");
		}
	}
}

//Calculate HP from the players count
int PlrCountHP(int &in iMulti)
{
	int iHP = 0;
	int iSurvNum = Utils.GetNumPlayers(survivor, true);
	if(iSurvNum < 4) iSurvNum = 5;
	iHP = iSurvNum * iMulti;
	
	return iHP;
}