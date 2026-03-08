extends CanvasLayer

class_name LoadingScreen

@onready var progress_bar : ProgressBar = $ProgressBar

func add_to_bar(add: float):
	progress_bar.value += add

func update_bar(new_value: float):
	progress_bar.value = new_value
