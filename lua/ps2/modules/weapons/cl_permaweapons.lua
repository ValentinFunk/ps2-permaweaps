local HoldTypeTranslate = {
	["missile launcher"] = "rpg",
	crowbar = "melee",
	pistol = "pistol",
	smg2 = "smg",
	slam = "slam",
	python = "revolver",
	bow = "crossbow",
	Grenade = "grenade",
	stunbaton = "melee",
	shotgun = "shotgun",
	gauss = "physgun",
	ar2 = "ar2"
}

local function GetHL2Weapons( )
	local tbl = {}
	for classname, info in pairs( list.Get( "Weapon" ) ) do
		local extendedInfo = file.Read( "scripts/" .. classname .. ".txt", "GAME" )
		if extendedInfo then
			local infoTable = util.KeyValuesToTable( extendedInfo )
			table.insert( tbl, {
				WorldModel = infoTable.playermodel,
				PrintName = language.GetPhrase( infoTable.printname ),
				ClassName = classname,
				HoldType = HoldTypeTranslate[infoTable.anim_prefix]
			})
		end
	end
	return tbl
end

local function GetScriptedWeapons( ) 
	-- Don't include weapon bases
	return LibK._.filter( weapons.GetList( ), function( weapon )
		return not string.find( weapon.ClassName, "base" )
	end )
end

function Pointshop2.GetWeaponsForPicker( )
	local weapons
	if engine.ActiveGamemode( ) == "terrortown" then
		weapons = GetScriptedWeapons( )
	else
		weapons = table.Add( GetHL2Weapons( ), GetScriptedWeapons( ) )
	end

	table.sort( weapons, function( a, b ) 
		local aName = a.PrintName or a.ClassName
		local bName = b.PrintName or b.ClassName
		if LANG then
			aName = LANG.TryTranslation( aName )
			bName = LANG.TryTranslation( bName )
		end

		return aName < bName
	end )

	return weapons
end

function Pointshop2:GetAllWeaponClassnames()
	local cls = LibK._.map(Pointshop2.GetWeaponsForPicker(), function(w) return w.ClassName end)
	for k, v in pairs({
		"weapon_357",
		"weapon_alyxgun",
		"weapon_annabelle",
		"weapon_ar2",
		"weapon_brickbat",
		"weapon_bugbait",
		"weapon_crossbow",
		"weapon_crowbar",
		"weapon_frag",
		"weapon_physcannon",
		"weapon_pistol",
		"weapon_rpg",
		"weapon_shotgun",
		"weapon_smg1",
		"weapon_striderbuster",
		"weapon_stunstick",
	}) do 
		if not table.HasValue(cls, v) then
			table.insert(cls, v)
		end
	end
	return cls
end

function Pointshop2.IsValidWeaponClass( weaponClass )
	for k, v in pairs( Pointshop2.GetWeaponsForPicker( ) ) do
		if v.ClassName == weaponClass then
			return true
		end
	end
	return false
end

function Pointshop2.GetWeaponWorldModel( weaponClass )
	for k, v in pairs( Pointshop2.GetWeaponsForPicker( ) ) do
		if v.ClassName == weaponClass then
			return v.WorldModel
		end
	end
	return "models/error.mdl"
end

local function checkSlotWeapons( )
	local message = "[WARNING][ADMIN ONLY] There is a possible misconfiguration with your Permaweapon Slots. The following slots have are set to replace weapons but the weapons do not seem to exist on the server:\n\n"
	local hasError = false
	local slots = Pointshop2.GetSetting( "PS2 Weapons", "WeaponSlots.Slots" )
	for slotName, info in pairs( slots ) do
		local shouldReplace = isstring(info.replaces) and info.replaces != "false"
		if shouldReplace and not table.HasValue( Pointshop2:GetAllWeaponClassnames(), info.replaces ) then
			message = message .. slotName .. " (" .. info.replaces .. "): Could not be found on the server.\n"
			hasError = true
		end
	end
	message = message .. "If you do not want to replace any weapons you can clear the replace settings for these slot(s).\n"

	if IsValid(LocalPlayer().permaWeaponErrorPanel) and not hasError then
		LocalPlayer( ).notificationPanel:ForceSlideOut( LocalPlayer().permaWeaponErrorPanel )
	end

	if LocalPlayer():IsAdmin() and hasError then
		if IsValid(LocalPlayer( ).permaWeaponErrorPanel) then
			LocalPlayer( ).notificationPanel:ForceSlideOut( LocalPlayer().permaWeaponErrorPanel )
		end

		local notification = vgui.Create( "KNotificationPanel" )
		notification:setText( message )
		notification:setIcon( "icon16/exclamation.png" )
		notification.sound = "kreport/electric_deny2.wav"
		notification:SetSkin( Pointshop2.Config.DermaSkin )
		notification.duration = 30

		local btn = vgui.Create( "DButton", notification )
		btn:SetText( "Clear Replace Settings" )
		function btn.DoClick() 
			local newSettings = table.Copy( slots )
			for slotName, info in pairs( newSettings ) do
				local shouldReplace = isstring(info.replaces) and info.replaces != "false"
				if shouldReplace and not weapons.GetStored( info.replaces ) then
					info.replaces = false
				end
			end

			btn:SetDisabled(true)
			btn:SetText("Saving...")
			Pointshop2View:getInstance():saveSettings(Pointshop2.GetModule("PS2 Weapons"), "Shared", { ["WeaponSlots.Slots"] = newSettings })
		end
		btn:SizeToContents()
		btn:Dock( TOP )
		btn:DockMargin( 5, 5, 5, 5 )
		btn:SetTall( 30 )
		notification:SetMouseInputEnabled( true )
		btn:SetMouseInputEnabled( true )

		LocalPlayer().permaWeaponErrorPanel = LocalPlayer( ).notificationPanel:addNotification( notification )
	end
end
hook.Add( "PS2_OnSettingsUpdate", "ErrorNotifierPerma", function( ) 
	timer.Simple(3, checkSlotWeapons)
end )