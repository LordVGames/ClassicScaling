---@diagnostic disable: redundant-parameter, undefined-field


CONFIG_FILENAME = _ENV["!guid"]..".cfg"
CONFIG_PATH = paths.config()
FULL_PATH = path.combine(CONFIG_PATH, CONFIG_FILENAME)
CONFIG_SECTION = "Options"
MyConfig = config.config_file:new(FULL_PATH, true)


ConfigEntry_ClassicEliteStats = MyConfig:bind(
    CONFIG_SECTION,
    "Enable classic elite stats",
    true,
    "Nerfs the multipliers for elite HP, damage, and honor elite HP back to RoR1's numbers."
)
ConfigEntry_ClassicLootAmounts = MyConfig:bind(
    CONFIG_SECTION,
    "Enable classic loot amounts and amount scaling",
    true,
    "Un-nerfs both the base loot amount multiplier and the multiplier for loot for every player in multiplayer other than the host."
)
ConfigEntry_ClassicEnemyBuffStageScaling = MyConfig:bind(
    CONFIG_SECTION,
    "Enable classic enemy strength scaling on stage change",
    true,
    "Makes the number for the HP & damage increase that enemies get after every stage no longer exponentially increase every stage, and instead be a one of few numbers that do not increase per stage."
)