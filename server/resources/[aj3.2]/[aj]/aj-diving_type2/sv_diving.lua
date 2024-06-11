local AJFW = exports['aj-base']:GetCoreObject()

RegisterNetEvent("jacob-diving:collected", function(type, item, count)    
    local xPlayer = AJFW.Functions.GetPlayer(source)    
    if xPlayer then      
        if type == "normal" then
            xPlayer.Functions.AddItem(item, count)            
            TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[item], "add")        
        elseif type == "rare" then
            xPlayer.Functions.AddItem(item, count)            
            TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[item], "add")        
        else
            TriggerClientEvent("AJFW:Notify", source, "You got nothing")
        end
	end
end)