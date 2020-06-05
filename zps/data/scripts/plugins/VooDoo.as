void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void CD(const string &in strMsg)
{
	Chat.CenterMessage(all, strMsg);
}

void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("VooDoo Plugin");

	Events::Player::PlayerSay.Hook(@VooDoo_PlayerSay);
}

void OnMapInit()
{
}

HookReturnCode VooDoo_PlayerSay(CZP_Player@ pPlayer, CASCommand@ pArgs)
{
	HookReturnCode HRC_Result = HOOK_CONTINUE;
	if (pPlayer is null || pArgs is null) 
	{
		return HRC_Result;
	}

	string Content = pArgs.Arg(1);

	if (Content.findFirst("/", 0) == 0 || Content.findFirst("!", 0) == 0)
	{
		HRC_Result = HOOK_HANDLED;
		Content = Utils.StrReplace(Content, "/", "");
		Content = Utils.StrReplace(Content, "!", "");
		VooDoo_CommandManager(StringToArgSplit(Content, " "), pPlayer);
	}

	return HRC_Result;
}

void VooDoo_CommandManager(CASCommand@ pCS, CZP_Player@ pPlayer)
{
	CBasePlayer@ pPlayerBase = pPlayer.opCast();
	CBaseEntity@ pPlayerEntity = pPlayerBase.opCast();
	string Command = pCS.Arg(0);

	if (Utils.StrEql("test1", Command, true))
	{
		SD("{violet}TEST1");

	}
	else if (Utils.StrEql("test1", Command, true))
	{
		SD("{red}TEST2");

	}
}