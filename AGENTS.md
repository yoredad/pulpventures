# AGENTS.md

## Engine and verification
- Godot 4.7 project. Engine: `C:\tools\Godot\Godot_v4.7.2-stable_win64_console.exe` (use the console exe for CLI output).
- No build, test, lint, or CI toolchain. Verify with headless Godot:
  - `& "C:\tools\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path <repo> --import`
  - `& ... --headless --path <repo> --quit-after 10` (append a scene path before `--quit-after` to run one scene)
  - `& ... --headless --path <repo> --editor --quit` and scan for `ERROR`/`Parse Error`
- After editing `project.godot`, reload the project in the editor; autoload and display changes are not picked up by an already-open session.

## Architecture
- Entry scene: `res://scenes/start_screen.tscn`; flow is start → menu → mini games via `get_tree().change_scene_to_file(...)`.
- `scenes/main.tscn` and `scripts/main.gd` are legacy placeholders; `themes/mobile_theme.tres` is only used by them. Do not build on them.
- `GameState` autoload (`scripts/game_state.gd`) holds `missions`, `villain`, `hero` and loads `res://heroes.json` + `res://villains.json` at startup. `select_random_encounter()` picks a random hero and villain and adds current `name` and `portrait` fields to each; the mini games screen calls it once on load.
- `MessageBus` autoload (`scripts/message_bus.gd`) is a global pub/sub bus: `register(topic, reference)` subscribes an object implementing `notify(topic: String, message: String)`; `notify(topic, message)` calls each subscriber registered for that topic. Duplicate references are ignored.
- `mini_games_screen.gd` intentionally resolves the singleton via `get_node_or_null("/root/GameState")`. If the editor reports `Identifier "GameState" not declared`, reload the project instead of changing the autoload setup.
- `scenes/mini_games_screen.tscn` reserves the top 300 px as a status area split into three 100 px rows: hero name + ABOUT button, villain name + ABOUT button, and the `%MessageArea` log. ABOUT buttons open `scenes/character_about_modal.tscn`, which shows the current `name`/`portrait` plus character details; REROLL rerolls stats and BACK closes it. The screen registers itself with `MessageBus` for each mini-game topic it launches (currently `outwit`) and replaces `%MessageArea` with each incoming message.
- Display is portrait 1080x2400 (`canvas_items` stretch). Desktop/editor use aspect `keep` with a 360x800 window override; `GameState` switches to `EXPAND` on mobile. Keep new UI in 1080x2400 coordinates.

## Mini game overlay contract
All mini games follow the same caller/overlay/result contract; do not replace the caller scene with `change_scene_to_file`.
- Each mini game is a full-screen scene instantiated by its caller and added as a child (`add_child`). The caller stays alive underneath, so its UI, `MessageBus` listeners, and `GameState.hero`/`villain` state persist.
- When the overlay is destroyed (via `queue_free()`), the caller must unregister from the `MessageBus` for that topic before the scene tree exits, to avoid "invalid previously freed instance" runtime errors. Always call `message_bus.unregister("<topic>", self)` in `_exit_tree()` or an equivalent cleanup function.
- The overlay root is a full-rect `Control` with `z_index = 100` and `mouse_filter = STOP`, so it draws above and blocks input to the caller. It closes itself with `queue_free()`.
- Each overlay exposes a `minigame_mode: bool` property local to the overlay. The caller sets it before `add_child()`; do not store it in `GameState`.
  - `minigame_mode = true`: show the mini game's initial/training layout (intro art, message area, Play/Back/About). Used by `mini_games_screen.gd`.
  - `minigame_mode = false`: skip the initial layout and start the game immediately. Used by mission callers.
  - Android back is allowed in minigame mode (closing an open modal first, then the overlay) and blocked in mission mode. Set `get_tree().quit_on_go_back = false` while the overlay is alive and restore the previous value on exit.
- When the mini game ends, it calls `MessageBus.notify("<topic>", "<result>")` (for example, `notify("outwit", "hero wins")` or `notify("outwit", "villain wins")`), shows the final result for its delay, then frees itself. The caller registers for that topic before launching the overlay and consumes the result in `notify(topic: String, message: String)`.
- Topic names match the mini game (`outwit`, and the equivalent topic for each future mini game). Define the result vocabulary per mini game.
- The mini games screen is the training caller (`minigame_mode = true`); the mission controller is the mission caller (`minigame_mode = false`).
- `gun-crowbar-knife-bomb-sword.md` and `scenes/outwit.tscn` are the reference implementation of this contract.

## Data
- `heroes.md` and `villains.md` are the editable source docs; `heroes.json` and `villains.json` are runtime data loaded with `FileAccess` from the project root. No generator exists — keep both formats in sync when editing.
- Stat system: `speed`, `strength`, `wits`, `charm`, `agility`, `luck` = sum of the highest 3 of 5 d6 rolls (3–18); `health` is always 10.
- Reroll rules: hero stats use highest 3 of 5 d6; villain stats use 3d6; `health` stays 10. `GameState.reroll_stats(character_type)` mutates the backing hero/villain object.
- Preserve CRLF line endings in the `.md` data docs.

## Stat checks
Whenever a `speed`, `strength`, `wits`, `charm`, `agility`, or `luck` check is performed, apply the modifier for the relevant ability score to the roll, then also apply the hero's current `luck` modifier (`roll + stat modifier + luck modifier`). A `luck` check applies the luck modifier only once.

- A natural d20 roll of 1 is an automatic failure, and a natural d20 roll of 20 is an automatic success, regardless of modifiers or difficulty.
- On a natural 20, permanently add +1 to the hero's `luck` stat. On a natural 1, permanently add -1 to the hero's `luck` stat.

| Ability Score | Modifier |
| --- | --- |
| <= 9 | -1 |
| 10-11 | +0 |
| 12-13 | +1 |
| 14-15 | +2 |
| 16-17 | +3 |
| 18-19 | +4 |
| 20+ | +5 |

## Specs and assets
- Behavior specs: `start-menu-game.md` (screens/buttons), `game_design.md` (adventure phases, mission schema), `combat_mini_game.md` (fight), `gun-crowbar-knife-bomb-sword.md` (outwit), `tick-tack-sexy.md` (seduce). Treat these as the source of truth.
- Default font: `res://assets/fonts/zai_CourierPolski1941.ttf` (italic variant: `zai_CourierPolski1941_i.ttf`). It is set as the project-wide default via `themes/default_theme.tres` (`gui/theme/custom` in `project.godot`); new text UI picks it up automatically.
- Button images in `assets/buttons/` are 200x100 JPEGs with baked-in labels; use `TextureButton` with `ignore_texture_size`, not text buttons.
- Primary target is Android portrait; export presets exist for Android, Windows, and Web (outputs go to `../output/`, which is gitignored).
