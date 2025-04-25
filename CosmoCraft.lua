--[[
**************************************************************************
*                                Settings                                *
**************************************************************************
]]
RepairAmount = 20 -- the amount it needs to drop before Repairing (set it to 0 if you don't want it to repair)
RedAlert = false -- Change this manually to true during red alerts to do red alert missions
Debug = true -- Change this to true to print debug log to see what the script is doing
CurrentClass = "ALC" -- SND is broken and can't retrieve self job ID right now so have to manual input
FallbackQuest = true -- Change this to true to select a lower difficulty quest if no valid A quests are available
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
    toggleMateriaExtractionWindow = '/generalaction "Materia Extraction" <wait.1>',
    openMissionInformationWindow = "/callback WKSHud true 11 <wait.1>",
    openRecipeWindow = "/callback WKSMissionInfomation true 14 <wait.1>",
    startSynthesis = "/callback WKSRecipeNotebook true 6 <wait.1>",
    navigateToBasicMissionTab = "/callback WKSMission true 15 0u <wait.1>",
    clickMission = "/callback WKSMission true 12 %su 8u 1u <wait.1>",
    startMission = "/callback WKSMission true 13 %su 8u 1u <wait.1>",
    submitMission = "/callback WKSMissionInfomation true 11 <wait.1>"
}
StopScript = false
DoingMission = false
Synthesizing = false
QuestList = {
    ARM = {
        Red = {
            [518] = {questName = " Spare Vacuum Tanks", valid = true},
            [519] = {questName = " Vehicular Plating", valid = true}
        },
        A = {
            [112] = {questName = "A-1: Key Facility Plating", valid = false},
            [113] = {questName = "A-1: Rare Material Processing", valid = true},
            [114] = {questName = "A-1: Construction Necessities", valid = true},
            [115] = {questName = "A-1: High-conductivity Culinary Tools", valid = true},
            [116] = {questName = "A-1: Meteoric Material Test Processing", valid = false},
            [123] = {questName = "A-1: Hub Furnishings and Fixtures I", valid = true},
            [125] = {questName = "A-1: Specialized Materials I", valid = true},
            [117] = {questName = "A-2: Replica Incensories", valid = true},
            [118] = {questName = "A-2: Fine-grade Material Processing", valid = false},
            [128] = {questName = "A-2: Starship Building Materials", valid = false},
            [497] = {questName = "A-2: Impact-resistant Containers", valid = false}
        },
        B = {
            [104] = {questName = " Rover Parts", valid = true},
            [105] = {questName = " Standardized Light Plating", valid = true},
            [106] = {questName = " Worker's Culinary Tools II", valid = true},
            [107] = {questName = " Beverage Stations", valid = true},
            [108] = {questName = " Campfire Fixtures", valid = true},
            [109] = {questName = " Habitation Storage", valid = true},
            [110] = {questName = " Lunar Material Tool Processing", valid = true},
            [111] = {questName = " Lunar Material Part Processing", valid = true}
        },
        C = {
            [97] = {questName = " Standardized Heavy Plating", valid = true},
            [98] = {questName = " Starship Shafts", valid = true},
            [99] = {questName = " Worker's Culinary Tools I", valid = true},
            [100] = {questName = " Standardized Chainmail Sheets", valid = true},
            [101] = {questName = " Dust-filtering Equipment", valid = true},
            [102] = {questName = " Custom Parts (Intermediate)", valid = true},
            [103] = {questName = " Insulated Equipment", valid = true}
        },
        D = {
            [91] = {questName = " Multi-purpose Plating", valid = true},
            [92] = {questName = " Spare Starship Parts", valid = true},
            [93] = {questName = " Alloy Inspection", valid = true},
            [94] = {questName = " Custom Parts (Simple)", valid = true},
            [95] = {questName = " Multi-purpose Metal Components", valid = true},
            [96] = {questName = " Mass-produced Necessities", valid = true}
        }
    },
    CUL = {
        Red = {},
        A = {
            [337] = {questName = "A-1: Water-resistant Lubricant", valid = false},
            [338] = {questName = "A-1: Stellar Adhesive", valid = false},
            [339] = {questName = "A-1: Liquid Nutrient Supplements", valid = false},
            [340] = {questName = "A-1: Cafeteria Goods", valid = false},
            [341] = {questName = "A-1: Lunar Seafood Processing", valid = false},
            [348] = {questName = "A-1: Worker's Banquet Preparation I", valid = false},
            [350] = {questName = "A-1: Loporrit Dietary Improvement I", valid = false},
            [342] = {questName = "A-2: Stable Food Mass Production", valid = false},
            [343] = {questName = "A-2: Sharlayan Dish Inspection", valid = false},
            [353] = {questName = "A-2: Aquaculture Feed I", valid = false},
            [504] = {questName = "A-2: Freshness Preservation", valid = false}
        },
        B = {
            [329] = {questName = " Experimental Foodstuffs", valid = true},
            [330] = {questName = " Water-resistant Lubricant", valid = true},
            [331] = {questName = " Experimental Potables", valid = true},
            [332] = {questName = " Launch Party Foodstuffs", valid = true},
            [333] = {questName = " Home-cooked Seafood Meal", valid = true},
            [334] = {questName = " Nutrient-rich Lunar Food", valid = true},
            [335] = {questName = " Bakery Inspection", valid = true},
            [336] = {questName = " Mushroom Processing", valid = true}
        },
        C = {
            [322] = {questName = " Heat-resistant Lubricant", valid = true},
            [323] = {questName = " Nutrient-rich Foodstuffs", valid = true},
            [324] = {questName = " Construction Paint", valid = true},
            [325] = {questName = " Portable Foodstuffs", valid = true},
            [326] = {questName = " Nutrient-rich Seafood Processing", valid = true},
            [327] = {questName = " Emergency Foodstuff Development", valid = true},
            [328] = {questName = " Essential Whole Meals", valid = true}
        },
        D = {
            [316] = {questName = " Standard Lubricant", valid = true},
            [317] = {questName = " Spice Processing", valid = true},
            [318] = {questName = " Building Adhesive", valid = true},
            [319] = {questName = " Aquatic Nutrient Concentrate", valid = true},
            [320] = {questName = " Aquatic Ink", valid = true},
            [321] = {questName = " Medicated Feed Research", valid = true}
        }
    },
    CRP = {
        Red = {},
        A = {
            [22] = {questName = "A-1: High-durability Fiberboard", valid = false},
            [23] = {questName = "A-1: High-grade Paper", valid = false},
            [24] = {questName = "A-1: Starship Insulation", valid = false},
            [25] = {questName = "A-1: High Burn Charcoal", valid = false},
            [26] = {questName = "A-1: Lunar Flora Test Processing", valid = false},
            [33] = {questName = "A-1: Power Transmission Shafts I", valid = false},
            [35] = {questName = "A-1: Specialized Materials I", valid = false},
            [27] = {questName = "A-2: Test Material Final Processing", valid = false},
            [28] = {questName = "A-2: Serving Trays", valid = false},
            [38] = {questName = "A-2: Rest Facility Materials", valid = false},
            [496] = {questName = "A-2: Aquatic Resource Research Tanks", valid = false}
        },
        B = {
            [14] = {questName = " Resupplying Containers", valid = true},
            [15] = {questName = " Thick Fiberboard", valid = true},
            [16] = {questName = " High-quality Insulation Materials", valid = true},
            [17] = {questName = " Heat-resistant Resin", valid = true},
            [18] = {questName = " Long-term Storage Paper", valid = true},
            [19] = {questName = " Habitation Module Chairs", valid = true},
            [20] = {questName = " Test Material Gathering Tools", valid = true},
            [21] = {questName = " High-quality Rest Beds", valid = true}
        },
        C = {
            [7] = {questName = " Thin Fiberboard", valid = true},
            [8] = {questName = " Carpentry Provisions", valid = true},
            [9] = {questName = " Worker's Weaving Tools", valid = true},
            [10] = {questName = " Data Entry Paper", valid = true},
            [11] = {questName = " Interior Insulation Materials", valid = true},
            [12] = {questName = " Cosmoliner Supplies", valid = true},
            [13] = {questName = " New Material Earrings ", valid = true}
        },
        D = {
            [1] = {questName = " Multi-purpose Fiberboard", valid = true},
            [2] = {questName = " Fieldwork Fuel", valid = true},
            [3] = {questName = " Gathering Miscellany", valid = true},
            [4] = {questName = " Essential Research Materials", valid = true},
            [5] = {questName = " Charcoal Longevity Testing", valid = true},
            [6] = {questName = " General-purpose Bedding ", valid = true}
        }
    },
    BSM = {
        Red = {},
        A = {
            [67] = {questName = "A-1: Key Facility Plating", valid = false},
            [68] = {questName = "A-1: Rare Material Processing", valid = false},
            [69] = {questName = "A-1: Construction Necessities", valid = false},
            [70] = {questName = "A-1: Worker's Sheet Metal Tools", valid = false},
            [71] = {questName = "A-1: Meteoric Material Test Processing", valid = false},
            [78] = {questName = "A-1: Hub Furnishings and Fixtures I", valid = false},
            [80] = {questName = "A-1: Specialized Materials I", valid = false},
            [72] = {questName = "A-2: Replica Far Eastern Furnishings", valid = false},
            [73] = {questName = "A-2: Fine-grade Material Processing", valid = false},
            [83] = {questName = "A-2: Starship Building Materials", valid = false},
            [508] = {questName = "A-2: Processed Aquatic Metals", valid = false}
        },
        B = {
            [59] = {questName = " Rover Shafts", valid = true},
            [60] = {questName = "???", valid = false},
            [61] = {questName = " Worker's Smithing Tools", valid = true},
            [62] = {questName = " Bathing Fixtures", valid = true},
            [63] = {questName = " Ceruleum Stoves", valid = true},
            [64] = {questName = " Habitation Lighting", valid = true},
            [65] = {questName = " Lunar Material Tool Processing", valid = true},
            [66] = {questName = " Lunar Material Part Processing", valid = true}
        },
        C = {
            [52] = {questName = " Standardized Heavy Plating", valid = true},
            [53] = {questName = " Starship Shafts", valid = true},
            [54] = {questName = " Worker's Mining Tools", valid = true},
            [55] = {questName = " Standardized Alloy Rivets", valid = true},
            [56] = {questName = " Worker's Carpentry Tools", valid = true},
            [57] = {questName = " Custom Parts (Intermediate)", valid = true},
            [58] = {questName = " Insulated Equipment", valid = true}
        },
        D = {
            [46] = {questName = " Multi-purpose Plating", valid = true},
            [47] = {questName = " Spare Starship Parts", valid = true},
            [48] = {questName = " Alloy Inspection", valid = true},
            [49] = {questName = " Custom Parts (Simple)", valid = true},
            [50] = {questName = " Multi-purpose Metal Components", valid = true},
            [51] = {questName = " Mass-produced Necessities ", valid = true}
        }
    },
    GSM = {
        Red = {},
        A = {
            [157] = {questName = "A-1: Key Facility Plating", valid = false},
            [158] = {questName = "A-1: Rare Material Processing", valid = false},
            [159] = {questName = "A-1: Construction Necessities", valid = false},
            [160] = {questName = "A-1: Fine-grade Knives", valid = false},
            [161] = {questName = "A-1: Meteoric Material Test Processing", valid = false},
            [168] = {questName = "A-1: Hub Furnishings and Fixtures I", valid = false},
            [170] = {questName = "A-1: Specialized Materials I", valid = false},
            [162] = {questName = "A-2: Replica Bathing Fixtures", valid = false},
            [163] = {questName = "A-2: Fine-grade Material Processing", valid = false},
            [173] = {questName = "A-2: Starship Building Materials", valid = false},
            [498] = {questName = "A-2: Soothing Censers", valid = false}
        },
        B = {
            [149] = {questName = " Rover Parts", valid = true},
            [150] = {questName = " Standardized Light Plating", valid = true},
            [151] = {questName = " Worker's Weaving Tools", valid = true},
            [152] = {questName = " Observation Devices", valid = true},
            [153] = {questName = " Fireplace Fixtures", valid = true},
            [154] = {questName = " Habitation Vanities", valid = true},
            [155] = {questName = " Lunar Material Tool Processing", valid = true},
            [156] = {questName = " Lunar Material Part Processing", valid = true}
        },
        C = {
            [142] = {questName = " Standardized Heavy Plating", valid = true},
            [143] = {questName = " Starship Shafts", valid = true},
            [144] = {questName = " Worker's Grinding Tools", valid = true},
            [145] = {questName = " Standardized Chainmail Sheets", valid = true},
            [146] = {questName = " Eye Protection Equipment", valid = true},
            [147] = {questName = " Custom Parts (Intermediate)", valid = true},
            [148] = {questName = " Heat Dissipation Equipment", valid = true}
        },
        D = {
            [136] = {questName = " Multi-purpose Plating", valid = true},
            [137] = {questName = " Spare Starship Parts", valid = true},
            [138] = {questName = " Alloy Inspection", valid = true},
            [139] = {questName = " Custom Parts (Simple)", valid = true},
            [140] = {questName = " Multi-purpose Metal Components", valid = true},
            [141] = {questName = " Mass-produced Necessities", valid = true}
        }
    },
    ALC = {
        Red = {},
        A = {
            [292] = {questName = "A-1: Water-resistant Bricks", valid = false},
            [293] = {questName = "A-1: Stellar Adhesive", valid = false},
            [294] = {questName = "A-1: Nutrient Supplements", valid = false},
            [295] = {questName = "A-1: Cafeteria Goods", valid = false},
            [296] = {questName = "A-1: Lunar Seafood Processing", valid = false},
            [303] = {questName = "A-1: Natural Remedy Inspection I", valid = false},
            [305] = {questName = "A-1: Loporrit Habitat Improvements I", valid = false},
            [297] = {questName = "A-2: Emergency Potables", valid = false},
            [298] = {questName = "A-2: Cosmetic Research Materials", valid = false},
            [308] = {questName = "A-2: Aquaculture Feed I", valid = false},
            [509] = {questName = "A-2: Refined Moon Gel", valid = false}
        },
        B = {
            [284] = {questName = " Lunar Spice Processing", valid = true},
            [285] = {questName = " Water-resistant Bricks", valid = true},
            [286] = {questName = " Research Medicine", valid = true},
            [287] = {questName = " Holy Water", valid = true},
            [288] = {questName = " Lunar Flooring", valid = true},
            [289] = {questName = " Stellar Nutrients", valid = true},
            [290] = {questName = " Miniature Gardens", valid = true},
            [291] = {questName = " Decorative Lunar Plants", valid = true}
        },
        C = {
            [277] = {questName = " Heat-resistant Bricks", valid = true},
            [278] = {questName = " Health Drinks", valid = true},
            [279] = {questName = " Construction Paint", valid = true},
            [280] = {questName = " Traditional Veneer", valid = true},
            [281] = {questName = " Night Lighting", valid = true},
            [282] = {questName = " Emergency Foodstuffs Development", valid = true},
            [283] = {questName = " Experimental Potables", valid = true}
        },
        D = {
            [271] = {questName = " Foundation Bricks", valid = true},
            [272] = {questName = " Spice Processing", valid = true},
            [273] = {questName = " Building Adhesive", valid = true},
            [274] = {questName = " Nutrient Supplements", valid = true},
            [275] = {questName = " Aquatic Adhesive", valid = true},
            [276] = {questName = " Medicated Feed Research", valid = true}
        }
    },
    LTW = {
        Red = {},
        A = {
            [202] = {questName = "A-1: High-durability Leather String", valid = false},
            [203] = {questName = "A-1: High-grade Paper", valid = false},
            [204] = {questName = "A-1: Research Plant Rug", valid = false},
            [205] = {questName = "A-1: Thermal Leather", valid = false},
            [206] = {questName = "A-1: Lunar Flora Test Processing", valid = false},
            [213] = {questName = "A-1: Base Supplies I", valid = false},
            [215] = {questName = "A-1: Specialized Materials I", valid = false},
            [207] = {questName = "A-2: Test Material Final Processing", valid = false},
            [208] = {questName = "A-2: Work Pouches", valid = false},
            [218] = {questName = "A-2: Rest Facility Materials", valid = false}
        },
        B = {
            [194] = {questName = " Leather First-aid Bags", valid = true},
            [195] = {questName = " Sterile Leather String", valid = true},
            [196] = {questName = " High-grade Rugs", valid = true},
            [197] = {questName = " Transport Leather", valid = true},
            [198] = {questName = " Long-term Storage Paper", valid = true},
            [199] = {questName = " High-grade Rest Chairs", valid = true},
            [200] = {questName = " Test Material Gloves", valid = true},
            [201] = {questName = " High-grade Rest Lounges", valid = true}
        },
        C = {
            [187] = {questName = " Heat-resistant Leather String", valid = true},
            [188] = {questName = " Worker's Bags", valid = true},
            [189] = {questName = " Worker's Belts", valid = true},
            [190] = {questName = " High-grade Paper", valid = true},
            [191] = {questName = " Sheep Rugs", valid = true},
            [192] = {questName = " Cosmoliner Materials", valid = true},
            [193] = {questName = " New Material Jackets", valid = true}
        },
        D = {
            [181] = {questName = " Multi-purpose Leather Straps", valid = true},
            [182] = {questName = " First-aid Leather", valid = true},
            [183] = {questName = " Gatherer's Gloves", valid = true},
            [184] = {questName = " Essential Research Materials", valid = true},
            [185] = {questName = " Work Pouches", valid = true},
            [186] = {questName = " Leather Room Shoes", valid = true}
        }
    },
    WVR = {
        Red = {},
        A = {
            [247] = {questName = "A-1: High-durability Yarn", valid = false},
            [248] = {questName = "A-1: High-grade Composite Fiber", valid = false},
            [249] = {questName = "A-1: High-grade Bedroom Curtains", valid = false},
            [250] = {questName = "A-1: First-aid Bandaging", valid = false},
            [251] = {questName = "A-1: Lunar Flora Test Processing", valid = false},
            [258] = {questName = "A-1: Cosmoliner Materials I", valid = false},
            [260] = {questName = "A-1: Specialized Materials I", valid = false},
            [252] = {questName = "A-2: Test Material Final Processing", valid = false},
            [253] = {questName = "A-2: Weaving Materials", valid = false},
            [263] = {questName = "A-2: Rest Facility Materials", valid = false},
            [999] = {questName = "???", valid = false} -- 999 placeholder
        },
        B = {
            [239] = {questName = " Work Rope", valid = true},
            [240] = {questName = " Sterile Yarn", valid = true},
            [241] = {questName = " High-grade Curtains", valid = true},
            [242] = {questName = " Transport Yarn", valid = true},
            [243] = {questName = " Heat-resistant Composite Fiber", valid = true},
            [244] = {questName = " Rest Supplies", valid = true},
            [245] = {questName = " Test Material Hats", valid = true},
            [246] = {questName = " Rest Cushions", valid = true}
        },
        C = {
            [232] = {questName = " Heat-resistant Yarn", valid = true},
            [233] = {questName = " Room Garments", valid = true},
            [234] = {questName = " Multi-purpose Fabric", valid = true},
            [235] = {questName = " Composite Fiber", valid = true},
            [236] = {questName = " Infirmary Curtains", valid = true},
            [237] = {questName = " Cosmoliner Materials", valid = true},
            [238] = {questName = " New Material Trousers", valid = true}
        },
        D = {
            [226] = {questName = " Multi-purpose Yarn", valid = true},
            [227] = {questName = " First-aid Cloth", valid = true},
            [228] = {questName = " Gatherer's Helmets", valid = true},
            [229] = {questName = " Essential Research Materials", valid = true},
            [230] = {questName = " Multi-purpose String", valid = true},
            [231] = {questName = " Divider Curtains", valid = true}
        }
    }
}
--[[
********************************************************************************
*                            Internal Functions                                         *
********************************************************************************
]]
function logDebug(val)
    if Debug then
        yield("/echo [Debug] " .. val)
    end
end

function logInfo(val)
    yield("/echo [Info] " .. val)
end

function checkQuestAvailability(val)
  logInfo("Checking if "..val.." is available")
    if RedAlert then
        for questCode, questObject in pairs(QuestList[CurrentClass]["Red"]) do
            if string.find(questObject.questName, val) and questObject.valid then
                return questCode
            end
        end
    else
        for questCode, questObject in pairs(QuestList[CurrentClass]["A"]) do
            if string.find(questObject.questName, val) and questObject.valid then
                return questCode
            end
        end
        if FallbackQuest then
            for questCode, questObject in pairs(QuestList[CurrentClass]["B"]) do
                if string.find(questObject.questName, val) and questObject.valid then
                    return questCode
                end
            end
            for questCode, questObject in pairs(QuestList[CurrentClass]["C"]) do
                if string.find(questObject.questName, val) and questObject.valid then
                    return questCode
                end
            end
            for questCode, questObject in pairs(QuestList[CurrentClass]["D"]) do
                if string.find(questObject.questName, val) and questObject.valid then
                    return questCode
                end
            end
        end
    end
end

function getCurrentQuests()
    quests = {}
    rankA = {}
    table.insert(
        rankA,
        string.sub(GetNodeText("WKSMission", 89, 2, 8), 5, string.len(GetNodeText("WKSMission", 89, 2, 8)))
    )
    table.insert(
        rankA,
        string.sub(GetNodeText("WKSMission", 89, 3, 8), 5, string.len(GetNodeText("WKSMission", 89, 3, 8)))
    )
    table.insert(
        rankA,
        string.sub(GetNodeText("WKSMission", 89, 4, 8), 5, string.len(GetNodeText("WKSMission", 89, 4, 8)))
    )
    table.insert(
        rankA,
        string.sub(GetNodeText("WKSMission", 89, 5, 8), 5, string.len(GetNodeText("WKSMission", 89, 5, 8)))
    )
    quests.A = rankA
    if FallbackQuest then
        rankB = {}
        table.insert(
            rankB,
            string.sub(GetNodeText("WKSMission", 89, 6, 8), 5, string.len(GetNodeText("WKSMission", 89, 6, 8)))
        )
        table.insert(
            rankB,
            string.sub(GetNodeText("WKSMission", 89, 7, 8), 5, string.len(GetNodeText("WKSMission", 89, 7, 8)))
        )
        table.insert(
            rankB,
            string.sub(GetNodeText("WKSMission", 89, 8, 8), 5, string.len(GetNodeText("WKSMission", 89, 8, 8)))
        )
        quests.B = rankB
        rankC = {}
        table.insert(
            rankC,
            string.sub(GetNodeText("WKSMission", 89, 9, 8), 5, string.len(GetNodeText("WKSMission", 89, 9, 8)))
        )
        table.insert(
            rankC,
            string.sub(GetNodeText("WKSMission", 89, 10, 8), 5, string.len(GetNodeText("WKSMission", 89, 10, 8)))
        )
        table.insert(
            rankC,
            string.sub(GetNodeText("WKSMission", 89, 11, 8), 5, string.len(GetNodeText("WKSMission", 89, 11, 8)))
        )
        quests.C = rankC
        rankD = {}
        table.insert(
            rankD,
            string.sub(GetNodeText("WKSMission", 89, 12, 8), 5, string.len(GetNodeText("WKSMission", 89, 12, 8)))
        )
        table.insert(
            rankD,
            string.sub(GetNodeText("WKSMission", 89, 13, 8), 5, string.len(GetNodeText("WKSMission", 89, 13, 8)))
        )
        table.insert(
            rankD,
            string.sub(GetNodeText("WKSMission", 89, 14, 8), 5, string.len(GetNodeText("WKSMission", 89, 14, 8)))
        )
        quests.D = rankD
    end
    return quests
end

function startMission()
    questName, questCode = searchForMission(getCurrentQuests())
    if questName ~= nil then
      logInfo("Running mission " .. questName .. " with Quest ID " .. questCode)
      yield(string.format(Callback.clickMission, questCode))
      yield(string.format(Callback.startMission, questCode))
      DoingMission = true
    end
end

function searchForMission(currentQuestList)
    for _, availableQuest in pairs(currentQuestList.A) do
        questCode = checkQuestAvailability(availableQuest)
        if questCode ~= nil then
            return availableQuest, questCode
        end
    end
    logInfo("No suitable A mission found. Searching for B mission.")
    for _, availableQuest in pairs(currentQuestList.B) do
        questCode = checkQuestAvailability(availableQuest)
        if questCode ~= nil then
            return availableQuest, questCode
        end
    end
    logInfo("No suitable B mission found. Searching for C mission.")
    for _, availableQuest in pairs(currentQuestList.C) do
        questCode = checkQuestAvailability(availableQuest)
        if questCode ~= nil then
            return availableQuest, questCode
        end
    end
    logInfo("No suitable C mission found. Searching for D mission.")
    for _, availableQuest in pairs(currentQuestList.D) do
        questCode = checkQuestAvailability(availableQuest)
        if questCode ~= nil then
            return availableQuest, questCode
        end
    end
    logInfo("No suitable mission found. Aborting script.")
    StopScript = true
end

function submitMission()
    if not IsAddonVisible("WKSMissionInfomation") then
        yield(Callback.openMissionInformationWindow)
    end
    yield(Callback.submitMission)
    if IsAddonVisible("WKSReward") then
        logInfo("Mission submitted!")
        DoingMission = false
    end
end

function repair()
    -- if IsAddonVisible("SelectYesno") then
    --     yield("/callback SelectYesno true 0")
    --     return
    -- end
    -- if IsAddonVisible("Repair") then
    --     if not NeedsRepair(RepairAmount) then
    --         yield("/callback Repair true -1") -- if you don't need repair anymore, close the menu
    --     else
    --         yield("/callback Repair true 0") -- select repair
    --     end
    --     return
    -- end
    -- -- if occupied by repair, then just wait
    -- if GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) then
    --     yield("/wait 1")
    --     return
    -- end
    -- if GetItemCount(33916) > 0 then
    --     if IsAddonVisible("Shop") then
    --         yield("/callback Shop true -1")
    --         return
    --     end
    --     if NeedsRepair(RepairAmount) then
    --         if not IsAddonVisible("Repair") then
    --             yield("/generalaction repair")
    --         end
    --     end
    -- else
    --     yield("/echo Out of Dark Matter. Turning Off")
    --     StopScript = true
    -- end
end

function extractMateria()
    logInfo("Extracting materia")
    CanMaterialize = checkIfCanExtractMateria()
    logDebug("CanMaterialize : " .. tostring(CanMaterialize))
    while CanMaterialize do
        if not IsAddonVisible("Materialize") then
            yield(Callback.toggleMateriaExtractionWindow)
        end
        if IsAddonVisible("MaterializeDialog") then
            yield(Callback.extractMateriaDialog)
        else
            yield(Callback.extractMateria)
        end
        CanMaterialize = checkIfCanExtractMateria()
    end
    -- No more materia to extract or inventory is full. Close the materialize window
    if IsAddonVisible("Materialize") then
        yield(Callback.toggleMateriaExtractionWindow)
    end
end

function checkIfCanExtractMateria()
    if CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        logInfo("Materia extraction available")
        return true
    end
    logInfo("Materia extraction not available")
    return false
end

--[[
********************************************************************************
*                            Script Body                                       *
********************************************************************************
]]
logInfo("Starting CosmicCraft")
while not StopScript do
    extractMateria()
    -- repair()
    logDebug("DoingMission : " .. tostring(DoingMission))
    while not DoingMission do
        if not IsAddonVisible("WKSMission") then
            yield(Callback.openMissionInformationWindow)
        end
        if IsAddonVisible("WKSMission") then
            -- Mission not started
            logInfo("Searching for a valid mission to start")
            -- Clicking the Basic Missions tab to skip Red Alerts
            -- yield(Callback.navigateToBasicMissionTab)
            startMission(getCurrentQuests())
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

        logDebug("DoingMission : " .. tostring(DoingMission))
        logDebug("Character is synthesizing : " .. tostring(Synthesizing))

        -- Mid synthesizing, wait awhile before rechecking
        if Synthesizing then
            logInfo("Waiting for synthesis to finish <wait.3>")
        end
        -- If not mid synthesizing, tries to submit
        if not Synthesizing then
            submitMission()
            -- Mission submitted, breaking out of loop
            if not DoingMission then
                break
            end
            -- Mission failed to submit, continue crafting
            if not IsAddonVisible("WKSRecipeNotebook") then
                -- Opens Recipe Book. Mission information window should already be opened.
                yield(Callback.openRecipeWindow)
            end
            logInfo("Starting synthesis")
            yield(Callback.startSynthesis)
        end
    end
end
