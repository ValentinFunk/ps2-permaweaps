util.AddNetworkString("SlotsRemoved")

local function refundSlotItems( slots, kPlayerId )
  if #slots == 0 then
    return Promise.Resolve()
  end

  local itemIds = {}
  local slotIds = {}
  for k, v in pairs(slots) do
    table.insert(itemIds, v.itemId)
    table.insert(slotIds, v.id)
  end

  local ply
  for k, v in pairs(player.GetAll()) do
    if v.kPlayerId == kPlayerId then
      ply = v
    end
  end

  return Promise.Resolve()
  :Then(function()
    if ply then
      return ply.fullyLoadedPromise
    end
  end)
  :Then(function()
    return KInventory.Item.getDbEntries("WHERE kinv_items.id IN (" .. table.concat(itemIds, ",") .. ")")
  end)
  :Then(function(items)
    local promises = {}
    for k, item in pairs(items) do
      local amount, currency = 0, "points"
      --New way
    	if item.purchaseData then
    		item.purchaseData.amount = item.purchaseData.amount or 0
    		item.purchaseData.currency = item.purchaseData.currency or "points"
    		amount, currency = math.floor( item.purchaseData.amount ), item.purchaseData.currency
    	end

    	--Legacy way
    	if item.class.Price.points then
    		amount, currency = math.floor( item.class.Price.points ), "points"
    	elseif item.class.Price.premiumPoints then
    		amount, currency = math.floor( item.class.Price.premiumPoints ), "premiumPoints"
    	end
      if ply then
        table.insert(promises, Pointshop2Controller:getInstance( ):addToPlayerWallet( ply, currency, amount ))
        Pointshop2Controller:getInstance():startView( "Pointshop2View", "playerUnequipItem", player.GetAll( ), ply, item.id )
        local slot
        for k, v in pairs(ply.PS2_Slots) do
          if v.itemId == item.id then
            slot = v
          end
        end
        slot.Item = nil
        slot.itemId = nil
        ply.PS2_Slots[slot.id] = nil
        Pointshop2Controller:getInstance():startView( "Pointshop2View", "slotChanged", ply, slot )
    		KInventory.ITEMS[item.id]:OnHolster( )
        KInventory.ITEMS[item.id] = nil
        Pointshop2.LogCacheEvent('REMOVE', 'removeSlot-refundSlotItem', item.id)
        Pointshop2.DeactivateItemHooks(item)
      else
        table.insert(promises, Pointshop2.DB.DoQuery(Format("UPDATE ps2_wallet SET %s = %s + %i WHERE ownerId = %i", currency, currency, amount, kPlayerId)))
      end
    end
    return WhenAllFinished(promises)
  end)
  :Then(function()
    return WhenAllFinished{
      Pointshop2.DB.DoQuery("UPDATE ps2_equipmentslot SET itemId = NULL WHERE id IN (" .. table.concat(slotIds, ",") .. ")"),
      Pointshop2.DB.DoQuery("DELETE FROM kinv_items WHERE id IN (" .. table.concat(itemIds, ",") .. ")")
    }
  end)
end

local function relocateItems( slots, inventoryId, kPlayerId )
  if #slots == 0 then
    return Promise.Resolve()
  end

  local ply
  for k, v in pairs(player.GetAll()) do
    if v.kPlayerId == kPlayerId then
      ply = v
    end
  end

  return Promise.Resolve()
  :Then(function()
    if ply then
      return ply.fullyLoadedPromise
    end
  end)
  :Then(function()
    if ply then
      local promises = {}
      for k, v in pairs(slots) do
        table.insert(promises, Pointshop2Controller:getInstance():unequipItem(ply, v.slotName))
      end
      return WhenAllFinished(promises)
    else
      local itemIds = {}
      local slotIds = {}
      for k, v in pairs(slots) do
        table.insert(itemIds, v.itemId)
        table.insert(slotIds, v.id)
      end

      return WhenAllFinished{
        Pointshop2.DB.DoQuery("UPDATE kinv_items SET inventory_id = " .. tonumber(inventoryId) .. " WHERE id IN (" .. table.concat(itemIds, ",") .. ")"),
        Pointshop2.DB.DoQuery("UPDATE ps2_equipmentslot SET itemId = NULL WHERE id IN (" .. table.concat(slotIds, ",") .. ")")
      }
    end
  end)
end

function Pointshop2.RemoveSlots(slotNames)
  if #slotNames == 0 then
    return Promise.Resolve()
  end

  local saveSlotNames = {}
  for k, v in pairs(slotNames) do
    table.insert(saveSlotNames, Pointshop2.DB.SQLStr(v))
  end

  local affectedSlotsMap, affectedSlotsIds
  return Pointshop2.DB.DoQuery("SELECT * FROM ps2_equipmentslot WHERE slotName in (" .. table.concat(saveSlotNames, ",") .. ") and itemId IS NOT NULL")
  :Then( function( result )
    local ownerIds = {}
    for k, v in pairs( result or {} ) do
      table.insert(ownerIds, v.ownerId)
    end

    affectedSlotsIds = {}
    affectedSlotsMap = {}
    for k, v in pairs(result or {}) do
      affectedSlotsMap[v.ownerId] = affectedSlotsMap[v.ownerId] or {}
      table.insert(affectedSlotsMap[v.ownerId], v)
      table.insert(affectedSlotsIds, v.id)
    end

    if #ownerIds > 0 then
      return Pointshop2.DB.DoQuery([[SELECT inv.id as id, inv.numSlots as numSlots, inv.ownerId as ownerId, COUNT(items.id) as slotsTaken FROM
        inventories inv, kinv_items items
        WHERE items.inventory_id = inv.id AND inv.ownerId IN (]] .. table.concat(ownerIds, ",") .. ") GROUP BY inv.ownerId")
    end
  end )
  :Then(function(inventories)
    if not inventories then return end

    local promises = {}
    for k, inv in pairs(inventories) do
      local plyAffectedSlots = affectedSlotsMap[inv.ownerId]
      local slotDifference = inv.numSlots - ( inv.slotsTaken + #plyAffectedSlots )
      if slotDifference > 0 then
        table.insert(promises, relocateItems(plyAffectedSlots, inv.id, inv.ownerId))
      else
        local slotsToRelocate, slotsToRefund = {}, {}
        local toRelocateCount = #plyAffectedSlots + slotDifference
        for key, slot in pairs(plyAffectedSlots) do
          if key <= toRelocateCount then
            table.insert(slotsToRelocate, slot)
          else
            table.insert(slotsToRefund, slot)
          end
        end
        table.insert(promises, refundSlotItems(slotsToRefund, inv.ownerId))
        table.insert(promises, relocateItems(slotsToRelocate, inv.id, inv.ownerId))
      end
    end
  end):Then(function()
    if #affectedSlotsIds > 0 then
      return Pointshop2.DB.DoQuery("DELETE FROM ps2_equipmentslot WHERE slotName IN (" .. table.concat(saveSlotNames, ",") .. ")")
    end
  end):Done(print):Fail(function(err) KLog(1, err) end)
end

net.Receive( "SlotsRemoved", function( len, ply )
  local slotNames = net.ReadTable()
  if not PermissionInterface.query( ply, "pointshop2 manageitems" ) then
    ply:PS2_DisplayError("You do not have the pointshop2 manageitems permission.")
    return
  end

  Pointshop2.RemoveSlots(slotNames)
end )
