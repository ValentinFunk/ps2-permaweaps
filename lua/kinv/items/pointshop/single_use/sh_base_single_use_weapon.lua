ITEM.PrintName = "Pointshop Single Use Weapon Base"
ITEM.baseClass = "base_single_use"

ITEM.weaponClass = "weapon_357"
ITEM.category = "Weapons"

function ITEM:CanBeUsed( )	
	local canBeUsed, reason = ITEM.super.CanBeUsed( self ) 
	if not canBeUsed then
		return false, reason
	end
	
	local ply = self:GetOwner( )
	if not ply:Alive( ) or ( ply.IsSpec and ply:IsSpec( ) ) then
		return false, "You need to be alive to use this item"
	end
	return true
end

function ITEM:OnUse( )
	self:GetOwner( ):Give( self.weaponClass )
end

function ITEM.static:GetPointshopIconControl( )
	return "DPointshopWeaponIcon"
end

function ITEM.static.getPersistence( )
	return Pointshop2.SingleUseWeaponPersistence
end

function ITEM.static.generateFromPersistence( itemTable, persistenceItem )
	ITEM.super.generateFromPersistence( itemTable, persistenceItem.ItemPersistence )
	itemTable.weaponClass = persistenceItem.weaponClass
end

function ITEM.static.GetPointshopIconDimensions( )
	return Pointshop2.GenerateIconSize( 4, 4 )
end

function ITEM:getIcon( )
	self.icon = vgui.Create( "DPointshopWeaponInvIcon" )
	self.icon:SetItem( self )
	self.icon:SetSize( 64, 64 )
	return self.icon
end