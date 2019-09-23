void RegisterEntities()
{
	Entities::RegisterPickup("item_deliver");
	Entities::RegisterUse("item_deliver");
	Entities::RegisterDrop("item_deliver");

	Entities::RegisterUse("item_adrenaline");
	Entities::RegisterDrop("item_adrenaline");
	Entities::RegisterPickup("item_adrenaline");
}