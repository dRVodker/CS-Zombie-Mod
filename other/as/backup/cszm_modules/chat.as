void SD(const string &in strMSG)
{
	Chat.PrintToChat(all, strMSG);
}

void CD(const string &in strMsg)
{
	Chat.CenterMessage(all, strMsg);
}

void EmitCountdownSound(const int &in iNumber)
{
	Engine.EmitSound("CS_FVox" + iNumber);
}