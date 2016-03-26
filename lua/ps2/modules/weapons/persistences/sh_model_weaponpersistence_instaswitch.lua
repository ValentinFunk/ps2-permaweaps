Pointshop2.InstaswitchWeaponPersistence = class( "Pointshop2.InstaswitchWeaponPersistence" )
local InstaswitchWeaponPersistence = Pointshop2.InstaswitchWeaponPersistence

InstaswitchWeaponPersistence.static.DB = "Pointshop2"

InstaswitchWeaponPersistence.static.model = {
	tableName = "ps2_instatswitchweaponpersistence",
	fields = {
		itemPersistenceId = "int",
		weaponClass = "string",
		loadoutType = "string",
	},
	belongsTo = {
		ItemPersistence = {
			class = "Pointshop2.ItemPersistence",
			foreignKey = "itemPersistenceId",
			onDelete = "CASCADE",
		}
	}
}

InstaswitchWeaponPersistence:include( DatabaseModel )
InstaswitchWeaponPersistence:include( Pointshop2.EasyExport )

function InstaswitchWeaponPersistence.static.createOrUpdateFromSaveTable( saveTable, doUpdate )
	return Pointshop2.ItemPersistence.createOrUpdateFromSaveTable( saveTable, doUpdate )
	:Then( function( itemPersistence )
		if doUpdate then
			return InstaswitchWeaponPersistence.findByItemPersistenceId( itemPersistence.id )
		else
			local weaponPersistence = InstaswitchWeaponPersistence:new( )
			weaponPersistence.itemPersistenceId = itemPersistence.id
			return weaponPersistence
		end
	end )
	:Then( function( weaponPersistence )
		weaponPersistence.weaponClass = saveTable.weaponClass
		weaponPersistence.loadoutType = saveTable.loadoutType
		return weaponPersistence:save( )
	end )
end
