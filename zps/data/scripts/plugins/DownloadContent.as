void OnPluginInit()
{
	PluginData::SetVersion("1.0");
	PluginData::SetAuthor("dR.Vodker");
	PluginData::SetName("-=Download Content=-");
}

void OnMapInit()
{
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/contagion_mossberg590.vmt");
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/mossberg590_diff.vtf");
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/mossberg590_exp.vtf");
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/mossberg590_norm.vtf");

    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/mossy_grip_diff.vmt");
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/mossy_grip_diff.vtf");
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/mossy_grip_exp.vtf");
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/mossy_grip_norm.vtf");

    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/shell_diff.vmt");
    Engine.AddToDownloadTable("materials/models/weapons/custom/v_mossberg/shell_diff.vtf");

    Engine.AddToDownloadTable("materials/models/weapons/custom/w_mossberg/contagion_mossberg590.vmt");
    Engine.AddToDownloadTable("materials/models/weapons/custom/w_mossberg/mossberg590_diff.vtf");
    Engine.AddToDownloadTable("materials/models/weapons/custom/w_mossberg/mossberg590_norm.vtf");
    Engine.AddToDownloadTable("materials/models/weapons/custom/w_mossberg/mossy_grip_diff.vmt");
    Engine.AddToDownloadTable("materials/models/weapons/custom/w_mossberg/mossy_grip_diff.vtf");
    Engine.AddToDownloadTable("materials/models/weapons/custom/w_mossberg/mossy_grip_norm.vtf");

    Engine.AddToDownloadTable("models/weapons/custom/v_mossberg.dx80.vtx");
    Engine.AddToDownloadTable("models/weapons/custom/v_mossberg.dx90.vtx");
    Engine.AddToDownloadTable("models/weapons/custom/v_mossberg.mdl");
    Engine.AddToDownloadTable("models/weapons/custom/v_mossberg.sw.vtx");
    Engine.AddToDownloadTable("models/weapons/custom/v_mossberg.vvd");

    Engine.AddToDownloadTable("models/weapons/custom/w_mossberg.dx80.vtx");
    Engine.AddToDownloadTable("models/weapons/custom/w_mossberg.dx90.vtx");
    Engine.AddToDownloadTable("models/weapons/custom/w_mossberg.mdl");
    Engine.AddToDownloadTable("models/weapons/custom/w_mossberg.sw.vtx");
    Engine.AddToDownloadTable("models/weapons/custom/w_mossberg.vvd");
    Engine.AddToDownloadTable("models/weapons/custom/w_mossberg.phy");
}