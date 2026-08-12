--[[
    MX Hub - Module 7: PvP & Bounty Hunting Module
    Handles Skill Aimbot, Silent Aim, Hitbox Extender, Auto Bounty Farm target tracking,
    skill combos, and Safe Health Auto Teleport.
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Tween = require(script.Parent.Parent.utils.tween)
local FastAttack = require(script.Parent.Parent.utils.fast_attack)

local PVP = {}

PVP.Aimbot = false
PVP.SilentAim = false
PVP.HitboxExtender = false
PVP.HitboxSize = 15
PVP.AutoBounty = false
PVP.SelectedTargetPlayer = nil
PVP.SafeHealthRun = false
PVP.SafeHealthPercent = 25

local HitboxConnection = nil
local SafeHealthConnection = nil

--- Expand Enemy Player Hitboxes
function PVP.SetHitboxExtender(state)
    PVP.HitboxExtender = state
    if state then
        if not HitboxConnection then
            HitboxConnection = RunService.RenderStepped:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(PVP.HitboxSize, PVP.HitboxSize, PVP.HitboxSize)
                            hrp.Transparency = 0.7
                            hrp.BrickColor = BrickColor.new("Cyan")
                            hrp.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if HitboxConnection then
            HitboxConnection:Disconnect()
            HitboxConnection = nil
        end
    end
end

--- Auto Teleport Away to Safe Zone if Health drops below threshold
function PVP.SetSafeHealthRun(state)
    PVP.SafeHealthRun = state
    if state then
        if not SafeHealthConnection then
            SafeHealthConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if hum and hrp and hum.Health > 0 then
                    local healthPct = (hum.Health / hum.MaxHealth) * 100
                    if healthPct <= PVP.SafeHealthPercent then
                        print("[MX Hub PVP] Low Health Warning (" .. math.floor(healthPct) .. "%). Escaping to Safe Sky Area!")
                        hrp.CFrame = hrp.CFrame * CFrame.new(0, 1500, 0)
                        task.wait(5)
                    end
                end
            end)
        end
    else
        if SafeHealthConnection then
            SafeHealthConnection:Disconnect()
            SafeHealthConnection = nil
        end
    end
end

--- Start Auto Bounty Hunting Target Execution
function PVP.StartAutoBountyTarget(targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if not targetPlayer then
        print("[MX Hub PVP] Target player not found in server!")
        return
    end

    PVP.AutoBounty = true
    task.spawn(function()
        FastAttack.Start()

        while PVP.AutoBounty and targetPlayer and targetPlayer.Character do
            task.wait(0.1)
            local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

            if targetHrp and targetHum and targetHum.Health > 0 then
                -- Tween to Target Player position with 5 stud offset
                Tween.TweenTo(targetHrp.CFrame * CFrame.new(0, 3, -4), 350)
            else
                print("[MX Hub PVP] Target defeated or lost!")
                break
            end
        end

        FastAttack.Stop()
    end)
end

function PVP.StopAutoBounty()
    PVP.AutoBounty = false
end

return PVP
