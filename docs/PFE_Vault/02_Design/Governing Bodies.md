
This page is a living note based on how Governing Bodies are going to be handled in the game. Of course, this is subject to change as more information is discovered. 

# What is it

Governing bodies are simply entities that has a regulatory or sanctioning function. Governing bodies can be child governing bodies of encompassing governing bodies. For example, the English FA ultimately has sanctioning and regulatory power over the Premier League Governing Body. 


# Scope of Governing Bodies

Governing bodies have different levels of scope. Scope is essentially how wide their influence is and how much area their regulation changes have an impact. For example, the International Football Federations Alliance (IFFA) is the generic and in-game version of real life FIFA. They would have a global scope as they sanction the entire world. The in-game version of the English FA, named the English National Federation (ENF), would have a national or territory wide scope. Their regulation changes would only affect their territory. 

As of now, I have defined a maximum of 11 scope levels that are allow in the game. There can be multiple levels of governing bodies inside each level,  but these are the general levels.

1. **Global**: Encompasses the entire world.
2. **Continental**: Continental or large grouping of countries. 
3. **Sub-Continental Region**: A regional divide of the continents. For example, Northern Africa and East Africa are sub-continental regions. Regions are just collections of the next lower scope. So this level is just collections of nations or territories.
4. **National/Territory**: The in-game equivalent to a nation. This is called Territory to also include overseas territories or special administrative regions that act independently. This allows for countries like Aruba, Wales, and Scotland to compete as its own national team even if not a real life sovereign state.  
5. **Sub-Territory Region**: A regional division or collection of states. For example, in the United States you can divide the nation into 4 major sub-territory regions such as the midwest, east coast, west coat, and the south. 
6. **State/First Level Division**: This is the first level division for all nations/territories. In the United States it would be states, in Canada it would be provinces, and in France it would be administrative regions. 
7. **Sub-State Region**: This is regional divisions of states or the first level divisions.
8. **County/Second level Division**: This is essentially the next subdivision below the first level division.
9. **Sub County Region**
10. **Municipal or City**: This is the level of cities (New York City, London, Paris) or municipalities. 
11. **Sub-City Region**
12. **Neighborhood/Parish**: This is the next subdivision of city and municipalities. 

Not every single territory needs to have an entry at every level. Some countries around the world only have one or two subdivisions. This systems allows jumps in between levels but everything should fit into this system. Lets looks at some examples below

## Examples

If we look at the real life structure of the English League Pyramid it contains many governing bodies that would break rigid systems. This extendable graph system is very flexible and only follows the idea of "Who sanctions or regulates who". An edge in this graph shows a parent/child relationship, where the parent sets the rules for the child. The child may have its own separate rules in addition to the rules set by the parent, but it must follow the rules set by the parent. This idea is very common computer science and is known as inheritance. 

The English League Pyramid exposes some edge cases that lead to this graph system. The English League pyramid has the first 5 levels be technically national/territory scoped. These include the Premier League, EFL Championship, EFL League One, EFL League Two, and National League. These are all national/territory scoped because they can have clubs from anywhere across the country. Within these leagues, there are three governing bodies. The Premier League (level 1), the EFL (level 2-4), and National League (level 5-9) which falls directly under the jurisdiction of the FA.  