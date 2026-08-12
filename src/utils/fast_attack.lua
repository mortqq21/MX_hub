--[[
    MX Hub - Fast Attack Engine & Mob Grouping Module
    Optimized combat performance, weapon animation clipping, VirtualUser attack triggers,
    and mob gathering / bring mob system.
--]]

local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FastAttack = {}
FastAttack.Enabled = false
FastAttack.AttackSpeed = 0.05 -- Delay between attack bursts
FastAttack.AttackRadius = 60 -- Max distance to register hits
FastAttack.BringMobs = false
FastAttack.BringRadius = 350
FastAttack.SelectedWeaponType = "Melee" -- Melee, Sword, Gun, Blox Fruit

local AttackConnection = nil
local MobBringConnection = nil

--- Auto equip tool of specific category from Backpack
function FastAttack.EquipWeapon(category)
    local char = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    if not char or not backpack then return end

    -- Check current equipped tool
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool then
        local toolType = currentTool:GetAttribute("ToolTip") or currentTool.ToolTip or ""
        if category == "Melee" and (toolType:find("Melee") or currentTool.Name:find("Combat") or currentTool.Name:find("Style") or currentTool.Name:find("Black Leg") or currentTool.Name:find("Electro") or currentTool.Name:find("Fishman") or currentTool.Name:find("Dragon") or currentTool.Name:find("Superhuman") or currentTool.Name:find("Death Step") or currentTool.Name:find("Sharkman") or currentTool.Name:find("Electric Claw") or currentTool.Name:find("Dragon Talon") or currentTool.Name:find("Godhuman") or currentTool.Name:find("Sanguine Art")) then
            return currentTool
        end
    end

    -- Look in Backpack
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local tName = tool.Name
            local isMatch = false

            if category == "Melee" then
                if tool:GetAttribute("ToolTip") == "Melee" or tName:find("Combat") or tName:find("Style") or tName:find("Black Leg") or tName:find("Electro") or tName:find("Fishman") or tName:find("Dragon") or tName:find("Superhuman") or tName:find("Death Step") or tName:find("Sharkman") or tName:find("Electric Claw") or tName:find("Dragon Talon") or tName:find("Godhuman") or tName:find("Sanguine Art") then
                    isMatch = true
                end
            elseif category == "Sword" then
                if tool:GetAttribute("ToolTip") == "Sword" or tool:FindFirstChild("Sword") or tool:FindFirstChild("Blade") then
                    isMatch = true
                end
            elseif category == "Fruit" or category == "Blox Fruit" then
                if tool:GetAttribute("ToolTip") == "Blox Fruit" or tool:FindFirstChild("Fruit") or tName:find("Fruit") then
                    isMatch = true
                end
            elseif category == "Gun" then
                if tool:GetAttribute("ToolTip") == "Gun" or tool:FindFirstChild("Gun") then
                    isMatch = true
                end
            end

            if isMatch then
                tool.Parent = char
                return tool
            end
        end
    end
end

--- Register fast attack click event
local lastAttack = 0
function FastAttack.PerformClick()
    if tick() - lastAttack < FastAttack.AttackSpeed then return end
    lastAttack = tick()

    -- Bypass standard attack delay using VirtualUser
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    VirtualUser:Button1Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)

    -- Extra Net Attack Trigger for Blox Fruits Replicated Attack Net
    local char = LocalPlayer.Character
    if char then
        local weapon = char:FindFirstChildOfClass("Tool")
        if weapon and weapon:FindFirstChild("RemoteFunction") then
            pcall(function()
                weapon.RemoteFunction:InvokeServer()
            end)
        end
    end
end

--- Start Fast Attack Loop
function FastAttack.Start()
    if AttackConnection then return end
    FastAttack.Enabled = true

    AttackConnection = RunService.RenderStepped:Connect(function()
        if FastAttack.Enabled then
            FastAttack.EquipWeapon(FastAttack.SelectedWeaponType)
            FastAttack.PerformClick()
        end
    end)
end

--- Stop Fast Attack Loop
function FastAttack.Stop()
    FastAttack.Enabled = false
    if AttackConnection then
        AttackConnection:Disconnect()
        AttackConnection = nil
    end
end

--- Bring nearby enemies to a center target CFrame for efficient AOE farming
function FastAttack.StartMobGrouping(targetEnemyName, centerCFrame)
    if MobBringConnection then return end
    FastAttack.BringMobs = true

    MobBringConnection = RunService.Heartbeat:Connect(function()
        if not FastAttack.BringMobs or not centerCFrame then return end
        
        local enemiesFolder = Workspace:FindFirstChild("Enemies")
        if not enemiesFolder then return end

        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") and (not targetEnemyName or enemy.Name == targetEnemyName) then
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                
                if hum and hrp and hum.Health > 0 then
                    local dist = (hrp.Position - centerCFrame.Position).Magnitude
                    if dist <= FastAttack.BringRadius and dist > 5 then
                        -- Disable collisions and pull mob to center
                        for _, p in ipairs(enemy:GetChildren()) do
                            if p:IsA("BasePart") then
                                p.CanCollide = false
                            end
                        end
                        hrp.CFrame = centerCFrame * CFrame.new(0, 0, -3)
                        hrp.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
    end)
end

function FastAttack.StopMobGrouping()
    FastAttack.BringMobs = false
    if MobBringConnection then
        MobBringConnection:Disconnect()
        MobBringConnection = nil
    end
end

return FastAttack
