concommand.Add( "primary", function( ply, cmd, args )
	local item = ply:PS2_GetItemInSlot( "Primary" )
	if item then
		ply:SelectWeapon( item.weaponClass )
	end
end )

concommand.Add( "secondary", function( ply, cmd, args )
	local item = ply:PS2_GetItemInSlot( "Secondary" )
	if item then
		ply:SelectWeapon( item.weaponClass )
	end
end )