//some data
bool bIsCSZM = false;

array<string> g_strEntities = 
{
	"prop_door_rotating", //0
	"prop_physics_multiplayer", //1
	"prop_physics_override", //2
	"prop_physics", //3
	"func_door_rotating", //4
	"func_door", //5
	"func_breakable", //6
	"func_physbox", //7
	"prop_barricade" //8
};

void SD( const string &in strMSG )
{
	Chat.PrintToChat( all, strMSG );
}

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "dR.Vodker" );
	PluginData::SetName( "CSZM - Show HP of Breakables" );

	//Events
	Events::Custom::OnEntityDamaged.Hook( @CSZM_OnEntDamaged );
}

void OnMapInit()
{	
	if( Utils.StrContains( "cszm", Globals.GetCurrentMapName() ) ) bIsCSZM = true;
}

HookReturnCode CSZM_OnEntDamaged( CBaseEntity@ pEntity, CTakeDamageInfo &out DamageInfo )
{
	if ( bIsCSZM == false ) return HOOK_HANDLED;

	bool bIsUnbreakable = false; 

	if ( Utils.StrContains( "unbrk", pEntity.GetEntityName() ) || Utils.StrContains( "unbreakable", pEntity.GetEntityName() ) ) bIsUnbreakable = true;

	//Show HP
	CBaseEntity@ pAttacker = DamageInfo.GetAttacker();
	if ( pAttacker.IsPlayer() && pAttacker.GetTeamNumber() == 3 && bIsUnbreakable != true )
	{
		int iSlot = pAttacker.entindex();
		bool bIsValid = false;

		for ( uint i = 0; i < g_strEntities.length(); i++ )
		{
			if ( bIsValid ) continue;
			if ( Utils.StrEql( pEntity.GetClassname(), g_strEntities[i] ) ) bIsValid = true;
		}

		if ( bIsValid )
		{
			bool bLeft = false;
			float flDMG = DamageInfo.GetDamage();
			float flHP = pEntity.GetHealth();
			float flResult = flHP - flDMG;

			if ( flDMG > 0 ) bLeft = true;

			if ( flResult > 0 ) ShowHP( ToBasePlayer( iSlot ), int( flResult ), bLeft, false );
			else ShowHP( ToBasePlayer( iSlot ), int( flResult ), bLeft, true );
		}
	}

	//Other stuff
	if ( Utils.StrContains( "physics", pEntity.GetClassname() ) )
	{
		string MDLName = pEntity.GetModelName();
		int DMGType = DamageInfo.GetDamageType();
		float DMG = DamageInfo.GetDamage();
		if ( pAttacker.IsPlayer() && pAttacker.GetTeamNumber() == 2 )
		{
			if ( DMGType == ( 1<<12 ) + ( 1<<23 ) + ( 1<<1 ) || DMGType == ( 1<<13 ) + ( 1<<23 ) + ( 1<<1 ) || DMGType == ( 1<<12 ) + (1<<29) + ( 1<<23 ) + ( 1<<1 ) )
			{
				if ( 
					Utils.StrContains( "propanecanister001a", MDLName ) ||
					Utils.StrContains( "oildrum001_explosive", MDLName ) ||
					Utils.StrContains( "propane_tank001a", MDLName ) ||
					Utils.StrContains( "gascan001a", MDLName ) ) return HOOK_HANDLED;
				
				DamageInfo.SetDamage( DMG * 0.021f );
			}
		}
	}

	//Break "prop_itemcrate" if punt
	if ( Utils.StrEql( pEntity.GetClassname(), "prop_itemcrate" ) && DamageInfo.GetDamageType() == (1<<23) )
	{
		DamageInfo.SetDamageType( 1<<13 );
		DamageInfo.SetDamage( pEntity.GetHealth() );
		return HOOK_HANDLED;
	}

	//50% of damage resist for "prop_barricade"
	if ( Utils.StrEql( pEntity.GetClassname(), "prop_barricade" ) )
	{
		DamageInfo.SetDamage( DamageInfo.GetDamage() * 0.5f );
		return HOOK_HANDLED;
	}

	//Don't deal any damage if unbreakable
	if ( bIsUnbreakable )
	{
		DamageInfo.SetDamageType( 1<<23 );
		DamageInfo.SetDamage( 0 );
		return HOOK_HANDLED;
	}

	return HOOK_HANDLED;
}

void ShowHP( CBasePlayer@ pBasePlayer, const int &in iHP, const bool &in bLeft, const bool &in bHide )
{
	if ( bHide )
	{
		Chat.CenterMessagePlayer( pBasePlayer, "" );
		return;
	}
	else
	{
		string strLeft = "";
		if ( bLeft ) strLeft = " Left";
		Chat.CenterMessagePlayer( pBasePlayer, iHP + " HP" + strLeft );
	}
}