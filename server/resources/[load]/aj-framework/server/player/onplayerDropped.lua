local aaaaa = 'Player/PlayerDropped'
AddEventHandler('playerDropped', function(reason)
    Jobs_police_crime_d(source,reason)
end)