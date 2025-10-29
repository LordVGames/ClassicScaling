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
    -- keep this last one at the bottom because this hooks in a way where we can't check if the hook location is valid before hooking
    "classic_elite_stat_buffs.lua"
}
local init = function ()
    hotload = true
    modOptions = ModOptions.new(NAMESPACE)
    settings = {}
    file = TOML.new()


    for i in pairs(file_name_list) do
        -- this mod's files return false if they successfully do all their hooks, so if one fails a hook and stops itself then it'll return true by default
        -- if one file says it's hooks didn't work then that likely means all hooks are fucked, so then the mod will stop loading and hooking any further
        if require(file_name_list[i]) then
            log.warning("Cancelling any further mod loading due to an error during the hooking process.")
            break
        end
    end


    local t = file:read()
    if t then settings = t end
end


Initialize.add(init)
if hotload then
    init()
end