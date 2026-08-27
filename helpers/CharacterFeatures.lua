local HookManager = require("helpers/HookManager")

local CharacterFeatures = {}
local achievedConcentration = 2.0

-- Global: aumento contínuo de Devil Trigger (DT) a cada frame, até o máximo permitido
-- Global: continuous increase of Devil Trigger (DT) each frame, up to the maximum allowed
function CharacterFeatures.UpdateInfiniteDt(player)
    local currentDt = player:call("get_devilTriggerGauge")
    local maxDt = player:call("get_maxDevilTriggerGauge")

    if currentDt and maxDt and currentDt < maxDt then
        local newDtValue = currentDt + 50.0
        if newDtValue > maxDt then newDtValue = maxDt end
        player:call("set_devilTriggerGauge", newDtValue)
    end
end

-- Nero: mantém o nível de Exceed no 3 sem reduzir, garantindo que o jogador possa usar Exceed continuamente
-- Nero: keeps the Exceed level at 3 without reduction, ensuring the player can use Exceed continuously
function CharacterFeatures.UpdateInfiniteExceed(player)
    local gaugeManager = player:call("get_exceedGaugeManager")
    if gaugeManager then
        gaugeManager:call("set_Stock", 3)
        gaugeManager:call("set_exceedLevel", 3)
    end
end

-- Nero: mantém o tambor do ColorUp no máximo, sem redução
-- Nero: keeps the ColorUp chamber at maximum, without reduction
function CharacterFeatures.UpdateInfiniteColorUp(player)
    local reserveLevel = player:call("get_reserveChargeLevel")
    if reserveLevel and reserveLevel < 3 then
        player:call("set_reserveChargeLevel", 3)
    end

    local blueRose = player:call("get_cachedBlueRose")
    if blueRose then
        local currentShells = blueRose:call("get_shellCount")
        local maxShells = blueRose:call("get_maxShellCount")
        if currentShells and maxShells and currentShells < maxShells then
            blueRose:call("set_shellCount", maxShells)
        end
    end
end

-- Nero: mantém o nível de disparo carregado da Blue Rose no máximo(Não brilha nem mostra na UI, mas permite disparar o tiro carregado instantaneamente)
-- Nero: keeps the Blue Rose's charged shot level at maximum (does not glow or show in the UI, but allows for instant charged shots)
function CharacterFeatures.UpdateInfiniteChargeShot(player)
    local chargeChecker = player:get_field("BlueRoseCharge")
    if chargeChecker then
        local maxLevel = chargeChecker:call("get_maxLevel")
        local currentLevel = chargeChecker:call("get_currentLevel")
        if currentLevel and maxLevel and currentLevel < maxLevel then
            chargeChecker:call("set_currentLevel", maxLevel)
        end
    end
end

-- Dante: Atualiza o nível do Sin Devil Trigger(SDT) para o máximo permitido, garantindo que Dante possa usar o SDT continuamente
-- Dante: Updates the Sin Devil Trigger (SDT) level to the maximum allowed, ensuring that Dante can use SDT continuously
function CharacterFeatures.UpdateDanteSdt(player)
    player:call("set_theDTGauge", 10000.0)
end

-- Dante: Após carregar o fogo do Balrog, impede que o fogo apague por tempo
-- Dante: After loading the Balrog's fire, prevents the fire from extinguishing over time
function CharacterFeatures.UpdateInfiniteBalrog()
    local balrog = HookManager.balrogInstance
    if not balrog then return end
    
    if not sdk.is_managed_object(balrog) then 
        HookManager.balrogInstance = nil
        return 
    end
    
    local mode = balrog:get_field("<burningMode>k__BackingField")
    local timer = balrog:get_field("<burningTimer>k__BackingField")
    if mode == 1 and type(timer) == "number" and timer < 500.0 then
        balrog:set_field("<burningTimer>k__BackingField", 1200.0)
    end
end

-- Vergil: Atualiza o nível de concentração para 2.0, e impede que o nível caia. Atualizando caso seja maior que 2.0, e mantendo o nível máximo alcançado.
-- Vergil: Updates the concentration level to 2.0, and prevents the level from dropping. Updates if it is greater than 2.0, and maintains the maximum level achieved.
function CharacterFeatures.UpdateVergilConcentration(player)
    local currentGauge = player:get_field("<concentGauge>k__BackingField")
    if currentGauge then
        if currentGauge >= achievedConcentration then
            achievedConcentration = currentGauge
        elseif currentGauge < achievedConcentration then
            player:set_field("<concentGauge>k__BackingField", achievedConcentration)
        end
    end
end

-- Vergil: Atualiza o nível do Sin Devil Trigger(SDT) para o máximo permitido, garantindo que Vergil possa usar o SDT continuamente
-- Vergil: Updates the Sin Devil Trigger (SDT) level to the maximum allowed, ensuring that Vergil can use SDT continuously
function CharacterFeatures.UpdateVergilSdt(player)
    local maxSdt = player:get_field("MAX_THEDEVILTRIGGER_GAUGE")
    if type(maxSdt) ~= "number" then maxSdt = 10000.0 end
    player:call("set_theDTGauge", maxSdt)
end


return CharacterFeatures