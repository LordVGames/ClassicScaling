---@diagnostic disable: undefined-field, param-type-mismatch, lowercase-global
-- All hooks in here are in the function "gml_Object_oDirectorControl_Alarm_0"




--[[
"removing" the the 0.85 mult to player count in the formula

-- going to before these lines --

140F613D9                 movsd   xmm0, cs:qword_14203F2D8      (F2 0F 10 05 F7 DE 0D 01)
140F613E1                 movsd   [rsp+3B0h+var_340], xmm0      (F2 0F 11 44 24 70)
]]
local director_points_formula_bad_mult_pointer = memory.scan_pattern("F2 0F 10 05 F7 DE 0D 01 F2 0F 11 44 24 70")
if (director_points_formula_bad_mult_pointer:is_null()) then
    log.error("COULD NOT FIND MEMORY ADDRESS FOR POINTER \"director_points_formula_bad_mult_pointer\", NOT DOING HOOK \"replace_director_points_formula_bad_mult\"!!!", 1)
    return
end


-- adding 8 to go past the "movsd   xmm0, cs:qword_14203F2D8" line
memory.dynamic_hook_mid("replace_director_points_formula_bad_mult", {"xmm0"}, {"double"}, 0, director_points_formula_bad_mult_pointer:add(8),
function(args)
    if not settings.classicDirectorPointScaling then
        return
    end

    args[1]:set(1)
end)




--[[
removing the the 0.35 add after the player count is multiplied in the formula

-- going to before these lines --

140F6144C                 movsd   xmm1, cs:qword_14203F1F0              (F2 0F 10 0D 9C DD 0D 01)
140F61454                 lea     rcx, [rsp+3B0h+var_378.flags]         (48 8D 4C 24  40)
140F61459                 call    add_number_to_string                  (E8 52 98 1A FF)
]]
local director_points_formula_bad_add_pointer = memory.scan_pattern("F2 0F 10 0D 9C DD 0D 01 48 8D 4C 24 40 E8 52 98 1A FF")
if (director_points_formula_bad_add_pointer:is_null()) then
    log.error("COULD NOT FIND MEMORY ADDRESS FOR POINTER \"director_points_formula_bad_add_pointer\", NOT DOING HOOK \"replace_director_points_formula_bad_add\"!!!", 1)
    return
end


-- adding 8 to go past the "movsd   xmm1, cs:qword_14203F1F0" line
memory.dynamic_hook_mid("replace_director_points_formula_bad_add", {"xmm1"}, {"double"}, 0, director_points_formula_bad_add_pointer:add(8),
function(args)
    if not settings.classicDirectorPointScaling then
        return
    end

    args[1]:set(0)
end)




return false