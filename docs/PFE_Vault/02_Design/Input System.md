

## Input Router

The Input Router is the single entrance for input in the entire game. Any keyboard presses, controller inputs, or touch screen inputs will likely go through this Autoload before being handled. The only job of the Input Router is to collect inputs from the player and then send the raw input to the correct target. For example, during gameplay with one controller, the Input Router would collect the controller button pushes and send them to the Input Interpreter inside the current active player. The game is currently planned for 8 local multiplayer so the Router would in charge of sending the correct input to the correct input interpreter. The Input Interpreter would handle the raw input sent by the Router and turn it into understandable and standardized Game Commands. Input Router is simple because it does not concern itself with how to handle the input, it is simply responsible for sending it to the correct owner. In this sense, it is like a WiFi router or mailman delivering letters to the correct address. 

![[Input System Basic Schematic.png]]

## Input Interpreter

The input interpreter is a class present in every playable character on screen. This class handles the raw input information sent by the Input Router and interprets the data, creating it into a Game Command. Game Commands are so sent by the Input Interpreter or AI Interpreter (the AI brain that controls football players currently not in control) to all systems that need it: Movement, Physics, Animation, etc. This Interpreter is is charge of handling single button presses, multi button presses, double taps, directional movement (joystick or mouse motion), and even button holds.


## Input Mapping

Since the game is being planned for release on Mobile and PC, there needs to be support for keyboard inputs and mobile inputs. For personal preference, and for the possibility that the game may be released on console in the future, then controller inputs must also be accepted. Thankfully, Godot abstracts different input types into actions, so we only need to worry about how input actions map to in-game input and not worry about which input type (keyboard, mobile, controller) the player uses. 

### Mobile Limitations

Keyboards and Controllers offer a long list of possibilities for input and  combinations. The biggest limiting factor for this game would be the mobile inputs. Mobile inputs are heavily limited by many factors such as the ideas below

#### Limitations

1. **2 Thumb Limit**: Forcing players to use anything more than 2 thumbs would require weird claw grips that may be uncomfortable, or impossible, for many. This means at most, the player can only truly press two buttons at the same time, limiting the button combos that can be made.
2. **Screen Occlusion**: All the buttons are overlayed on the screen, meaning any space taken up by the buttons and the player's thumbs, introduces blind areas especially for a football game where vision is important. The more buttons we add, the less screen area is purely for the football match.
3. **Zero Haptic Anchoring**: Players may have to constantly look to buttons to ensure they are pressing the buttons, this can lead to missed shots or passes in game.
4. **Lack of Native Modifier Keys**: Dedicated modifier buttons (like controller L1/R1) break down on mobile because pressing a modifier while holding a movement stick and tapping an action key requires a third finger.

#### Possibilities

Given the limitations outlined above, there are some creative things we can do to add some functionality back into the mobile inputs.

1. **Directional Swiping on Buttons**: Swiping in a direction can act similarly to modifier keys on controller and keyboard. For example, you press the pass button but swipe up on the button, leading to a lofted pass. For this, we can have 4 directions as modifiers for all base actions.
2. **Strict Contextual Dynamic Swapping**: Buttons can swap out for a different action depending on the context of the game. For example, the button in charge of shooting may be the button in charge of tackling when the team is defending. 
3. **Off-Hand Screen Gestures**: Gestures outside the button space may also act as contextual macros. For example, swiping on the right side of the screen may act as the skill moves the player performs.
4. **Tap-to-Target Direction Selection**: Tapping directly on a teammate on the screen could bypass the passing or shooting buttons.
5. **Pressure Scaling**: Holding down a button dynamically expands a power meter.


### Core Actions

At the moment, I am thinking of following a similar system to FIFA, where there are four main actions a player can perform. These core actions are the following
1. Ground Pass: A regular pass to a teammate where the ball stays on the ground
2. Shoot: A strong shot towards the opponent's net or to simply clear the ball out
3. Lofted Pass: A pass to a teammate where the ball gets lifted into the air.
4. Through Ball: A pass to a teammate where the ball ends up slightly ahead of the player, allowing the teammate to run into the pass.

Of course, these core actions are only true when the player is currently attacking, when defending, these core actions contextually switch to the following core actions
1. Jockey: Pressing this button, leads to the player facing the player
2. Tackle:
3. Slide Tackle:
4. GK Rush:

## Full Button Breakdown


| Button 1      | Button 2 | Button 3 | Action |
| ------------- | -------- | -------- | ------ |
| Left Joystick |          |          |        |






