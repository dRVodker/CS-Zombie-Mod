#include "./cszm_modules/teamnums.as"

const string TEXT_ALLOWED_IN_LOBBY = "{cornflowerblue}*Allowed only in the {green}lobby team{cornflowerblue}!";
const string TEXT_YOU_HAVE_SNOWBALL = "{cornflowerblue}*You already have a {white}snowball{cornflowerblue}!";
const string TEXT_YOUR_SCALE = "Your scale has been changed to ";
const string TEXT_INVALID_VALUE = "{red}*Invalid value!";
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
	"!dlight;!dl;Turn on a dynamic light",
	"!snowball;Get a snowball"
};

bool bIsCSZM;

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

	string arg1 = pArgs.Arg(1);

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
				return HOOK_HANDLED;
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
			return HOOK_HANDLED;
		}

		else
		{
			Chat.PrintToChatPlayer(pPlrEnt, TEXT_ALLOWED_IN_LOBBY);
			Engine.EmitSoundPlayer(pPlayer, FILENAME_DENY);
		}

		return HOOK_HANDLED;
	}

	else if (Utils.StrContains("!dlight", arg1) || Utils.StrContains("!dl", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			DLight(pPlayer, pBaseEnt, pBaseEnt.entindex());
			return HOOK_HANDLED;
		}

		else
		{
			Chat.PrintToChatPlayer(pPlrEnt, TEXT_ALLOWED_IN_LOBBY);
			Engine.EmitSoundPlayer(pPlayer, FILENAME_DENY);
		}

		return HOOK_HANDLED;
	}

	else if (Utils.StrEql("!snowball", arg1))
	{
		if (pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS)
		{
			CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

			if (!Utils.StrEql("weapon_snowball", pWeapon.GetClassname()))
			{
				pPlayer.GiveWeapon("weapon_snowball");
			}

			else
			{
				Chat.PrintToChatPlayer(pPlrEnt, TEXT_YOU_HAVE_SNOWBALL);
				Engine.EmitSoundPlayer(pPlayer, FILENAME_DENY);
			}
		}

		else
		{
			Chat.PrintToChatPlayer(pPlrEnt, TEXT_ALLOWED_IN_LOBBY);
			Engine.EmitSoundPlayer(pPlayer, FILENAME_DENY);
		}

		return HOOK_HANDLED;
	}

	else if (Utils.StrEql("!chatcom", arg1))
	{
		ShowCom(pPlrEnt);
		return HOOK_HANDLED;
	}
/*
	if (Utils.StrContains("!hp", arg1))
	{
		pBaseEnt.SetHealth(99999);
		return HOOK_HANDLED;
	}
*/
	return HOOK_CONTINUE;
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