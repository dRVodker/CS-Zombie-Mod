void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

int iMaxPlayers;
bool bIsCSZM = false;
float flWaitTime;

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Anti-personnel Mine" );

	Events::Entities::OnEntityCreation.Hook( @FM_OnEntityCreation );
}

void OnMapInit()
{
	if ( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) )
	{
		bIsCSZM = true;

		flWaitTime = Globals.GetCurrentTime() + 0.05f;

		iMaxPlayers = Globals.GetMaxClients();

		Entities::RegisterUse( "weapon_fragmine" );
		Entities::RegisterOutput( "OnTakeDamage", "test_fragmine_active" );
		Entities::RegisterOutput( "OnTakeDamage", "test_fragmine_inactive" );

		Engine.PrecacheFile( sound, "weapons/slam/throw.wav" );
		Engine.PrecacheFile( sound, "weapons/slam/mine_mode.wav" );
		Engine.PrecacheFile( sound, "weapons/slam/buttonclick.wav" );

		Engine.PrecacheFile( model, "models/cszm/weapons/w_minefrag.mdl" );
		Engine.PrecacheFile( model, "models/cszm/weapons/v_minefrag.mdl" );
	}
}

void OnMapShutdown()
{
	if ( bIsCSZM == true ) 
	{
		bIsCSZM = false;
		Entities::RemoveRegisterUse( "weapon_fragmine" );
		Entities::RemoveRegisterOutput( "OnTakeDamage", "test_fragmine_active" );
	}
}

HookReturnCode FM_OnEntityCreation( const string &in strClassname, CBaseEntity@ pEntity )
{
	if ( bIsCSZM == false ) return HOOK_HANDLED;

	if ( Utils.StrContains( "weapon_machete", strClassname ) ) SpawnWepFragMine( pEntity );
/*
	if ( Utils.StrEql( pEntity.GetEntityName(), "fmine_explode" ) && Utils.StrEql( strClassname, "env_explosion" ) )
	{
		Engine.Ent_Fire_Ent( pEntity, "Addoutput", "classname weapon_fragmine" );
		Engine.Ent_Fire_Ent( pEntity, "Explode" );
	}
*/
	return HOOK_CONTINUE;
}

void OnEntityOutput( const string &in strOutput, CBaseEntity@ pActivator, CBaseEntity@ pCaller )
{
	if ( Utils.StrContains( "test_fragmine", pCaller.GetEntityName() ) && Utils.StrEql( strOutput, "OnTakeDamage" )  && bIsCSZM == true )
	{
		bool bExplode = false;

		pCaller.SetHealth( 9000000 );

		if ( pActivator.GetTeamNumber() != pCaller.GetOwner().GetTeamNumber() )
		{
			if ( pActivator.IsPlayer() == true )
			{
				pCaller.ChangeTeam( pActivator.GetTeamNumber() );
				pCaller.SetOwner( pActivator );
			}

			bExplode = true;
		}

		if ( pActivator is pCaller.GetOwner() ) bExplode = true;

		if ( bExplode == true ) ExplodeFragMine( pCaller );
	}
}

void OnItemDeliverUsed(CZP_Player@ pPlayer, CBaseEntity@ pEntity, int &in iEntityOutput)
{
	if ( bIsCSZM == false ) return;
	if ( pPlayer is null ) return;
	if ( pEntity is null ) return;

	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();
	
	int iIndex = pBaseEnt.entindex();

	if ( Utils.StrEql( pEntity.GetEntityName(), "weapon_fragmine" ) ) ThrowMine( iIndex, pPlayer, pEntity );
}

void ThrowMine( const int &in iIndex, CZP_Player@ pPlayer, CBaseEntity@ pEntity )
{
	CBasePlayer@ pPlrEnt = pPlayer.opCast();
	CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

	Vector vecMVelocity = pBaseEnt.GetAbsVelocity();

	Globals.AngleVectors(pBaseEnt.EyeAngles(), vecMVelocity);

	CEntityData@ FragMineIPD = EntityCreator::EntityData();
	FragMineIPD.Add("targetname", "test_fragmine_inactive");
	FragMineIPD.Add("model", "models/cszm/weapons/w_minefrag.mdl");
	FragMineIPD.Add("spawnflags", "10114");//9990
	FragMineIPD.Add("skin", "0");
	FragMineIPD.Add("overridescript", "mass,60,rotdamping,10000,damping,0,inertia,0,");
	FragMineIPD.Add("nodamageforces", "1");

	FragMineIPD.Add("addoutput", "targetname test_fragmine_preactive", true, "0.98");

	CBaseEntity@ pFragMine = EntityCreator::Create("prop_physics_override", Vector( 720, 1960, 108 ), QAngle(0, 0, 0), FragMineIPD);

	pFragMine.SetOwner( pBaseEnt );
	pFragMine.ChangeTeam( pBaseEnt.GetTeamNumber() );
	pFragMine.SetHealth( 9000000 );

	float angX = pBaseEnt.EyeAngles().x;
	float angY = pBaseEnt.EyeAngles().y;
	float angZ = pBaseEnt.EyeAngles().z;

	if ( angX > 30.0f ) angX = 30.0f;
	if ( angX < -30.0f ) angX = -30.0f;

	pFragMine.SetOutline( true, filter_entity, pBaseEnt.entindex(), Color(32, 245, 64), 384.0f, false, true);

	pFragMine.Teleport( Vector( pBaseEnt.EyePosition().x, pBaseEnt.EyePosition().y, pBaseEnt.EyePosition().z - 12 ), QAngle( angX, angY, angZ ), ( vecMVelocity * 225 ) );

	Engine.EmitSoundPosition(pFragMine.entindex(), "weapons/slam/throw.wav", Vector( pBaseEnt.EyePosition().x, pBaseEnt.EyePosition().y, pBaseEnt.EyePosition().z - 12 ), 0.5f, 65, 85);

	pEntity.SetEntityName( "used" + iIndex );
	Engine.Ent_Fire( "used" + iIndex, "addoutput", "itemstate 0" );
	Engine.Ent_Fire( "used" + iIndex, "kill", "0", "0.3" );
}

void SpawnWepFragMine( CBaseEntity@ pEntity )
{
	CEntityData@ WepFragMineIPD = EntityCreator::EntityData();
	WepFragMineIPD.Add( "targetname", "weapon_fragmine" );
	WepFragMineIPD.Add( "viewmodel", "models/cszm/weapons/v_minefrag.mdl" );
	WepFragMineIPD.Add( "model", "models/cszm/weapons/w_minefrag.mdl" );
	WepFragMineIPD.Add( "itemstate", "1" );
	WepFragMineIPD.Add( "isimportant", "0" );
	WepFragMineIPD.Add( "glowcolor", "0 128 245" );
	WepFragMineIPD.Add( "delivername", "FragMine" );
	WepFragMineIPD.Add( "sound_pickup", "Player.PickupWeapon" );
	WepFragMineIPD.Add( "printname", "vgui/images/fragmine" );

	CBaseEntity@ pWPM = EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), WepFragMineIPD);

	pEntity.SUB_Remove();
}

void OnProcessRound()
{
	if ( flWaitTime <= Globals.GetCurrentTime() && bIsCSZM == true )
	{
		flWaitTime = Globals.GetCurrentTime() + 0.05f;
		FragMineThink();
	}
}

void FragMineThink()
{
	CBaseEntity@ pFMine = null;

	while ( ( @pFMine = FindEntityByName( pFMine, "test_fragmine_inactive" ) ) !is null )
	{
		if ( pFMine.GetOwner() is null || pFMine.GetOwner().GetTeamNumber() != pFMine.GetTeamNumber() || pFMine.GetOwner().IsAlive() == false ) DefuseFragMine( pFMine, null );
	}

	while ( ( @pFMine = FindEntityByName( pFMine, "test_fragmine_preactive" ) ) !is null )
	{
		pFMine.SetOutline( true, filter_entity, pFMine.GetOwner().entindex(), Color(245, 32, 64), 384.0f, false, true);
		pFMine.SetEntityName( "test_fragmine_active" );
		pFMine.SetSkin( 1 );
		Engine.EmitSoundPosition( pFMine.entindex(), "weapons/slam/mine_mode.wav", pFMine.GetAbsOrigin(), 1.0f, 75, 105);
	}

	while ( ( @pFMine = FindEntityByName( pFMine, "test_fragmine_active" ) ) !is null )
	{
		if ( pFMine.GetOwner() is null || pFMine.GetOwner().GetTeamNumber() != pFMine.GetTeamNumber() || pFMine.GetOwner().IsAlive() == false )
		{
			DefuseFragMine( pFMine, null );
			continue;
		}

		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			CZP_Player@ pPlayer = ToZPPlayer( i );
							
			if ( pPlayer is null ) continue;

			bool bExplode = false;

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if ( pBaseEnt.Intersects( pFMine ) == true )
			{
				if ( pBaseEnt !is pFMine.GetOwner() && pFMine.GetTeamNumber() != pBaseEnt.GetTeamNumber() && pBaseEnt.IsAlive() == true ) bExplode = true;
				else if ( pBaseEnt is pFMine.GetOwner() ) bExplode = true;
			}

			if ( bExplode == true ) ExplodeFragMine( pFMine );
		}
	}
}

void ExplodeFragMine( CBaseEntity@ pFMine )
{
	CEntityData@ ExplodeIPD = EntityCreator::EntityData();
	ExplodeIPD.Add( "targetname", "fmine_explode" );
	ExplodeIPD.Add( "iMagnitude", "350" );
	ExplodeIPD.Add( "iRadiusOverride", "200" );
	ExplodeIPD.Add( "Addoutput", "classname weapon_fragmine", true );
	ExplodeIPD.Add( "Explode", "0", true );

	CBaseEntity@ pExplode = EntityCreator::Create("env_explosion", pFMine.GetAbsOrigin(), pFMine.GetAbsAngles(), ExplodeIPD);

	pExplode.SetOwner( pFMine.GetOwner() );

	pFMine.SUB_Remove();	
}

void DefuseFragMine( CBaseEntity@ pFMine, CZP_Player@ pPlayer )
{
	CEntityData@ WFMIPD = EntityCreator::EntityData();
	WFMIPD.Add( "targetname", "weapon_fragmine" );
	WFMIPD.Add( "viewmodel", "models/cszm/weapons/v_minefrag.mdl" );
	WFMIPD.Add( "model", "models/cszm/weapons/w_minefrag.mdl" );
	WFMIPD.Add( "itemstate", "1" );
	WFMIPD.Add( "isimportant", "0" );
	WFMIPD.Add( "glowcolor", "0 128 245" );
	WFMIPD.Add( "delivername", "FragMine" );
	WFMIPD.Add( "sound_pickup", "HL2Player.PickupWeapon" );
	WFMIPD.Add( "printname", "vgui/images/fragmine" );

	CBaseEntity@ pWPM = EntityCreator::Create("item_deliver", pFMine.GetAbsOrigin(), pFMine.GetAbsAngles(), WFMIPD);

	pFMine.SUB_Remove();

	Engine.EmitSoundPosition(pWPM.entindex(), "weapons/slam/buttonclick.wav", pFMine.GetAbsOrigin(), 0.85f, 65, 105);
	
	if ( pPlayer !is null ) pPlayer.PutToInventory( pWPM );
}