Pointshop2.WeaponSlots = {} -- { slotName: true }

function Pointshop2.IsWeaponSlot( slotName )
	return Pointshop2.WeaponSlots[slotName]
end

function Pointshop2.GetWeaponSlotNames( )
	return table.GetKeys( Pointshop2.WeaponSlots )
end

function Pointshop2.AddWeaponsSlot( slotName, replaceWeapon )
	Pointshop2.WeaponSlots[slotName] = true
	local slot = {}
	slot.order = math.huge
	slot.canHoldItem = function( item )
		--Check if the item is a Primary
		return instanceOf( Pointshop2.GetItemClassByName( "base_weapon" ), item ) and item.loadoutType == slotName
	end
	slot.name = slotName
	slot.replaceWeapon = replaceWeapon
	slot._autoAdded = true

	Pointshop2.AddEquipmentSlotEx( slot )
end

function Pointshop2.CheckWeaponReplace( item )
	local ply = item:GetOwner()
	local slotName = Pointshop2.FindSlotThatContains( ply, item )
	local slot = Pointshop2.FindEquipmentSlot( slotName )
	if not slot then
		KLogf( 1, "Couldn't find slot %s for item %s", tostring(slotName), tostring(item:GetPrintName()))
		return
	end

	if slot.replaceWeapon and slot.replaceWeapon != "false" and not weapons.GetStored( slot.replaceWeapon ) then
		KLogf( 1, "You have set an invalid weapon class %s in your Pointshop 2 Weapon Slot settings for slot %s. Weapon replacing will not work.", tostring(slot.replaceWeapon), tostring(slotName))
	end

	if slot and slot.replaceWeapon and slot.replaceWeapon != "false" then
		ply:StripWeapon( slot.replaceWeapon )
		timer.Simple(0.01, function() ply:SelectWeapon( item.weaponClass ) end)
	end
end

hook.Add( "PS2_OnSettingsUpdate", "LoadTheSlots", function( )
	-- Remove previously generated slots
	for k, v in pairs(Pointshop2.EquipmentSlots) do
		if v._autoAdded then
				Pointshop2.RemoveEquipmentSlot(v.name)
		end
	end

	-- Add everything
	local slotsSettings = Pointshop2.GetSetting( "PS2 Weapons", "WeaponSlots.Slots" )
	for k, v in pairs( slotsSettings ) do
		Pointshop2.AddWeaponsSlot( k, v.replaces )
	end
end )
