local death_cetro = {}
local give_on_death = minetest.settings:get_bool('death_cetro.give_on_death',true)

-- TODO : Add a stack based undo feature upto some limit

--Store (Temporarily) the player's death location
minetest.register_on_dieplayer(function(player)
    death_cetro[player:get_player_name()] = player:get_pos()
end)

--Give crystal when player dies (if give_on_death is true)
minetest.register_on_respawnplayer(function(player)
    if give_on_death and death_cetro[player:get_player_name()]then
        inv = player:get_inventory()
        inv:add_item("main","death_cetro:cetro")
    end
end)

minetest.register_craftitem("death_cetro:cetro", {
	description = "".. minetest.colorize("yellow", "scepter of return."),
	wield_scale = {x=0.75,y=0.75,z=0.75},
	inventory_image = "resurection_wand.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
        local died = death_cetro[user:get_player_name()]
        if died then
            local posd = {x = died.x, y = died.y+1, z = died.z}
            user:set_pos(posd)
            death_cetro[user:get_player_name()] = nil
            itemstack:take_item()
        else
            minetest.chat_send_player(user:get_player_name(),"You haven't died recently, congratulations!")
        end
        return itemstack
    end
})

-- if wand is not given on death then make it craftable
if not give_on_death then
    minetest.register_craft({
	    output = "death_cetro:cetro",
	    recipe = {
			    {"dye:red", "default:diamond", "dye:red"},
			    {"", "default:gold_ingot", ""},
			    {"", "default:gold_ingot", ""}
		     }
    })
end
