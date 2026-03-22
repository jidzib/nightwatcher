extends CharacterBody2D

class_name Entity

var target_position : Vector2 = Vector2.ZERO
var speed := 20
var player: Player
var direction: Vector2
@onready var agent = $Agent
@onready var sprite : AnimatedSprite2D = $Sprite

enum States {
	IDLE, WALK
}
var state : States = States.IDLE


func _ready():
	sprite.play("idle")
	sprite.speed_scale = 0.8
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://shaders/outline.gdshader")
	
func _physics_process(delta: float) -> void:
		
	if state == States.WALK:
		direction = global_position.direction_to(agent.get_next_path_position())
		
		if direction.x >= 0:
			sprite.scale.x = 1.0
		else:
			sprite.scale.x = -1.0
		
		
		velocity = direction * speed
		move_and_slide()

func set_highlighted(value: bool):
	sprite.material.set_shader_parameter("enabled", value)



func _on_mouse_entered() -> void:
	print("MOUSE ENTERED")
	set_highlighted(true)

func _on_mouse_exited() -> void:
	set_highlighted(false)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("right_click"):
		
		if state == States.IDLE:
			state = States.WALK
			agent.target_position = player.global_position
			sprite.play("walk")
		else:
			state = States.IDLE
			sprite.play("idle")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
