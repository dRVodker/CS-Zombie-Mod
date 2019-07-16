bool bIsCSZM = false;

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Set Scale" );

	Events::Player::PlayerSay.Hook( @CSZM_SetS_PlrSay );
	Events::Player::OnPlayerSpawn.Hook( @CSZM_SetS_OnPlrSpawn );
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
	if ( bIsCSZM == true )  bIsCSZM = false;
}

HookReturnCode CSZM_SetS_OnPlrSpawn( CZP_Player@ pPlayer )
{
	if ( bIsCSZM == false ) return HOOK_CONTINUE;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	string sEntName = pBaseEnt.GetEntityName();

	if ( Utils.StrEql( "", sEntName ) )
	{
		sEntName = ( "plr_setsize" + pBaseEnt.entindex() );
		pBaseEnt.SetEntityName( sEntName );
	}

	Engine.Ent_Fire( sEntName, "SetModelScale", "1.0"  );

	return HOOK_CONTINUE;
}

HookReturnCode CSZM_SetS_PlrSay( CZP_Player@ pPlayer, CASCommand@ pArgs )
{
	if ( bIsCSZM == false ) return HOOK_CONTINUE;
	if ( pArgs is null ) return HOOK_CONTINUE;

	string arg1 = pArgs.Arg( 1 );

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	if ( Utils.StrContains( "!setscale", arg1 ) )
	{
		if ( pBaseEnt.GetTeamNumber() == 0 )
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
				if ( fltest < 0.1f ) fltest = 0.1f;
				if ( fltest > 1.0f ) fltest = 1.0f;

				if ( fltest == 1 ) sAddition = ".0";

				string sEntName = pBaseEnt.GetEntityName();

				if ( Utils.StrEql( "", sEntName ) )
				{
					sEntName = ( "plr_setsize" + pBaseEnt.entindex() );
					pBaseEnt.SetEntityName( sEntName );
				}

				Engine.Ent_Fire( sEntName, "SetModelScale", "" + fltest );
				Engine.EmitSoundPlayer( pPlayer, "weapons/slam/buttonclick.wav" );
			}

			Chat.CenterMessagePlayer( pPlrEnt, "Your scale has been changed to " + fltest + sAddition );
			return HOOK_HANDLED;
		}

		else Chat.PrintToChatPlayer( pPlrEnt, "Command should only be used in the ready room.");

		return HOOK_HANDLED;
	}

	if ( Utils.StrContains( "!dlight", arg1 ) )
	{
		if ( pBaseEnt.GetTeamNumber() == 0 )
		{
			CBaseEntity@ pWeapon = pPlayer.GetCurrentWeapon();
			if ( pWeapon !is null && !Utils.StrContains( "DLight_Origin", pWeapon.GetModelName() ) )
			{
				pWeapon.SetEntityName( "DLight_Origin" + pBaseEnt.entindex() );
				Engine.EmitSoundEntity( pBaseEnt, "Buttons.snd14" );
				Engine.Ent_Fire( "DLight_Origin" + pBaseEnt.entindex(), "AddOutput", "Effects 2" );
			}
		}
	}

	return HOOK_CONTINUE;
}