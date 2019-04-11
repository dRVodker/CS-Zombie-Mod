void SpawnAntidote(Vector &in vecOrigin, QAngle &in angAngle)
{
	CEntityData@ AntidoteIPD = EntityCreator::EntityData();
	AntidoteIPD.Add("targetname", "antidote");

	EntityCreator::Create("item_pills", vecOrigin, angAngle, AntidoteIPD);
}