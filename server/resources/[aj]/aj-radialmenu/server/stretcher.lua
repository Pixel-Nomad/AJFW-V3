RegisterNetEvent('aj-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('aj-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('aj-radialmenu:Stretcher:BusyCheck', function(id, type)
    TriggerClientEvent('aj-radialmenu:Stretcher:client:BusyCheck', id, source, type)
end)

RegisterNetEvent('aj-radialmenu:server:BusyResult', function(isBusy, otherId, type)
    TriggerClientEvent('aj-radialmenu:client:Result', otherId, isBusy, type)
end)