Pointshop2.WeaponSlots = {} -- { slotName: true }

function Pointshop2.IsWeaponSlot( slotName )
	return Pointshop2.WeaponSlots[slotName]
end

function Pointshop2.GetWeaponSlotNames( )
	return table.GetKeys( Pointshop2.WeaponSlots )
end

function Pointshop2.AddWeaponsSlot( slotName )
	Pointshop2.WeaponSlots[slotName] = true

	Pointshop2.AddEquipmentSlot( slotName, function( item )
		--Check if the item is a Primary
		return instanceOf( Pointshop2.GetItemClassByName( "base_weapon" ), item ) and item.loadoutType == slotName
	end )
end

Pointshop2.AddWeaponsSlot( "Primary" )
Pointshop2.AddWeaponsSlot( "Secondary" )
