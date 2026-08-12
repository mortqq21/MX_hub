--[[
    MX Hub - Configuration & Auto-Save Manager
    Provides JSON serialization, config file saving, auto-loading user settings,
    and profile management via writefile / readfile / isfile executor functions.
--]]

local HttpService = game:GetService("HttpService")

local ConfigManager = {}
ConfigManager.Folder = "MX_Hub"
ConfigManager.File = "MX_Hub/config.json"

ConfigManager.Settings = {
    -- Main Farm Settings
    AutoFarmLevel = false,
    FarmWeapon = "Melee",
    AutoStats = false,
    PrimaryStat = "Melee",
    AutoMastery = false,

    -- Swords & Mythics
    AutoTTK = false,
    AutoCDK = false,
    AutoSoulGuitar = false,

    -- Fruits & Inventory
    AutoSnipeFruit = false,
    AutoGrabFruit = false,
    AutoStoreFruit = false,
    FruitESP = false,
    ChestESP = false,

    -- Sea Events
    AutoSeaBeast = false,
    AutoMirageGear = false,

    -- Race V4
    AutoFlowers = false,
    AutoTempleTrial = false,

    -- Raids
    SelectedRaidChip = "Dough",
    AutoRaidLoop = false,

    -- PvP
    HitboxExtender = false,
    HitboxSize = 16,
    SafeHealthRun = false,
    SafeHealthPct = 25,

    -- Performance
    AntiAFK = true,
    FPSBooster = false,
    LowGraphics = false,
    WhiteScreen = false,
}

--- Ensure config directory exists
function ConfigManager.Init()
    if makefolder and not isfolder(ConfigManager.Folder) then
        pcall(function() makefolder(ConfigManager.Folder) end)
    end
end

--- Save current configuration to JSON file
function ConfigManager.Save()
    ConfigManager.Init()
    if writefile then
        local success, err = pcall(function()
            local jsonStr = HttpService:JSONEncode(ConfigManager.Settings)
            writefile(ConfigManager.File, jsonStr)
        end)
        if success then
            print("[MX Hub Config] Configuration saved successfully!")
        else
            warn("[MX Hub Config] Save error: " .. tostring(err))
        end
    end
end

--- Load saved configuration from JSON file
function ConfigManager.Load()
    ConfigManager.Init()
    if readfile and isfile and isfile(ConfigManager.File) then
        local success, result = pcall(function()
            local jsonStr = readfile(ConfigManager.File)
            return HttpService:JSONDecode(jsonStr)
        end)
        if success and type(result) == "table" then
            for key, val in pairs(result) do
                ConfigManager.Settings[key] = val
            end
            print("[MX Hub Config] Configuration loaded successfully!")
        end
    end
    return ConfigManager.Settings
end

return ConfigManager
