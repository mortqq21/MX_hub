--[[
    MX Hub - UI Interface Controller (WindUI / Fluent Library Integration)
    Handles full window construction, theme styling, tab assembly, control binding,
    and auto-save synchronization across all feature modules.
--]]

local UI = {}

function UI.Build(Fluent, Modules, Utils)
    local ConfigManager = Utils.Config
    local Performance = Utils.Performance
    local MainFarm = Modules.MainFarm
    local Swords = Modules.Swords
    local Fruits = Modules.Fruits
    local SeaEvents = Modules.SeaEvents
    local RaceV4 = Modules.RaceV4
    local Raids = Modules.Raids
    local PVP = Modules.PVP
    local Teleports = Modules.Teleports

    -- Load saved configuration settings
    local cfg = ConfigManager.Load()

    -- 1. Create Main Window
    local Window = Fluent:CreateWindow({
        Title = "MX HUB | Blox Fruits [v3.0 Ultra]",
        SubTitle = "by MX Development Team",
        TabWidth = 160,
        Size = UDim2.fromOffset(600, 480),
        Acrylic = true,
        Theme = "Darker",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    -- 2. Create UI Tabs
    local Tabs = {
        Main = Window:AddTab({ Title = "Main / Auto Farm", Icon = "home" }),
        Swords = Window:AddTab({ Title = "TTK / CDK / Mythics", Icon = "sword" }),
        Fruits = Window:AddTab({ Title = "Fruit & Inventory", Icon = "apple" }),
        Sea = Window:AddTab({ Title = "Sea Events & Mirage", Icon = "waves" }),
        Race = Window:AddTab({ Title = "Race V1 - V4", Icon = "zap" }),
        Raids = Window:AddTab({ Title = "Raids & Awaken", Icon = "flame" }),
        PVP = Window:AddTab({ Title = "PvP & Bounty", Icon = "crosshair" }),
        Teleports = Window:AddTab({ Title = "Teleports & World", Icon = "map-pin" }),
        Settings = Window:AddTab({ Title = "Settings & Perf", Icon = "settings" })
    }

    -- ------------------------------------------------------------------------
    -- TAB 1: MAIN / AUTO FARM
    -- ------------------------------------------------------------------------
    local FarmSection = Tabs.Main:AddSection("Auto Level & Combat Engine")
    
    local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarmLevel", { Title = "Auto Farm Level (1 - 2550)", Default = cfg.AutoFarmLevel })
    AutoFarmToggle:OnChanged(function(val)
        cfg.AutoFarmLevel = val
        ConfigManager.Save()
        if val then MainFarm.StartAutoFarm() else MainFarm.StopAutoFarm() end
    end)

    local WeaponDropdown = Tabs.Main:AddDropdown("WeaponSelect", {
        Title = "Select Farm Weapon",
        Values = {"Melee", "Sword", "Gun", "Blox Fruit"},
        Multi = false,
        Default = cfg.FarmWeapon or 1
    })
    WeaponDropdown:OnChanged(function(val)
        cfg.FarmWeapon = val
        ConfigManager.Save()
    end)

    local StatsSection = Tabs.Main:AddSection("Auto Stats Allocator")
    local AutoStatsToggle = Tabs.Main:AddToggle("AutoStats", { Title = "Auto Allocate Stat Points", Default = cfg.AutoStats })
    AutoStatsToggle:OnChanged(function(val)
        cfg.AutoStats = val
        MainFarm.AutoStats = val
        ConfigManager.Save()
        if val then MainFarm.StartAutoStats() end
    end)

    -- ------------------------------------------------------------------------
    -- TAB 2: SWORDS & MYTHICS
    -- ------------------------------------------------------------------------
    Tabs.Swords:AddSection("True Triple Katana (TTK)")
    Tabs.Swords:AddButton({
        Title = "Check Legendary Dealer & Buy Swords",
        Description = "Invokes ValuableCheck and auto purchases Shisui, Wando, and Saddi",
        Callback = function()
            Swords.CheckAndBuyLegendarySwords()
            Fluent:Notify({ Title = "MX TTK Dealer", Content = "ValuableCheck executed successfully!", Duration = 5 })
        end
    })

    Tabs.Swords:AddSection("Cursed Dual Katana & Soul Guitar")
    Tabs.Swords:AddButton({
        Title = "Start Auto CDK Puzzles (Tushita & Yama)",
        Callback = function()
            Swords.RunCDKAutomation()
            Fluent:Notify({ Title = "MX CDK", Content = "CDK Puzzle sequence started!", Duration = 5 })
        end
    })
    Tabs.Swords:AddButton({
        Title = "Auto Soul Guitar Puzzle",
        Callback = function()
            Swords.RunSoulGuitarAutomation()
            Fluent:Notify({ Title = "MX Soul Guitar", Content = "Soul Guitar puzzle sequence started!", Duration = 5 })
        end
    })

    -- ------------------------------------------------------------------------
    -- TAB 3: FRUITS & INVENTORY
    -- ------------------------------------------------------------------------
    Tabs.Fruits:AddSection("Fruit Gacha & Store")
    Tabs.Fruits:AddButton({
        Title = "Buy Random Fruit (Zioles Cousin)",
        Callback = function()
            local res = Fruits.BuyRandomFruit()
            Fluent:Notify({ Title = "Fruit Gacha", Content = "Result: " .. tostring(res), Duration = 5 })
        end
    })
    Tabs.Fruits:AddButton({
        Title = "Store All Fruits to Inventory",
        Callback = function()
            Fruits.StoreAllFruitsInBackpack()
            Fluent:Notify({ Title = "Treasure Inventory", Content = "Stored all fruits!", Duration = 4 })
        end
    })

    local GrabberToggle = Tabs.Fruits:AddToggle("AutoFruitGrab", { Title = "Auto Fruit Grabber (Teleport & Pick)", Default = cfg.AutoGrabFruit })
    GrabberToggle:OnChanged(function(val)
        cfg.AutoGrabFruit = val
        ConfigManager.Save()
        if val then Fruits.StartAutoGrab() else Fruits.StopAutoGrab() end
    end)

    -- ------------------------------------------------------------------------
    -- TAB 4: SEA EVENTS & MIRAGE
    -- ------------------------------------------------------------------------
    Tabs.Sea:AddSection("Sea Events")
    local SeaBeastToggle = Tabs.Sea:AddToggle("AutoSeaBeast", { Title = "Auto Sea Beast / Kraken Farm", Default = cfg.AutoSeaBeast })
    SeaBeastToggle:OnChanged(function(val)
        cfg.AutoSeaBeast = val
        ConfigManager.Save()
        if val then SeaEvents.StartAutoSeaBeast() else SeaEvents.StopAutoSeaBeast() end
    end)

    Tabs.Sea:AddSection("Mirage Island & Gear Puzzle")
    Tabs.Sea:AddButton({
        Title = "Run Mirage Moon Gear Puzzle",
        Callback = function()
            SeaEvents.RunMirageMoonPuzzle()
        end
    })

    -- ------------------------------------------------------------------------
    -- TAB 5: RACE V1 TO V4 AWAKENING
    -- ------------------------------------------------------------------------
    Tabs.Race:AddSection("Race V2 Flower Farm")
    local FlowerToggle = Tabs.Race:AddToggle("AutoFlowers", { Title = "Auto Collect Red & Blue Flowers", Default = cfg.AutoFlowers })
    FlowerToggle:OnChanged(function(val)
        cfg.AutoFlowers = val
        ConfigManager.Save()
        if val then RaceV4.StartAutoFlowers() else RaceV4.StopAutoFlowers() end
    end)

    Tabs.Race:AddSection("Race V4 Temple of Time")
    Tabs.Race:AddButton({
        Title = "Run Race V4 Temple Entry & Lever Pull",
        Callback = function()
            RaceV4.RunTempleOfTimeTrial()
        end
    })

    -- ------------------------------------------------------------------------
    -- TAB 6: RAIDS & DOUGH AWAKENING
    -- ------------------------------------------------------------------------
    Tabs.Raids:AddSection("Raid Automation")
    local RaidTypeDropdown = Tabs.Raids:AddDropdown("RaidSelect", {
        Title = "Select Raid Chip",
        Values = {"Dough", "Phoenix", "Flame", "Ice", "Quake", "Light", "Dark", "Rumble", "Magma", "Human: Buddha"},
        Multi = false,
        Default = cfg.SelectedRaidChip or 1
    })
    RaidTypeDropdown:OnChanged(function(val)
        cfg.SelectedRaidChip = val
        Raids.SelectedRaid = val
        ConfigManager.Save()
    end)

    Tabs.Raids:AddButton({
        Title = "Buy Selected Microchip",
        Callback = function()
            local res = Raids.BuyChip(Raids.SelectedRaid)
            Fluent:Notify({ Title = "Raid Microchip", Content = "Bought: " .. tostring(Raids.SelectedRaid), Duration = 4 })
        end
    })

    local AutoRaidToggle = Tabs.Raids:AddToggle("AutoRaidLoop", { Title = "Auto Full Raid (Buy Chip -> Start -> Rooms 1-5)", Default = cfg.AutoRaidLoop })
    AutoRaidToggle:OnChanged(function(val)
        cfg.AutoRaidLoop = val
        ConfigManager.Save()
        if val then Raids.StartAutoRaid() else Raids.StopAutoRaid() end
    end)

    -- ------------------------------------------------------------------------
    -- TAB 7: PVP & BOUNTY
    -- ------------------------------------------------------------------------
    Tabs.PVP:AddSection("PvP Hitbox & Escape")
    local HitboxToggle = Tabs.PVP:AddToggle("HitboxExtender", { Title = "Hitbox Extender (Head/HRP Expansion)", Default = cfg.HitboxExtender })
    HitboxToggle:OnChanged(function(val)
        cfg.HitboxExtender = val
        ConfigManager.Save()
        PVP.SetHitboxExtender(val)
    end)

    local SafeHealthToggle = Tabs.PVP:AddToggle("SafeHealthRun", { Title = "Auto Escape Sky on Low Health (<25%)", Default = cfg.SafeHealthRun })
    SafeHealthToggle:OnChanged(function(val)
        cfg.SafeHealthRun = val
        ConfigManager.Save()
        PVP.SetSafeHealthRun(val)
    end)

    -- ------------------------------------------------------------------------
    -- TAB 8: TELEPORTS & WORLD
    -- ------------------------------------------------------------------------
    Tabs.Teleports:AddSection("Sea World Hopper")
    Tabs.Teleports:AddButton({ Title = "Travel to Sea 1 (First Sea)", Callback = function() Teleports.TravelSea(1) end })
    Tabs.Teleports:AddButton({ Title = "Travel to Sea 2 (Second Sea)", Callback = function() Teleports.TravelSea(2) end })
    Tabs.Teleports:AddButton({ Title = "Travel to Sea 3 (Third Sea)", Callback = function() Teleports.TravelSea(3) end })

    Tabs.Teleports:AddSection("Server Options")
    Tabs.Teleports:AddButton({ Title = "Rejoin Server", Callback = function() Teleports.RejoinServer() end })
    Tabs.Teleports:AddButton({ Title = "Server Hop (Low Players)", Callback = function() Teleports.ServerHop() end })

    -- ------------------------------------------------------------------------
    -- TAB 9: SETTINGS & PERFORMANCE
    -- ------------------------------------------------------------------------
    Tabs.Settings:AddSection("Performance & Optimization")

    local AntiAFKToggle = Tabs.Settings:AddToggle("AntiAFK", { Title = "Anti-AFK Disconnect Preventer", Default = cfg.AntiAFK })
    AntiAFKToggle:OnChanged(function(val)
        cfg.AntiAFK = val
        ConfigManager.Save()
        Performance.SetAntiAFK(val)
    end)

    local FPSBoosterToggle = Tabs.Settings:AddToggle("FPSBooster", { Title = "FPS Booster & Lag Reduction", Default = cfg.FPSBooster })
    FPSBoosterToggle:OnChanged(function(val)
        cfg.FPSBooster = val
        ConfigManager.Save()
        Performance.SetFPSBooster(val)
    end)

    local WhiteScreenToggle = Tabs.Settings:AddToggle("WhiteScreen", { Title = "Overnight GPU Saver Mode (3D Rendering Off)", Default = cfg.WhiteScreen })
    WhiteScreenToggle:OnChanged(function(val)
        cfg.WhiteScreen = val
        ConfigManager.Save()
        Performance.SetWhiteScreen(val)
    end)

    Tabs.Settings:AddSection("Configuration Save Manager")
    Tabs.Settings:AddButton({
        Title = "Save Preferences to File",
        Callback = function()
            ConfigManager.Save()
            Fluent:Notify({ Title = "Configuration", Content = "Saved settings to MX_Hub/config.json!", Duration = 4 })
        end
    })

    -- Enable Anti-AFK by default
    Performance.SetAntiAFK(true)

    Window:SelectTab(1)
    return Window
end

return UI
