extends Control

const MENU_SCENE := "res://scenes/menu_screen.tscn"

@onready var evade_button: TextureButton = %EvadeButton
@onready var fight_button: TextureButton = %FightButton
@onready var run_button: TextureButton = %RunButton
@onready var outwit_button: TextureButton = %OutwitButton
@onready var seduce_button: TextureButton = %SeduceButton
@onready var back_button: TextureButton = %BackButton


func _ready() -> void:
	evade_button.pressed.connect(_on_mini_game_selected)
	fight_button.pressed.connect(_on_mini_game_selected)
	run_button.pressed.connect(_on_mini_game_selected)
	outwit_button.pressed.connect(_on_mini_game_selected)
	seduce_button.pressed.connect(_on_mini_game_selected)
	back_button.pressed.connect(_on_back_pressed)


func _on_mini_game_selected() -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if game_state:
		game_state.select_random_encounter()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)
