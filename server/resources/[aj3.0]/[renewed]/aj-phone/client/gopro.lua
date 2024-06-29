if GetResourceState('brazzers-cameras') == 'started' then
    RegisterNUICallback('SetupGoPros', function(_, cb)
        local list = Config.BrazzersCameras and exports['brazzers-cameras']:GetMyCams() or {}
        cb(list)
    end)

    RegisterNUICallback('gopro-viewcam', function(data, cb)
        if not data then return end
        TriggerEvent('aj-Cameras:ViewCamera', tonumber(data.id))
        cb("ok")
    end)

    RegisterNUICallback('gopro-track', function(data, cb)
        TriggerEvent('aj-Cameras:client:TrackCam', data.id)
        if not data then return end
        cb("ok")
    end)

    RegisterNUICallback('gopro-transfer', function(data, cb)
        if not data then return end
        TriggerEvent("aj-Cameras:client:GrantAccess", tonumber(data.id), tonumber(data.stateid))
        cb("ok")
    end)
end