local AJFW = exports['aj-base']:GetCoreObject()
AJFW.Commands.Add("fix", "Repair your vehicle (Admin Only)", {}, false, function(source)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

AJFW.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("aj-vehiclefailure:client:RepairVehicle", source)
    end
end)

AJFW.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("aj-vehiclefailure:client:CleanVehicle", source)
    end
end)

AJFW.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("aj-vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterNetEvent('aj-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = AJFW.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1, nil, nil, true)
end)

RegisterNetEvent('aj-vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = AJFW.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1, nil, nil, true)
    TriggerClientEvent('aj-vehiclefailure:client:SyncWash', -1, veh)
end)