mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto(true)
PATH = _ENV["!plugins_mod_folder_path"]
NAMESPACE = "classic_scaling"

local init = function ()
    require("classic_elite_stat_buffs.lua")
    require("classic_enemy_buff_stage_scaling.lua")
    require("classic_stage_credit_scaling.lua")

    HOTLOAD = true
end
Initialize(init)


if HOTLOAD then
    init()
end