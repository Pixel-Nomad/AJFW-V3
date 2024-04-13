if GetResourceState('aj-base') ~= 'started' then return end
AJFW = exports['aj-base']:GetCoreObject()
Framework, PlayerLoaded, PlayerData = 'aj', nil, {}

AddStateBagChangeHandler('isLoggedIn', '', function(_bagName, _key, value, _reserved, _replicated)
    if value then
        PlayerData = AJFW.Functions.GetPlayerData()
    else
        table.wipe(PlayerData)
    end
    PlayerLoaded = value
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not LocalPlayer.state.isLoggedIn then return end
    PlayerData = AJFW.Functions.GetPlayerData()
    PlayerLoaded = true
end)


AddEventHandler('gameEventTriggered', function(event, data)
	if event ~= 'CEventNetworkEntityDamage' then return end
	local victim, victimDied = data[1], data[4]
	if not IsPedAPlayer(victim) then return end
	local player = PlayerId()
	if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim))  then
        TriggerEvent('aj-fishing:onPlayerDeath')
	end
end)

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    TriggerEvent('aj-fishing:onPlayerSpawn')
end)

RegisterNetEvent('AJFW:Player:SetPlayerData', function(newPlayerData)
    if source ~= '' and GetInvokingResource() ~= 'aj-base' then return end
    PlayerData = newPlayerData
end)

function HasGroup(filter)
    local groups = { 'job', 'gang' }
    local type = type(filter)

    if type == 'string' then
        for i = 1, #groups do
            local data = PlayerData[groups[i]]

            if data.name == filter then
                return data.name, data.grade.level
            end
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for i = 1, #groups do
                local data = PlayerData[groups[i]]
                local grade = filter[data.name]

                if grade and grade <= data.grade.level then
                    return data.name, data.grade.level
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local group = filter[i]

                for j = 1, #groups do
                    local data = PlayerData[groups[j]]

                    if data.name == group then
                        return data.name, data.grade.level
                    end
                end
            end
        end
    end
end
