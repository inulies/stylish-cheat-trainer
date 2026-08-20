local GlobalMods = {}
local hit_controller_def = sdk.find_type_definition("app.HitController")
local is_player_hit = false
local dt_regen_rate = 50.0

-- Injeta os hooks de dano na memória. Recebe a tabela de estado para ler o status da GUI.
function GlobalMods.init_hooks(state)
    if not hit_controller_def then
        print("[InulieSSS] Erro: app.HitController não encontrado.")
        return
    end

    sdk.hook(hit_controller_def:get_method("damageProc"), function(args)
        is_player_hit = false
    end, function(retval) return retval end)

    sdk.hook(hit_controller_def:get_method("calcDamageValueDmgPl"), function(args)
        is_player_hit = true
        if state.global.no_damage then return sdk.PreHookResult.SKIP_ORIGINAL end
    end, function(retval) return retval end)

    sdk.hook(hit_controller_def:get_method("updateDamage"), function(args)
        if is_player_hit and state.global.no_damage then return sdk.PreHookResult.SKIP_ORIGINAL end
    end, function(retval) return retval end)

    sdk.hook(hit_controller_def:get_method("setDamageReaction"), function(args)
        if is_player_hit and state.global.no_damage then return sdk.PreHookResult.SKIP_ORIGINAL end
    end, function(retval) return retval end)
end

-- Roda a cada frame para gerenciar o DT
function GlobalMods.update(manual_player, state)
    if not state.global.infinite_dt then return end

    local current_dt = manual_player:call("get_devilTriggerGauge")
    local max_dt = manual_player:call("get_maxDevilTriggerGauge")

    if current_dt and max_dt and current_dt < max_dt then
        local new_dt_value = math.min(current_dt + dt_regen_rate, max_dt)
        manual_player:call("set_devilTriggerGauge", new_dt_value)
    end
end

return GlobalMods