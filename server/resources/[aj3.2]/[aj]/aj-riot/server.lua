local AJFW = exports['aj-base']:GetCoreObject()

AJFW.Commands.Add("riot", "Gives Riot Shield (Police Only)", {}, false, function(source)
    local Player = AJFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.type == "leo" then
        TriggerClientEvent("Riot:ToggleRiot", source)
    else
        TriggerClientEvent('AJFW:Notify', source,  "For Police Officer Only", "error")
    end
end, 'leo')

AJFW.Commands.Add("riot2", "Gives Ballistic Riot Shield (Police Only)", {}, false, function(source)
    local Player = AJFW.Functions.GetPlayer(source)
    if Player.PlayerData.job.type == "leo" then
        TriggerClientEvent("Riot:ToggleBalRiot", source)
    else
        TriggerClientEvent('AJFW:Notify', source,  "For Police Officer Only", "error")
    end
end, 'leo')
    

RegisterNetEvent('aj-quite', function(q)
    TriggerClientEvent('aj-quite', -1, q)
end)
    
    
    