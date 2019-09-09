const int TEAM_LOBBYGUYS = 0;
const int TEAM_SPECTATORS = 1;

bool bIsCSZM = false;

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Chat Commands" );

	Events::Player::PlayerSay.Hook( @CSZM_SetS_PlrSay );
	Events::Player::OnPlayerSpawn.Hook( @CSZM_SetS_OnPlrSpawn );
	Events::Player::OnConCommand.Hook( @CSZM_SetS_OnConCommand );
}

void OnMapInit()
{
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		bIsCSZM = true;
		Engine.PrecacheFile( sound, "weapons/slam/buttonclick.wav" );
		Engine.PrecacheFile( sound, "buttons/lightswitch2.wav" );
		Engine.PrecacheFile( sound, "common/wpn_denyselect.wav" );
	}
}

void OnMapShutdown()
{
	if ( bIsCSZM )
	{
		bIsCSZM = false;
	}
}

HookReturnCode CSZM_SetS_OnPlrSpawn( CZP_Player@ pPlayer )
{
	if ( !bIsCSZM )
	{
		return HOOK_CONTINUE;
	}

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	string sEntName = pBaseEnt.GetEntityName();

	if ( pBaseEnt.GetTeamNumber() == TEAM_SPECTATORS )
	{
		pPlayer.StripWeapon( "weapon_emptyhand" );
	}

	Engine.Ent_Fire_Ent( pBaseEnt, "SetModelScale", "1.0"  );

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_SetS_OnConCommand( CZP_Player@ pPlayer, CASCommand@ pArgs )
{
	if ( bIsCSZM )
	{
		CBasePlayer@ pPlrEnt = pPlayer.opCast();
		CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

		int iIndex = pBaseEnt.entindex();

		if ( pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS )
		{
			if ( Utils.StrContains( "enhancevision", pArgs.Arg( 0 ) ) ) 
			{
				DLight( pPlayer, pBaseEnt, iIndex );
				return HOOK_HANDLED;
			}
		}
	}
	
	return HOOK_CONTINUE;
}

HookReturnCode CSZM_SetS_PlrSay( CZP_Player@ pPlayer, CASCommand@ pArgs )
{
	if ( !bIsCSZM ) 
	{
		return HOOK_CONTINUE;
	}

	if ( pArgs is null )
	{
		return HOOK_CONTINUE;
	}

	string arg1 = pArgs.Arg( 1 );

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( Utils.StrContains( "!setscale", arg1 ) || Utils.StrContains( "!scale", arg1 ) )
	{
		if ( pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS )
		{
			CASCommand@ pSplited = StringToArgSplit( arg1, " ");
			string sValue = pSplited.Arg( 1 );
			string sAddition = "";
			float fltest = Utils.StringToFloat( sValue );

			if ( fltest == 0 || fltest < 0 )
			{
				Chat.PrintToChatPlayer( pPlrEnt, "{red}*Invalid value!" );
				Engine.EmitSoundPlayer( pPlayer, "common/wpn_denyselect.wav" );
				return HOOK_HANDLED;
			}

			else
			{
				if ( fltest < 0.1f )
				{
					fltest = 0.1f;
				}

				if ( fltest > 1.0f )
				{
					fltest = 1.0f;
				}

				if ( fltest == 1 )
				{
					sAddition = ".0";
				}

				Engine.Ent_Fire_Ent( pBaseEnt, "SetModelScale", "" + fltest );
				Engine.EmitSoundPlayer( pPlayer, "weapons/slam/buttonclick.wav" );
			}

			Chat.CenterMessagePlayer( pPlrEnt, "Your scale has been changed to " + fltest + sAddition );
			return HOOK_HANDLED;
		}

		else
		{
			Chat.PrintToChatPlayer( pPlrEnt, "*Allowed only in {green}lobby team{default}!");
			Engine.EmitSoundPlayer( pPlayer, "common/wpn_denyselect.wav" );
		}

		return HOOK_HANDLED;
	}

	if ( Utils.StrContains( "!dlight", arg1 ) || Utils.StrContains( "!dl", arg1 ) )
	{
		if ( pBaseEnt.GetTeamNumber() == TEAM_LOBBYGUYS )
		{
			DLight( pPlayer, pBaseEnt, pBaseEnt.entindex() );
			return HOOK_HANDLED;
		}

		else
		{
			Chat.PrintToChatPlayer( pPlrEnt, "*Allowed only in the {green}lobby team{default}!");
			Engine.EmitSoundPlayer( pPlayer, "common/wpn_denyselect.wav" );
		}

		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

void DLight( CZP_Player@ pPlayer, CBaseEntity@ pPlrEntity, const int &in iIndex )
{
	CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();

	if ( pWeapon !is null )
	{
		Engine.EmitSoundEntity( pPlrEntity, "Buttons.snd14" );

		if ( !Utils.StrContains( "DLight_Origin", pWeapon.GetEntityName() ) )
		{
			pWeapon.SetEntityName( "DLight_Origin" + iIndex );
			Engine.Ent_Fire( "DLight_Origin" + iIndex, "AddOutput", "Effects 2" );
		}

		else
		{
			pWeapon.SetEntityName( "TrurnOff-DL" + iIndex );
			Engine.Ent_Fire( "TrurnOff-DL" + iIndex, "AddOutput", "Effects 32" );
		}
	}
}