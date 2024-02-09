local Sounds = {}

AJFW.Commands.Add('testsounds', 'Change Vehicle Sound During Dev Session', {}, false, function(source, args)
    print(source,args)
    TriggerClientEvent('aj-vehiclesounds:client:OpenMenu', source, false)
end,'dev')

AJFW.Commands.Add('changesound', 'Change Vehicle Sound', {}, false, function(source, args)
    TriggerClientEvent('aj-vehiclesounds:client:OpenMenu', source, true)
end,'dev')

RegisterNetEvent('aj-vehiclesounds:server:ChangeSound', function(Sound, ShouldSaveTODB)
    local ped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(ped)
    Entity(vehicle).state.engineSound = Sound
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('aj-vehiclesounds:client:saveSound', source, Sound)
    if ShouldSaveTODB then
        if Sounds[plate] == nil then 
            Sounds[plate] = {} 
        end
        Sounds[plate].plate = plate
        Sounds[plate].engineSound = Sound
        TriggerClientEvent('aj-sounds:client:post', -1, Sounds)
        local plate = GetVehicleNumberPlateText(vehicle)
        local result = MySQL.query.await('SELECT * FROM sounds WHERE plate = ?', {plate})
        if result[1] == nil then
            MySQL.insert.await('INSERT INTO sounds (plate, sound) VALUES (?, ?)', {plate, Sound})
        elseif result[1] then
            MySQL.query.await('UPDATE sounds SET sound = ? WHERE plate = ?',{Sound,plate})
        end
    end
end)

RegisterNetEvent('aj-sounds:client:get', function(Sound)
    TriggerClientEvent('aj-sounds:client:post', source, Sounds)
end)

CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM sounds', {})
    for _,v in pairs(result) do
        if Sounds[v.plate] == nil then 
            Sounds[v.plate] = {} 
        end
        Sounds[v.plate].plate = v.plate
        Sounds[v.plate].engineSound = v.sound
    end
end)