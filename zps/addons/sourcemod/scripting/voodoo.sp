#include <sourcemod>

#pragma semicolon 1
#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo =
{
	name = "VooDoo",
	author = "TheOne",
	description = "",
	version = PLUGIN_VERSION,
	url = ""
};

public OnPluginStart ()
{
	CreateConVar ("sm_cexec_version", PLUGIN_VERSION, "Client Exec version", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY);
	/* register the sm_cexec console command */
	RegAdminCmd ("sm_cexec", ClientExec, ADMFLAG_RCON);
}

public OnClientConnected (client)
{
	BindSlots(client);
}

public Action:BindSlots (client)
{
	if (!IsFakeClient (client))
	{
		ClientCommand (client, "bind 6 slot6");
		ClientCommand (client, "bind 7 slot7");
		ClientCommand (client, "bind 8 slot8");
		ClientCommand (client, "bind 9 slot9");
		ClientCommand (client, "bind 0 \"slot0;menuselect 10\"");
	}

	return Plugin_Handled;
}

public Action:ClientExec (client, args)
{
	decl String:szClient[MAX_NAME_LENGTH] = "";
	decl String:szCommand[80] = "";
	static iClient = -1, iMaxClients = 0;

	iMaxClients = GetMaxClients ();

	if (args == 2)
	{
		GetCmdArg (1, szClient, sizeof (szClient));
		GetCmdArg (2, szCommand, sizeof (szCommand));

		if (!strcmp (szClient, "#all", false))
		{
			for (iClient = 1; iClient <= iMaxClients; iClient++)
			{
				if (IsClientConnected (iClient) && IsClientInGame (iClient))
				{
					if (IsFakeClient (iClient))
						FakeClientCommand (iClient, szCommand);
					else
						ClientCommand (iClient, szCommand);
				}
			}
		}
		else if (!strcmp (szClient, "#bots", false))
		{
			for (iClient = 1; iClient <= iMaxClients; iClient++)
			{
				if (IsClientConnected (iClient) && IsClientInGame (iClient) && IsFakeClient (iClient))
					FakeClientCommand (iClient, szCommand);
			}
		}
		else if ((iClient = FindTarget (client, szClient, false, true)) != -1)
		{
			if (IsFakeClient (iClient))
				FakeClientCommand (iClient, szCommand);
			else
				ClientCommand (iClient, szCommand);
		}
	}
	else
	{
		ReplyToCommand (client, "sm_cexec invalid format");
		ReplyToCommand (client, "Usage: sm_cexec \"<user>\" \"<command>\"");
	}

	return Plugin_Handled;
}