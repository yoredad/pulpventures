extends Control

const MENU_SCENE := "res://scenes/menu_screen.tscn"

@onready var play_button: TextureButton = %PlayButton
@onready var quit_button: TextureButton = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)


func _on_quit_pressed() -> void:
	get_tree().quit()
