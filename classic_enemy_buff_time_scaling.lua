---@diagnostic disable: undefined-field, param-type-mismatch, lowercase-global
-- All hooks in here are in the function "gml_Object_oDirectorControl_Alarm_0"




--[[
replacing the finished enemy_buff formula result with RoR1's result (it didn't use much of a formula)

-- going to before these lines --

140F63B35                 lea     rdx, [rsp+3B0h+var_378.flags]     (48 8D 54  24 40)
140F63B3A                 mov     rcx, r14                          (49 8B CE)
140F63B3D                 call    RValue_Add                        (E8 4E 66 10 FF)
]]
local enemy_buff_time_scale_formula_result_pointer = memory.scan_pattern("48 8D 54 24 40 49 8B CE E8 4E 66 10 FF")
if (enemy_buff_time_scale_formula_result_pointer:is_null()) then
    log.error("COULD NOT FIND MEMORY ADDRESS FOR POINTER \"enemy_buff_time_scale_formula_result_pointer\", NOT DOING HOOK \"replace_enemy_buff_time_scale_formula_result\"!!!", 1)
    return
end


-- adding 5 to go past the "lea     rdx, [rsp+3B0h+var_378.flags]" line
memory.dynamic_hook_mid("replace_enemy_buff_time_scale_formula_result", {"rdx"}, {"RValue*"}, 0, enemy_buff_time_scale_formula_result_pointer:add(5),
function(args)
    if not ConfigEntry_ClassicEnemyBuffTimeScaling:get() then
        return
    end


    -- diff_level and the index for that are both +1-ed because lua arrays start at 1 but not gamemaker ones
    local current_run_diff_scale = Global.class_difficulty[Global.diff_level+1][9]
    local value_to_add
    if (Global.coop ~= 2) then
        value_to_add = current_run_diff_scale
    elseif (Global.host) then
        -- dividing by 7.27 to get what are basically the RoR1 multiplayer difficulty values with support for modded difficulties
        ---@diagnostic disable-next-line: missing-parameter
        value_to_add = (current_run_diff_scale / 7.27) * gm.call("player_util_count_alive")
    end


    value_to_add = value_to_add * gm.trials_setting_get("difficulty_scaling_rate", 1)
    --log.debug("value_to_add BEFORE is " .. args[1].value)
    args[1].value = value_to_add
    --log.debug("value_to_add AFTER is " .. args[1].value)
end)


return false