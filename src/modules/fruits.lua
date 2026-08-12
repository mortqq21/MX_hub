--[[
    MX Hub - Module 3: Fruit & Inventory Module
    Handles Auto Random Fruit Gacha (Zioles Cousin NPC), Auto Fruit Grabber (Teleport & Pick),
    Auto Store Fruit to Inventory, and Visual ESP hooks.
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)
local ESP = require(script.Parent.Parent.utils.esp)

local Fruits = {}

Fruits.AutoSnipe = false
Fruits.AutoGrab = false
Fruits.AutoStore = false

--- Buy Random Fruit from Zioles Cousin NPC
function Fruits.BuyRandomFruit()
    local result = Remotes.BuyRandomFruit()
    print("[MX Hub Fruit] Gacha Result: ", tostring(result))
    if result then
        Fruits.StoreAllFruitsInBackpack()
    end
    return result
end

--- Auto Store all Fruits in Backpack to Treasure Inventory
function Fruits.StoreAllFruitsInBackpack()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool:GetAttribute("ToolTip") == "Blox Fruit") then
            print("[MX Hub Fruit] Storing Fruit: " .. tool.Name)
            Remotes.StoreFruit(tool.Name, tool)
        end
    end
end

--- Teleport to all dropped fruits in Workspace and grab them
function Fruits.StartAutoGrab()
    if Fruits.AutoGrab then return end
    Fruits.AutoGrab = true

    task.spawn(function()
        while Fruits.AutoGrab do
            task.wait(1)
            for _, item in ipairs(Workspace:GetChildren()) do
                if not Fruits.AutoGrab then break end
                if item:IsA("Tool") and (item.Name:find("Fruit") or item:FindFirstChild("Handle")) then
                    local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        print("[MX Hub Fruit] Found dropped fruit! Teleporting to: " .. item.Name)
                        Tween.TweenTo(handle.CFrame, 350, function()
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, handle, 1)
                        end)
                        task.wait(1)
                        if Fruits.AutoStore then
                            Fruits.StoreAllFruitsInBackpack()
                        end
                    end
                end
            end
        end
    end)
end

function Fruits.StopAutoGrab()
    Fruits.AutoGrab = false
end

return Fruits
