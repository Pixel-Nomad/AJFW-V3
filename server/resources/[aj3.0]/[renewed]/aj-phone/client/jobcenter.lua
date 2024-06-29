NoVPN = {}
CreateThread(function ()
    for _, v in pairs(Config.JobCenter) do
        if v.vpn == false then
            NoVPN[#NoVPN+1] = v
        end
    end
end)

RegisterNUICallback('GetJobCentersJobs', function(data, cb)
    local result = AJFW.Functions.HasItem("vpn", 1)
    if result then
        cb(Config.JobCenter)
    else
        cb(NoVPN)
    end
end)

RegisterNUICallback('CasinoPhoneJobCenter', function(data)
    TriggerEvent(data.event)
end)

RegisterNetEvent('aj-phone:jobcenter:tow', function()
    TriggerEvent('aj-phone:client:CustomNotification',
        'JOB CENTER',
        'GPS Waypoint Set',
        'fas fa-briefcase',
        '#2496f2',
        5000
    )
    SetNewWaypoint(-191.48, -1158.67)
end)

RegisterNetEvent('aj-phone:jobcenter:fish', function()
    TriggerEvent('aj-phone:client:CustomNotification',
        'JOB CENTER',
        'GPS Waypoint Set',
        'fas fa-briefcase',
        '#2496f2',
        5000
    )
    SetNewWaypoint(-335.15, 6105.79)
end)

RegisterNetEvent('aj-phone:jobcenter:postop', function()
    TriggerEvent('aj-phone:client:CustomNotification',
        'JOB CENTER',
        'GPS Waypoint Set',
        'fas fa-briefcase',
        '#2496f2',
        5000
    )
    SetNewWaypoint(-427.78, -2774.04)
end)

RegisterNetEvent('aj-phone:jobcenter:sanitation', function()
    TriggerEvent('aj-phone:client:CustomNotification',
        'JOB CENTER',
        'GPS Waypoint Set',
        'fas fa-briefcase',
        '#2496f2',
        5000
    )
    SetNewWaypoint(-321.83, -1545.94)
end)

RegisterNetEvent('aj-phone:jobcenter:pdimpound', function()
    TriggerEvent('aj-phone:client:CustomNotification',
        'JOB CENTER',
        'GPS Waypoint Set',
        'fas fa-briefcase',
        '#2496f2',
        5000
    )
    SetNewWaypoint(442.05, -1013.97)
end)