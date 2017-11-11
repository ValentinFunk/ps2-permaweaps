--[[
    Provides a renderer for Hat Icons.
]]--

local entity = ClientsideModel( "models/error.mdl", RENDER_GROUP_OPAQUE_ENTITY )
entity:SetNoDraw(true)

local colAmbientLight = Color( 50, 50, 50 )
local colColor = Color( 255, 255, 255, 255 )
local directionalLight = {
	[BOX_TOP] = Color(255, 255, 255),
	[BOX_FRONT] = Color(255, 255, 255)
}
local camPos = Vector( 0, 30, 10 )
local lookAt = Vector( 0, 0, 0 )
local fov = 70
local function PaintWeaponIcon(itemClass)
    entity:SetAngles( Angle( 0, -25, 0 ) )
    entity:SetModel(Pointshop2.GetWeaponWorldModel( itemClass.weaponClass ) or "models/error.mdl")
	entity:SetPos(Vector(0, 0, 2))
	
	local wep = weapons.GetStored(itemClass.weaponClass)
	if wep and wep["SkinIndex"] then
		entity:SetSkin(wep["SkinIndex"])
	end	

    local PrevMins, PrevMaxs = entity:GetRenderBounds()
    camPos = PrevMins:Distance(PrevMaxs) * Vector(0.65, 0.65, 0.5) 
    lookAt = (PrevMaxs + PrevMins) / 2

    local ang = ( lookAt - camPos ):Angle()
	cam.Start3D( camPos, ang, fov, 0, 0, 512, 512, 5, 4096 )
		cam.IgnoreZ( true )
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( entity:GetPos() )
		render.ResetModelLighting( colAmbientLight.r/255, colAmbientLight.g/255, colAmbientLight.b/255 )
		render.SetColorModulation( colColor.r/255, colColor.g/255, colColor.b/255 )
		render.SetBlend( 1 )

		for i=0, 6 do
			local col = directionalLight[ i ]
			if ( col ) then
				render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
			end
		end

        entity:DrawModel( )

		cam.IgnoreZ( false )
		render.SuppressEngineLighting( false )
	cam.End3D( )
end


local WeaponIconRendererMixin = {}
function WeaponIconRendererMixin:included( klass )
    klass.static.PaintIcon = function(cls)
        PaintWeaponIcon(cls)
    end
end
Pointshop2.RegisterItemClassMixin( "base_weapon", WeaponIconRendererMixin )
Pointshop2.RegisterItemClassMixin( "base_single_use_weapon", WeaponIconRendererMixin )