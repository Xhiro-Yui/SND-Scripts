--[[
**************************************************************************
*                                Settings                                *
**************************************************************************
]]
RepairAmount = 99          -- the amount it needs to drop before Repairing (set it to 0 if you don't want it to repair)
CriticalMissions = false    -- Change this manually to true during red alerts to do red alert missions
ProvisionalMissions = true -- Change this manually to true to attempt doing provisional missions when available
Debug = false               -- Change this to true to print debug log to see what the script is doing
CurrentClass = "CRP"       -- SND is broken and can't retrieve self job ID right now so have to manual input
--[[
********************************************************************************
*                           Internal Variables                                  *
********************************************************************************
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
    toggleRepairWindow = "/generalaction repair <wait.1>",
    toggleMateriaExtractionWindow = '/generalaction "Materia Extraction" <wait.1>',
    openMissionInformationWindow = "/callback WKSHud true 11 <wait.1>",
    openRecipeWindow = "/callback WKSMissionInfomation true 14 <wait.1>",
    startSynthesis = "/callback WKSRecipeNotebook true 6 <wait.1>",
    navigateToBasicMissionsTab = "/callback WKSMission true 15 0u <wait.1>",
    navigateToProvisionalMissionsTab = "/callback WKSMission true 15 1u <wait.1>",
    navigateToCriticalMissionsTab = "/callback WKSMission true 15 2u <wait.1>",
    clickMission = "/callback WKSMission true 12 %su 8u 1u <wait.1>",
    startMission = "/callback WKSMission true 13 %su 8u 1u <wait.1>",
    submitMission = "/callback WKSMissionInfomation true 11 <wait.1>",
}
StopScript = false
DoingMission = false
Synthesizing = false
MissionList = {
    ARM = {
        Critical = {
            [518] = { missionName = " Spare Vacuum Tanks", valid = true },
            [519] = { missionName = " Vehicular Plating", valid = true }
        },
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [112] = { missionName = "A-1: Key Facility Plating", valid = false },
            [113] = { missionName = "A-1: Rare Material Processing", valid = true },
            [114] = { missionName = "A-1: Construction Necessities", valid = true },
            [115] = { missionName = "A-1: High-conductivity Culinary Tools", valid = true },
            [116] = { missionName = "A-1: Meteoric Material Test Processing", valid = false },
            [123] = { missionName = "A-1: Hub Furnishings and Fixtures I", valid = true },
            [125] = { missionName = "A-1: Specialized Materials I", valid = true },
            [117] = { missionName = "A-2: Replica Incensories", valid = true },
            [118] = { missionName = "A-2: Fine-grade Material Processing", valid = false },
            [128] = { missionName = "A-2: Starship Building Materials", valid = false },
            [497] = { missionName = "A-2: Impact-resistant Containers", valid = false }
        },
        B = {
            [104] = { missionName = " Rover Parts", valid = true },
            [105] = { missionName = " Standardized Light Plating", valid = true },
            [106] = { missionName = " Worker's Culinary Tools II", valid = true },
            [107] = { missionName = " Beverage Stations", valid = true },
            [108] = { missionName = " Campfire Fixtures", valid = true },
            [109] = { missionName = " Habitation Storage", valid = true },
            [110] = { missionName = " Lunar Material Tool Processing", valid = true },
            [111] = { missionName = " Lunar Material Part Processing", valid = true }
        },
        C = {
            [97] = { missionName = " Standardized Heavy Plating", valid = true },
            [98] = { missionName = " Starship Shafts", valid = true },
            [99] = { missionName = " Worker's Culinary Tools I", valid = true },
            [100] = { missionName = " Standardized Chainmail Sheets", valid = true },
            [101] = { missionName = " Dust-filtering Equipment", valid = true },
            [102] = { missionName = " Custom Parts (Intermediate)", valid = true },
            [103] = { missionName = " Insulated Equipment", valid = true }
        },
        D = {
            [91] = { missionName = " Multi-purpose Plating", valid = true },
            [92] = { missionName = " Spare Starship Parts", valid = true },
            [93] = { missionName = " Alloy Inspection", valid = true },
            [94] = { missionName = " Custom Parts (Simple)", valid = true },
            [95] = { missionName = " Multi-purpose Metal Components", valid = true },
            [96] = { missionName = " Mass-produced Necessities", valid = true }
        }
    },
    CUL = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [337] = { missionName = "A-1: Water-resistant Lubricant", valid = false },
            [338] = { missionName = "A-1: Stellar Adhesive", valid = false },
            [339] = { missionName = "A-1: Liquid Nutrient Supplements", valid = false },
            [340] = { missionName = "A-1: Cafeteria Goods", valid = false },
            [341] = { missionName = "A-1: Lunar Seafood Processing", valid = false },
            [348] = { missionName = "A-1: Worker's Banquet Preparation I", valid = false },
            [350] = { missionName = "A-1: Loporrit Dietary Improvement I", valid = false },
            [342] = { missionName = "A-2: Stable Food Mass Production", valid = false },
            [343] = { missionName = "A-2: Sharlayan Dish Inspection", valid = false },
            [353] = { missionName = "A-2: Aquaculture Feed I", valid = false },
            [504] = { missionName = "A-2: Freshness Preservation", valid = false }
        },
        B = {
            [329] = { missionName = " Experimental Foodstuffs", valid = true },
            [330] = { missionName = " Water-resistant Lubricant", valid = true },
            [331] = { missionName = " Experimental Potables", valid = true },
            [332] = { missionName = " Launch Party Foodstuffs", valid = true },
            [333] = { missionName = " Home-cooked Seafood Meal", valid = true },
            [334] = { missionName = " Nutrient-rich Lunar Food", valid = true },
            [335] = { missionName = " Bakery Inspection", valid = true },
            [336] = { missionName = " Mushroom Processing", valid = true }
        },
        C = {
            [322] = { missionName = " Heat-resistant Lubricant", valid = true },
            [323] = { missionName = " Nutrient-rich Foodstuffs", valid = true },
            [324] = { missionName = " Construction Paint", valid = true },
            [325] = { missionName = " Portable Foodstuffs", valid = true },
            [326] = { missionName = " Nutrient-rich Seafood Processing", valid = true },
            [327] = { missionName = " Emergency Foodstuff Development", valid = true },
            [328] = { missionName = " Essential Whole Meals", valid = true }
        },
        D = {
            [316] = { missionName = " Standard Lubricant", valid = true },
            [317] = { missionName = " Spice Processing", valid = true },
            [318] = { missionName = " Building Adhesive", valid = true },
            [319] = { missionName = " Aquatic Nutrient Concentrate", valid = true },
            [320] = { missionName = " Aquatic Ink", valid = true },
            [321] = { missionName = " Medicated Feed Research", valid = true }
        }
    },
    CRP = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [22] = { missionName = "A-1: High-durability Fiberboard", valid = false },
            [23] = { missionName = "A-1: High-grade Paper", valid = false },
            [24] = { missionName = "A-1: Starship Insulation", valid = false },
            [25] = { missionName = "A-1: High Burn Charcoal", valid = false },
            [26] = { missionName = "A-1: Lunar Flora Test Processing", valid = false },
            [33] = { missionName = "A-1: Power Transmission Shafts I", valid = false },
            [35] = { missionName = "A-1: Specialized Materials I", valid = false },
            [27] = { missionName = "A-2: Test Material Final Processing", valid = false },
            [28] = { missionName = "A-2: Serving Trays", valid = false },
            [38] = { missionName = "A-2: Rest Facility Materials", valid = false },
            [496] = { missionName = "A-2: Aquatic Resource Research Tanks", valid = false }
        },
        B = {
            [14] = { missionName = " Resupplying Containers", valid = true },
            [15] = { missionName = " Thick Fiberboard", valid = true },
            [16] = { missionName = " High-quality Insulation Materials", valid = true },
            [17] = { missionName = " Heat-resistant Resin", valid = true },
            [18] = { missionName = " Long-term Storage Paper", valid = true },
            [19] = { missionName = " Habitation Module Chairs", valid = true },
            [20] = { missionName = " Test Material Gathering Tools", valid = true },
            [21] = { missionName = " High-quality Rest Beds", valid = true }
        },
        C = {
            [7] = { missionName = " Thin Fiberboard", valid = true },
            [8] = { missionName = " Carpentry Provisions", valid = true },
            [9] = { missionName = " Worker's Weaving Tools", valid = true },
            [10] = { missionName = " Data Entry Paper", valid = true },
            [11] = { missionName = " Interior Insulation Materials", valid = true },
            [12] = { missionName = " Cosmoliner Supplies", valid = true },
            [13] = { missionName = " New Material Earrings ", valid = true }
        },
        D = {
            [1] = { missionName = " Multi-purpose Fiberboard", valid = true },
            [2] = { missionName = " Fieldwork Fuel", valid = true },
            [3] = { missionName = " Gathering Miscellany", valid = true },
            [4] = { missionName = " Essential Research Materials", valid = true },
            [5] = { missionName = " Charcoal Longevity Testing", valid = true },
            [6] = { missionName = " General-purpose Bedding ", valid = true }
        }
    },
    BSM = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [67] = { missionName = "A-1: Key Facility Plating", valid = false },
            [68] = { missionName = "A-1: Rare Material Processing", valid = false },
            [69] = { missionName = "A-1: Construction Necessities", valid = false },
            [70] = { missionName = "A-1: Worker's Sheet Metal Tools", valid = false },
            [71] = { missionName = "A-1: Meteoric Material Test Processing", valid = false },
            [78] = { missionName = "A-1: Hub Furnishings and Fixtures I", valid = false },
            [80] = { missionName = "A-1: Specialized Materials I", valid = false },
            [72] = { missionName = "A-2: Replica Far Eastern Furnishings", valid = false },
            [73] = { missionName = "A-2: Fine-grade Material Processing", valid = false },
            [83] = { missionName = "A-2: Starship Building Materials", valid = false },
            [508] = { missionName = "A-2: Processed Aquatic Metals", valid = false }
        },
        B = {
            [59] = { missionName = " Rover Shafts", valid = true },
            [60] = { missionName = "???", valid = false },
            [61] = { missionName = " Worker's Smithing Tools", valid = true },
            [62] = { missionName = " Bathing Fixtures", valid = true },
            [63] = { missionName = " Ceruleum Stoves", valid = true },
            [64] = { missionName = " Habitation Lighting", valid = true },
            [65] = { missionName = " Lunar Material Tool Processing", valid = true },
            [66] = { missionName = " Lunar Material Part Processing", valid = true }
        },
        C = {
            [52] = { missionName = " Standardized Heavy Plating", valid = true },
            [53] = { missionName = " Starship Shafts", valid = true },
            [54] = { missionName = " Worker's Mining Tools", valid = true },
            [55] = { missionName = " Standardized Alloy Rivets", valid = true },
            [56] = { missionName = " Worker's Carpentry Tools", valid = true },
            [57] = { missionName = " Custom Parts (Intermediate)", valid = true },
            [58] = { missionName = " Insulated Equipment", valid = true }
        },
        D = {
            [46] = { missionName = " Multi-purpose Plating", valid = true },
            [47] = { missionName = " Spare Starship Parts", valid = true },
            [48] = { missionName = " Alloy Inspection", valid = true },
            [49] = { missionName = " Custom Parts (Simple)", valid = true },
            [50] = { missionName = " Multi-purpose Metal Components", valid = true },
            [51] = { missionName = " Mass-produced Necessities ", valid = true }
        }
    },
    GSM = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [157] = { missionName = "A-1: Key Facility Plating", valid = false },
            [158] = { missionName = "A-1: Rare Material Processing", valid = false },
            [159] = { missionName = "A-1: Construction Necessities", valid = false },
            [160] = { missionName = "A-1: Fine-grade Knives", valid = false },
            [161] = { missionName = "A-1: Meteoric Material Test Processing", valid = false },
            [168] = { missionName = "A-1: Hub Furnishings and Fixtures I", valid = false },
            [170] = { missionName = "A-1: Specialized Materials I", valid = false },
            [162] = { missionName = "A-2: Replica Bathing Fixtures", valid = false },
            [163] = { missionName = "A-2: Fine-grade Material Processing", valid = false },
            [173] = { missionName = "A-2: Starship Building Materials", valid = false },
            [498] = { missionName = "A-2: Soothing Censers", valid = false }
        },
        B = {
            [149] = { missionName = " Rover Parts", valid = true },
            [150] = { missionName = " Standardized Light Plating", valid = true },
            [151] = { missionName = " Worker's Weaving Tools", valid = true },
            [152] = { missionName = " Observation Devices", valid = true },
            [153] = { missionName = " Fireplace Fixtures", valid = true },
            [154] = { missionName = " Habitation Vanities", valid = true },
            [155] = { missionName = " Lunar Material Tool Processing", valid = true },
            [156] = { missionName = " Lunar Material Part Processing", valid = true }
        },
        C = {
            [142] = { missionName = " Standardized Heavy Plating", valid = true },
            [143] = { missionName = " Starship Shafts", valid = true },
            [144] = { missionName = " Worker's Grinding Tools", valid = true },
            [145] = { missionName = " Standardized Chainmail Sheets", valid = true },
            [146] = { missionName = " Eye Protection Equipment", valid = true },
            [147] = { missionName = " Custom Parts (Intermediate)", valid = true },
            [148] = { missionName = " Heat Dissipation Equipment", valid = true }
        },
        D = {
            [136] = { missionName = " Multi-purpose Plating", valid = true },
            [137] = { missionName = " Spare Starship Parts", valid = true },
            [138] = { missionName = " Alloy Inspection", valid = true },
            [139] = { missionName = " Custom Parts (Simple)", valid = true },
            [140] = { missionName = " Multi-purpose Metal Components", valid = true },
            [141] = { missionName = " Mass-produced Necessities", valid = true }
        }
    },
    ALC = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [292] = { missionName = "A-1: Water-resistant Bricks", valid = false },
            [293] = { missionName = "A-1: Stellar Adhesive", valid = false },
            [294] = { missionName = "A-1: Nutrient Supplements", valid = false },
            [295] = { missionName = "A-1: Cafeteria Goods", valid = false },
            [296] = { missionName = "A-1: Lunar Seafood Processing", valid = false },
            [303] = { missionName = "A-1: Natural Remedy Inspection I", valid = false },
            [305] = { missionName = "A-1: Loporrit Habitat Improvements I", valid = false },
            [297] = { missionName = "A-2: Emergency Potables", valid = false },
            [298] = { missionName = "A-2: Cosmetic Research Materials", valid = false },
            [308] = { missionName = "A-2: Aquaculture Feed I", valid = false },
            [509] = { missionName = "A-2: Refined Moon Gel", valid = false }
        },
        B = {
            [284] = { missionName = " Lunar Spice Processing", valid = true },
            [285] = { missionName = " Water-resistant Bricks", valid = true },
            [286] = { missionName = " Research Medicine", valid = true },
            [287] = { missionName = " Holy Water", valid = true },
            [288] = { missionName = " Lunar Flooring", valid = true },
            [289] = { missionName = " Stellar Nutrients", valid = true },
            [290] = { missionName = " Miniature Gardens", valid = true },
            [291] = { missionName = " Decorative Lunar Plants", valid = true }
        },
        C = {
            [277] = { missionName = " Heat-resistant Bricks", valid = true },
            [278] = { missionName = " Health Drinks", valid = true },
            [279] = { missionName = " Construction Paint", valid = true },
            [280] = { missionName = " Traditional Veneer", valid = true },
            [281] = { missionName = " Night Lighting", valid = true },
            [282] = { missionName = " Emergency Foodstuffs Development", valid = true },
            [283] = { missionName = " Experimental Potables", valid = true }
        },
        D = {
            [271] = { missionName = " Foundation Bricks", valid = true },
            [272] = { missionName = " Spice Processing", valid = true },
            [273] = { missionName = " Building Adhesive", valid = true },
            [274] = { missionName = " Nutrient Supplements", valid = true },
            [275] = { missionName = " Aquatic Adhesive", valid = true },
            [276] = { missionName = " Medicated Feed Research", valid = true }
        }
    },
    LTW = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [202] = { missionName = "A-1: High-durability Leather String", valid = false },
            [203] = { missionName = "A-1: High-grade Paper", valid = false },
            [204] = { missionName = "A-1: Research Plant Rug", valid = false },
            [205] = { missionName = "A-1: Thermal Leather", valid = false },
            [206] = { missionName = "A-1: Lunar Flora Test Processing", valid = false },
            [213] = { missionName = "A-1: Base Supplies I", valid = false },
            [215] = { missionName = "A-1: Specialized Materials I", valid = false },
            [207] = { missionName = "A-2: Test Material Final Processing", valid = false },
            [208] = { missionName = "A-2: Work Pouches", valid = false },
            [218] = { missionName = "A-2: Rest Facility Materials", valid = false }
        },
        B = {
            [194] = { missionName = " Leather First-aid Bags", valid = true },
            [195] = { missionName = " Sterile Leather String", valid = true },
            [196] = { missionName = " High-grade Rugs", valid = true },
            [197] = { missionName = " Transport Leather", valid = true },
            [198] = { missionName = " Long-term Storage Paper", valid = true },
            [199] = { missionName = " High-grade Rest Chairs", valid = true },
            [200] = { missionName = " Test Material Gloves", valid = true },
            [201] = { missionName = " High-grade Rest Lounges", valid = true }
        },
        C = {
            [187] = { missionName = " Heat-resistant Leather String", valid = true },
            [188] = { missionName = " Worker's Bags", valid = true },
            [189] = { missionName = " Worker's Belts", valid = true },
            [190] = { missionName = " High-grade Paper", valid = true },
            [191] = { missionName = " Sheep Rugs", valid = true },
            [192] = { missionName = " Cosmoliner Materials", valid = true },
            [193] = { missionName = " New Material Jackets", valid = true }
        },
        D = {
            [181] = { missionName = " Multi-purpose Leather Straps", valid = true },
            [182] = { missionName = " First-aid Leather", valid = true },
            [183] = { missionName = " Gatherer's Gloves", valid = true },
            [184] = { missionName = " Essential Research Materials", valid = true },
            [185] = { missionName = " Work Pouches", valid = true },
            [186] = { missionName = " Leather Room Shoes", valid = true }
        }
    },
    WVR = {
        Critical = {},
        Sequential = {},
        Time = {},
        Weather = {},
        A = {
            [247] = { missionName = "A-1: High-durability Yarn", valid = false },
            [248] = { missionName = "A-1: High-grade Composite Fiber", valid = false },
            [249] = { missionName = "A-1: High-grade Bedroom Curtains", valid = false },
            [250] = { missionName = "A-1: First-aid Bandaging", valid = false },
            [251] = { missionName = "A-1: Lunar Flora Test Processing", valid = false },
            [258] = { missionName = "A-1: Cosmoliner Materials I", valid = false },
            [260] = { missionName = "A-1: Specialized Materials I", valid = false },
            [252] = { missionName = "A-2: Test Material Final Processing", valid = false },
            [253] = { missionName = "A-2: Weaving Materials", valid = false },
            [263] = { missionName = "A-2: Rest Facility Materials", valid = false },
            [999] = { missionName = "???", valid = false } -- 999 placeholder
        },
        B = {
            [239] = { missionName = " Work Rope", valid = true },
            [240] = { missionName = " Sterile Yarn", valid = true },
            [241] = { missionName = " High-grade Curtains", valid = true },
            [242] = { missionName = " Transport Yarn", valid = true },
            [243] = { missionName = " Heat-resistant Composite Fiber", valid = true },
            [244] = { missionName = " Rest Supplies", valid = true },
            [245] = { missionName = " Test Material Hats", valid = true },
            [246] = { missionName = " Rest Cushions", valid = true }
        },
        C = {
            [232] = { missionName = " Heat-resistant Yarn", valid = true },
            [233] = { missionName = " Room Garments", valid = true },
            [234] = { missionName = " Multi-purpose Fabric", valid = true },
            [235] = { missionName = " Composite Fiber", valid = true },
            [236] = { missionName = " Infirmary Curtains", valid = true },
            [237] = { missionName = " Cosmoliner Materials", valid = true },
            [238] = { missionName = " New Material Trousers", valid = true }
        },
        D = {
            [226] = { missionName = " Multi-purpose Yarn", valid = true },
            [227] = { missionName = " First-aid Cloth", valid = true },
            [228] = { missionName = " Gatherer's Helmets", valid = true },
            [229] = { missionName = " Essential Research Materials", valid = true },
            [230] = { missionName = " Multi-purpose String", valid = true },
            [231] = { missionName = " Divider Curtains", valid = true }
        }
    }
}
--[[
********************************************************************************
*                            Internal Functions                                *
********************************************************************************
]]
function LogDebug(val)
    if Debug then
        yield("/echo [Debug] " .. val)
    end
end

function LogInfo(val)
    yield("/echo [Info] " .. val)
end

function PrintCurrentMissions(CurrentMissions)
    for MissionType, MissionList in pairs(CurrentMissions) do
        LogDebug("[CurrentMissions] Mission Type : " .. MissionType)
        for _, MissionName in pairs(MissionList) do
            LogDebug("[CurrentMissions] -> " .. MissionName)
        end
        LogDebug("[CurrentMissions] ------")
    end
end

function GetMissionClass(MissionType, MissionName)
    LogDebug("Searching for [" .. MissionName .. "] in ".. MissionType .. " Mission List for " .. CurrentClass)
    for _, MissionObject in pairs(MissionList[CurrentClass][MissionType]) do
        if MissionObject.missionName == MissionName then
            return true
        end
    end
    -- Mission not found in mission list. This can be due to unknown missions that has not been documented or there is an error on the mission list
    LogDebug("Unable to find [" .. MissionName .. "] in Mission List. Skipping")
    return false
end

function ParseNonBasicMission(MissionType, MissionTable, MissionName)
    if MissionName ~= nil then
        if GetMissionClass(MissionType, MissionName) then
            table.insert(MissionTable, MissionName)
        end
    end
end

function GetCurrentMissions()
    Missions = {}
    if CriticalMissions then
        -- TODO Parse the class icon as critical missions lists all missions including other job missions
        LogDebug("Critical Missions enabled. Parsing Critical missions tab")
        yield(Callback.navigateToCriticalMissionsTab)
        Critical = {}
        Missions.Critical = Critical
        if (next(Critical) ~= nil) then
            if Debug then PrintCurrentMissions(Missions) end
            return Missions -- Return early because if any is available, should be doing it anyway
        end
    end
    if ProvisionalMissions then
        LogDebug("Provisional Missions enabled. Parsing Provisional missions tab")
        yield(Callback.navigateToProvisionalMissionsTab)
        Sequential = {}
        Time = {}
        Weather = {}
        if GetNodeText("WKSMission", 89, 24, 2) == "Time-restricted Missions" then
            ParseNonBasicMission("Time", Time, GetNodeText("WKSMission", 89, 2, 8))
        end
        if GetNodeText("WKSMission", 89, 24, 2) == "Weather-restricted Missions" then
            ParseNonBasicMission("Weather", Weather, GetNodeText("WKSMission", 89, 2, 8))
        end

        Missions.Sequential = Sequential
        Missions.Time = Time
        Missions.Weather = Weather
        if (next(Sequential) ~= nil or next(Time) ~= nil or next(Weather) ~= nil) then
            if Debug then PrintCurrentMissions(Missions) end
            return Missions -- Return early because if any is available, should be doing it anyway
        end
    end
    LogDebug("Parsing Basic missions tab")
    yield(Callback.navigateToBasicMissionsTab)
    ClassA = {}
    ClassB = {}
    ClassC = {}
    ClassD = {}
    if (GetNodeText("WKSMission", 89, 24, 2) == "Class A Missions") then
        table.insert(ClassA, GetNodeText("WKSMission", 89, 2, 8))
        table.insert(ClassA, GetNodeText("WKSMission", 89, 3, 8))
        table.insert(ClassA, GetNodeText("WKSMission", 89, 4, 8))
        table.insert(ClassA, GetNodeText("WKSMission", 89, 5, 8))
        table.insert(ClassB, GetNodeText("WKSMission", 89, 6, 8))
        table.insert(ClassB, GetNodeText("WKSMission", 89, 7, 8))
        table.insert(ClassB, GetNodeText("WKSMission", 89, 8, 8))
        table.insert(ClassC, GetNodeText("WKSMission", 89, 9, 8))
        table.insert(ClassC, GetNodeText("WKSMission", 89, 10, 8))
        table.insert(ClassC, GetNodeText("WKSMission", 89, 11, 8))
        table.insert(ClassD, GetNodeText("WKSMission", 89, 12, 8))
        table.insert(ClassD, GetNodeText("WKSMission", 89, 13, 8))
        table.insert(ClassD, GetNodeText("WKSMission", 89, 14, 8))
    else
        if (GetNodeText("WKSMission", 89, 24, 2) == "Class B Missions") then
            table.insert(ClassB, GetNodeText("WKSMission", 89, 2, 8))
            table.insert(ClassB, GetNodeText("WKSMission", 89, 3, 8))
            table.insert(ClassB, GetNodeText("WKSMission", 89, 4, 8))
            table.insert(ClassC, GetNodeText("WKSMission", 89, 5, 8))
            table.insert(ClassC, GetNodeText("WKSMission", 89, 6, 8))
            table.insert(ClassC, GetNodeText("WKSMission", 89, 7, 8))
            table.insert(ClassD, GetNodeText("WKSMission", 89, 8, 8))
            table.insert(ClassD, GetNodeText("WKSMission", 89, 9, 8))
            table.insert(ClassD, GetNodeText("WKSMission", 89, 10, 8))
        else
            if (GetNodeText("WKSMission", 89, 24, 2) == "Class C Missions") then
                table.insert(ClassC, GetNodeText("WKSMission", 89, 2, 8))
                table.insert(ClassC, GetNodeText("WKSMission", 89, 3, 8))
                table.insert(ClassC, GetNodeText("WKSMission", 89, 4, 8))
                table.insert(ClassD, GetNodeText("WKSMission", 89, 5, 8))
                table.insert(ClassD, GetNodeText("WKSMission", 89, 6, 8))
                table.insert(ClassD, GetNodeText("WKSMission", 89, 7, 8))
            else
                if (GetNodeText("WKSMission", 89, 24, 2) == "Class D Missions") then
                    table.insert(ClassD, GetNodeText("WKSMission", 89, 2, 8))
                    table.insert(ClassD, GetNodeText("WKSMission", 89, 3, 8))
                    table.insert(ClassD, GetNodeText("WKSMission", 89, 4, 8))
                end
            end
        end
    end
    Missions.ClassA = ClassA
    Missions.ClassB = ClassB
    Missions.ClassC = ClassC
    Missions.ClassD = ClassD
    if Debug then PrintCurrentMissions(Missions) end
    return Missions
end

function StartMission()
    MissionName, MissionCode = SearchForMission(GetCurrentMissions())
    if MissionName ~= nil and MissionCode ~= nil then
        LogInfo("Running mission [" .. MissionName .. "] with Mission ID [" .. MissionCode.. "]")
        yield(string.format(Callback.clickMission, MissionCode))
        yield(string.format(Callback.startMission, MissionCode))
        DoingMission = true
    end
end

function CheckMissionValidity(MissionName)
    LogDebug("Checking if [" .. MissionName .. "] is set as valid mission")
    if CriticalMissions then
        for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["Critical"]) do
            if MissionObject.missionName == MissionName and MissionObject.valid then
                return MissionCode
            end
        end
    end
    if ProvisionalMissions then
        for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["Sequential"]) do
            if MissionObject.missionName == MissionName and MissionObject.valid then
                return MissionCode
            end
        end
        for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["Time"]) do
            if MissionObject.missionName == MissionName and MissionObject.valid then
                return MissionCode
            end
        end
        for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["Weather"]) do
            if MissionObject.missionName == MissionName and MissionObject.valid then
                return MissionCode
            end
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["A"]) do
        if MissionObject.missionName == MissionName and MissionObject.valid then
            return MissionCode
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["B"]) do
        if MissionObject.missionName == MissionName and MissionObject.valid then
            return MissionCode
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["C"]) do
        if MissionObject.missionName == MissionName and MissionObject.valid then
            return MissionCode
        end
    end
    for MissionCode, MissionObject in pairs(MissionList[CurrentClass]["D"]) do
        if MissionObject.missionName == MissionName and MissionObject.valid then
            return MissionCode
        end
    end
end

function SearchForMission(CurrentMissionList)
    if CriticalMissions then
        for _, CurrentMissionName in pairs(CurrentMissionList.Critical) do
            MissionCode = CheckMissionValidity(CurrentMissionName)
            if MissionCode ~= nil then
                return CurrentMissionName, MissionCode
            end
        end
    end
    if ProvisionalMissions then
        for _, CurrentMissionName in pairs(CurrentMissionList.Sequential) do
            MissionCode = CheckMissionValidity(CurrentMissionName)
            if MissionCode ~= nil then
                return CurrentMissionName, MissionCode
            end
        end
        for _, CurrentMissionName in pairs(CurrentMissionList.Time) do
            MissionCode = CheckMissionValidity(CurrentMissionName)
            if MissionCode ~= nil then
                return CurrentMissionName, MissionCode
            end
        end
        for _, CurrentMissionName in pairs(CurrentMissionList.Weather) do
            MissionCode = CheckMissionValidity(CurrentMissionName)
            if MissionCode ~= nil then
                return CurrentMissionName, MissionCode
            end
        end
    end
    for _, CurrentMissionName in pairs(CurrentMissionList.ClassA) do
        MissionCode = CheckMissionValidity(CurrentMissionName)
        if MissionCode ~= nil then
            return CurrentMissionName, MissionCode
        end
    end
    LogInfo("No suitable A mission found. Searching for B mission.")
    for _, CurrentMissionName in pairs(CurrentMissionList.ClassB) do
        MissionCode = CheckMissionValidity(CurrentMissionName)
        if MissionCode ~= nil then
            return CurrentMissionName, MissionCode
        end
    end
    LogInfo("No suitable B mission found. Searching for C mission.")
    for _, CurrentMissionName in pairs(CurrentMissionList.ClassC) do
        MissionCode = CheckMissionValidity(CurrentMissionName)
        if MissionCode ~= nil then
            return CurrentMissionName, MissionCode
        end
    end
    LogInfo("No suitable C mission found. Searching for D mission.")
    for _, CurrentMissionName in pairs(CurrentMissionList.ClassD) do
        MissionCode = CheckMissionValidity(CurrentMissionName)
        if MissionCode ~= nil then
            return CurrentMissionName, MissionCode
        end
    end
    LogInfo("No suitable mission found. Aborting script.")
    StopScript = true

end

function SubmitMission()
    if not IsAddonVisible("WKSMissionInfomation") then
        yield(Callback.openMissionInformationWindow)
    end
    yield(Callback.submitMission)
    if IsAddonVisible("WKSReward") then
        LogInfo("Mission submitted!")
        DoingMission = false
    end
end

function Repair()
    CanRepair = CheckIfCanRepair()
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
    CanMaterialize = CheckIfCanExtractMateria()
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
********************************************************************************
*                            Script Body                                       *
********************************************************************************
]]

LogInfo("Starting CosmoCraft v1.0")
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
        -- Update if character is synthesizing
        Synthesizing =
            GetCharacterCondition(CharacterCondition.crafting) and
            not GetCharacterCondition(CharacterCondition.preparingToCraft)

        LogDebug("DoingMission : " .. tostring(DoingMission))
        LogDebug("Character is synthesizing : " .. tostring(Synthesizing))

        -- Mid synthesizing, wait awhile before rechecking
        if Synthesizing then
            LogInfo("Waiting for synthesis to finish <wait.3>")
        end
        -- If not mid synthesizing, tries to submit
        if not Synthesizing then
            SubmitMission()
            -- Mission submitted, breaking out of loop
            if not DoingMission then
                break
            end
            -- Mission failed to submit, continue crafting
            if not IsAddonVisible("WKSRecipeNotebook") then
                -- Opens Recipe Book. Mission information window should already be opened.
                yield(Callback.openRecipeWindow)
            end
            LogInfo("Starting synthesis")
            yield(Callback.startSynthesis)
        end
    end
end
