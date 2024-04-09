RegisterNetEvent('aj-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('aj-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('aj-radialmenu:Stretcher:BusyCheck', function(target, type)
    local src = source
    if not IsCloseToTarget(src, target) then return end
    TriggerClientEvent('aj-radialmenu:Stretcher:client:BusyCheck', target, source, type)
end)

RegisterNetEvent('aj-radialmenu:server:BusyResult', function(isBusy, target, type)
    local src = source
    if not IsCloseToTarget(src, target) then return end
    TriggerClientEvent('aj-radialmenu:client:Result', target, isBusy, type)
end)