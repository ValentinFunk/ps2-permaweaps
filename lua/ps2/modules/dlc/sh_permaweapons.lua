hook.Add( "PS2_ModulesLoaded", "DLC_Weapons", function( )
	local MODULE = Pointshop2.GetModule( "Pointshop 2 DLC" )
	table.insert( MODULE.Blueprints, {
		label = "Weapon",
		base = "base_weapon",
		icon = "pointshop2/crime1.png",
		creator = "DWeaponCreator"
	} )
end )

hook.Add( "PS2_PopulateCredits", "AddCreditsPermweaps", function( panel )
	panel:AddCreditSection( "Pointshop 2 Permanent Weapons", [[
Pointshop 2 Permanent Weapons by Kamshak
	]] )
end )