--[[
    MX Hub - Module 1: Main / Auto Farm Engine
    Handles Auto Level (1-2550), Quest auto-accept, Mob Grouping, Fast Attack,
    Auto Mastery, Auto Bosses, Auto Bones/Ectoplasm, and Auto Stats Allocator.
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)
local FastAttack = require(script.Parent.Parent.utils.fast_attack)
local Quests = require(script.Parent.Parent.data.quests)

local MainFarm = {}
MainFarm.AutoFarmLevel = false
MainFarm.AutoMastery = false
MainFarm.MasteryWeapon = "Sword"
MainFarm.MasteryHPPercent = 25
MainFarm.AutoBoss = false
MainFarm.SelectedBoss = "Rip Indra"
MainFarm.AutoBones = false
MainFarm.AutoStats = false
MainFarm.StatsRatio = { Melee = 1, Defense = 1, Sword = 1, Gun = 0, Fruit = 0 }

local FarmConnection = nil
local StatsConnection = nil

--- Auto Stats Allocator background loop
function MainFarm.StartAutoStats()
    if StatsConnection then return end
    StatsConnection = task.spawn(function()
        while task.wait(2) do
            if MainFarm.AutoStats then
                for stat, ratio in pairs(MainFarm.StatsRatio) do
                    if ratio > 0 then
                        local statRemoteName = stat == "Fruit" and "Demon Fruit" or stat
                        Remotes.AddPoint(statRemoteName, ratio * 3)
                    end
                end
            end
        end
    end)
end

--- Get closest alive target mob matching name
local function getClosestMob(mobName)
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    local closest, closestDist = nil, math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, mob in ipairs(enemiesFolder:GetChildren()) do
        if mob:IsA("Model") and mob.Name == mobName then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local mobHrp = mob:FindFirstChild("HumanoidRootPart")
            if hum and mobHrp and hum.Health > 0 then
                local dist = (mobHrp.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = mob
                end
            end
        end
    end
    return closest
end

--- Start Main Auto Level Farming Loop
function MainFarm.StartAutoFarm()
    if MainFarm.AutoFarmLevel then return end
    MainFarm.AutoFarmLevel = true

    task.spawn(function()
        FastAttack.Start()

        while MainFarm.AutoFarmLevel do
            task.wait(0.1)
            local char = LocalPlayer.Character
            local level = LocalPlayer.Data.Level.Value
            local questData = Quests.GetQuestForLevel(level)

            if questData and char and char:FindFirstChild("HumanoidRootPart") then
                -- Check if active quest matches requirement
                local activeQuest = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                local hasQuest = activeQuest and activeQuest.Visible

                if not hasQuest then
                    -- Tween to Quest NPC & Accept Quest
                    Tween.TweenTo(questData.QuestNPC, 300, function()
                        Remotes.StartQuest(questData.QuestName, questData.QuestLevel)
                    end)
                else
                    -- Find target mob & farm
                    local targetMob = getClosestMob(questData.MobName)
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        FastAttack.StartMobGrouping(questData.MobName, targetMob.HumanoidRootPart.CFrame)
                        Tween.TweenTo(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 300)
                    else
                        -- Teleport to mob spawn area
                        Tween.TweenTo(questData.CFrame, 300)
                    end
                end
            end
        end

        FastAttack.Stop()
        FastAttack.StopMobGrouping()
    end)
end

function MainFarm.StopAutoFarm()
    MainFarm.AutoFarmLevel = false
end

return MainFarm
