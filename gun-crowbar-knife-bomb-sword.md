# Outwit Mini Game

## Overview

- Full-screen overlay scene: `res://scenes/outwit.tscn`.
- The caller instantiates the scene, sets `minigame_mode`, then adds it as a child. The calling scene stays alive underneath.
- The overlay uses `z_index = 100`, covers the full 1080x2400 viewport, and closes itself with `queue_free()`.
- `minigame_mode` is local to the outwit scene and is set by the caller. It is not stored in `GameState`.
- The hero and villain come from `GameState.hero` and `GameState.villain`.
- On match end, call `MessageBus.notify("outwit", "hero wins")` or `MessageBus.notify("outwit", "villain wins")`. The caller's listener consumes the result.

## Match Rules

- Hero and villain wins start at 0 when the match starts.
- The first side to reach 2 wins takes the match.
- Ties award no wins and start the next round.
- The score is displayed at the top left of the green play mat: hero above villain. The message area and the revealed weapon icons provide the rest of the feedback.
- Round results and the final result stay visible for 3 seconds before advancing or closing.

## Layout

Viewport: 1080x2400.

### Minigame-mode initial screen

- Black background.
- Intro image `res://assets/special/outwit.jpg` at `(0, 0)`, size 1080x1100.
- Message area 1080x100 at `y = 1100`.
- Bottom panel 1080x1200 at `y = 1200`.
- Play, Back, and About buttons are 200x100, separated by 10 px, and centered within the bottom panel.
- Play starts the match.
- Back closes the overlay.
- About opens the weapon guide modal.

### Match view

- Villain portrait 1080x1100 at `(0, 0)`, using `GameState.villain["portrait"]`. Fall back to `outwit.jpg` if the portrait is missing.
- Message area 1080x100 at `y = 1100`. Shows the round hint or generic message, the round result, and the final result.
- Green play mat 1080x1100 at `(0, 1200)`.
- Score labels at the top left of the play mat: `HERO: 0` above `VILLAIN: 0`. Reset both to 0 when the match starts.
- A `+` indicator at the top right of the play mat when the one-time wits check succeeded. Hide it when the check failed; it stays in that state for the match.
- Player and villain weapon icons display at 300x300 after the player selects, centered as a pair inside the play mat, separated by 200 px: villain left, player right.
- Both weapon icons stay hidden until the player selects a weapon.
- Five 100x100 weapon buttons run along the bottom at `y = 2300-2400`, centered, with 20 px gaps: Gun, Sword, Crowbar, Knife, Bomb.
- Play, Back, and About are hidden during the match.

### Mission mode

- `minigame_mode = false`.
- Skip the initial screen and open directly in the match view. Round 1 starts immediately.
- No Play, Back, or About buttons.
- Android back is blocked for the entire match.

### Minigame mode

- `minigame_mode = true`.
- Show the initial screen. Play starts the match.
- Android back closes the About modal if it is open; otherwise it closes the overlay. It is allowed before and during the match.

## About Modal

- Opened from the About button.
- Shows the five weapon matchup explanations only. Do not show the Quick Reference or Results Matrix.
- A Back button closes the modal.

## Wits Check

- Perform the wits check once at the start of the match, before round 1.
- Roll `d20 + hero wits modifier + hero luck modifier`.
- Compare the total after modifiers to the villain's raw `wits` stat.
- A natural 1 is an automatic failure.
- A natural 20 is an automatic success.
- A natural 20 permanently adds +1 to `GameState.hero["stats"]["luck"]`.
- A natural 1 permanently subtracts 1 from `GameState.hero["stats"]["luck"]`.
- The success or failure result carries forward through every round. Do not reroll it between rounds.
- Show a `+` at the top right of the play mat when the check succeeds. Hide it when the check fails; it stays in that state for the match.
- Each round still chooses a new hidden villain weapon. On a carried success, show a hint for that weapon. On a carried failure, show a generic message.

| Ability Score | Modifier |
| --- | --- |
| <= 9 | -1 |
| 10-11 | +0 |
| 12-13 | +1 |
| 14-15 | +2 |
| 16-17 | +3 |
| 18-19 | +4 |
| 20+ | +5 |

## Round Flow

1. Match start: reset wins to 0-0, perform the one-time wits check, and show the match view.
2. Round start: hide both weapon icons, randomly choose a hidden villain weapon, display a random hint for that weapon if the wits check succeeded or a random generic message if it failed, then enable the weapon buttons.
3. Player selection: show the player icon on the right and the villain icon on the left, resolve the round with the weapon matrix, update the win counts and score labels, and display one of:
   - `Hero wins the round!`
   - `Villain wins the round!`
   - `Tie! No one scores.`
4. Disable the weapon buttons while the result is visible.
5. If neither side has 2 wins, wait 3 seconds and start the next round.
6. If a side has 2 wins, display `Hero wins the match!` or `Villain wins the match!`, call `MessageBus.notify("outwit", "hero wins")` or `MessageBus.notify("outwit", "villain wins")`, wait 3 seconds, then `queue_free()` the overlay.

The final notification happens as soon as the final result is displayed, so the caller can update its own UI behind the overlay during the 3-second wait.

The round result does not name the villain's weapon; the revealed icon in the play mat shows it.

## Weapon Order

Use this order everywhere:

1. Gun
2. Sword
3. Crowbar
4. Knife
5. Bomb

## Win/Loss Relationships

| Item | Beats | Loses To |
| --- | --- | --- |
| Gun | Sword, Crowbar | Knife, Bomb |
| Sword | Crowbar, Knife | Gun, Bomb |
| Crowbar | Knife, Bomb | Gun, Sword |
| Knife | Bomb, Gun | Sword, Crowbar |
| Bomb | Gun, Sword | Crowbar, Knife |

## Flavor Explanations

- Gun outranges the Sword and the Crowbar.
- Sword parries the Crowbar and outranges the Knife.
- Crowbar breaks the Knife and knocks away the Bomb.
- Knife can backstab a Gun and disarm a Bomb.
- Bomb blows up the Gun and the Sword.

## Quick Reference

```
Gun     > Sword, Crowbar
Sword   > Crowbar, Knife
Crowbar > Knife, Bomb
Knife   > Bomb, Gun
Bomb    > Gun, Sword
```

## Results Matrix

| vs | Gun | Sword | Crowbar | Knife | Bomb |
| --- | --- | --- | --- | --- | --- |
| Gun | Tie | Win | Win | Lose | Lose |
| Sword | Lose | Tie | Win | Win | Lose |
| Crowbar | Lose | Lose | Tie | Win | Win |
| Knife | Win | Lose | Lose | Tie | Win |
| Bomb | Win | Win | Lose | Lose | Tie |

Every weapon wins against 2, loses to 2, and ties with itself.

## Villain Hint Messages

Display one of these randomly when the carried wits result is a success. The hint must correspond to the current hidden villain weapon.

Intent to Shoot (Gun):
- "I'm about to let the lead do the talking."
- "He's about to feel the heat."
- "I'm locked and loaded."
- "This is my boomstick."
- "Time to pray and spray."

Intent to Cut (Sword):
- "I'm fixing to carve out an answer."
- "Time to taste my steel."
- "He'll be feeling the edge of the argument."
- "This dance is about to get sharp."
- "Let's see how he likes cold steel."

Intent to Stab (Knife):
- "I'm going to stick it to ya."
- "I've got a point to make."
- "This calls for a fast touch."
- "He'll get the point in the end."
- "One quick move oughta settle things."

Intent to Club (Crowbar):
- "I'm about to rearrange his thinking."
- "This sap is about to get his bell rung."
- "Time to introduce him to hard luck."
- "Katie bar the door."
- "I'm bringing a little persuasion."

Intent to Blow Up (Bomb):
- "Things are about to go sky-high."
- "Here comes the boom."
- "I'm fixing to make a big impression."
- "Stand back, the fireworks are starting."
- "This caper's ending with a bang."

## Generic Villain Messages

Display one of these randomly when the carried wits result is a failure:

- "The curtain's about to come down."
- "Looks like your luck just ran dry."
- "This is where the story takes a turn."
- "You're standing in the wrong place at the wrong time."
- "The fat lady's warming up backstage."
- "I've got a surprise with your name on it."
- "The next few seconds oughta be memorable."
- "This town's about to lose a customer."
- "Your number just came up."
- "Let's see how this chapter ends."

## Assets

Use `res://` paths, never absolute Windows paths.

- `res://assets/special/outwit.jpg` (1080x1100)
- `res://assets/buttons/button_play.jpg` (200x100)
- `res://assets/buttons/button_back.jpg` (200x100)
- `res://assets/buttons/button_about.jpg` (200x100)
- `res://assets/buttons/gun.jpg` (100x100)
- `res://assets/buttons/sword.jpg` (100x100)
- `res://assets/buttons/crowbar.jpg` (100x100)
- `res://assets/buttons/knife.jpg` (100x100)
- `res://assets/buttons/bomb.jpg` (100x100)

## Integration Notes

- The mini games screen launches the overlay with `minigame_mode = true` from its Outwit button handler.
- The mini games screen registers for the `outwit` topic and displays the result in its message area.
- Mission mode launches the overlay with `minigame_mode = false`. The mission controller must register for the `outwit` topic before launching it.
- The overlay must not replace the calling scene.
- If `GameState.hero` or `GameState.villain` is empty when the overlay loads, select a random encounter before starting.
