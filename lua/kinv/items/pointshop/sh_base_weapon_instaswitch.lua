ITEM.PrintName = "Pointshop Instaswitch Weapon Base"
ITEM.baseClass = "base_weapon"

ITEM.weaponClass = "weapon_357"
ITEM.loadoutType = "Secondary"

ITEM.category = "Weapons"

function ITEM:OnEquip( )
	if CLIENT then
		return
	end

	if not self:GetOwner( ):Alive( ) then
		return
	end

	local player = self:GetOwner()
	if player.IsSpec and player:IsSpec() then
		return
	end

	if player:Team() == TEAM_SPECTATOR then
		return
	end

	self:GiveWeapon( )
end

function ITEM:OnHolster( )
	if SERVER then
		self:GetOwner( ):StripWeapon( self.weaponClass )
	end
end

function ITEM:GiveWeapon( )
	local w = weapons.GetStored( self.weaponClass )
	local oldDC, oldDC2
	if w then
		oldDC, oldDC2 = w.Primary.DefaultClip, w.Secondary.DefaultClip
		w.Primary.DefaultClip = 1
		w.Secondary.DefaultClip = 1
	end

	self:GetOwner( ):Give( self.weaponClass )
	self:GetOwner( ):SelectWeapon( self.weaponClass )

	if w then
		w.Primary.DefaultClip = oldDC
		w.Secondary.DefaultClip = oldDC2
	end
end

function ITEM.static:GetPointshopIconControl( )
	return "DCsgoItemIcon"
end

function ITEM.static.getPersistence( )
	return Pointshop2.InstaswitchWeaponPersistence
end

function ITEM.static.generateFromPersistence( itemTable, persistenceItem )
	ITEM.super.generateFromPersistence( itemTable, persistenceItem )
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
