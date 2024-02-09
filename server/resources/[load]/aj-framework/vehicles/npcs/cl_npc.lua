local Data = {}

local colors = {
    {255, 0, 0},      -- Red
    {220, 20, 60},    -- Crimson
    {178, 34, 34},    -- Fire Brick
    {255, 69, 0},     -- Orange Red
    {205, 92, 92},    -- Indian Red
    {250, 128, 114},  -- Salmon
    {255, 99, 71},    -- Tomato
    {188, 0, 0},      -- Dark Red
    {139, 0, 0},      -- Dark Red (Deep Red)
    {255, 0, 0},      -- Medium Red
    {255, 36, 0},     -- Vermilion
    {227, 66, 52},    -- Jasper
    {165, 42, 42},    -- Brown
    {255, 51, 51},    -- Light Red
    {255, 69, 0},     -- Coral
    {255, 0, 0},      -- Dark Candy Apple Red
    {255, 11, 97},    -- Amaranth Red
    {204, 51, 51},    -- Chestnut Red
    {220, 20, 60},    -- Ruby Red
    {255, 36, 0},     -- Orange Red
    {255, 20, 147},   -- Deep Pink
    {255, 105, 180},  -- Hot Pink
    {250, 128, 114},  -- Salmon
    {255, 160, 122},  -- Light Salmon
    {255, 69, 0},     -- Coral
    {255, 48, 48},    -- Light Coral
    {219, 112, 147},  -- Pale Violet Red
    {227, 38, 54},    -- Raspberry
    {255, 105, 180},  -- Hot Pink
    {255, 20, 147},   -- Deep Pink
    {255, 140, 0},    -- Dark Orange
    {255, 165, 0},    -- Orange
    {255, 228, 181},  -- Moccasin
    {220, 20, 60},    -- Maroon
    {178, 58, 238},   -- Medium Orchid
    {186, 85, 211},   -- Medium Purple
    {255, 192, 203},  -- Pink
    {255, 182, 193},  -- Light Pink
    {219, 112, 147},  -- Pale Violet Red
    {255, 165, 0},    -- Gold
    {255, 215, 0},    -- Gold (Metallic)
    {255, 223, 0},    -- Gold (Web Golden)
    {218, 165, 32},   -- Goldenrod
    {255, 218, 185},  -- Peach
    {255, 222, 173},  -- Navajo White
}



local function ApplyModification(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if not Data[plate] then
        SetVehicleModKit(vehicle, 0)
        if math.random(1,100) <= 30 then
            SetVehicleMod(vehicle, 11, math.random(1,2), true)
        end
        if math.random(1,100) <= 30 then
            local random = math.random(1,#colors)
            local r = colors[random][1]
            local g = colors[random][2]
            local b = colors[random][3]
            SetVehicleNeonLightEnabled(vehicle, 0, true)
            SetVehicleNeonLightEnabled(vehicle, 1, true)
            SetVehicleNeonLightEnabled(vehicle, 2, true)
            SetVehicleNeonLightEnabled(vehicle, 3, true)
            SetVehicleNeonLightsColour(vehicle, r,g,b)
        end
        if math.random(1,100) <= 30 then
            SetVehicleMod(vehicle, 12, 1, true)
        end
        if math.random(1,100) <= 30 then
            SetVehicleMod(vehicle, 13, math.random(1,2), true)
        end
        if math.random(1,100) <= 15 then
            ToggleVehicleMod(vehicle, 18, true)
        end
        Data[plate] = vehicle
    end
end


CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn then
            local sleep = 1000
            for k,v in pairs(GetGamePool('CVehicle')) do
                if IsThisModelACar(GetEntityModel(v)) and not IsEntityAMissionEntity(v) and not IsVehiclePreviouslyOwnedByPlayer(v) then
                    ApplyModification(v)
                end
            end
        end
        for k,v in pairs(Data) do
            if not DoesEntityExist(v) then
                Data[k] = nil
            end
        end
        Wait(sleep)
    end
end)