local aaaaa = 'Player/PlayerConnected'
AddEventHandler('PlayerConnected', function()
    Citizen.Wait(1000)
    Jobs_police_crime_c(source)
end)