-- NUI Callback

RegisterNUICallback('CasinoAddBet', function(data, cb)
    TriggerServerEvent('aj-phone:server:CasinoAddBet', data)
    cb("ok")
end)

RegisterNetEvent('aj-phone:client:addbetForAll', function(data)
    SendNUIMessage({
        action = "BetAddToApp",
        datas = data,
    })
end)

RegisterNUICallback('BettingAddToTable', function(data, cb)
    TriggerServerEvent('aj-phone:server:BettingAddToTable', data)
    cb("ok")
end)

RegisterNUICallback('CasinoDeleteTable', function(_, cb)
    TriggerServerEvent('aj-phone:server:DeleteAndClearTable')
    cb("ok")
end)

RegisterNUICallback('CheckHasBetTable', function(_, cb)
    local HasTable = lib.callback.await('aj-phone:server:CheckHasBetTable', false)
    cb(HasTable)
end)

RegisterNUICallback('casino_status', function(_, cb)
    TriggerServerEvent('aj-phone:server:casino_status')
    cb("ok")
end)

RegisterNUICallback('CheckHasBetStatus', function(_, cb)
    local HasStatus = lib.callback.await('aj-phone:server:CheckHasBetStatus', false)
    cb(HasStatus)
end)

RegisterNUICallback('WineridCasino', function(data, cb)
    TriggerServerEvent('aj-phone:server:WineridCasino', data)
    cb("ok")
end)