--LIGHTS+ 
--updated 12/11/2013
--Mod adding simple on/off lights by qwrwed.

--Code from Stairs+ to determine facedir of lights
local dirs1 = { 21, 20, 23, 22, 21 }
local dirs2 = { 15, 8, 17, 6, 15 }
local dirs3 = { 14, 11, 16, 5, 14 }

lightsplus_players_onwall = {}

local function get_nodedef_field(nodename, fieldname)
        if not minetest.registered_nodes[nodename] then
                return nil
        end
        return minetest.registered_nodes[nodename][fieldname]
end

function lightsplus_rotate_and_place(itemstack, placer, pointed_thing, onwall)
    local node = minetest.get_node(pointed_thing.under)
        if not minetest.registered_nodes[node.name] or not minetest.registered_nodes[node.name].on_rightclick then
            local above = pointed_thing.above
            local under = pointed_thing.under
            local top = {x=under.x, y=under.y+1, z=under.z}
            local pitch = placer:get_look_pitch()
            local node = minetest.get_node(above)
            local fdir = minetest.dir_to_facedir(placer:get_look_dir())
            local wield_name = itemstack:get_name()
            local slab = string.find(wield_name, "light")
            local iswall = (above.x ~= under.x) or (above.z ~= under.z)
            local isceiling = (above.x == under.x) and (above.z == under.z) and (pitch > 0)
            if get_nodedef_field(minetest.get_node(under).name, "buildable_to") then
                if slab then fdir = 0 end
                minetest.add_node(under, {name = wield_name, param2 = fdir }) -- place right side up
            elseif not get_nodedef_field(minetest.get_node(above).name, "buildable_to") then
                return
            elseif onwall or (iswall and (slab or panel)) then
                if slab then
                    minetest.add_node(above, {name = wield_name, param2 = dirs2[fdir+2] }) -- place with wall slab rotation
                else
                    minetest.add_node(above, {name = wield_name, param2 = dirs3[fdir+2] }) -- place with wall panel/micro rotation
                end
            elseif isceiling then
                local nfdir = dirs1[fdir+2]
                if slab then nfdir = 22 end
                minetest.add_node(above, {name = wield_name, param2 = nfdir }) -- place upside down variant
            else
                if slab then fdir = 0 end
                minetest.add_node(above, {name = wield_name, param2 = fdir }) -- place right side up
            end
                itemstack:take_item()
                return itemstack
    else
        minetest.registered_nodes[node.name].on_rightclick(pointed_thing.under, node, placer)
    end
end


--Node Definitions and Functions
local lights = {
	{"lightsplus:light", "lightsplus:light_on", "Light", "lightsplus_light.png", "", "", "facedir", ""},
	{"lightsplus:gold_light", "lightsplus:gold_light_on", "Gold Light", "lightsplus_gold_light.png", "", "facedir", "", ""},
	{"lightsplus:slab_light", "lightsplus:slab_light_on", "Slab Light", "lightsplus_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},},},
	{"lightsplus:gold_slab_light", "lightsplus:gold_slab_light_on", "Gold Slab Light", "lightsplus_gold_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},},},
	{"lightsplus:flat_light", "lightsplus:flat_light_on", "Flat Light", "lightsplus_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5},},},
	{"lightsplus:gold_flat_light", "lightsplus:gold_flat_light_on", "Gold Flat Light", "lightsplus_gold_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5},},},
}


for _, row in ipairs(lights) do
    local off = row[1]
    local on = row[2]
	local desc = row[3]
	local tiles = row[4]
	local paramtype = row[5]
	local paramtype2 = row[6]
	local drawtype = row[7]
	local nodebox = row[8]
    minetest.register_node(off, {
        description = desc,
		tiles = { tiles },
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2},
		paramtype = paramtype,
		paramtype2 = paramtype2,
		drawtype = drawtype,
		node_box = nodebox,
		selection_box = nodebox,
        on_punch = function(pos, node, puncher)
            minetest.set_node(pos, {name=on, param2=node.param2})
        end,
		on_place = function(itemstack, placer, pointed_thing)
			local keys=placer:get_player_control()
			lightsplus_rotate_and_place(itemstack, placer, pointed_thing, keys["sneak"])
		end
    })
    minetest.register_node(on, {
        description = desc.." (Active)",
        drop = off,
		tiles = { tiles },
		light_source = 14,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2, not_in_creative_inventory=2},
		paramtype = paramtype,
		paramtype2 = paramtype2,
		drawtype = drawtype,
		node_box = nodebox,
		selection_box = nodebox,
        on_punch = function(pos, node, puncher)
            minetest.set_node(pos, {name=off, param2=node.param2})
        end,
		on_place = function(itemstack, placer, pointed_thing)
			local keys=placer:get_player_control() 
			lightsplus_rotate_and_place(itemstack, placer, pointed_thing, keys["sneak"])
		end
    })
end


--	CRAFTING
--Light
minetest.register_craft({
	output = '"lightsplus:light" 10',
	recipe = {
		{'default:glass', 'default:glass', 'default:glass'},
		{'default:torch', 'default:torch', 'default:torch'},
		{'default:glass', 'default:glass', 'default:glass'},
	}
})

--Gold Light
minetest.register_craft({
	type = "shapeless",
	output = "lightsplus:gold_light",
	recipe = {'lightsplus:light', 'default:gold_ingot'},
})

--Gold Slab Light
minetest.register_craft({
	output = '"lightsplus:gold_slab_light" 6',
	recipe = {
		{'lightsplus:gold_light', 'lightsplus:gold_light', 'lightsplus:gold_light'},
	}
})

--Gold Light from Slabs
minetest.register_craft({
	output = '"lightsplus:gold_light"',
	recipe = {
		{'lightsplus:gold_slab_light'},
		{'lightsplus:gold_slab_light'},
	}
})

--Slab Light
minetest.register_craft({
	output = '"lightsplus:slab_light" 6',
	recipe = {
		{'lightsplus:light', 'lightsplus:light', 'lightsplus:light'},
	}
})

--Light from Slabs
minetest.register_craft({
	output = '"lightsplus:light"',
	recipe = {
		{'lightsplus:slab_light'},
		{'lightsplus:slab_light'},
	}
})

--Flat Light
minetest.register_craft({
	output = '"lightsplus:flat_light" 16',
	recipe = {
		{'lightsplus:light'},
	}
})

--Slab Light from Flat Light
minetest.register_craft({
	type = "shapeless",
	output = "lightsplus:slab_light",
	recipe = {'lightsplus:flat_light', 'lightsplus:flat_light', 'lightsplus:flat_light', 'lightsplus:flat_light', 'lightsplus:flat_light', 'lightsplus:flat_light', 'lightsplus:flat_light', 'lightsplus:flat_light'},
})

--Gold Flat Light
minetest.register_craft({
	output = '"lightsplus:gold_flat_light" 16',
	recipe = {
		{'lightsplus:gold_light'},
	}
})

--Gold Slab from Gold Flat Lights
minetest.register_craft({
	type = "shapeless",
	output = "lightsplus:gold_slab_light",
	recipe = {'lightsplus:gold_flat_light', 'lightsplus:gold_flat_light', 'lightsplus:gold_flat_light', 'lightsplus:gold_flat_light', 'lightsplus:gold_flat_light', 'lightsplus:gold_flat_light', 'lightsplus:gold_flat_light', 'lightsplus:gold_flat_light'},
})

minetest.register_alias("newlights:light", "lightsplus:light")
minetest.register_alias("newlights:light_on", "lightsplus:light_on")
minetest.register_alias("newlights:slab_light", "lightsplus:flat_light")
minetest.register_alias("newlights:slab_light_on", "lightsplus:flat_light_on")
minetest.register_alias("lightsplus:light_flat", "lightsplus:flat_light")
minetest.register_alias("lightsplus:slab_light_wall", "lightsplus:slab_light")
minetest.register_alias("lightsplus:slab_light_wall_on", "lightsplus:slab_light_on")
minetest.register_alias("lightsplus:slab_light_inv", "lightsplus:slab_light")
minetest.register_alias("lightsplus:slab_light_inv_on", "lightsplus:slab_light_on")
minetest.register_alias("lightsplus:light_gold", "lightsplus:gold_light")
minetest.register_alias("lightsplus:light_on_gold", "lightsplus:gold_light_on")
minetest.register_alias("lightsplus:slab_light_gold", "lightsplus:gold_slab_light")
minetest.register_alias("lightsplus:slab_light_on_gold", "lightsplus:gold_slab_light_on")
minetest.register_alias("lightsplus:slab_light_wall_gold", "lightsplus:gold_slab_light")
minetest.register_alias("lightsplus:slab_light_wall_on_gold", "lightsplus:gold_slab_light_on")
minetest.register_alias("lightsplus:slab_light_inv_gold", "lightsplus:gold_slab_light")
minetest.register_alias("lightsplus:slab_light_inv_on_gold", "lightsplus:gold_slab_light_on")
minetest.register_alias("lightsplus:light_flat", "lightsplus:flat_light")
minetest.register_alias("lightsplus:light_flat_on", "lightsplus:flat_light_on")
minetest.register_alias("lightsplus:light_flat_gold", "lightsplus:gold_flat_light")
minetest.register_alias("lightsplus:light_flat_on_gold", "lightsplus:gold_flat_light_on")







--	Register the function for use (optional, uncomment the following line to enable)
--	print("[Lights+] Loaded!")
