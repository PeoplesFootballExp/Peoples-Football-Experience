## 📘 Overview

**Scene Name**: Selection Tile
**Purpose**: To simply display the team as a tile in another scene. Displays the team name, logo, and average rating in attack, midfield, and defense
**Inputs**: 
**Outputs**:
**Linked Managers**: None

## Wireframe/Mockup

![[Selection Tile Wireframe.png]]
## User Flow

- The entire scene is a button. This button will simply store the team ID it is displaying, then when pressed send a signal to the [[Team Selection Menu]] which team was lasted clicked by the player
- User Clicks Team 

### User Goals

- The User simply needs to see some simple data about the Team in the Team Grid on the [[Team Selection Menu]]. Using this simple data, the user selects the team they want by clicking this scene which is simply a button. We made this its own scene so we can reuse it as many times as we like. 

### Flow Charts

## UI Actions

- Button Press -> send signal with team ID

## Theme & Visual Rules

Like most scene, we will be following the preference of dark theme. Most of the color here will be dark, with the exception of the area behind the team logo which will be gray. There are some designs that rely on a white background and some designs that rely on a black background, so a gray background is a good compromise to allow both logos to still be visible.

## Structure & Organization

- Team Logo
- Team Name
- Field Name
- Field Averages

## Track Dependencies



## Navigation Flow

## Known Issues

## TODOS








