extends Node

var missions: Array = []
var villain: Dictionary = {}
var hero: Dictionary = {}

var _heroes: Array = []
var _villains: Array = []


func _ready() -> void:
	_configure_display()
	_heroes = _load_json_array("res://heroes.json")
	_villains = _load_json_array("res://villains.json")


func _configure_display() -> void:
	var window := get_window()
	if OS.has_feature("mobile"):
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	else:
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP


func _load_json_array(path: String) -> Array:
	if not FileAccess.file_exists(path):
		push_warning("GameState: file not found: " + path)
		return []
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed is Array:
		return parsed
	push_warning("GameState: invalid JSON array in " + path)
	return []


func select_random_encounter() -> void:
	if not _villains.is_empty():
		villain = _villains.pick_random()
	if not _heroes.is_empty():
		hero = _heroes.pick_random()
