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
- `GameState` autoload (`scripts/game_state.gd`) holds `missions`, `villain`, `hero` and loads `res://heroes.json` + `res://villains.json` at startup. Mini-game buttons call `GameState.select_random_encounter()`.
- `mini_games_screen.gd` intentionally resolves the singleton via `get_node_or_null("/root/GameState")`. If the editor reports `Identifier "GameState" not declared`, reload the project instead of changing the autoload setup.
- Display is portrait 1080x2400 (`canvas_items` stretch). Desktop/editor use aspect `keep` with a 360x800 window override; `GameState` switches to `EXPAND` on mobile. Keep new UI in 1080x2400 coordinates.

## Data
- `heroes.md` and `villains.md` are the editable source docs; `heroes.json` and `villains.json` are runtime data loaded with `FileAccess` from the project root. No generator exists — keep both formats in sync when editing.
- Stat system: `speed`, `strength`, `wits`, `charm`, `agility`, `luck` = sum of the highest 3 of 5 d6 rolls (3–18); `health` is always 10.
- Preserve CRLF line endings in the `.md` data docs.

## Specs and assets
- Behavior specs: `start-menu-game.md` (screens/buttons), `game_design.md` (adventure phases, mission schema), `combat_mini_game.md` (fight), `gun-crowbar-knife-bomb-sword.md` (outwit), `tick-tack-sexy.md` (seduce). Treat these as the source of truth.
- Button images in `assets/buttons/` are 200x100 JPEGs with baked-in labels; use `TextureButton` with `ignore_texture_size`, not text buttons.
- Primary target is Android portrait; export presets exist for Android, Windows, and Web (outputs go to `../output/`, which is gitignored).
