---@diagnostic disable: undefined-field, param-type-mismatch


-- All of the hooks in here are in the function "gml_Object_oDirectorControl_Other_4"
-- base address is 14128F8F0


-- going to before these lines
-- movsd   xmm2, cs:qword_141C25B40
-- lea     rcx, [rsp+9B0h+var_950+8]
local initial_stage_credits_mult_pointer = memory.scan_pattern("F2 0F 10 15 52 3B 99 00 48 8D 4C 24 68")


-- adding 8 to go past the "xmm2, cs:qword_141C25B40" line
memory.dynamic_hook_mid("edit_initial_stage_credits_mult", {"xmm2"}, {"double"}, 0, initial_stage_credits_mult_pointer:add(8),
function(args)
    if not ConfigEntry_ClassicLootAmounts:get() then
        return
    end

    args[1]:set(1)
end)




-- going to before these lines
-- movsd   xmm7, cs:qword_141C25A88
-- movaps  xmm2, xmm7
local multiplayer_stage_credits_mult_pointer = memory.scan_pattern("F2 0F 10 3D 99 39 99 00 0F 28 D7")


-- adding 8 to go past the "movsd   xmm7, cs:qword_141C25A88" line
memory.dynamic_hook_mid("edit_multiplayer_stage_credits_mult", {"xmm7"}, {"double"}, 0, multiplayer_stage_credits_mult_pointer:add(8),
function(args)
    if not ConfigEntry_ClassicLootAmounts:get() then
        return
    end

    args[1]:set(0.5)
end)