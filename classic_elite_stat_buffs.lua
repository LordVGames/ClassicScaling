---@diagnostic disable: undefined-field, param-type-mismatch
-- All of these addresses are in found in "gml_Script_recalculate_stats" in the database


local recalculate_stats_pointer = gm.get_script_function_address(gm.constants.recalculate_stats)


-- 0x14C4 sends the pointer below the line "movsd   xmm0, cs:qword_141C25C90"
-- this lets us be able to pull the multiplier from xmm0 and read/change it
-- any values from anything named xmm# HAVE to be gotten and modified with :get() and :set() respectively
-- .value is ALWAYS nil here due to the xmm# being a "sol.lua::memory::value_wrapper_t"
memory.dynamic_hook_mid("edit_honor_elite_hp_mult", {"xmm0"}, {"double"}, 0, recalculate_stats_pointer:add(0x14C4),
function(args)
    if not ConfigEntry_ClassicEliteStats:get() then
        return
    end

    -- ror1 mult is 2.1, rorr mult is 2.2
    args[1]:set(2.1)
end)


-- 0x14DF sends the pointer below the line "movsd   xmm0, cs:qword_14203F438"
memory.dynamic_hook_mid("edit_normal_elite_hp_mult", {"xmm0"}, {"double"}, 0, recalculate_stats_pointer:add(0x14DF),
function(args)
    if not ConfigEntry_ClassicEliteStats:get() then
        return
    end

    -- ror1 mult is 2.6, rorr mult is 2.8
    args[1]:set(2.6)
end)


-- 0x156A sends the pointer below the line "movsd   xmm0, cs:qword_141C25C68"
memory.dynamic_hook_mid("edit_elite_damage_mult", {"xmm0"}, {"double"}, 0, recalculate_stats_pointer:add(0x156A),
function(args)
    if not ConfigEntry_ClassicEliteStats:get() then
        return
    end

    -- ror1 mult is 1.7, rorr mult is 1.9
    args[1]:set(1.7)
end)