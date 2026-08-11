
# Player Positions

These are the fundamental starting locations of players on the pitch. While formations define the initial setup, modern football emphasizes fluidity and positional interchange. However, understanding the basic positions is crucial. Positions are simply the general area the player maintains during the game. In general, the formation of a team outlines the general shape the team has

A lot of information for these positions and roles are based on modern day positions and roles. A lot of additional information can also be found on the wikipedia page for [positions](https://en.wikipedia.org/wiki/Association_football_positions)

## Goalkeeper

**Goalkeeper** is the last line of defense, responsible for preventing the ball from entering the goal. Unique in being allowed to use their hands within their penalty area.  
Goalkeepers tend to be taller than most other players on the field (on par with center backs)
- Positional ID: 1
- Abbreviation: GK
- Pitch Line: Goalkeeper
- Pitch Side: Center
- UI Position X: 0.5
- UI Position Y: 0.9


#### Shot Stopper (DEFAULT):

Traditional role of a goalkeeper that is focused on mainly stopping shots by remaining in the goalkeeping box. This goalkeeper role will play conservatively, staying in the box at all times for the most part and focus on making saves and commanding their penalty area. Their key attributes are agility, reflexed, positioning, and aerial ability.

When the team is attacking, the goalkeeper will always remain in the goalkeeping box. When defending, they will remain tightly to the goal, only coming out to get loose balls in the goalkeeping box if needed.


| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 0             |
| Lapping Runs          | 0             |
| Width                 | 0             |
| Track Back            | 0             |
| Vision                | 0             |
| Passing into Space    | 0             |
| Shoot on sight        | 0             |
| Defense Aggression    | 0             |
| Marking Focus         | 0             |
| Step up               | 0             |
| Come for Crosses (GK) | 25            |
| Rust out (GK)         | 25            |
| Distribution (GK)     | 50            |

#### Sweeper Keeper

Proactive goalkeeper who is comfortable coming off their line to intercept through balls, act as an extra defender, and even participate in the early build-up play with their feet. Requires excellent reading of the game and composure on the ball. Much more likely to be out of position if defenders loose the ball or goalkeeper mistakenly comes out for a loose ball.

When attacking, the goalkeeper will often go forward, past the goalkeeping box, in order to help with build up and a last resort pass for the defenders if getting pressed. When defending, this goalkeeper will move more back to goal, but will more often rush out to collect loose balls, not afraid to dribble past pressing attackers.

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 0             |
| Lapping Runs          | 0             |
| Width                 | 0             |
| Track Back            | 0             |
| Vision                | 0             |
| Passing into Space    | 0             |
| Shoot on sight        | 0             |
| Defense Aggression    | 0             |
| Marking Focus         | 0             |
| Step up               | 0             |
| Come for Crosses (GK) | 75            |
| Rust out (GK)         | 75            |
| Distribution (GK)     | 75            |


## Defenders

Defenders are the backbone of the team, playing in between the midfielders and the goalkeeper. Their primary responsibility is to prevent the opposing team from scoring and even shooting at the net. Usually, they will remain in their own half of the football pitch, only occasionally crossing over in unique and risky tactical decisions (high press or attacking wing backs). Occasionally, center backs, because of their height, will move to attack in the opposing goal box during set pieces such as corners or free kicks. 

### Center Backs

The primary role of center backs is to block the opponent from scoring and safely clearing the ball from the penalty area. Of course, these players play centrally on the pitch only coming in pairs of twos or, more rarely, in pairs of three. 

Center backs mostly defend in three different ways. One way to defend is to defend a space, ensuring or pressuring opponent players to move to different areas. Another way is man marking, focused on directly staying close to attacking players. Last way is interceptions, focus on cutting passing or shooting lanes. Most center backs use a combination of all three ways to defend but some players may focus on one way due to tactical decisions.

Center backs tend to be tall, strong, and good at jumping, heading, and tackling ability. They need to be able to tackle or slide in to safely to take possession from opponent players. As mentioned before, center backs will sometimes move forward on the pitch into the opponents penalty area in order to attempt heading the ball into the net from corners or free-kicks. Once the set piece is done, they rush back to their primary position to defend.

####  Ball Playing Defender

This role is for a center back that is comfortable and skilled in possession, capable of playing accurate passes through the lines, breaking the first line of pressure. 

These players, when in possession, will often move forward into a defensive midfielder position to help the initial attack and control the midfield. When defending, they may stay forward in the defensive midfield position to cut off passing lanes or defend early. Eventually, if this fails, they move back to a center back position to further help with defense.

In rare occasions, this defender may run the ball all the way up the pitch and even shoot in rare occasions. 

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 40            |
| Lapping Runs          | 30            |
| Width                 | 30            |
| Track Back            | 80            |
| Vision                | 50            |
| Passing into Space    | 80            |
| Shoot on sight        | 50            |
| Defense Aggression    | 50            |
| Marking Focus         | 50            |
| Step up               | 75            |
| Come for Crosses (GK) | 0             |
| Rust out (GK)         | 0             |
| Distribution (GK)     | 0             |

#### Traditional Center Back (DEFAULT)

The traditional role of a defender, primarily focused on winning aerial duels, making tackles, and preventing opposition forwards from getting past them. Emphasizes physical presence and defensive awareness as well as marking opposition tightly. 

In attack, this center back will move slightly forward but mostly stay in line with the other defensive players. In defense, these center backs will remain as a wall, staying disciplined in staying in this defensive line and preventing players from running past them or shooting effectively.

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 25            |
| Lapping Runs          | 30            |
| Width                 | 30            |
| Track Back            | 85            |
| Vision                | 30            |
| Passing into Space    | 50            |
| Shoot on sight        | 50            |
| Defense Aggression    | 40            |
| Marking Focus         | 80            |
| Step up               | 40            |
| Come for Crosses (GK) | 0             |
| Rust out (GK)         | 0             |
| Distribution (GK)     | 0             |

#### Sweeper

Best used in a three-man defense, this center back will move back behind the defensive line covering through balls and providing an extra layer of security. This role can be risky, sometimes allowing an attacking player to push beyond the defensive line and still remain onside. This role is more free to explore the width of the field, entering space or marking where needed to stop goals.

In attack, this player is similar to the stopper, staying back and staying in line with other defensive players. In defense, these center backs are more willing to move behind the defensive lines to prevent through balls or mark opponents. These players may also be roaming wide, moving wherever needed to stop the attacking players.

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 25            |
| Lapping Runs          | 30            |
| Width                 | 50            |
| Track Back            | 90            |
| Vision                | 30            |
| Passing into Space    | 50            |
| Shoot on sight        | 50            |
| Defense Aggression    | 20            |
| Marking Focus         | 85            |
| Step up               | 10            |
| Come for Crosses (GK) | 0             |
| Rust out (GK)         | 0             |
| Distribution (GK)     | 0             |

### Full Backs

Full backs are defensive players that play on either side of the center backs to provide protection of attacking wide players. They often have to defend against the opponents wingers, preventing them from crossing the ball into the penalty area or cutting inside to shoot. Depending on their role, full backs can remain behind along with the center backs or push up to help with the attack.

#### Traditional Full Back (DEFAULT)

These full backs, like stopper center backs, are primarily focused on defending their flank, marking wingers, and making tackles. 

In attack, these players will stay back alongside the centerbacks to ensure defensive solidity. In defense, they remain along the defensive line and attempt to prevent wide players from making runs or passes behind.

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 25            |
| Lapping Runs          | 70            |
| Width                 | 75            |
| Track Back            | 80            |
| Vision                | 50            |
| Passing into Space    | 50            |
| Shoot on sight        | 50            |
| Defense Aggression    | 30            |
| Marking Focus         | 80            |
| Step up               | 30            |
| Come for Crosses (GK) | 0             |
| Rust out (GK)         | 0             |
| Distribution (GK)     | 0             |

#### Wing Back

These players are willing to push up ahead, moving into the LM or RM positions in attack to better support. Usually will not move too forward, in order to still have the ability of quickly tracking back and defending. Unlike traditional full backs, they are a little more likely to step up and block passing lanes or catch attacking opponents quickly

In attack, they move up, into a wide midfield position in order to provide some attacking support. In defense, they quickly move back to defend but willing to still step up to cut passing lanes or press if needed.

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 25            |
| Lapping Runs          | 70            |
| Width                 | 75            |
| Track Back            | 80            |
| Vision                | 50            |
| Passing into Space    | 50            |
| Shoot on sight        | 30            |
| Defense Aggression    | 30            |
| Marking Focus         | 80            |
| Step up               | 50            |
| Come for Crosses (GK) | 0             |
| Rust out (GK)         | 0             |
| Distribution (GK)     | 0             |

#### Attacking Wing Back

These players will really push up into attacking spaces, such as wingers, in order to provide an extra passing width option. Because these players run up and down the field constantly, they need a great amount of stamina and speed. They also need better crossing, passing, and vision abilities to better act as wingers if needed.

In attack, these players push up high on the field, often occupying the same space as wingers. IN defense, these players track back if possible and defend along the defensive line. Occasionally stepping up to defend passing lanes but trying to return to position

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 60            |
| Lapping Runs          | 70            |
| Width                 | 75            |
| Track Back            | 80            |
| Vision                | 65            |
| Passing into Space    | 50            |
| Shoot on sight        | 30            |
| Defense Aggression    | 60            |
| Marking Focus         | 80            |
| Step up               | 55            |
| Come for Crosses (GK) | 0             |
| Rust out (GK)         | 0             |
| Distribution (GK)     | 0             |

#### Inverted Full Back

These players move into the midfield, providing a passing option and dominate the midfield. 

In attack, these players move more centrally and forward, moving into a Defensive Midfielder area to provide a passing option and add numbers to the midfield. In defense, these players track back into the full back positions, staying in line with other defenders.

| Attribute             | Value (0-100) |
| --------------------- | ------------- |
| Forward Runs          | 60            |
| Lapping Runs          | 70            |
| Width                 | 75            |
| Track Back            | 80            |
| Vision                | 65            |
| Passing into Space    | 50            |
| Shoot on sight        | 30            |
| Defense Aggression    | 60            |
| Marking Focus         | 80            |
| Step up               | 55            |
| Come for Crosses (GK) | 0             |
| Rust out (GK)         | 0             |
| Distribution (GK)     | 0             |

- **Defenders:** Their primary role is to prevent the opposition from scoring. They can be categorized further:  
    
    - **Center-Back (CB):** Plays centrally in defense, responsible for marking central attackers, winning aerial duels, and making tackles. Often crucial in organizing the defensive line.  
    - **Full-Back (LB/RB):** Plays on the flanks of the defense (left and right). Traditionally focused on defending against wingers but increasingly involved in attacking by providing width and crosses.
- **Midfielders:** The engine room of the team, linking defense and attack. Their roles are diverse:
    - **Central Midfielder (CM):** Operates in the center of the pitch. Can have various roles, from dictating play (deep-lying playmaker) to box-to-box midfielders who contribute both defensively and offensively.
    - **Defensive Midfielder (DM):** Sits in front of the defense, primarily focused on breaking up opposition attacks, winning back possession, and shielding the backline. Also important in distributing the ball to start attacks.
    - **Attacking Midfielder (AM):** Plays in the space between the midfield and the forwards, focused on creating scoring opportunities, playing through balls, and sometimes scoring themselves. Often the team's primary playmaker.
    - **Wide Midfielder (LM/RM):** Plays on the flanks in midfield. Traditionally focused on providing crosses but can also cut inside to create chances or support the central midfield.  
        
- **Forwards:** Their main objective is to score goals.  
    
    - **Striker (ST):** The primary attacking player, usually positioned centrally to lead the attack and get on the end of passes and crosses.  
    - Central Forward (CF): 
    - **Winger (LW/RW):** Plays wide in attack, aiming to beat defenders, deliver crosses into the box, and sometimes cut inside to shoot.  
        