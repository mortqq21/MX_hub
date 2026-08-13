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
local NavigationEngine = { Speed = 280, IsTweening = false, CurrentTween = nil, LastTargetPosition = Vector3.new(0,0,0) }
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
        if NavigationEngine.CurrentTween then
            NavigationEngine.CurrentTween:Cancel()
            NavigationEngine.IsTweening = false
        end
        hrp.CFrame = targetCF
        if onComplete then onComplete() end
        return
    end

    -- If already tweening smoothly to roughly the same position, don't interrupt!
    if NavigationEngine.IsTweening and (NavigationEngine.LastTargetPosition - targetCF.Position).Magnitude < 10 then
        return
    end

    if NavigationEngine.CurrentTween then NavigationEngine.CurrentTween:Cancel() end
    NavigationEngine.IsTweening = true
    NavigationEngine.LastTargetPosition = targetCF.Position
    NavigationEngine.SetNoclip(true)
    hum.Sit = false

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
            hrp.CFrame = targetCF
            if onComplete then onComplete() end
        end
    end)
    tween:Play()
    return tween
end

-- KILL AURA & FAST ATTACK ENGINE (نظام هالة الضرب والتدمير عن بعد - نفس ريدز)
local FastAttackEngine = { Enabled = false, WeaponType = "Melee", BringMobs = false, BringRadius = 350, AuraRadius = 60 }
local AttackLoopConn, BringLoopConn = nil, nil
local NetNet = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")

function FastAttackEngine.EquipWeapon(category)
    category = category or cfg.FarmWeapon or "Melee"
    local char = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    if not char or not backpack then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local current = char:FindFirstChildOfClass("Tool")

    local slotNum = category:match("Slot%s*(%d+)") or category:match("(%d+)")
    if slotNum then
        slotNum = tonumber(slotNum)
        local allTools = {}
        if current then table.insert(allTools, current) end
        for _, t in ipairs(backpack:GetChildren()) do if t:IsA("Tool") then table.insert(allTools, t) end end

        if allTools[slotNum] then
            local targetTool = allTools[slotNum]
            if current ~= targetTool then hum:EquipTool(targetTool) end
            return targetTool
        end
    end

    if category:find("Current") then
        if current then return current end
        local t = backpack:FindFirstChildOfClass("Tool")
        if t then hum:EquipTool(t) return t end
        return
    end

    local cleanCat = "Melee"
    if category:find("Sword") then cleanCat = "Sword"
    elseif category:find("Blox Fruit") or category:find("Fruit") then cleanCat = "Blox Fruit"
    end

    FastAttackEngine.WeaponType = cleanCat

    if current and current:IsA("Tool") then
        local toolTip = current.ToolTip or ""
        local name = current.Name
        if cleanCat == "Melee" and (toolTip == "Melee" or toolTip == "" or name:find("Style") or name:find("Leg") or name:find("Karate") or name:find("Step") or name:find("Combat") or name:find("Electro") or name:find("Claw") or name:find("Talon") or name:find("Godhuman") or name:find("Sanguine") or name:find("Breath")) then
            return current
        elseif cleanCat == "Sword" and (toolTip == "Sword" or name:find("Katana") or name:find("Blade") or name:find("Sword") or name:find("Saber") or name:find("Yoru") or name:find("Saddi") or name:find("Wando") or name:find("Shisui") or name:find("Pole") or name:find("Trident") or name:find("Scythe") or name:find("Anchor")) then
            return current
        elseif cleanCat == "Blox Fruit" and (toolTip == "Blox Fruit" or name:find("Fruit") or name:find("Kitsune") or name:find("Buddha") or name:find("Leopard") or name:find("Dough") or name:find("Dragon") or name:find("T-Rex") or name:find("Venom") or name:find("Ice") or name:find("Light") or name:find("Magma")) then
            return current
        end
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolTip = tool.ToolTip or ""
            local name = tool.Name
            local isMatch = false
            if cleanCat == "Melee" and (toolTip == "Melee" or toolTip == "" or name:find("Style") or name:find("Leg") or name:find("Karate") or name:find("Step") or name:find("Combat") or name:find("Electro") or name:find("Claw") or name:find("Talon") or name:find("Godhuman") or name:find("Sanguine") or name:find("Breath")) then
                isMatch = true
            elseif cleanCat == "Sword" and (toolTip == "Sword" or name:find("Katana") or name:find("Blade") or name:find("Sword") or name:find("Saber") or name:find("Yoru") or name:find("Saddi") or name:find("Wando") or name:find("Shisui") or name:find("Pole") or name:find("Trident") or name:find("Scythe") or name:find("Anchor")) then
                isMatch = true
            elseif cleanCat == "Blox Fruit" and (toolTip == "Blox Fruit" or name:find("Fruit") or name:find("Kitsune") or name:find("Buddha") or name:find("Leopard") or name:find("Dough") or name:find("Dragon") or name:find("T-Rex") or name:find("Venom") or name:find("Ice") or name:find("Light") or name:find("Magma")) then
                isMatch = true
            end

            if isMatch then
                hum:EquipTool(tool)
                return tool
            end
        end
    end

    if not current then
        local t = backpack:FindFirstChildOfClass("Tool")
        if t then hum:EquipTool(t) return t end
    end
end

-- Redz-Style Kill Aura Distance Damage (تدمير كل الوحوش القريبة في نطاق الهالة تلقائياً)
function FastAttackEngine.PerformAuraAttack()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local currentTool = char:FindFirstChildOfClass("Tool")
    if not currentTool then return end

    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end

    local targets = {}
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob:IsA("Model") then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local mobHRP = mob:FindFirstChild("HumanoidRootPart")
            if hum and mobHRP and hum.Health > 0 then
                local dist = (hrp.Position - mobHRP.Position).Magnitude
                if dist <= FastAttackEngine.AuraRadius then
                    table.insert(targets, mobHRP)
                end
            end
        end
    end

    if #targets > 0 then
        -- Execute Blox Fruits official RegisterAttack remote
        pcall(function()
            local regAttack = NetNet and NetNet:FindFirstChild("RegisterAttack") or ReplicatedStorage:FindFirstChild("RegisterAttack")
            if regAttack then
                regAttack:FireServer(0.01)
            end
        end)

        -- Execute hit registration for all targets inside the aura radius
        pcall(function()
            local regHit = NetNet and NetNet:FindFirstChild("RegisterHit") or ReplicatedStorage:FindFirstChild("RegisterHit")
            if regHit then
                for _, mobHRP in ipairs(targets) do
                    regHit:FireServer(mobHRP, {mobHRP})
                end
            end
        end)

        -- Activate weapon handle touch for instant damage
        local handle = currentTool:FindFirstChild("Handle")
        if handle then
            for _, mobHRP in ipairs(targets) do
                firetouchinterest(handle, mobHRP, 0)
                firetouchinterest(handle, mobHRP, 1)
            end
        end
    end
end

function FastAttackEngine.Start()
    if AttackLoopConn then return end
    FastAttackEngine.Enabled = true
    AttackLoopConn = RunService.RenderStepped:Connect(function()
        if FastAttackEngine.Enabled then
            FastAttackEngine.EquipWeapon(FastAttackEngine.WeaponType)
            FastAttackEngine.PerformAuraAttack()
            task.wait(0.03)
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
-- 3. DATA TABLES & QUEST DATABASE (1 - 2800 COMPLETE ALL SEAS)
-- ============================================================================

-- ===== SEA 1 (Old World) =====
local Sea1Quests = {
    { MinLevel = 1,    MaxLevel = 9,    QuestName = "BanditQuest1",   QuestLevel = 1, MobName = "Bandit",             NPC = "BanditQuest1", MobArea = CFrame.new(1059, 17, 1546),   QuestNPC = CFrame.new(1059, 15, 1547) },
    { MinLevel = 10,   MaxLevel = 14,   QuestName = "BanditQuest1",   QuestLevel = 2, MobName = "Bandit",             NPC = "BanditQuest1", MobArea = CFrame.new(1059, 17, 1546),   QuestNPC = CFrame.new(1059, 15, 1547) },
    { MinLevel = 15,   MaxLevel = 29,   QuestName = "JungleQuest",    QuestLevel = 1, MobName = "Monkey",             NPC = "JungleQuest",  MobArea = CFrame.new(-1602, 37, 153),   QuestNPC = CFrame.new(-1598, 36, 153) },
    { MinLevel = 30,   MaxLevel = 59,   QuestName = "BuggyQuest1",    QuestLevel = 1, MobName = "Pirate",             NPC = "BuggyQuest1",  MobArea = CFrame.new(-1210, 5, 3915),   QuestNPC = CFrame.new(-1140, 4.5, 3858) },
    { MinLevel = 60,   MaxLevel = 74,   QuestName = "DesertQuest",    QuestLevel = 1, MobName = "Desert Bandit",      NPC = "DesertQuest",  MobArea = CFrame.new(890, 7, 4380),     QuestNPC = CFrame.new(894, 6.5, 4390) },
    { MinLevel = 75,   MaxLevel = 89,   QuestName = "DesertQuest",    QuestLevel = 2, MobName = "Desert Officer",     NPC = "DesertQuest",  MobArea = CFrame.new(890, 7, 4380),     QuestNPC = CFrame.new(894, 6.5, 4390) },
    { MinLevel = 90,   MaxLevel = 99,   QuestName = "SnowQuest",      QuestLevel = 1, MobName = "Snow Bandit",        NPC = "SnowQuest",    MobArea = CFrame.new(1280, 87, -1290),  QuestNPC = CFrame.new(1385, 87, -1298) },
    { MinLevel = 100,  MaxLevel = 119,  QuestName = "SnowQuest",      QuestLevel = 2, MobName = "Snowman",            NPC = "SnowQuest",    MobArea = CFrame.new(1280, 87, -1290),  QuestNPC = CFrame.new(1385, 87, -1298) },
    { MinLevel = 120,  MaxLevel = 149,  QuestName = "IceSideQuest",   QuestLevel = 1, MobName = "Chief Petty Officer", NPC = "IceSideQuest", MobArea = CFrame.new(1579, 87, -1796),  QuestNPC = CFrame.new(1579, 87, -1796) },
    { MinLevel = 150,  MaxLevel = 174,  QuestName = "SkyQuest",       QuestLevel = 1, MobName = "Sky Bandit",         NPC = "SkyQuest",     MobArea = CFrame.new(-4850, 717, 4300), QuestNPC = CFrame.new(-4850, 717, 4300) },
    { MinLevel = 175,  MaxLevel = 199,  QuestName = "SkyQuest",       QuestLevel = 2, MobName = "Dark Master",        NPC = "SkyQuest",     MobArea = CFrame.new(-4850, 717, 4300), QuestNPC = CFrame.new(-4850, 717, 4300) },
    { MinLevel = 200,  MaxLevel = 249,  QuestName = "ColosseumQuest", QuestLevel = 1, MobName = "Toga Warrior",       NPC = "ColosseumQuest", MobArea = CFrame.new(-1450, 7, -2908), QuestNPC = CFrame.new(-1450, 7, -2908) },
    { MinLevel = 250,  MaxLevel = 274,  QuestName = "ColosseumQuest", QuestLevel = 2, MobName = "Gladiator",          NPC = "ColosseumQuest", MobArea = CFrame.new(-1450, 7, -2908), QuestNPC = CFrame.new(-1450, 7, -2908) },
    { MinLevel = 275,  MaxLevel = 299,  QuestName = "MagmaQuest",     QuestLevel = 1, MobName = "Military Soldier",   NPC = "MagmaQuest",   MobArea = CFrame.new(-5314, 12, 8506),  QuestNPC = CFrame.new(-5314, 12, 8506) },
    { MinLevel = 300,  MaxLevel = 374,  QuestName = "MagmaQuest",     QuestLevel = 2, MobName = "Military Spy",       NPC = "MagmaQuest",   MobArea = CFrame.new(-5314, 12, 8506),  QuestNPC = CFrame.new(-5314, 12, 8506) },
    { MinLevel = 375,  MaxLevel = 449,  QuestName = "UnderwaterQuest", QuestLevel = 1, MobName = "Fishman Warrior",   NPC = "UnderwaterQuest", MobArea = CFrame.new(61163, 12, 1819), QuestNPC = CFrame.new(61163, 12, 1819) },
    { MinLevel = 450,  MaxLevel = 524,  QuestName = "UnderwaterQuest", QuestLevel = 2, MobName = "Fishman Commando",  NPC = "UnderwaterQuest", MobArea = CFrame.new(61163, 12, 1819), QuestNPC = CFrame.new(61163, 12, 1819) },
    { MinLevel = 525,  MaxLevel = 599,  QuestName = "FountainQuest",   QuestLevel = 1, MobName = "God's Guard",       NPC = "FountainQuest",  MobArea = CFrame.new(-4903, 841, -1911), QuestNPC = CFrame.new(-4903, 841, -1911) },
    { MinLevel = 600,  MaxLevel = 699,  QuestName = "FountainQuest",   QuestLevel = 2, MobName = "Shanda",            NPC = "FountainQuest",  MobArea = CFrame.new(-4903, 841, -1911), QuestNPC = CFrame.new(-4903, 841, -1911) },
}

-- ===== SEA 2 (New World) =====
local Sea2Quests = {
    { MinLevel = 700,  MaxLevel = 774,  QuestName = "Area1Quest",      QuestLevel = 1, MobName = "Raider",              NPC = "Area1Quest",      MobArea = CFrame.new(-425, 73, 1835),   QuestNPC = CFrame.new(-425, 73, 1835) },
    { MinLevel = 775,  MaxLevel = 849,  QuestName = "Area1Quest",      QuestLevel = 2, MobName = "Mercenary",           NPC = "Area1Quest",      MobArea = CFrame.new(-425, 73, 1835),   QuestNPC = CFrame.new(-425, 73, 1835) },
    { MinLevel = 850,  MaxLevel = 924,  QuestName = "Area2Quest",      QuestLevel = 1, MobName = "Swan Pirate",         NPC = "Area2Quest",      MobArea = CFrame.new(636, 73, 918),     QuestNPC = CFrame.new(636, 73, 918) },
    { MinLevel = 925,  MaxLevel = 999,  QuestName = "Area2Quest",      QuestLevel = 2, MobName = "Factory Staff",       NPC = "Area2Quest",      MobArea = CFrame.new(636, 73, 918),     QuestNPC = CFrame.new(636, 73, 918) },
    { MinLevel = 1000, MaxLevel = 1049, QuestName = "HauntedQuest1",   QuestLevel = 1, MobName = "Zombie",              NPC = "HauntedQuest1",   MobArea = CFrame.new(-5150, 80, 4240),  QuestNPC = CFrame.new(-5150, 80, 4240) },
    { MinLevel = 1050, MaxLevel = 1099, QuestName = "HauntedQuest1",   QuestLevel = 2, MobName = "Vampire",             NPC = "HauntedQuest1",   MobArea = CFrame.new(-5150, 80, 4240),  QuestNPC = CFrame.new(-5150, 80, 4240) },
    { MinLevel = 1100, MaxLevel = 1174, QuestName = "SnowMountainQuest", QuestLevel = 1, MobName = "Snow Trooper",      NPC = "SnowMountainQuest", MobArea = CFrame.new(612, 400, -5100), QuestNPC = CFrame.new(612, 400, -5100) },
    { MinLevel = 1175, MaxLevel = 1249, QuestName = "SnowMountainQuest", QuestLevel = 2, MobName = "Arctic Warrior",    NPC = "SnowMountainQuest", MobArea = CFrame.new(612, 400, -5100), QuestNPC = CFrame.new(612, 400, -5100) },
    { MinLevel = 1250, MaxLevel = 1324, QuestName = "IceSideQuest2",    QuestLevel = 1, MobName = "Fishman Raider",     NPC = "IceSideQuest2",    MobArea = CFrame.new(-6050, 15, -4920), QuestNPC = CFrame.new(-6050, 15, -4920) },
    { MinLevel = 1325, MaxLevel = 1374, QuestName = "ForgottenQuest",   QuestLevel = 1, MobName = "Forest Pirate",      NPC = "ForgottenQuest",   MobArea = CFrame.new(-3204, 296, -10372), QuestNPC = CFrame.new(-3204, 296, -10372) },
    { MinLevel = 1375, MaxLevel = 1424, QuestName = "ForgottenQuest",   QuestLevel = 2, MobName = "Mythological Pirate", NPC = "ForgottenQuest", MobArea = CFrame.new(-3204, 296, -10372), QuestNPC = CFrame.new(-3204, 296, -10372) },
    { MinLevel = 1425, MaxLevel = 1499, QuestName = "PiratePortQuest",  QuestLevel = 1, MobName = "Pirate Millionaire",  NPC = "PiratePortQuest", MobArea = CFrame.new(-290, 44, 4536),  QuestNPC = CFrame.new(-290, 44, 4536) },
}

-- ===== SEA 3 (Third Sea) =====
local Sea3Quests = {
    { MinLevel = 1500, MaxLevel = 1574, QuestName = "TikiQuest1",       QuestLevel = 1, MobName = "Isle Outlaw",          NPC = "TikiQuest1",       MobArea = CFrame.new(-16500, 55, 5500), QuestNPC = CFrame.new(-16200, 55, 5450) },
    { MinLevel = 1575, MaxLevel = 1649, QuestName = "TikiQuest1",       QuestLevel = 2, MobName = "Isle Champion",        NPC = "TikiQuest1",       MobArea = CFrame.new(-16500, 55, 5500), QuestNPC = CFrame.new(-16200, 55, 5450) },
    { MinLevel = 1650, MaxLevel = 1724, QuestName = "MansionQuest",     QuestLevel = 1, MobName = "Lab Subordinate",      NPC = "MansionQuest",     MobArea = CFrame.new(-12488, 332, -7577), QuestNPC = CFrame.new(-12488, 332, -7577) },
    { MinLevel = 1725, MaxLevel = 1799, QuestName = "MansionQuest",     QuestLevel = 2, MobName = "Horned Warrior",       NPC = "MansionQuest",     MobArea = CFrame.new(-12488, 332, -7577), QuestNPC = CFrame.new(-12488, 332, -7577) },
    { MinLevel = 1800, MaxLevel = 1874, QuestName = "CartQuest",        QuestLevel = 1, MobName = "Marine Commodore",     NPC = "CartQuest",        MobArea = CFrame.new(-12700, 316, -7672), QuestNPC = CFrame.new(-12700, 316, -7672) },
    { MinLevel = 1875, MaxLevel = 1949, QuestName = "CartQuest",        QuestLevel = 2, MobName = "Marine Rear Admiral",  NPC = "CartQuest",        MobArea = CFrame.new(-12700, 316, -7672), QuestNPC = CFrame.new(-12700, 316, -7672) },
    { MinLevel = 1950, MaxLevel = 2024, QuestName = "CastleQuest",      QuestLevel = 1, MobName = "Jungle Pirate",        NPC = "CastleQuest",      MobArea = CFrame.new(-10502, 331, -8823), QuestNPC = CFrame.new(-10502, 331, -8823) },
    { MinLevel = 2025, MaxLevel = 2074, QuestName = "CastleQuest",      QuestLevel = 2, MobName = "Musketeer Pirate",     NPC = "CastleQuest",      MobArea = CFrame.new(-10502, 331, -8823), QuestNPC = CFrame.new(-10502, 331, -8823) },
    { MinLevel = 2075, MaxLevel = 2174, QuestName = "MiniSkyQuest",     QuestLevel = 1, MobName = "Reborn Skeleton",      NPC = "MiniSkyQuest",     MobArea = CFrame.new(-9500, 140, 5600), QuestNPC = CFrame.new(-9500, 140, 5600) },
    { MinLevel = 2175, MaxLevel = 2274, QuestName = "MiniSkyQuest",     QuestLevel = 2, MobName = "Living Zombie",        NPC = "MiniSkyQuest",     MobArea = CFrame.new(-9500, 140, 5600), QuestNPC = CFrame.new(-9500, 140, 5600) },
    { MinLevel = 2275, MaxLevel = 2349, QuestName = "ShipQuest1",       QuestLevel = 1, MobName = "Ship Deckhand",        NPC = "ShipQuest1",       MobArea = CFrame.new(1190, 125, 33000), QuestNPC = CFrame.new(1190, 125, 33000) },
    { MinLevel = 2350, MaxLevel = 2449, QuestName = "ShipQuest2",       QuestLevel = 1, MobName = "Ship Engineer",        NPC = "ShipQuest2",       MobArea = CFrame.new(1190, 125, 33200), QuestNPC = CFrame.new(1190, 125, 33200) },
    { MinLevel = 2450, MaxLevel = 2549, QuestName = "ShipQuest3",       QuestLevel = 1, MobName = "Ship Steward",         NPC = "ShipQuest3",       MobArea = CFrame.new(1190, 125, 33400), QuestNPC = CFrame.new(1190, 125, 33400) },
    { MinLevel = 2550, MaxLevel = 2649, QuestName = "ShipQuest4",       QuestLevel = 1, MobName = "Ship Officer",         NPC = "ShipQuest4",       MobArea = CFrame.new(1190, 125, 33600), QuestNPC = CFrame.new(1190, 125, 33600) },
    { MinLevel = 2650, MaxLevel = 2800, QuestName = "ShipQuest5",       QuestLevel = 1, MobName = "Ship Captain",         NPC = "ShipQuest5",       MobArea = CFrame.new(1190, 125, 33800), QuestNPC = CFrame.new(1190, 125, 33800) },
}

-- Merge all quests into one database
local QuestDatabase = {}
for _, q in ipairs(Sea1Quests) do table.insert(QuestDatabase, q) end
for _, q in ipairs(Sea2Quests) do table.insert(QuestDatabase, q) end
for _, q in ipairs(Sea3Quests) do table.insert(QuestDatabase, q) end

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

-- Smart quest finder: matches by level then selects best quest
local function getQuestData(level)
    local best = nil
    for _, q in ipairs(QuestDatabase) do
        if level >= q.MinLevel and level <= q.MaxLevel then
            best = q
            break
        end
    end
    return best or QuestDatabase[#QuestDatabase]
end

-- Check which sea the player should be in based on level
local function getRequiredSea(level)
    if level < 700 then return 1
    elseif level < 1500 then return 2
    else return 3 end
end

-- Detect current sea from PlaceId
local function getCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1
    elseif placeId == 4442272183 then return 2
    elseif placeId == 7449423635 then return 3
    else return 1 end
end

-- ============================================================================
-- 4. FLOATING UI TOGGLE BUTTON (أيقونة عائمة لفتح وإغلاق القائمة)
-- ============================================================================
local MX_HubVisible = true

local function createFloatingToggle(FluentWindow)
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local existing = coreGui:FindFirstChild("MX_ToggleGui")
        if existing then existing:Destroy() end

        local sg = Instance.new("ScreenGui")
        sg.Name = "MX_ToggleGui"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 9999999
        sg.Parent = coreGui

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 50, 0, 50)
        btn.Position = UDim2.new(0, 15, 0.45, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Text = "MX"
        btn.Active = true
        btn.Draggable = true
        btn.ZIndex = 9999999
        btn.Parent = sg

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 14)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255, 50, 50)
        stroke.Thickness = 2.5

        -- Glow effect animation
        task.spawn(function()
            while btn and btn.Parent do
                for i = 0, 1, 0.02 do
                    if not btn or not btn.Parent then break end
                    stroke.Transparency = i * 0.5
                    task.wait(0.03)
                end
                for i = 1, 0, -0.02 do
                    if not btn or not btn.Parent then break end
                    stroke.Transparency = i * 0.5
                    task.wait(0.03)
                end
            end
        end)

        btn.MouseButton1Click:Connect(function()
            MX_HubVisible = not MX_HubVisible

            pcall(function()
                if FluentWindow then
                    if FluentWindow.Root then
                        FluentWindow.Root.Enabled = MX_HubVisible
                    end
                end
            end)

            -- Also fallback to searching all ScreenGuis in CoreGui & gethui
            pcall(function()
                for _, g in ipairs(coreGui:GetChildren()) do
                    if g:IsA("ScreenGui") and g.Name ~= "MX_ToggleGui" and g.Name ~= "MX_KeySystemGui" and g.Name ~= "MX_WhiteScreen" then
                        if g:FindFirstChild("CanvasGroup") or g:FindFirstChild("Frame") or g:FindFirstChild("Main") or g.Name:find("Fluent") then
                            g.Enabled = MX_HubVisible
                        end
                    end
                end
            end)

            pcall(function()
                if gethui then
                    for _, g in ipairs(gethui():GetChildren()) do
                        if g:IsA("ScreenGui") and g.Name ~= "MX_ToggleGui" then
                            g.Enabled = MX_HubVisible
                        end
                    end
                end
            end)

            if MX_HubVisible then
                btn.Text = "MX"
                btn.TextColor3 = Color3.fromRGB(255, 50, 50)
            else
                btn.Text = "MX"
                btn.TextColor3 = Color3.fromRGB(150, 30, 30)
            end
        end)
    end)
end

-- ============================================================================
-- KEY SYSTEM ENGINE (نظام تفعيل المفتاح مع حفظ المفتاح تلقائياً)
-- ============================================================================
local KeySystem = {
    ValidKeys = {
        ["MX-MORTQQ21-VIP"] = true,
        ["MX-HUB-FREE-2026"] = true,
        ["MX-PERMANENT-2800"] = true,
        ["mortqq21"] = true
    },
    SavedKeyFile = "MX_Hub/saved_key.txt"
}

function KeySystem.CheckSavedKey()
    pcall(function()
        if isfile and readfile and isfile(KeySystem.SavedKeyFile) then
            local saved = readfile(KeySystem.SavedKeyFile):gsub("%s+", "")
            if KeySystem.ValidKeys[saved] then
                return true
            end
        end
    end)
    return false
end

function KeySystem.SaveKey(key)
    pcall(function()
        if writefile and makefolder then
            if isfolder and not isfolder("MX_Hub") then makefolder("MX_Hub") end
            writefile(KeySystem.SavedKeyFile, key)
        end
    end)
end

function KeySystem.PromptKey(onSuccess)
    if KeySystem.CheckSavedKey() then
        onSuccess()
        return
    end

    local coreGui = game:GetService("CoreGui")
    local existing = coreGui:FindFirstChild("MX_KeySystemGui")
    if existing then existing:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "MX_KeySystemGui"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 9999999
    sg.Parent = coreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 260)
    frame.Position = UDim2.new(0.5, -210, 0.5, -130)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = sg

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 50, 50)
    stroke.Thickness = 2

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "🔑 MX HUB | Key Verification System"
    title.TextColor3 = Color3.fromRGB(255, 60, 60)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 30)
    subtitle.Position = UDim2.new(0, 20, 0, 45)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Please enter your permanent key to unlock MX Hub"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 190)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 13
    subtitle.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -40, 0, 45)
    textBox.Position = UDim2.new(0, 20, 0, 90)
    textBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Enter Key Here..."
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 14
    textBox.Text = ""
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    local tbCorner = Instance.new("UICorner", textBox)
    tbCorner.CornerRadius = UDim.new(0, 10)

    local tbStroke = Instance.new("UIStroke", textBox)
    tbStroke.Color = Color3.fromRGB(60, 60, 80)
    tbStroke.Thickness = 1

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 140)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.Parent = frame

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.46, 0, 0, 42)
    verifyBtn.Position = UDim2.new(0, 20, 0, 185)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 14
    verifyBtn.Text = "Verify Key"
    verifyBtn.Parent = frame

    local vCorner = Instance.new("UICorner", verifyBtn)
    vCorner.CornerRadius = UDim.new(0, 10)

    local getBtn = Instance.new("TextButton")
    getBtn.Size = UDim2.new(0.46, 0, 0, 42)
    getBtn.Position = UDim2.new(0.54, 0, 0, 185)
    getBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    getBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
    getBtn.Font = Enum.Font.GothamBold
    getBtn.TextSize = 14
    getBtn.Text = "Get Key"
    getBtn.Parent = frame

    local gCorner = Instance.new("UICorner", getBtn)
    gCorner.CornerRadius = UDim.new(0, 10)

    verifyBtn.MouseButton1Click:Connect(function()
        local input = textBox.Text:gsub("%s+", "")
        if KeySystem.ValidKeys[input] then
            statusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            statusLabel.Text = "✓ Key Verified Successfully! Loading..."
            KeySystem.SaveKey(input)
            task.wait(0.8)
            sg:Destroy()
            onSuccess()
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            statusLabel.Text = "❌ Invalid Key! Check your key and try again."
        end
    end)

    getBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("MX-MORTQQ21-VIP")
                statusLabel.TextColor3 = Color3.fromRGB(80, 220, 255)
                statusLabel.Text = "📋 Key copied to clipboard: MX-MORTQQ21-VIP"
            else
                textBox.Text = "MX-MORTQQ21-VIP"
                statusLabel.TextColor3 = Color3.fromRGB(80, 220, 255)
                statusLabel.Text = "Permanent Key filled in textbox!"
            end
        end)
    end)
end

-- ============================================================================
-- 5. FLUENT UI & MODULE BINDINGS
-- ============================================================================
local function initializeMXHub()
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

local WeaponDropdown = Tabs.Main:AddDropdown("SelectFarmWeapon", {
    Title = "Select Farm Weapon (اختر سلاح التلفيل / الخانة)",
    Values = {
        "Melee (أسلوب القتال الحالي)",
        "Sword (السيف الحالي)",
        "Blox Fruit (الفاكهة الحالية)",
        "Slot 1 (الخانة 1 في الشريط)",
        "Slot 2 (الخانة 2 في الشريط)",
        "Slot 3 (الخانة 3 في الشريط)",
        "Slot 4 (الخانة 4 في الشريط)",
        "Slot 5 (الخانة 5 في الشريط)",
        "Current Tool (السلاح في يدك)"
    },
    Multi = false,
    Default = 1
})
WeaponDropdown:OnChanged(function(v)
    cfg.FarmWeapon = v
    FastAttackEngine.WeaponType = v
    ConfigManager.Save()
end)

local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarmLevel", { Title = "Auto Farm Level (1 - 2800 Max)", Default = cfg.AutoFarmLevel })

local lastQuestAttempt = 0

local function hasActiveQuest()
    local active = false
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            local qFrame = mainGui:FindFirstChild("Quest")
            if qFrame then
                if qFrame.Visible then active = true end
                local container = qFrame:FindFirstChild("Container")
                if container and container.Visible then active = true end
                for _, child in ipairs(qFrame:GetDescendants()) do
                    if child:IsA("TextLabel") and child.Text and child.Text ~= "" then
                        local txt = child.Text
                        if txt:find("Defeat") or txt:find("Kill") or txt:find("/") or txt:find("Quest") then
                            active = true
                            break
                        end
                    end
                end
            end
        end
    end)
    return active
end

AutoFarmToggle:OnChanged(function(val)
    cfg.AutoFarmLevel = val ConfigManager.Save()
    if val then
        FastAttackEngine.Start()
        task.spawn(function()
            while cfg.AutoFarmLevel do
                task.wait(0.15)

                local char = LocalPlayer.Character
                if not char then task.wait(1) continue end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then task.wait(1) continue end

                local lvl = LocalPlayer.Data.Level.Value
                local qData = getQuestData(lvl)

                -- Check if player is in the correct Sea
                local requiredSea = getRequiredSea(lvl)
                local currentSea = getCurrentSea()
                if requiredSea ~= currentSea then
                    Fluent:Notify({ Title = "Sea Travel Required", Content = "Level " .. lvl .. " requires Sea " .. requiredSea .. ". You are in Sea " .. currentSea .. ". Traveling...", Duration = 8 })
                    pcall(function()
                        local seaIds = { [1] = 2753915549, [2] = 4442272183, [3] = 7449423635 }
                        game:GetService("TeleportService"):Teleport(seaIds[requiredSea], LocalPlayer)
                    end)
                    task.wait(10)
                    continue
                end

                if not hasActiveQuest() then
                    -- ===== STEP 1: Go to Quest NPC & Accept Quest (No Spam) =====
                    FastAttackEngine.StopBring()

                    local distToNPC = (hrp.Position - qData.QuestNPC.Position).Magnitude
                    if distToNPC > 15 then
                        -- Fly towards the Quest NPC safely
                        NavigationEngine.TweenTo(qData.QuestNPC, 280)
                    else
                        -- We are at the NPC, stop tween and try accepting quest ONCE every 2.5 seconds
                        if (tick() - lastQuestAttempt) > 2.5 then
                            lastQuestAttempt = tick()
                            hrp.CFrame = qData.QuestNPC
                            task.wait(0.2)
                            -- Send real Blox Fruits quest start remote
                            RemotesEngine.Invoke("StartQuest", qData.QuestName, qData.QuestLevel)
                            task.wait(0.5)
                        end
                    end
                else
                    -- ===== STEP 2: Quest is active, find and kill mobs =====
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if not enemies then task.wait(0.5) continue end

                    -- Find the CLOSEST ALIVE mob matching quest target
                    local closestMob = nil
                    local closestDist = math.huge

                    for _, mob in ipairs(enemies:GetChildren()) do
                        if mob:IsA("Model") and mob.Name == qData.MobName then
                            local mobHum = mob:FindFirstChildOfClass("Humanoid")
                            local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                            if mobHum and mobHRP and mobHum.Health > 0 then
                                local dist = (hrp.Position - mobHRP.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestMob = mob
                                end
                            end
                        end
                    end

                    if closestMob and closestMob:FindFirstChild("HumanoidRootPart") then
                        local mobHRP = closestMob.HumanoidRootPart

                        -- Teleport above the mob and auto-attack
                        local attackPos = mobHRP.CFrame * CFrame.new(0, 8, 0)
                        hrp.CFrame = attackPos

                        -- Bring nearby mobs to player position
                        FastAttackEngine.StartBring(qData.MobName, hrp.CFrame)
                    else
                        -- No alive mobs found, go to mob spawn area and wait
                        FastAttackEngine.StopBring()
                        NavigationEngine.TweenTo(qData.MobArea * CFrame.new(0, 10, 0), 280)
                        task.wait(1.5)
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
end

-- Launch Key Verification System
KeySystem.PromptKey(initializeMXHub)
