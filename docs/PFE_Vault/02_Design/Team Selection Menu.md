## 📘 Overview

Scene Name: Team Selection Menu
Purpose: To allow the player to select the teams for the football match, both their team and the opponent team
Inputs: Main Menu
Outputs: Tactics Edit Scene
Linked Managers: DBManager, AssetManager, SceneManager

## Wireframe/Mockup

![[main_menu_wireframe.png|476x364]]

## User Flow

## Order of Selection

1. Continental Confederation
2. Territory
3. Team Type
4. Men or Women Teams
5. League in Pyramid
6. Team
OR

7. Search Team
8. Select Team

This flow allows selection of both all club teams, all national teams, and all men and women teams. Also allows for quicker selection as each level quickly zooms into the desired team. For example, having something similar to FIFA, where all the leagues are in one long line of options, would be unsustainable for this many countries. This set up quickly eliminates options as we go, making the final selection easier. 

### User Goals

The goals for the user in the scene are the following
- Select their own team 
- Quickly select teams
- Select the opponent team
- See Basic Stats for Team, to see strength to help selection

### Flow Charts



## UI Actions



## Theme & Visual Rules

The colors of this scene and all scenes, will be customizable. But the default mode will be dark mode. So the colors should be on the darker side (Blacks, Greys, Dark Colors)

Personal Preference: A Dark Purple integrated into the dark theme but can change 

## Structure & Organization



## Track Dependencies

## Navigation Flow

## Known Issues

- League Option Button, which was working, does not work for now as we simply want to deal with national teams for the MVP
- Scene is not optimized perfectly, its load all teams logos even if not on screen 

## TODOS
- Optimize scene, main slowdown is I/O access of logos.
- UI elements are not optimized, especially team grid display. To improve performance, either virtualize the gird or do pagination. Both options decrease the number of nodes and logos loaded in the scene tree at any given time. This helps to mitigate the I/O access time. 













