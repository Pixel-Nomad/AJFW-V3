Config = {}
Config.UsingTarget = true
Config.Commission = 0.10                              -- Percent that goes to sales person from a full car sale 10%
Config.FinanceCommission = 0.05                       -- Percent that goes to sales person from a finance sale 5%
Config.PaymentWarning = 10                            -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 24                           -- time in hours between payment being due
Config.MinimumDown = 10                               -- minimum percentage allowed down
Config.MaximumPayments = 24                           -- maximum payments allowed
Config.PreventFinanceSelling = false                  -- allow/prevent players from using /transfervehicle if financed
Config.FilterByMake = false                           -- adds a make list before selecting category in shops
Config.SortAlphabetically = true                      -- will sort make, category, and vehicle selection menus alphabetically
Config.HideCategorySelectForOne = true                -- will hide the category selection menu if a shop only sells one category of vehicle or a make has only one category
Config.Shops = {
    ['pdm'] = {
        ['Type'] = 'managed', -- no player interaction is required to purchase a car
        ['Zone'] = {
            ['Shape'] = {      --polygon that surrounds the shop
                vector2(-56.727394104004, -1086.2325439453),
                vector2(-60.612808227539, -1096.7795410156),
                vector2(-58.26834487915, -1100.572265625),
                vector2(-35.927803039551, -1109.0034179688),
                vector2(-34.427627563477, -1108.5111083984),
                vector2(-33.9, -1108.96),
                vector2(-35.95, -1114.32),
                vector2(-31.58, -1115.21),
                vector2(-27.48, -1103.42),
                vector2(-33.342102050781, -1101.0377197266),
                vector2(-31.292987823486, -1095.3717041016)
            },
            ['minZ'] = 25.0,                                         -- min height of the shop zone
            ['maxZ'] = 28.0,                                         -- max height of the shop zone
            ['size'] = 2.75                                          -- size of the vehicles zones
        },
        ['Job'] = 'none',                                            -- Name of job or none
        ['ShopLabel'] = 'Premium Deluxe Motorsport',                 -- Blip name
        ['showBlip'] = true,                                         -- true or false
        ['blipSprite'] = 326,                                        -- Blip sprite
        ['blipColor'] = 3,                                           -- Blip color
        ['TestDriveTimeLimit'] = 0.5,                                -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-45.67, -1098.34, 26.42),             -- Blip Location
        ['ReturnLocation'] = vector3(-44.74, -1082.58, 26.68),       -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-56.79, -1109.85, 26.43, 71.5),   -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(-56.79, -1109.85, 26.43, 71.5), -- Spawn location for test drive
        ['FinanceZone'] = vector3(-29.53, -1103.67, 26.42),          -- Where the finance menu is located
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-45.65, -1093.66, 25.44, 69.5), -- where the vehicle will spawn on display
                defaultVehicle = 'ardent',                       -- Default display vehicle
                chosenVehicle = 'ardent',                        -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-48.27, -1101.86, 25.44, 294.5),
                defaultVehicle = 'schafter2',
                chosenVehicle = 'schafter2'
            },
            [3] = {
                coords = vector4(-39.6, -1096.01, 25.44, 66.5),
                defaultVehicle = 'coquette',
                chosenVehicle = 'coquette'
            },
            [4] = {
                coords = vector4(-51.21, -1096.77, 25.44, 254.5),
                defaultVehicle = 'vigero',
                chosenVehicle = 'vigero'
            },
            [5] = {
                coords = vector4(-40.18, -1104.13, 25.44, 338.5),
                defaultVehicle = 'rhapsody',
                chosenVehicle = 'rhapsody'
            },
            [6] = {
                coords = vector4(-43.31, -1099.02, 25.44, 52.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati'
            },
            [7] = {
                coords = vector4(-50.66, -1093.05, 25.44, 222.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati'
            },
            [8] = {
                coords = vector4(-44.28, -1102.47, 25.44, 298.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati'
            }
        },
    },
    ['edm'] = {
        ['Type'] = 'managed', -- no player interaction is required to purchase a car
        ['Zone'] = {
            ['Shape'] = {      --polygon that surrounds the shop
            vector2(-808.67, -210.77),
            vector2(-794.68, -202.68),
            vector2(-792.66, -206.16),
            vector2(-786.0, -202.89),
            vector2(-775.92, -220.2),
            vector2(-780.16, -222.9),
            vector2(-782.5, -231.74),
            vector2(-779.3, -237.44),
            vector2(-781.99, -239.01),
            vector2(-779.19, -244.1),
            vector2(-787.76, -247.78)
            },
            ['minZ'] = 36.17,                                         -- min height of the shop zone
            ['maxZ'] = 38.17,                                         -- max height of the shop zone
            ['size'] = 2.75                                          -- size of the vehicles zones
        },
        ['Job'] = 'edm',                                            -- Name of job or none
        ['ShopLabel'] = 'EDM',                 -- Blip name
        ['showBlip'] = true,                                         -- true or false
        ['blipSprite'] = 326,                                        -- Blip sprite
        ['blipColor'] = 3,                                           -- Blip color
        ['TestDriveTimeLimit'] = 0.5,                                -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-792.04, -217.9, 37.41),             -- Blip Location
        ['ReturnLocation'] = vector3(-773.66, -235.18, 36.55),       -- Location to return vehicle, only enables if the vehicleshop has a job owned
        ['VehicleSpawn'] = vector4(-773.66, -235.18, 36.55, 206.68),   -- Spawn location when vehicle is bought
        ['TestDriveSpawn'] = vector4(-773.66, -235.18, 36.55, 206.68), -- Spawn location for test drive
        ['FinanceZone'] = vector3(-783.68, -212.48, 36.54),          -- Where the finance menu is located
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-779.33, -219.18, 36.21, 65.55), -- where the vehicle will spawn on display
                defaultVehicle = 'evo9',                       -- Default display vehicle
                chosenVehicle = 'evo9',                        -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-787.54, -207.28, 36.21, 115.51),
                defaultVehicle = 'fnf4r34',
                chosenVehicle = 'fnf4r34'
            },
            [3] = {
                coords = vector4(-803.72, -215.09, 36.21, 208.39),
                defaultVehicle = 'zx10',
                chosenVehicle = 'zx10'
            },
            [4] = {
                coords = vector4(-792.11, -218.33, 36.21, 122.09),
                defaultVehicle = 'swiftmg',
                chosenVehicle = 'swiftmg'
            },
            [5] = {
                coords = vector4(-796.36, -228.61, 36.01, 299.34),
                defaultVehicle = 't20',
                chosenVehicle = 't20'
            }
        },
    },
}
