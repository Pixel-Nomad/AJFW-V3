local AJFW = exports['aj-base']:GetCoreObject()

AJFW.Functions.CreateUseableItem("radio", function(source)
    TriggerClientEvent('aj-radio:use', source)
end)

for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local Player = AJFW.Functions.GetPlayer(source)
        return config[Player.PlayerData.job.name] and Player.PlayerData.job.onduty
    end)
end
