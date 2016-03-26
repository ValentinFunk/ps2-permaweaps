local PANEL = {}

function PANEL:Init()
  self:SetSkin(Pointshop2.Config.DermaSkin)
  self:SetTitle("Add a Weapon Slot")

  self:SetSize(320, 180)

  local slotName = vgui.Create("DLabel", self)
  slotName:SetText("Slot Name:")
  slotName:Dock(TOP)
  slotName:SizeToContents()
  slotName:DockMargin( 5, 5, 0, 5 )

  self.slotNameEntry = vgui.Create("DTextEntry", self)
  self.slotNameEntry:Dock(TOP)
  self.slotNameEntry:DockMargin( 5, 0, 5, 5 )

  local panel = vgui.Create( "DPanel", self )
  panel:DockMargin( 5, 10, 5, 5 )
  panel:Dock( TOP )
  function panel:Paint( w, h ) end
  panel.entry = vgui.Create( "DTextEntry", panel )
  function panel:PerformLayout( )
    self.checkBox:SetPos( 0, 0 )
    self.label:SetPos( self.checkBox:GetWide( ) + 5 )
    self.entry:SetPos( 100, 0 )
    self.entry:SetWide(self:GetWide() - 100 )

    self:SizeToChildren( false, true )
  end

  panel.checkBox = vgui.Create( "DCheckBox", panel )
  function panel.checkBox:OnChange( )
    panel.label:SetDisabled( not self:GetChecked( ) )
    panel.entry:SetDisabled( not self:GetChecked( ) )
  end

  panel.label = vgui.Create( "DLabel", panel )
  panel.label:SetText( "Replaces Class:" )
  panel.label:SizeToContents( )
  panel.checkBox:SetValue( false )

  self.save = vgui.Create( "DButton", self )
  self.save:SetText( "Add" )
  self.save:SetImage( "pointshop2/plus24.png" )
  self.save:SetTall( 30 )
  self.save:DockMargin( 5, 10, 5, 5)
  self.save.m_Image:SetSize( 16, 16 )
  self.save:Dock( BOTTOM )
  function self.save.DoClick( )
    local replaces = panel.checkBox:GetChecked() and panel.entry:GetText() or false
    self:OnSaved( self.slotNameEntry:GetText(), replaces )
  end
end

function PANEL:OnSaved()
  -- for override
end

vgui.Register( "DWeaponSlotsConfigurator_AddSlot", PANEL, "DFrame" )
