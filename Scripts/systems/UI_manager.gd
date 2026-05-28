extends CanvasLayer
class_name UIManager

var stack : Array[UI] = []

func _ready() -> void:
	var new_ui = load("uid://c208q5ch5o4vs").instantiate()
	add_child(new_ui)
	add(new_ui)
	new_ui.show()

func _process(delta: float) -> void:
	pass

func add(ui: UI) -> void:
	print("SIGNAL RECEIVED")
	print(ui.name)
	if not is_empty() and stack[-1] == ui:
		return
	hide_top()
	stack.append(ui)
	add_child(ui)
	show_top()

func back() -> void:
	remove_top()
	show_top()

func remove_top() -> void:
	if not is_empty():
		#stack[-1].queue_free()
		#stack.remove_at(-1)
		stack.pop_back().queue_free()

func is_empty() -> bool:
	return stack.is_empty()

func show_top() -> void:
	if not is_empty():
		stack[-1].show()
		
func hide_top() -> void:
	if not is_empty():
		print("Hiding top dawg: ", stack[-1].name)
		stack[-1].hide()

func _on_tree_entered() -> void:
	GlobalSignal.ui_transition_request.connect(add)
	GlobalSignal.ui_back_request.connect(back)

func _on_tree_exited() -> void:
	GlobalSignal.ui_transition_request.disconnect(add)
	GlobalSignal.ui_back_request.disconnect(back)
