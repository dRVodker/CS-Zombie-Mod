#include "./cszm_modules/teamnums.as"

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
	"!firefly;Become a {orange}Firefly"
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

	if (pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS)
	{
		pPlayer.StripWeapon("weapon_emptyhand");
	}

	else
	{
		SetFirefly(pBaseEnt, pBaseEnt.entindex(), false);
	}

	Engine.Ent_Fire_Ent(pBaseEnt, "SetModelScale", "1.0");

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
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_SetS_PlrSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	if (!bIsCSZM || pArgs is null) 
	{
		return HOOK_CONTINUE;
	}

	int iCommTeam = -1;
	string arg1 = pArgs.Arg(1);
	bool bHandled;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if (Utils.StrContains("!setscale", arg1) || Utils.StrContains("!scale", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			CASCommand@ pSplited = StringToArgSplit(arg1, " ");
			string sValue = pSplited.Arg(1);
			string sAddition = "";
			float fltest = Utils.StringToFloat(sValue);

			if (fltest == 0 || fltest < 0)
			{
				Chat.PrintToChatPlayer(pPlrEnt, TEXT_INVALID_VALUE);
				Engine.EmitSoundPlayer(pPlayer, FILENAME_DENY);
				bHandled = true;
			}

			else
			{
				if (fltest < 0.1f)
				{
					fltest = 0.1f;
				}

				if (fltest > 1.0f)
				{
					fltest = 1.0f;
				}

				if (fltest == 1)
				{
					sAddition = ".0";
				}

				Engine.Ent_Fire_Ent(pBaseEnt, "SetModelScale", "" + fltest);
				Engine.EmitSoundPlayer(pPlayer, FILENAME_BUTTONCLICK);
			}

			Chat.CenterMessagePlayer(pPlrEnt, TEXT_YOUR_SCALE + fltest + sAddition);
		}

		else
		{
			iCommTeam = TEAM_LOBBYGUYS;
		}

		bHandled = true;
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

		bHandled = true;
	}

	else if (Utils.StrEql("!snowball", arg1) || Utils.StrEql("!sball", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

			if (Utils.StrEql("weapon_emptyhand", pWeapon.GetClassname()))
			{
				pPlayer.GiveWeapon("weapon_snowball");
			}

			else
			{
				pPlayer.StripWeapon(pWeapon.GetClassname());
				pPlayer.GiveWeapon("weapon_snowball");
			}
		}

		else
		{
			iCommTeam = TEAM_LOBBYGUYS;
		}

		bHandled = true;
	}
	
	else if (Utils.StrEql("!tennisball", arg1) || Utils.StrEql("!tball", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

			if (Utils.StrEql("weapon_emptyhand", pWeapon.GetClassname()))
			{
				pPlayer.GiveWeapon("weapon_tennisball");
			}

			else
			{
				pPlayer.StripWeapon(pWeapon.GetClassname());
				pPlayer.GiveWeapon("weapon_tennisball");
			}				
		}

		else
		{
			iCommTeam = TEAM_LOBBYGUYS;
		}

		bHandled = true;
	}

	else if (Utils.StrEql("!firefly", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS)
		{
			if (!Utils.StrContains("firefly", pBaseEnt.GetEntityDescription()))
			{
				SetFirefly(pBaseEnt, pBaseEnt.entindex(), true);
				Chat.PrintToChatPlayer(pPlrEnt, TEXT_FIREFLY);			
			}

			else
			{
				ColorFireFly(pBaseEnt, pBaseEnt.entindex());
				Chat.PrintToChatPlayer(pPlrEnt, TEXT_FIREFLY_COLOR);	
			}
		}

		else
		{
			iCommTeam = TEAM_SPECTATORS;
		}

		bHandled = true;
	}

	else if (Utils.StrEql("!chatcom", arg1))
	{
		ShowCom(pPlrEnt);
		bHandled = true;
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
		bHandled = true;
	}

	if (bHandled)
	{
		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

void ColorFireFly(CBaseEntity@ pPlayerEntity, const int &in iIndex)
{
	CBaseEntity@ pSpriteEnt = null;
	CBaseEntity@ pTrailEnt = null;

	const int iR = Math::RandomInt(1, 255);
	const int iG = Math::RandomInt(iR - iR / 2, 255);
	const int iB = Math::RandomInt(iG - iG / 2, 255);

	@pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");
	@pTrailEnt = FindEntityByName(pTrailEnt, iIndex + "firefly_trail");

	if (pSpriteEnt !is null)
	{
		Engine.Ent_Fire_Ent(pSpriteEnt, "color", "" + iR + " " + iG + " " + iB);
		Engine.Ent_Fire_Ent(pTrailEnt, "color", "" + iR + " " + iG + " " + iB);		
	}

	Engine.EmitSoundPosition(iIndex, "ZPlayer.AmmoPickup", pPlayerEntity.GetAbsOrigin(), 0.75F, 80, 105);
}

void SetFirefly(CBaseEntity@ pPlayerEntity, const int &in iIndex, const bool &in bFirefly)
{
	string strPlrDisc = pPlayerEntity.GetEntityDescription();

	if (bFirefly)
	{
		strPlrDisc = strPlrDisc + "|firefly|";

		pPlayerEntity.SetEntityDescription(strPlrDisc);

		const int iR = Math::RandomInt(1, 255);
		const int iG = Math::RandomInt(iR - iR / 2, 255);
		const int iB = Math::RandomInt(iG - iG / 2, 255);

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

		CBaseEntity@ pSpriteEnt = null;
		CBaseEntity@ pTrailEnt = null;

		@pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");
		@pTrailEnt = FindEntityByName(pTrailEnt, iIndex + "firefly_trail");

		pTrailEnt.SetParent(pSpriteEnt);
		pSpriteEnt.SetParent(pPlayerEntity);

		Engine.EmitSoundPosition(iIndex, "Player.PickupWeapon", pPlayerEntity.GetAbsOrigin(), 0.75F, 80, 105);
	}

	else
	{
		CBaseEntity@ pSpriteEnt = null;

		@pSpriteEnt = FindEntityByName(pSpriteEnt, iIndex + "firefly_sprite");

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

void DLight(CZP_Player@ pPlayer, CBaseEntity@ pPlrEntity, const int &in iIndex)
{
	CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

	if (pWeapon !is null)
	{
		Engine.EmitSoundEntity(pPlrEntity, "Buttons.snd14");

		if (!Utils.StrContains(TARGETNAME_DLIGHT, pWeapon.GetEntityName()))
		{
			pWeapon.SetEntityName(TARGETNAME_DLIGHT + iIndex);
			Engine.Ent_Fire(TARGETNAME_DLIGHT + iIndex, "AddOutput", "Effects 2");
		}

		else
		{
			pWeapon.SetEntityName("TrurnOff-DL" + iIndex);
			Engine.Ent_Fire("TrurnOff-DL" + iIndex, "AddOutput", "Effects 32");
		}
	}
}

void ShowCom(CBasePlayer@ pPlayer)
{
	Chat.PrintToChatPlayer(pPlayer, CLIST_COLOR_HEAD + "-=List of chat commands=-");

	for (uint q = 0; q < g_ChatComs.length(); q++)
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

	Engine.EmitSoundPlayer(pPlayer, "HudChat.Message");
}