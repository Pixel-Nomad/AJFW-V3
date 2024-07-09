local dashcamPlayers = {}
function enteredVehicle(src, model, netId)
    local job = GetPlayerJob(src)
    dashcamPlayers[src] = {
        pId = src,
        vehNetId = netId,
        vehModel = model,
        label = src .. " | " .. GetCharName(src, Config.UseCharacterNames),
        job = job.name
    }
end

function leftVehicle(src)
    dashcamPlayers[src] = nil
end

CreateCallback('aj-jobcams:getDashcamList:server', function(source, cb)
    cb(dashcamPlayers)
end)

CreateCallback('aj-jobcams:getVehicleByID:server', function(source, cb, id)
    local ped = GetPlayerPed(id)
    local vehicle = GetVehiclePedIsUsing(ped)
    cb(vehicle)
end)

CreateCallback('aj-jobcams:getPlayerCoords:server', function(source, cb, id)
    local ped = GetPlayerPed(id)
    cb(GetEntityCoords(ped))
end)

CreateCallback('aj-jobcams:getBodycamList:server', function(source, cb, job)
    local pData = {}
    for _, playerId in ipairs(GetPlayers()) do
        local numPlayerId = tonumber(playerId)
        if numPlayerId ~= source then
            if HasItem(tonumber(playerId)) then 
                local jobData = GetPlayerJob(tonumber(playerId))
                if jobData then
                    if type(job) == "table" then
                        for k, v in pairs(job) do
                            if jobData.name == v then
                                local playerName = GetCharName(playerId, Config.UseCharacterNames)
                                local license = GetPlayerLicense(playerId)
                                pData[license] = {
                                    label = playerId .. " | " .. playerName,
                                    id = tonumber(playerId)
                                }
                            end
                        end
                    else
                        if jobData.name == job then
                            local playerName = GetCharName(playerId, Config.UseCharacterNames)
                            local license = GetPlayerLicense(playerId)
                            pData[license] = {
                                label = playerId .. " | " .. playerName,
                                id = tonumber(playerId)
                            }
                        end
                    end
                end
            end
        end
    end
    Citizen.Wait(500)
    cb(pData)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh, seat, modelName, netId)
    local src = source
    enteredVehicle(src, modelName, netId)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh, seat, modelName, netId)
    local src = source
    leftVehicle(src)
end)

RegisterNetEvent('aj-jobcams:createClonePed:server', function(nearbyPlayers)
    local myPed = GetPlayerPed(source)
    local myCoords = GetEntityCoords(myPed)
    local myHeading = GetEntityHeading(myPed)
    for _, id in pairs(nearbyPlayers) do
        TriggerClientEvent('aj-jobcams:createClonePed:client', id, myPed, vector4(myCoords.x, myCoords.y, myCoords.z, myHeading))
    end
end)

RegisterNetEvent('aj-jobcams:deleteClonePed:server', function(nearbyPlayers)
    for _, id in pairs(nearbyPlayers) do
        TriggerClientEvent('aj-jobcams:deleteClonePed:client', id)
    end
end)