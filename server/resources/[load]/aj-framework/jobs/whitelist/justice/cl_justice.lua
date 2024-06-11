Modular:CreateBlip({
    ID          = 'jobs-whitelist-justice-blip',
    Type        = 'Coords',
    Coords      = vector3(-530.19, -173.02, 38.22),
    Sprite      = 304,
    Display     = 4,
    Scale       = 0.6,
    Color       = 5,
    ShortRange  = true,
    Title       = 'Court of Justice',
})

RegisterNetEvent("aj-justice:client:showLawyerLicense", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GlobalPlayerPedID, false)
    local dist = #(pos - sourcePos)
    if dist < 2.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pass-ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>CSN:</strong> {4} </div></div>',
            args = {'Advocate pass', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

RegisterNetEvent("aj-justice:client:showMayorPass", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GlobalPlayerPedID, false)
    local dist = #(pos - sourcePos)
    if dist < 2.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pass-ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>CSN:</strong> {4} </div></div>',
            args = {'Mayor Pass', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

RegisterNetEvent('covidvac:client:vaccination', function(source)
    TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items["covidvac"], "remove")
    TriggerServerEvent("AJFW:Server:RemoveItem", "covidvac", 1)    
end)


RegisterNetEvent('DOJ:ToggleDuty', function()
    TriggerServerEvent("AJFW:ToggleDuty")
end)