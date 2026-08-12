--[[
    MX Hub - Safe Fast Teleport / Tween Engine
    Handles high-speed CFrame tweening with automated noclip, safe speed scaling,
    and anti-cheat bypass mechanisms.
--]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Navigation = {}
Navigation.Speed = 300 -- Default safe speed for Blox Fruits bypass
Navigation.IsTweening = false
Navigation.CurrentTween = nil

local NoclipConnection = nil

--- Enable or disable character noclip
function Navigation.SetNoclip(state)
    if state then
        if not NoclipConnection then
            NoclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide then
                            child.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
    end
end

--- Stop active tween
function Navigation.Stop()
    if Navigation.CurrentTween then
        Navigation.CurrentTween:Cancel()
        Navigation.CurrentTween = nil
    end
    Navigation.IsTweening = false
    Navigation.SetNoclip(false)
end

--- Fast Safe Tween to target CFrame
--- @param targetCFrame CFrame Target location
--- @param customSpeed number|nil Speed in studs/sec
--- @param onComplete function|nil Callback on reach
function Navigation.TweenTo(targetCFrame, customSpeed, onComplete)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid or humanoid.Health <= 0 then return end

    local speed = customSpeed or Navigation.Speed
    local distance = (hrp.Position - targetCFrame.Position).Magnitude

    -- Instant teleport if extremely close
    if distance < 10 then
        hrp.CFrame = targetCFrame
        if onComplete then onComplete() end
        return
    end

    Navigation.Stop()
    Navigation.IsTweening = true
    Navigation.SetNoclip(true)

    local timeToTravel = distance / speed
    local tweenInfo = TweenInfo.new(
        timeToTravel,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    -- Temporary disable seat / ragdoll bugs
    humanoid.Sit = false

    local tween = TweenService:Create(hrp, tweenInfo, { CFrame = targetCFrame })
    Navigation.CurrentTween = tween

    local completedConn
    completedConn = tween.Completed:Connect(function(status)
        Navigation.IsTweening = false
        Navigation.SetNoclip(false)
        if completedConn then completedConn:Disconnect() end
        if status == Enum.PlaybackState.Completed and onComplete then
            onComplete()
        end
    end)

    tween:Play()
    return tween
end

--- Fast Teleport directly to a model / NPC / Mob
function Navigation.TweenToModel(model, offset, customSpeed, onComplete)
    if not model then return end
    local primaryPart = model:IsA("BasePart") and model or (model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart"))
    if primaryPart then
        local targetCF = primaryPart.CFrame
        if offset then
            targetCF = targetCF * offset
        end
        return Navigation.TweenTo(targetCF, customSpeed, onComplete)
    end
end

return Navigation
