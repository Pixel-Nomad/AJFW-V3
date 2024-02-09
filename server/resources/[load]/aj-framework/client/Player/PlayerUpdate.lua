local aaaaa = 'Player/PlayerUpdate'

CreateThread(function()
    while true do
        local sleep = 0
        if LocalPlayer.state.isLoggedIn then
            sleep = (1000 * 60) * 5
            local hungerRate = 0
            local thirstRate = 0
            -- if exports["aj-buffs"]:HasBuff("super-hunger") then 
            --     hungerRate = AJFW.Config.Player.HungerRate/2 
            -- else 
                hungerRate = AJFW.Config.Player.HungerRate 
            -- end
            -- if exports["aj-buffs"]:HasBuff("super-thirst") then 
            --     thirstRate = AJFW.Config.Player.ThirstRate/2 
            -- else 
                thirstRate = AJFW.Config.Player.ThirstRate 
            -- end
            TriggerServerEvent('AJFW:UpdatePlayer', nil, nil, hungerRate, thirstRate)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        if LocalPlayer.state.isLoggedIn then
            if (PlayerData.metadata['hunger'] <= 0 or PlayerData.metadata['thirst'] <= 0) and 
               (not PlayerData.metadata['isdead'] or not PlayerData.metadata['inlaststand']) then
                local ped = GlobalPlayerPedID
                local currentHealth = GetEntityHealth(ped)
                SetEntityHealth(ped, currentHealth - math.random(5, 10))
            end
        end
    end
end)
