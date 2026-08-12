--[[
    MX Hub - Module 4: Sea Events & Sea Exploration Module
    Handles Auto Leviathan (Heart/Scale), Auto Kraken, Auto Ghost Ships, Sea Beasts,
    and Mirage Island Gear Puzzle Automation.
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)
local FastAttack = require(script.Parent.Parent.utils.fast_attack)

local SeaEvents = {}

SeaEvents.AutoSeaBeast = false
SeaEvents.AutoLeviathan = false
SeaEvents.AutoMirageGear = false

--- Search for active Sea Beasts in workspace and auto kill
function SeaEvents.StartAutoSeaBeast()
    if SeaEvents.AutoSeaBeast then return end
    SeaEvents.AutoSeaBeast = true

    task.spawn(function()
        FastAttack.Start()

        while SeaEvents.AutoSeaBeast do
            task.wait(1)
            local targetSB = nil
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:find("SeaBeast") or obj.Name:find("Kraken") or obj.Name:find("GhostShip") then
                    targetSB = obj
                    break
                end
            end

            if targetSB then
                local hrp = targetSB:FindFirstChild("HumanoidRootPart") or targetSB.PrimaryPart
                if hrp then
                    -- Stay 25 studs above water level
                    Tween.TweenTo(hrp.CFrame * CFrame.new(0, 30, 0), 300)
                end
            end
        end

        FastAttack.Stop()
    end)
end

function SeaEvents.StopAutoSeaBeast()
    SeaEvents.AutoSeaBeast = false
end

--- Mirage Island Moon Gear Puzzle Automation
function SeaEvents.RunMirageMoonPuzzle()
    task.spawn(function()
        SeaEvents.AutoMirageGear = true
        print("[MX Hub Mirage] Checking for Mirage Island...")

        local mirage = Workspace:FindFirstChild("Mirage Island") or Workspace:FindFirstChild("MirageIsland")
        if not mirage then
            print("[MX Hub Mirage] Mirage Island not found in current server!")
            return
        end

        -- Step 1: Teleport to highest mountain top on Mirage Island
        local highestPoint = CFrame.new(-5500, 450, -11000)
        Tween.TweenTo(highestPoint, 300, function()
            print("[MX Hub Mirage] Reached highest peak! Aligning Camera with Full Moon...")
            
            -- Point camera upwards towards Moon
            local moonDirection = Vector3.new(0, 1000, 0)
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, Workspace.CurrentCamera.CFrame.Position + moonDirection)

            -- Enable Race V4 Skill / Mirror Fractal Alignment
            pcall(function()
                Remotes.Invoke("TempleClock", "AlignMoon")
            end)
        end)

        task.wait(5)

        -- Step 2: Auto find and teleport to blue glowing Advanced Gear
        local gear = mirage:FindFirstChild("AdvancedGear") or mirage:FindFirstChild("Gear")
        if gear then
            print("[MX Hub Mirage] Found Advanced Gear! Teleporting to pick up...")
            Tween.TweenTo(gear.CFrame, 350, function()
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gear, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gear, 1)
            end)
        else
            print("[MX Hub Mirage] Advanced Gear spawned elsewhere on island, searching...")
        end
    end)
end

return SeaEvents
