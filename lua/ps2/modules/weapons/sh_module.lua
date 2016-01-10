local MODULE = {}

--Pointshop2 Basic Items
MODULE.Name = "PS2 Weapons"
MODULE.Author = "Kamshak"

--This defines blueprints that players can use to create items.
--base is the name of the class that is used as a base
--creator is the name of the derma control that is used to create new items from the blueprint
MODULE.Blueprints = {
	{
		label = "Perma-Weapon",
		base = "base_weapon",
		icon = "pointshop2/crime1.png",
		creator = "DWeaponCreator",
		tooltip = "Weapon is given when the player spawns. Cannot switch weapons during rounds."
	},
	{
		label = "Single Use Weapon",
		base = "base_single_use_weapon",
		icon = "pointshop2/crime1.png",
		creator = "DSingleUseWeaponCreator",
		tooltip = "Weapon is are given only once when the item is used"
	},
	{
		label = "Insta-Weapon",
		base = "base_weapon_instaswitch",
		icon = "pointshop2/crime1.png",
		creator = "DWeaponCreator",
		tooltip = "Weapons are given on spawn and instantly when equipped. Can switch weapons during rounds."
	}
}

MODULE.SettingButtons = {}


MODULE.Settings = { 
	Shared = {},
	Server = {}
}

Pointshop2.RegisterModule( MODULE )