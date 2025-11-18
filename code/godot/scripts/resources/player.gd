class_name Player 
extends Resource
## A player class that stores information about the player. All data is gathered from and saved to 
## the PLayer Table in the SQLite Database
##
##
##
##


@export_category("Identifying Information")

## The unique ID of the Player
@export var id: int;

## The commonly used name (aka nickname) of the player
@export var name: String

## The official name of the player
@export var official_name: String

## The Day of the Player's Birthday
@export var birth_day: int;

## The Month of the player's Birthday
@export var birth_month: int;

## The year of the player's Birthday
@export var birth_year: int;

## The Age of the Player
@export var age: int;

## The Gender of the Player
## 0 is men, 1 is women
@export var gender: int;

## The Primary Nationality of the Player: After age 21, this will be the default.
## Points to Territory ID
@export var primary_nationality: int;


@export_category("Key Details")

## The dominant foot of the player. Saved as an integer in SQLite
@export var dominant_foot: int;

## The Skill Moves rating of the player
@export var skill_moves: int; #out of 5 stars

## The ability of the player's non-dominant foot (aka weak foot)
@export var weak_foot: int; #out of 5 stars

## The player's morale: How motivated or happy the player is
@export var morale: int;

## The Sharpness of a player: How in form or condition is the player
@export var condition: int;

## The Primary Position of the player, stored as the ID of the position
@export var primary_position: int;

## The Secondary Position of the player, stored as the ID of the position
@export var secondary_position: int;

## The Tertiary Position of the player, stored as the ID of the position
@export var tertiary_position: int;

## The Market Value of the player, 
@export var market_value: int;

## The current weekly wages of the player
@export var weekly_wage: int;

## The current stamina of the player
@export var stamina_level: int;

## The current club team of this player. Points to ID of team
@export var club_team: int;

## The current national team of this player. Points to ID of team
@export var national_team: int

## The Secondary Nationality of the Player.
## Points to Territory ID
@export var secondary_nationality: int;

## The Tertiary Nationality of the Player.
## Points to Territory ID
@export var tertiary_nationality: int;

@export_category("Attributes")

@export_subgroup("Stats Summary")
## The overall of the player: Dependent on primary position of player and attributes
@export var overall: int;

## The Potential of the player: Dependent on primary position of player and attributes
@export var potential: int;

@export_subgroup("Technical Ability")

## Accuracy and weight of ground passes
@export var passing: int;

## Accuracy and curve of lofted passes
@export var crossing: int;

## Ability to run with the ball while maintaining control
@export var dribbling: int;

## How cleanly a player controls the ball when receiving a pass
@export var first_touch: int;

## Accuracy of shots on goal (excluding long shots)
@export var finishing: int;

## Power of shots on goal (excluding long shots)
@export var power: int;

## Accuracy and power of shots taken outside the penalty box
@export var long_shots: int;

## Effectiveness and cleanliness of attempts to win the ball from an opponent
@export var tackling: int;

## Ability to stay close to an opponent and limit their space and options
@export var marking: int;

## Skill in directing the ball with their head (both attacking and defensive)
@export var heading: int;

## General proficiency and comfort with complex technical moves; execution quality
@export var technique: int;

## Accuracy, curve, and power on direct and indirect free kicks
@export var free_kicks: int;

## Accuracy and curve on corner kicks
@export var corners: int;

## Composure and Accuracy when taking penalty kicks
@export var penalties: int;

## Distance and accuracy of long-distance throws-ins
@export var long_throws: int;

@export_subgroup("Mental Ability")

## Ability to read the game and predict where the ball/players will go next
@export var anticipation: int;

## Ability to find the correct defensive position relative to the ball, opponent, and goal
@export var positioning: int;

## Ability to find good attacking space when not in possession of the ball
@export var off_the_ball: int;

## Speed and correctness of choosing the bets course of action during play
@export var decisions: int;

## Ability to maintain technique and focus under pressure 
## (especially in the final third both offensively and defensively)
@export var composure: int;

## Consistency of mental focus throughout the match (avoiding errors)
@export var concentration: int;

## Ability to see potential passing options and chances others miss
@export var vision: int;

## Willingness to stick to tactical instructions and work for the team
@export var teamwork: int;

## Propensity to contest balls vigorously and commit to tackles
@export var aggression: int;

## Desire to win and bounce back from setbacks during a game
@export var determination: int;

## Tendency and ability to execute unpredictable, creative, and risky actions
@export var flair: int;

## Effort and intensity applied throughout the match
@export var work_rate: int;

## Willingness to risk injury or physical contact for the team (e.g blocking shots)
@export var bravery: int;

## Ability to influence and motivate teammates on the field
@export var leadership: int;

@export_subgroup("Physical Ability")

## Maximum speed reached while running without the ball
@export var pace: int;

## How quickly a player reaches their top speed from a standstill
@export var acceleration: int;

## Ease and speed of changing direction and twisting
@export var agility: int;

## Ability to remain steady on their feet when dribbling or being tackled
@export var balance: int;

## Physical power used to win contested balls or shield the ball from opponents
@export var strength: int;

## Maximum height a player can reach with their head when jumping
@export var jumping_reach: int;

## Ability to maintain physical effort throughout the match without fatigue
@export var stamina: int;

## Rate of recovery between matches and resistance to losing condition
@export var natural_fitness: int;

## Player height (in cm) - influences aerial duels
@export var height: int;

## Player weight (in kg) - influences strength contests and balance
@export var weight: int;

@export_subgroup("Goal Keeper Specifics")

## Security when catching or holding the ball
@export var handling: int;

## Speed of reaction to close-range or powerful shots
@export var reflexes: int;

## Effectiveness in saving when a forward is clean through on goal
@export var one_on_ones: int;

## Ability to claim high crosses and corner kicks
@export var aerial_reach: int;

## Accuracy and distance of distribution with the feet
@export var kicking: int;

## Accuracy and distance of distribution with the hands
@export var throwing: int;

## Ability to position themselves correctly to cover the goal against shots
@export var keeper_positioning: int;

## Authority and effectiveness in organizing the defense and claiming balls within the box
@export var command_of_area: int;

## Tendency to take ricks or engage in unconventional actions (e.g. rushing out aggressively )
@export var eccentricity: int; 
