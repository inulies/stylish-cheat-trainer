-- Variável para armazenar o estado de configuração do jogo, pela GUI do REFramework.
    -- Variable to store the game's configuration state, through the REFramework GUI.
local ConfigState = {
    -- Global
    godMode = false,
    infiniteDt = false,
    
    -- Nero
    infiniteExceed = false,
    infiniteColorUp = false,
    instantChargeShot = false,
    
    -- Dante
    infiniteSdtDante = false,
    infiniteBalrog = false,
    
    -- Vergil
    infiniteConcentration = false,
    infiniteSdtVergil = false
}

-- Lógica de salvamento de estado de configuração em arquivo JSON. Persistindo os dados mesmo após sair e entrar no jogo
-- Logic for saving configuration state to a JSON file. Persisting data even after exiting and entering the game
local SETTINGS_FILE = "StylishTrainerConfig.json"

function ConfigState.Save()
    json.dump_file(SETTINGS_FILE, ConfigState)
end

function ConfigState.Load()
    local loadedData = json.load_file(SETTINGS_FILE)
    if not loadedData then return end
    for key, value in pairs(loadedData) do
        if ConfigState[key] ~= nil and type(ConfigState[key]) ~= "function" then
            ConfigState[key] = value
        end
    end
end

-- Primeiro carregamento de configuração ao inicializar Script
-- First config load when initializing the script
ConfigState.Load()

return ConfigState