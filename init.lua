local death_cetro = {}
local storage = minetest.get_mod_storage()

-- TODO : Add a stack based undo feature upto some limit
-- **TODO : Add mod_storage to store player deaths/helps with restarts
-- TODO : wands can probably be recycled on server with recylcer

--Store (Temporarily) the player's death location
minetest.register_on_dieplayer(function(player)
    local name = player:get_player_name()
    local pos = player:get_pos()
    storage:set_string(name,minetest.serialize(pos))
end)

--Give crystal when player dies (always cause that makes sense)
minetest.register_on_respawnplayer(function(player)
    local name = player:get_player_name()
    if storage:get_string(name) then
        local inv = player:get_inventory()
        local name = player:get_player_name()
        if not inv then
            -- not sure if return works, have to check api
            -- its a global callback so return have no sense so maybe send a
            -- sensible message to player
            minetest.chat_send_player(name,"Could not load your inventory")
            return
        end
        -- check space for adding inventory
        if not inv:room_for_item("main", {name="death_cetro:cetro", count=1}) then
            minetest.chat_send_player(name,"Could not add cetro to inventory")
            return
        end
        inv:add_item("main","death_cetro:cetro")
        return true, "Death Cetro given!"
    end
end)

minetest.register_craftitem("death_cetro:cetro", {
	description = "".. minetest.colorize("yellow", "scepter of return."),
	wield_scale = {x=0.75,y=0.75,z=0.75},
	inventory_image = "resurection_wand.png",
    stack_max = 1,
	on_use = function(itemstack, player, pointed_thing)
        local name = player:get_player_name()
        local died = minetest.deserialize(storage:get_string(name))
        if died then
            local posd = {x = died.x, y = died.y+1, z = died.z}
            player:set_pos(posd)
            storage:set_string(name,nil)
            itemstack:take_item()
        else
            minetest.chat_send_player(name,"You haven't died recently, congratulations!")
        end
        return itemstack
    end
})

-- seems reasonable price to play respawn
minetest.register_craft({
    output = "death_cetro:cetro",
    recipe = {
            {"dye:red", "default:diamond", "dye:red"},
            {"", "default:gold_ingot", ""},
            {"", "default:gold_ingot", ""}
         }
})
