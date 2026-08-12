--[[
    MX Hub - Module 6: Raids & Dough Awakening Module
    Handles Auto Buying Chips (Normal & Advanced like Dough/Phoenix), Auto Start Raid,
    Auto Island Teleportation across all 5 rooms, Auto Killing Raid Mobs/Bosses, and Skill Awakening.
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)
local FastAttack = require(script.Parent.Parent.utils.fast_attack)

local Raids = {}

Raids.AutoRaid = false
Raids.SelectedRaid = "Dough"
Raids.AutoAwaken = false

--- Buy selected Raid Microchip
function Raids.BuyChip(raidType)
    local targetRaid = raidType or Raids.SelectedRaid
    print("[MX Hub Raids] Buying Chip for: " .. targetRaid)
    local res = Remotes.BuyRaidChip(targetRaid)
    return res
end

--- Auto Raid Loop (Buy Chip -> Start -> Teleport Rooms 1-5 -> Kill Boss -> Awaken)
function Raids.StartAutoRaid()
    if Raids.AutoRaid then return end
    Raids.AutoRaid = true

    task.spawn(function()
        FastAttack.Start()

        while Raids.AutoRaid do
            task.wait(1)

            -- 1. Check if holding Chip in Backpack
            local char = LocalPlayer.Character
            local backpack = LocalPlayer.Backpack
            local hasChip = (char and char:FindFirstChild("Special Microchip")) or (backpack and backpack:FindFirstChild("Special Microchip"))

            if not hasChip then
                -- Buy Chip
                Raids.BuyChip(Raids.SelectedRaid)
                task.wait(1)
            end

            -- 2. Teleport to Cold Lab Raid Start Pedestal
            local raidPedestal = CFrame.new(-6060, 16, -4905)
            Tween.TweenTo(raidPedestal, 300, function()
                Remotes.StartRaid()
            end)

            -- 3. Check if inside Raid Map
            local raidLocations = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Raid")
            if raidLocations then
                -- Teleport through Raid Island Rooms 1 to 5
                for roomIndex = 1, 5 do
                    if not Raids.AutoRaid then break end
                    local roomName = "Island " .. roomIndex
                    local island = raidLocations:FindFirstChild(roomName)
                    if island then
                        print("[MX Hub Raids] Teleporting to Raid Room #" .. roomIndex)
                        local targetCF = island.CFrame * CFrame.new(0, 40, 0)
                        Tween.TweenTo(targetCF, 300)
                        task.wait(3)
                    end
                end

                -- Auto Awaken Skill after completion
                if Raids.AutoAwaken then
                    Remotes.AwakenSkill()
                end
            end
        end

        FastAttack.Stop()
    end)
end

function Raids.StopAutoRaid()
    Raids.AutoRaid = false
end

return Raids
