local PANEL = {}

function PANEL:Init( )
	self:SetSkin( Pointshop2.Config.DermaSkin )
	self:SetSize( 600, 600 )
	
	self:SetTitle( "Select a Weapon" )
	
	self.scroll = vgui.Create( "DScrollPanel", self )
	self.scroll:Dock( FILL )

	self.layout = vgui.Create("DIconLayout", self.scroll)
	self.layout:Dock(TOP)
	self.layout:SetSpaceX( 8 )
	self.layout:SetSpaceY( 8 )
	self.layout:DockMargin( 0, 6, 0, 0 )
	
	for k, weapon in ipairs( Pointshop2.GetWeaponsForPicker( ) ) do
		local pnl = vgui.Create( "DButton", self.layout )
		pnl:SetTall( 75 )
		pnl:SetWide( 280 )
		pnl:DockPadding( 5, 5, 5, 5 )
		pnl:SetText( "" )
		
		pnl.mdlPanel = vgui.Create( "DModelPanel", pnl )
		pnl.mdlPanel:SetSize( 64, 64 )
		pnl.mdlPanel:Dock( LEFT )
		pnl.mdlPanel:SetTooltip( "Click to Select" )
		pnl.mdlPanel:SetModel( weapon.WorldModel or "models/error.mdl" )
		pnl.mdlPanel:SetMouseInputEnabled( false )
		function pnl.mdlPanel:LayoutEntity( ent )
			self:SetCamPos( Vector( 20, 20, 20 ) )
			self:SetLookAt( ent:GetPos( ) + Vector( 0, 0, 5 ) )
			if self:GetAnimated() then
				ent:SetAngles( ent:GetAngles( ) + Angle( 0, FrameTime() * 50,  0) )
			end
		end	
		
		pnl.title = vgui.Create( "DLabel", pnl )
		pnl.title:Dock( TOP )
		pnl.title:DockMargin( 5, 0, 5, 0 )
		pnl.title:SetFont( self:GetSkin().SmallTitleFont )
		pnl.title:SetColor( self:GetSkin().Colours.Label.Bright )
		if LANG then
			pnl.title:SetText( LANG.TryTranslation( weapon.PrintName or weapon.ClassName ) )
		else
			pnl.title:SetText( weapon.PrintName or weapon.ClassName )
		end
		pnl.title:SizeToContents( )
		
		pnl.class = vgui.Create( "DLabel", pnl )
		pnl.class:Dock( TOP )
		pnl.class:DockMargin( 5, 0, 5, 0 )
		pnl.class:SetText( weapon.ClassName )
		pnl.class:SetFont( self:GetSkin().fontName )
		
		function pnl.DoClick( )
			self.selectedWeapon = weapon.ClassName 
			self.selectedModel = weapon.WorldModel

			if engine.ActiveGamemode() == "terrortown" and not weapon.Kind then
				Derma_Message( "You have chosen a weapon that is incompatible with TTT.\nIt will not work if equipped in TTT.\nLearn how to convert it: bit.ly/TTTWeapon")
			end

			self:OnChange()
		end
		
		function pnl:Think()
			self.mdlPanel:SetAnimated( self.Hovered )
		end

		if engine.ActiveGamemode() == "terrortown" and not weapon.Kind then
			pnl.error = vgui.Create( "DLabel", pnl )
			pnl.error:Dock( TOP )
			pnl.error:DockMargin( 5, 0, 5, 0 )
			pnl.error:SetText( "Incompatible with TTT" )
			pnl.error:SetTooltip( "This weapon cannot be used with TTT. Contact the author to learn more." )
			pnl.error:SetFont( self:GetSkin().fontName )
			pnl.error:SetColor( Color( 255, 0, 0 ) )
		end
		
		Derma_Hook( pnl, "Paint", "Paint", "Button" )
	end
end

function PANEL:OnChange( )
	--for overwriting
end

vgui.Register( "DWeaponSelector", PANEL, "DFrame" )