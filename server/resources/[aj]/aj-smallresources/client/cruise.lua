local AJFW = exports['aj-base']:GetCoreObject()
local vehicleClasses = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = false,
    [14] = false,
    [15] = false,
    [16] = false,
    [17] = true,
    [18] = true,
    [19] = true,
    [20] = true,
    [21] = false
}

local function GetVehicleMPH(veh)
    return GetEntitySpeed(veh) * 2.23694
end
local speed = 0
local cruiseon = false
local function triggerCruiseControl(veh)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        speed = GetVehicleMPH(veh)
        if speed > 30 and GetVehicleCurrentGear(veh) > 0 and GetIsVehicleEngineRunning(veh) then
            speed = GetVehicleMPH(veh)
            TriggerEvent('seatbelt:client:ToggleCruise', true)
            AJFW.Functions.Notify(Lang:t('cruise.activated'))
            cruiseon = true
            CreateThread(function()
                while speed > 0 and GetPedInVehicleSeat(veh, -1) == ped do
                    Wait(0)
                    local angle = GetVehicleSteeringAngle(veh)
                    print(angle)
                    local onWheel = IsVehicleOnAllWheels(veh)
                    local speed2= GetVehicleMPH(veh) 
                    local isBreaking = IsControlPressed(2, 72) or IsControlPressed(2, 76)
                    if  speed2 < 30 or not GetIsVehicleEngineRunning(veh) then
                        speed = 0
                        cruiseon = false
                        TriggerEvent('seatbelt:client:ToggleCruise', false)
                        AJFW.Functions.Notify(Lang:t('cruise.deactivated'), "error")
                        Wait(2000)
                        break
                    end
                    print(GetEntitySpeed(veh))
                    if not (angle > 20.0 or angle < -20.0) and not isBreaking and onWheel and speed2 < speed - 0.5 then
                        SetControlNormal(0, 71, 0.8)
                    end

                    if not (angle > 5.0 or angle < -5.0) and not isBreaking and onWheel and speed2 > speed - 0.5 and speed2 < speed then
                        SetVehicleForwardSpeed(veh, speed / 2.23694)
                    end

                    if IsControlJustPressed(1, 246) then
                        speed = GetVehicleMPH(veh)
                    end

                    if not cruiseon then
                        speed = 0
                        TriggerEvent('seatbelt:client:ToggleCruise', false)
                        AJFW.Functions.Notify(Lang:t('cruise.deactivated'), "error")
                        Wait(2000)
                        break
                    end

                    -- if  IsControlJustPressed(0, 76) then
                    --     speed = 0
                    --     cruiseon = false
                    --     TriggerEvent('seatbelt:client:ToggleCruise', false)
                    --     AJFW.Functions.Notify(Lang:t('cruise.deactivated'), "error")
                    --     Wait(2000)
                    --     break
                    -- end
                end
            end)
        end
    end
end

RegisterCommand('togglecruise', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local driver = GetPedInVehicleSeat(veh, -1)
    local vehClass = GetVehicleClass(veh)
    if not cruiseon then
        if ped == driver and vehicleClasses[vehClass] then
            triggerCruiseControl(veh)
        else
            AJFW.Functions.Notify(Lang:t('cruise.unavailable'), "error")
        end
    else
        cruiseon = false
    end
end, false)

RegisterKeyMapping('togglecruise', 'Toggle Cruise Control', 'keyboard', 'Y')

local speedchange = 5
RegisterCommand('increasecruisespeed', function()
    if cruiseon then
        speed = speed + speedchange
        AJFW.Functions.Notify("Cruse Speed Increased By "..speedchange)
    end
end, false)

RegisterKeyMapping('increasecruisespeed', 'Cruse Speed +5', 'keyboard', 'PRIOR')

RegisterCommand('decreasecruisespeed', function()
    if cruiseon then
        
        speed = speed - speedchange
        AJFW.Functions.Notify("Cruse Speed Decreased By "..speedchange)
    end
end, false)

RegisterKeyMapping('decreasecruisespeed', 'Cruse Speed -5', 'keyboard', 'NEXT')

RegisterCommand('speedchange', function()
    speedchange = speedchange + 1
    if speedchange > 10 then
        speedchange = 1
    end
    AJFW.Functions.Notify("Cruise Speed will now increase by ".. speedchange)
end, false)

RegisterKeyMapping('speedchange', 'Cruse Speed', 'keyboard', 'HOME')