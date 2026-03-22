class_name HoeItem
extends Item

func use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]

	if player.action_state == player.ActionStates.NO_ACTION:
		#var obj = player.interaction_manager.get_selected_object(player)
		var obj = player.interaction_manager.selected_object
		if obj and obj.ID == Enums.ObjectType.FARMLAND:
			#obj.change_tile(player.interaction_manager)
			#func update_surroundings(origin_tile: Vector2i, chunk_coords: Vector2i,
						 #interaction_manager: InteractionManager)
			if obj.crop_id and obj.is_max_stage():
				obj.harvest()
				player.action_state_machine.change_state(player.action_state_machine.current_state.using_item_state)
		
		if obj:
			return
			
		#var tile = player.interaction_manager.get_selected_tile(player)
		var tile_id = player.interaction_manager.selected_tile
		if tile_id == Enums.TileLayer.GRASS:
			player.action_state_machine.change_state(player.action_state_machine.current_state.using_item_state)
			chunk.add_object(References.OBJECTS[Enums.ObjectType.FARMLAND].instantiate(), tile_coords)
			chunk.OBJECTS[tile_coords].autotile.update_surroundings(tile_coords, chunk_coords, player.interaction_manager)
func alt_use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player) -> void:
	var chunk = world.chunk_manager.CHUNKS[chunk_coords]
	
	if player.action_state == player.ActionStates.NO_ACTION:
		var obj = player.interaction_manager.selected_object
		if obj and obj.ID == Enums.ObjectType.FARMLAND and !obj.crop_id:
			player.action_state_machine.change_state(player.action_state_machine.current_state.using_item_state)
			var neighbors : Array[FarmlandObject] = []
			var world_coords : Vector2i = Util.chunk_and_tile_to_world(chunk_coords, tile_coords)
			for dir in obj.autotile.DIRS:
				var neighbor : MapObject = player.interaction_manager.get_object(world_coords+dir)
				if neighbor and neighbor.ID == obj.ID:
					neighbors.append(neighbor)
			chunk.remove_object(tile_coords)
			for neighbor in neighbors:
				var bitmask : int = neighbor.autotile.calculate_bitmask(
					neighbor.tile_coords, neighbor.chunk_coords, player.interaction_manager)
				neighbor.autotile.switch_tile(bitmask)
