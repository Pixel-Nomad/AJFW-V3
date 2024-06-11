local AJFW = exports['aj-base']:GetCoreObject()

if Config.UseableItems then

    AJFW.Functions.CreateUseableItem("newscam", function(source)
        TriggerClientEvent("Cam:ToggleCam", source)
    end)

    AJFW.Functions.CreateUseableItem("newsmic", function(source)
        TriggerClientEvent("Mic:ToggleMic", source)
    end)

    AJFW.Functions.CreateUseableItem("newsbmic", function(source)
        TriggerClientEvent("Mic:ToggleBMic", source)
    end)

else

    local Player = AJFW.Functions.GetPlayer(source)
    AJFW.Commands.Add("newscam", "Grab a news camera", {}, false, function(source, _)
        if Player.PlayerData.job.name ~= "reporter" then return end
        TriggerClientEvent("Cam:ToggleCam", source)
    end)

    AJFW.Commands.Add("newsmic", "Grab a news microphone", {}, false, function(source, _)
        if Player.PlayerData.job.name ~= "reporter" then return end
        TriggerClientEvent("Mic:ToggleMic", source)
    end)

    AJFW.Commands.Add("newsbmic", "Grab a Boom microphone", {}, false, function(source, _)
        if Player.PlayerData.job.name ~= "reporter" then return end
        TriggerClientEvent("Mic:ToggleBMic", source)
    end)
end