--LIGHTS+ 
--updated 12/11/2013
--Mod adding simple on/off lights by qwrwed.
--updated 11/11/2018
--Added colored lights by stefan77.

if minetest.get_modpath("unified_inventory") or not minetest.setting_getbool("creative_mode") then
        lightsplus_expect_infinite_stacks = false
else
        lightsplus_expect_infinite_stacks = true
end

local colors = {
  { "blue", "dye:blue", "Blue" },
  { "brown", "dye:brown", "Brown" },
  { "cyan", "dye:cyan", "Cyan" },
  { "dark_green", "dye:dark_green", "Dark Green" },
  { "green", "dye:green", "Green" },
  { "magenta", "dye:magenta", "Magenta" },
  { "orange", "dye:orange", "Orange" },
  { "pink", "dye:pink", "Pink" },
  { "red", "dye:red", "Red" },
  { "violet", "dye:violet", "Violet" },
  { "yellow", "dye:yellow", "Yellow" },
  { "gold", "default:gold_ingot", "Gold" }
}

--Node Definitions and Functions
local lights = {
	{"lightsplus:light", "lightsplus:light_on", "Light", "lightsplus_light.png", "", "", "facedir", ""},
	{"lightsplus:slab_light", "lightsplus:slab_light_on", "Slab Light", "lightsplus_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},},},
	{"lightsplus:flat_light", "lightsplus:flat_light_on", "Flat Light", "lightsplus_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5},},}
}

for _, row in ipairs(colors) do
  local color = row[1]
  local name = row[3]

  table.insert(
    lights,
    {"lightsplus:"..color.."_light", "lightsplus:"..color.."_light_on", name.." Light", "lightsplus_"..color.."_light.png", "", "facedir", "", ""}
  )

  table.insert(
      lights,
      {"lightsplus:"..color.."_slab_light", "lightsplus:"..color.."_slab_light_on", name.." Slab Light", "lightsplus_"..color.."_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},},}
    )

  table.insert(
      lights,
    	{"lightsplus:"..color.."_flat_light", "lightsplus:"..color.."_flat_light_on", name.." Flat Light", "lightsplus_"..color.."_light.png", "light", "facedir", "nodebox", {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5},},}
    )
end


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
		on_place = minetest.rotate_and_place
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
		on_place = minetest.rotate_and_place
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





for _, row in ipairs(colors) do
  local color = row[1]
  local item = row[2]
  local name = row[3]

  --Colored Light
  minetest.register_craft({
    type = "shapeless",
    output = "lightsplus:"..color.."_light",
    recipe = {'lightsplus:light', item},
  })

  --Colored Slab Light
  minetest.register_craft({
    output = '"lightsplus:'..color..'_slab_light" 6',
    recipe = {
      {'lightsplus:'..color..'_light', 'lightsplus:'..color..'_light', 'lightsplus:'..color..'_light'},
    }
  })

  --Colored Light from Slabs
  minetest.register_craft({
    output = '"lightsplus:'..color..'_light"',
    recipe = {
      {'lightsplus:'..color..'_slab_light'},
      {'lightsplus:'..color..'_slab_light'},
    }
  })

  --Colored Flat Light
  minetest.register_craft({
    output = '"lightsplus:'..color..'_flat_light" 16',
    recipe = {
      {'lightsplus:'..color..'_light'},
    }
  })

  --Colored Slab from Colored Flat Lights
  minetest.register_craft({
    type = "shapeless",
    output = "lightsplus:"..color.."_slab_light",
    recipe = {'lightsplus:'..color..'_flat_light', 'lightsplus:'..color..'_flat_light', 'lightsplus:'..color..'_flat_light', 'lightsplus:'..color..'_flat_light', 'lightsplus:'..color..'_flat_light', 'lightsplus:'..color..'_flat_light', 'lightsplus:'..color..'_flat_light', 'lightsplus:'..color..'_flat_light'},
  })

end






--[[
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
]]--






--	Register the function for use (optional, uncomment the following line to enable)
--	print("[Lights+] Loaded!")
