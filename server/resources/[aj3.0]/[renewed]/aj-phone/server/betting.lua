local AJFW = exports['aj-base']:GetCoreObject()

local CasinoTable = {}
local BetNumber = 0
RegisterNetEvent('aj-phone:server:CasinoAddBet', function(data)
    BetNumber += 1
    CasinoTable[BetNumber] = {['Name'] = data.name, ['chanse'] = data.chanse, ['id'] = BetNumber}
    TriggerClientEvent('aj-phone:client:addbetForAll', -1, CasinoTable)
end)

local CasinoBetList = {}
local casino_status = true

RegisterNetEvent('aj-phone:server:BettingAddToTable', function(data)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local amount = tonumber(data.amount)
    local CSN = Player.PlayerData.citizenid
    if casino_status then
        if Player.PlayerData.money.bank >= amount then
            if not CasinoBetList[CSN] then
                Player.Functions.RemoveMoney('bank', amount, "casino betting")
                CasinoBetList[CSN] = {['csn'] = CSN, ['amount'] = amount, ['player'] = data.player, ['chanse'] = data.chanse, ['id'] = data.id}
            else
                TriggerClientEvent('AJFW:Notify', src, "You are already betting...", "error")
            end
        else
            TriggerClientEvent('AJFW:Notify', src, "You do not have enough money!", "error")
        end
    else
        TriggerClientEvent('AJFW:Notify', src, "Betting is not active...", "error")
    end
end)

RegisterNetEvent('aj-phone:server:DeleteAndClearTable', function()
    local src = source
    CasinoTable = {}
    CasinoBetList = {}
    BetNumber = 0
    TriggerClientEvent('aj-phone:client:addbetForAll', -1, CasinoTable)
    TriggerClientEvent('AJFW:Notify', src, "Done", "primary")
end)

AJFW.Functions.CreateCallback('aj-phone:server:CheckHasBetTable', function(_, cb)
    cb(CasinoTable)
end)


RegisterNetEvent('aj-phone:server:casino_status', function()
    casino_status = not casino_status
end)

AJFW.Functions.CreateCallback('aj-phone:server:CheckHasBetStatus', function(_, cb)
    cb(casino_status)
end)

RegisterNetEvent('aj-phone:server:WineridCasino', function(data)
    local Winer = data.id
    for _, v in pairs(CasinoBetList) do
        if v.id == Winer then
            local OtherPly = AJFW.Functions.GetPlayerByCitizenId(v.csn)
            if OtherPly then
                local amount = v.amount * v.chanse
                OtherPly.Functions.AddMoney('bank', tonumber(amount), "casino winner")
            end
        end
    end
end)