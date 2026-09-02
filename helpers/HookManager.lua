local ConfigState = require("helpers/ConfigState")

local HookManager = {
    balrogInstance = nil,
    isPlayerHit = false
}

function HookManager.Initialize()
    -- Hook para capturar a instância do Balrog quando ele é atualizado no metodo "doUpdate"
    -- Hook to capture the Balrog instance when it is updated in the "doUpdate" method
    local balrogDef = sdk.find_type_definition("app.WeaponBalrog")
    if balrogDef then
        local doUpdate = balrogDef:get_method("doUpdate")
        if doUpdate then
            sdk.hook(doUpdate, function(args)
                local balrog = sdk.to_managed_object(args[2])
                if balrog then HookManager.balrogInstance = balrog end
            end, function(retval) return retval end)
        end
    end

    -- Hooks para implementar o No Damage, interceptando métodos relacionados a dano
    -- Hooks to implement No Damage, intercepting damage-related methods
    local hitControllerDef = sdk.find_type_definition("app.HitController")
    if hitControllerDef then
        sdk.hook(hitControllerDef:get_method("damageProc"), function(args)
            HookManager.isPlayerHit = false
        end, function(retval) return retval end)

        sdk.hook(hitControllerDef:get_method("calcDamageValueDmgPl"), function(args)
            HookManager.isPlayerHit = true
            if ConfigState.godMode then return sdk.PreHookResult.SKIP_ORIGINAL end
        end, function(retval) return retval end)

        sdk.hook(hitControllerDef:get_method("updateDamage"), function(args)
            if HookManager.isPlayerHit and ConfigState.godMode then return sdk.PreHookResult.SKIP_ORIGINAL end
        end, function(retval) return retval end)

        sdk.hook(hitControllerDef:get_method("setDamageReaction"), function(args)
            if HookManager.isPlayerHit and ConfigState.godMode then return sdk.PreHookResult.SKIP_ORIGINAL end
        end, function(retval) return retval end)
    end
end

return HookManager