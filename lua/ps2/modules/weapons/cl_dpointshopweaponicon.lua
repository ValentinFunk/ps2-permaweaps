local PANEL = {}

function PANEL:Init( )
	self.modelPanel = vgui.Create( "DModelPanel", self )
	self.modelPanel:Dock( FILL )
	self.modelPanel:SetAnimated( true )
	self.modelPanel.Angles = Angle( 0, 0, 0 )
	self.modelPanel:SetMouseInputEnabled( false )
	function self.modelPanel:LayoutEntity( ent )
		self:SetCamPos( Vector( 20, 20, 20 ) )
		self:SetLookAt( ent:GetPos( ) + Vector( 0, 0, 5 ) )
		if self:GetAnimated() then
			ent:SetAngles( ent:GetAngles( ) + Angle( 0, FrameTime() * 50,  0) )
		end
	end
end

function PANEL:OnSelected( )
	
end

function PANEL:OnDeselected( )
end

function PANEL:SetItemClass( itemClass )
	self.BaseClass.SetItemClass( self, itemClass )
	self.modelPanel:SetModel( Pointshop2.GetWeaponWorldModel( itemClass.weaponClass ) or "models/error.mdl" )
end

function PANEL:SetItem( item )
	self:SetItemClass( item.class )
end

function PANEL:SetSelected( b )
	self.BaseClass.SetSelected( self, b )
	self.Selected = b
end

function PANEL:Think( )
	if self.Selected or self.Hovered or self:IsChildHovered( 2 ) then
		self.modelPanel:SetAnimated( true )
	else
		self.modelPanel:SetAnimated( false )
	end
end

derma.DefineControl( "DPointshopWeaponIcon", "", PANEL, "DPointshopItemIcon" )