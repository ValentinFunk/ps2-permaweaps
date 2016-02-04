hook.Add( "PlayerLoadout", "CheckForPendingSlots", function( ply )
  if not ply.PS2_Slots then
    ply.fullyLoadedPromise:Done( function( )
      for id, slot in pairs( ply.PS2_Slots ) do
        if Pointshop2.IsWeaponSlot( slot.slotName ) then
          local item = ply:PS2_GetItemInSlot( slot.slotName )
          if item then
            item:PlayerLoadout( ply )
          end
        end
      end
    end )
  end
end )
