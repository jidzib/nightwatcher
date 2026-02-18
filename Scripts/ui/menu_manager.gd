extends Control

class_name StartMenu

enum MenuState {
	MAIN,
	WORLD_SELECT,
	CREATE_WORLD,
	SETTINGS
}

@onready var menus = {
	MenuState.MAIN: $Menus/MainMenu,
	MenuState.WORLD_SELECT: $Menus/WorldSelectMenu,
	MenuState.CREATE_WORLD: $Menus/CreateWorldMenu,
	MenuState.SETTINGS: $Menus/SettingsMenu
}

var current_state: MenuState

func _ready():
	DirAccess.make_dir_recursive_absolute("user://worlds/")
	switch_menu(MenuState.MAIN)

func switch_menu(state: MenuState):
	for menu in menus.values():
		menu.visible = false
	
	menus[state].visible = true
	current_state = state
	
func _on_play_button_pressed() -> void:
	switch_menu(MenuState.WORLD_SELECT)

func _on_settings_button_pressed() -> void:
	switch_menu(MenuState.SETTINGS)
	
func _on_quit_button_pressed() -> void:
	pass # Replace with function body.

func _on_create_world_button_pressed() -> void:
	switch_menu(MenuState.CREATE_WORLD)

func _on_create_button_pressed() -> void:
	menus[current_state].create_world()
