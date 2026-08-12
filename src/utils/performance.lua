--[[
    MX Hub - Performance & Anti-AFK Engine
    Handles Anti-AFK timeout prevention, FPS Boosting (texture reduction, particle cleanup, shadow removal),
    and Low Graphics / White Screen rendering optimization mode.
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Performance = {}
Performance.AntiAFKEnabled = false
Performance.FPSBoosterEnabled = false
Performance.WhiteScreenEnabled = false

local AntiAFKConn = nil
local WhiteScreenGui = nil

--- Enable Anti-AFK (Prevents 20-minute idle disconnects)
function Performance.SetAntiAFK(state)
    Performance.AntiAFKEnabled = state
    if state then
        if not AntiAFKConn then
            AntiAFKConn = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
                print("[MX Hub Performance] Anti-AFK trigger executed.")
            end)
            print("[MX Hub Performance] Anti-AFK Engine active.")
        end
    else
        if AntiAFKConn then
            AntiAFKConn:Disconnect()
            AntiAFKConn = nil
            print("[MX Hub Performance] Anti-AFK Engine disabled.")
        end
    end
end

--- Enable FPS Booster (Reduces Lag, disables shadows, removes particles & extra textures)
function Performance.SetFPSBooster(state)
    Performance.FPSBoosterEnabled = state
    if state then
        print("[MX Hub Performance] Applying FPS Booster & Lag Reduction...")
        
        -- Disable shadows & lighting effects
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        pcall(function()
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                end
            end
        end)

        -- Clean textures in workspace
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
                descendant.Enabled = false
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant.Texture = ""
            end
        end

        -- Monitor new spawned particles
        Workspace.DescendantAdded:Connect(function(descendant)
            if Performance.FPSBoosterEnabled then
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
                    descendant.Enabled = false
                end
            end
        end)
    end
end

--- Enable White Screen / Low Graphics Mode (Extreme GPU Saver for overnight farming)
function Performance.SetWhiteScreen(state)
    Performance.WhiteScreenEnabled = state
    local coreGui = game:GetService("CoreGui")

    if state then
        if not WhiteScreenGui then
            WhiteScreenGui = Instance.new("ScreenGui")
            WhiteScreenGui.Name = "MX_WhiteScreen"
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

            local subtxt = Instance.new("TextLabel", frame)
            subtxt.Size = UDim2.new(1, 0, 0, 40)
            subtxt.Position = UDim2.new(0, 0, 0.48, 0)
            subtxt.BackgroundTransparency = 1
            subtxt.TextColor3 = Color3.fromRGB(180, 180, 200)
            subtxt.Font = Enum.Font.Gotham
            subtxt.TextSize = 14
            subtxt.Text = "Rendering graphics bypassed to maximize FPS & save power. Toggle OFF to restore."

            WhiteScreenGui.Parent = coreGui
        end
        WhiteScreenGui.Enabled = true
        RunService:Set3dRenderingEnabled(false)
    else
        if WhiteScreenGui then
            WhiteScreenGui.Enabled = false
        end
        RunService:Set3dRenderingEnabled(true)
    end
end

return Performance
