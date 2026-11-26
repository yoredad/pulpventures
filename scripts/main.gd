extends Control

const BRIEFING_TEXT := "Your handler slides a dossier across the desk. The Obsidian Cabal has surfaced again, and another of their schemes must be stopped before dawn.\n\nObjective: infiltrate their hideout, secure the mission target, and escape."
const ARRIVAL_TEXT := "Your transport rumbles through the night. Ahead, the Cabal's hideout waits behind a guarded gate.\n\nArrival mini-game: car or plane."

@onready var phase_label: Label = %PhaseLabel
@onready var cutscene_label: Label = %CutsceneLabel
@onready var start_button: Button = %StartButton
@onready var game_area_hint: Label = %GameAreaHint

var _step := 0


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)


func _on_start_button_pressed() -> void:
	_step += 1
	match _step:
		1:
			phase_label.text = "PHASE A - MISSION BRIEFING"
			cutscene_label.text = BRIEFING_TEXT
			start_button.text = "DEPLOY"
			game_area_hint.text = "Mission dossier and player stats will appear here."
		_:
			phase_label.text = "PHASE B - ARRIVAL"
			cutscene_label.text = ARRIVAL_TEXT
			start_button.visible = false
			game_area_hint.text = "The arrival mini-game will run here."
