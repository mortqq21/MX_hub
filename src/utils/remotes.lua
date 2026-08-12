--[[
    MX Hub - Blox Fruits Script Core Remotes Wrapper
    Provides unified helper methods for Blox Fruits CommF_ and other ReplicatedStorage remotes.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = {}
local CommF = ReplicatedStorage:WaitForChild("Remotes", 10) and ReplicatedStorage.Remotes:WaitForChild("CommF_", 10)

--- Safe invoke wrapper for CommF_ remote
--- @param ... any Arguments to pass to CommF_
--- @return any Result from the server invoke
function Remotes.Invoke(...)
    if not CommF then
        CommF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
    end
    if CommF then
        local success, result = pcall(function(...)
            return CommF:InvokeServer(...)
        end, ...)
        if success then
            return result
        else
            warn("[MX Hub Remotes] InvokeServer error: " .. tostring(result))
        end
    else
        warn("[MX Hub Remotes] CommF_ Remote not found!")
    end
    return nil
end

--- Safe fire wrapper for CommF_ or event remotes
function Remotes.Fire(remoteName, ...)
    local rem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild(remoteName)
    if rem and rem:IsA("RemoteEvent") then
        pcall(function(...)
            rem:FireServer(...)
        end, ...)
    end
end

-- ============================================================================
-- COMMON BLOX FRUITS REMOTE API HELPER BINDINGS
-- ============================================================================

--- Accept Quest
function Remotes.StartQuest(questName, questLevel)
    return Remotes.Invoke("StartQuest", questName, questLevel)
end

--- Abandon Active Quest
function Remotes.AbandonQuest()
    return Remotes.Invoke("AbandonQuest")
end

--- Allocate Stat Points
--- @param stat string "Melee" | "Defense" | "Sword" | "Gun" | "Demon Fruit"
--- @param points number
function Remotes.AddPoint(stat, points)
    return Remotes.Invoke("AddPoint", stat, points or 1)
end

--- Random Fruit Gacha (Zioles Cousin)
function Remotes.BuyRandomFruit()
    return Remotes.Invoke("Cousin", "Buy")
end

--- Store Fruit to Treasure Inventory
function Remotes.StoreFruit(fruitName, fruitTool)
    return Remotes.Invoke("StoreFruit", fruitName, fruitTool)
end

--- Check Legendary Sword Dealer (Sea 2)
function Remotes.CheckLegendaryDealer()
    return Remotes.Invoke("ValuableCheck")
end

--- Buy Legendary Sword (Shisui, Wando, Saddi)
function Remotes.BuyLegendarySword(swordName)
    return Remotes.Invoke("BuyItem", swordName)
end

--- Travel between seas
--- @param seaTarget number 1, 2, or 3
function Remotes.TravelSea(seaTarget)
    if seaTarget == 1 then
        return Remotes.Invoke("TravelMain")
    elseif seaTarget == 2 then
        return Remotes.Invoke("TravelDressrosa")
    elseif seaTarget == 3 then
        return Remotes.Invoke("TravelZ")
    end
end

--- Buy Raid Chip
function Remotes.BuyRaidChip(raidName)
    return Remotes.Invoke("RaidsNpc", "Select", raidName)
end

--- Start Raid
function Remotes.StartRaid()
    return Remotes.Invoke("RaidsNpc", "Start")
end

--- Awaken Fruit Skill
function Remotes.AwakenSkill()
    return Remotes.Invoke("Awakener", "Awaken")
end

return Remotes
