void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

void CD( const string &in strMsg )
{
	Chat.CenterMessage( all, strMsg );
}

int iMaxPlayers;
bool bIsCSZM = false;
float flWaitTime;
float flWaitTimeTL;

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
		flWaitTimeTL = Globals.GetCurrentTime() + 0.01f;

		iMaxPlayers = Globals.GetMaxClients();

		Entities::RegisterUse( "item_deliver" );
		Entities::RegisterDrop( "item_deliver" );
		Entities::RegisterDamaged( "test_fragmine_active" );
		Entities::RegisterDamaged( "test_fragmine_inactive" );

		Engine.PrecacheFile( sound, "weapons/slam/throw.wav" );
		Engine.PrecacheFile( sound, "weapons/slam/mine_mode.wav" );
		Engine.PrecacheFile( sound, "weapons/slam/buttonclick.wav" );
		Engine.PrecacheFile( sound, "weapons/357/357_reload3.wav" );

		Engine.PrecacheFile( model, "models/cszm/weapons/w_minefrag.mdl" );
		Engine.PrecacheFile( model, "models/cszm/weapons/v_minefrag.mdl" );
	}
}

void OnMapShutdown()
{
	if ( bIsCSZM == true ) 
	{
		bIsCSZM = false;
		Entities::RemoveRegisterUse( "item_deliver" );
		Entities::RemoveRegisterDrop( "item_deliver" );
		Entities::RemoveRegisterOutput( "OnTakeDamage", "test_fragmine_active" );

		flWaitTime = 0.0f;
		flWaitTimeTL = 0.0f;
	}
}

void OnProcessRound()
{
	if ( bIsCSZM == true )
	{
		if ( flWaitTime <= Globals.GetCurrentTime() )
		{
			flWaitTime = Globals.GetCurrentTime() + 0.05f;
			FragMineThink();
		}

		if ( flWaitTimeTL <= Globals.GetCurrentTime() )
		{
			flWaitTimeTL = Globals.GetCurrentTime() + 0.01f;

			for ( int i = 1; i <= iMaxPlayers; i++ )
			{
				CZP_Player@ pPlayer = ToZPPlayer( i );
								
				if ( pPlayer is null ) continue;

				CBasePlayer@ pPlrEnt = pPlayer.opCast();
				CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

				if ( pPlayer.m_afButtonPressed == 32 && pBaseEnt.IsGrounded() && pBaseEnt.GetTeamNumber() == 2 )
				{
					Vector Forward = pBaseEnt.EyePosition();
					Vector StartPos;
					Vector EndPos;

					Globals.AngleVectors( pBaseEnt.EyeAngles(), Forward );

					StartPos = pBaseEnt.EyePosition() + Forward * 32;
					EndPos = StartPos + Forward * 40;

					CGameTrace trace;

					Utils.TraceLine( StartPos, EndPos, MASK_ALL, null, COLLISION_GROUP_NONE, trace );

					if ( trace.DidHitNonWorldEntity() )
					{
						CBaseEntity@ pTEntity = trace.m_pEnt;

						if ( pTEntity !is null )
						{
							if ( Utils.StrContains( "test_fragmine", pTEntity.GetEntityName() ) ) 
							{
								if ( pTEntity.GetOwner() is pBaseEnt || pTEntity.GetOwner() is null ) DefuseFragMine( pTEntity, pPlayer );
								else Chat.PrintToChatPlayer( pPlrEnt, "This frag mine is not yours, you can't disarm and pick it up!");
							}
						}
					}
				}
			}
		}
	}
}

HookReturnCode FM_OnEntityCreation( const string &in strClassname, CBaseEntity@ pEntity )
{
	if ( bIsCSZM == false ) return HOOK_HANDLED;

	if ( Utils.StrContains( "weapon_machete", strClassname ) ) SpawnWepFragMine( pEntity );

	return HOOK_CONTINUE;
}

void OnEntityDamaged( CBaseEntity@ pAttacker, CBaseEntity@ pEntity )
{
	if ( bIsCSZM == false ) return;
	if ( pAttacker is null ) return;
	if ( pEntity is null ) return;

	if ( Utils.StrContains( "test_fragmine", pEntity.GetEntityName() ) )
	{
		bool bExplode = true;

		if ( pEntity.GetOwner() !is null )
		{
			if ( pAttacker.GetTeamNumber() == 2 && pAttacker !is pEntity.GetOwner() ) bExplode = false;
			pEntity.ChangeTeam( 2 );
		}

		else
		{
			pEntity.ChangeTeam( pAttacker.GetTeamNumber() );
			pEntity.SetOwner( pAttacker );
		}

		if ( bExplode == true ) ExplodeFragMine( pEntity );
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

void OnEntityDropped(CZP_Player@ pPlayer, CBaseEntity@ pEntity)
{
	if ( bIsCSZM == false ) return;
	if ( pPlayer is null ) return;
	if ( pEntity is null ) return;

	if ( Utils.StrEql( pEntity.GetEntityName(), "wf_used" ) ) pEntity.SUB_Remove();
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

//	CBaseEntity@ pFragMine = EntityCreator::Create("prop_physics_override", Vector( 0, 0, 0 ), QAngle(0, 0, 0), FragMineIPD);
	CBaseEntity@ pFragMine = EntityCreator::Create("projectile_nonhurtable", Vector( 0, 0, 0 ), QAngle(0, 0, 0), FragMineIPD);

	pFragMine.SetOwner( pBaseEnt );
	pFragMine.ChangeTeam( pBaseEnt.GetTeamNumber() );
	pFragMine.SetHealth( 9000000 );

	float angX = pBaseEnt.EyeAngles().x;
	float angY = pBaseEnt.EyeAngles().y;
	float angZ = pBaseEnt.EyeAngles().z;

	if ( angX > 30.0f ) angX = 30.0f;
	if ( angX < -30.0f ) angX = -30.0f;

	pFragMine.SetOutline( true, filter_entity, pBaseEnt.entindex(), Color(32, 245, 64), 384.0f, false, true);

	pFragMine.Teleport( Vector( pBaseEnt.EyePosition().x, pBaseEnt.EyePosition().y, pBaseEnt.EyePosition().z - 12 ), QAngle( angX, angY, angZ ), pBaseEnt.GetAbsVelocity() + ( vecMVelocity * 225 ) );

	Engine.EmitSoundPosition(pFragMine.entindex(), "weapons/slam/throw.wav", Vector( pBaseEnt.EyePosition().x, pBaseEnt.EyePosition().y, pBaseEnt.EyePosition().z - 12 ), 0.5f, 65, 85);

	pEntity.SetRenderMode( kRenderNone );
	pEntity.SetEntityName( "wf_used" + iIndex );

	Engine.Ent_Fire( "wf_used" + iIndex, "addoutput", "itemstate 0" );
	Engine.Ent_Fire( "wf_used" + iIndex, "addoutput", "rendermode 10" );
	Engine.Ent_Fire( "wf_used" + iIndex, "kill", "0", "0.3" );
}

void SpawnWepFragMine( CBaseEntity@ pEntity )
{
	CEntityData@ WepFragMineIPD = EntityCreator::EntityData();
	WepFragMineIPD.Add( "targetname", "weapon_fragmine" );
	WepFragMineIPD.Add( "viewmodel", "models/cszm/weapons/v_minefrag.mdl" );
	WepFragMineIPD.Add( "model", "models/cszm/weapons/w_minefrag.mdl" );
	WepFragMineIPD.Add( "itemstate", "1" );
	WepFragMineIPD.Add( "isimportant", "0" );
	WepFragMineIPD.Add( "carrystate", "6" );
	WepFragMineIPD.Add( "glowcolor", "0 128 245" );
	WepFragMineIPD.Add( "delivername", "FragMine" );
	WepFragMineIPD.Add( "sound_pickup", "Player.PickupWeapon" );
	WepFragMineIPD.Add( "printname", "vgui/images/fragmine" );
	WepFragMineIPD.Add( "weight", "5" );

	WepFragMineIPD.Add( "DisableDamageForces", "0", true );

	EntityCreator::Create("item_deliver", pEntity.GetAbsOrigin(), pEntity.GetAbsAngles(), WepFragMineIPD);

	pEntity.SUB_Remove();
}

void FragMineThink()
{
	CBaseEntity@ pFMine = null;

	while ( ( @pFMine = FindEntityByName( pFMine, "test_fragmine_inactive" ) ) !is null )
	{
		if ( pFMine.GetOwner() !is null )
		{
			if ( pFMine.GetTeamNumber() != pFMine.GetOwner().GetTeamNumber() || pFMine.GetOwner().IsAlive() == false )
			{
				pFMine.SetOwner( null );
				pFMine.SetOutline( true, filter_team, 2, Color(245, 245, 245), 512.0f, false, true );
			}
		}
	}

	while ( ( @pFMine = FindEntityByName( pFMine, "test_fragmine_preactive" ) ) !is null )
	{
		if ( pFMine.GetOwner() !is null ) pFMine.SetOutline( true, filter_entity, pFMine.GetOwner().entindex(), Color(245, 32, 64), 384.0f, false, true);

		pFMine.SetEntityName( "test_fragmine_active" );
		pFMine.SetSkin( 1 );
		Engine.EmitSoundPosition( pFMine.entindex(), "weapons/slam/mine_mode.wav", pFMine.GetAbsOrigin(), 1.0f, 75, 105);
	}

	while ( ( @pFMine = FindEntityByName( pFMine, "test_fragmine_active" ) ) !is null )
	{
		if ( pFMine.GetOwner() !is null )
		{
			if ( pFMine.GetTeamNumber() != pFMine.GetOwner().GetTeamNumber() || pFMine.GetOwner().IsAlive() == false )
			{
				pFMine.SetOwner( null );
				pFMine.SetOutline( true, filter_team, 2, Color(245, 245, 245), 512.0f, false, true );
			}
		}

		for ( int i = 1; i <= iMaxPlayers; i++ )
		{
			CZP_Player@ pPlayer = ToZPPlayer( i );
									
			if ( pPlayer is null ) continue;

			CBasePlayer@ pPlrEnt = pPlayer.opCast();
			CBaseEntity@ pBaseEnt = pPlrEnt.opCast();

			if ( pBaseEnt.Intersects( pFMine ) == true && pBaseEnt.IsAlive() == true )
			{
				if ( pFMine.GetOwner() is pBaseEnt ) 
				{
					ExplodeFragMine( pFMine );
					return;
				}

				else if ( pBaseEnt.GetTeamNumber() == pFMine.GetTeamNumber() ) continue;

				if ( pFMine.GetTeamNumber() != pBaseEnt.GetTeamNumber() ) ExplodeFragMine( pFMine );
			}
		}			
	}
}

void ExplodeFragMine( CBaseEntity@ pFMine )
{
	pFMine.SetEntityName( "fragmine_detonation" );
	
	CEntityData@ ExplodeIPD = EntityCreator::EntityData();
	ExplodeIPD.Add( "targetname", "fmine_explode" );
	ExplodeIPD.Add( "iMagnitude", "350" );
	ExplodeIPD.Add( "iRadiusOverride", "200" );
	ExplodeIPD.Add( "Addoutput", "classname weapon_fragmine", true );
	ExplodeIPD.Add( "Explode", "0", true );

	CBaseEntity@ pExplode = EntityCreator::Create("env_explosion", pFMine.GetAbsOrigin(), pFMine.GetAbsAngles(), ExplodeIPD);

	if ( pFMine.GetOwner() !is null ) 
	{
		pExplode.SetOwner( pFMine.GetOwner() );
		pExplode.ChangeTeam( pFMine.GetOwner().GetTeamNumber() );
	}

	else 
	{
		pExplode.SetOwner( null );
		pExplode.ChangeTeam( 2 );
	}

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

	Engine.EmitSoundPosition(pWPM.entindex(), "weapons/slam/buttonclick.wav", pFMine.GetAbsOrigin(), 0.85f, 60, 105);
	Engine.EmitSoundPosition(pWPM.entindex(), "weapons/357/357_reload3.wav", pFMine.GetAbsOrigin(), 0.9f, 70, 105);
	
	if ( pPlayer !is null ) pPlayer.PutToInventory( pWPM );
}
/*
void CreateSPR( Vector vecOrigin )
{
	const int iR = 245;
	const int iG = Math::RandomInt(32, 48);
	const int iB = Math::RandomInt(32, 48);

	CEntityData@ FFSpriteIPD = EntityCreator::EntityData();

	FFSpriteIPD.Add("targetname", "test_sprite");
	FFSpriteIPD.Add("model", "sprites/light_glow01.vmt");
	FFSpriteIPD.Add("rendercolor", iR + " " + iG + " " + iB);
	FFSpriteIPD.Add("rendermode", "5");
	FFSpriteIPD.Add("renderamt", "240");
	FFSpriteIPD.Add("scale", "0.1");
	FFSpriteIPD.Add("spawnflags", "1");
	FFSpriteIPD.Add("framerate", "0");


	FFSpriteIPD.Add("kill", "0", true, "2.14");

	EntityCreator::Create( "env_sprite", vecOrigin, QAngle(0, 0, 0), FFSpriteIPD );
}
*/