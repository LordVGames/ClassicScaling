---@diagnostic disable: redundant-parameter, undefined-field



settings.classicLootAmounts = true
local classic_loot_amounts_checkbox = modOptions:add_checkbox("classicLootAmounts")
classic_loot_amounts_checkbox:add_getter(function()
    return settings.classicLootAmounts
end)
classic_loot_amounts_checkbox:add_setter(function(value)
    settings.classicLootAmounts = value
    file:write(settings)
end)



settings.classicEnemyBuffStageScaling = true
local classic_enemy_buff_stage_scaling_checkbox = modOptions:add_checkbox("classicEnemyBuffStageScaling")
classic_enemy_buff_stage_scaling_checkbox:add_getter(function()
    return settings.classicEnemyBuffStageScaling
end)
classic_enemy_buff_stage_scaling_checkbox:add_setter(function(value)
    settings.classicEnemyBuffStageScaling = value
    file:write(settings)
end)



settings.classicEnemyBuffTimeScaling = true
local classic_enemy_buff_time_scaling_checkbox = modOptions:add_checkbox("classicEnemyBuffTimeScaling")
classic_enemy_buff_time_scaling_checkbox:add_getter(function()
    return settings.classicEnemyBuffTimeScaling
end)
classic_enemy_buff_time_scaling_checkbox:add_setter(function(value)
    settings.classicEnemyBuffTimeScaling = value
    file:write(settings)
end)



settings.classicDirectorPointScaling = true
local classic_director_point_scaling_checkbox = modOptions:add_checkbox("classicDirectorPointScaling")
classic_director_point_scaling_checkbox:add_getter(function()
    return settings.classicDirectorPointScaling
end)
classic_director_point_scaling_checkbox:add_setter(function(value)
    settings.classicDirectorPointScaling = value
    file:write(settings)
end)



settings.classicEliteStats = true
local classic_elite_stats = modOptions:add_checkbox("classicEliteStats")
classic_elite_stats:add_getter(function()
    return settings.classicEliteStats
end)
classic_elite_stats:add_setter(function(value)
    settings.classicEliteStats = value
    file:write(settings)
end)



return false