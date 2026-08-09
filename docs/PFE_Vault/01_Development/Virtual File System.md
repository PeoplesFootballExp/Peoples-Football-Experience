
# Assets

PFE will be full of assets, everything from the flags of countries to the 3D models a player shows. All these assets live inside the game to ensure they work. However, in order to be customizable, the game needs to be able to handle three different types of assets

## Asset Types

The three possible types of assets in the game PFE are the following

1. **Default Assets**: These are the assets that come with the game itself. These will always be present in the game's internal folders as a backup.
2. **Mod Assets**: These are assets that either the user themselves added OR downloaded from a mod made by someone else. These can replace existing assets (e.g. Changing the logo of a team already in the game) or be entirely new assets (e.g. Adding a new fictional team with their own Logos).
3. **Custom Save Assets**: During a save itself, the user may choose to change a asset in which case the asset should only be used in that specific save and not change anything outside of it. PFE is also planning to have multiple options for some assets (like club logos) so we need to track which of the variant assets are currently being used

Any system that handles assets must be able to handle all of these asset types. 