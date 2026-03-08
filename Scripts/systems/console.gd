extends CanvasLayer

@onready var command_line : LineEdit = $InputLine
@onready var log : VBoxContainer = $ScrollContainer/Log
@onready var scroll : ScrollContainer = $ScrollContainer

var COMMANDS : Dictionary[String, Callable] = {}
var player : Player

var log_scroll_amount : int = 100

func _ready():
	initialize_commands()

func _process(delta: float):
	if Input.is_action_just_pressed("enter"):
		try_command()
		
func initialize_commands():
	COMMANDS.set("add", add_item)
	COMMANDS.set("test", get_tile_in_neighbor)

func try_command():
	var command = command_line.text.split(" ")
	
	add_to_log("User input: " + command_line.text)
	
	if command[0].to_lower() in COMMANDS:
		COMMANDS[command[0].to_lower()].call(command)
	
	command_line.text = ""

func add_item(command: PackedStringArray):
	if command.size() != 3:
		add_to_log("Incorrect number of inputs", Color.RED)
		return
		
	elif int(command[2]) < 1:
		add_to_log("Incorrect input: Item number must be non-zero and non-negative", Color.RED)
		return
	
	var item_name = command[1].to_upper()
	
	if Enums.ItemIDs.has(item_name):
		player.inventory.add_item(References.ITEMS[Enums.ItemIDs[item_name]], int(command[2]))
		add_to_log("Successfully added item(s)", Color.GREEN)
	else:
		add_to_log("Item does not exist", Color.RED)

func get_tile_in_neighbor(command: PackedStringArray):
	var original_tile_coords_x = int(command[1]) # 0 
	var original_tile_coords_y = int(command[2]) # 40
	var relative_chunk_coords_x = int(command[3])
	var relative_chunk_coords_y = int(command[4])
	add_to_log(str(original_tile_coords_x-(relative_chunk_coords_x * Util.CHUNK_SIZE))+
				" , " +
				str(original_tile_coords_y-(relative_chunk_coords_y * Util.CHUNK_SIZE))
				)
															
func add_to_log(line: String, color: Color = Color.WHITE):
	var log_line : Label = Label.new()
	log_line.add_theme_font_size_override("font_size", 12)
	log_line.text = line
	log_line.modulate = color
	log.add_child(log_line)
	scroll.scroll_vertical += log_scroll_amount
