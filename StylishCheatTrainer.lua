package.path = package.path .. ";./reframework/stylish-cheat-trainer/?.lua"

-- Importa os módulos necessários da pasta helpers
-- Import the necessary modules from the helpers folder
local ConfigState = require("helpers/ConfigState")
local UiManager = require("helpers/UiManager")
local HookManager = require("helpers/HookManager")
local CharacterFeatures = require("helpers/CharacterFeatures")

-- Captura e grava os dados primitivos de cada personagem.
-- Captures and records the primitive data of each character.
local playerNero = sdk.find_type_definition("app.PlayerNero")
local playerV = sdk.find_type_definition("app.PlayerV")
local playerDante = sdk.find_type_definition("app.PlayerDante")
local playerVergil = sdk.find_type_definition("app.PlayerVergilPL")

-- Inicializa o HookManager
-- Initializes the HookManager
HookManager.Initialize()

-- Renderiza o UI do Trainer para aparecer no insert menu do REFramework
-- Renders the Trainer UI to appear in the REFramework insert menu
re.on_draw_ui(function()
    UiManager.Render()
end)

-- re.on_frame é chamado a cada frame do jogo
-- re.on_frame is called every game frame
re.on_frame(function()
    -- Obtém os dados do jogador atual e verifica o Tipo do jogador (Nero, Dante, V ou Vergil)
    local playerManager = sdk.get_managed_singleton("app.PlayerManager")
    if not playerManager then return end 
    local currentPlayer = playerManager:call("get_manualPlayer")
    if not currentPlayer then return end
    local currentPlayerType = currentPlayer:get_type_definition()

    -- Chama o infiniteDt do CharacterFeatures se a opção estiver ativada no ConfigState
    -- Calls the infiniteDt from CharacterFeatures if the option is enabled in ConfigState
    if ConfigState.infiniteDt then 
        CharacterFeatures.UpdateInfiniteDt(currentPlayer) 
    end

    -- Checagem e chamada de funções específicas para cada personagem, dependendo do tipo do jogador atual
    -- Checks and calls specific functions for each character, depending on the current player's type
    if currentPlayerType == playerNero then
        if ConfigState.infiniteExceed then CharacterFeatures.UpdateInfiniteExceed(currentPlayer) end 
        if ConfigState.infiniteColorUp then CharacterFeatures.UpdateInfiniteColorUp(currentPlayer) end
        if ConfigState.instantChargeShot then CharacterFeatures.UpdateInfiniteChargeShot(currentPlayer) end

    elseif currentPlayerType == playerDante then 
        if ConfigState.infiniteSdtDante then CharacterFeatures.UpdateDanteSdt(currentPlayer) end 
        if ConfigState.infiniteBalrog then CharacterFeatures.UpdateInfiniteBalrog() end 

    elseif currentPlayerType == playerVergil then
        if ConfigState.infiniteConcentration then CharacterFeatures.UpdateVergilConcentration(currentPlayer) end 
        if ConfigState.infiniteSdtVergil then CharacterFeatures.UpdateVergilSdt(currentPlayer) end 
    end
end)

print("[Stylish Cheat Trainer] Sistema modularizado carregado com sucesso.")