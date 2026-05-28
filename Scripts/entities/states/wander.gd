extends State

@export var wander_range : int = 12
@export var timer : Timer
var waiting : bool = false

func find_point() -> Vector2i:
	var attemps : int = 20
	for i in range(attemps):
		pass
		var offset : Vector2i = Vector2i(randi_range(-wander_range, wander_range), 
										 randi_range(-wander_range, wander_range))
		var target_tile : Vector2i = parent.tile_coords + offset
		if not parent.interaction_manager.get_object(target_tile):
			return target_tile
	
	return parent.tile_coords	
	
func enter() -> void:
	timer_loop()
	pass

func wander():
	if not parent.active:
		return
	
	var rand : int = randi_range(1, 10)
	
	if rand <= 5:
		parent.navigation_component.find_path(find_point())
	else:
		parent.navigation_component.path = []
		parent.stop_moving()
		#parent.velocity = Vector2.ZERO
		#parent.movement = Vector2.ZERO
	
	#parent.velocity = Vector2.ZERO
	#parent.movement = Vector2.ZERO	
	#wander()

func timer_loop() -> void:
	timer.start(randf_range(5.0, 20.0))
	await timer.timeout
	wander()
	timer_loop()
	
func _on_timer_timeout() -> void:
	waiting = false
