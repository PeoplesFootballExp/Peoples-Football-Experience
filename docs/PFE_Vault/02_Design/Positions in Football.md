
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

For more information about defenders, please visit the [defender](https://en.wikipedia.org/wiki/Defender_(association_football)) Wikipedia page

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
| Forward Runs          | 25            |
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

## Midfielders

Midfielders are players who play in between the attacking players and defenders. Their main role are maintaining possession and transitioning the ball from the defenders to the attackers. Midfielders are very versatile players that can often get called into defensive or attacking areas. 

More information about midfielders can be found on the [midfielder](https://en.wikipedia.org/wiki/Midfielder#Central_midfielder) Wikipedia page 
### Central Midfielders


#### Traditional Central Midfielder

This role is the default role for central midfielders. These players will remain in the center of the pitch in both the vertical and horizontal directions. These players will remain in the midfield to support both the attack and defense. 

In attack, these will mostly remain neutral and support the attack but stay behind a little. Essentially, these central midfielders remain in the midfield centrally. In defense, they will continue to remain in the midfield, in between the attackers and defenders.

#### Playmaker

This role is suited for central midfielders who specialize in attack, vision, and passing. These players will still push slightly higher up in the midfield and roam a little wider than the traditional central midfielder.

In attack, these players will move forward and roam the width of the pitch a little more occupying the Attacking Midfielder area. In defense, they will track back to the traditional central midfielder area to help defend.

#### Holding

This role is suited for central midfielders who specialize in defense, tackling, and strength. These players will stay in the CM area, and track back greatly to help defend.

In attack, these players stay in the CM area like traditional central midfielders. But in defense, they will track back further and occupy the defensive midfielder area, helping more than other central midfielders roles.

#### Box-to-Box

These players are for players that specialize in both attacking and defense. These players will occupy the entirety of the midfield, constantly running back and forth from defensive to attacking positions. These players require greater stamina than other roles.

In attack, these players will move forward occupying the Attacking Midfielder area like in the Playmaker role. In defense, these players will track further back to occupy the Defensive Midfielder area like the Holding role. In essence, this role is to get the best of both roles of Player maker and Holding, but in a more balanced role. 

#### Wide Midfielders

This role is very similar to the traditional central midfielder, except these players will move more wide during the attack stage to offer more width. 

In attack, these players move wider, occupying the Left and Right midfielders area. In defense, these players move back to the traditional central midfielders area, moving more centrally to their natural position.


### Attacking Midfielder

#### Advanced Playmaker

Like the name suggest, these players are attacking midfielders that specialize in roaming around the attacking midfielder area to create goal scoring opportunities. These players can move forward, drop deep, or go forward to shoot. Essentially, these players are like a jack of all trades, serving as the offensive pivot for the team.

In attack, these players can drop deep, run forward, or go wide. These players will do anything to create goal scoring opportunities or shoot from distance. In defense, these players will often remain in the attacking midfielder area in the team, helping to stop attacks early.

#### False Attacking Midfielder

These players are similar to traditional attacking midfielders but they specialize in dropping deeper to move opponent defenders out of position and allowing other attacking players to make runs. These players typically require stronger vision, passing ability, and stamina.

In attack, these players will drop deep, typically into the central midfielder area, in order to create space and running opportunities. Once the ball has been passed forward, these players will return to the typical attacking midfielder position. In defense, these players are identical to traditional attacking midfielders, attempting to stop attacks early. 

#### Traditional Attacking Midfielder (Default)

These players remain in the attacking midfield area in both attack and defense, acting as a good offensive pivot and remaining centrally on the pitch. 

In attack and defense, they remain in the attacking midfielder area.

#### Central Winger

These players will often drift wide, to both draw opponents out of position but also to overload the flanks alongside wingers or attacking full backs. Once the player is free and moved the ball forward, they will return centrally to help in attack but still able to drift wide if need be.

In attack, these players drift wide, often playing in the winger area. In defense, these players will also drift wide if needed to better defend the flanks.

#### Second Striker

These players are like the advanced playermakers but move even more forward, occupying the central forward or second striker area, focused on making runs and shooting from distance. 

In attack, they move even further forward, focused on making runs into the penalty area or shooting from distance. 

### Defensive Midfielder

#### Holding Midfielder (Default)

These players embody the role of the defensive midfielder, occupying the area of defensive midfielder in both attack and defense. 

In attack, these players mostly stay back, focused on quickly recovering balls and getting the ball up through short and easy passes.

#### Deep-lying Playmaker

A player who specializes in passing ability and vision. These players will attempt to move forward, into the central midfielder and creatively creative goal scoring opportunities and get the ball forward.

In attack, they move forward a bit into the central midfielder area, focused on quick short passes or long balls to get the ball forward quickly. In defense, they remain in the defensive midfielder area, attempting to quickly get the ball to quickly attack.

#### Centre Half

A player who specializes in defense, staying back during attack in order to maintain defense integrity.

In attack, they move backwards to join the center backs on the defensive wall. In defense, they move back to the defensive midfielder area, attempting to cut passing lanes.

#### Wide Half

These players move wide and explore the width in order to move attacks through the flanks. These players need stamina, speed, and passing ability to start attacks quickly on the wings. 

In attack, these players move wide into the wing back or full back area to provide width to the defense and build up in attack. In defense, these players return to the defensive midfielder area, to cover passing lanes and defend in front of the center backs

### Wide Midfielders

This position covers both the Left Midfielder and Right Midfielder positions as they are exact mirror copies of each other. 


#### Wide Midfielder (DEFAULT)

In attack, they stay in the wide midfielder area but able to move forward if needed. They also track back and help defensively, more than any other role. This is the wide equivalent of box-to-box central midfielders. 
#### Attacking Wide Midfielder

In attack, they move forward and stay wide, playing in the winger area

#### Wide Playmaker

These players stay wide, playing in the attacking midfielder area, moving everywhere to create plays or runs.

#### Inverted Wide Midfielders

They cut in, attempting to pull wide players out of position. They move centrally, occupying the central midfielder area to both overload the midfield and create new passing and running opportunities.

#### Inverted Winger

These players move forward and centrally to occupy the second striker area to support the attack and potentially shoot from distance


## Attackers


For more information about attackers, please visit the [Attackers](https://en.wikipedia.org/wiki/Forward_(association_football)) Wikipedia Page

### Striker

#### Target Man

#### Poacher

#### Advanced Forward

### Central Forward

#### Second Striker

In attack, they move forward

#### False Nine

In attack, they drop deeper, more into the AM area to pull defenders out of area and creating passing/running opportunities for teammates. In defense, they move back to the central forward area

#### Central Forward (Default)

### Wingers

#### Traditional Winger

In attack, they stay wide to offer a wide passing option at all times. In defense, they typically stay up closer to the stikers but try to quickly stop an attack before it starts

#### Inverted Winger

These players starts wide but can quickly move inside, drawing wide defenders out of position and creating space for overlapping wide player like wide midfielders or attacking wing backs. 

In attack, they move centrally often to create passing or running opportunities for other players and can stay in the central forward or second striker area or move back to stay wide. Their focus is exploring the width of the field to create opportunities. 

#### Box-to-Box Winger

These players run the entire pitch

in attack, these players play as traditional wingers, staying wide to provide a passing option or cross in balls but also track back to help with defense. They essentially travel the entire pitch to help with attack and defense, requiring speed, stamina, and defense abilities. 




