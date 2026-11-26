this is the outwit mini game
track villain and player (hero) number of wins
game ends when one has a scored two victories
ties do not count for either vilain or hero
start the next round
villain and hero start with zero wins.  reset on scene loan
if game state is in minigame mode then display a quit button "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_quit.jpg" at the bottom.
clicking quit returns to the minigame menu

initial layout:
black background
replace the current scene with a new scene that is the full screen 1080x2400 divided into two 1080X1200 panels.

top panel:
display the outwit image positioned with its top left corner at 0,0 in the upper panel "C:\Users\YoreDad\Projects\godot\pulpventures\assets\special\outwit.jpg"
the image only has height 1100. reserve a 100 pixel bottom area for a text area that displays messages

bottom panel:
black background
array the following buttons in vertically spaced 10px appart and centered within the bottom panel
Play "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_play.jpg"
BAck "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_back.jpg"
About "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_about.jpg"

play action = start a round
back action = return to previous menu
about action = show a pop up modal with the flavor text from explanations.  add a Back button to close the modal.




perform a wits roll before each round.
generate a random number between 1 and 20.  if roll is <= to the players wits stat display a villain hint message.
1 = auto failure 20 = auto success

100x100 icons assets:
Gun="C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\gun.jpg"
Sword="C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\sword.jpg"
Crowbar="C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\crowbar.jpg"
Knife-"C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\knife.jpg"
Bomb="C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\bomb.jpg"


Weapons
Gun
Sword
Crowbar
Knife
Bomb

Win/Loss Relationships
Item	Beats	Loses To
Gun	Sword, Crowbar	Knife, Bomb
Sword	Crowbar, Knife	Gun, Bomb
Crowbar	Knife, Bomb	Gun, Sword
Knife	Bomb, Gun	Sword, Crowbar
Bomb	Gun, Sword	Crowbar, Knife

Flavor Explanations
Gun outranges the Sword and the Crowbar.
Sword parries the Crowbar and outranges the Knife.
Crowbar breaks the Knife and knocks away the Bomb.
Knife can backstab a Gun and disarm a Bomb.
Bomb blows up the Gun and the Sword.

Quick Reference
Gun     > Sword, Crowbar
Sword   > Crowbar, Knife
Crowbar > Knife, Bomb
Knife   > Bomb, Gun
Bomb    > Gun, Sword

Results Matrix
vs	Gun	Sword	Crowbar	Knife	Bomb
Gun	Tie	Win	Win	Lose	Lose
Sword	Lose	Tie	Win	Win	Lose
Crowbar	Lose	Lose	Tie	Win	Win
Knife	Win	Lose	Lose	Tie	Win
Bomb	Win	Win	Lose	Lose	Tie

This remains perfectly balanced: every weapon wins against 2, loses to 2, and ties with itself.

select the villains move with a random number between 1 and 5
1=gun 2=sword 3=knife 4=crowbar 5=bomb

display one of these corresponding villain hint messages randomly when player wins the wits roll check:
Intent to Shoot (Gun):
"I'm about to let the lead do the talking."
"His ticket's about to get punched."
"I'm turning the heat on this mug."
"This bird's flying into trouble."
"Looks like I'm closing his account."

Intent to Cut (Sword):
"I'm fixing to carve out an answer."
"Time to settle this the old-fashioned way."
"He'll be feeling the edge of the argument."
"This dance is about to get sharp."
"Let's see how he likes cold steel."

Intent to Stab (Knife):
"I'm getting in close for this one."
"I've got a point to make."
"This calls for a personal touch."
"He's about to learn a sharp lesson."
"One quick move oughta settle things."

Intent to Club (Crowbar):
"I'm about to rearrange his thinking."
"This sap needs a wake-up call."
"Time to introduce him to hard luck."
"He won't forget this meeting."
"I'm bringing a little persuasion."

Intent to Blow Up (Bomb):
"Things are about to go sky-high."
"This joint won't look the same tomorrow."
"I'm fixing to make a big impression."
"Stand back, the fireworks are starting."
"This caper's ending with a bang."

if the player loses the wits roll check display one of the following generic messages randomly:
"The curtain's about to come down."
"Looks like your luck just ran dry."
"This is where the story takes a turn."
"You're standing in the wrong place at the wrong time."
"The fat lady's warming up backstage."
"I've got a surprise with your name on it."
"The next few seconds oughta be memorable."
"This town's about to lose a customer."
"Your number just came up."
"Let's see how this chapter ends."