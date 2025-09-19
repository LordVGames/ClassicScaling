---@diagnostic disable: undefined-field, param-type-mismatch
-- All hooks in here are in the function "gml_Object_oDirectorControl_Other_4"




--[[
-- going to before these lines -- 

140F6EEE0  F2 0F 10 15 B8 03 0D 01               movsd   xmm2, cs:qword_14203F2A8
140F6EEF0  48 8D 95 78 03 00 00                  lea     rcx, [rsp+9B0h+var_950+8]
]]
local initial_stage_credits_mult_pointer = memory.scan_pattern("F2 0F 10 15 B8 03 0D 01 48 8D 95 78 03 00 00")
if (initial_stage_credits_mult_pointer:is_null()) then
    log.error("COULD NOT FIND MEMORY ADDRESS FOR POINTER \"initial_stage_credits_mult_pointer\", NOT DOING HOOK \"edit_initial_stage_credits_mult\"!!!", 1)
    return
end


-- adding 8 to go past the "movsd   xmm2, cs:qword_14203F2A8" line
memory.dynamic_hook_mid("edit_initial_stage_credits_mult", {"xmm2"}, {"double"}, 0, initial_stage_credits_mult_pointer:add(8),
function(args)
    if not ConfigEntry_ClassicLootAmounts:get() then
        return
    end

    -- ror1 mult is 1, rorr is 0.7
    args[1]:set(1)
end)




--[[
-- going to before these lines --

140F6F020  F2 0F 10 3D C8 01 0D 01               movsd   xmm7, cs:qword_14203F1F0
140F6F020  0F 28 D7                              movaps  xmm2, xmm7
]]
local multiplayer_stage_credits_mult_pointer = memory.scan_pattern("F2 0F 10 3D C8 01 0D 01 0F 28 D7")
if (initial_stage_credits_mult_pointer:is_null()) then
    log.error("COULD NOT FIND MEMORY ADDRESS FOR POINTER \"multiplayer_stage_credits_mult_pointer\", NOT DOING HOOK \"edit_multiplayer_stage_credits_mult\"!!!", 1)
    return
end


-- adding 8 to go past the "movsd   xmm7, cs:qword_141C25A88" line
memory.dynamic_hook_mid("edit_multiplayer_stage_credits_mult", {"xmm7"}, {"double"}, 0, multiplayer_stage_credits_mult_pointer:add(8),
function(args)
    if not ConfigEntry_ClassicLootAmounts:get() then
        return
    end

    -- ror1 mult is 0.5, rorr is 0.3
    args[1]:set(0.5)
end)




return false