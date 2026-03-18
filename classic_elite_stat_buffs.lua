---@diagnostic disable: undefined-field, param-type-mismatch
require("global_data.lua")
local honor_elite_hp_reduction_multiplier = 0.9545
local normal_elite_hp_reduction_multiplier = 0.9285
local elite_damage_reduction_multiplier = 0.8947



RecalculateStats.add(
function (actor, api)
    if not settings.classicEliteStats then
        return
    end
    -- don't touch non-elites or blighteds or empyreans if ssr is installed
    if actor.elite_type < 0 or actor.elite_type == 6 then
        return
    end
    if gm.call("actor_is_boss", nil, nil, actor.id) then
        return
    end
    if not Ensure_Honor_Artifact() then
        return
    end



    if Honor_Artifact.active then
        -- 2.2 mult > 2.1 mult by doing this
        -- multiplying like this leaves the final number off by a hundreth or a few compared to dividing
        -- whatever it's all i can do
        api.maxhp_mult(honor_elite_hp_reduction_multiplier)
    else
        -- 2.8 > 2.6
        api.maxhp_mult(normal_elite_hp_reduction_multiplier)
    end
    -- 1.9 > 1.7
    api.damage_mult(elite_damage_reduction_multiplier)
end)