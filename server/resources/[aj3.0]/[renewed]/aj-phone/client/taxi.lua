RegisterNUICallback('GetAvailableTaxiDrivers', function(_, cb)
    local drivers = lib.callback.await('aj-phone:server:GetAvailableTaxiDrivers', false)
    cb(drivers)
end)

RegisterNetEvent('aj-phone:OpenAvailableTaxi', function()
    local taxiMenu = {}

    -- TO BE WRITTEN

    lib.registerContext({
        id = 'taxi_call_menu',
        title = 'Available Taxis',
        options = taxiMenu
    })
    lib.showContext('taxi_call_menu')
end)