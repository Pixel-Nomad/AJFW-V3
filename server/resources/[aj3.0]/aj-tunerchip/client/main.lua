local inTuner = false
local RainbowNeon = false
LastEngineMultiplier = 1.0
local TunerData 
local AJFW = exports['aj-base']:GetCoreObject()

local Cache = {}
local Cache2= {}

function GetTune(plate)
    if Cache2[plate] then
        if Cache2[plate].boost > 50 then
            return true
        end
    end
    return false
end
exports('GetTune', GetTune)

function setVehData(veh,data)
    data.boost = tonumber(data.boost)
    ModifyVehicleTopSpeed(veh, -1.0)
    if not DoesEntityExist(veh) or not data then return nil end
    local plate = GetVehicleNumberPlateText(veh, false)
    if data.boost > 0 then
        ModifyVehicleTopSpeed(veh, data.boost / 10)
        TriggerServerEvent('aj-tunerchip:server:TuneStatus', AJFW.Functions.GetPlate(veh), true)
    else 
        TriggerServerEvent('aj-tunerchip:server:TuneStatus', AJFW.Functions.GetPlate(veh), false)
    end
    SetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), "CHandlingData", "fBrakeBiasFront", data.brake / 100)
    Cache2[plate].boost = data.boost
    Cache2[plate].brake = data.brake
    if data.boost > 50 then
        TriggerEvent('aj-vehicles:ForceRemove:Mode')
    end
    TriggerServerEvent('aj-tunnerchip:storeData', plate, nil,Cache2[plate])
    TriggerEvent('aj-custom:client:updatemodsindatabase')
end

function resetVeh(veh)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", 1.0)
    SetVehicleEnginePowerMultiplier(veh, 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", 0.5)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", 1.0)
end

RegisterNUICallback('save', function(data)
    AJFW.Functions.TriggerCallback('aj-tunerchip:server:HasChip', function(HasChip)
        if HasChip then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped)
            setVehData(veh, data)
            AJFW.Functions.Notify('TunerChip v3.55: Vehicle Tuned!', 'error')
        end
    end)
end)

RegisterNetEvent('aj-tunerchip:client:TuneStatus')
AddEventHandler('aj-tunerchip:client:TuneStatus', function()
    local ped = PlayerPedId()
    local closestVehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    local plate = AJFW.Functions.GetPlate(closestVehicle)
    local vehModel = GetEntityModel(closestVehicle)
    if vehModel ~= 0 then
        AJFW.Functions.TriggerCallback('aj-tunerchip:server:GetStatus', function(status)
            if status then
                AJFW.Functions.Notify('This Vehicle Has Been Tuned', 'success')
            else
                AJFW.Functions.Notify('This Vehicle Has Not Been Tuned', 'error')
            end
        end, plate)
    else
        AJFW.Functions.Notify('No Vehicle Nearby', 'error')
    end
end)

RegisterNetEvent('aj-tunerchip:client:checkvehicle')
AddEventHandler('aj-tunerchip:client:checkvehicle', function(slot, info)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        TriggerServerEvent('aj-tunerchip:server:checkvehicle', slot, info)
    else
        AJFW.Functions.Notify("You Are Not In A Vehicle", "error")
    end
end)

RegisterNUICallback('checkItem', function(data, cb)
    local retval = false
    AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
        if result then
            retval = true
        end
        cb(retval)
    end, data.item)
end)

RegisterNUICallback('reset', function(data)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    resetVeh(veh)
    -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 5)
    AJFW.Functions.Notify('TunerChip v3.55: Vehicle has been reset!', 'error')
end)

RegisterNetEvent('aj-tunerchip:client:openChip')
AddEventHandler('aj-tunerchip:client:openChip', function(item)
    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped)

    if inVehicle then
        if GetEntitySpeed(GetVehiclePedIsIn(ped, false)) < 0.1 then
            AJFW.Functions.Progressbar("connect_laptop", "Tunerchip v3.55: Vehicle Has Been Reset!", 2000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 16,
            }, {}, {}, function() -- Done
                local infos = {}
                infos.uses = item.info.uses - 1
                TriggerServerEvent('AJFW:Server:RemoveItem', item.name, item.amount, item.slot)
                TriggerServerEvent("AJFW:Server:AddItem", item.name, item.amount, item.slot, infos)
                TunerData = item
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                openTunerLaptop(true)
            end, function() -- Cancel
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                AJFW.Functions.Notify("Canceled", "error")
            end)
        end
    else
        AJFW.Functions.Notify("You Are Not In A Vehicle", "error")
    end
end)

RegisterNUICallback('exit', function()
    openTunerLaptop(false)
    SetNuiFocus(false, false)
    inTuner = false
end)

local LastRainbowNeonColor = 0

local RainbowNeonColors = {
    [1] = {
        r = 255,
        g = 0,
        b = 0
    },
    [2] = {
        r = 255,
        g = 165,
        b = 0
    },
    [3] = {
        r = 255,
        g = 255,
        b = 0
    },
    [4] = {
        r = 0,
        g = 0,
        b = 255
    },
    [5] = {
        r = 75,
        g = 0,
        b = 130
    },
    [6] = {
        r = 238,
        g = 130,
        b = 238
    },
}

RegisterNUICallback('saveNeon', function(data)
    AJFW.Functions.TriggerCallback('aj-tunerchip:server:HasChip', function(HasChip)
        if HasChip then
            if not data.rainbowEnabled then
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)

                if tonumber(data.neonEnabled) == 1 then
                    SetVehicleNeonLightEnabled(veh, 0, true)
                    SetVehicleNeonLightEnabled(veh, 1, true)
                    SetVehicleNeonLightEnabled(veh, 2, true)
                    SetVehicleNeonLightEnabled(veh, 3, true)
                    if tonumber(data.r) ~= nil and tonumber(data.g) ~= nil and tonumber(data.b) ~= nil then
                        SetVehicleNeonLightsColour(veh, tonumber(data.r), tonumber(data.g), tonumber(data.b))
                    else
                        SetVehicleNeonLightsColour(veh, 255, 255, 255)
                    end
                    RainbowNeon = false
                else
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                    RainbowNeon = false
                end
            else
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)

                if tonumber(data.neonEnabled) == 1 then
                    if not RainbowNeon then
                        RainbowNeon = true
                        SetVehicleNeonLightEnabled(veh, 0, true)
                        SetVehicleNeonLightEnabled(veh, 1, true)
                        SetVehicleNeonLightEnabled(veh, 2, true)
                        SetVehicleNeonLightEnabled(veh, 3, true)
                        Citizen.CreateThread(function()
                            while true do
                                if RainbowNeon then
                                    if (LastRainbowNeonColor + 1) ~= 7 then
                                        LastRainbowNeonColor = LastRainbowNeonColor + 1
                                        SetVehicleNeonLightsColour(veh, RainbowNeonColors[LastRainbowNeonColor].r, RainbowNeonColors[LastRainbowNeonColor].g, RainbowNeonColors[LastRainbowNeonColor].b)
                                    else
                                        LastRainbowNeonColor = 1
                                        SetVehicleNeonLightsColour(veh, RainbowNeonColors[LastRainbowNeonColor].r, RainbowNeonColors[LastRainbowNeonColor].g, RainbowNeonColors[LastRainbowNeonColor].b)
                                    end
                                else
                                    break
                                end

                                Citizen.Wait(350)
                            end
                        end)
                    end
                else
                    RainbowNeon = false
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                end
            end
            -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 5)
        end
    end)
end)

local RainbowHeadlight = false
local RainbowHeadlightValue = 0

RegisterNUICallback('saveHeadlights', function(data)
    AJFW.Functions.TriggerCallback('aj-tunerchip:server:HasChip', function(HasChip)
        if HasChip then
            if data.rainbowEnabled then
                RainbowHeadlight = true
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)
                local value = tonumber(data.value)

                Citizen.CreateThread(function()
                    while true do
                        if RainbowHeadlight then
                            if (RainbowHeadlightValue + 1) ~= 12 then
                                RainbowHeadlightValue = RainbowHeadlightValue + 1
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleHeadlightsColour(veh, RainbowHeadlightValue)
                            else
                                RainbowHeadlightValue = 1
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleHeadlightsColour(veh, RainbowHeadlightValue)
                            end
                        else
                            break
                        end
                        Citizen.Wait(300)
                    end
                end)                
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, value)
            else
                RainbowHeadlight = false
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)
                local value = tonumber(data.value)

                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, value)
            end
            -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 5)
        end
    end)
end)

function openTunerLaptop(bool)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local plate = GetVehicleNumberPlateText(vehicle, false)
    if bool then
        if not Cache[plate] then
            Cache[plate] = {
                boost = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce"),
                brake = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeBiasFront"),
            }
        end
        if not Cache2[plate] then
            Cache2[plate] = {
                boost = 0,
                brake = math.floor(100*(GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeBiasFront")))
            }
        end
        TriggerServerEvent('aj-tunnerchip:storeData', plate, Cache[plate],Cache2[plate])
    end
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
        data = {
            boost  = Cache2[plate].boost,
            brake  = Cache2[plate].brake,
        }
    })
    inTuner = bool
end

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    TriggerServerEvent('aj-tunnerchip:getData')
end)

RegisterNetEvent('aj-tunnerchip:syncData', function(c,c2)
    Cache = c
    Cache2 = c2
end)

RegisterNUICallback('SetStancer', function(data, cb)
    local fOffset = data.fOffset * 100 / 1000
    local fRotation = data.fRotation * 100 / 1000
    local rOffset = data.rOffset * 100 / 1000
    local rRotation = data.rRotation * 100 / 1000

    -- print(fOffset)
    -- print(fRotation)
    -- print(rOffset)
    -- print(rRotation)

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    -- TriggerServerEvent('Perform:Decay:item', TunerData.name, TunerData.slot, 5)
    exports["vstancer"]:SetWheelPreset(veh, -fOffset, -fRotation, -rOffset, -rRotation)
    TriggerEvent('aj-custom:client:updatemodsindatabase')

end)
