extends Item
class_name AxeItem

func use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player):
	var object = player.interaction_manager.get_selected_object(player)
	if not player.action_state == player.ActionStates.USING_ITEM and object and object.ID == Enums.ObjectType.TREE:
		player.action_state_machine.change_state(player.action_state_machine.current_state.using_item_state)
		#player.swing()
		# 
		object.hit(1)

func alt_use(world: World, chunk_coords: Vector2i, tile_coords: Vector2i, player: Player):
	pass

func set_type():
	type = Enums.ItemType.AXE
