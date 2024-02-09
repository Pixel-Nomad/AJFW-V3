local aaaaa = 'Player/PlayerUpdate'

RegisterNetEvent('AJFW:UpdatePlayer', function(armor, health, hungerRate, thirstRate)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        if hungerRate and thirstRate then
            local newHunger = Player.PlayerData.metadata['hunger'] - hungerRate
            local newThirst = Player.PlayerData.metadata['thirst'] - thirstRate
            if newHunger <= 0 then
                newHunger = 0
            end
            if newThirst <= 0 then
                newThirst = 0
            end
            Player.Functions.SetMetaData('thirst', newThirst)
            Player.Functions.SetMetaData('hunger', newHunger)
            TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
        end
        if armor then
            local abcd = armor
            Player.Functions.SetMetaData('armor', abcd)
        end
        if health then
            local abcd = health
            Player.Functions.SetMetaData('health', abcd)
        end
        Player.Functions.Save()
    end
end)
