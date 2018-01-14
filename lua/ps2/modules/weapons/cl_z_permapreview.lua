local WeaponInfoLookup = {}
for k, v in pairs(Pointshop2.GetWeaponsForPicker( )) do
	if v.WorldModel != "models/error.mdl" then
    	WeaponInfoLookup[v.ClassName] = v
	end
end

local function spawnProp( weaponClass, entity )
	local prop = ents.CreateClientProp( Model( "models/error.mdl" ) )
	prop:Spawn( )
	prop:SetNoDraw( true )
	prop:AddEffects( EF_BONEMERGE )
	return prop
end

local function applyWeaponClassToProp( weaponClass, entity, prop )
	prop:SetParent( entity, entity:LookupAttachment( "RHand" ) )
	prop:SetModel( Model( weaponClass.WorldModel ) )
end

local function preDrawModel( self )
	if not IsValid( self.Entity ) then
		return
	end

	local shouldShowClassName
    for k, v in pairs(LocalPlayer().PS2_EquippedItems) do
        if instanceOf(KInventory.Items.base_weapon, v) then
			local weaponClassName = v.weaponClass
            if not WeaponInfoLookup[weaponClassName] then
				continue
			end

			if v.loadoutType == "Primary" then
				shouldShowClassName = v.weaponClass
			elseif v.loadoutType == "Secondary" and not shouldShowClassName then
				-- Show secondary only if no primary
				shouldShowClassName = v.weaponClass
			end
        end
    end

	if not shouldShowClassName and IsValid( self.Entity.CarriedWeapon ) then
		SafeRemoveEntityDelayed(self.Entity.CarriedWeapon, 0 )
		self.Entity:ResetSequence( self.Entity:LookupSequence( "idle_all_01" ) )
		return
	end

	if shouldShowClassName then
		local weaponClass = WeaponInfoLookup[shouldShowClassName]

		if not IsValid( self.Entity.CarriedWeapon ) then
			self.Entity.CarriedWeapon = spawnProp( weaponClass, entity )
			self.Entity.CarriedWeapon.className = ""
		end

		if self.Entity.CarriedWeapon.className != shouldShowClassName then
			applyWeaponClassToProp( weaponClass, self.Entity, self.Entity.CarriedWeapon )
			self.Entity.CarriedWeapon.className = shouldShowClassName
			local holdType = weaponClass.HoldType or "pistol"
			self.Entity:ResetSequence( self.Entity:LookupSequence( "idle_" .. holdType ) )
		end
	end
end

local function drawWeapon( self )
	if IsValid( self.Entity ) and IsValid( self.Entity.CarriedWeapon ) then
		self.Entity.CarriedWeapon:DrawModel()
	end
	self:SetAnimated( true )
end

hook.Add( "PS2_PreviewPanelPaint_PreStart3D", "WeaponsPreview", preDrawModel )
hook.Add( "PS2_PreviewPanelPaint_PostDrawModel", "WeaponsPreview", drawWeapon )
hook.Add( "PS2_InvPreviewPanelPaint_PreStart3D", "WeaponsPreview", preDrawModel )
hook.Add( "PS2_InvPreviewPanelPaint_PostDrawModel", "WeaponsPreview", drawWeapon )