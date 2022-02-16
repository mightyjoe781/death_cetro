local death_cetro = {}
local give_on_death = true

--Almacenar (Temporalmente) la ubicacion de muerte del jugador
minetest.register_on_dieplayer(function(player)
    death_cetro[player:get_player_name()] = player:get_pos()
end)

--Dar el cristal cuando el player muere (si give_on_death es verdadero)
minetest.register_on_respawnplayer(function(player) 
    if give_on_death and death_cetro[player:get_player_name()]then
        inv = player:get_inventory()
        inv:add_item("main","death_cetro:cetro")
    end 
end)

minetest.register_craftitem("death_cetro:cetro", {
	description = "".. minetest.colorize("yellow", "cetro del retorno."),
	wield_scale = {x=0.75,y=0.75,z=0.75},
	inventory_image = "resurection_wand.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
        local died = death_cetro[user:get_player_name()]
        if died then
            local posd = {x = died.x, y = died.y+1, z = died.z}
            user:set_pos(posd)
            minetest.chat_send_all(died.x .. died.y .. died.z)
            death_cetro[user:get_player_name()] = nil
            itemstack:take_item()
        else
            minetest.chat_send_player(user:get_player_name(),"No has muerto recientemente, ¡felicidades!")
        end
        return itemstack
    end
})

if not give_on_death then
    minetest.register_craft({
	    output = "death_cetro:cetro",
	    recipe = {
			    {"dye:red", "default:diamond", "dye:red"},
			    {"", "default:gold_ingot", ""},
			    {"", "default:gold_ingot", ""}
		     }
    })
else


end
