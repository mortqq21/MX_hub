--[[
    MX Hub - Materials, Bosses & Endgame Item Collector Engine
    Supports farming Bones, Ectoplasm, Scrap Metal, Dragon Scale, Cocoa, Vampire Fangs,
    and all Sea 1, 2, and 3 Bosses (Rip Indra, Dough King, Soul Reaper, Longma, etc.)
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)
local FastAttack = require(script.Parent.Parent.utils.fast_attack)

local MatBoss = {}

MatBoss.AutoBoss = false
MatBoss.SelectedBoss = "Rip Indra [Boss]"

MatBoss.AutoMaterials = false
MatBoss.SelectedMaterial = "Bones"

-- Database of all major Bosses across Sea 1, 2, and 3
MatBoss.BossList = {
    -- Sea 3 Bosses
    "Rip Indra [Boss]",
    "Dough King",
    "Soul Reaper [Boss]",
    "Longma",
    "Cake Queen",
    "Elephant Admin",
    "Captain Elephant",
    "Beautiful Pirate",
    "Kilobyte",
    
    -- Sea 2 Bosses
    "Tide Keeper [Boss]",
    "Don Swan [Boss]",
    "Cyborg [Boss]",
    "Ice Admiral",
    "Jeremy",
    "Diamond",
    "Fajita",

    -- Sea 1 Bosses
    "Greybeard [Boss]",
    "The Saw",
    "Saber Expert",
    "Gorilla King",
    "Bobby",
    "The Gorilla King"
}

-- Database of all Materials and target mob locations
MatBoss.MaterialData = {
    ["Bones"] = { MobName = "Reborn Skeleton", CFrame = CFrame.new(-9500, 140, 5600) },
    ["Ectoplasm"] = { MobName = "Ship Deckhand", CFrame = CFrame.new(1190, 125, 33000) },
    ["Scrap Metal"] = { MobName = "Brute", CFrame = CFrame.new(-1145, 15, 4350) },
    ["Dragon Scale"] = { MobName = "Dragon Crew Warrior", CFrame = CFrame.new(5800, 50, -4400) },
    ["Conjured Cocoa"] = { MobName = "Chocolate Bar Pirate", CFrame = CFrame.new(280, 25, -12500) },
    ["Vampire Fang"] = { MobName = "Vampire", CFrame = CFrame.new(-6010, 6, -1310) },
    ["Mystic Droplet"] = { MobName = "Water Fighter", CFrame = CFrame.new(60900, 18, 1500) },
    ["Mini Tusk"] = { MobName = "Mythological Pirate", CFrame = CFrame.new(5440, 600, 750) }
}

--- Auto Farm Selected Boss
function MatBoss.StartAutoBoss()
    if MatBoss.AutoBoss then return end
    MatBoss.AutoBoss = true

    task.spawn(function()
        FastAttack.Start()

        while MatBoss.AutoBoss do
            task.wait(0.5)
            local enemies = Workspace:FindFirstChild("Enemies")
            local targetBoss = enemies and enemies:FindFirstChild(MatBoss.SelectedBoss)

            if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") then
                local hum = targetBoss:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    FastAttack.StartBring(MatBoss.SelectedBoss, targetBoss.HumanoidRootPart.CFrame)
                    Tween.TweenTo(targetBoss.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 280)
                end
            else
                print("[MX Hub Bosses] Searching for spawned boss: " .. tostring(MatBoss.SelectedBoss))
            end
        end

        FastAttack.Stop()
        FastAttack.StopBring()
    end)
end

function MatBoss.StopAutoBoss()
    MatBoss.AutoBoss = false
end

--- Auto Farm Selected Material
function MatBoss.StartAutoMaterial()
    if MatBoss.AutoMaterials then return end
    MatBoss.AutoMaterials = true

    task.spawn(function()
        FastAttack.Start()

        while MatBoss.AutoMaterials do
            task.wait(0.5)
            local matInfo = MatBoss.MaterialData[MatBoss.SelectedMaterial]
            if matInfo then
                local enemies = Workspace:FindFirstChild("Enemies")
                local targetMob = enemies and enemies:FindFirstChild(matInfo.MobName)

                if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                    FastAttack.StartBring(matInfo.MobName, targetMob.HumanoidRootPart.CFrame)
                    Tween.TweenTo(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 280)
                else
                    Tween.TweenTo(matInfo.CFrame, 280)
                end
            end
        end

        FastAttack.Stop()
        FastAttack.StopBring()
    end)
end

function MatBoss.StopAutoMaterial()
    MatBoss.AutoMaterials = false
end

return MatBoss
