void CheckForHoldout(const string &in MapName)
{
	if (Utils.StrContains("heavyice", MapName) || Utils.StrContains("sunshine", MapName))
	{
		UnlimitedRandom = true;
		g_strStartWeapons.resize(iStartWeaponLength);
		g_strStartWeapons.insertLast("weapon_mp5");
	}
	else
	{
		UnlimitedRandom = false;
		g_strStartWeapons.resize(iStartWeaponLength);
	}
}