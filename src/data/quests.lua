--[[
    MX Hub - Blox Fruits Complete Level Quests & Mob Database (1 - 2550 Max Level)
    Includes quest accept names, level requirements, mob names, quest IDs, and CFrame coordinates.
--]]

local Quests = {}

Quests.Data = {
    -- ================= SEA 1 (First Sea: Level 1 - 700) =================
    { MinLevel = 1, MaxLevel = 9, QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", MobCount = 5, CFrame = CFrame.new(1059, 17, 1546), QuestNPC = CFrame.new(1059, 17, 1546) },
    { MinLevel = 10, MaxLevel = 14, QuestName = "JungleQuest", QuestLevel = 1, MobName = "Monkey", MobCount = 6, CFrame = CFrame.new(-1602, 37, 153), QuestNPC = CFrame.new(-1598, 37, 153) },
    { MinLevel = 15, MaxLevel = 29, QuestName = "JungleQuest", QuestLevel = 2, MobName = "Gorilla", MobCount = 8, CFrame = CFrame.new(-1237, 6, -486), QuestNPC = CFrame.new(-1598, 37, 153) },
    { MinLevel = 30, MaxLevel = 39, QuestName = "BuggyQuest1", QuestLevel = 1, MobName = "Pirate", MobCount = 8, CFrame = CFrame.new(-1210, 5, 3915), QuestNPC = CFrame.new(-1140, 5, 3858) },
    { MinLevel = 40, MaxLevel = 59, QuestName = "BuggyQuest1", QuestLevel = 2, MobName = "Brute", MobCount = 8, CFrame = CFrame.new(-1145, 15, 4350), QuestNPC = CFrame.new(-1140, 5, 3858) },
    { MinLevel = 60, MaxLevel = 89, QuestName = "DesertQuest", QuestLevel = 1, MobName = "Desert Bandit", MobCount = 8, CFrame = CFrame.new(890, 7, 4380), QuestNPC = CFrame.new(894, 7, 4390) },
    { MinLevel = 90, MaxLevel = 119, QuestName = "DesertQuest", QuestLevel = 2, MobName = "Desert Officer", MobCount = 6, CFrame = CFrame.new(1580, 10, 4370), QuestNPC = CFrame.new(894, 7, 4390) },
    { MinLevel = 120, MaxLevel = 149, QuestName = "SnowQuest", QuestLevel = 1, MobName = "Snow Bandit", MobCount = 7, CFrame = CFrame.new(1280, 87, -1290), QuestNPC = CFrame.new(1385, 87, -1298) },
    { MinLevel = 150, MaxLevel = 189, QuestName = "SnowQuest", QuestLevel = 2, MobName = "Snowman", MobCount = 7, CFrame = CFrame.new(1285, 106, -1440), QuestNPC = CFrame.new(1385, 87, -1298) },
    { MinLevel = 190, MaxLevel = 224, QuestName = "MarineQuest2", QuestLevel = 1, MobName = "Chief Petty Officer", MobCount = 8, CFrame = CFrame.new(-4850, 21, 4300), QuestNPC = CFrame.new(-5035, 29, 4325) },
    { MinLevel = 225, MaxLevel = 274, QuestName = "SkyQuest", QuestLevel = 1, MobName = "Sky Bandit", MobCount = 7, CFrame = CFrame.new(-4840, 718, -2620), QuestNPC = CFrame.new(-4840, 718, -2620) },
    { MinLevel = 275, MaxLevel = 299, QuestName = "SkyQuest", QuestLevel = 2, MobName = "Dark Master", MobCount = 8, CFrame = CFrame.new(-5250, 389, -2250), QuestNPC = CFrame.new(-4840, 718, -2620) },
    { MinLevel = 300, MaxLevel = 374, QuestName = "PrisonerQuest", QuestLevel = 1, MobName = "Prisoner", MobCount = 8, CFrame = CFrame.new(530, 2, 480), QuestNPC = CFrame.new(530, 2, 480) },
    { MinLevel = 375, MaxLevel = 449, QuestName = "FishmanQuest", QuestLevel = 1, MobName = "Fishman Warrior", MobCount = 8, CFrame = CFrame.new(60900, 18, 1500), QuestNPC = CFrame.new(60900, 18, 1500) },
    { MinLevel = 450, MaxLevel = 524, QuestName = "MagmaQuest", QuestLevel = 1, MobName = "Military Soldier", MobCount = 8, CFrame = CFrame.new(-5400, 11, 8500), QuestNPC = CFrame.new(-5315, 12, 8515) },
    { MinLevel = 525, MaxLevel = 624, QuestName = "MagmaQuest", QuestLevel = 2, MobName = "Military Spy", MobCount = 8, CFrame = CFrame.new(-5800, 75, 8750), QuestNPC = CFrame.new(-5315, 12, 8515) },
    { MinLevel = 625, MaxLevel = 699, QuestName = "FountainQuest", QuestLevel = 1, MobName = "Galley Pirate", MobCount = 8, CFrame = CFrame.new(5580, 38, 3950), QuestNPC = CFrame.new(5258, 38, 4050) },

    -- ================= SEA 2 (Second Sea: Level 700 - 1500) =================
    { MinLevel = 700, MaxLevel = 724, QuestName = "Area1Quest", QuestLevel = 1, MobName = "Raider", MobCount = 8, CFrame = CFrame.new(-450, 73, 2980), QuestNPC = CFrame.new(-425, 73, 1835) },
    { MinLevel = 725, MaxLevel = 774, QuestName = "Area1Quest", QuestLevel = 2, MobName = "Mercenary", MobCount = 8, CFrame = CFrame.new(-960, 73, 1420), QuestNPC = CFrame.new(-425, 73, 1835) },
    { MinLevel = 775, MaxLevel = 874, QuestName = "Area2Quest", QuestLevel = 1, MobName = "Swan Pirate", MobCount = 8, CFrame = CFrame.new(880, 120, 1220), QuestNPC = CFrame.new(910, 120, 1315) },
    { MinLevel = 875, MaxLevel = 924, QuestName = "MarineQuest3", QuestLevel = 1, MobName = "Marine Lieutenant", MobCount = 8, CFrame = CFrame.new(-2800, 73, -3030), QuestNPC = CFrame.new(-2440, 73, -3215) },
    { MinLevel = 925, MaxLevel = 999, QuestName = "MarineQuest3", QuestLevel = 2, MobName = "Marine Captain", MobCount = 8, CFrame = CFrame.new(-1870, 73, -3320), QuestNPC = CFrame.new(-2440, 73, -3215) },
    { MinLevel = 1000, MaxLevel = 1049, QuestName = "ZombieQuest", QuestLevel = 1, MobName = "Zombie", MobCount = 8, CFrame = CFrame.new(-5540, 48, -750), QuestNPC = CFrame.new(-5495, 48, -795) },
    { MinLevel = 1050, MaxLevel = 1099, QuestName = "ZombieQuest", QuestLevel = 2, MobName = "Vampire", MobCount = 8, CFrame = CFrame.new(-6010, 6, -1310), QuestNPC = CFrame.new(-5495, 48, -795) },
    { MinLevel = 1100, MaxLevel = 1174, QuestName = "SnowMountainQuest", QuestLevel = 1, MobName = "Snow Trooper", MobCount = 8, CFrame = CFrame.new(650, 400, -5350), QuestNPC = CFrame.new(605, 400, -5370) },
    { MinLevel = 1175, MaxLevel = 1249, QuestName = "SnowMountainQuest", QuestLevel = 2, MobName = "Winter Warrior", MobCount = 8, CFrame = CFrame.new(1150, 430, -5180), QuestNPC = CFrame.new(605, 400, -5370) },
    { MinLevel = 1250, MaxLevel = 1349, QuestName = "IceSideQuest", QuestLevel = 1, MobName = "Lab Subordinate", MobCount = 8, CFrame = CFrame.new(-5780, 40, -4850), QuestNPC = CFrame.new(-6060, 16, -4905) },
    { MinLevel = 1350, MaxLevel = 1424, QuestName = "FireSideQuest", QuestLevel = 1, MobName = "Magma Ninja", MobCount = 8, CFrame = CFrame.new(-5430, 65, -5900), QuestNPC = CFrame.new(-5430, 16, -5295) },
    { MinLevel = 1425, MaxLevel = 1499, QuestName = "ShipQuest1", QuestLevel = 1, MobName = "Ship Deckhand", MobCount = 8, CFrame = CFrame.new(1190, 125, 33000), QuestNPC = CFrame.new(1000, 125, 32900) },

    -- ================= SEA 3 (Third Sea: Level 1500 - 2550 MAX) =================
    { MinLevel = 1500, MaxLevel = 1574, QuestName = "PiratePortQuest", QuestLevel = 1, MobName = "Pirate Millionaire", MobCount = 8, CFrame = CFrame.new(-370, 74, 5550), QuestNPC = CFrame.new(-290, 44, 5580) },
    { MinLevel = 1575, MaxLevel = 1624, QuestName = "PiratePortQuest", QuestLevel = 2, MobName = "Pistol Billionaire", MobCount = 8, CFrame = CFrame.new(-470, 74, 5950), QuestNPC = CFrame.new(-290, 44, 5580) },
    { MinLevel = 1625, MaxLevel = 1699, QuestName = "AmazonQuest", QuestLevel = 1, MobName = "Dragon Crew Warrior", MobCount = 8, CFrame = CFrame.new(5800, 50, -4400), QuestNPC = CFrame.new(5830, 50, -4360) },
    { MinLevel = 1700, MaxLevel = 1749, QuestName = "AmazonQuest2", QuestLevel = 1, MobName = "Female Islander", MobCount = 8, CFrame = CFrame.new(4700, 750, 400), QuestNPC = CFrame.new(5440, 600, 750) },
    { MinLevel = 1750, MaxLevel = 1824, QuestName = "MarineTreeQuest", QuestLevel = 1, MobName = "Marine Commodore", MobCount = 8, CFrame = CFrame.new(-2550, 73, -3200), QuestNPC = CFrame.new(-2180, 73, -3400) },
    { MinLevel = 1825, MaxLevel = 1899, QuestName = "DeepForestQuest", QuestLevel = 1, MobName = "Jungle Pirate", MobCount = 8, CFrame = CFrame.new(-12100, 330, -8750), QuestNPC = CFrame.new(-13230, 330, -7620) },
    { MinLevel = 1900, MaxLevel = 1974, QuestName = "DeepForestQuest2", QuestLevel = 1, MobName = "Musketeer Pirate", MobCount = 8, CFrame = CFrame.new(-13200, 390, -9800), QuestNPC = CFrame.new(-13230, 330, -7620) },
    { MinLevel = 1975, MaxLevel = 2049, QuestName = "HauntedQuest1", QuestLevel = 1, MobName = "Reborn Skeleton", MobCount = 8, CFrame = CFrame.new(-9500, 140, 5600), QuestNPC = CFrame.new(-9480, 140, 5540) },
    { MinLevel = 2050, MaxLevel = 2124, QuestName = "HauntedQuest2", QuestLevel = 1, MobName = "Living Zombie", MobCount = 8, CFrame = CFrame.new(-10150, 140, 5950), QuestNPC = CFrame.new(-9480, 140, 5540) },
    { MinLevel = 2125, MaxLevel = 2199, QuestName = "PeanutQuest", QuestLevel = 1, MobName = "Peanut Scout", MobCount = 8, CFrame = CFrame.new(-2150, 48, -10150), QuestNPC = CFrame.new(-2080, 48, -10180) },
    { MinLevel = 2200, MaxLevel = 2274, QuestName = "IceCreamQuest", QuestLevel = 1, MobName = "Ice Cream Chef", MobCount = 8, CFrame = CFrame.new(-650, 50, -11150), QuestNPC = CFrame.new(-820, 65, -10950) },
    { MinLevel = 2275, MaxLevel = 2349, QuestName = "CakeQuest1", QuestLevel = 1, MobName = "Cookie Crafter", MobCount = 8, CFrame = CFrame.new(-2050, 65, -12150), QuestNPC = CFrame.new(-1920, 38, -12000) },
    { MinLevel = 2350, MaxLevel = 2424, QuestName = "CakeQuest2", QuestLevel = 1, MobName = "Cake Guard", MobCount = 8, CFrame = CFrame.new(-1650, 38, -12450), QuestNPC = CFrame.new(-1920, 38, -12000) },
    { MinLevel = 2425, MaxLevel = 2499, QuestName = "TikiQuest1", QuestLevel = 1, MobName = "Isle Outlaw", MobCount = 8, CFrame = CFrame.new(-16500, 55, 5500), QuestNPC = CFrame.new(-16200, 55, 5450) },
    { MinLevel = 2500, MaxLevel = 2800, QuestName = "TikiQuest2", QuestLevel = 2, MobName = "Isle Champion", MobCount = 8, CFrame = CFrame.new(-16800, 55, 5900), QuestNPC = CFrame.new(-16200, 55, 5450) },
}

--- Get optimal quest info for player current level
function Quests.GetQuestForLevel(playerLevel)
    for _, q in ipairs(Quests.Data) do
        if playerLevel >= q.MinLevel and playerLevel <= q.MaxLevel then
            return q
        end
    end
    -- Default fallback for max level
    return Quests.Data[#Quests.Data]
end

return Quests
