local aaaaa = 'Player/OnPlayerUpdate'


local function GarbageCollection(val)
    PlayerData = val
    PlayerJob = PlayerData.job
    PlayerMeta = PlayerData.metadata
    PlayerGang = PlayerData.gang
    PlayerCharinfo = PlayerData.charinfo
    PlayerMoney = PlayerData.money
    isDead     = PlayerData.metadata['isdead']
    isLastStand = PlayerData.metadata['inlaststand']
    isCuffed    = PlayerData.metadata['ishandcuffed']
end

RegisterNetEvent('AJFW:Player:SetPlayerData', function(val)
    GarbageCollection(val)
end)

RegisterNetEvent('AJFW:Player:UpdatePlayerData', function()
    local hungerRate = 0
    local thirstRate = 0
    -- if exports["aj-buffs"]:HasBuff("super-hunger") then 
        -- hungerRate = AJFW.Config.Player.HungerRate/2 
    -- else 
        hungerRate = AJFW.Config.Player.HungerRate 
    -- end
    -- if exports["aj-buffs"]:HasBuff("super-thirst") then 
        -- thirstRate = AJFW.Config.Player.ThirstRate/2 
    -- else 
        thirstRate = AJFW.Config.Player.ThirstRate 
    -- end
    TriggerServerEvent('AJFW:UpdatePlayer', GetPedArmour(GlobalPlayerPedID), GetEntityHealth(GlobalPlayerPedID), hungerRate, thirstRate)
end)