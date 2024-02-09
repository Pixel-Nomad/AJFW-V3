local ShouldSaveTODB = true

local Sounds = {}
local DataSounds = {}
local DataCollected = false

local function pairsByKeys(t,f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function ()   -- iterator function
            i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

local Menu = {
    {
        isMenuHeader = true,
        header = 'SoundMenu Category',
    },
    {
        header = 'Enter Manually',
        params = {
            event = 'aj-vehiclesounds:client:OpenInput',
        }
    }
}
local count = 0
for k,v in pairsByKeys(Config.VehicleSounds) do
    count = count + 1
    local Menu2 = {
        {
            isMenuHeader = true,
            header = 'SoundMenu',
        },
        {
            header = 'Go Back',
            params = {
                event = 'aj-vehiclesounds:client:OpenMenu',
            }
        }
    }
    local count2 = 0
    for l,m in pairsByKeys(Config.VehicleSounds[k]) do
        count2 = count2 + 1
        Menu2[#Menu2+1] = {
            header = count2..'. '..m,
            params = {
                event = 'aj-vehiclesounds:client:ChangeSound',
                args  = l
            }
        }
    end
    Menu[#Menu+1] = {
        header = count..'. '..k,
        params = {
            event = 'aj-vehiclesounds:client:ChangeSoundMenu',
            args  = Menu2
        }
    }
end


RegisterNetEvent('aj-vehiclesounds:client:OpenMenu', function(Toggle)
    ShouldSaveTODB = Toggle
    ModularUI:openMenu(Menu)
end)

RegisterNetEvent('aj-vehiclesounds:client:ChangeSound', function(Sound)
    if IsPedInAnyVehicle(PlayerPedId()) then
        TriggerServerEvent('aj-vehiclesounds:server:ChangeSound', Sound, ShouldSaveTODB)
        -- TriggerEvent('aj-vehiclesounds:client:OpenMenu', false)
    end
end)

RegisterNetEvent('aj-vehiclesounds:client:ChangeSoundMenu', function(Data)
    ModularUI:openMenu(Data)
end)

RegisterNetEvent('aj-vehiclesounds:client:OpenInput', function()
    local dialog = ModularInput:ShowInput({
        header = 'Enter Sound ID',
        submitText = 'Submit',
        inputs = {
            {
                text = "For Example evoixsound",
                name = "soundId",
                type = "text",
                isRequired = true
            }
        }
    })
    if dialog and dialog.soundId then
        dialog.soundId = dialog.soundId:lower()
        TriggerEvent('aj-vehiclesounds:client:ChangeSound',dialog.soundId)
    end
end)

RegisterNetEvent('aj-vehiclesounds:client:saveSound', function(Sound, entNet)
    
    if entNet then
        local vehicle = NetworkGetEntityFromNetworkId(entNet)
        if vehicle and vehicle ~= 0 then
            ForceVehicleEngineAudio(vehicle, Sound)
        end
    else
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        TriggerEvent('aj-clipboard', Sound)
        ForceVehicleEngineAudio(vehicle, Sound)
    end
end)

AddStateBagChangeHandler('tunerData', nil, function(bagName, key, value)
    Wait(1000)
    if not value then return end
    local entNet = tonumber(bagName:gsub('entity:', ''), 10)
    local vehicle = NetworkGetEntityFromNetworkId(entNet)
    if vehicle and vehicle ~= 0 then
        ForceVehicleEngineAudio(vehicle, value)
    end
end)

RegisterNetEvent('aj-sounds:client:post', function(Sound)
    print('On:VehicleSoundsUpdated')
    Sounds = Sound
    Wait(1000)
    DataCollected = true
end)

CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn and DataCollected then
            local sleep = 2000
            local pos = GetEntityCoords(GlobalPlayerPedID)
            for k,v in pairs(GetGamePool('CVehicle')) do
                local target = GetEntityCoords(v)
                local dist = #(pos - target)
                if dist <= 100 then
                    local plate = GetVehicleNumberPlateText(v)
                    local model = GetEntityModel(v)
                    -- if Sounds[plate] then
                        if DataSounds[plate] == nil then
                            DataSounds[plate] = {}
                            DataSounds[plate].plate = plate
                            DataSounds[plate].entity = v
                            DataSounds[plate].Sound = Sounds[plate] and Sounds[plate].engineSound or Config.DefaultCarSounds[model]
                            -- DataSounds[plate].Sound = Sounds[plate] and Sounds[plate].engineSound or 'evoixsound'
                        end
                        DataSounds[plate].Sound = Sounds[plate] and Sounds[plate].engineSound or Config.DefaultCarSounds[model]
                        -- DataSounds[plate].Sound = Sounds[plate] and Sounds[plate].engineSound or 'evoixsound'
                        if DataSounds[plate] and DataSounds[plate].plate and plate == DataSounds[plate].plate and DataSounds[plate].current ~= DataSounds[plate].Sound then
                            ForceVehicleEngineAudio(v, DataSounds[plate].Sound)
                            DataSounds[plate].current = DataSounds[plate].Sound
                        end
                    -- end
                elseif dist > 100 and DataSounds[plate] and DataSounds[plate].current then
                    DataSounds[plate].current = nil
                end
            end
        end
        for k,v in pairs(DataSounds) do
            if not DoesEntityExist(v.entity) then
                DataSounds[k] = nil
            end
        end
        Wait(sleep)
    end
end)