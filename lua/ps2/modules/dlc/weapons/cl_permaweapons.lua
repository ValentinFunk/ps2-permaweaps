local function GetHL2Weapons( )
	for classname, info in pairs( list.Get( "Weapon" ) ) do
		local tbl = {}
		local extendedInfo = file.Read( "scripts/" .. classname .. ".txt", "GAME" )
		if extendedInfo then
			local infoTable = util.KeyValuesToTable( extendedInfo )
			table.insert( tbl, {
				WorldModel = infoTable.playermodel,
				PrintName = language.GetPhrase( infoTable.printname ),
				ClassName = classname
			})
		end
	end
end

local function GetScriptedWeapons( ) 
	-- Don't include weapon bases
	return table.filter( weapons.GetList( ), function( weapon )
		return not string.find( weapon.ClassName, "base" )
	end )
end

function Pointshop2.GetWeaponsForPicker( )
	return table.Add( GetHL2Weapons( ), GetScriptedWeapons( ) )
end