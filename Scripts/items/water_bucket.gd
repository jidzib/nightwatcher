class_name WaterBucketItem
extends Item

func use(world: World, tile_coords: Vector2i, player: Player) -> void:
	#var obj = player.interaction_manager.get_selected_object(player)
	var obj = player.interaction_manager.selected_object
	if !player.action_state == player.ActionStates.USING_ITEM and obj and obj.ID == Enums.ObjectType.FARMLAND:
		if !obj.can_water():
			return
		player.action_state_machine.change_state(player.action_state_machine.current_state.using_item_state)
		obj.water()
	
func alt_use(world: World, tile_coords: Vector2i, player: Player) -> void:
	pass
