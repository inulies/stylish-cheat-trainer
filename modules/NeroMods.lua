local NeroMods = {}

function NeroMods.update(manual_player, state)
    -- Early return se não for o Nero
    if manual_player:get_type_definition():get_name() ~= "PlayerNero" then return end

    if state.nero.infinite_exceed then
        local gauge_manager = manual_player:call("get_exceedGaugeManager")
        if gauge_manager then
            gauge_manager:call("set_Stock", 3)
            gauge_manager:call("set_exceedLevel", 3)
        end
    end

    if state.nero.infinite_color_up then
        local reserve_level = manual_player:call("get_reserveChargeLevel")
        if reserve_level and reserve_level < 3 then
            manual_player:call("set_reserveChargeLevel", 3)
        end
        local blue_rose = manual_player:call("get_cachedBlueRose")
        if blue_rose then
            local max_shells = blue_rose:call("get_maxShellCount")
            if max_shells then blue_rose:call("set_shellCount", max_shells) end
        end
    end

    if state.nero.infinite_charge_shot then
        local charge_checker = manual_player:get_field("BlueRoseCharge")
        if charge_checker then
            local max_level = charge_checker:call("get_maxLevel")
            if max_level then charge_checker:call("set_currentLevel", max_level) end
        end
    end
end

return NeroMods