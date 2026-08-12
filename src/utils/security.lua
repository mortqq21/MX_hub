--[[
    MX Hub - Anti-Ban & Security Protection Module
    Provides client-side anti-detection, randomized delay jittering (humanized inputs),
    remote rate-limiting, and GUI name spoofing.
--]]

local Security = {}

--- Generate a random alphanumeric string for instance name spoofing
function Security.RandomString(length)
    length = length or math.random(8, 14)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local str = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        str = str .. chars:sub(randIndex, randIndex)
    end
    return str
end

--- Dynamic Humanized Delay Generator
function Security.HumanDelay(min, max)
    min = min or 0.1
    max = max or 0.3
    task.wait(math.random() * (max - min) + min)
end

--- Remote Invocation Rate Limiter Wrapper
local lastRemoteCalls = {}
function Security.SafeRemoteCall(remoteFunc, remoteName, ...)
    local now = tick()
    if lastRemoteCalls[remoteName] and (now - lastRemoteCalls[remoteName]) < 0.25 then
        Security.HumanDelay(0.1, 0.25)
    end
    lastRemoteCalls[remoteName] = tick()

    local success, result = pcall(function(...)
        return remoteFunc(...)
    end, ...)

    if not success then
        warn("[MX Security] Remote call protected from crash/kick: " .. tostring(result))
        return nil
    end
    return result
end

--- Max Safe CFrame Speed Limiter (Prevents Speed Anticheat Kicks)
function Security.GetSafeSpeed(requestedSpeed)
    local maxSafeSpeed = 280 -- Blox Fruits recommended max safe studs/sec
    if requestedSpeed > maxSafeSpeed then
        return maxSafeSpeed
    end
    return requestedSpeed
end

return Security
