this is a godot 4.7 game intended for android phone
the godot engine is located here C:\tools\Godot
window size 1080x2400 for android phone

1. start screen
background color = black
display the splash image "C:\Users\YoreDad\Projects\godot\pulpventures\assets\splash\splash.jpg" with the top left corner at 0,0 of the viewport
at the bottom of the screen display 2 buttons Play and Quit side by side centered and divided by 20px of space and 10px from the bottom of the viewport
Play "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_play.jpg"
Quit "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_quit.jpg"
quit action = exit the application
play action = hide the start screen and show the menu screen

initialize the game state by calling a game state script object
this object should have a missions,villain and hero variable


2. menu screen
background color = black
split the screen into two halves 1080x1200 pixels
in the top section display the menu image "C:\Users\YoreDad\Projects\godot\pulpventures\assets\special\menu.jpeg" with the top left corner at 0,0 of the viewport
in the bottom section list 3 buttons vertically seperated by 20px centered in the section horizontally and vertically: Missions, Games, Back

Missions  "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_missions.jpg"
Games  "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_games.jpg"
Back  "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_back.jpg"

Missions Action = n/a for now
Games Action  = show the mini games screen
Back Action = return to start screen

3. mini games screen
background color = black
use the full resolution 1080x2400
list 5 buttons vertically seperated by 20px centered in the section horizontally and vertically: Evade,Fight,Run,Outwit,Seduce

Evade  "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_evade.jpg"
Fight  "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_fight.jpg"
Run  "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_run.jpg"
Outwit "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_outwit.jpg"
Seduce "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_seduce.jpg"

along the bottom 20px from the right border of the viewport and 10px from the bottom add a back button
Back  "C:\Users\YoreDad\Projects\godot\pulpventures\assets\buttons\button_back.jpg"

Evade action = select a random villain from the villains.json file and place in the game state script.  select a random hero from the heroes.json file and place in the game state script.
Fight action = select a random villain from the villains.json file and place in the game state script.  select a random hero from the heroes.json file and place in the game state script.
Run action = select a random villain from the villains.json file and place in the game state script.  select a random hero from the heroes.json file and place in the game state script.
Outwit action = select a random villain from the villains.json file and place in the game state script.  select a random hero from the heroes.json file and place in the game state script.
Back action = return to the mini games screen

