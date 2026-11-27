class_name CharacterAboutModal
extends Control

@onready var portrait_rect: TextureRect = %Portrait
@onready var character_name_label: Label = %CharacterNameLabel
@onready var title_label: Label = %TitleLabel
@onready var details_label: RichTextLabel = %DetailsLabel
@onready var reroll_button: TextureButton = %RerollButton
@onready var back_button: TextureButton = %BackButton

var _character: Dictionary = {}
var _character_type := "hero"


func _ready() -> void:
	reroll_button.pressed.connect(_on_reroll_pressed)
	back_button.pressed.connect(_on_back_pressed)


func show_character(character: Dictionary, character_type: String) -> void:
	_character = character
	_character_type = character_type
	_refresh()


func _refresh() -> void:
	character_name_label.text = str(_character.get("name", ""))
	title_label.text = str(_character.get("title", ""))
	portrait_rect.texture = _load_portrait(str(_character.get("portrait", "")))
	details_label.text = _build_details()


func _build_details() -> String:
	var lines: PackedStringArray = []
	if _character_type == "hero":
		_add_section(lines, "Description")
		lines.append(str(_character.get("description", "")))

		var traits: Array = _character.get("traits", [])
		if not traits.is_empty():
			_add_section(lines, "Traits")
			for trait_text in traits:
				lines.append("• " + str(trait_text))

		var catchphrase := str(_character.get("catchphrase", ""))
		if not catchphrase.is_empty():
			_add_section(lines, "Catchphrase")
			lines.append("\"" + catchphrase + "\"")
	else:
		_add_section(lines, "Monologue")
		lines.append(str(_character.get("monologue", "")))

		var henchman_title := str(_character.get("henchmanTitle", ""))
		var henchman := str(_character.get("henchman", ""))
		if not henchman.is_empty():
			_add_section(lines, henchman_title if not henchman_title.is_empty() else "Henchman")
			lines.append(henchman)

		var praise := str(_character.get("praise", ""))
		if not praise.is_empty():
			_add_section(lines, "Praise")
			lines.append("\"" + praise + "\"")

		var thugs: Array = _character.get("thugs", [])
		if not thugs.is_empty():
			_add_section(lines, "Thugs")
			lines.append(", ".join(PackedStringArray(thugs)))

	_add_section(lines, "Stats")
	var stats: Dictionary = _character.get("stats", {})
	for stat_name in stats.keys():
		lines.append("%s: %d" % [str(stat_name).to_upper(), int(stats[stat_name])])

	return "\n".join(lines)


func _add_section(lines: PackedStringArray, title: String) -> void:
	if not lines.is_empty():
		lines.append("")
	lines.append("[color=#d3a84d][b]%s[/b][/color]" % title)


func _load_portrait(path: String) -> Texture2D:
	if path.is_empty():
		return null
	var normalized := path.replace("\\", "/")
	var assets_index := normalized.find("assets/")
	if assets_index != -1:
		var res_path := "res://" + normalized.substr(assets_index)
		if ResourceLoader.exists(res_path):
			return load(res_path) as Texture2D
	if FileAccess.file_exists(path):
		var image := Image.load_from_file(path)
		if image:
			return ImageTexture.create_from_image(image)
	return null


func _on_reroll_pressed() -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if not game_state:
		return
	game_state.reroll_stats(_character_type)
	_character = game_state.hero if _character_type == "hero" else game_state.villain
	_refresh()


func _on_back_pressed() -> void:
	queue_free()
