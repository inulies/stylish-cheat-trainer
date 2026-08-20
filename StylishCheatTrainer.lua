-- ==========================================
-- DEPENDENCIES
-- ==========================================
local hit_controller_def = sdk.find_type_definition("app.HitController")

-- ==========================================
-- GUI STATE
-- ==========================================
local is_god_mode_enabled = false
local is_infinite_dt_enabled = false

-- Nero Specific State
local is_infinite_exceed_enabled = false
local is_infinite_color_up_enabled = false
local is_infinite_charge_shot_enabled = false

-- ==========================================
-- INTERNAL STATE
-- ==========================================
local is_player_hit = false
local dt_regen_rate = 50.0

-- ==========================================
-- GUI (REFramework ImGui)
-- ==========================================
re.on_draw_ui(function()
    if imgui.tree_node("Stylish Cheat Trainer") then
        
        -- Global Mods
        local changed_god, new_value_god = imgui.checkbox("No Damage", is_god_mode_enabled)
        if changed_god then is_god_mode_enabled = new_value_god end

        local changed_dt, new_value_dt = imgui.checkbox("Devil Trigger Regeneration", is_infinite_dt_enabled)
        if changed_dt then is_infinite_dt_enabled = new_value_dt end

        -- Character Specific Mods: Nero
        if imgui.tree_node("Nero") then
            local changed_exceed, new_value_exceed = imgui.checkbox("Infinite Exceed", is_infinite_exceed_enabled)
            if changed_exceed then is_infinite_exceed_enabled = new_value_exceed end
            
            local changed_color_up, new_value_color_up = imgui.checkbox("Infinite Color Up Shot", is_infinite_color_up_enabled)
            if changed_color_up then is_infinite_color_up_enabled = new_value_color_up end

            local changed_charge_shot, new_value_charge_shot = imgui.checkbox("Instant Charge Shot", is_infinite_charge_shot_enabled)
            if changed_charge_shot then is_infinite_charge_shot_enabled = new_value_charge_shot end
            
            imgui.tree_pop()
        end

        imgui.tree_pop()
    end
end)

-- ==========================================
-- GOD MODE (HitController Hooks)
-- ==========================================
if hit_controller_def then
    -- Reset hit flag
    sdk.hook(hit_controller_def:get_method("damageProc"), function(args)
        is_player_hit = false
    end, function(retval) return retval end)

    -- Flag active player damage
    sdk.hook(hit_controller_def:get_method("calcDamageValueDmgPl"), function(args)
        is_player_hit = true
        if is_god_mode_enabled then return sdk.PreHookResult.SKIP_ORIGINAL end
    end, function(retval) return retval end)

    -- Block HP reduction
    sdk.hook(hit_controller_def:get_method("updateDamage"), function(args)
        if is_player_hit and is_god_mode_enabled then return sdk.PreHookResult.SKIP_ORIGINAL end
    end, function(retval) return retval end)

    -- Block death reactions
    sdk.hook(hit_controller_def:get_method("setDamageReaction"), function(args)
        if is_player_hit and is_god_mode_enabled then return sdk.PreHookResult.SKIP_ORIGINAL end
    end, function(retval) return retval end)

    print("[Stylish Cheat Trainer] Motor de Invulnerabilidade injetado.")
else
    print("[Stylish Cheat Trainer] Erro: app.HitController nao encontrado.")
end

-- ==========================================
-- FEATURE MODULES
-- ==========================================

-- Infinite Devil Trigger (Universal)
local function update_infinite_dt()
    if not is_infinite_dt_enabled then return end

    pcall(function()
        local player_manager = sdk.get_managed_singleton("app.PlayerManager")
        if not player_manager then return end

        local manual_player = player_manager:call("get_manualPlayer")
        if not manual_player then return end

        local current_dt = manual_player:call("get_devilTriggerGauge")
        local max_dt = manual_player:call("get_maxDevilTriggerGauge")

        if current_dt and max_dt and current_dt < max_dt then
            local new_dt_value = current_dt + dt_regen_rate
            if new_dt_value > max_dt then new_dt_value = max_dt end
            manual_player:call("set_devilTriggerGauge", new_dt_value)
        end
    end)
end

-- Infinite Exceed (Nero Only)
local function update_infinite_exceed()
    if not is_infinite_exceed_enabled then return end

    pcall(function()
        local player_manager = sdk.get_managed_singleton("app.PlayerManager")
        if not player_manager then return end

        local manual_player = player_manager:call("get_manualPlayer")
        if not manual_player then return end

        if manual_player:get_type_definition():get_name() == "PlayerNero" then
            local gauge_manager = manual_player:call("get_exceedGaugeManager")
            
            if gauge_manager then
                gauge_manager:call("set_Stock", 3)
                gauge_manager:call("set_exceedLevel", 3)
            end
        end
    end)
end

-- Infinite Color Up Shot (Nero)
local function update_infinite_color_up()
    if not is_infinite_color_up_enabled then return end

    pcall(function()
        local player_manager = sdk.get_managed_singleton("app.PlayerManager")
        if not player_manager then return end

        local manual_player = player_manager:call("get_manualPlayer")
        if not manual_player then return end

        if manual_player:get_type_definition():get_name() == "PlayerNero" then
            -- Silent UI Setter
            local reserve_level = manual_player:call("get_reserveChargeLevel")
            if reserve_level and reserve_level < 3 then
                manual_player:call("set_reserveChargeLevel", 3)
            end

            -- Silent Physical Weapon Setter
            local blue_rose = manual_player:call("get_cachedBlueRose")
            if blue_rose then
                local current_shells = blue_rose:call("get_shellCount")
                local max_shells = blue_rose:call("get_maxShellCount")
                
                if current_shells and max_shells and current_shells < max_shells then
                    blue_rose:call("set_shellCount", max_shells)
                end
            end
        end
    end)
end

-- Infinite Charge Shot (Nero Only)
local function update_infinite_charge_shot()
    if not is_infinite_charge_shot_enabled then return end

    pcall(function()
        local player_manager = sdk.get_managed_singleton("app.PlayerManager")
        if not player_manager then return end

        local manual_player = player_manager:call("get_manualPlayer")
        if not manual_player then return end

        if manual_player:get_type_definition():get_name() == "PlayerNero" then
            local charge_checker = manual_player:get_field("BlueRoseCharge")
            
            if charge_checker then
                local max_level = charge_checker:call("get_maxLevel")
                local current_level = charge_checker:call("get_currentLevel")
                
                if current_level and max_level and current_level < max_level then
                    charge_checker:call("set_currentLevel", max_level)
                end
            end
        end
    end)
end

-- ==========================================
-- MAIN FRAME LOOP
-- ==========================================
re.on_frame(function()
    update_infinite_dt()
    update_infinite_exceed()
    update_infinite_color_up()
    update_infinite_charge_shot()
end)

print("[Stylish Cheat Trainer] Carregamento concluido com sucesso.")