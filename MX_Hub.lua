--[[
================================================================================
                    MX HUB - BLOX FRUITS PREMIUM SCRIPT HUB
               Version: 3.1 Ultra Complete (Latest Update 24)
                  Supported: Sea 1 (First), Sea 2 (Second), Sea 3 (Third)
    Aesthetic: Modern Futuristic Dark-Themed UI with Acrylic & Smooth Animations
================================================================================
--]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ============================================================================
-- 1. SECURITY & ANTI-BAN ENGINE
-- ============================================================================
local Security = {}
function Security.RandomString(length)
    length = length or math.random(8, 14)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local str = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        str = str .. chars:sub(randIndex, randIndex)
    end
    return str
end

function Security.HumanDelay(min, max)
    task.wait(math.random() * ((max or 0.3) - (min or 0.1)) + (min or 0.1))
end

function Security.GetSafeSpeed(speed)
    return math.min(speed or 280, 280)
end

-- ============================================================================
-- 2. UTILS MODULES & WATER WALK ENGINE
-- ============================================================================

-- CONFIG MANAGER
local ConfigManager = { Folder = "MX_Hub", File = "MX_Hub/config.json" }
ConfigManager.Settings = {
    AutoFarmLevel = false, FarmWeapon = "Melee", AutoStats = false, PrimaryStat = "Melee",
    AutoGrabFruit = false, AutoSeaBeast = false, AutoFlowers = false, AutoBoss = false, SelectedBoss = "Rip Indra [Boss]",
    AutoMaterial = false, SelectedMaterial = "Bones", AutoKitsuneWisp = false,
    SelectedRaidChip = "Dough", AutoRaidLoop = false, HitboxExtender = false, SafeHealthRun = false,
    AntiAFK = true, FPSBooster = false, WhiteScreen = false, WaterWalk = true
}

function ConfigManager.Init()
    if makefolder and not isfolder(ConfigManager.Folder) then pcall(makefolder, ConfigManager.Folder) end
end
function ConfigManager.Save()
    ConfigManager.Init()
    if writefile then pcall(writefile, ConfigManager.File, HttpService:JSONEncode(ConfigManager.Settings)) end
end
function ConfigManager.Load()
    ConfigManager.Init()
    if readfile and isfile and isfile(ConfigManager.File) then
        local ok, res = pcall(function() return HttpService:JSONDecode(readfile(ConfigManager.File)) end)
        if ok and type(res) == "table" then
            for k, v in pairs(res) do ConfigManager.Settings[k] = v end
        end
    end
    return ConfigManager.Settings
end

-- WATER WALK ENGINE (المشي فوق الماء من دون أضرار)
local WaterWalkEngine = { Enabled = true }
local WaterPart = nil
local WaterConn = nil

function WaterWalkEngine.Start()
    if WaterConn then return end
    WaterConn = RunService.RenderStepped:Connect(function()
        if not WaterWalkEngine.Enabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not WaterPart or not WaterPart.Parent then
                WaterPart = Instance.new("Part")
                WaterPart.Name = Security.RandomString(10)
                WaterPart.Size = Vector3.new(60, 2, 60)
                WaterPart.Anchored = true
                WaterPart.Transparency = 0.8
                WaterPart.Color = Color3.fromRGB(0, 230, 255)
                WaterPart.Parent = Workspace
            end
            if hrp.Position.Y < 30 and hrp.Position.Y > -15 then
                WaterPart.CFrame = CFrame.new(hrp.Position.X, 1, hrp.Position.Z)
                WaterPart.CanCollide = true
            else
                WaterPart.CanCollide = false
            end
        end
    end)
end
WaterWalkEngine.Start()

-- PERFORMANCE & ANTI-AFK
local Performance = { AntiAFKEnabled = false, FPSBoosterEnabled = false, WhiteScreenEnabled = false }
local AntiAFKConn = nil
local WhiteScreenGui = nil

function Performance.SetAntiAFK(state)
    Performance.AntiAFKEnabled = state
    if state and not AntiAFKConn then
        AntiAFKConn = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    elseif not state and AntiAFKConn then
        AntiAFKConn:Disconnect() AntiAFKConn = nil
    end
end

function Performance.SetFPSBooster(state)
    Performance.FPSBoosterEnabled = state
    if state then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
                descendant.Enabled = false
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant.Texture = ""
            end
        end
    end
end

function Performance.SetWhiteScreen(state)
    Performance.WhiteScreenEnabled = state
    local coreGui = game:GetService("CoreGui")
    if state then
        if not WhiteScreenGui then
            WhiteScreenGui = Instance.new("ScreenGui", coreGui)
            WhiteScreenGui.Name = Security.RandomString(12)
            WhiteScreenGui.IgnoreGuiInset = true
            local frame = Instance.new("Frame", WhiteScreenGui)
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            local txt = Instance.new("TextLabel", frame)
            txt.Size = UDim2.new(1, 0, 0, 100)
            txt.Position = UDim2.new(0, 0, 0.4, 0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = Color3.fromRGB(0, 230, 255)
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 24
            txt.Text = "MX HUB - OVERNIGHT GPU SAVER MODE ACTIVE"
        end
        WhiteScreenGui.Enabled = true
        RunService:Set3dRenderingEnabled(false)
    else
        if WhiteScreenGui then WhiteScreenGui.Enabled = false end
        RunService:Set3dRenderingEnabled(true)
    end
end

-- REMOTES WRAPPER (`CommF_`)
local RemotesEngine = {}
local CommF = ReplicatedStorage:WaitForChild("Remotes", 10) and ReplicatedStorage.Remotes:WaitForChild("CommF_", 10)
local lastCallTick = 0

function RemotesEngine.Invoke(...)
    local now = tick()
    if (now - lastCallTick) < 0.2 then
        Security.HumanDelay(0.05, 0.15)
    end
    lastCallTick = tick()

    if not CommF then CommF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") end
    if CommF then
        local ok, res = pcall(CommF.InvokeServer, CommF, ...)
        if ok then return res end
    end
    return nil
end

-- TWEEN & NAVIGATION ENGINE (طيران ثابت على مستوى الماء وتأقلم مع ارتفاع الجزر)
local NavigationEngine = { Speed = 280, IsTweening = false, CurrentTween = nil }
local NoclipConn = nil

function NavigationEngine.SetNoclip(state)
    if state and not NoclipConn then
        NoclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide then child.CanCollide = false end
                end
            end
        end)
    elseif not state and NoclipConn then
        NoclipConn:Disconnect() NoclipConn = nil
    end
end

function NavigationEngine.TweenTo(targetCF, customSpeed, onComplete)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local safeSpeed = Security.GetSafeSpeed(customSpeed or NavigationEngine.Speed)
    local dist = (hrp.Position - targetCF.Position).Magnitude

    if dist < 8 then
        hrp.CFrame = targetCF
        if onComplete then onComplete() end
        return
    end

    if NavigationEngine.CurrentTween then NavigationEngine.CurrentTween:Cancel() end
    NavigationEngine.IsTweening = true
    NavigationEngine.SetNoclip(true)
    hum.Sit = false

    -- Flight Altitude Safety Manager (طيران ثابت فوق البحر وانخفاض عند الوصول للجزيرة)
    local flightTargetCF = targetCF
    if dist > 70 then
        local flightY = math.max(targetCF.Y + 25, 45)
        flightTargetCF = CFrame.new(targetCF.Position.X, flightY, targetCF.Position.Z)
    end

    local travelTime = dist / safeSpeed
    local tween = TweenService:Create(hrp, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), { CFrame = flightTargetCF })
    NavigationEngine.CurrentTween = tween

    local conn
    conn = tween.Completed:Connect(function(status)
        NavigationEngine.IsTweening = false
        NavigationEngine.SetNoclip(false)
        if conn then conn:Disconnect() end
        if status == Enum.PlaybackState.Completed then
            -- Touchdown on island ground
            hrp.CFrame = targetCF
            if onComplete then onComplete() end
        end
    end)
    tween:Play()
    return tween
end

-- FAST ATTACK ENGINE
local FastAttackEngine = { Enabled = false, WeaponType = "Melee", BringMobs = false, BringRadius = 300 }
local AttackLoopConn, BringLoopConn = nil, nil

function FastAttackEngine.EquipWeapon(category)
    local char = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    if not char or not backpack then return end
    local current = char:FindFirstChildOfClass("Tool")
    if current then return current end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then tool.Parent = char return tool end
    end
end

function FastAttackEngine.PerformClick()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    VirtualUser:Button1Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("RemoteFunction") then pcall(function() tool.RemoteFunction:InvokeServer() end) end
    end
end

function FastAttackEngine.Start()
    if AttackLoopConn then return end
    FastAttackEngine.Enabled = true
    AttackLoopConn = RunService.RenderStepped:Connect(function()
        if FastAttackEngine.Enabled then
            FastAttackEngine.EquipWeapon(FastAttackEngine.WeaponType)
            FastAttackEngine.PerformClick()
            task.wait(math.random(4, 7) / 100)
        end
    end)
end

function FastAttackEngine.Stop()
    FastAttackEngine.Enabled = false
    if AttackLoopConn then AttackLoopConn:Disconnect() AttackLoopConn = nil end
end

function FastAttackEngine.StartBring(mobName, centerCF)
    if BringLoopConn then return end
    FastAttackEngine.BringMobs = true
    BringLoopConn = RunService.Heartbeat:Connect(function()
        if not FastAttackEngine.BringMobs or not centerCF then return end
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in ipairs(enemies:GetChildren()) do
                if mob:IsA("Model") and (not mobName or mob.Name == mobName) then
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then
                        if (hrp.Position - centerCF.Position).Magnitude <= FastAttackEngine.BringRadius then
                            for _, p in ipairs(mob:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end
                            hrp.CFrame = centerCF * CFrame.new(0, 0, -3)
                            hrp.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end
    end)
end

function FastAttackEngine.StopBring()
    FastAttackEngine.BringMobs = false
    if BringLoopConn then BringLoopConn:Disconnect() BringLoopConn = nil end
end

-- ============================================================================
-- 3. DATA TABLES & QUEST DATABASE (1 - 2800 MAX LEVEL)
-- ============================================================================
local QuestDatabase = {
    { MinLevel = 1, MaxLevel = 10, QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", CFrame = CFrame.new(1059, 17, 1546), QuestNPC = CFrame.new(1059, 17, 1546) },
    { MinLevel = 10, MaxLevel = 30, QuestName = "JungleQuest", QuestLevel = 1, MobName = "Monkey", CFrame = CFrame.new(-1602, 37, 153), QuestNPC = CFrame.new(-1598, 37, 153) },
    { MinLevel = 30, MaxLevel = 60, QuestName = "BuggyQuest1", QuestLevel = 1, MobName = "Pirate", CFrame = CFrame.new(-1210, 5, 3915), QuestNPC = CFrame.new(-1140, 5, 3858) },
    { MinLevel = 60, MaxLevel = 90, QuestName = "DesertQuest", QuestLevel = 1, MobName = "Desert Bandit", CFrame = CFrame.new(890, 7, 4380), QuestNPC = CFrame.new(894, 7, 4390) },
    { MinLevel = 90, MaxLevel = 120, QuestName = "SnowQuest", QuestLevel = 1, MobName = "Snow Bandit", CFrame = CFrame.new(1280, 87, -1290), QuestNPC = CFrame.new(1385, 87, -1298) },
    { MinLevel = 120, MaxLevel = 700, QuestName = "MarineQuest2", QuestLevel = 1, MobName = "Chief Petty Officer", CFrame = CFrame.new(-4850, 21, 4300), QuestNPC = CFrame.new(-5035, 29, 4325) },
    { MinLevel = 700, MaxLevel = 1500, QuestName = "Area1Quest", QuestLevel = 1, MobName = "Raider", CFrame = CFrame.new(-450, 73, 2980), QuestNPC = CFrame.new(-425, 73, 1835) },
    { MinLevel = 1500, MaxLevel = 2499, QuestName = "TikiQuest1", QuestLevel = 1, MobName = "Isle Outlaw", CFrame = CFrame.new(-16500, 55, 5500), QuestNPC = CFrame.new(-16200, 55, 5450) },
    { MinLevel = 2500, MaxLevel = 2800, QuestName = "TikiQuest2", QuestLevel = 2, MobName = "Isle Champion", CFrame = CFrame.new(-16800, 55, 5900), QuestNPC = CFrame.new(-16200, 55, 5450) }
}

local MaterialData = {
    ["Bones"] = { MobName = "Reborn Skeleton", CFrame = CFrame.new(-9500, 140, 5600) },
    ["Ectoplasm"] = { MobName = "Ship Deckhand", CFrame = CFrame.new(1190, 125, 33000) },
    ["Scrap Metal"] = { MobName = "Brute", CFrame = CFrame.new(-1145, 15, 4350) },
    ["Dragon Scale"] = { MobName = "Dragon Crew Warrior", CFrame = CFrame.new(5800, 50, -4400) },
    ["Conjured Cocoa"] = { MobName = "Chocolate Bar Pirate", CFrame = CFrame.new(280, 25, -12500) },
    ["Vampire Fang"] = { MobName = "Vampire", CFrame = CFrame.new(-6010, 6, -1310) },
    ["Mystic Droplet"] = { MobName = "Water Fighter", CFrame = CFrame.new(60900, 18, 1500) },
    ["Mini Tusk"] = { MobName = "Mythological Pirate", CFrame = CFrame.new(5440, 600, 750) }
}

local BossDatabase = {
    "Rip Indra [Boss]", "Dough King", "Soul Reaper [Boss]", "Longma", "Cake Queen",
    "Elephant Admin", "Captain Elephant", "Beautiful Pirate", "Tide Keeper [Boss]",
    "Don Swan [Boss]", "Cyborg [Boss]", "Ice Admiral", "Jeremy", "Greybeard [Boss]"
}

local function getQuestData(level)
    for _, q in ipairs(QuestDatabase) do if level >= q.MinLevel and level <= q.MaxLevel then return q end end
    return QuestDatabase[#QuestDatabase]
end

-- ============================================================================
-- 4. FLOATING UI TOGGLE BUTTON (أيقونة عائمة لفتح وإغلاق القائمة)
-- ============================================================================
local function createFloatingToggle(WindowInstance)
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local existing = coreGui:FindFirstChild("MX_ToggleGui")
        if existing then existing:Destroy() end

        local sg = Instance.new("ScreenGui", coreGui)
        sg.Name = "MX_ToggleGui"
        sg.ResetOnSpawn = false

        local btn = Instance.new("TextButton", sg)
        btn.Size = UDim2.new(0, 48, 0, 48)
        btn.Position = UDim2.new(0, 15, 0.45, 0)
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        btn.TextColor3 = Color3.fromRGB(0, 230, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.Text = "MX"
        btn.Active = true
        btn.Draggable = true

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 12)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(0, 230, 255)
        stroke.Thickness = 2

        btn.MouseButton1Click:Connect(function()
            if WindowInstance then
                if WindowInstance.Root then
                    WindowInstance.Root.Enabled = not WindowInstance.Root.Enabled
                elseif WindowInstance.Minimize then
                    WindowInstance:Minimize()
                end
            end
        end)
    end)
end

-- ============================================================================
-- 5. FLUENT UI & MODULE BINDINGS
-- ============================================================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local cfg = ConfigManager.Load()
Performance.SetAntiAFK(cfg.AntiAFK)
Performance.SetFPSBooster(cfg.FPSBooster)

local Window = Fluent:CreateWindow({
    Title = "MX HUB | Blox Fruits [v3.1 Complete]", SubTitle = "by MX Development Team", TabWidth = 165, Size = UDim2.fromOffset(620, 500), Acrylic = true, Theme = "Darker", MinimizeKey = Enum.KeyCode.RightControl
})

-- Create floating toggle icon button
createFloatingToggle(Window)

local Tabs = {
    Main = Window:AddTab({ Title = "Main / Auto Farm", Icon = "home" }),
    BossMat = Window:AddTab({ Title = "Bosses & Materials", Icon = "skull" }),
    Swords = Window:AddTab({ Title = "Swords & Mythics", Icon = "sword" }),
    Fruits = Window:AddTab({ Title = "Fruit & Inventory", Icon = "apple" }),
    Sea = Window:AddTab({ Title = "Sea Events & Kitsune", Icon = "waves" }),
    Race = Window:AddTab({ Title = "Race V1 - V4", Icon = "zap" }),
    Raids = Window:AddTab({ Title = "Raids & Awaken", Icon = "flame" }),
    PVP = Window:AddTab({ Title = "PvP & Bounty", Icon = "crosshair" }),
    Teleports = Window:AddTab({ Title = "Teleports & World", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings & Perf", Icon = "settings" })
}

-- TAB 1: MAIN FARM
Tabs.Main:AddSection("Auto Level & Combat Engine (Level 1 - 2800)")
local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarmLevel", { Title = "Auto Farm Level (1 - 2800 Max)", Default = cfg.AutoFarmLevel })
AutoFarmToggle:OnChanged(function(val)
    cfg.AutoFarmLevel = val ConfigManager.Save()
    if val then
        FastAttackEngine.Start()
        task.spawn(function()
            while cfg.AutoFarmLevel do
                task.wait(0.1)
                local lvl = LocalPlayer.Data.Level.Value
                local qData = getQuestData(lvl)
                local activeQuest = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                if not (activeQuest and activeQuest.Visible) then
                    NavigationEngine.TweenTo(qData.QuestNPC, 280, function() RemotesEngine.Invoke("StartQuest", qData.QuestName, qData.QuestLevel) end)
                else
                    local enemies = Workspace:FindFirstChild("Enemies")
                    local mob = enemies and enemies:FindFirstChild(qData.MobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        FastAttackEngine.StartBring(qData.MobName, mob.HumanoidRootPart.CFrame)
                        NavigationEngine.TweenTo(mob.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 280)
                    else
                        NavigationEngine.TweenTo(qData.CFrame, 280)
                    end
                end
            end
            FastAttackEngine.Stop() FastAttackEngine.StopBring()
        end)
    else
        FastAttackEngine.Stop() FastAttackEngine.StopBring()
    end
end)

local StatsToggle = Tabs.Main:AddToggle("AutoStats", { Title = "Auto Allocate Stat Points", Default = cfg.AutoStats })
StatsToggle:OnChanged(function(val)
    cfg.AutoStats = val ConfigManager.Save()
    if val then
        task.spawn(function()
            while cfg.AutoStats do
                task.wait(2) RemotesEngine.Invoke("AddPoint", cfg.PrimaryStat or "Melee", 3)
            end
        end)
    end
end)

Tabs.Main:AddSection("Auto Buy All Fighting Styles (جميع أساليب القتال)")
local stylesDropdown = Tabs.Main:AddDropdown("SelectStyle", {
    Title = "Select Fighting Style",
    Values = { "Black Leg (Dark Step)", "Electro", "Fishman Karate", "Dragon Breath", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art" },
    Multi = false, Default = 1
})
local selectedStyle = "Black Leg (Dark Step)"
stylesDropdown:OnChanged(function(v) selectedStyle = v end)

Tabs.Main:AddButton({
    Title = "Buy Selected Fighting Style",
    Callback = function()
        local styleRemoteMap = {
            ["Black Leg (Dark Step)"] = "BuyBlackLeg", ["Electro"] = "BuyElectro", ["Fishman Karate"] = "BuyFishmanKarate",
            ["Dragon Breath"] = "BuyDragonBreath", ["Superhuman"] = "BuySuperhuman", ["Death Step"] = "BuyDeathStep",
            ["Sharkman Karate"] = "BuySharkmanKarate", ["Electric Claw"] = "BuyElectricClaw", ["Dragon Talon"] = "BuyDragonTalon",
            ["Godhuman"] = "BuyGodhuman", ["Sanguine Art"] = "BuySanguineArt"
        }
        RemotesEngine.Invoke(styleRemoteMap[selectedStyle] or "BuyBlackLeg")
        Fluent:Notify({ Title = "Fighting Style", Content = "Purchased: " .. selectedStyle, Duration = 5 })
    end
})

-- TAB 2: BOSSES & MATERIALS FARM
Tabs.BossMat:AddSection("All Bosses Auto Farm")
local bossDropdown = Tabs.BossMat:AddDropdown("SelectBoss", { Title = "Select Target Boss", Values = BossDatabase, Multi = false, Default = 1 })
bossDropdown:OnChanged(function(v) cfg.SelectedBoss = v ConfigManager.Save() end)

local AutoBossToggle = Tabs.BossMat:AddToggle("AutoBoss", { Title = "Auto Farm Selected Boss", Default = cfg.AutoBoss })
AutoBossToggle:OnChanged(function(val)
    cfg.AutoBoss = val ConfigManager.Save()
    if val then
        FastAttackEngine.Start()
        task.spawn(function()
            while cfg.AutoBoss do
                task.wait(0.5)
                local enemies = Workspace:FindFirstChild("Enemies")
                local boss = enemies and enemies:FindFirstChild(cfg.SelectedBoss)
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                    FastAttackEngine.StartBring(cfg.SelectedBoss, boss.HumanoidRootPart.CFrame)
                    NavigationEngine.TweenTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 280)
                end
            end
            FastAttackEngine.Stop() FastAttackEngine.StopBring()
        end)
    else
        FastAttackEngine.Stop() FastAttackEngine.StopBring()
    end
end)

Tabs.BossMat:AddSection("All Materials Auto Farm")
local matDropdown = Tabs.BossMat:AddDropdown("SelectMat", {
    Title = "Select Material",
    Values = { "Bones", "Ectoplasm", "Scrap Metal", "Dragon Scale", "Conjured Cocoa", "Vampire Fang", "Mystic Droplet", "Mini Tusk" },
    Multi = false, Default = 1
})
local selectedMat = "Bones"
matDropdown:OnChanged(function(v) selectedMat = v cfg.SelectedMaterial = v ConfigManager.Save() end)

local AutoMatToggle = Tabs.BossMat:AddToggle("AutoMaterial", { Title = "Auto Farm Selected Material Mobs", Default = cfg.AutoMaterial })
AutoMatToggle:OnChanged(function(val)
    cfg.AutoMaterial = val ConfigManager.Save()
    if val then
        FastAttackEngine.Start()
        task.spawn(function()
            while cfg.AutoMaterial do
                task.wait(0.5)
                local info = MaterialData[selectedMat]
                if info then
                    local enemies = Workspace:FindFirstChild("Enemies")
                    local mob = enemies and enemies:FindFirstChild(info.MobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        FastAttackEngine.StartBring(info.MobName, mob.HumanoidRootPart.CFrame)
                        NavigationEngine.TweenTo(mob.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 280)
                    else
                        NavigationEngine.TweenTo(info.CFrame, 280)
                    end
                end
            end
            FastAttackEngine.Stop() FastAttackEngine.StopBring()
        end)
    else
        FastAttackEngine.Stop() FastAttackEngine.StopBring()
    end
end)

-- TAB 3: SWORDS & MYTHICS
Tabs.Swords:AddSection("Mythic Swords & Item Unlocks")
Tabs.Swords:AddButton({ Title = "Check Dealer & Buy Legendary Swords (TTK)", Callback = function()
    RemotesEngine.Invoke("ValuableCheck")
    for _, s in ipairs({"Shisui", "Wando", "Saddi"}) do RemotesEngine.Invoke("BuyItem", s) end
end })
Tabs.Swords:AddButton({ Title = "Start Auto CDK Puzzles (Tushita & Yama)", Callback = function()
    local torchPositions = { CFrame.new(-11690, 335, -9460), CFrame.new(-12180, 335, -10600), CFrame.new(-12750, 420, -9850), CFrame.new(-13550, 470, -6900), CFrame.new(-13200, 390, -9800) }
    for _, cf in ipairs(torchPositions) do NavigationEngine.TweenTo(cf, 280) task.wait(2) end
end })
Tabs.Swords:AddButton({ Title = "Auto Soul Guitar Puzzle", Callback = function()
    NavigationEngine.TweenTo(CFrame.new(-9480, 140, 5540), 280, function()
        RemotesEngine.Invoke("SoulGuitar", "Pray") RemotesEngine.Invoke("SoulGuitar", "FloorPattern") RemotesEngine.Invoke("SoulGuitar", "ChemicalCode") RemotesEngine.Invoke("SoulGuitar", "Craft")
    end)
end })

-- TAB 4: FRUITS & INVENTORY
Tabs.Fruits:AddSection("Fruit Gacha & Store")
Tabs.Fruits:AddButton({ Title = "Buy Random Fruit (Zioles Cousin)", Callback = function()
    local res = RemotesEngine.Invoke("Cousin", "Buy")
    Fluent:Notify({ Title = "Fruit Gacha", Content = "Result: " .. tostring(res), Duration = 5 })
end })
Tabs.Fruits:AddButton({ Title = "Store All Fruits to Inventory", Callback = function()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool:GetAttribute("ToolTip") == "Blox Fruit") then RemotesEngine.Invoke("StoreFruit", tool.Name, tool) end
    end
    Fluent:Notify({ Title = "Inventory", Content = "Stored all fruits!", Duration = 4 })
end })

local GrabberToggle = Tabs.Fruits:AddToggle("AutoFruitGrab", { Title = "Auto Fruit Grabber (Teleport & Pick)", Default = cfg.AutoGrabFruit })
GrabberToggle:OnChanged(function(val)
    cfg.AutoGrabFruit = val ConfigManager.Save()
    if val then
        task.spawn(function()
            while cfg.AutoGrabFruit do
                task.wait(1)
                for _, item in ipairs(Workspace:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Handle") then
                        NavigationEngine.TweenTo(item.Handle.CFrame, 280, function()
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item.Handle, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item.Handle, 1)
                        end)
                    end
                end
            end
        end)
    end
end)

-- TAB 5: SEA EVENTS & KITSUNE ISLAND
Tabs.Sea:AddSection("Sea Beasts, Leviathan & Kitsune Shrine")
local SBToggle = Tabs.Sea:AddToggle("AutoSeaBeast", { Title = "Auto Sea Beast / Kraken Farm", Default = cfg.AutoSeaBeast })
SBToggle:OnChanged(function(val)
    cfg.AutoSeaBeast = val ConfigManager.Save()
    if val then
        FastAttackEngine.Start()
        task.spawn(function()
            while cfg.AutoSeaBeast do
                task.wait(1)
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name:find("SeaBeast") or obj.Name:find("Kraken") then
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                        if hrp then NavigationEngine.TweenTo(hrp.CFrame * CFrame.new(0, 30, 0), 280) end
                    end
                end
            end
            FastAttackEngine.Stop()
        end)
    else
        FastAttackEngine.Stop()
    end
end)

Tabs.Sea:AddButton({ Title = "Run Mirage Moon Gear Puzzle", Callback = function()
    local mirage = Workspace:FindFirstChild("Mirage Island") or Workspace:FindFirstChild("MirageIsland")
    if mirage then
        NavigationEngine.TweenTo(CFrame.new(-5500, 450, -11000), 280, function()
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, Workspace.CurrentCamera.CFrame.Position + Vector3.new(0, 1000, 0))
            pcall(function() RemotesEngine.Invoke("TempleClock", "AlignMoon") end)
        end)
    end
end })

Tabs.Sea:AddButton({ Title = "Kitsune Shrine Offer Azure Wisps", Callback = function()
    local res = RemotesEngine.Invoke("KitsuneShrine", "Offer")
    Fluent:Notify({ Title = "Kitsune Shrine", Content = "Offered Azure Wisps! Result: " .. tostring(res), Duration = 5 })
end })

-- TAB 6: RACE V1 - V4
Tabs.Race:AddSection("Race Awakening")
Tabs.Race:AddButton({ Title = "Auto Collect Red & Blue Flowers (Race V2)", Callback = function()
    for _, fName in ipairs({"Flower1", "Flower2"}) do
        local flower = Workspace:FindFirstChild(fName)
        if flower and flower:IsA("BasePart") then
            NavigationEngine.TweenTo(flower.CFrame, 280, function()
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, flower, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, flower, 1)
            end)
        end
    end
end })
Tabs.Race:AddButton({ Title = "Run Race V4 Temple Entry & Lever Pull", Callback = function()
    NavigationEngine.TweenTo(CFrame.new(2295, 443, -7160), 280, function()
        RemotesEngine.Invoke("TempleClock", "Check") RemotesEngine.Invoke("TempleClock", "Lever")
        NavigationEngine.TweenTo(CFrame.new(2850, 14890, -40), 280) RemotesEngine.Invoke("UpgradeRaceV4")
    end)
end })

-- TAB 7: RAIDS
Tabs.Raids:AddSection("Raids Automation")
Tabs.Raids:AddButton({ Title = "Buy Selected Microchip", Callback = function() RemotesEngine.Invoke("RaidsNpc", "Select", "Dough") end })

-- TAB 8: PVP & BOUNTY
Tabs.PVP:AddSection("PvP & Hitbox Options")
local HitboxToggle = Tabs.PVP:AddToggle("HitboxExtender", { Title = "Hitbox Extender (Expand Head/HRP)", Default = cfg.HitboxExtender })
HitboxToggle:OnChanged(function(v)
    cfg.HitboxExtender = v ConfigManager.Save()
    if v then
        RunService:BindToRenderStep("MX_Hitbox", 1, function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(16, 16, 16)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                end
            end
        end)
    else pcall(function() RunService:UnbindFromRenderStep("MX_Hitbox") end) end
end)

-- TAB 9: TELEPORTS
Tabs.Teleports:AddSection("Sea World Travel")
Tabs.Teleports:AddButton({ Title = "Travel to Sea 1", Callback = function() RemotesEngine.Invoke("TravelMain") end })
Tabs.Teleports:AddButton({ Title = "Travel to Sea 2", Callback = function() RemotesEngine.Invoke("TravelDressrosa") end })
Tabs.Teleports:AddButton({ Title = "Travel to Sea 3", Callback = function() RemotesEngine.Invoke("TravelZ") end })

-- TAB 10: SETTINGS
Tabs.Settings:AddSection("Performance & Water Walk")
local AntiAFKToggle = Tabs.Settings:AddToggle("AntiAFK", { Title = "Anti-AFK Disconnect Preventer", Default = cfg.AntiAFK })
AntiAFKToggle:OnChanged(function(val) cfg.AntiAFK = val ConfigManager.Save() Performance.SetAntiAFK(val) end)

local FPSBoosterToggle = Tabs.Settings:AddToggle("FPSBooster", { Title = "FPS Booster & Lag Reduction", Default = cfg.FPSBooster })
FPSBoosterToggle:OnChanged(function(val) cfg.FPSBooster = val ConfigManager.Save() Performance.SetFPSBooster(val) end)

local WhiteScreenToggle = Tabs.Settings:AddToggle("WhiteScreen", { Title = "Overnight GPU Saver Mode (3D Rendering Off)", Default = cfg.WhiteScreen })
WhiteScreenToggle:OnChanged(function(val) cfg.WhiteScreen = val ConfigManager.Save() Performance.SetWhiteScreen(val) end)

local WaterWalkToggle = Tabs.Settings:AddToggle("WaterWalk", { Title = "Water Walk (المشي فوق الماء)", Default = cfg.WaterWalk })
WaterWalkToggle:OnChanged(function(val) cfg.WaterWalk = val WaterWalkEngine.Enabled = val ConfigManager.Save() end)

Window:SelectTab(1)
Fluent:Notify({ Title = "MX Hub v3.1 Loaded", Content = "Floating Toggle Icon, Water Walk, & Altitude Flight Control Active!", Duration = 6 })

print("[MX Hub v3.1] Updated with Floating Toggle Icon, Water Walk, & Flight Altitude Manager!")
