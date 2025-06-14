---@diagnostic disable: undefined-field, param-type-mismatch


-- in the function "gml_Script_stage_goto_next_gml_Object_oDirectorControl_Create_0"
--[[
scanning for these:
141281902 48 8D 55 88                                   lea     rdx, [rbp+0B0h+stages_passed_3]
141281906 48 8B 8D C0 00 00 00                          mov     rcx, [rbp+0B0h+gamemode_check]
14128190D E8 6E D5 DD FE                                call    RValue_Add
]]
local before_enemy_buff_add_pointer = memory.scan_pattern("48 8D 55 88 48 8B 8D C0 00 00 00 E8 6E D5 DD FE")


-- add 4 is done to skip past the "lea rdx" line
-- this hook happens when transitioning to a stage but BEFORE the stage actually transitions
memory.dynamic_hook_mid("remove_returns_per_stage_difficulty_scaling", {"rdx"}, {"RValue*"}, 0, before_enemy_buff_add_pointer:add(4),
function(args)
    if not ConfigEntry_ClassicEnemyBuffStageScaling:get() then
        return
    end
    
    -- fuck off
    args[1].value = 0
end)


-- ror1 chose the enemy_buff number depending on the stage name, but all the stages that shared a stage # had the same enemy_buff additions anyways.
-- idk how rorml handled modded stages (and especially ss1 with it's special stages) but if there's some special handling i'll add it later
local classic_enemy_buff_per_stage =
{
    [1] = 0.4,
    [2] = 0.4,
    [3] = 0.5,
    [4] = 0.45,
    [5] = 0.45
}


-- have to check for specific stages in here beacause the memory hook is too early to get the new stage id
-- this happens after our memory hook but it's STILL not late enough for the stage to actually change
-- so the stage name/stages passed will be of the previous stage
-- luckily the result.value is the id the next stage, so we can use that
gm.post_script_hook(gm.constants.stage_roll_next,
function(self, other, result, args)
    if not ConfigEntry_ClassicEnemyBuffStageScaling:get() then
        return
    end

    
    --log.debug("stage_roll_next")
    -- avoid doing this on menus
    if Global.level_name == "" then
        return
    end
    --log.debug("level name is " .. Global.level_name)
    --log.debug("level ID is " .. Global.stage_id)
    --log.debug("result.value (new level ID) is " .. result.value)
    local director = GM._mod_game_getDirector()
    if director == nil then
        log.warning("director was NIL in stage_roll_next - not adding to enemy_buff!")
        return
    end
    
    
    -- when entering contact light
    -- it's handled separately here since you can go here any stage post-loop and we need to avoid adding the wrong number to enemy_buff
    if result.value == 9 then
        director.enemy_buff = director.enemy_buff + 0.45
        return
    end


    -- can't check for boar beach here so we can't do any special handling
    -- but we don't need to since rorr's existing functionality mixed with this mod leads to classic functionality anyways


    local stage_number_in_loop = math.fmod(director.stages_passed + 1, 5)
    -- mfw arrays start at 1 so i can't have a value in a table starting at 0
    if stage_number_in_loop == 0 then
        stage_number_in_loop = 5
    end
    --log.debug("stages passed is " .. director.stages_passed)
    --log.debug("stage_number_in_loop is " .. stage_number_in_loop)
    --log.debug("before: " .. director.enemy_buff)
    director.enemy_buff = director.enemy_buff + classic_enemy_buff_per_stage[stage_number_in_loop]
    --log.debug("after: " .. director.enemy_buff)
end)