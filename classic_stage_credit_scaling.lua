---@diagnostic disable: undefined-field, param-type-mismatch



local initial_interactable_player_count_multiplier = 1
local classic_per_extra_player_multiplier = 0.5
local rorr_per_extra_player_multiplier = 0.3

local current_stage = nil
local stage_interactable_points = 0



Hook.add_pre("gml_Object_oDirectorControl_Other_4",
function (self, other, result, args)
    if not settings.classicLootAmounts then
        return
    end
    if not Ensure_Director_Active() then
        return
    end


    --[[ 
        can't change pos_points before/after this function, it gets set and used all in the middle of oDirectorControl_Other_4
        so instead we'll increase the stages' interactable points before it's used in calculating pos_points
        and then set it back after pos_points have been used (aka after oDirectorControl_Other_4)
        that way the end result will be as if the multipliers in the game code were changed to the classic values
        it's kinda convoluted but it works and it's either this or a mid hook
    ]]
    current_stage = Stage.wrap(Global.stage_id)
    local max_players = Instance.find(gm.constants.oInit).player_max_chosen
    stage_interactable_points = current_stage.interactable_spawn_points
    --log.debug("current_stage.interactable_spawn_points BEFORE is " .. current_stage.interactable_spawn_points)
    local initial_interactable_points_unnerf_multiplier = string.format(
        -- 4 points of precision is enough
        "%.4f",
        (
            (current_stage.interactable_spawn_points * initial_interactable_player_count_multiplier)
            / (current_stage.interactable_spawn_points * 0.7)
        )
    )
    local per_extra_player_unnerf_multiplier = string.format(
        "%.4f",
        (
            (1 + math.max(max_players - 1, 0) * classic_per_extra_player_multiplier)
            / (1 + math.max(max_players - 1, 0) * rorr_per_extra_player_multiplier)
        )
    )
    --log.debug("initial_interactable_points_unnerf_multiplier " .. initial_interactable_points_unnerf_multiplier)
    --log.debug("per_extra_player_unnerf_multiplier " .. per_extra_player_unnerf_multiplier)
    current_stage.interactable_spawn_points = math.ceil(
        current_stage.interactable_spawn_points * initial_interactable_points_unnerf_multiplier
    ) * per_extra_player_unnerf_multiplier
    --log.debug("current_stage.interactable_spawn_points AFTER is " .. current_stage.interactable_spawn_points)
end)



Hook.add_post("gml_Object_oDirectorControl_Other_4",
function (self, other, result, args)
    if current_stage == nil then
        log.error("Couldn't set stage interactable points back to it's original value!", 1)
        return
    end

    current_stage.interactable_spawn_points = stage_interactable_points
end)