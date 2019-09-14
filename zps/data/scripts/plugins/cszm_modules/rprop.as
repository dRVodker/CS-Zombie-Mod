//List of entity classnames which will be removed if a player spawns inside them
array<string> g_strPropsCN = 
{
    "prop_physics_override",
    "prop_physics_multiplayer",
    "prop_physics",
    "func_physbox",
    "prop_ragdoll",
    "prop_barricade"
};

void RemoveProp( CBaseEntity@ pPlayer )
{
	CBaseEntity@ pProp = null;

    for ( uint i = 0; i < g_strPropsCN.length(); i++ )
    {
        while ( ( @pProp = FindEntityByClassname( pProp, g_strPropsCN[i] ) ) !is null )
        {
            if ( pProp.Intersects( pPlayer ) == true  && pProp !is null )
            {
                pProp.SUB_Remove();
            }
        }
    }
}