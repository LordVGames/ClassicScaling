Sync_classic_enemy_buff_packet = nil
Update_enemy_buff_on_minute_packet = nil
Reset_variables_on_run_start_packet = nil


Setup_Packets = function ()
    Sync_classic_enemy_buff_packet = Packet.new("sync_classic_enemy_buff")
    Update_enemy_buff_on_minute_packet = Packet.new("update_enemy_buff_on_minute")
    Reset_variables_on_run_start_packet = Packet.new("reset_variables_on_run_start")


    -- stupid shit
    Reset_variables_on_run_start_packet:set_serializers(
    function(buffer)
    end,

    function(buffer)
        Reset_global_variables()
    end)


    Sync_classic_enemy_buff_packet:set_serializers(
    function(buffer, old_enemy_buff, enemy_buff_add_value)
        buffer:write_float(old_enemy_buff)
        buffer:write_float(enemy_buff_add_value)
    end,

    function(buffer)
        if not Ensure_Director_Active() then
            log.error("CLIENT failed director check", 1)
            return
        end

        local old_enemy_buff = buffer:read_float()
        local enemy_buff_add = buffer:read_float()
        --log.debug("CLIENT enemy_buff before: " .. Director.enemy_buff)
        --log.debug("old_enemy_buff is  " .. old_enemy_buff)
        --log.debug("enemy_buff_add is  " .. enemy_buff_add)
        Director.enemy_buff = old_enemy_buff + enemy_buff_add
        --log.debug("CLIENT enemy_buff after: " .. Director.enemy_buff)
    end)


    Update_enemy_buff_on_minute_packet:set_serializers(
    function(buffer)
    end,

    function(buffer)
        Add_classic_enemy_buff_time_scaling()
    end)
end