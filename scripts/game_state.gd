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
	villain = _create_character(_villains)
	hero = _create_character(_heroes)


func _create_character(pool: Array) -> Dictionary:
	if pool.is_empty():
		return {}
	var character: Dictionary = (pool.pick_random() as Dictionary).duplicate(true)
	var names: Array = character.get("names", [])
	var portraits: Array = character.get("portraits", [])
	character["name"] = names.pick_random() if not names.is_empty() else ""
	character["portrait"] = portraits.pick_random() if not portraits.is_empty() else ""
	return character


func reroll_stats(character_type: String) -> void:
	var character: Dictionary = hero if character_type == "hero" else villain
	if character.is_empty():
		return
	var stats: Dictionary = character.get("stats", {})
	for stat_name in stats.keys():
		if stat_name == "health":
			continue
		stats[stat_name] = _roll_highest_three_of_five() if character_type == "hero" else _roll_three_d6()
	stats["health"] = 10
	character["stats"] = stats


func _roll_highest_three_of_five() -> int:
	var rolls: Array[int] = []
	for _die in 5:
		rolls.append(randi_range(1, 6))
	rolls.sort()
	return rolls[2] + rolls[3] + rolls[4]


func _roll_three_d6() -> int:
	var total := 0
	for _die in 3:
		total += randi_range(1, 6)
	return total
