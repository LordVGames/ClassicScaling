---@diagnostic disable: undefined-field, param-type-mismatch, lowercase-global
require("global_data.lua")
require("packets.lua")
-- All hooks in here are in the function "gml_Object_oDirectorControl_Alarm_0"



local old_enemy_buff = 0



Add_classic_enemy_buff_time_scaling = function ()
    if not settings.classicEnemyBuffTimeScaling then
        return
    end
    if not Ensure_Director_Active() then
        return
    end
    --log.debug("after: " .. Director.enemy_buff)
    if Director.enemy_buff <= old_enemy_buff then
        return
    end



    
    local value_to_add
    if Global.coop ~= 2 then
        value_to_add = Current_Difficulty.diff_scale
    else
        -- dividing by 7.2727 to get what are basically the RoR1 multiplayer difficulty values with support for modded difficulties
        ---@diagnostic disable-next-line: missing-parameter
        value_to_add = string.format(
            "%.4f",
            ---@diagnostic disable-next-line: missing-parameter
            (Current_Difficulty.diff_scale / 7.2727) * gm.call("player_util_count_alive")
        )
    end


    value_to_add = value_to_add * gm.trials_setting_get("difficulty_scaling_rate", 1)
    --log.debug("old_enemy_buff " .. old_enemy_buff)
    --log.debug("value_to_add " .. value_to_add)
    Director.enemy_buff = old_enemy_buff + value_to_add
    --log.debug("true after: " .. Director.enemy_buff .. "\n")
end



Callback.add(Callback.ON_SECOND,
function (minute, second)
    --log.debug("second " .. second)
    --log.debug("minute " .. minute)
    if second == 59 then
        if not Ensure_Director_Active() then
            return
        end
    
    
        old_enemy_buff = Director.enemy_buff
        --log.debug("\nbefore: " .. old_enemy_buff)
    elseif second == 0 and minute > 0 then
        -- this doesn't run on ONLY the first time on clients?????? why???????
        -- whatever i'll just network this manually idc
        if Net.host then
            Update_enemy_buff_on_minute_packet:send_to_all()
            Add_classic_enemy_buff_time_scaling()
        end
    end
end)