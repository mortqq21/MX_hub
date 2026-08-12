--[[
    MX Hub - World Teleports & Islands Database
    Contains exact CFrame coordinates for all major islands, cafes, mansions, trial doors,
    and secret spots across Sea 1, Sea 2, and Sea 3.
--]]

local Islands = {}

Islands.Sea1 = {
    ["Starter Island"] = CFrame.new(1059, 17, 1546),
    ["Jungle"] = CFrame.new(-1598, 37, 153),
    ["Pirate Village"] = CFrame.new(-1140, 5, 3858),
    ["Desert"] = CFrame.new(894, 7, 4390),
    ["Middle Town"] = CFrame.new(-690, 15, 1580),
    ["Frozen Village"] = CFrame.new(1385, 87, -1298),
    ["Marine Fort"] = CFrame.new(-5035, 29, 4325),
    ["Skypiea 1"] = CFrame.new(-4840, 718, -2620),
    ["Upper Sky"] = CFrame.new(-7880, 5600, -2250),
    ["Prison"] = CFrame.new(530, 2, 480),
    ["Colosseum"] = CFrame.new(-1480, 7, -2750),
    ["Magma Village"] = CFrame.new(-5315, 12, 8515),
    ["Underwater City"] = CFrame.new(60900, 18, 1500),
    ["Fountain City"] = CFrame.new(5258, 38, 4050),
}

Islands.Sea2 = {
    ["Kingdom of Rose (Cafe)"] = CFrame.new(910, 120, 1315),
    ["Ushita Mansion"] = CFrame.new(-425, 73, 1835),
    ["Don Swan Mansion"] = CFrame.new(2250, 15, 800),
    ["Green Zone"] = CFrame.new(-2440, 73, -3215),
    ["Graveyard / Haunted Castle"] = CFrame.new(-5495, 48, -795),
    ["Snow Mountain"] = CFrame.new(605, 400, -5370),
    ["Cold Lab / Raids NPC"] = CFrame.new(-6060, 16, -4905),
    ["Hot Side"] = CFrame.new(-5430, 16, -5295),
    ["Cursed Ship"] = CFrame.new(1000, 125, 32900),
    ["Forgotten Island"] = CFrame.new(-3050, 235, -10140),
}

Islands.Sea3 = {
    ["Port Town"] = CFrame.new(-290, 44, 5580),
    ["Hydra Island"] = CFrame.new(5830, 50, -4360),
    ["Great Tree / Temple of Time Entrance"] = CFrame.new(2295, 443, -7160),
    ["Floating Turtle (Mansion)"] = CFrame.new(-12470, 330, -7580),
    ["Haunted Castle / Soul Guitar NPC"] = CFrame.new(-9480, 140, 5540),
    ["Peanut Island"] = CFrame.new(-2080, 48, -10180),
    ["Ice Cream Island"] = CFrame.new(-820, 65, -10950),
    ["Cake Land"] = CFrame.new(-1920, 38, -12000),
    ["Chocolate Bar Island"] = CFrame.new(280, 25, -12500),
    ["Tiki Outpost"] = CFrame.new(-16200, 55, 5450),
    ["Mirage Island Target Spawner"] = CFrame.new(-5500, 300, -11000),
}

return Islands
