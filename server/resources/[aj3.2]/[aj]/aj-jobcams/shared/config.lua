Config = {
    ServerCallbacks = {}, -- Don't edit or change
    BodycamItem = {
        Enable = true,
        ItemName = "bodycam"
    }, -- Just works for bodycam not dashcam
    UseCharacterNames = true, -- If it is false in UI you will see Steam names
    WatchAreas = {
        {
            job = {"lspd", "ambulance"},
            areas = {
                {coords = vector3(439.62, -999.97, 39.42), label = "See Dashcams", type = "dashcam"},
                {coords = vector3(434.48, -998.49, 39.42), label = "See Bodycams", type = "bodycam"}
                -- If you use target use these code lines
                -- {coords = vector3(434.69, -996.99, 39.42), heading = 0, scale = 2.0, width = 2.0, label = "See Dashcams", type = "dashcam"},
                -- {coords = vector3(434.48, -998.49, 39.42), heading = 0, scale = 2.0, width = 2.0, label = "See Bodycams", type = "bodycam"}
            },
            dashcamVehicles = {
                Enable = false, -- if false works with all vehicles
                Vehicles = {
                    "poltaurus","npolvic", "npolexp"
                }
            },
            interaction = {
                Target = {
                    Enable = false,
                    Distance = 2.0,
                    Icon = "fa-solid fa-address-book"
                },
                Text = {
                    Enable = false,
                    Distance = 2.0
                },
                DrawText = {
                    Enable = true,
                    Distance = 2.0,
                    Show = function(label)
                        exports["aj-base"]:DrawText(label, "left")
                    end,
                    Hide = function()
                        exports["aj-base"]:HideText()
                    end
                }
            }
        }
    }
}