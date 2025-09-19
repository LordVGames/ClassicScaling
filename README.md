# Classic Scaling

Brings back the old values for a lot of the game's scaling, making RoR Returns' difficulty closer to RoR1's. Each section of changes can be configured on/off, with every section being on by default. You can change the config options in-game by looking for the mod under the `Config` tab at the top of the ImGui menu (the default key to open it is `Insert`).

The following things are changed:

## Enemy strength increase on stage change
- **Number added no longer increases exponentially per stage**
- Leaving stage 1/2: + 0.4
- Leaving stage 3: + 0.5
- Leaving stage 4/5: + 0.45
- Entering contact light: + 0.45
- - (not in addition to previous numbers)

## Enemy strength increases over time
- Strength increases in singleplayer: **same as RoR1**
- Strength increases in multiplayer:
- - Changed From: difficulty scale + smaller amount per player past the first
- - To: smaller amount per player (including first player)

## Director point/credit scaling
- Formula changed:
- - Removed x0.85 mult to player count
- - Removed +0.3 added to player count after mult
- Makes singleplayer get less points, 2 players the same, 3+ get more points

## Stage credits:
- Base multiplier: 0.7 > 1
- Multiplayer multiplier: 0.3 > 0.5
- - (added on to the base multiplier for every player other than the host)

## Elite stat buffs
- Elite HP multiplier: 2.8 > 2.6
- Elite HP multiplier (honor artifact): 2.2 > 2.1
- Elite damage multiplier: 1.9 > 1.7

### Other notes
This mod does **not** change/remove anything else that was changed from RoR1 to RoR Returns. This includes:
- Any base stat increases for some enemies
- New attacks for some enemies

If there any problems or mod conflicts with this mod, make an issue on the [github page](https://github.com/LordVGames/ClassicScaling) or ping me (lordvgames) in the RoRR modding discord server.