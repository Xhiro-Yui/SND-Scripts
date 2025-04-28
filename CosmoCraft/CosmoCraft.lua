--[[
**************************************************************************
*                          CosmoCraft v1.2                               *
**************************************************************************
]]
--[[
**************************************************************************
*                                Settings                                *
**************************************************************************
]]
RepairAmount = 99          -- the amount it needs to drop before Repairing (set it to 0 if you don't want it to repair)
CriticalMissions = true    -- Change this manually to true during red alerts to do red alert missions -- WILL CRASH IF TRUE! Will be fixed in v1.3 or later
ProvisionalMissions = true -- Change this manually to true to attempt doing provisional missions when available
Debug = true               -- Change this to true to print debug log to see what the script is doing
CurrentClass = "ARM"       -- SND is broken and can't retrieve self job ID right now so have to manual input
Artisan = true             -- Uses Artisan's endurance mode
InteractKeybind = "NUMPAD0"
--[[
**************************************************************************
*                           Internal Variables                           *
**************************************************************************
]]
CharacterCondition = {
    crafting = 5,
    occupiedMateriaExtractionAndRepair = 39,
    preparingToCraft = 41
}
Callback = {
    extractMateria = "/callback Materialize true 2 0 <wait.3>",
    extractMateriaDialog = "/callback MaterializeDialog true 0 <wait.3>",
    repair = "/callback Repair true 0 <wait.3>",
    selectYes = "/callback SelectYesno true 0 <wait.3>",
    interactNpc = "/send %s <wait.1>",
    toggleRepairWindow = "/generalaction repair <wait.1>",
    toggleMateriaExtractionWindow = '/generalaction "Materia Extraction" <wait.1>',
    openMissionInformationWindow = "/callback WKSHud true 11 <wait.1>",
    openRecipeWindow = "/callback WKSMissionInfomation true 14 <wait.1>",
    startSynthesis = "/callback WKSRecipeNotebook true 6 <wait.1>",
    clickHQButton = "/callback WKSRecipeNotebook true 5 <wait.0.2>",
    clickNextItemToCraft = "/callback WKSRecipeNotebook true 0 %su <wait.1>",
    navigateToBasicMissionsTab = "/callback WKSMission true 15 0u <wait.1>",
    navigateToProvisionalMissionsTab = "/callback WKSMission true 15 1u <wait.1>",
    navigateToCriticalMissionsTab = "/callback WKSMission true 15 2u <wait.1>",
    clickMission = "/callback WKSMission true 12 %su <wait.1>",
    startMission = "/callback WKSMission true 13 %su <wait.1>",
    submitMission = "/callback WKSMissionInfomation true 11 <wait.1>",
    moveToSubmissionPoint = "/vnav moveto %s %s %s", -- x,y,z
}
StopScript = false
DoingMission = false
CurrentMission = {}
Synthesizing = false
MissionList = {
    ARM = {
        Critical = {
            [518] = { type = "Critical", name = " Spare Vacuum Tanks", valid = true, x = 176, y = 9, z = 562 },
            [519] = { type = "Critical", name = " Vehicular Plating", valid = true }
        },
        Provisional = {
            [126] = { type = "Sequential", name = "A-2: Specialized Materials II", valid = true },
            [130] = { type = "Time", name = "A-1: High-performance Drone Materials I", valid = true },
            [121] = { type = "Weather", name = "A-3: High-durability Material Processing", valid = true},
            [122] = { type = "Weather", name = "A-3: Impact-resistant Material Processing", valid = true},
            
        },
        A = {
            [112] = { name = "A-1: Key Facility Plating", valid = true },
            [113] = { name = "A-1: Rare Material Processing", valid = true },
            [114] = { name = "A-1: Construction Necessities", valid = true },
            [115] = { name = "A-1: High-conductivity Culinary Tools", valid = true },
            [116] = { name = "A-1: Meteoric Material Test Processing", valid = true },
            [123] = { name = "A-1: Hub Furnishings and Fixtures I", valid = true },
            [125] = { name = "A-1: Specialized Materials I", valid = true },
            [117] = { name = "A-2: Replica Incensories", valid = false },
            [118] = { name = "A-2: Fine-grade Material Processing", valid = false },
            [128] = { name = "A-2: Starship Building Materials", valid = false },
            [497] = { name = "A-2: Impact-resistant Containers", valid = false }
        },
        B = {
            [104] = { name = " Rover Parts", valid = true },
            [105] = { name = " Standardized Light Plating", valid = true },
            [106] = { name = " Worker's Culinary Tools II", valid = true },
            [107] = { name = " Beverage Stations", valid = true },
            [108] = { name = " Campfire Fixtures", valid = true },
            [109] = { name = " Habitation Storage", valid = true },
            [110] = { name = " Lunar Material Tool Processing", valid = true },
            [111] = { name = " Lunar Material Part Processing", valid = true }
        },
        C = {
            [97] = { name = " Standardized Heavy Plating", valid = true },
            [98] = { name = " Starship Shafts", valid = true },
            [99] = { name = " Worker's Culinary Tools I", valid = true },
            [100] = { name = " Standardized Chainmail Sheets", valid = true },
            [101] = { name = " Dust-filtering Equipment", valid = true },
            [102] = { name = " Custom Parts (Intermediate)", valid = true },
            [103] = { name = " Insulated Equipment", valid = true }
        },
        D = {
            [91] = { name = " Multi-purpose Plating", valid = true },
            [92] = { name = " Spare Starship Parts", valid = true },
            [93] = { name = " Alloy Inspection", valid = true },
            [94] = { name = " Custom Parts (Simple)", valid = true },
            [95] = { name = " Multi-purpose Metal Components", valid = true },
            [96] = { name = " Mass-produced Necessities", valid = true }
        }
    },
    CUL = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [337] = { name = "A-1: Water-resistant Lubricant", valid = false },
            [338] = { name = "A-1: Stellar Adhesive", valid = false },
            [339] = { name = "A-1: Liquid Nutrient Supplements", valid = false },
            [340] = { name = "A-1: Cafeteria Goods", valid = false },
            [341] = { name = "A-1: Lunar Seafood Processing", valid = false },
            [348] = { name = "A-1: Worker's Banquet Preparation I", valid = false },
            [350] = { name = "A-1: Loporrit Dietary Improvement I", valid = false },
            [342] = { name = "A-2: Stable Food Mass Production", valid = false },
            [343] = { name = "A-2: Sharlayan Dish Inspection", valid = false },
            [353] = { name = "A-2: Aquaculture Feed I", valid = false },
            [504] = { name = "A-2: Freshness Preservation", valid = false }
        },
        B = {
            [329] = { name = " Experimental Foodstuffs", valid = true },
            [330] = { name = " Water-resistant Lubricant", valid = true },
            [331] = { name = " Experimental Potables", valid = true },
            [332] = { name = " Launch Party Foodstuffs", valid = true },
            [333] = { name = " Home-cooked Seafood Meal", valid = true },
            [334] = { name = " Nutrient-rich Lunar Food", valid = true },
            [335] = { name = " Bakery Inspection", valid = true },
            [336] = { name = " Mushroom Processing", valid = true }
        },
        C = {
            [322] = { name = " Heat-resistant Lubricant", valid = true },
            [323] = { name = " Nutrient-rich Foodstuffs", valid = true },
            [324] = { name = " Construction Paint", valid = true },
            [325] = { name = " Portable Foodstuffs", valid = true },
            [326] = { name = " Nutrient-rich Seafood Processing", valid = true },
            [327] = { name = " Emergency Foodstuff Development", valid = true },
            [328] = { name = " Essential Whole Meals", valid = true }
        },
        D = {
            [316] = { name = " Standard Lubricant", valid = true },
            [317] = { name = " Spice Processing", valid = true },
            [318] = { name = " Building Adhesive", valid = true },
            [319] = { name = " Aquatic Nutrient Concentrate", valid = true },
            [320] = { name = " Aquatic Ink", valid = true },
            [321] = { name = " Medicated Feed Research", valid = true }
        }
    },
    CRP = {
        Critical = {
            [514] = { name = " Fungal Building Materials", valid = true, x = 656, y = 52, z = 97 },
        },
        Sequential = {},
        Time = {
            [40] = { name = "A-1: Packing Materials I", valid = true } -- 0000-0159
        },
        Weather = {
            [121] = { name = "A-3: Elevating Platforms", valid = true},
        },
        A = {
            [22] = { name = "A-1: High-durability Fiberboard", valid = true },
            [23] = { name = "A-1: High-grade Paper", valid = true },
            [24] = { name = "A-1: Starship Insulation", valid = true },
            [25] = { name = "A-1: High Burn Charcoal", valid = true },
            [26] = { name = "A-1: Lunar Flora Test Processing", valid = true },
            [33] = { name = "A-1: Power Transmission Shafts I", valid = true },
            [35] = { name = "A-1: Specialized Materials I", valid = true },
            [27] = { name = "A-2: Test Material Final Processing", valid = true },
            [28] = { name = "A-2: Serving Trays", valid = true },
            [38] = { name = "A-2: Rest Facility Materials", valid = true },
            [496] = { name = "A-2: Aquatic Resource Research Tanks", valid = false }
        },
        B = {
            [14] = { name = " Resupplying Containers", valid = true },
            [15] = { name = " Thick Fiberboard", valid = true },
            [16] = { name = " High-quality Insulation Materials", valid = true },
            [17] = { name = " Heat-resistant Resin", valid = true },
            [18] = { name = " Long-term Storage Paper", valid = true },
            [19] = { name = " Habitation Module Chairs", valid = true },
            [20] = { name = " Test Material Gathering Tools", valid = true },
            [21] = { name = " High-quality Rest Beds", valid = true }
        },
        C = {
            [7] = { name = " Thin Fiberboard", valid = true },
            [8] = { name = " Carpentry Provisions", valid = true },
            [9] = { name = " Worker's Weaving Tools", valid = true },
            [10] = { name = " Data Entry Paper", valid = true },
            [11] = { name = " Interior Insulation Materials", valid = true },
            [12] = { name = " Cosmoliner Supplies", valid = true },
            [13] = { name = " New Material Earrings ", valid = true }
        },
        D = {
            [1] = { name = " Multi-purpose Fiberboard", valid = true },
            [2] = { name = " Fieldwork Fuel", valid = true },
            [3] = { name = " Gathering Miscellany", valid = true },
            [4] = { name = " Essential Research Materials", valid = true },
            [5] = { name = " Charcoal Longevity Testing", valid = true },
            [6] = { name = " General-purpose Bedding ", valid = true }
        }
    },
    BSM = {
        Critical = {
            [517] = { name = " Flamethrower Parts", valid = true, x = 546, y = 37, z = 55 },
        },
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [67] = { name = "A-1: Key Facility Plating", valid = false },
            [68] = { name = "A-1: Rare Material Processing", valid = false },
            [69] = { name = "A-1: Construction Necessities", valid = false },
            [70] = { name = "A-1: Worker's Sheet Metal Tools", valid = false },
            [71] = { name = "A-1: Meteoric Material Test Processing", valid = false },
            [78] = { name = "A-1: Hub Furnishings and Fixtures I", valid = false },
            [80] = { name = "A-1: Specialized Materials I", valid = false },
            [72] = { name = "A-2: Replica Far Eastern Furnishings", valid = false },
            [73] = { name = "A-2: Fine-grade Material Processing", valid = false },
            [83] = { name = "A-2: Starship Building Materials", valid = false },
            [508] = { name = "A-2: Processed Aquatic Metals", valid = false }
        },
        B = {
            [59] = { name = " Rover Shafts", valid = true },
            [60] = { name = "???", valid = false },
            [61] = { name = " Worker's Smithing Tools", valid = true },
            [62] = { name = " Bathing Fixtures", valid = true },
            [63] = { name = " Ceruleum Stoves", valid = true },
            [64] = { name = " Habitation Lighting", valid = true },
            [65] = { name = " Lunar Material Tool Processing", valid = true },
            [66] = { name = " Lunar Material Part Processing", valid = true }
        },
        C = {
            [52] = { name = " Standardized Heavy Plating", valid = true },
            [53] = { name = " Starship Shafts", valid = true },
            [54] = { name = " Worker's Mining Tools", valid = true },
            [55] = { name = " Standardized Alloy Rivets", valid = true },
            [56] = { name = " Worker's Carpentry Tools", valid = true },
            [57] = { name = " Custom Parts (Intermediate)", valid = true },
            [58] = { name = " Insulated Equipment", valid = true }
        },
        D = {
            [46] = { name = " Multi-purpose Plating", valid = true },
            [47] = { name = " Spare Starship Parts", valid = true },
            [48] = { name = " Alloy Inspection", valid = true },
            [49] = { name = " Custom Parts (Simple)", valid = true },
            [50] = { name = " Multi-purpose Metal Components", valid = true },
            [51] = { name = " Mass-produced Necessities ", valid = true }
        }
    },
    GSM = {
        Critical = {
            [522] = { name = " Intricate Vacuum Parts", valid = true, x = 176, y = 9, z = 562 },
        },
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [157] = { name = "A-1: Key Facility Plating", valid = false },
            [158] = { name = "A-1: Rare Material Processing", valid = false },
            [159] = { name = "A-1: Construction Necessities", valid = false },
            [160] = { name = "A-1: Fine-grade Knives", valid = false },
            [161] = { name = "A-1: Meteoric Material Test Processing", valid = false },
            [168] = { name = "A-1: Hub Furnishings and Fixtures I", valid = false },
            [170] = { name = "A-1: Specialized Materials I", valid = false },
            [162] = { name = "A-2: Replica Bathing Fixtures", valid = false },
            [163] = { name = "A-2: Fine-grade Material Processing", valid = false },
            [173] = { name = "A-2: Starship Building Materials", valid = false },
            [498] = { name = "A-2: Soothing Censers", valid = false }
        },
        B = {
            [149] = { name = " Rover Parts", valid = true },
            [150] = { name = " Standardized Light Plating", valid = true },
            [151] = { name = " Worker's Weaving Tools", valid = true },
            [152] = { name = " Observation Devices", valid = true },
            [153] = { name = " Fireplace Fixtures", valid = true },
            [154] = { name = " Habitation Vanities", valid = true },
            [155] = { name = " Lunar Material Tool Processing", valid = true },
            [156] = { name = " Lunar Material Part Processing", valid = true }
        },
        C = {
            [142] = { name = " Standardized Heavy Plating", valid = true },
            [143] = { name = " Starship Shafts", valid = true },
            [144] = { name = " Worker's Grinding Tools", valid = true },
            [145] = { name = " Standardized Chainmail Sheets", valid = true },
            [146] = { name = " Eye Protection Equipment", valid = true },
            [147] = { name = " Custom Parts (Intermediate)", valid = true },
            [148] = { name = " Heat Dissipation Equipment", valid = true }
        },
        D = {
            [136] = { name = " Multi-purpose Plating", valid = true },
            [137] = { name = " Spare Starship Parts", valid = true },
            [138] = { name = " Alloy Inspection", valid = true },
            [139] = { name = " Custom Parts (Simple)", valid = true },
            [140] = { name = " Multi-purpose Metal Components", valid = true },
            [141] = { name = " Mass-produced Necessities", valid = true }
        }
    },
    ALC = {
        Critical = {
            [532] = { name = " Flamethrower Fuel", valid = false, x = 546, y = 37, z = 55 },
            [530] = { name = " Aether-resistant Agent", valid = true, x = 176, y = 9, z = 562 },
        },
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [292] = { name = "A-1: Water-resistant Bricks", valid = false },
            [293] = { name = "A-1: Stellar Adhesive", valid = false },
            [294] = { name = "A-1: Nutrient Supplements", valid = false },
            [295] = { name = "A-1: Cafeteria Goods", valid = false },
            [296] = { name = "A-1: Lunar Seafood Processing", valid = false },
            [303] = { name = "A-1: Natural Remedy Inspection I", valid = false },
            [305] = { name = "A-1: Loporrit Habitat Improvements I", valid = false },
            [297] = { name = "A-2: Emergency Potables", valid = false },
            [298] = { name = "A-2: Cosmetic Research Materials", valid = false },
            [308] = { name = "A-2: Aquaculture Feed I", valid = false },
            [509] = { name = "A-2: Refined Moon Gel", valid = false }
        },
        B = {
            [284] = { name = " Lunar Spice Processing", valid = true },
            [285] = { name = " Water-resistant Bricks", valid = true },
            [286] = { name = " Research Medicine", valid = true },
            [287] = { name = " Holy Water", valid = true },
            [288] = { name = " Lunar Flooring", valid = true },
            [289] = { name = " Stellar Nutrients", valid = true },
            [290] = { name = " Miniature Gardens", valid = true },
            [291] = { name = " Decorative Lunar Plants", valid = true }
        },
        C = {
            [277] = { name = " Heat-resistant Bricks", valid = true },
            [278] = { name = " Health Drinks", valid = true },
            [279] = { name = " Construction Paint", valid = true },
            [280] = { name = " Traditional Veneer", valid = true },
            [281] = { name = " Night Lighting", valid = true },
            [282] = { name = " Emergency Foodstuffs Development", valid = true },
            [283] = { name = " Experimental Potables", valid = true }
        },
        D = {
            [271] = { name = " Foundation Bricks", valid = true },
            [272] = { name = " Spice Processing", valid = true },
            [273] = { name = " Building Adhesive", valid = true },
            [274] = { name = " Nutrient Supplements", valid = true },
            [275] = { name = " Aquatic Adhesive", valid = true },
            [276] = { name = " Medicated Feed Research", valid = true }
        }
    },
    LTW = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [202] = { name = "A-1: High-durability Leather String", valid = false },
            [203] = { name = "A-1: High-grade Paper", valid = false },
            [204] = { name = "A-1: Research Plant Rug", valid = false },
            [205] = { name = "A-1: Thermal Leather", valid = false },
            [206] = { name = "A-1: Lunar Flora Test Processing", valid = false },
            [213] = { name = "A-1: Base Supplies I", valid = false },
            [215] = { name = "A-1: Specialized Materials I", valid = false },
            [207] = { name = "A-2: Test Material Final Processing", valid = false },
            [208] = { name = "A-2: Work Pouches", valid = false },
            [218] = { name = "A-2: Rest Facility Materials", valid = false }
        },
        B = {
            [194] = { name = " Leather First-aid Bags", valid = true },
            [195] = { name = " Sterile Leather String", valid = true },
            [196] = { name = " High-grade Rugs", valid = true },
            [197] = { name = " Transport Leather", valid = true },
            [198] = { name = " Long-term Storage Paper", valid = true },
            [199] = { name = " High-grade Rest Chairs", valid = true },
            [200] = { name = " Test Material Gloves", valid = true },
            [201] = { name = " High-grade Rest Lounges", valid = true }
        },
        C = {
            [187] = { name = " Heat-resistant Leather String", valid = true },
            [188] = { name = " Worker's Bags", valid = true },
            [189] = { name = " Worker's Belts", valid = true },
            [190] = { name = " High-grade Paper", valid = true },
            [191] = { name = " Sheep Rugs", valid = true },
            [192] = { name = " Cosmoliner Materials", valid = true },
            [193] = { name = " New Material Jackets", valid = true }
        },
        D = {
            [181] = { name = " Multi-purpose Leather Straps", valid = true },
            [182] = { name = " First-aid Leather", valid = true },
            [183] = { name = " Gatherer's Gloves", valid = true },
            [184] = { name = " Essential Research Materials", valid = true },
            [185] = { name = " Work Pouches", valid = true },
            [186] = { name = " Leather Room Shoes", valid = true }
        }
    },
    WVR = {
        Critical = {
            [529] = { name = " Fungal Cloth", valid = true, x = 656, y = 52, z = 97 },
        },
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [247] = { name = "A-1: High-durability Yarn", valid = false },
            [248] = { name = "A-1: High-grade Composite Fiber", valid = false },
            [249] = { name = "A-1: High-grade Bedroom Curtains", valid = false },
            [250] = { name = "A-1: First-aid Bandaging", valid = false },
            [251] = { name = "A-1: Lunar Flora Test Processing", valid = false },
            [258] = { name = "A-1: Cosmoliner Materials I", valid = false },
            [260] = { name = "A-1: Specialized Materials I", valid = false },
            [252] = { name = "A-2: Test Material Final Processing", valid = false },
            [253] = { name = "A-2: Weaving Materials", valid = false },
            [263] = { name = "A-2: Rest Facility Materials", valid = false },
            [999] = { name = "???", valid = false } -- 999 placeholder
        },
        B = {
            [239] = { name = " Work Rope", valid = true },
            [240] = { name = " Sterile Yarn", valid = true },
            [241] = { name = " High-grade Curtains", valid = true },
            [242] = { name = " Transport Yarn", valid = true },
            [243] = { name = " Heat-resistant Composite Fiber", valid = true },
            [244] = { name = " Rest Supplies", valid = true },
            [245] = { name = " Test Material Hats", valid = true },
            [246] = { name = " Rest Cushions", valid = true }
        },
        C = {
            [232] = { name = " Heat-resistant Yarn", valid = true },
            [233] = { name = " Room Garments", valid = true },
            [234] = { name = " Multi-purpose Fabric", valid = true },
            [235] = { name = " Composite Fiber", valid = true },
            [236] = { name = " Infirmary Curtains", valid = true },
            [237] = { name = " Cosmoliner Materials", valid = true },
            [238] = { name = " New Material Trousers", valid = true }
        },
        D = {
            [226] = { name = " Multi-purpose Yarn", valid = true },
            [227] = { name = " First-aid Cloth", valid = true },
            [228] = { name = " Gatherer's Helmets", valid = true },
            [229] = { name = " Essential Research Materials", valid = true },
            [230] = { name = " Multi-purpose String", valid = true },
            [231] = { name = " Divider Curtains", valid = true }
        }
    }
}
--[[
**************************************************************************
*                           Internal Functions                           *
**************************************************************************
]]
function LogDebug(val)
    if Debug then
        yield("/echo [Debug] " .. val)
    end
end

function LogInfo(val)
    yield("/echo [Info] " .. val)
end

function CheckRequiredDependencies()
    LogInfo("Checking required dependencies for the script to run")
    if Artisan then
        if not HasPlugin("Artisan") then
            LogInfo("Artisan is required. Please install Artisan : https://github.com/PunishXIV/Artisan")
            return false
        end
    end
    if CriticalMissions then
        if not HasPlugin("vnavmesh") then
            LogInfo("vnavmesh is required. Please install vnavmesh : https://github.com/awgil/ffxiv_navmesh")
            return false
        end
    end
    LogInfo("Dependencies check is completed")
    return true
end

function PrintCurrentMissions(CurrentMissions)
    for MissionType, MissionList in pairs(CurrentMissions) do
        LogDebug("[CurrentMissions] Mission Type : " .. MissionType)
        for _, MissionData in pairs(MissionList) do
            LogDebug("[CurrentMissions] -> " .. (MissionData.type or "Basic") .. " |  " .. MissionData.name)
        end
        LogDebug("[CurrentMissions] ------")
    end
end


function GetMissionClass(MissionType, MissionName)
    LogDebug("Searching for [" .. MissionName .. "] in [" .. MissionType .. "] Mission List for [" .. CurrentClass .. "]")
    for _, MissionObject in pairs(MissionList[CurrentClass][MissionType]) do
        if MissionObject.name == MissionName then
            return MissionObject
        end
    end
    -- Mission not found in mission list. This can be due to unknown missions that has not been documented or there is an error on the mission list
    LogDebug("Unable to find [" .. MissionName .. "] in Mission List. Skipping")
    return
end

function ParseMission(MissionType, MissionTable, MissionName)
    if MissionName ~= nil then
        MissionData = GetMissionClass(MissionType, MissionName)
        if MissionData ~= nil then
            table.insert(MissionTable, MissionData)
        end
    end
end

function GetCurrentMissions()
    CurrentMissions = {}
    if CriticalMissions then
        LogDebug("Critical Missions enabled. Parsing Critical missions tab")
        yield(Callback.navigateToCriticalMissionsTab)
        Critical = {}
        Mission = {}
        if GetNodeText("WKSMission", 89, 24, 2) == "Critical Missions" then
            ParseMission("Critical", Critical, GetNodeText("WKSMission", 89, 2, 8))
            ParseMission("Critical", Critical, GetNodeText("WKSMission", 89, 3, 8))
            ParseMission("Critical", Critical, GetNodeText("WKSMission", 89, 4, 8))
            ParseMission("Critical", Critical, GetNodeText("WKSMission", 89, 5, 8))
            ParseMission("Critical", Critical, GetNodeText("WKSMission", 89, 6, 8))
            ParseMission("Critical", Critical, GetNodeText("WKSMission", 89, 7, 8))
        end
        CurrentMissions.Critical = Critical
        if (next(Critical) ~= nil) then
            if Debug then PrintCurrentMissions(CurrentMissions) end
            return CurrentMissions -- Return early because if any is available, should be doing it anyway
        end
    end
    if ProvisionalMissions then
        LogDebug("Provisional Missions enabled. Parsing Provisional missions tab")
        yield(Callback.navigateToProvisionalMissionsTab)
        Provisional = {}
        -- Check how many tabs there are currently
        local Tab1Name = GetNodeText("WKSMission", 89, 24, 2)
        ParseMission("Provisional", Provisional, GetNodeText("WKSMission", 89, 2, 8))
        ParseMission("Provisional", Provisional, GetNodeText("WKSMission", 89, 3, 8))
        ParseMission("Provisional", Provisional, GetNodeText("WKSMission", 89, 4, 8))
        ParseMission("Provisional", Provisional, GetNodeText("WKSMission", 89, 5, 8))
        ParseMission("Provisional", Provisional, GetNodeText("WKSMission", 89, 6, 8))
        ParseMission("Provisional", Provisional, GetNodeText("WKSMission", 89, 7, 8))
        ParseMission("Provisional", Provisional, GetNodeText("WKSMission", 89, 8, 8))
        CurrentMissions.Provisional = Provisional
        if (next(Provisional) ~= nil) then
            if Debug then PrintCurrentMissions(CurrentMissions) end
            return CurrentMissions -- Return early because if any is available, should be doing it anyway
        end
    end
    LogDebug("Parsing Basic missions tab")
    yield(Callback.navigateToBasicMissionsTab)
    ClassA = {}
    ClassB = {}
    ClassC = {}
    ClassD = {}
    if (GetNodeText("WKSMission", 89, 24, 2) == "Class A Missions") then
        ParseMission("A", ClassA, GetNodeText("WKSMission", 89, 2, 8))
        ParseMission("A", ClassA, GetNodeText("WKSMission", 89, 2, 8))
        ParseMission("A", ClassA, GetNodeText("WKSMission", 89, 3, 8))
        ParseMission("A", ClassA, GetNodeText("WKSMission", 89, 4, 8))
        ParseMission("A", ClassA, GetNodeText("WKSMission", 89, 5, 8))
        ParseMission("B", ClassB, GetNodeText("WKSMission", 89, 6, 8))
        ParseMission("B", ClassB, GetNodeText("WKSMission", 89, 7, 8))
        ParseMission("B", ClassB, GetNodeText("WKSMission", 89, 8, 8))
        ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 9, 8))
        ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 10, 8))
        ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 11, 8))
        ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 12, 8))
        ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 13, 8))
        ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 14, 8))
    else
        if (GetNodeText("WKSMission", 89, 24, 2) == "Class B Missions") then
            ParseMission("B", ClassB, GetNodeText("WKSMission", 89, 2, 8))
            ParseMission("B", ClassB, GetNodeText("WKSMission", 89, 3, 8))
            ParseMission("B", ClassB, GetNodeText("WKSMission", 89, 4, 8))
            ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 5, 8))
            ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 6, 8))
            ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 7, 8))
            ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 8, 8))
            ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 9, 8))
            ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 10, 8))
        else
            if (GetNodeText("WKSMission", 89, 24, 2) == "Class C Missions") then
                ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 2, 8))
                ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 3, 8))
                ParseMission("C", ClassC, GetNodeText("WKSMission", 89, 4, 8))
                ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 5, 8))
                ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 6, 8))
                ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 7, 8))
            else
                if (GetNodeText("WKSMission", 89, 24, 2) == "Class D Missions") then
                    ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 2, 8))
                    ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 3, 8))
                    ParseMission("D", ClassD, GetNodeText("WKSMission", 89, 4, 8))
                end
            end
        end
    end
    CurrentMissions.ClassA = ClassA
    CurrentMissions.ClassB = ClassB
    CurrentMissions.ClassC = ClassC
    CurrentMissions.ClassD = ClassD
    if Debug then PrintCurrentMissions(CurrentMissions) end
    return CurrentMissions
end

function StartMission()
    MissionObject, MissionCode = SearchForMission(GetCurrentMissions())
    if MissionObject ~= nil and MissionCode ~= nil then
        if Debug then
            LogDebug("Running mission [" .. MissionObject.name .. "] with Mission ID [" .. MissionCode.. "]")
        else
            LogInfo("Running mission " .. MissionObject)
        end

        yield(string.format(Callback.clickMission, MissionCode))
        yield(string.format(Callback.startMission, MissionCode))
        CurrentMission = MissionObject
        DoingMission = true
    end
end

function CheckMissionValidity(CurrenMissionObject)
    LogDebug("Checking if [" .. CurrenMissionObject.name .. "] is set as valid mission")
    if CriticalMissions then
        for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["Critical"]) do
            if MissionObject.name == CurrenMissionObject.name and MissionObject.valid then
                return MissionCode
            end
        end
    end
    if ProvisionalMissions then
        for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["Provisional"]) do
            if MissionObject.name == CurrenMissionObject.name and MissionObject.valid then
                return MissionCode
            end
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["A"]) do
        if MissionObject.name == CurrenMissionObject.name and MissionObject.valid then
            return MissionCode
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["B"]) do
        if MissionObject.name == CurrenMissionObject.name and MissionObject.valid then
            return MissionCode
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["C"]) do
        if MissionObject.name == CurrenMissionObject.name and MissionObject.valid then
            return MissionCode
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["D"]) do
        if MissionObject.name == CurrenMissionObject.name and MissionObject.valid then
            return MissionCode
        end
    end
end

function SearchForMission(CurrentMissionList)
    if CriticalMissions then
        for _, CurrentMissionObject in pairs(CurrentMissionList.Critical) do
            MissionCode = CheckMissionValidity(CurrentMissionObject)
            if MissionCode ~= nil then
                return CurrentMissionObject, MissionCode
            end
        end
    end
    if ProvisionalMissions then
        for _, CurrentMissionObject in pairs(CurrentMissionList.Provisional) do
            MissionCode = CheckMissionValidity(CurrentMissionObject)
            if MissionCode ~= nil then
                return CurrentMissionObject, MissionCode
            end
        end
    end
    for _, CurrentMissionObject in pairs(CurrentMissionList.ClassA) do
        MissionCode = CheckMissionValidity(CurrentMissionObject)
        if MissionCode ~= nil then
            return CurrentMissionObject, MissionCode
        end
    end
    for _, CurrentMissionObject in pairs(CurrentMissionList.ClassB) do
        MissionCode = CheckMissionValidity(CurrentMissionObject)
        if MissionCode ~= nil then
            return CurrentMissionObject, MissionCode
        end
    end
    for _, CurrentMissionObject in pairs(CurrentMissionList.ClassC) do
        MissionCode = CheckMissionValidity(CurrentMissionObject)
        if MissionCode ~= nil then
            return CurrentMissionObject, MissionCode
        end
    end
    for _, CurrentMissionObject in pairs(CurrentMissionList.ClassD) do
        MissionCode = CheckMissionValidity(CurrentMissionObject)
        if MissionCode ~= nil then
            return CurrentMissionObject, MissionCode
        end
    end
    LogInfo("No valid mission found. Aborting script.")
    StopScript = true
end

function SubmitMission()
    LogDebug("Attempting to submit mission")
    if CurrentMission.type and CurrentMission.type == "Critical" then
        if GetNodeText("_ToDoList", 28, 3) == "Deliver to the collection point: 0/1" then
            LogDebug("Critical mission submission") -- TODO vnav to the submission npc
            yield(string.format(Callback.moveToSubmissionPoint, CurrentMission.x, CurrentMission.y, CurrentMission.z))
            while PathIsRunning() do
                LogDebug("Walking to submission point")
                yield("/wait 3")
            end
            LogDebug("Submission point reached")
            yield(string.format(Callback.interactNpc, InteractKeybind))
            yield(string.format(Callback.interactNpc, InteractKeybind))
        end
    else
        LogDebug("Normal mission submission")
        if not IsAddonVisible("WKSMissionInfomation") then
            yield(Callback.openMissionInformationWindow)
        end
        yield(Callback.submitMission)
    end
    if IsAddonVisible("WKSReward") then
        LogInfo("Mission submitted!")
        DoingMission = false
        if Artisan then
            ArtisanSetEnduranceStatus(false)
        end
    end
end

function GetNextCraftableItem()
    LogDebug("Searching for next craftable item")
    local ItemSequence = 0
    local CraftableItemsRemaining = false
    while not CraftableItemsRemaining do
        yield(string.format(Callback.clickNextItemToCraft, ItemSequence))
        if tonumber(GetNodeText("WKSRecipeNotebook", 24)) > 0 then
            LogDebug("Item " .. (ItemSequence + 1) .. " is craftable")
            CraftableItemsRemaining = true
            return (ItemSequence + 1)
        end
        LogDebug("Item " .. ((ItemSequence) + 1) .. " can no longer be crafted. Checking next item")
        ItemSequence = ItemSequence + 1
    end
end

function CraftNextItem()
    LogDebug("Attempting to craft next item")
    if Artisan then
        if not ArtisanGetEnduranceStatus() then
            if not IsAddonVisible("WKSRecipeNotebook") then
                if not IsAddonVisible("WKSMission") then
                    yield(Callback.openMissionInformationWindow)
                end
                yield(Callback.openRecipeWindow)
            end        
            local RecipeItem = GetNextCraftableItem()
            LogInfo("Starting artisan endurance on item number " .. RecipeItem)
            ArtisanSetEnduranceStatus(true)
            yield("/wait 1")
        else
            -- Artisan still in endurance mode. Synthesizing status should still be true. This is usually because Artisan is doing other actions
            LogDebug("Artisan still in endurance mode but synthesizing status has become " .. tostring(Synthesizing) .. ". Re-checking and re-setting the status")
            Synthesizing = GetCharacterCondition(CharacterCondition.crafting) and not GetCharacterCondition(CharacterCondition.preparingToCraft) and IsAddonVisible("Synthesis")
        end
    else
        if not IsAddonVisible("WKSRecipeNotebook") then
            if not IsAddonVisible("WKSMission") then
                yield(Callback.openMissionInformationWindow)
            end
            yield(Callback.openRecipeWindow)
        end    
        local RecipeItem = GetNextCraftableItem()
        LogInfo("Starting synthesis on item number " .. RecipeItem)
        yield(Callback.clickHQButton)
        yield(Callback.startSynthesis)
    end
end

function Repair()
    local CanRepair = CheckIfCanRepair()
    LogDebug("CanRepair : " .. tostring(CanRepair))
    while CanRepair do
        if not IsAddonVisible("Repair") then
            yield(Callback.toggleRepairWindow)
        end
        LogInfo("Repairing ...")
        yield(Callback.repair)
        CanRepair = CheckIfCanRepair()
    end
    -- Nothing else to repair. Close the repair window
    if IsAddonVisible("Repair") then
        yield(Callback.toggleRepairWindow)
    end
end

function ExtractMateria()
    local CanMaterialize = CheckIfCanExtractMateria()
    LogDebug("CanMaterialize : " .. tostring(CanMaterialize))
    while CanMaterialize do
        if not IsAddonVisible("Materialize") then
            yield(Callback.toggleMateriaExtractionWindow)
        end
        if IsAddonVisible("MaterializeDialog") then
            yield(Callback.extractMateriaDialog)
        else
            LogInfo("Extracting materia ...")
            yield(Callback.extractMateria)
        end
        CanMaterialize = CheckIfCanExtractMateria()
    end
    -- No more materia to extract or inventory is full. Close the materialize window
    if IsAddonVisible("Materialize") then
        yield(Callback.toggleMateriaExtractionWindow)
    end
end

function CheckIfCanExtractMateria()
    if CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        LogInfo("Materia extraction available")
        return true
    end
    return false
end

function CheckIfCanRepair()
    if GetItemCount(33916) > 0 and NeedsRepair(RepairAmount) then
        LogInfo("Repair available")
        return true
    end
    if GetItemCount(33916) < 1 then
        LogInfo("Insufficient Dark Matter to repair. Aborting script")
        StopScript = true
        return false
    end
    if not NeedsRepair(RepairAmount) then
        return false
    end
end

--[[
**************************************************************************
*                              Script Body                               *
**************************************************************************
]]

LogInfo("Starting CosmoCraft")
if not CheckRequiredDependencies() then
    LogInfo("Missing dependency required by the script. Aborting script")
    StopScript = true
end
while not StopScript do
    ExtractMateria()
    Repair()
    if StopScript then return end -- Premature ending script, mainly caused by being unable to repair gear
    LogDebug("DoingMission : " .. tostring(DoingMission))
    while not DoingMission do
        if not IsAddonVisible("WKSMission") then
            yield(Callback.openMissionInformationWindow)
        end
        if IsAddonVisible("WKSMission") then
            -- Mission not started
            LogInfo("Searching for a valid mission to start")
            StartMission()
        end
        if StopScript then
            break
        end
    end
    while DoingMission do
        Synthesizing = GetCharacterCondition(CharacterCondition.crafting) and not GetCharacterCondition(CharacterCondition.preparingToCraft) and IsAddonVisible("Synthesis")
        LogDebug("Synthesizing : " .. tostring(Synthesizing))
        if Artisan then
            LogDebug("Endurance : " .. tostring(ArtisanGetEnduranceStatus()))
        end
        LogDebug("Mission : [" .. (CurrentMission.type or "Basic") .. "] " .. CurrentMission.name)
        -- If not mid synthesizing, tries to submit
        if not Synthesizing then
            SubmitMission()
            -- Mission submitted, breaking out of loop
            if not DoingMission then
                LogDebug("No longer doing mission.")
                break
            end
            CraftNextItem()
        end
        if Synthesizing or ArtisanGetEnduranceStatus() then
            yield("/wait 3")
        end
    end
end
