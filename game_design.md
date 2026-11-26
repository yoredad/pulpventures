this is a godot 4.7 game intended for android phone
the godot engine is located here C:\tools\Godot
window size 1080x2400 for android phone
split into two windows 1080x1200
the upper window is for menus and cutscenes
the lower window is the game layout.

create a micro adventure game set in a fictional pulp setting of the 1930s and 1940s.  Your hero Colt Fusion works for a mysterious government agency.  The villians are members of evil organization
The Obsidian Cabal.  They are a secret society of occult billionaires  who seek world domination through occult rituals, terror, blackmail and kidnapping.  Colt Fusion's job is to thwart their schemes.  
The game should use the Godot 4.6 engine locaated here C:\tools\Godot.  The game consists of randomly generated micro adventures that follow this same basic 5 phases:

draw a room card
cards may have encounters
there is always a garage card and an airfield card
there is always an objective card
the objective  card must be completed before the airfield card or garage card can be used
room cards are randomly generated

villain Archtypes:
Pirate
Cult Leader
Occultist
Mad Scientist
General
Warlord
Mobster
Shadow
Tycoon
Mastermind
Geneticist
Dictator

Thug Archtypes:
goth/thief
gypsy/goon
mechanic/lab assistant
cultistm/cultistf
strongman/catwoman
soldierm/soldierf
ninja/pirate
robot/gorilla

mission template:
{
"missions":
[{"name":"Recover the stolen plans",
"description":"",
"briefing":"",
"goal":"",
"type":"",
"item":"",
"fail_image":"",
"success_image":""
"minigame":"",
"room":"",
"villain":""
}
]
}

A. mission briefing
B. arrival mini game: car or plane
C. sneak fight,evade,run,outwit,seduce (female only)  guards/thugs/occultists of both genders while searching for safe, victim, or machine
D. open safe -> plans ,lock -> victim, destroy->machine/robot/missile
E. escape mini game: car or plane

note: phase C repeats a random number of times from 2 to 10.  after the final success the location of the safe,lock (cell), machine/robot/missle is revealed.  then phase D starts

Phase A.
0. the player starts with random stats on a scale of 1 - 10 of speed,strength,wits,charm,agility and health (always starts at 10). 
1. display the player stats and give the player the option to re-roll stats 3 times.
1. mission briefing - retrieve plans from safe or rescue victim or destroy death machine/robot/missile
2. arrive at the base, factory, club, hide out, mansion via car or plane via turn based combat mini game using a hand of randomly distributed action cards
3. sneak fight,evade,run,outwit,seduce (female only)  guards/thugs/occultists of both genders while searching for safe, victim, or machine

5. open safe via combination mini game,  or unlock doors with a lock picking mini game,  randomly placed items can also be used like crowbars can be used to break the door or explosives can be used to blow open the safe / destroy the machine
6. distribute items in random boxes, chests, drawers or on thugs,occultists,guards
7. after plans are retrieved, victim rescued or machine destroyed,  then escape eitther by car or plane again using turn based combat using a hand of randomly distribured action cards
8. when player health reaches <=0 the game is over.
9. the game ends when the phase E is completed

Phase B,E.


Phase C.
4. all fight,evade,run,outwit,seduce checks are accomplished on a random 20 sided dice roll with 20 being thte best (automatic success) and 1 being the worst (automatic failure). 
4.a add fight,evade,run,outwit,seduce button for the user to click and randomly roll a value from 1-20.  seduce will be disabled if opponent is maie.
4.b rolls are augmented with player statistics speed,strength,wits,charm,agility
4.c randomly compute a difficulty from 1 to 20 and compare the roll + stat bonus: fight->strength,evade->agility,run->speed,outwit->wits,seduce->charm
4.d success a 50% chance of a random item: crowbar, dynamite, lockpick, tonic=health +1, adrenaline->speed+1, elixer->strength+1, mushroom->wits+1,blue pill->charm+1,monkey paw->agility+1
4.e stat boosting items are consumed immediately and the corresponding stat boosted.  the rest are carried in inventory
4.e failure results in  health -1 and loss of inventory items.
4.f once the location is obtained, proceed to phase D
4.f if player health <= 0 the game ends

Inventory Items:
crowbar -> bypass lock mini game, bypass destroy the machine mini game
lockpick -> bypass the lock mini game
dynamite -> bypass the safe mini game, destroy the machine mini game
c4 -> bypass the safe mini game, bypass the lock mini game, destroy the machine mini game
combination -> bypass the safe mini game


car / plane mini game combat:
goal: reduce the computer plane/car to <= 0 health by playing cards
0. each players car/plan has 10 points of health
1. both offensive and defensive cards should be available as well as a draw pile to draft additional cards up to 5.
2. card play consists of two actions per player and computer opponent.  actions consist of playing one card or d2scarding and drawing a card.  
3. at the start of the turn cards are drawn until the hand consists of 5 cards.  
4. card types are damage +1,+2 or +3, stun (causes opponent to skip the next turn), evasion -> played from the hand when an opponent plays a damage card,  or heal the car/plane +1, +2 or +3
5. computer strategy is basically all damage based.   it only plays damage cards and draws if it does not have any in its hands.  it never plays stun, evasion or heal cards and will discard them
for damage cards if it does not have any.
6. if the computer plays a damage card,  the player has the option to play an evasion card from his hand.
7. mini game ends when computer car/plan health  <= 0 or player car/plane health <=0 (game ends)
8. if player wins proced to the next phase. if this is phase E the game ends
9. if the computer wins trigger 1 phase C event then continue with the current phase

safe mini game:
goal: line up the dial with the 3 combination numbers without the dial going past the number 
1. the safe has a dial with a pointer on it.  the player clicks a button and the dial rotates clockwise. 
2. in a fixed circle on the safe are numbers from 1 - 30. 
3. randomly choose 3 numbers from 1 - 30 to form the combination
4. highlight the first number in the combination
5. the player must click stop button when the pointer on the dial is pointing at the highlighted number.  the dial may not pass the highlighted number.
6. when the stop button is clicked stop the dial if it is on the lighted number.  highlight the next number and reverse the dial direction.  
7. if the dial is pointed at the lighted number and it is the last number the game ends with a success and the game proceeds to phase E
8. if the dial not pointed at the lighted number or goes past the lighted number the game ends in failure
9. on failure the mini games ends and there is a 60% random chance to encounter a guard/thug/occultist  (repeat phase C until one success then return to phase D and repeat the mini game)

lock pick mini game:
goal: click lighted circles 10 time consecutively
display a vertical grid of 6 squares.  inside each square is a circle.  this represents the pins on the lock
randomly light one of the circles for .3 seconds
the player must click the lighted circle before the light goes out
the player must do this 10 times in a row to unlock the lock
missing one of the lighted circles ends the game in failure
clicking all 10 in a row triggers success and the victim is released. proceed to phase E
on failure the mini games ends and there is a 60% random chance to encounter a guard/thug/occultist  (repeat phase C until one success then return to phase D and repeat the mini game)

destroy the machine mini game:
goal: trigger an overload by connectiong the 8 colored circuits.
1. display a vertical grid of 8 squares.  inside each square is a random colored circle (red,dark blue,yellow,orange,green,white,gray,cyan)
2. display a second column of squares next to the ones from step 1 on the right side.  these squares are empty.
3. beneath the two columns is button  that says connect.
4. display the two columns and button off center left by 100 pixels.
5. repeat steps 1 through 3 except that the empty squares are to the left side.
6. display the 2 columns and button from step 5 offset right by 100 pixels.
7. randomly pick one of the colors and display the circle in the top empty square on the right
8. rotate through all 8 colors
9. every .3 seconds move the colored circle to the next lower empty square.
10. after the last square go back to the top and start over
11. when the user clicks the connect buttom beneath the two grids. stop the moving circle.  if the color of the adjacent circle is the same color then success.  stop the circle and start over at the top with the next random color. if they don't match then failure.
12. skip over squares with already lit circles.  when you get to the last color blink it every .2 seconds.  the last colored circle must be lit when connect is clicked for success. if it is not lit then failure.
13. simultaneausly perform steps 7-12 on the left columns.  utilize the left connect button.
14. once the goal is met proceed to phase E
15. on failure the mini games ends and there is an encounter with a guard/thug/occultist  (repeat phase C until one success then return to phase D and repeat the mini game)

thug threats:
"You're on thin ice."
"Watch your back."
"Your luck's running out."
"Keep pushing and see what happens."
"You've got one chance left."
"Don't test me."
"You're making a big mistake."
"I'll remember this."
"You're out of your league."
"The clock's ticking."
"You're playing a dangerous game."
"You won't like what's next."
"This ends badly for you."
"You've been warned."
"Don't make me come back."
"Your time is coming."
"You're standing on borrowed time."
"You picked the wrong enemy."
"This isn't over."
"You'll regret that."

witty responses:
"Big talk for a rental villain."
"I've heard scarier parking tickets."
"You practice that in the mirror?"
"That's your best line?"
"I've survived worse Wi-Fi."
"You're all bark, no sequel."
"Careful, you're straining your ego."
"I'd be worried if you sounded competent."
"Threatening me isn't a personality."
"You peak at intimidation and still miss."
"I've seen tougher-looking accountants."
"Your reputation does all the work. You don't."
"Keep talking. You're weakening your case."
"Was that a threat or a cry for attention?"
"I expected danger, not stand-up comedy."
"Your confidence isn't backed by evidence."
"You're auditioning for a role nobody cast."
"If words were punches, you'd still miss."
"The scary act needs a rewrite."
"Come back when you have better material."

"I've met puddles deeper than you."
"You couldn't intimidate a goldfish."
"That's cute. Try again."
"You sound tougher in your head."
"I've heard stronger threats from toddlers."
"Did someone write that line for you?"
"You bring drama, not danger."
"I almost took you seriously."
"Your bark needs subtitles."
"The act is convincing. The actor isn't."
"You talk like a final boss and fight like a tutorial."
"Confidence isn't a substitute for talent."
"You're trying way too hard."
"I've seen folding chairs with more backbone."
"Threats are cheaper than results."
"I see the mouth moving. That's about it."
"You'd lose an argument with an echo."
"The only thing dangerous here is your overconfidence."
"You're a warning label without a product."
"For someone so loud, you say very little."

villain boast:
"At last, the pieces align."
"Let the world witness greatness."
"The final act begins."
"Everything has led to this."
"Now the fun starts."
"So it begins."
"History changes today."
"No one can stop this now."
"The future is mine."
"Watch destiny unfold."
"The game is over."
"Time to reshape the board."
"Behold my masterpiece."
"Let chaos bloom."
"The waiting is over."
"Witness perfection."
"Let's see who laughs last."
"The age of fools ends today."
"This is the moment."
"Everything proceeds as planned."

thug succeeds:
"Told you I'd come out on top."
"That's how it's done."
"Never doubted it for a second."
"King stays king."
"Another win for me."
"You should've walked away."
"I make this look easy."
"Game over."
"The house always backs me."
"I don't lose."
"Guess who's still standing."
"That's why they fear me."
"Too easy."
"I called it from the start."
"The crown fits perfectly."
"This city knows my name."
"Nobody does it better."
"You brought a knife to a chess match."
"Put another notch on the scoreboard."
"Victory looks good on me."

thug failed:
"This wasn't supposed to happen."
"You got lucky."
"It's not over yet."
"I underestimated you."
"Enjoy the moment."
"You win... this time."
"I won't forget this."
"You caught me off guard."
"Next time will be different."
"I had a bad day anyway."
"Don't get used to it."
"You earned that one."
"This changes nothing."
"I should've seen that coming."
"You think this is the end?"
"I hate losing."
"Fine. You got me."
"The boss won't like this."
"I'll be back on my feet."
"Guess the odds finally caught up to me."

villain triumph:
"At last! Victory is mine!"
"Behold my triumph!"
"I have done the impossible!"
"No one can stop me now!"
"The world is mine!"
"Witness true power!"
"I stand above all!"
"This is my greatest achievement!"
"I told you I would prevail!"
"Bow before greatness!"
"Everything has gone according to plan!"
"I am unstoppable!"
"The age of heroes is over!"
"Let history remember this day!"
"My genius has won the day!"
"At last, my destiny is fulfilled!"
"The future belongs to me!"
"Who dares challenge me now?"
"This is only the beginning!"
"I have conquered all!"

villain failure:
"No... this can't be!"
"Impossible!"
"I was so close!"
"You ruined everything!"
"This isn't over!"
"How could I lose?"
"My plan was flawless!"
"Curse you!"
"I refuse to accept this!"
"You've only delayed the inevitable!"
"Enjoy your victory while it lasts!"
"I underestimated you."
"This changes nothing!"
"You got lucky!"
"I'll return stronger!"
"The world will regret this!"
"You think you've won?"
"I should have destroyed you when I had the chance!"
"My defeat is only temporary!"
"Remember this moment... it won't last!"

seduction lines:
"You're the prettiest sight in the room, doll."
"Mind if I steal a moment of your time?"
"A face like yours ought to come with a warning."
"You've got the whole room beat without even trying."
"I was doing fine until you walked in."
"Tell me, do you always leave a trail of broken hearts?"
"A dame with class is hard to find these days."
"You make this old world look brand new."
"I think destiny just pulled up a chair."
"Care to help a fellow forget his troubles?"
"You're more intoxicating than champagne."
"I could cross an ocean chasing a smile like that."
"You've got style, and that's a rare commodity."
"I was hoping fate would be kind tonight."
"The band sounds better since you arrived."
"If charm were a contest, you'd be the trophy."
"Let's give the gossip column something to wonder about."
"You make it awfully difficult to look anywhere else."
"One dance, and I promise you'll remember my name."
"The night was ordinary until I met you."

seduction success:
"You say that to all the girls, don't you?"
"My, aren't you the charmer?"
"That's quite a line you've got there."
"And does that usually work?"
"You're awfully sure of yourself."
"I suppose you practiced that speech."
"Careful, mister, your ego's showing."
"Well, points for originality."
"You're a smooth operator, I'll give you that."
"Flattery will get you everywhere."
"You certainly know how to start a conversation."
"Is that the best you've got?"
"I ought to walk away... but I'm curious."
"You make a habit of sweeping dames off their feet?"
"Maybe I'll humor you for a minute."
"You're trouble, aren't you?"
"I can't decide whether to laugh or blush."
"Buy me a soda and I might believe you."
"You've got nerve, I'll say that much."
"All right, handsome. What's your next line?"

seduction fail:
"Sorry, handsome, but I'm not buying what you're selling."
"You'll have to try that line on another dame."
"Nice try, but no cigar."
"I've heard better from a radio announcer."
"You're charming, but I'm not interested."
"Keep practicing. You'll get there someday."
"I wasn't born yesterday, mister."
"Save your charm for someone who believes it."
"That's awfully flattering, but I'll pass."
"You seem nice enough, but I'm not collecting admirers."
"You talk a good game."
"I'm afraid you're barking up the wrong tree."
"Sorry, but my dance card's full."
"I think you're in love with your own reflection."
"You're smooth, but not that smooth."
"Why don't you give the next girl a chance?"
"I'm sure that routine kills in another town."
"I came here for the music, not the sales pitch."
"You're wasting perfectly good charm on me."
"Better luck next time, Romeo."

hero success:
"You should've stayed down the first time."
"That's the breaks, pal."
"Better luck next round."
"I warned you."
"Looks like the house picked me."
"You had your shot."
"Don't feel bad. Nobody's perfect."
"That all you've got?"
"You picked the wrong guy."
"Guess we're done here."
"Take a walk, tough guy."
"The night's over for you."
"I hope you learned something."
"You talk better than you fight."
"I've had tougher mornings."
"Maybe next time, pal."
"The smart money was on me."
"You should've quit while you were ahead."
"That's one for the record books."
"Now stay down and save us both the trouble."

hero failure:
"You got me fair and square."
"Guess I had that coming."
"You're tougher than you look."
"Not my lucky night."
"All right, pal, you win."
"I've taken worse."
"I won't make that mistake twice."
"You packed quite a wallop."
"Next time it'll be different."
"Can't win 'em all."
"The better man won tonight."
"I was off my game."
"You caught me sleeping."
"That's the way the cards fall."
"Looks like the odds were right."
"Well, there goes my reputation."
"You earned that one."
"Save me a little dignity, will ya?"
"Don't get too comfortable on top."
"Enjoy the victory, kid."

jailor:
"There's no escaping the cell!"
"You can save your excuses. The bars don't care."
"Meals come twice a day. Complaints come all day."
"Don't test the locks. They've beaten smarter men than you."
"Quiet down. The walls have heard enough already."
"You're safer behind those bars than out there."
"If you need something, ask. If you're planning something, don't."
"Another day served. Plenty more to go."
"I've seen prisoners come and go. You're just like the rest."
"Remember, prisoner: freedom starts with surviving today."

rescue:
"Thank you... you saved my life."
"I thought it was over. Thank you."
"You came back for me. Thank you."
"I can't thank you enough."
"You were my miracle today."
"Thank you for not giving up on me."
"I owe you everything."
"You got me out alive. Thank you."
"I thought no one would find me."
"Thank you for bringing me home."
"You gave me another chance."
"I'll never forget what you did."
"You were there when I needed help."
"Thank you for saving my family and me."
"I didn't think I'd make it."
"You're a true hero. Thank you."
"Because of you, I'm still here."
"Thank you for risking your life for mine."
"You answered my prayers."
"From the bottom of my heart, thank you."

complaints:
"Hey, easy on the turns!"
"Do you always drive this fast?"
"I think I left my stomach back there."
"Watch where you're going!"
"Can you avoid at least one pothole?"
"That landing was rough!"
"Are you trying to shake us apart?"
"I've had smoother rides on a farm wagon."
"Maybe slow down a little?"
"Was that turbulence or your flying?"
"You call this a smooth flight?"
"I think we missed the road... again."
"Could you stop swerving?"
"I've never been carsick before today."
"The seatbelt shouldn't be this necessary."
"Next time, try aiming for the runway."
"Are those flying lessons refundable?"
"Please tell me that noise is normal."
"I'd like to arrive in one piece."
"Remind me never to ride with you again."

compliments:
"That was a smooth ride!"
"You've got a steady hand on the wheel."
"Best flight I've had all year."
"You make this look easy."
"That landing was perfect."
"I barely felt us touch down."
"You're a natural behind the controls."
"Now that's professional driving."
"Smooth as silk the whole way."
"I feel safer riding with you."
"You handled that like a pro."
"Not a single bump to complain about."
"You've got real talent."
"That was one comfortable trip."
"I could relax the entire ride."
"You navigated that beautifully."
"First-class driving right there."
"You made a difficult trip feel easy."
"I'd ride with you again anytime."
"Five stars from this passenger!"

villain curses:
"You blundering fool!"
"Must I do everything myself?"
"You couldn't guard a paper bag!"
"Hopeless! Absolutely hopeless!"
"You had one simple task!"
"I've seen sharper minds in a sack of hammers!"
"You let the hero escape again!"
"Incompetence is becoming your specialty!"
"You dim-witted oaf!"
"I've trained chimpanzees with more discipline!"
"You call that a plan?"
"Your failures are exhausting."
"Do you have any idea what you've cost me?"
"Even my enemies are more useful than you!"
"You couldn't capture a sleeping kitten!"
"The next mistake will be your last!"
"Why do I surround myself with idiots?"
"You've turned triumph into disaster!"
"Get out of my sight before I lose my temper!"
"No wonder the hero makes fools of you!"

hero catchphrases:
"Justice never misses its mark!"
"The game's up, villains!"
"Not while I'm on the case!"
"Looks like your luck just ran out!"
"Adventure's calling!"
"Let's give 'em what for!"
"No crook gets away on my watch!"
"The truth always wins out!"
"Looks like we've got work to do!"
"Another mystery solved!"
"Nobody pushes innocent folks around!"
"Time to even the odds!"
"I've tangled with worse than you!"
"Let's wrap this up, boys!"
"The good guys aren't finished yet!"
"That's the trouble with evil, it gets careless!"
"Looks like justice just arrived!"
"You picked the wrong side of the law!"
"Courage, friends! We have them on the run!"
"The day is ours!"
"The guilty cannot hide forever!"
"Onward to victory!"
"The tide's turning our way!"
"Stand fast, men!"
"Crime doesn't pay!"
"The fearless prevail!"
"Another triumph for justice!"
"The sea belongs to the bold!"
"Let's clip their wings!"
"Never count a hero out!"

todo:
generate fist/target icons
generate heart/dagger icons
generate an escape button
generate dialog for the suduction mini game player/villainf