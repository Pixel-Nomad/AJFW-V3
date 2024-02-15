local AJFW = exports['aj-base']:GetCoreObject()

-- NUI Callback

RegisterNUICallback('GetAvailableRaces', function(_, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:GetRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('JoinRace', function(data, cb)
    TriggerServerEvent('aj-lapraces:server:JoinRace', data.RaceData)
    cb("ok")
end)

RegisterNUICallback('LeaveRace', function(data, cb)
    TriggerServerEvent('aj-lapraces:server:LeaveRace', data.RaceData)
    cb("ok")
end)

RegisterNUICallback('StartRace', function(data, cb)
    TriggerServerEvent('aj-lapraces:server:StartRace', data.RaceData.RaceId)
    cb("ok")
end)

RegisterNUICallback('SetAlertWaypoint', function(data, cb)
    local coords = data.alert.coords
    AJFW.Functions.Notify('GPS set: '..data.alert.title, "primary")
    SetNewWaypoint(coords.x, coords.y)
    cb("ok")
end)

RegisterNUICallback('GetRaces', function(_, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('aj-lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
    cb("ok")
end)

RegisterNUICallback('HasCreatedRace', function(_, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(_, cb)
    local InRace = exports['aj-lapraces']:IsInRace()
    cb(InRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:IsAuthorizedToCreateRaces', function(IsAuthorized, NameAvailable)
        local sendData = {
            IsAuthorized = IsAuthorized,
            IsBusy = exports['aj-lapraces']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(sendData)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('aj-lapraces:server:CreateLapRace', data.TrackName)
    cb("ok")
end)

RegisterNUICallback('GetRacingLeaderboards', function(_, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:GetRacingData', function(RaceData)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = #(coords - vector3(checkpointcoords.x, checkpointcoords.y, checkpointcoords.z))
        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('aj-lapraces:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            AJFW.Functions.Notify('You\'re too far away from the race. GPS set.', "error", 5000)
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == "editor" then
        cb(exports['aj-lapraces']:IsInEditor())
    else
        cb(exports['aj-lapraces']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(_, cb)
    AJFW.Functions.TriggerCallback('aj-lapraces:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

-- Events

RegisterNetEvent('aj-phone:client:RaceNotify', function(message)
    TriggerEvent('aj-phone:client:CustomNotification',
        "Racing",
        message,
        "fas fa-flag-checkered",
        "#353b48",
        3500
    )
end)

RegisterNetEvent('aj-phone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)