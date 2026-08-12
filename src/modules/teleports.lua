--[[
    MX Hub - Module 8: Teleports & World Navigation Module
    Handles Safe Fast Teleport (Tween CFrame) to all Sea 1, 2, and 3 Islands, NPCs, Cafes,
    World Hopper (Sea 1 <-> Sea 2 <-> Sea 3), and Server Hop / Rejoin.
--]]

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = require(script.Parent.Parent.utils.remotes)
local Tween = require(script.Parent.Parent.utils.tween)
local Islands = require(script.Parent.Parent.data.islands)

local Teleports = {}

--- Teleport to selected island CFrame
function Teleports.ToIsland(seaName, islandName)
    local targetCF = Islands[seaName] and Islands[seaName][islandName]
    if targetCF then
        print("[MX Hub Teleports] Fast Teleporting to: " .. islandName .. " (" .. seaName .. ")")
        Tween.TweenTo(targetCF, 350)
    else
        warn("[MX Hub Teleports] Island position not found: " .. tostring(islandName))
    end
end

--- Travel between World Seas (Sea 1, 2, or 3)
function Teleports.TravelSea(targetSeaNumber)
    print("[MX Hub World Hopper] Travelling to Sea #" .. targetSeaNumber)
    Remotes.TravelSea(targetSeaNumber)
end

--- Rejoin current server
function Teleports.RejoinServer()
    print("[MX Hub Server] Rejoining server...")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

--- Server Hop to a different server instance with lower player count
function Teleports.ServerHop()
    print("[MX Hub Server] Searching for alternative server...")
    local serversApi = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversApi))
    end)

    if success and response and response.data then
        for _, server in ipairs(response.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                print("[MX Hub Server] Hopping to server: " .. server.id .. " (" .. server.playing .. "/" .. server.maxPlayers .. ")")
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                return
            end
        end
    end
    warn("[MX Hub Server] Failed to find available server to hop!")
end

return Teleports
