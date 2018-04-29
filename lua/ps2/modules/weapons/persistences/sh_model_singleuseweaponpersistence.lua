Pointshop2.SingleUseWeaponPersistence = class( "Pointshop2.SingleUseWeaponPersistence" )
local SingleUseWeaponPersistence = Pointshop2.SingleUseWeaponPersistence 

SingleUseWeaponPersistence.static.DB = "Pointshop2"

SingleUseWeaponPersistence.static.model = {
	tableName = "ps2_singleuseweaponpersistence",
	fields = {
		itemPersistenceId = "int",
		weaponClass = "string",
	},
	belongsTo = {
		ItemPersistence = {
			class = "Pointshop2.ItemPersistence",
			foreignKey = "itemPersistenceId",
			onDelete = "CASCADE",
		}
	}
}

SingleUseWeaponPersistence:include( DatabaseModel )
SingleUseWeaponPersistence:include( Pointshop2.EasyExport )

function SingleUseWeaponPersistence.static.createOrUpdateFromSaveTable( saveTable, doUpdate )
	return Pointshop2.ItemPersistence.createOrUpdateFromSaveTable( saveTable, doUpdate )
	:Then( function( itemPersistence )
		if doUpdate then
			return SingleUseWeaponPersistence.findByItemPersistenceId( itemPersistence.id )
		else
			local weaponPersistence = SingleUseWeaponPersistence:new( )
			weaponPersistence.itemPersistenceId = itemPersistence.id
			return weaponPersistence
		end
	end )
	:Then( function( weaponPersistence )
		weaponPersistence.weaponClass = saveTable.weaponClass
		return weaponPersistence:save( )
	end )
end