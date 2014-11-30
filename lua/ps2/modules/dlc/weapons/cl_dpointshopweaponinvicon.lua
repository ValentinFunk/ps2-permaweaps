local PANEL = {}

function PANEL:Init( )
	self.modelPanel = vgui.Create( "DModelPanel", self )
	self.modelPanel:Dock( FILL )
	self.modelPanel:SetDragParent( self )
	self.modelPanel:SetMouseInputEnabled( false )
	function self.modelPanel:LayoutEntity( ent )
		self:SetCamPos( Vector( 20, 20, 20 ) )
		self:SetLookAt( ent:GetPos( ) + Vector( 0, 0, 5 ) )
		if self:GetAnimated() then
			ent:SetAngles( ent:GetAngles( ) + Angle( 0, FrameTime() * 50,  0) )
		end
	end	
end

function PANEL:Think( )
	if self.Selected or self.Hovered or self:IsChildHovered( 2 ) then
		self.modelPanel:SetAnimated( true )
	else
		self.modelPanel:SetAnimated( false )
	end
end

function PANEL:SetItem( item )
	self.item = item 
	
	local weapon = weapons.GetStored( item.weaponClass )
	if weapon and weapon.WorldModel then
		self.modelPanel:SetModel( weapon.WorldModel )
	else
		self.modelPanel:SetModel( "models/error.mdl" )
	end
	--self.modelPanel.Entity:SetPos( Vector( -100, 0, -61 ) )
end

vgui.Register( "DPointshopWeaponInvIcon", PANEL, "DPointshopInventoryItemIcon" )