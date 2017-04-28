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

function ITEM:OnHolster( )
end

function ITEM:GiveWeapon( )
	if hook.Run( "PS2_WeaponShouldSpawn", self:GetOwner() ) == false then
		return
	end
	Pointshop2.CheckWeaponReplace( self )
	self:GetOwner( ):Give( self.weaponClass )
end

function ITEM:PlayerLoadout( ply )
	if ply == self:GetOwner( ) then
		timer.Simple( 0.01, function()
			self:GiveWeapon( )
		end )
	end
end
Pointshop2.AddItemHook( "PlayerLoadout", ITEM )

--Deathrun Support
function ITEM:OnRoundSet( round, ... )
	if round == ROUND_ACTIVE then
		timer.Simple( 0, function( )
			self:PlayerLoadout( self:GetOwner( ) ) --Pretend Loadout hook was executed
		end )
	end
end
Pointshop2.AddItemHook( "OnRoundSet", ITEM )

if engine.ActiveGamemode( ) == "zombieescape" then
	function ITEM:PlayerLoadout( ply )
		timer.Simple( 3, function( )
			if ply == self:GetOwner( ) then
				self:GiveWeapon( )
			end
		end )
	end
end

if engine.ActiveGamemode( ) == "surf" then
	hook.Add( "PlayerSpawn", "FixMessup", function( ply )
		hook.Run( "PlayerLoadout", ply )
	end )
end

function ITEM.static:GetPointshopIconControl( )
	return "DCsgoItemIcon"
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
