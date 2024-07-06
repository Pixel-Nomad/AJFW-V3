local AJFW = exports['aj-base']:GetCoreObject()

RegisterNetEvent('aj-rentals:server:depositpayout', function(key)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
        Player.Functions.AddMoney('bank', Config.Data[key]['deposit'], "", true)
        exports['aj-Banking']:handleTransaction(
            Player.PlayerData.citizenid,
            "Personal Account / " .. Player.PlayerData.citizenid, 
            Config.Data[key]['deposit'], 
            'rental deposit return', 
            name, 
            Player.PlayerData.citizenid, 
            "deposit"
        )
    end
end)

RegisterNetEvent('aj-rental:rentalpapers', function(plate, model, money)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local info = {}
    info.citizenid = Player.PlayerData.citizenid
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.plate = plate
    info.model = model
    TriggerClientEvent('inventory:client:ItemBox', src,  AJFW.Shared.Items["rentalpapers"], 'add')
    Player.Functions.AddItem('rentalpapers', 1, false, info)
    Player.Functions.RemoveMoney('bank', money, "vehicle-rental", true)
    local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    exports['aj-Banking']:handleTransaction(
        Player.PlayerData.citizenid,
        "Personal Account / " .. Player.PlayerData.citizenid, 
        money, 
        'Payed Vehicle Rantel Deposit', 
        Player.PlayerData.citizenid, 
        name, 
        "withdraw"
    )
end)

RegisterServerEvent('aj-rental:removepapers', function(plate, model, money)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src,  AJFW.Shared.Items["rentalpapers"], 'remove')
    Player.Functions.RemoveItem('rentalpapers', 1, false, info)
end)

RegisterNetEvent('aj-rentals:server:healthcheck', function(health, key)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if health <= 450 then 
        TriggerClientEvent("AJFW:Notify", src, "The car seems damaged you are being charged $"..Config.Data[key]['RepairHigh'].." for the repairs.", "error", 5000)
        Player.Functions.RemoveMoney("bank", Config.Data[key]['RepairHigh'] , "Vehicle has been sent for repairs.", true)
        local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
        exports['aj-Banking']:handleTransaction(
            Player.PlayerData.citizenid,
            "Personal Account / " .. Player.PlayerData.citizenid, 
            Config.Data[key]['RepairHigh'], 
            'Payed Vehicle Rantel Repair Cost', 
            Player.PlayerData.citizenid, 
            name, 
            "withdraw"
        )
    elseif health <= 800 then
        TriggerClientEvent("AJFW:Notify", src, "The car seems damaged you are being charged $"..Config.Data[key]['RepairLow'].." for the repairs.", "error", 5000)
        Player.Functions.RemoveMoney("bank", Config.Data[key]['RepairLow'] , "Vehicle has been sent for repairs.", true)
        local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
        exports['aj-Banking']:handleTransaction(
            Player.PlayerData.citizenid,
            "Personal Account / " .. Player.PlayerData.citizenid, 
            Config.Data[key]['RepairLow'], 
            'Payed Vehicle Rantel Repair Cost', 
            Player.PlayerData.citizenid, 
            name, 
            "withdraw"
        )
    end
end)