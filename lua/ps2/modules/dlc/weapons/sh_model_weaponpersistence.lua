Pointshop2.WeaponPersistence = class( "Pointshop2.WeaponPersistence" )
local WeaponPersistence = Pointshop2.WeaponPersistence 

WeaponPersistence.static.DB = "Pointshop2"

WeaponPersistence.static.model = {
	tableName = "ps2_weaponpersistence",
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

WeaponPersistence:include( DatabaseModel )
WeaponPersistence:include( Pointshop2.EasyExport )

function WeaponPersistence.static.createOrUpdateFromSaveTable( saveTable, doUpdate )
	return Pointshop2.ItemPersistence.createOrUpdateFromSaveTable( saveTable, doUpdate )
	:Then( function( itemPersistence )
		if doUpdate then
			return WeaponPersistence.findByItemPersistenceId( itemPersistence.id )
		else
			local weaponPersistence = WeaponPersistence:new( )
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