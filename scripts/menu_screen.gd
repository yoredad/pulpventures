extends Control

const START_SCENE := "res://scenes/start_screen.tscn"
const MINI_GAMES_SCENE := "res://scenes/mini_games_screen.tscn"

@onready var missions_button: TextureButton = %MissionsButton
@onready var games_button: TextureButton = %GamesButton
@onready var back_button: TextureButton = %BackButton


func _ready() -> void:
	missions_button.pressed.connect(_on_missions_pressed)
	games_button.pressed.connect(_on_games_pressed)
	back_button.pressed.connect(_on_back_pressed)


func _on_missions_pressed() -> void:
	pass


func _on_games_pressed() -> void:
	get_tree().change_scene_to_file(MINI_GAMES_SCENE)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(START_SCENE)
