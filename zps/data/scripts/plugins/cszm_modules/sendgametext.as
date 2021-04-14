// Sends information to a specific team
void SendGameText( ZPTeams iTeam, const string &in strMessage, int iChannel, float flxTime, float flxPos, float flyPos, float flFadeIn, float flFadeOut, float flHoldTime, Color clrPrimary, Color clrSecondary )
{
	// Create our params
	HudTextParams pParams;

	// Our X pos (0-1.0)
	// If -1, it will be centered
	pParams.x = flxPos;

	// Our Y pos (0-1.0)
	// If -1, it will be centered
	pParams.y = flyPos;

	// Our channel
	pParams.channel = iChannel;

	// Fade settings
	pParams.fadeinTime = flFadeIn;
	pParams.fadeoutTime = flFadeOut;

	// Our hold time
	pParams.holdTime = flHoldTime;

	// Our FX time
	pParams.fxTime = flxTime;

	// Our primary color
	pParams.SetColor( clrPrimary );

	// Our secondary color
	pParams.SetColor2( clrSecondary );

	// Print our message
	Utils.GameText( iTeam, strMessage, pParams );
}

// Sends the information to the specific player
void SendGameTextPlayer( CZP_Player@ pPlayer, const string &in strMessage, int iChannel, float flxTime, float flxPos, float flyPos, float flFadeIn, float flFadeOut, float flHoldTime, Color clrPrimary, Color clrSecondary )
{
	// Create our params
	HudTextParams pParams;

	// Our X pos (0-1.0)
	// If -1, it will be centered
	pParams.x = flxPos;

	// Our Y pos (0-1.0)
	// If -1, it will be centered
	pParams.y = flyPos;

	// Our channel
	pParams.channel = iChannel;

	// Fade settings
	pParams.fadeinTime = flFadeIn;
	pParams.fadeoutTime = flFadeOut;

	// Our hold time
	pParams.holdTime = flHoldTime;

	// Our FX time
	pParams.fxTime = flxTime;

	// Our primary color
	pParams.SetColor( clrPrimary );

	// Our secondary color
	pParams.SetColor2( clrSecondary );

	// Print our message
	Utils.GameTextPlayer( pPlayer, strMessage, pParams );
}
