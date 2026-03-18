---@diagnostic disable: undefined-field, param-type-mismatch
require("global_data.lua")
require("packets.lua")
-- All hooks in here are in the function "gml_Script_stage_goto_next_gml_Object_oDirectorControl_Create_0"



local old_enemy_buff = 0



Hook.add_pre(gm.constants["stage_goto_next@gml_Object_oDirectorControl_Create_0"],
function(self, other, result, args)
    if not Ensure_Director_Active() then
        return
    end

    
    old_enemy_buff = Director.enemy_buff
    --log.debug("before: " .. Director.enemy_buff)
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
Hook.add_pre(gm.constants.stage_roll_next,
function(self, other, result, args)
    if not settings.classicEnemyBuffStageScaling then
        return
    end
    if not Ensure_Director_Active() then
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



    -- enemy_buff gets reset by the game on run start, so don't try to touch enemy_buff when a run is started
    if Director.stages_passed == 0 and Director.time_start == 0 then
        --log.warning("GOING TO A STARTING STAGE")
        return
    end


    -- rorr enemy_buff addition has happened by this point, set it back to it's old value so we can add our own
    local enemy_buff_add
    local stage_number_in_loop
    -- when entering contact light
    -- it's handled separately here since you can go here any stage post-loop and we need to avoid adding the wrong number to enemy_buff
    if result.value == 9 then
        enemy_buff_add = 0.45
    else
        stage_number_in_loop = math.fmod(Director.stages_passed + 1, 5)
        -- mfw arrays start at 1 so i can't have a value in a table starting at 0
        if stage_number_in_loop == 0 then
            stage_number_in_loop = 5
        end
        enemy_buff_add = classic_enemy_buff_per_stage[stage_number_in_loop]
    end

    if Net.host then
        Sync_classic_enemy_buff_packet:send_to_all(old_enemy_buff, enemy_buff_add)
    end

    --log.debug("enemy_buff before: " .. Director.enemy_buff)
    Director.enemy_buff = old_enemy_buff + enemy_buff_add
    --log.debug("enemy_buff after: " .. Director.enemy_buff)
end)