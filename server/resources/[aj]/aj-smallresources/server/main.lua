local AJFW = exports['aj-base']:GetCoreObject()

RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent('tackle:client:GetTackled', playerId)
end)

AJFW.Commands.Add('id', 'Check Your ID #', {}, false, function(source)
    TriggerClientEvent('AJFW:Notify', source, 'ID: ' .. source)
end)

AJFW.Functions.CreateUseableItem('harness', function(source, item)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    if not Player then return end

    if not Player.PlayerData.items[item.slot].info.uses then
        Player.PlayerData.items[item.slot].info.uses = Config.HarnessUses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    elseif Player.PlayerData.items[item.slot].info.uses == 1 then
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['harness'], 'remove')
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    if not Player then return end

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses -= 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('aj-carwash:server:washCar', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    if not Player then return end

    if Player.Functions.RemoveMoney('cash', Config.CarWash.defaultPrice, 'car-washed') then
        TriggerClientEvent('aj-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.CarWash.defaultPrice, 'car-washed') then
        TriggerClientEvent('aj-carwash:client:washCar', src)
    else
        TriggerClientEvent('AJFW:Notify', src, Lang:t('error.dont_have_enough_money'), 'error')
    end
end)

AJFW.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(_, cb)
    cb(#GetPlayers())
end)
