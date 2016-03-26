local PANEL = {}

function PANEL:Init()
  self:SetSkin(Pointshop2.Config.DermaSkin)
  self:SetTitle("Configure Weapon Slots")

  self:SetSize(400, 600)

  self.infoPanel = vgui.Create( "DInfoPanel", self )
	self.infoPanel:Dock( TOP )
	self.infoPanel:SetInfo( "Weapon Slots", "You can configure weapon slots here. Slots can strip a weapon before giving the equipped one to the player. This can be used to replace weapons such as for example the crowbar in TTT.\nWhen you remove a slot,  items that are currently in the slot are put back into the player's inventory or refunded, if their inventory is full." )
	self.infoPanel:DockMargin( 0, 0, 0, 10 )

  self.removedSlots = {}

  self.tbl = vgui.Create("DListView", self)
  self.tbl:Dock( FILL )
  self.tbl:SetMultiSelect( false )
  self.tbl:AddColumn( "Slot Name" )
  self.tbl:AddColumn( "Replace Weapon" )
  function self.tbl.OnRowRightClick( tbl, id, line )
    local menu = DermaMenu()
    menu:SetSkin( Pointshop2.Config.DermaSkin )

    menu:AddOption( "Remove", function( )
      self.data["WeaponSlots.Slots"][line.slotName] = nil
      self.tbl:RemoveLine( id )
      self.removedSlots[line.slotName] = true
    end )

    menu:Open( )
  end

  self.save = vgui.Create( "DButton", self )
  self.save:SetText( "Save" )
  self.save:SetImage( "pointshop2/floppy1.png" )
  self.save:SetTall( 30 )
  self.save:DockMargin( 0, 10, 0, 0)
  self.save.m_Image:SetSize( 16, 16 )
  self.save:Dock( BOTTOM )
  function self.save.DoClick( )
    self:Save( )
  end

  self.buttons = vgui.Create( "DPanel", self )
  self.buttons:Dock( BOTTOM )
  self.buttons:SetTall( 30 )
  self.buttons.Paint = function( ) end
  self.buttons:DockMargin( 0, 5, 0, 0)

  self.add = vgui.Create( "DButton", self.buttons )
  self.add:SetText( "Add New" )
  self.add:SetImage( "pointshop2/plus24.png" )
  self.add:SetWide( 150 )
  self.add.m_Image:SetSize( 16, 16 )
  self.add:Dock( RIGHT )
  function self.add.DoClick( )
    self:OpenAddSlotFrame( )
  end
end

function PANEL:AddSlotToTable(slotName, replaces)
  local line = self.tbl:AddLine(slotName, replaces)
  line.slotName = slotName
  line.replaces = { replaces = replaces }
  self.data["WeaponSlots.Slots"][slotName] = { replaces = replaces }

  -- handle "undo" of slot removal
  if self.removedSlots[slotName] then
    self.removedSlots[slotName] = nil
  end
end

function PANEL:OpenAddSlotFrame( )
	local frame = vgui.Create( "DWeaponSlotsConfigurator_AddSlot" )
	frame:Center( )
	frame:MakePopup( )
	--frame:DoModal( )
	frame:SetSkin( Pointshop2.Config.DermaSkin )

	function frame.OnSaved( frame, slotName, replace )
    for k, v in pairs(self.tbl:GetLines()) do
      if v.slotName == slotName then
        return Derma_Message("A slot with the name " .. slotName .. " already exists!", "Error")
      end
    end
		self:AddSlotToTable( slotName, replace )
		frame:Remove( )
	end

	return frame
end

function PANEL:SetModule( mod )
	self.mod = mod
end

function PANEL:SetData( data )
	self.data = data

	for slotName, replaces in pairs( self.data["WeaponSlots.Slots"] ) do
		self:AddSlotToTable( slotName, replaces.replaces )
	end
end

function PANEL:Save( )
	Pointshop2View:getInstance( ):saveSettings( self.mod, "Shared", self.data )

  local removed = {}
  for name, isRemoved in pairs(self.removedSlots) do
    if isRemoved then
      table.insert(removed, name)
    end
  end

  net.Start("SlotsRemoved")
    net.WriteTable(removed)
  net.SendToServer()

	self:Remove( )
end

vgui.Register( "DWeaponSlotsConfigurator", PANEL, "DFrame" )
