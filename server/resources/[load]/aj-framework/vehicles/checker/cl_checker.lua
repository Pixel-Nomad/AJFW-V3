local isInVehicle = false
local isEnteringVehicle = false
local currentVehicle = 0
local currentSeat = 0

local function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

CreateThread(function()
    while true do
        local sleep = 1500
        if LocalPlayer.state.isLoggedIn then
            sleep = 50
            local ped = GlobalPlayerPedID
            local Vehicle = GetVehiclePedIsTryingToEnter(ped)
            if not isInVehicle then
                if Vehicle ~= 0 then
                    if DoesEntityExist(Vehicle) and not isEnteringVehicle then
                        local seat = GetSeatPedIsTryingToEnter(ped)
                        local netId = VehToNet(Vehicle)
                        local model = GetEntityModel(Vehicle)
                        local name = GetDisplayNameFromVehicleModel(model)
                        isEnteringVehicle = true
                        print('On:VehicleEntering')
                        TriggerServerEvent('aj-framework:enteringVehicle', Vehicle, seat, name, netId)
                    elseif not DoesEntityExist(Vehicle) and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
                        print('On:VehicleEnteringAborted')
                        TriggerEvent('aj-framework:enteringAborted')
                        TriggerServerEvent('aj-framework:enteringAborted')
                        isEnteringVehicle = false
                    end
                elseif not isInVehicle then
                    if IsPedInAnyVehicle(ped) then
                        isEnteringVehicle = false
                        isInVehicle = true
                        currentVehicle = GetVehiclePedIsUsing(ped)
                        currentSeat = GetPedVehicleSeat(ped)
                        local model = GetEntityModel(currentVehicle)
                        local name = GetDisplayNameFromVehicleModel(model)
                        local netId = VehToNet(currentVehicle)
                        print('On:VehicleEntered')
                        TriggerServerEvent('aj-framework:enteredVehicle', currentVehicle, currentSeat, name, netId)
                    end
                end
            elseif isInVehicle then
                if not IsPedInAnyVehicle(ped) then
                    local model = GetEntityModel(currentVehicle)
                    local name = GetDisplayNameFromVehicleModel(model)
                    local netId = VehToNet(currentVehicle)
                    print('On:VehicleLeaving')
                    TriggerEvent('aj-framework:leftVehicle', currentVehicle, currentSeat, name, netId)
                    TriggerServerEvent('aj-framework:leftVehicle', currentVehicle, currentSeat, name, netId)
                    isInVehicle = false
                    currentVehicle = 0
                    currentSeat = 0
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('AJFW:Client:VehicleInfo', function(info)
    local plate = AJFW.Functions.GetPlate(info.vehicle)
    local data = {
        vehicle = NetToVeh(info.netid),
        seat = info.seat,
        name = info.modelName,
        plate = plate,
        driver = GetPedInVehicleSeat(info.vehicle, -1),
        inseat = GetPedInVehicleSeat(info.vehicle, info.seat),
        haskeys = exports['aj-vehiclekeys']:HasKeys(plate)
    }
    TriggerEvent('AJFW:Client:'..info.event..'Vehicle', data)
end)