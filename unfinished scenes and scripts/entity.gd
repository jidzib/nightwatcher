extends CharacterBody2D

var target_position : Vector2 = Vector2.ZERO
var speed := 50
var player: Player
var direction: Vector2
@onready var agent = $Agent
func _ready():
	player = get_parent().player

func _process(delta: float) -> void:
	agent.target_position = get_parent().player.global_position
	direction = global_position.direction_to(agent.get_next_path_position())
	#position = position.move_toward(target_position, speed * delta)
	#if position.distance_to(target_position) < 1.0:
		#position = target_position

	velocity = lerp(velocity, speed*direction, delta)
	move_and_slide()
