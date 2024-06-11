local AJFW = exports["aj-base"]:GetCoreObject()

AJFW.Functions.CreateUseableItem('spikestrip', function(src)
    TriggerClientEvent("aj-spikes:client:usespikes", src)
end)

RegisterNetEvent('aj-spikes:server:removespikes', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('spikestrip', 1)
end)

RegisterNetEvent("aj-spikes:server:pickupspikes", function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    -- if Player.PlayerData.job.name == 'police' then 
        Player.Functions.AddItem('spikestrip', 1)
    -- end
end)