--[[
    MX Hub - ESP & Visuals Engine
    Provides high-performance rendering for Player ESP, Fruit ESP, Chest ESP, Flower ESP,
    Boss ESP, Sea Events ESP, and Mirage Island Gear ESP.
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ESP = {}
ESP.Enabled = false
ESP.Players = false
ESP.Fruits = false
ESP.Chests = false
ESP.Flowers = false
ESP.Bosses = false
ESP.SeaEvents = false
ESP.Mirage = false

ESP.ColorPalette = {
    Player = Color3.fromRGB(0, 230, 255),
    Fruit = Color3.fromRGB(255, 85, 255),
    Chest = Color3.fromRGB(255, 215, 0),
    FlowerRed = Color3.fromRGB(255, 50, 50),
    FlowerBlue = Color3.fromRGB(50, 150, 255),
    Boss = Color3.fromRGB(255, 50, 90),
    SeaEvent = Color3.fromRGB(50, 255, 150),
    MirageGear = Color3.fromRGB(200, 100, 255)
}

local Cache = {}

local function createBillBoard(name, color, parent, offset)
    local bb = Instance.new("BillboardGui")
    bb.Name = "MX_ESP_" .. name
    bb.Adornee = parent
    bb.Size = UDim2.new(0, 150, 0, 40)
    bb.StudsOffset = offset or Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true

    local txt = Instance.new("TextLabel")
    txt.Parent = bb
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = color
    txt.TextStrokeTransparency = 0.2
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.Text = name

    bb.Parent = parent
    return bb
end

local function removeESP(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name:find("MX_ESP_") then
            child:Destroy()
        end
    end
end

--- Render loop for all tracked world objects
local ESPConnection = nil
function ESP.Start()
    if ESPConnection then return end
    ESP.Enabled = true

    ESPConnection = RunService.RenderStepped:Connect(function()
        if not ESP.Enabled then return end

        -- 1. Fruits ESP
        if ESP.Fruits then
            for _, item in ipairs(Workspace:GetChildren()) do
                if item:IsA("Tool") or item.Name:find("Fruit") then
                    local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
                    if handle and not handle:FindFirstChild("MX_ESP_Fruit") then
                        createBillBoard("Fruit: " .. item.Name, ESP.ColorPalette.Fruit, handle)
                    end
                end
            end
        end

        -- 2. Chests ESP
        if ESP.Chests then
            for _, item in ipairs(Workspace:GetChildren()) do
                if item.Name:find("Chest") and item:IsA("BasePart") then
                    if not item:FindFirstChild("MX_ESP_Chest") then
                        createBillBoard("Chest", ESP.ColorPalette.Chest, item)
                    end
                end
            end
        end

        -- 3. Flowers ESP (Race V2)
        if ESP.Flowers then
            for _, flowerName in ipairs({"Flower1", "Flower2"}) do
                local flower = Workspace:FindFirstChild(flowerName)
                if flower and flower:IsA("BasePart") and not flower:FindFirstChild("MX_ESP_Flower") then
                    local color = flowerName == "Flower1" and ESP.ColorPalette.FlowerRed or ESP.ColorPalette.FlowerBlue
                    createBillBoard(flowerName == "Flower1" and "Red Flower" or "Blue Flower", color, flower)
                end
            end
        end

        -- 4. Bosses ESP
        if ESP.Bosses then
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, enemy in ipairs(enemies:GetChildren()) do
                    local hum = enemy:FindFirstChildOfClass("Humanoid")
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.MaxHealth > 10000 and hum.Health > 0 then
                        if not hrp:FindFirstChild("MX_ESP_Boss") then
                            createBillBoard("[BOSS] " .. enemy.Name .. " (" .. math.floor(hum.Health) .. " HP)", ESP.ColorPalette.Boss, hrp)
                        end
                    end
                end
            end
        end

        -- 5. Sea Events ESP (Sea Beast, Leviathan, Ghost Ships)
        if ESP.SeaEvents then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:find("SeaBeast") or obj.Name:find("Leviathan") or obj.Name:find("GhostShip") then
                    local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                    if hrp and not hrp:FindFirstChild("MX_ESP_SeaEvent") then
                        createBillBoard("Sea Event: " .. obj.Name, ESP.ColorPalette.SeaEvent, hrp)
                    end
                end
            end
        end

        -- 6. Mirage Island Gear ESP
        if ESP.Mirage then
            local mirage = Workspace:FindFirstChild("Mirage Island") or Workspace:FindFirstChild("MirageIsland")
            if mirage then
                local gear = mirage:FindFirstChild("AdvancedGear") or mirage:FindFirstChild("Gear")
                if gear and not gear:FindFirstChild("MX_ESP_MirageGear") then
                    createBillBoard("!!! MIRAGE GEAR !!!", ESP.ColorPalette.MirageGear, gear)
                end
            end
        end
    end)
end

function ESP.Stop()
    ESP.Enabled = false
    if ESPConnection then
        ESPConnection:Disconnect()
        ESPConnection = nil
    end
end

return ESP
