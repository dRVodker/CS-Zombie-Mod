void AddSlowdown( const int &in iIndex, const float &in flDamage, const int &in iDamageType )
{
	CZP_Player@ pPlayer = ToZPPlayer( iIndex );

	if ( pPlayer is null ) return;
	if ( g_bIsWeakZombie[iIndex] ) return;

	g_flRecoverTime[iIndex] = 0.0f;

	bool bLongSlowdown = false;

	if ( g_flSlowTime[iIndex] - Globals.GetCurrentTime() > flMaxSlowTime ) bLongSlowdown = true;

	float p_flAddTime = g_flAddTime[iIndex];
	float flSlowTime = 0.05f;
	int iSpeed = 5;

	if ( p_flAddTime < 0.22f ) flSlowTime += 0.15f;

	if ( flDamage <= 2 ) iSpeed = 1;

	else if ( flDamage > 5 ) iSpeed = int( flDamage * 0.40f );

	p_flAddTime += flSlowTime;

	if ( p_flAddTime > flMaxSlowTime && !bLongSlowdown ) p_flAddTime = flMaxSlowTime;

	//Melee
	if ( bDamageType( iDamageType, 7 ) )
	{
		iSpeed = 100;
		p_flAddTime = 2.95f;
	}

	//Blast
	if ( bDamageType( iDamageType, 6 ) )
	{
		iSpeed = 75;
		p_flAddTime = 2.35f;
	}

	//Blast Surface
	if ( bDamageType( iDamageType, 27 ) )
	{
		iSpeed = 65;
		p_flAddTime = 1.35f;
	}

	//Buckshot
	if ( bDamageType( iDamageType, 29 ) )
	{
		iSpeed += Math::RandomInt( 10, 15 );
		p_flAddTime += Math::RandomFloat( 0.25f, 0.40f );
	}

	//Fall
	if ( bDamageType( iDamageType, 5 ) )
	{
		iSpeed = 60;
		p_flAddTime = 0.78f;
	}

	//If hit with revolver - increase slowdown time
	if ( flDamage >= 60 && bDamageType( iDamageType, 13 ) ) p_flAddTime += 0.30f;

	//If First infected - reduce iSpeed
	if ( g_bIsFirstInfected[iIndex] ) iSpeed = int( floor( iSpeed * 0.87f ) );

	//If Carrier - reduce iSpeed
	if ( pPlayer.IsCarrier() && !g_bIsFirstInfected[iIndex] ) iSpeed = int( floor( iSpeed * 0.65f ) );

	//Get current player speed and subtract slowdown value (iSpeed)
	g_iSlowSpeed[iIndex] = pPlayer.GetMaxSpeed() - iSpeed;

	//Increase slowdown timer
	if ( !bLongSlowdown )
	{
		g_flAddTime[iIndex] = p_flAddTime;
		g_flSlowTime[iIndex] = Globals.GetCurrentTime() + p_flAddTime;
	}

	//"g_iSlowSpeed" cannot be lower than "iMinSpeed"
	if ( g_iSlowSpeed[iIndex] < iMinSpeed ) g_iSlowSpeed[iIndex] = iMinSpeed;

	//Apply slowdown to player
	pPlayer.SetMaxSpeed( g_iSlowSpeed[iIndex] );

	SD("------------------------------");
	SD( "iSpeed: " + iSpeed + "\ng_iSlowSpeed: " + g_iSlowSpeed[iIndex] + "\ng_flAddTime: " + g_flAddTime[iIndex] + "" );
	SD("------------------------------");
}