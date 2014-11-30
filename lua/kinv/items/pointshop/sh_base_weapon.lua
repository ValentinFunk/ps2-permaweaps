ITEM.PrintName = "Pointshop Weapon Base"
ITEM.baseClass = "base_pointshop_item"

ITEM.weaponClass = "weapon_357"
ITEM.loadoutType = "Secondary"

ITEM.category = "Weapons"

/*
	Inventory icon
*/
function ITEM:getIcon( )
	self.icon = vgui.Create( "DPointshopWeaponInvIcon" )
	self.icon:SetItem( self )
	self.icon:SetSize( 64, 64 )
	return self.icon
end

function ITEM:OnEquip( )
end

function ITEM:OnHolster( ply )
end

function ITEM:GiveWeapon( )
	self:GetOwner( ):Give( self.weaponClass )
end

function ITEM:PlayerSpawn( ply )
	if ply == self:GetOwner( ) then
		self:GiveWeapon( )
	end
end
Pointshop2.AddItemHook( "PlayerSpawn", ITEM )

function ITEM.static:GetPointshopIconControl( )
	return "DPointshopWeaponIcon"
end

function ITEM.static.getPersistence( )
	return Pointshop2.WeaponPersistence
end

function ITEM.static.generateFromPersistence( itemTable, persistenceItem )
	ITEM.super.generateFromPersistence( itemTable, persistenceItem.ItemPersistence )
	itemTable.weaponClass = persistenceItem.weaponClass
	itemTable.loadoutType = persistenceItem.loadoutType
end

function ITEM.static.GetPointshopIconDimensions( )
	return Pointshop2.GenerateIconSize( 4, 4 )
end