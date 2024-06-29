-- NUI Callback

-- WORK IN PROGRESS
--[[
RegisterNUICallback('SetupHousingDocuments', function(_, cb)
    AJFW.Functions.TriggerCallback('aj-phone:server:GetHousingLocations', function(houses)
        cb(houses)
    end)
end)
]]

RegisterNUICallback('documents_Save_Note_As', function(data, cb)
    TriggerServerEvent('aj-phone:server:documents_Save_Note_As', data)
    cb("ok")
end)

RegisterNUICallback('document_Send_Note', function(data, cb)
    if data.Type == 'LocalSend' then
        local pID, playerPed, coords = lib.getClosestPlayer(GetEntityCoords(cache.ped), 2.5)
        if pID ~= -1 then
            local PlayerId = GetPlayerServerId(pID)
            TriggerServerEvent("aj-phone:server:sendDocumentLocal", data, PlayerId)
        else
            TriggerEvent("DoShortHudText", "No one around!", 2)
        end
    elseif data.Type == 'PermSend' then
        TriggerServerEvent('aj-phone:server:sendDocument', data)
    end
    cb("ok")
end)

RegisterNetEvent("aj-phone:client:sendingDocumentRequest", function(data, Receiver, Ply, SenderName)
    local success = exports['aj-phone']:PhoneNotification("DOCUMENTS", SenderName..' Incoming Document', 'fas fa-folder', '#b3e0f2', "NONE", 'fas fa-check-circle', 'fas fa-times-circle')
    if success then
        if data.Type == 'PermSend' then
            TriggerServerEvent("aj-phone:server:documents_Save_Note_As", data, Receiver, Ply, SenderName)
        elseif data.Type == 'LocalSend' then
            TriggerEvent('aj-phone:client:CustomNotification',
                'DOCUMENTS',
                'New Document',
                'fas fa-folder',
                '#d9d9d9',
                5000
            )

            SendNUIMessage({
                action = "DocumentSent",
                DocumentSend = {
                    title = data.Title,
                    text = data.Text,
                },
            })
        end
    end
end)

RegisterNUICallback('GetNote_for_Documents_app', function(_, cb)
    cb(PhoneData.Documents)
end)

RegisterNetEvent('aj-phone:RefReshNotes_Free_Documents', function(notes)
    PhoneData.Documents = notes
    SendNUIMessage({
        action = "DocumentRefresh",
    })
end)