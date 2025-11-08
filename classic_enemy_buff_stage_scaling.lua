---@diagnostic disable: undefined-field, param-type-mismatch
-- All hooks in here are in the function "gml_Script_stage_goto_next_gml_Object_oDirectorControl_Create_0"




--[[
-- going to before these lines --

140F5BC4B                   lea     rdx, [rbp+0A0h+var_90]      (48 8D 55 10)
140F5BC4F                   mov     rcx, [rbp+0B0h+r13]         (49 8B CD)
140F5BC52                   call    RValue_Add                  (E8 39 E5 10 FF)
]]
local before_enemy_buff_add_pointer = memory.scan_pattern("48 8D 55 10 49 8B CD E8 39 E5 10 FF")
if (before_enemy_buff_add_pointer:is_null()) then
    log.error("COULD NOT FIND MEMORY ADDRESS FOR POINTER \"before_enemy_buff_add_pointer\", NOT DOING HOOK \"remove_returns_per_stage_difficulty_scaling\"!!!", 1)
    return
end


-- add 4 is done to skip past the "lea rdx" line
-- this hook happens when transitioning to a stage but BEFORE the stage actually transitions
memory.dynamic_hook_mid("remove_returns_per_stage_difficulty_scaling", {"rdx"}, {"RValue*"}, 0, before_enemy_buff_add_pointer:add(4),
function(args)
    if not settings.classicEnemyBuffStageScaling then
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


local sync_classic_enemy_buff_packet = Packet.new("sync_classic_enemy_buff")
-- have to check for specific stages in here beacause the memory hook is too early to get the new stage id
-- this happens after our memory hook but it's STILL not late enough for the stage to actually change
-- so the stage name/stages passed will be of the previous stage
-- luckily the result.value is the id the next stage, so we can use that
gm.post_script_hook(gm.constants.stage_roll_next,
function(self, other, result, args)
    if not settings.classicEnemyBuffStageScaling then
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


    local director = gm._mod_game_getDirector()
    if director == nil then
        log.warning("director was NIL in stage_roll_next - not adding to enemy_buff!")
        return
    end


    -- enemy_buff gets reset by the game on run start, so don't try to touch enemy_buff when a run is started
    if director.stages_passed == 0 and director.time_start == 0 then
        --log.warning("GOING TO A STARTING STAGE")
        return
    end


    local enemy_buff_add
    local stage_number_in_loop
    -- when entering contact light
    -- it's handled separately here since you can go here any stage post-loop and we need to avoid adding the wrong number to enemy_buff
    if result.value == 9 then
        enemy_buff_add = 0.45
        return
    else
        stage_number_in_loop = math.fmod(director.stages_passed + 1, 5)
        -- mfw arrays start at 1 so i can't have a value in a table starting at 0
        if stage_number_in_loop == 0 then
            stage_number_in_loop = 5
        end
        enemy_buff_add = classic_enemy_buff_per_stage[stage_number_in_loop]
    end

    if Net.host then
        sync_classic_enemy_buff_packet:send_to_all(enemy_buff_add)
    end

    --log.debug("before: " .. director.enemy_buff)
    director.enemy_buff = director.enemy_buff + enemy_buff_add
    --log.debug("after: " .. director.enemy_buff)
end)


sync_classic_enemy_buff_packet:set_serializers(
    function(buffer, enemy_buff_add_value)
        buffer:write_float(enemy_buff_add_value)
    end,

    function(buffer, player)
       local director = gm._mod_game_getDirector()
        if director == nil then
            log.warning("CLIENT director was NIL in stage_roll_next - not adding to enemy_buff!")
            return
        end

        local enemy_buff_add = buffer:read_float()
        --log.debug("CLIENT before: " .. director.enemy_buff)
        director.enemy_buff = director.enemy_buff + enemy_buff_add
        --log.debug("CLIENT after: " .. director.enemy_buff) 
    end
)



return false