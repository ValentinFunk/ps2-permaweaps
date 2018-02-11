local PANEL = {}

function PANEL:Init( )
	self:addSectionTitle( "Weapon Selection" )
	
	self.selectWeaponElem = vgui.Create( "DPanel" )
	self.selectWeaponElem:SetTall( 64 )
	self.selectWeaponElem:SetWide( self:GetWide( ) )
	function self.selectWeaponElem:Paint( ) end
	
	self.mdlPanel = vgui.Create( "SpawnIcon", self.selectWeaponElem )
	self.mdlPanel:SetSize( 64, 64 )
	self.mdlPanel:Dock( LEFT )
	self.mdlPanel:SetTooltip( "Click to Select" )
	local frame = self
	function self.mdlPanel:DoClick( )
		--Open model selector
		local window = vgui.Create( "DWeaponSelector" )
		window:Center( )
		window:MakePopup( )
		window:DoModal()
		function window:OnChange( )
			frame.manualEntry.IgnoreChange = true
			frame.manualEntry:SetText( window.selectedWeapon )
			frame.manualEntry.IgnoreChange = false
			frame.mdlPanel:SetModel( window.selectedModel )
			window:Close()
		end
	end
	
	local rightPnl = vgui.Create( "DPanel", self.selectWeaponElem )
	rightPnl:Dock( FILL )
	function rightPnl:Paint( )
	end

	self.manualEntry = vgui.Create( "DTextEntry", rightPnl )
	self.manualEntry:Dock( TOP )
	self.manualEntry:DockMargin( 5, 0, 5, 5 )
	self.manualEntry:SetTooltip( "Click on the icon or manually enter the weapon class here and press enter" )
	function self.manualEntry:OnEnter( )
		local weapon = weapons.GetStored( self:GetText( ) )
		if not weapon then
			return Derma_Message( self:GetText() .. " is not a valid weapon!", "Error" )
		end
		frame.mdlPanel:SetModel( weapon.WorldModel )
	end
	
	local cont = self:addFormItem( "Weapon", self.selectWeaponElem )
	cont:SetTall( 64 )
end

function PANEL:SaveItem( saveTable )
	self.BaseClass.SaveItem( self, saveTable )
	
	saveTable.weaponClass = self.manualEntry:GetText( )
end

function PANEL:EditItem( persistence, itemClass )
	self.BaseClass.EditItem( self, persistence.ItemPersistence, itemClass )
	
	self.manualEntry:SetText( persistence.weaponClass )
	local weapon = weapons.GetStored( persistence.weaponClass )
	if weapon and weapon.WorldModel then
		self.mdlPanel:SetModel( weapon.WorldModel )
	end
end

function PANEL:Validate( saveTable )
	local succ, err = self.BaseClass.Validate( self, saveTable )
	if not succ then
		return succ, err
	end
	
	if not Pointshop2.IsValidWeaponClass( saveTable.weaponClass ) then
		return false, saveTable.weaponClass .. " is not a valid weapon class"
	end
	
	return true
end

vgui.Register( "DSingleUseWeaponCreator", PANEL, "DItemCreator" )