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
	self.BaseClass.SetItem( self, item )
	
	self.modelPanel:SetModel( Pointshop2.GetWeaponWorldModel( item.weaponClass ) or "models/error.mdl" )
	local wep = weapons.GetStored(item.weaponClass)	
	if wep and wep["SkinIndex"] then
		self.modelPanel.Entity:SetSkin(wep["SkinIndex"])
	end
	--self.modelPanel.Entity:SetPos( Vector( -100, 0, -61 ) )
end

vgui.Register( "DPointshopWeaponInvIcon", PANEL, "DPointshopInventoryItemIcon" )