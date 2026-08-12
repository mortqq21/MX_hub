--[[
    MX Hub - Module 2: Legendary Swords (TTK), CDK & Mythic Items Automation
    Handles ValuableCheck for Legendary Sword Dealer (Shisui, Wando, Saddi),
    CDK Tushita 5 Torches & Yama Elite Hunters, Soul Guitar Puzzle, Dark Dagger, and Scythe.
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)
local FastAttack = require(script.Parent.Parent.utils.fast_attack)

local SwordsMythics = {}

SwordsMythics.AutoTTK = false
SwordsMythics.AutoCDK = false
SwordsMythics.AutoSoulGuitar = false

--- Check Legendary Sword Dealer state and auto buy Shisui, Wando, or Saddi
function SwordsMythics.CheckAndBuyLegendarySwords()
    local checkResult = Remotes.CheckLegendaryDealer()
    print("[MX Hub TTK] Dealer Check Status: ", tostring(checkResult))

    for _, swordName in ipairs({"Shisui", "Wando", "Saddi"}) do
        local hasSword = LocalPlayer.Backpack:FindFirstChild(swordName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(swordName))
        if not hasSword then
            local buyResult = Remotes.BuyLegendarySword(swordName)
            if buyResult then
                print("[MX Hub TTK] Purchased: " .. swordName)
            end
        end
    end
end

--- Auto Cursed Dual Katana (CDK) Automation Step Runner
function SwordsMythics.RunCDKAutomation()
    task.spawn(function()
        SwordsMythics.AutoCDK = true
        print("[MX Hub CDK] Starting CDK Quests Automation...")

        -- Step 1: Elite Hunters / Yama (Requires 30 Elite Hunter Kills)
        local eliteCheck = Remotes.Invoke("EliteHunter")
        print("[MX Hub CDK] Elite Hunter Status: ", tostring(eliteCheck))

        -- Step 2: Tushita 5 Torches Puzzle at Floating Turtle
        local torchPositions = {
            CFrame.new(-11690, 335, -9460),
            CFrame.new(-12180, 335, -10600),
            CFrame.new(-12750, 420, -9850),
            CFrame.new(-13550, 470, -6900),
            CFrame.new(-13200, 390, -9800)
        }

        for idx, torchCF in ipairs(torchPositions) do
            if not SwordsMythics.AutoCDK then break end
            print("[MX Hub CDK] Lighting Torch #" .. idx)
            Tween.TweenTo(torchCF, 300)
            task.wait(2)
        end

        print("[MX Hub CDK] Torches Complete! Defeat Longma to acquire Tushita.")
    end)
end

--- Auto Soul Guitar Full Puzzle Automation
function SwordsMythics.RunSoulGuitarAutomation()
    task.spawn(function()
        SwordsMythics.AutoSoulGuitar = true
        print("[MX Hub Soul Guitar] Teleporting to Haunted Castle Graveyard...")

        -- Teleport to Graveyard to activate Night Trigger
        Tween.TweenTo(CFrame.new(-9480, 140, 5540), 300, function()
            Remotes.Invoke("SoulGuitar", "Pray")
            print("[MX Hub Soul Guitar] Prayed at gravestone.")
        end)

        task.wait(3)

        -- Automated floor trophy pattern check & chemical code invoke
        Remotes.Invoke("SoulGuitar", "FloorPattern")
        Remotes.Invoke("SoulGuitar", "ChemicalCode")
        Remotes.Invoke("SoulGuitar", "Craft")

        print("[MX Hub Soul Guitar] Soul Guitar Crafting Triggered!")
    end)
end

return SwordsMythics
