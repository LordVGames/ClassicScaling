---@diagnostic disable: undefined-global
Director = nil
Current_Difficulty = nil
Honor_Artifact = nil


Reset_global_variables = function ()
    if Global.level_name == "" then
        Director = nil
        Current_Difficulty = nil
        Honor_Artifact = nil

        if Net.host then
            Reset_variables_on_run_start_packet:send_to_all()
        end
    end
end


-- resetting global values when leaving run
Hook.add_pre(gm.constants.stage_roll_next,
function(self, other, result, args)
    Reset_global_variables()
end)


Ensure_Director_Active = function ()
    if Director == nil then
        Director = gm._mod_game_getDirector()
        if Director == nil then
            log.error("Could not find director!", 1)
            return false
        end
    end
    return true
end


Ensure_Current_Difficulty = function ()
    if Current_Difficulty == nil then
        Current_Difficulty = Difficulty.wrap(gm._mod_game_getDifficulty())
        if Current_Difficulty == nil then
            log.error("Somehow couldn't get difficulty???", 1)
            return false
        end
    end
    return true
end


Ensure_Honor_Artifact = function ()
    if Honor_Artifact == nil then
        Honor_Artifact = Artifact.find("honor", "ror")
        if Honor_Artifact == nil then
            log.error("Could not find honor artifact!", 1)
            return false
        end
    end
    return true
end