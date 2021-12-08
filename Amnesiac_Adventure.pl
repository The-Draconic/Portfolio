/* Amnesiac Adventures, a text-based adventure game, by Brian Harris.
   See also INSTRUCTIONS.md
   Consult this file and issue the command:   start.  */

:- dynamic at/2, i_am_at/1, alive/1, wearing/1,dead/1,count/1.  /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).


count(40).


/* This defines the starting location. */

i_am_at(start_room).


/* These facts describe how the rooms are connected.
   Paths connected to start_room */

path(start_room, n, boss_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(start_room, n, boss_room) :-
at(key, in_hand).
path(start_room, n, boss_room) :-
write('The door is shut tight by a lock.'),
nl, fail.
path(boss_room, s, start_room).

path(start_room, e, east_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(start_room, e, east_room).
path(east_room, w, start_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(east_room, w, start_room).

path(start_room, w, west_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(start_room, w, west_room).
path(west_room, e, start_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(west_room, e, start_room).

path(start_room, s, corridor) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(start_room, s, corridor).
path(corridor, n, start_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(corridor, n, start_room).


/* Paths from east_room */

path(east_room, n, drink_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(east_room, n, drink_room).
path(drink_room, s, east_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(drink_room, s, east_room).

path(east_room, e, key_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(east_room, e, key_room) :-
dead(goblin).
path(east_room, e, key_room) :-
alive(goblin),
at(apple, in_hand),
retract(at(apple, in_hand)),
assert(at(apple, goblin)),
assert(at(flower, in_hand)),
write('You give the apple to the goblin, and it gives you'), nl,
write('a flower before it lets you through.'), nl, !.
path(east_room, e, key_room) :-
alive(goblin),
at(apple, goblin),
write('The goblin lets you pass peacefully.'), nl, !.
path(east_room, e, key_room) :-
alive(goblin),
write('A goblin blocks your way, its growls at you with a rusty'), nl,
write('dagger in its hands.'), nl, !, fail.
path(key_room, w, east_room).


/* Paths from west_room */

path(west_room, n, smith_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(west_room, n, smith_room).
path(smith_room, s, west_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(smith_room, s, west_room).

path(west_room, w, sword_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(west_room, w, sword_room).
path(sword_room, e, west_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(sword_room, e, west_room).


/* Corridor */

path(corridor, s, apple_room) :-
wearing(eyelids), !.
path(corridor, s, apple_room) :-
at(eyelids, in_hand),
write('As you walk, you feel yourself going forward, but you'), nl,
write('don\'t see yourself getting any closer to the apple.'), nl, !, fail.
path(apple_room, n, corridor) :-
wearing(eyelids), !.
path(apple_room, n, corridor) :-
at(eyelids, in_hand),
write('As you walk, you feel yourself going forward, but you'), nl,
write('do not see yourself getting any closer to the exit.'), nl.

/* Path Between Drinking Room and Boss Room */

path(drink_room, w, boss_room) :-
wearing(eyelids),
write('You cannot see where you are going.'), nl, !, fail.
path(drink_room, w, boss_room) :-
dead(puzzle).
path(drink_room, w, boss_room) :-
write('You run straight into the puzzle in the wall.'), nl,
write('What are you doing, silly?'), nl, !, fail.
/* Boss Room to Exit*/

path(boss_room, n, exit) :-
dead(curse).
path(boss_room, n, exit) :-
alive(dragon),
write('You can\'t exit the dungeon, the dragon blocks your path.'),
nl, !, fail.
path(boss_room, n, exit).

/* These facts tell where the various objects in the game are located. */

at(key, key_room).
at(sword, sword_room).
at(apple, apple_room).
at(alcohol, drink_room).
at(eyelids, in_hand).


/* These facts specify what is dead or alive. */

alive(dragon).
alive(goblin).
alive(puzzle).
alive(curse).
dead(sword).


/* These rules describe how to pick up an object. */

take(sword) :-
dead(sword),
i_am_at(Place),
at(X, Place),
retract(at(X, Place)),
assert(at(X, in_hand)),
write('You now have a rusty sword. It can\'t hurt anything now,'), nl,
write('so you should find someone to repair it.'),
nl, nl,
time, !.

take(sword) :-
alive(sword),
i_am_at(Place),
at(X, Place),
retract(at(X, Place)),
assert(at(X, in_hand)),
write('You now have a sword. It is in good condition to protect'), nl,
write('yourself or to hurt others.'),
nl, nl,
time, !.

take(sword) :-
write('It isn\'t here.'),
nl, !, fail.

take(X) :-
at(X, in_hand),
write('You\'re already holding it!'),
nl, nl,
time, !.

take(X) :-
i_am_at(Place),
at(X, Place),
retract(at(X, Place)),
assert(at(X, in_hand)),
write('Ok.'),
nl, nl,
time, !.  

take(_) :-
write('It isn\'t here'),
nl, !, fail.

wear(X):-
assert(wearing(X)),
time.

remove(X) :-
retract(wearing(X)),
time.  

i :-
at(X,in_hand),
write(X), nl,
time.      

/* This rule describes closing and opening eyes */

close_eyes :-
wear(eyelids),
write('You now can\'t see anything.'),
nl, nl, !.

open_eyes :-
remove(eyelids),
write('You can see again.'),
nl, nl, !.


/* These rules are for the drink room */

drink :-
i_am_at(drink_room),
write('You take a seat, put your feet on the table and start'), nl,
write('drinking your sorrows away. You can\'t take yourself away'), nl,
write('from the bottle and spend the rest of your days in despair.'), nl,
!, die.

drink :-
write('What is there to drink?'), nl, !, fail.

resist :-
i_am_at(drink_room),
write('You decide not to drink and continue with the hope of'), nl,
write('finding a way out of here. But maybe you can take the bottle'), nl,
write('for some kind of use.'), nl, nl,
time, !.

resist :-
write('What are you doing? Weirdo.'), nl, !, fail.


/* These rules describe how to put down an object. */

drop(eyelids) :-
write('You can\'t drop your eyelids, crazy!'), nl, nl,
time, !.

drop(X) :-
at(X, in_hand),
i_am_at(Place),
retract(at(X, in_hand)),
assert(at(X, Place)),
write('Ok.'),
nl, nl,
time, !.

drop(_) :-
write('You aren\'t holding it!'),
nl, nl,
time.


/* These rules define the six direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* This rule tells how to move in a given direction. */

go(Direction) :-
i_am_at(Here),
path(Here, Direction, There),
retract(i_am_at(Here)),
assert(i_am_at(There)),
look,
time, !.

go(_) :-
write('You can\'t go that way.'), nl,
time, !, fail.


/* This rule tells how to look about you. */

look :-
wearing(eyelids),
write('You can\'t see.'), nl.
                                       
look :-
i_am_at(Place),
describe(Place),
notice_objects_at(Place).

/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
at(X, Place),
write('There is a '), write(X), write(' here.'), nl, nl,
fail.

notice_objects_at(_).


/* These rules tell how to attack*/

attack :-
i_am_at(east_room),
at(sword, in_hand),
alive(sword),
retract(alive(goblin)),
assert(dead(goblin)),
write('You take your sword and easily take the live of'), nl,
write('the goblin, blood spills on the floor.'), nl, nl,
time.

attack :-
i_am_at(east_room),
at(sword, in_hand),
write('You attempt to use the rusty blade against the'), nl,
write('goblin, but it fails to kill him and he kills you instead.'),
nl, !, die.

attack :-
i_am_at(east_room),
write('You can only attack the goblin with your fists,'), nl,
write('but it doesn\'t take long for him to take you out.'), nl, !, die.

attack :-
i_am_at(smith_room),
write('The blacksmith yells out, saying \'Why you punk!\' '), nl,
write('He crushes your skull with his hammer and continues smithing.'),
nl, !, die.

attack :-
i_am_at(boss_room),
at(sword, in_hand),
alive(sword),
retract(alive(dragon)),
assert(dead(dragon)),
write('You fight valiantly against the dragon and it falls to the'), nl,
write('ground with a thundering thud. You have won and the exit is clear.'), nl,
write('The exit is north'), nl,
nl, time, !.

attack :-
i_am_at(boss_room),
at(sword, in_hand),
write('Despite your efforts, the sword is not good enough to defeat'), nl,
write('the dragon, and it consumes you.'), nl, !, die.

attack :-
i_am_at(boss_room),
write('You were able to leave in peace, but you wanted glory and fought'), nl,
write('a pointless battle as the dragon destroys you.'), nl, !, die.

attack :-
write('There is nothing to attack here.'), nl,
write('Boy, you\'re violent!'), nl, fail.

/* These rules describe searching rooms, how to solve the puzzle, and
   how to read the note. */

search :-
i_am_at(drink_room),
write('You find a strange puzzle embedded into the west wall,'), nl,
write('you could solve it if you gave some effort.'), nl,
write('enter \'solve\' to solve the puzzle.'), nl, nl,
time.
search :-
write('You don\'t notice anything special'), nl, nl, time.

solve :-
i_am_at(drink_room),
retract(alive(puzzle)),
assert(dead(puzzle)),
write('As you solve the puzzle, the wall caves inward, revealing'), nl,
write('a passageway. There is dim light and flashing warmth coming'), nl,
write('from within the tunnel.'), nl, nl, time, !.

read :-
i_am_at(start_room),
write('The note reads, \'Welcome to this dungeon! Here, you must find'), nl,
write('your way out. But be careful not to dilly dally, time is a'), nl,
write('dangerous thing within these aging walls\' '), nl, nl, time.

read :-
write('There\'s nothing to read. How boring.'), nl, nl, !, fail.


/* This rule tells how time decreases. */

time :-
count(N),
Y is N-1,
retract(count(N)),
assert(count(Y)),
time_tell.

time_tell :-                                            
count(N),
0 is mod(N,10) ->
write('You feel that some time as passed.'), nl, !,
time_death;
N = N.

time_death :-
count(N),
N is 10 ->
write('Too much time has passed and you feel yourself fading away.'),
nl, !;
N = N.


/* This rule tells how to die. */

die :-
!, finish.

finish :-
nl,
write('Game Over!'), nl,
write('Please enter the halt command.'),
nl, !.

end :-
dead(puzzle),
write('Game Over!'), nl,
write('You have found the unique ending! Whether or not blood was'), nl,
write('spilt, you found the puzzle and used it to escape the dungeon.'), nl,
write('Congratulations!.'), nl, nl,
write('Please enter the halt command.'),
nl, !.

end :-
alive(dragon),
alive(goblin),
write('Game Over!'), nl,
write('You have found the good ending! No blood was spilt and you'), nl,
write('left peacefully. However, you can\'t help but wonder why'), nl,
write('they were all in there.'), nl, nl,
write('Please enter the halt command.'),
nl, !.

end :-
dead(dragon),
alive(goblin),
write('Game Over!'), nl,
write('You have found the second ending! You didn\'t kill the,'), nl,
write('goblin, but you decided to slay the dragon. You feel'), nl,
write('victorious! Congratulations.'), nl, nl,
write('Please enter the halt command.'),
nl, !.

end :-
write('Game Over!'), nl,
write('You have found the bad ending! You killed both the goblin,'), nl,
write('and the dragon. You are the champion of the dungeon, but at'), nl,
write('what cost? Can you replay and find the good ending?'), nl, nl,
write('Please enter the halt command.'),
nl, !.


/* This rule just writes out game instructions. */

help :-
nl,
write('Enter commands using standard Prolog syntax.'), nl,
write('Available commands are:'), nl,
write('start                    -- to start the game.'), nl,
write('n, s, e, w         -- to go in that direction.'), nl,
write('take(Object)             -- to pick up an object.'), nl,
write('drop(Object)             -- to put down an object.'), nl,
write('wear(Object) -- to wear something.'), nl,
write('attack                   -- to attack an enemy.'), nl,
write('look                     -- to look around you again.'), nl,
write('search                   -- to search an object more closely.'), nl,
write('open_eyes -- to open your eyes.'), nl,
write('close_eyes -- to close your eyes.'), nl,
write('i                        -- to see what you are currently holding.'), nl,
write('help                     -- to see this message again.'), nl,
write('halt                     -- to end the game and quit.'), nl,
nl.


/* This rule prints out instructions and tells where you are. */

start :-
help,
write('You find yourself in a cold room with stone walls, you try to'), nl,
write('remember what you were doing before, but you don\'t remember'), nl,
write('anything. You want to get out, but don\'t know where to find'), nl,
write('the exit.'), nl, nl,
write('A locked door is to the north.'), nl,
write('Two rooms are to the east and west.'), nl,
write('A long corridor is to the south.'),
nl, nl.


/* These rules describe the rooms. Descriptions may differ. */

describe(start_room) :-
write('You are in the room you first found yourself in,'), nl,
write('there is an exit sign above the locked door. How convenient.'), nl,
write('There is also a note on a decaying table off to the side.'), nl,
write('Enter \'read\' to read the note.'), nl, nl,
write('A locked door is to the north.'), nl,
write('Two rooms are to the east and west.'), nl,
write('A long corridor is to the south.'),
nl, nl.

describe(corridor) :-
at(apple, apple_room),
write('The corridor fades from the stone walls to a bright white.'), nl,
write('At the end is an apple just... floating there? Maybe it'), nl,
write('could be useful.'), nl,
write('The exit is to the north.'), nl, nl.

describe(corridor) :-
write('The corridor fades from the stone walls to a bright white.'), nl,
write('The apple is no longer floating in the distance.'), nl,
write('The exit is to the north.'), nl, nl.

describe(apple_room) :-
at(apple, apple_room),
write('You finally made it to the apple, let\'s hope it was worth it.'), nl,
write('The exit is to the north.'), nl, nl.

describe(apple_room) :-
write('You find yourself back at the end of this strange corridor.'), nl,
write('The apple is no longer there.'), nl,
write('The exit is to the north.'), nl, nl.

describe(east_room) :-
alive(goblin),
not(at(apple, goblin)),
write('This room is not much different from the first room, plain'), nl,
write('stone walls and torches lighting the room. There is a room'), nl,
write('north smelling of booze, and a room with a goblin by it.'), nl,
write('It looks hungry.'), nl,
write('The exit is to the west.'), nl, nl.

describe(east_room) :-
alive(goblin),
at(apple, goblin),
write('This room is not much different from the first room, plain'), nl,
write('stone walls and torches lighting the room. There is a room'), nl,
write('north smelling of booze, and a room with a goblin by it.'), nl,
write('It looks satisfied.'), nl,
write('The exit is to the west.'), nl, nl.

describe(east_room) :-
dead(goblin),
write('This room is not much different from the first room, plain'), nl,
write('stone walls and torches lighting the room. There is a room'), nl,
write('north smelling of booze, and a room with a goblin by it.'), nl,
write('A pool of blood lays besides the door.'), nl,
write('The exit is to the west.'), nl, nl.

describe(drink_room) :-
at(alcohol, drink_room),
write('You see a dim lighted room, only lit from torches next to the'), nl,
write('only door in the room. A table in the middle of the room has'), nl,
write('a bottle of alcohol. It seems to call out to you. Maybe you'), nl,
write('could use a drink. After all, this is a lot of stress for an'), nl,
write('amnesiac lost in a dungeon fighting for their life.'), nl,
write('Do you drink the bottle or do you resist the urge?'), nl,
write('enter \'drink\' to drink or \'resist\' to resist.'), nl,
write('The exit is to the south.'), nl, nl.

describe(drink_room) :-
write('You see a dim lighted room, only lit from torches next to the'), nl,
write('only door in the room. The table in the middle of the room'), nl,
write('does not have the bottle of alcohol.'), nl,
write('The exit is to the south.'), nl, nl.

describe(key_room) :-
at(key, key_room),
write('There is no light from the room, but there is a sparkling of'), nl,
write('metal from the light outside. That metal seems to be a key.'), nl,
write('The exit is to the west.'), nl, nl.

describe(key_room) :-
write('There is no light from the room, nor the sparkling of metal.'), nl,
write('The exit is to the west.'), nl, nl.

describe(west_room) :-
write('This room isn\'t much different from the first room, plain'), nl,
write('stone walls, torches lighting the dim room. There is a room'), nl,
write('clanging with metal to the north and a silent room to the'), nl,
write('west.'), nl, write('The exit is to the east.'), nl, nl.

describe(sword_room) :-
at(sword, sword_room),
write('This room is brightly lit with torches on all the walls.'), nl,
write('A rusted sword stands pointed into a stone pedestal. It looks'), nl,
write('like you could pull it out.'), nl,
write('The exit is to the east.'), nl, nl.

describe(sword_room) :-
write('The room is still brightly lit, but there is no sword in the'), nl,
write('pedestal anymore.'), nl,
write('The exit is to the east.'), nl, nl.

describe(smith_room) :-
dead(sword),
at(sword, in_hand),
at(alcohol, in_hand),
retract(at(alcohol, in_hand)),
assert(at(alcohol, blacksmith)),
assert(alive(sword)),
write('The clanging gets louder as you enter the blazing room. The'), nl,
write('blacksmith continues banging at hot metal. He sees you enter.'), nl,
write('He says, \'Ah, I see you brought something nice. I\'ll take'), nl,
write('that nice bottle of alcohol, and I\'ll fix your sword.\' '), nl,
write('He finishes and gives it back, good as new. The blacksmith'), nl,
write('goes back to his smithing before you could thank him,'), nl,
write('swigging the bottle every now and then.'), nl,
write('The exit is to the south.'), nl, nl.

describe(smith_room) :-
alive(sword),
write('The blacksmith continues banging on metal while drinking.'), nl,
write('The exit is to the south.'), nl, nl.

describe(smith_room) :-
at(sword, in_hand),
write('You hear the clanging of hot metal and the blacksmith notices'), nl,
write('the sword in your hand. \'You want me to fix that? I\'m not'), nl,
write('going to do it for free, so you better find something to give'), nl,
write('as payment. Maybe alcohol or something if you can find it.\' '), nl,
write('The exit is to the south.'), nl, nl.

describe(smith_room) :-
write('You hear the clanging of hot metal and the burning warmth of'), nl,
write('the forge. The blacksmith notices you and continues hammering'), nl,
write('He says, \'Hey there, I\'m a blacksmith. You want me to fix'), nl,
write('anything, give me something to fix and payment. Nothing is'), nl,
write('for free around here.\' '), nl,
write('The exit is to the south.'), nl, nl.

describe(boss_room) :-
alive(dragon),
dead(goblin),
write('This room is large compared to the rest of the dungeon, and for'), nl,
write('good reason, as a dragon lays silently in the chamber floor.'), nl,
write('It takes notice of you and raises itself to its feet. Red'), nl,
write('scales glow in the torchlight. Its wings spread out, although'), nl,
write('limited by the size of the room. Large eyes seem to pierce'), nl,
write('into you. It speaks, \'You are a new face here.\' Long pauses'), nl,
write('separate its sentences. \'Shall you be the champion to free'), nl,
write('this dungeon of my reign? Strike me down in glorious battle'), nl,
write('and you shall have your hard earned freedom. STRIKE!\' '), nl, nl.

describe(boss_room) :-
alive(dragon),
alive(goblin),
write('This room is large compared to the rest of the dungeon, and for'), nl,
write('good reason, as a dragon lays silently in the chamber floor.'), nl,
write('It takes notice of you and raises itself to its feet. Red'), nl,
write('scales glow in the torchlight. Its wings spread out, although'), nl,
write('limited by the size of the room. Large eyes seem to gaze into'), nl,
write('you. It speaks, \'You are a new face here.\' Long pauses'), nl,
write('separate its sentences. \'I sense no blood on your hands. You'), nl,
write('are kinder than most. In honor of your character, I shall let'), nl,
write('you leave in peace. You do not deserve to be clad in unseen'), nl,
write('chains in this cursed place.\' The dragon moves its large body'), nl,
write('to allow you to exit the dungeon.'), nl, nl,
retract(alive(curse)),
assert(dead(curse)).

describe(boss_room) :-
dead(dragon),
write('The room is large and brightly lit, the corpse of the dragon'), nl,
write('lingers sadly, unmoving. The exit lays open with creaking'), nl,
write('and rusted metal hinges. Why linger in this place?'), nl, nl.

describe(exit) :-
write('You finally made it. Light pours onto you and you feel the cool'), nl,
write('breeze. You have found your way back into the world.'), nl, nl,
end.
