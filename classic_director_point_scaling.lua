---@diagnostic disable: undefined-field, param-type-mismatch, lowercase-global
require("global_data.lua")
local old_points = 0



Hook.add_pre("gml_Object_oDirectorControl_Alarm_0",
function(self, other, result, args)
    if not Ensure_Director_Active() then
        return
    end


    old_points = Director.points
    --log.debug("before: " .. Director.points)
end)



Hook.add_post("gml_Object_oDirectorControl_Alarm_0",
function(self, other, result, args)
    if not settings.classicDirectorPointScaling then
        return
    end
    if not Ensure_Director_Active() then
        return
    end
    --log.debug("after: " .. Director.points .. "\n")
    if Director.points <= old_points then
        return
    end
    if not Ensure_Current_Difficulty() then
        return
    end
    --log.debug("points changed!\n")

    
    -- reset points to before they were increased
    local rorr_points_add = Director.points - old_points
    --log.debug("ror1 before: " .. Director.points)

    -- do the point formula but without the 0.85 mult and 0.3 add during player count power
    -- makes it the same as ror1's formula
    -- i also broke the formula up to make it more readable, or at least more than when it's all bunched up
    local ror1_points_add =
    2 + (
        math.floor(
            (
                (
                    math.min(Current_Difficulty.general_scale - 0.2, 1) * Director.time_start
                )
                / 69
            )
            ---@diagnostic disable-next-line: missing-parameter
            * math.max(1, gm.call("player_util_count_alive") ^ 1.1)
        )
        * Current_Difficulty.point_scale
    )
    --log.debug("rorr add: " .. rorr_points_add)
    --log.debug("ror1 add: " .. ror1_points_add)
    Director.points = old_points + ror1_points_add
    --log.debug("ror1 after: " .. Director.points .. "\n")
end)