RegisterNetEvent('AJFW:Client:OnSharedUpdate', function(tableName, key, value)
    AJFW.Shared[tableName][key] = value
    TriggerEvent('AJFW:Client:UpdateObject')
end)

RegisterNetEvent('AJFW:Client:OnSharedUpdateMultiple', function(tableName, values)
    for key, value in pairs(values) do
        AJFW.Shared[tableName][key] = value
    end
    TriggerEvent('AJFW:Client:UpdateObject')
end)

RegisterNetEvent('AJFW:Client:SharedUpdate', function(table)
    AJFW.Shared = table
end)