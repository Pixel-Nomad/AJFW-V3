local AJFW = exports['aj-base']:GetCoreObject()

-- NUI Callback

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-phone:server:GetVehicleSearchResults', function(result)
        if result then
            for _, v in pairs(result) do
                AJFW.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
                    v.isFlagged = flagged
                end, v.plate)
                Wait(50)
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(_, cb)
    local vehicle = AJFW.Functions.GetClosestVehicle()
    local plate = AJFW.Functions.GetPlate(vehicle)
    local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
    AJFW.Functions.TriggerCallback('aj-phone:server:ScanPlate', function(result)
        AJFW.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
            result.isFlagged = flagged
            result.label = AJFW.Shared.Vehicles[vehname] and AJFW.Shared.Vehicles[vehname].name or 'Unknown brand..'
            cb(result)
        end, plate)
    end, plate)
end)

-- Events

RegisterNetEvent('aj-phone:client:addPoliceAlert', function(alertData)
    if PlayerData.job.name == 'police' and PlayerData.job.onduty then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)