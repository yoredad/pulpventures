extends Control

## Full-screen outwit overlay.
##
## The caller instantiates this scene, sets [member minigame_mode], and adds it
## as a child. When the match ends the overlay notifies MessageBus on the
## "outwit" topic, waits for the final message, then frees itself.

const ROUND_DELAY := 3.0
const OUTWIT_IMAGE := preload("res://assets/special/outwit.jpg")

const WEAPONS := ["Gun", "Sword", "Crowbar", "Knife", "Bomb"]

const WEAPON_TEXTURES := {
	"Gun": preload("res://assets/buttons/gun.jpg"),
	"Sword": preload("res://assets/buttons/sword.jpg"),
	"Crowbar": preload("res://assets/buttons/crowbar.jpg"),
	"Knife": preload("res://assets/buttons/knife.jpg"),
	"Bomb": preload("res://assets/buttons/bomb.jpg"),
}

const BEATS := {
	"Gun": ["Sword", "Crowbar"],
	"Sword": ["Crowbar", "Knife"],
	"Crowbar": ["Knife", "Bomb"],
	"Knife": ["Bomb", "Gun"],
	"Bomb": ["Gun", "Sword"],
}

const HINTS := {
	"Gun": [
		"I'm about to let the lead do the talking.",
		"He's about to feel the heat.",
		"I'm locked and loaded.",
		"This is my boomstick.",
		"Time to pray and spray.",
	],
	"Sword": [
		"I'm fixing to carve out an answer.",
		"Time to taste my steel.",
		"He'll be feeling the edge of the argument.",
		"This dance is about to get sharp.",
		"Let's see how he likes cold steel.",
	],
	"Crowbar": [
		"I'm about to rearrange his thinking.",
		"This sap is about to get his bell rung.",
		"Time to introduce him to hard luck.",
		"Katie bar the door.",
		"I'm bringing a little persuasion.",
	],
	"Knife": [
		"I'm going to stick it to ya.",
		"I've got a point to make.",
		"This calls for a fast touch.",
		"He'll get the point in the end.",
		"One quick move oughta settle things.",
	],
	"Bomb": [
		"Things are about to go sky-high.",
		"Here comes the boom.",
		"I'm fixing to make a big impression.",
		"Stand back, the fireworks are starting.",
		"This caper's ending with a bang.",
	],
}

const GENERIC_MESSAGES := [
	"The curtain's about to come down.",
	"Looks like your luck just ran dry.",
	"This is where the story takes a turn.",
	"You're standing in the wrong place at the wrong time.",
	"The fat lady's warming up backstage.",
	"I've got a surprise with your name on it.",
	"The next few seconds oughta be memorable.",
	"This town's about to lose a customer.",
	"Your number just came up.",
	"Let's see how this chapter ends.",
]

const ABOUT_TEXT := """[color=#d3a84d][b]Gun[/b][/color]
Outranges the Sword and the Crowbar.

[color=#d3a84d][b]Sword[/b][/color]
Parries the Crowbar and outranges the Knife.

[color=#d3a84d][b]Crowbar[/b][/color]
Breaks the Knife and knocks away the Bomb.

[color=#d3a84d][b]Knife[/b][/color]
Can backstab a Gun and disarm a Bomb.

[color=#d3a84d][b]Bomb[/b][/color]
Blows up the Gun and the Sword."""

## Set by the caller before add_child(). True shows the pre-match layout;
## false skips it and starts the match immediately.
var minigame_mode := false

@onready var initial_view: Control = %InitialView
@onready var match_view: Control = %MatchView
@onready var play_button: TextureButton = %PlayButton
@onready var initial_back_button: TextureButton = %InitialBackButton
@onready var about_button: TextureButton = %AboutButton
@onready var about_modal: Control = %AboutModal
@onready var about_back_button: TextureButton = %AboutBackButton
@onready var about_details: RichTextLabel = %AboutDetails
@onready var message_label: Label = %MessageLabel
@onready var villain_portrait: TextureRect = %VillainPortrait
@onready var villain_weapon_icon: TextureRect = %VillainWeaponIcon
@onready var player_weapon_icon: TextureRect = %PlayerWeaponIcon
@onready var hero_score_label: Label = %HeroScoreLabel
@onready var villain_score_label: Label = %VillainScoreLabel
@onready var wits_plus_label: Label = %WitsPlusLabel
@onready var weapon_row: HBoxContainer = %WeaponRow

var _hero: Dictionary = {}
var _villain: Dictionary = {}
var _villain_weapon := ""
var _wits_success := false
var _hero_wins := 0
var _villain_wins := 0
var _round_active := false
var _tree: SceneTree
var _previous_quit_on_go_back: Variant = null


func _ready() -> void:
	_tree = get_tree()
	_disable_quit_on_back()

	var game_state: Node = get_node_or_null("/root/GameState")
	if game_state:
		if game_state.hero.is_empty() or game_state.villain.is_empty():
			game_state.select_random_encounter()
		_hero = game_state.hero
		_villain = game_state.villain
	if _hero.is_empty() or _villain.is_empty():
		push_warning("Outwit: hero or villain is missing; using default stats.")

	_connect_buttons()
	about_details.text = ABOUT_TEXT
	about_modal.hide()
	_set_message("")
	_set_weapon_buttons_enabled(false)
	_hide_weapon_icons()
	_update_score_labels()
	wits_plus_label.hide()

	if minigame_mode:
		initial_view.show()
		match_view.hide()
	else:
		initial_view.hide()
		match_view.show()
		call_deferred("_start_match")


func _exit_tree() -> void:
	if _tree and _previous_quit_on_go_back != null:
		_tree.set("quit_on_go_back", _previous_quit_on_go_back)


func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_go_back()


func _connect_buttons() -> void:
	play_button.pressed.connect(_on_play_pressed)
	initial_back_button.pressed.connect(_on_initial_back_pressed)
	about_button.pressed.connect(_on_about_pressed)
	about_back_button.pressed.connect(_on_about_back_pressed)

	if weapon_row.get_child_count() != WEAPONS.size():
		push_error("Outwit: weapon button count does not match the weapon list.")
		return
	for index in weapon_row.get_child_count():
		var button := weapon_row.get_child(index) as TextureButton
		if button:
			button.pressed.connect(_on_weapon_pressed.bind(WEAPONS[index]))


func _disable_quit_on_back() -> void:
	if not _tree:
		return
	var current: Variant = _tree.get("quit_on_go_back")
	if current != null:
		_previous_quit_on_go_back = current
		_tree.set("quit_on_go_back", false)


func _start_match() -> void:
	_hero_wins = 0
	_villain_wins = 0
	_update_score_labels()
	_wits_success = _roll_wits_check()
	wits_plus_label.visible = _wits_success
	initial_view.hide()
	match_view.show()

	var portrait := _load_texture(str(_villain.get("portrait", "")))
	villain_portrait.texture = portrait if portrait else OUTWIT_IMAGE
	_hide_weapon_icons()
	_start_round()


func _start_round() -> void:
	if _hero_wins >= 2 or _villain_wins >= 2:
		return

	_round_active = false
	_set_weapon_buttons_enabled(false)
	_hide_weapon_icons()

	_villain_weapon = str(WEAPONS.pick_random())
	if _wits_success:
		_set_message(_pick_random(HINTS[_villain_weapon]))
	else:
		_set_message(_pick_random(GENERIC_MESSAGES))

	_round_active = true
	_set_weapon_buttons_enabled(true)


func _roll_wits_check() -> bool:
	var hero_stats: Dictionary = _hero.get("stats", {})
	var villain_stats: Dictionary = _villain.get("stats", {})
	var wits := int(hero_stats.get("wits", 10))
	var luck := int(hero_stats.get("luck", 10))
	var villain_wits := int(villain_stats.get("wits", 10))
	var natural := randi_range(1, 20)

	if natural == 20:
		# AGENTS.md: a natural 20 permanently raises the hero's luck by 1.
		_adjust_hero_luck(1)
		return true
	if natural == 1:
		# AGENTS.md: a natural 1 permanently lowers the hero's luck by 1.
		_adjust_hero_luck(-1)
		return false

	var total := natural + _stat_modifier(wits) + _stat_modifier(luck)
	return total >= villain_wits


func _stat_modifier(value: int) -> int:
	if value <= 9:
		return -1
	if value <= 11:
		return 0
	if value <= 13:
		return 1
	if value <= 15:
		return 2
	if value <= 17:
		return 3
	if value <= 19:
		return 4
	return 5


func _adjust_hero_luck(delta: int) -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if not game_state or game_state.hero.is_empty():
		return
	var stats: Dictionary = game_state.hero.get("stats", {})
	stats["luck"] = int(stats.get("luck", 10)) + delta
	game_state.hero["stats"] = stats
	_hero = game_state.hero


func _on_play_pressed() -> void:
	_start_match()


func _on_initial_back_pressed() -> void:
	queue_free()


func _on_about_pressed() -> void:
	about_modal.show()


func _on_about_back_pressed() -> void:
	about_modal.hide()


func _on_go_back() -> void:
	if not is_node_ready():
		return
	if about_modal.visible:
		about_modal.hide()
		return
	if minigame_mode:
		queue_free()


func _on_weapon_pressed(weapon: String) -> void:
	if not _round_active:
		return
	_round_active = false
	_set_weapon_buttons_enabled(false)

	player_weapon_icon.texture = WEAPON_TEXTURES[weapon] as Texture2D
	player_weapon_icon.show()
	villain_weapon_icon.texture = WEAPON_TEXTURES[_villain_weapon] as Texture2D
	villain_weapon_icon.show()

	var outcome := _resolve_round(weapon, _villain_weapon)
	if outcome == "hero":
		_hero_wins += 1
		_set_message("Hero wins the round!")
	elif outcome == "villain":
		_villain_wins += 1
		_set_message("Villain wins the round!")
	else:
		_set_message("Tie! No one scores.")

	_update_score_labels()

	if _hero_wins >= 2:
		await _finish_match("hero wins")
	elif _villain_wins >= 2:
		await _finish_match("villain wins")
	else:
		await get_tree().create_timer(ROUND_DELAY).timeout
		if is_inside_tree():
			_start_round()


func _resolve_round(hero_weapon: String, villain_weapon: String) -> String:
	if hero_weapon == villain_weapon:
		return "tie"
	var beaten: Array = BEATS.get(hero_weapon, [])
	if villain_weapon in beaten:
		return "hero"
	return "villain"


func _finish_match(winner: String) -> void:
	if winner == "hero wins":
		_set_message("Hero wins the match!")
	else:
		_set_message("Villain wins the match!")

	var message_bus: Node = get_node_or_null("/root/MessageBus")
	if message_bus:
		message_bus.notify("outwit", winner)

	await get_tree().create_timer(ROUND_DELAY).timeout
	if is_inside_tree():
		queue_free()


func _set_message(text: String) -> void:
	message_label.text = text


func _update_score_labels() -> void:
	hero_score_label.text = "HERO: %d" % _hero_wins
	villain_score_label.text = "VILLAIN: %d" % _villain_wins


func _set_weapon_buttons_enabled(enabled: bool) -> void:
	var tint := Color(1, 1, 1, 1) if enabled else Color(1, 1, 1, 0.5)
	for child in weapon_row.get_children():
		var button := child as TextureButton
		if button:
			button.disabled = not enabled
			button.modulate = tint


func _hide_weapon_icons() -> void:
	villain_weapon_icon.texture = null
	villain_weapon_icon.hide()
	player_weapon_icon.texture = null
	player_weapon_icon.hide()


func _pick_random(messages: Array) -> String:
	if messages.is_empty():
		return ""
	return str(messages.pick_random())


func _load_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	var normalized := path.replace("\\", "/")
	if normalized.begins_with("res://"):
		if ResourceLoader.exists(normalized):
			return load(normalized) as Texture2D
		return null
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
