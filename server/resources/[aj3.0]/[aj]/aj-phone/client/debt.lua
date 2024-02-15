-- NUI Callback

-- Used for assts and to pay off the entire LOAN
RegisterNUICallback('SendAllPayment', function(data, cb)
    -- All your cracked code here brains here

    TriggerServerEvent('aj-Debts:server:PayFull', tonumber(data.id))

    cb("ok")
end)

RegisterNUICallback('SendMinimumPayment', function(data, cb)
    -- All your cracked code here brains here
    TriggerServerEvent('aj-Debts:server:PayPartial', tonumber(data.id))
    cb("ok")
end)


RegisterNUICallback('GetPlayersDebt', function(_, cb)
    local debtData = Config.ajFinances and exports['aj-finances']:getDebt() or {}
    cb(debtData)
end)


-- refresh the shit

RegisterNetEvent('aj-phone:client:refreshDebt', function()
    local debtData = Config.ajFinances and exports['aj-finances']:getDebt() or {}
    SendNUIMessage({
        action = "refreshDebt",
        debt = debtData,
    })
end)