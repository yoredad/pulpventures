extends Control

const MENU_SCENE := "res://scenes/menu_screen.tscn"
const ABOUT_MODAL_SCENE := preload("res://scenes/character_about_modal.tscn")
const OUTWIT_SCENE := preload("res://scenes/outwit.tscn")

@onready var back_button: TextureButton = %BackButton
@onready var hero_about_button: TextureButton = %HeroAboutButton
@onready var villain_about_button: TextureButton = %VillainAboutButton
@onready var outwit_button: TextureButton = %OutwitButton
@onready var hero_name_label: Label = %HeroNameLabel
@onready var villain_name_label: Label = %VillainNameLabel
@onready var message_area: RichTextLabel = %MessageArea


func _ready() -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if game_state:
		game_state.select_random_encounter()
		hero_name_label.text = str(game_state.hero.get("name", ""))
		villain_name_label.text = str(game_state.villain.get("name", ""))
	var message_bus: Node = get_node_or_null("/root/MessageBus")
	if message_bus:
		message_bus.unregister("outwit", self)
		message_bus.register("outwit", self)
	hero_about_button.pressed.connect(_on_about_pressed.bind("hero"))
	villain_about_button.pressed.connect(_on_about_pressed.bind("villain"))
	outwit_button.pressed.connect(_on_outwit_pressed)
	back_button.pressed.connect(_on_back_pressed)


func _exit_tree() -> void:
	var message_bus: Node = get_node_or_null("/root/MessageBus")
	if message_bus:
		message_bus.unregister("outwit", self)


func notify(topic: String, message: String) -> void:
	if topic == "outwit":
		message_area.text = message


func _on_about_pressed(character_type: String) -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if not game_state:
		return
	var character: Dictionary = game_state.hero if character_type == "hero" else game_state.villain
	if character.is_empty():
		return
	var modal: CharacterAboutModal = ABOUT_MODAL_SCENE.instantiate()
	add_child(modal)
	modal.show_character(character, character_type)


func _on_outwit_pressed() -> void:
	var outwit: Control = OUTWIT_SCENE.instantiate()
	outwit.set("minigame_mode", true)
	add_child(outwit)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)
