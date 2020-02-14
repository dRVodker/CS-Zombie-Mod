#include "./cszm_modules/teamnums.as"
#include "./cszm_modules/chat.as"

bool bIsCSZM;

const string TEXT_ALLOWED_IN_LOBBY = "{cornflowerblue}*The command available only in the {green}lobby team{cornflowerblue}!";
const string TEXT_ALLOWED_IN_SPEC = "{cornflowerblue}*The command available only for {white}spectators{cornflowerblue}!";
const string TEXT_YOUR_SCALE = "Your scale has been changed to ";
const string TEXT_INVALID_VALUE = "{red}*Invalid value!";
const string TEXT_FIREFLY = "{cornflowerblue}*You became a {orange}firefly{cornflowerblue}.";
const string TEXT_FIREFLY_COLOR = "{cornflowerblue}*The {orange}firefly {cornflowerblue}color has been changed!";
const string TARGETNAME_DLIGHT = "DLight_Origin";
const string FILENAME_DENY = "buttons/combine_button_locked.wav";
const string FILENAME_BUTTONCLICK = "weapons/slam/buttonclick.wav";
const string FILENAME_LIGHTSWITCH = "buttons/lightswitch2.wav";

const string CLIST_COLOR_COMMAND = "{white}";
const string CLIST_COLOR_DESCRIP = "{gold}";
const string CLIST_COLOR_HEAD = "{gold}";

array<string> g_ChatComs =
{
	"!setscale;!scale;Set a player scale",
	"!dlight;Turn on a dynamic light",
	"!snowball;!sball;Get a snowball",
	"!tennisball;!tball;Get a tennisball",
	"!firefly;Become a {orange}Firefly{gold}. Supporting Custom {red}R{green}G{blue}B{gold}!"
};

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("CSZM - Chat Commands");

	Events::Player::PlayerSay.Hook(@CSZM_SetS_PlrSay);
	Events::Player::OnPlayerSpawn.Hook(@CSZM_SetS_OnPlrSpawn);
	Events::Player::OnConCommand.Hook(@CSZM_SetS_OnConCommand);
}

void OnMapInit()
{
	if (Utils.StrContains("cszm", Globals.GetCurrentMapName()))
	{
		bIsCSZM = true;
		Engine.PrecacheFile(sound, FILENAME_LIGHTSWITCH);
		Engine.PrecacheFile(sound, FILENAME_BUTTONCLICK);
		Engine.PrecacheFile(sound, FILENAME_DENY);
	}
}

void OnMapShutdown()
{
	if (bIsCSZM)
	{
		bIsCSZM = false;
	}
}

HookReturnCode CSZM_SetS_OnPlrSpawn(CZP_Player@ pPlayer)
{
	if (!bIsCSZM)
	{
		return HOOK_CONTINUE;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	string sEntDesc = pBaseEnt.GetEntityDescription();

	StripWeapon(pPlayer, "weapon_tennisball");
	StripWeapon(pPlayer, "weapon_snowball");

	if (pBaseEnt.GetTeamNumber() != TEAM_LOBBYGUYS)
	{
		CBaseEntity@ pPlrDlight = FindEntityByName(null, (pBaseEnt.entindex() + TARGETNAME_DLIGHT));
		if (pPlrDlight !is null)
		{
			Engine.EmitSoundEntity(pBaseEnt, "Buttons.snd14");
			pPlrDlight.SUB_Remove();
		}
	}

	if (pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS)
	{
		StripWeapon(pPlayer, "weapon_emptyhand");
	}
	else
	{
		SetFirefly(pBaseEnt, pBaseEnt.entindex(), 0, 0, 0, false);
	}

	if (Utils.StrContains(";scaled;", sEntDesc))
	{
		Engine.Ent_Fire_Ent(pBaseEnt, "SetModelScale", "1.0");
		sEntDesc = Utils.StrReplace(sEntDesc, ";scaled;", ";");
		pBaseEnt.SetEntityDescription(sEntDesc);
	}

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_SetS_OnConCommand(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	if (bIsCSZM)
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int iIndex = pBaseEnt.entindex();

		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			if (Utils.StrContains("enhancevision", pArgs.Arg(0))) 
			{
				DLight(pPlayer, pBaseEnt, iIndex);
			}
			else if (Utils.StrContains("holster", pArgs.Arg(0)))
			{
				CBaseEntity@ pCurWep = pPlayer.GetCurrentWeapon();
				const string CWClassname = pCurWep.GetClassname();
				if (!Utils.StrEql("weapon_emptyhand", CWClassname))
				{
					StripWeapon(pPlayer, CWClassname);
				}
			}
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_SetS_PlrSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HOOK_RESULT = HOOK_CONTINUE;
	if (!bIsCSZM || pArgs is null) 
	{
		return HOOK_RESULT;
	}

	int iCommTeam = -1;
	string arg1 = pArgs.Arg(1);

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (Utils.StrContains("!setscale", arg1) || Utils.StrContains("!scale", arg1))
	{
		CASCommand@ pSplited = StringToArgSplit(arg1, " ");

		if (Utils.StrEql("!setscale", pSplited.Arg(0)) || Utils.StrEql("!scale", pSplited.Arg(0)))
		{
			if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
			{
				string sValue = pSplited.Arg(1);
				string sAddition = "";
				string sEntDesc = pBaseEnt.GetEntityDescription();
				float fltest = Utils.StringToFloat(sValue);

				if (fltest == 0 || fltest < 0)
				{
					Chat.PrintToChatPlayer(pPlrEnt, TEXT_INVALID_VALUE);
					Engine.EmitSoundPlayer(pPlayer, FILENAME_DENY);
					HOOK_RESULT = HOOK_HANDLED;
				}
				else
				{
					if (fltest < 0.1f)
					{
						fltest = 0.1f;
					}

					else if (fltest > 2.0f)
					{
						fltest = 2.0f;
					}

					else if (fltest == 1)
					{
						sAddition = ".0";
					}

					Engine.Ent_Fire_Ent(pBaseEnt, "SetModelScale", "" + fltest);
					Engine.EmitSoundPlayer(pPlayer, FILENAME_BUTTONCLICK);

					if (!Utils.StrContains(";scaled;", sEntDesc))
					{
						sEntDesc = sEntDesc + ";scaled;";
						pBaseEnt.SetEntityDescription(sEntDesc);
					}

					Chat.CenterMessagePlayer(pPlrEnt, TEXT_YOUR_SCALE + fltest + sAddition);
				}
			}
			else
			{
				iCommTeam = TEAM_LOBBYGUYS;
			}

			HOOK_RESULT = HOOK_HANDLED;
		}
	}
	else if (Utils.StrEql("!dlight", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			DLight(pPlayer, pBaseEnt, pBaseEnt.entindex());				
		}
		else
		{
			iCommTeam = TEAM_LOBBYGUYS;
		}

		HOOK_RESULT = HOOK_HANDLED;
	}
	else if (Utils.StrEql("!snowball", arg1) || Utils.StrEql("!sball", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			GiveThrowable(pPlayer, "weapon_snowball");
		}
		else
		{
			iCommTeam = TEAM_LOBBYGUYS;
		}

		HOOK_RESULT = HOOK_HANDLED;
	}
	else if (Utils.StrEql("!tennisball", arg1) || Utils.StrEql("!tball", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			GiveThrowable(pPlayer, "weapon_tennisball");
		}
		else
		{
			iCommTeam = TEAM_LOBBYGUYS;
		}

		HOOK_RESULT = HOOK_HANDLED;
	}
	else if (Utils.StrContains("!firefly", arg1))
	{
		CASCommand@ pFFSplited = StringToArgSplit(arg1, " ");

		if (Utils.StrEql("!firefly", pFFSplited.Arg(0)))
		{
			if (pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS)
			{
				int FFColorR = Math::RandomInt(16, 255);
				int FFColorG = Math::RandomInt(16, 255);
				int FFColorB = Math::RandomInt(16, 255);

				if (pFFSplited.Args() != 1)
				{
					if(Utils.NumbersOnly(pFFSplited.Arg(1)) && Utils.StringToInt(pFFSplited.Arg(1)) >= 0)
					{
						FFColorR = Utils.StringToInt(pFFSplited.Arg(1));

						if (Utils.StringToInt(pFFSplited.Arg(1)) > 255)
						{
							FFColorR = 255;
						}
					}

					if(Utils.NumbersOnly(pFFSplited.Arg(2)) && Utils.StringToInt(pFFSplited.Arg(2)) >= 0)
					{
						FFColorG = Utils.StringToInt(pFFSplited.Arg(2));

						if (Utils.StringToInt(pFFSplited.Arg(2)) > 255)
						{
							FFColorG = 255;
						}
					}

					if(Utils.NumbersOnly(pFFSplited.Arg(3)) && Utils.StringToInt(pFFSplited.Arg(3)) >= 0)
					{
						FFColorB = Utils.StringToInt(pFFSplited.Arg(3));

						if (Utils.StringToInt(pFFSplited.Arg(3)) > 255)
						{
							FFColorB = 255;
						}
					}
				}

				Chat.PrintToConsolePlayer(pPlrEnt, "{gold}------------------------------------\n-= The Firefly Color ({red}R{green}G{blue}B{gold}) =-\n------------------------------------\n{red}Red: " + FFColorR + "\n{green}Green: " + FFColorG + "\n{blue}Blur: " + FFColorB + "\n{gold}------------------------------------");

				if (!Utils.StrContains("firefly", pBaseEnt.GetEntityDescription()))
				{
					SetFirefly(pBaseEnt, pBaseEnt.entindex(), FFColorR, FFColorG, FFColorB, true);
					Chat.PrintToChatPlayer(pPlrEnt, TEXT_FIREFLY);			
				}
				else
				{
					ColorFireFly(pBaseEnt, pBaseEnt.entindex(), FFColorR, FFColorG, FFColorB);
					Chat.PrintToChatPlayer(pPlrEnt, TEXT_FIREFLY_COLOR);	
				}

				Chat.PrintToConsolePlayer(pPlrEnt, "{gold}------------------------------------");

				HOOK_RESULT = HOOK_HANDLED;
			}
			else
			{
				iCommTeam = TEAM_SPECTATORS;
				HOOK_RESULT = HOOK_HANDLED;
			}
		}
	}
	else if (Utils.StrEql("!chatcom", arg1) || Utils.StrEql("!help", arg1))
	{
		ShowCom(pPlrEnt);
		HOOK_RESULT = HOOK_HANDLED;
	}

	if (iCommTeam != -1)
	{
		if (iCommTeam == TEAM_LOBBYGUYS)
		{
			Chat.PrintToChatPlayer(pPlrEnt, TEXT_ALLOWED_IN_LOBBY);
		}
		else if (iCommTeam == TEAM_SPECTATORS)
		{
			Chat.PrintToChatPlayer(pPlrEnt, TEXT_ALLOWED_IN_SPEC);
		}

		Engine.EmitSoundPlayer(pPlayer, FILENAME_DENY);

		if (HOOK_RESULT != HOOK_HANDLED)
		{
			HOOK_RESULT = HOOK_HANDLED;
		}
	}

	return HOOK_RESULT;
}

void ColorFireFly(CBaseEntity@ pPlayerEntity, const int &in iIndex, int &in iR, int &in iG, int &in iB)
{
	CBaseEntity@ pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");
	CBaseEntity@ pTrailEnt = FindEntityByName(pTrailEnt, iIndex + "firefly_trail");

	if (pSpriteEnt !is null && pTrailEnt !is null)
	{
		Engine.Ent_Fire_Ent(pSpriteEnt, "color", "" + iR + " " + iG + " " + iB);
		Engine.Ent_Fire_Ent(pTrailEnt, "color", "" + iR + " " + iG + " " + iB);		
	}

	Engine.EmitSoundPosition(iIndex, "ZPlayer.AmmoPickup", pPlayerEntity.GetAbsOrigin(), 0.75F, 80, 105);
}

void SetFirefly(CBaseEntity@ pPlayerEntity, const int &in iIndex, int &in iR, int &in iG, int &in iB, const bool &in bFirefly)
{
	string strPlrDisc = pPlayerEntity.GetEntityDescription();

	if (bFirefly)
	{
		strPlrDisc = strPlrDisc + "|firefly|";

		pPlayerEntity.SetEntityDescription(strPlrDisc);

		CEntityData@ FFSpriteIPD = EntityCreator::EntityData();

		FFSpriteIPD.Add("targetname", iIndex + "firefly_sprite");
		FFSpriteIPD.Add("model", "sprites/light_glow01.vmt");
		FFSpriteIPD.Add("rendercolor", iR + " " + iG + " " + iB);
		FFSpriteIPD.Add("rendermode", "5");
		FFSpriteIPD.Add("renderamt", "240");
		FFSpriteIPD.Add("scale", "0.25");
		FFSpriteIPD.Add("spawnflags", "1");
		FFSpriteIPD.Add("framerate", "0");

		CEntityData@ FFTrailIPD = EntityCreator::EntityData();

		FFTrailIPD.Add("targetname", iIndex + "firefly_trail");
		FFTrailIPD.Add("endwidth", "12");
		FFTrailIPD.Add("lifetime", "0.145");
		FFTrailIPD.Add("rendercolor", iR + " " + iG + " " + iB);
		FFTrailIPD.Add("rendermode", "5");
		FFTrailIPD.Add("renderamt", "84");
		FFTrailIPD.Add("spritename", "sprites/xbeam2.vmt");
		FFTrailIPD.Add("startwidth", "3");

		EntityCreator::Create("env_spritetrail", pPlayerEntity.GetAbsOrigin(), pPlayerEntity.GetAbsAngles(), FFTrailIPD);
		EntityCreator::Create("env_sprite", pPlayerEntity.GetAbsOrigin(), pPlayerEntity.GetAbsAngles(), FFSpriteIPD);

		CBaseEntity@ pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");
		CBaseEntity@ pTrailEnt = FindEntityByName(pTrailEnt, iIndex + "firefly_trail");

		pTrailEnt.SetParent(pSpriteEnt);
		pSpriteEnt.SetParent(pPlayerEntity);

		Engine.EmitSoundPosition(iIndex, "Player.PickupWeapon", pPlayerEntity.GetAbsOrigin(), 0.75F, 80, 105);
	}
	else
	{
		CBaseEntity@ pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");

		if (pSpriteEnt !is null)
		{
			pSpriteEnt.SUB_Remove();
		}

		if (Utils.StrContains("|firefly|", strPlrDisc))
		{
			strPlrDisc = Utils.StrReplace(strPlrDisc, "|firefly|", "");
			
			pPlayerEntity.SetEntityDescription(strPlrDisc);
		}
	}
}

void GiveThrowable(CZP_Player@ pPlayer, const string &in strClassname)
{
	CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();
	string strCurWepClassname = pWeapon.GetClassname();

	if (Utils.StrEql("weapon_emptyhand", strCurWepClassname))
	{
		pPlayer.GiveWeapon(strClassname);
	}
	else if (Utils.StrEql(strClassname, strCurWepClassname))
	{
		StripWeapon(pPlayer, strCurWepClassname);
	}
	else
	{
		StripWeapon(pPlayer, pWeapon.GetClassname());
		pPlayer.GiveWeapon(strClassname);
	}
}

void DLight(CZP_Player@ pPlayer, CBaseEntity@ pPlayerEntity, const int &in iIndex)
{
	CBaseEntity@ pPlrDlight = FindEntityByName(null, (iIndex + TARGETNAME_DLIGHT));

	Engine.EmitSoundEntity(pPlayerEntity, "Buttons.snd14");
	if (pPlrDlight !is null)
	{
		pPlrDlight.SUB_Remove();
	}
	else
	{
		CEntityData@ PropDynamicIPD = EntityCreator::EntityData();

		PropDynamicIPD.Add("targetname", iIndex + TARGETNAME_DLIGHT);
		PropDynamicIPD.Add("disableshadows", "1");
		PropDynamicIPD.Add("solid", "0");
		PropDynamicIPD.Add("DisableBoneFollowers", "1");
		PropDynamicIPD.Add("spawnflags", "256");
		PropDynamicIPD.Add("model", "models/props_junk/popcan01a.mdl");
		PropDynamicIPD.Add("modelscale", "0.25");
		PropDynamicIPD.Add("DefaultAnim", "idle");
		PropDynamicIPD.Add("Effects", "18");	//2
		PropDynamicIPD.Add("rendermode", "10");
		PropDynamicIPD.Add("health", "0");
		PropDynamicIPD.Add("fademindist", "1");
		PropDynamicIPD.Add("fademaxdist", "2");

		CBaseEntity@ pDlight = EntityCreator::Create("prop_dynamic_override", pPlayerEntity.GetAbsOrigin(), pPlayerEntity.GetAbsAngles(), PropDynamicIPD);

		pDlight.SetParent(pPlayerEntity);
		pDlight.SetParentAttachment("anim_attachment_LH", false);
	}
}

void ShowCom(CBasePlayer@ pPlayer)
{
	Chat.PrintToChatPlayer(pPlayer, CLIST_COLOR_HEAD + "-=List of chat commands=-");

	uint iChatComsLength = g_ChatComs.length();

	for (uint q = 0; q < iChatComsLength; q++)
	{
		string strCommand;
		string strShort;
		string strDescription;

		CASCommand@ pSplited = StringToArgSplit(g_ChatComs[q], ";");
		strCommand = pSplited.Arg(0);

		if (pSplited.Args() == 3)
		{
			strCommand += CLIST_COLOR_DESCRIP + " or";
			strShort = pSplited.Arg(1);
			strDescription = pSplited.Arg(2);
		}
		else if (pSplited.Args() == 2)
		{
			strDescription = pSplited.Arg(1);
		}

		Chat.PrintToChatPlayer(pPlayer, CLIST_COLOR_COMMAND + strCommand + " " + CLIST_COLOR_COMMAND + strShort + CLIST_COLOR_DESCRIP + " - " + strDescription);
	}

//	Engine.EmitSoundPlayer(pPlayer, "HudChat.Message");
	Engine.EmitSoundPlayer(pPlayer, "cszm_fx/misc/talk.wav");
}

void StripWeapon(CZP_Player@ pPlayer, const string &in strClassname)
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pBasePlayer.opCast();
	CBaseEntity@ pWeapon;

	pPlayer.StripWeapon(strClassname);

	while ((@pWeapon = FindEntityByClassname(pWeapon, strClassname)) !is null)
	{
		CBaseEntity@ pOwner = pWeapon.GetOwner();

		if (pPlayerEntity is pOwner)
		{
			pWeapon.SUB_Remove();
		}
	}
}