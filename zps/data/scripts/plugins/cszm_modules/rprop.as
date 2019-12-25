//Список ентити, которые будут удаляться, если игрок заспавнится внутри этих ентити
array<string> g_strPropsCN = 
{
    "prop_physics_override",
    "prop_physics_multiplayer",
    "prop_physics",
    "func_physbox",
    "prop_ragdoll",
    "prop_barricade",
    "prop_itemcrate"
};

void RemoveProp(CBaseEntity@ pPlayer)
{
	CBaseEntity@ pProp = null;

    uint iLength = g_strPropsCN.length();

    for (uint i = 0; i < iLength; i++)
    {
        while ((@pProp = FindEntityByClassname(pProp, g_strPropsCN[i])) !is null)
        {
            if (pProp.Intersects(pPlayer) && pProp !is null)
            {
                if (Utils.StrEql("prop_itemcrate", g_strPropsCN[i]))
                {
                    Engine.Ent_Fire_Ent(pProp, "break");
                }

                else
                {
                    pProp.SUB_Remove();
                }
            }
        }
    }
}