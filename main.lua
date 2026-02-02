---@diagnostic disable: lowercase-global


local NAMESPACE = "classicScaling"
mods["ReturnsAPI-ReturnsAPI"].auto{
    namespace = NAMESPACE,
    mp = true
}
PATH = _ENV["!plugins_mod_folder_path"]


local file_name_list = {
    "config.lua",
    "classic_stage_credit_scaling.lua",
    "classic_enemy_buff_stage_scaling.lua",
    "classic_enemy_buff_time_scaling.lua",
    "classic_director_point_scaling.lua",
    "classic_elite_stat_buffs.lua"
}
local init = function ()
    hotload = true
    modOptions = ModOptions.new(NAMESPACE)
    settings = {}
    file = TOML.new()


    for i in pairs(file_name_list) do
        require(file_name_list[i])
    end


    local t = file:read()
    if t then settings = t end
end


Initialize.add(init)
if hotload then
    init()
end




Director = nil
Current_Difficulty = nil
Honor_Artifact = nil


local reset_variables_on_run_start = Packet.new("reset_variables_on_run_start")
local reset_variables = function ()
    if Global.level_name == "" then
        Director = nil
        Current_Difficulty = nil
        Honor_Artifact = nil

        if Net.host then
            reset_variables_on_run_start:send_to_all()
        end
    end
end


-- stupid shit
reset_variables_on_run_start:set_serializers(
function(buffer)
end,

function(buffer)
    reset_variables()
end)


-- resetting global values when leaving run
Hook.add_pre(gm.constants.stage_roll_next,
function(self, other, result, args)
    reset_variables()
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