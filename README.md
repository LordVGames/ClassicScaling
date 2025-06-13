# Classic Scaling

Brings back the old values for some parts of the game's scaling, making RoR Returns' difficulty closer to RoR1's.

The following things are changed:

## Elite stat buffs
- Elite HP multiplier: 2.8 > 2.6
- Elite HP multiplier (honor artifact): 2.2 > 2.1
- Elite damage multiplier: 1.9 > 1.7

## Enemy strength increase on stage change
- **Number added no longer increases exponentially per stage**
- Leaving stage 1/2: + 0.4
- Leaving stage 3: + 0.5
- Leaving stage 4/5: + 0.45
- Entering contact light: + 0.45
- - (not in addition to previous numbers)
- Entering boar beach: No addition to enemy strength, removes 2 from the internal "Stages passed" counter
- - RoR1 game code says it does this. Not sure if it has any real effects.

## Stage credits:
- Base multiplier: 0.7 > 1
- Multiplayer multiplier: 0.3 > 0.5
- - (added on to the base multiplier for every player other than the host)

### Other notes
This mod does **not** change/remove anything else that was changed from RoR1 to RoR Returns. This includes:
- Any base stat increases for some enemies
- New attacks for some enemies

If there any problems or mod conflicts with this mod, make an issue on the [github page](https://github.com/LordVGames/ClassicScaling) or ping me (lordvgames) in the RoRR modding discord server.