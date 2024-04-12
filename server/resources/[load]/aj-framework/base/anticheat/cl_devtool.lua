RegisterNUICallback('devtool-block', function(_,cb)
    TriggerServerEvent('aj-framework:server:devtoolblock')
    cb('ok')
end)

