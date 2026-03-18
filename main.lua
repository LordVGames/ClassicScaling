---@diagnostic disable: lowercase-global


local NAMESPACE = "classicScaling"
mods["ReturnsAPI-ReturnsAPI"].auto{
    namespace = NAMESPACE,
    mp = true
}
PATH = _ENV["!plugins_mod_folder_path"]


local file_name_list = {
    "global_data.lua",
    "packets.lua",
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


    Setup_Packets()


    local t = file:read()
    if t then settings = t end
end


Initialize.add(init)
if hotload then
    init()
end