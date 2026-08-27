local ConfigState = require("helpers/ConfigState")

local UiManager = {}

-- Renderiza a interface do usuário do Trainer usando imgui e estados para cada personagem.
-- Renders the Trainer's user interface using imgui and states for each character.
function UiManager.Render()
    if not imgui.tree_node("Stylish Cheat Trainer") then return end

    -- GLOBAL
    if imgui.tree_node("Global") then
        local changedGod, valueGod = imgui.checkbox("No Damage", ConfigState.godMode)
        if changedGod then 
            ConfigState.godMode = valueGod 
            ConfigState.Save()
        end

        local changedDt, valueDt = imgui.checkbox("Devil Trigger Regeneration", ConfigState.infiniteDt)
        if changedDt then 
            ConfigState.infiniteDt = valueDt 
            ConfigState.Save()
        end
        
        imgui.tree_pop()
    end

    -- NERO
    if imgui.tree_node("Nero") then
        local changedExceed, valueExceed = imgui.checkbox("Infinite Exceed", ConfigState.infiniteExceed)
        if changedExceed then 
            ConfigState.infiniteExceed = valueExceed 
            ConfigState.Save() 
        end

        local changedColor, valueColor = imgui.checkbox("Infinite Color Up Shot", ConfigState.infiniteColorUp)
        if changedColor then 
            ConfigState.infiniteColorUp = valueColor 
            ConfigState.Save() 
        end

        local changedCharge, valueCharge = imgui.checkbox("Instant Charge Shot", ConfigState.instantChargeShot)
        if changedCharge then 
            ConfigState.instantChargeShot = valueCharge 
            ConfigState.Save() 
        end
        imgui.tree_pop()
    end

    -- V
    if imgui.tree_node("V") then
        imgui.text("Nenhuma feature implementada ainda.")
        imgui.tree_pop()
    end

    -- DANTE
    if imgui.tree_node("Dante") then
        local changedSdt, valueSdt = imgui.checkbox("Infinite Sin Devil Trigger", ConfigState.infiniteSdtDante)
        if changedSdt then 
            ConfigState.infiniteSdtDante = valueSdt 
            ConfigState.Save() 
        end

        local changedBalrog, valueBalrog = imgui.checkbox("Infinite Balrog", ConfigState.infiniteBalrog)
        if changedBalrog then 
            ConfigState.infiniteBalrog = valueBalrog 
            ConfigState.Save() 
        end
        imgui.tree_pop()
    end

    -- VERGIL
    if imgui.tree_node("Vergil") then
        local changedConcentration, valueConcentration = imgui.checkbox("Disable Concentration Decrease", ConfigState.infiniteConcentration)
        if changedConcentration then
            ConfigState.infiniteConcentration = valueConcentration
            if valueConcentration then
                ConfigState.maxAchievedConcentration = 5.0
            end
            ConfigState.Save()
        end

        local changedVergilSdt, valueVergilSdt = imgui.checkbox("Infinite Sin Devil Trigger", ConfigState.infiniteSdtVergil)
        if changedVergilSdt then 
            ConfigState.infiniteSdtVergil = valueVergilSdt 
            ConfigState.Save() 
        end
        imgui.tree_pop()
    end

    imgui.tree_pop()
end

return UiManager