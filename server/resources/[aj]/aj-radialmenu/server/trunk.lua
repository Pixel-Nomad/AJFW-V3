local AJFW = exports['aj-base']:GetCoreObject()
local trunkBusy = {}

function IsCloseToTarget(source, target)
    if not DoesPlayerExist(target) then return false end
    return #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) < 2.0
end

RegisterNetEvent('aj-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('aj-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterNetEvent('aj-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

RegisterNetEvent('aj-trunk:server:KidnapTrunk', function(target, closestVehicle)
    local src = source
    if not IsCloseToTarget(src, target) then return end
    TriggerClientEvent('aj-trunk:client:KidnapGetIn', target, closestVehicle)
end)

AJFW.Functions.CreateCallback('aj-trunk:server:getTrunkBusy', function(_, cb, plate)
    if trunkBusy[plate] then cb(true) return end
    cb(false)
end)

AJFW.Commands.Add("getintrunk", Lang:t("general.getintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('aj-trunk:client:GetIn', source)
end)

AJFW.Commands.Add("putintrunk", Lang:t("general.putintrunk_command_desc"), {}, false, function(source)
    TriggerClientEvent('aj-trunk:server:KidnapTrunk', source)
end)