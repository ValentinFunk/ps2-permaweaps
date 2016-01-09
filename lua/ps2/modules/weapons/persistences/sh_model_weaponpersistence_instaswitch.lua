Pointshop2.InstaswitchWeaponPersistence = class( "Pointshop2.InstaswitchWeaponPersistence", Pointshop2.WeaponPersistence )
local InstaswitchWeaponPersistence = Pointshop2.InstaswitchWeaponPersistence 

InstaswitchWeaponPersistence.static.DB = "Pointshop2"

InstaswitchWeaponPersistence.static.model = table.Copy( Pointshop2.WeaponPersistence.model )
InstaswitchWeaponPersistence.static.model.tableName = "ps2_instatswitchweaponpersistence"