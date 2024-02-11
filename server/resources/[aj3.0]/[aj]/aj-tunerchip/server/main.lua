local tunedVehicles = {}
local VehicleNitrous = {}
local AJFW = exports['aj-base']:GetCoreObject()

local Cache = {}
local Cache2 = {}

AJFW.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local src = source
    local player = AJFW.Functions.GetPlayer(src)
    -- if item.info.uses >= 1 then
        TriggerClientEvent('aj-tunerchip:client:openChip', src, item)
    -- else
    --     TriggerClientEvent("AJFW:Notify", src, "Brocken Chip", "error", 4000)
    -- end
    -- if player.PlayerData.job.name == 'tunnermechanic' then
    --     TriggerClientEvent('aj-tunerchip:client:checkvehicle', src, item.slot, item.info)
    -- else
    --     TriggerClientEvent('AJFW:Notify', src, "You Can't Use This Chip", 'error')
    -- end
end)

RegisterNetEvent('aj-tunnerchip:storeData', function(plate,data,data2)
    if data then
        Cache[plate] = data
    end
    Cache2[plate] = data2
    TriggerClientEvent('aj-tunnerchip:syncData', -1, Cache,Cache2)
end)

RegisterNetEvent('aj-tunnerchip:getData', function()
    TriggerClientEvent('aj-tunnerchip:syncData', source, Cache,Cache2)
end)

RegisterNetEvent('aj-tunerchip:server:checkvehicle',function(slot, info)
    local src = source
    local player = AJFW.Functions.GetPlayer(src)
    if info.uses ~= 0 then
        local infos = {}
              infos.uses = info.uses - 1
        player.Functions.RemoveItem('tunerlaptop', 1, slot, nil, true)
        player.Functions.AddItem('tunerlaptop', 1, slot, infos, true)
        TriggerClientEvent('aj-tunerchip:client:openChip', src)
    else
        TriggerClientEvent('AJFW:Notify', src, "Chip Is Broken", 'error')
    end
end)

RegisterServerEvent('aj-tunerchip:server:TuneStatus')
AddEventHandler('aj-tunerchip:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

AJFW.Functions.CreateCallback('aj-tunerchip:server:HasChip', function(source, cb)
    local src = source
    local Ply = AJFW.Functions.GetPlayer(src)
    local Chip = Ply.Functions.GetItemByName('tunerlaptop')

    if Chip ~= nil then
        cb(true)
    else
        DropPlayer(src, 'This is not the idea, is it?')
        cb(true)
    end
end)

AJFW.Functions.CreateCallback('aj-tunerchip:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)

AJFW.Functions.CreateUseableItem("nitrous", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)

    TriggerClientEvent('smallresource:client:LoadNitrous', source)
end)

RegisterServerEvent('nitrous:server:LoadNitrous')
AddEventHandler('nitrous:server:LoadNitrous', function(Plate)
    VehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    TriggerClientEvent('nitrous:client:LoadNitrous', -1, Plate)
end)

RegisterServerEvent('nitrous:server:SyncFlames')
AddEventHandler('nitrous:server:SyncFlames', function(netId)
    TriggerClientEvent('nitrous:client:SyncFlames', -1, netId, source)
end)

RegisterServerEvent('nitrous:server:UnloadNitrous')
AddEventHandler('nitrous:server:UnloadNitrous', function(Plate)
    VehicleNitrous[Plate] = nil
    TriggerClientEvent('nitrous:client:UnloadNitrous', -1, Plate)
end)
RegisterServerEvent('nitrous:server:UpdateNitroLevel')
AddEventHandler('nitrous:server:UpdateNitroLevel', function(Plate, level)
    VehicleNitrous[Plate].level = level
    TriggerClientEvent('nitrous:client:UpdateNitroLevel', -1, Plate, level)
end)

RegisterServerEvent('nitrous:server:StopSync')
AddEventHandler('nitrous:server:StopSync', function(plate)
    TriggerClientEvent('nitrous:client:StopSync', -1, plate)
end)
