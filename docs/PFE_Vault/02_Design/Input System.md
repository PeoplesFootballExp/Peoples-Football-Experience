

## Input Router

The Input Router is the single entrance for input in the entire game. Any keyboard presses, controller inputs, or touch screen inputs will likely go through this Autoload before being handled. The only job of the Input Router is to collect inputs from the player and then send the raw input to the correct target. For example, during gameplay with one controller, the Input Router would collect the controller button pushes and send them to the Input Interpreter inside the current active player. The game is currently planned for 8 local multiplayer so the Router would in charge of sending the correct input to the correct input interpreter. The Input Interpreter would handle the raw input sent by the Router and turn it into understandable and standardized Game Commands. Input Router is simple because it does not concern itself with how to handle the input, it is simply responsible for sending it to the correct owner. In this sense, it is like a WiFi router or mailman delivering letters to the correct address. 

![[Input System Basic Schematic.png]]

## Input Interpreter

The input interpreter is a class present in every playable character on screen. This class handles the raw input information sent by the Input Router and interprets the data, creating it into a Game Command. Game Commands are so sent by the Input Interpreter or AI Interpreter (the AI brain that controls football players currently not in control) to all systems that need it: Movement, Physics, Animation, etc. This Interpreter is is charge of handling single button presses, multi button presses, double taps, directional movement (joystick or mouse motion), and even button holds.




