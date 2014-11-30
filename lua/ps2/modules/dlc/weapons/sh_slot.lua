Pointshop2.AddEquipmentSlot( "Primary", function( item )
	--Check if the item is a Primary
	return instanceOf( Pointshop2.GetItemClassByName( "base_weapon" ), item ) and item.loadoutType == "Primary"
end )

Pointshop2.AddEquipmentSlot( "Secondary", function( item )
	--Check if the item is a Secondary
	return instanceOf( Pointshop2.GetItemClassByName( "base_weapon" ), item ) and item.loadoutType == "Secondary"
end )