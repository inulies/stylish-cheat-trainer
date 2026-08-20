-- Limpeza de cache para facilitar o desenvolvimento
package.loaded["inuliesss_modules.global_mods"] = nil
package.loaded["inuliesss_modules.char_nero"] = nil

-- Importação dos módulos
local global_mods = require("inuliesss_modules.global_mods")
local char_nero = require("inuliesss_modules.char_nero")

-- Objeto de Estado (State) que será lido pela GUI e pelos módulos
local state = {
    global = {
        no_damage = false,
        infinite_dt = false
    },
    nero = {
        infinite_exceed = false,
        infinite_color_up = false,
        infinite_charge_shot = false
    }
}

-- Inicializa os hooks de invulnerabilidade passando a referência do state
global_mods.init_hooks(state)

-- ==========================================
-- GESTÃO DE GUI (ImGui)
-- ==========================================
re.on_draw_ui(function()
    if imgui.tree_node("InulieSSS Trainer") then
        local changed, new_val
        
        -- Globais
        changed, new_val = imgui.checkbox("No Damage", state.global.no_damage)
        if changed then state.global.no_damage = new_val end

        changed, new_val = imgui.checkbox("Devil Trigger Regeneration", state.global.infinite_dt)
        if changed then state.global.infinite_dt = new_val end

        -- Específicos do Nero
        if imgui.tree_node("Nero") then
            changed, new_val = imgui.checkbox("Infinite Exceed", state.nero.infinite_exceed)
            if changed then state.nero.infinite_exceed = new_val end
            
            changed, new_val = imgui.checkbox("Infinite Color Up Shot", state.nero.infinite_color_up)
            if changed then state.nero.infinite_color_up = new_val end

            changed, new_val = imgui.checkbox("Instant Charge Shot", state.nero.infinite_charge_shot)
            if changed then state.nero.infinite_charge_shot = new_val end
            
            imgui.tree_pop()
        end
        
        imgui.tree_pop()
    end
end)

-- ==========================================
-- MAIN FRAME LOOP
-- ==========================================
re.on_frame(function()
    -- Busca o player_manager de forma segura no início de cada frame
    local player_manager = sdk.get_managed_singleton("app.PlayerManager")
    if not player_manager then return end

    local manual_player = player_manager:call("get_manualPlayer")
    if not manual_player then return end

    -- Chama os módulos passando as referências necessárias
    pcall(function()
        global_mods.update(manual_player, state)
        char_nero.update(manual_player, state)
    end)
end)

print("[InulieSSS Trainer] Módulos carregados e Runner iniciado.")