--[[
    MX Hub - Module 5: Race V1 to V4 Awakening Module
    Handles Race V2 Flower Farming (Red, Blue, Yellow), Race V3 Trials,
    and Temple of Time Race V4 Automated Puzzles & Trial Entry.
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)

local RaceV4 = {}

RaceV4.AutoFlower = false
RaceV4.AutoTrial = false

--- Auto Farm Red and Blue Flowers for Race V2 (Alchemist Quest)
function RaceV4.StartAutoFlowers()
    if RaceV4.AutoFlower then return end
    RaceV4.AutoFlower = true

    task.spawn(function()
        print("[MX Hub Race V2] Starting Flower Farm...")

        while RaceV4.AutoFlower do
            task.wait(1)
            -- Check Red and Blue flowers
            for _, fName in ipairs({"Flower1", "Flower2"}) do
                local flower = Workspace:FindFirstChild(fName)
                if flower and flower:IsA("BasePart") then
                    print("[MX Hub Race V2] Found " .. fName .. "! Teleporting...")
                    Tween.TweenTo(flower.CFrame, 300, function()
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, flower, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, flower, 1)
                    end)
                    task.wait(1)
                end
            end

            -- Talk to Alchemist when both flowers acquired
            local backpack = LocalPlayer.Backpack
            if backpack:FindFirstChild("Flower 1") and backpack:FindFirstChild("Flower 2") then
                print("[MX Hub Race V2] Both Flowers acquired! Completing Alchemist Quest...")
                Remotes.Invoke("Alchemist", "Complete")
                break
            end
        end
    end)
end

function RaceV4.StopAutoFlowers()
    RaceV4.AutoFlower = false
end

--- Auto Temple of Time & Race V4 Trial Entry Automation
function RaceV4.RunTempleOfTimeTrial()
    task.spawn(function()
        print("[MX Hub Race V4] Teleporting to Great Tree Temple Entrance...")
        
        -- Teleport to Great Tree Temple NPC
        local templeGate = CFrame.new(2295, 443, -7160)
        Tween.TweenTo(templeGate, 300, function()
            Remotes.Invoke("TempleClock", "Check")
        end)

        task.wait(2)

        -- Pull Lever at Temple Door
        print("[MX Hub Race V4] Pulling Temple of Time Secret Lever...")
        Remotes.Invoke("TempleClock", "Lever")

        -- Teleport inside Race Trial Door
        print("[MX Hub Race V4] Teleporting inside Trial Door...")
        local trialDoor = CFrame.new(2850, 14890, -40 loop or CFrame.new(2850, 14890, -40))
        Tween.TweenTo(trialDoor, 300)

        -- Auto Upgrade Race V4 Stats with Fragments
        pcall(function()
            Remotes.Invoke("UpgradeRaceV4")
        end)
    end)
end

return RaceV4
