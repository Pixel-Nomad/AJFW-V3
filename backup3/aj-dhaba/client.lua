local AJFW = exports['aj-base']:GetCoreObject()

RegisterNetEvent('aj-dhaba:stash', function(data)
    TriggerEvent("inventory:client:SetCurrentStash", "dhabastash")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "dhabastash", {
        maxweight = 10000000,
        slots = 500,
    })
end)

RegisterNetEvent('aj-dhaba:order', function(data)
    TriggerEvent("inventory:client:SetCurrentStash", "open_dhabastash")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "open_dhabastash", {
        maxweight = 4000000,
        slots = 500,
    })
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    exports['aj-target']:RemoveZone("dhabastorage")
    exports['aj-target']:RemoveZone("dhabaorder")
   end
end)

CreateThread(function()
    exports['aj-target']:AddBoxZone("dhabastorage", vector3(-385.11, 263.22, 86.43), 0.7, 1.2, {
        name="Dhaba",
        heading=125.99,
        debugPoly=false,
        minZ=85.64834,
        maxZ=87.47834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-dhaba:stash",
                    icon = "fas fa-box",
                    label = "Open Storage",
                    job = 'dhaba',
                },
            },
            distance = 1.0
        }
    )
    exports['aj-target']:AddBoxZone("dhabaorder", vector3(-381.30, 264.92, 86.43), 0.4, 1.0, {
        name="Dhaba",
        heading=305.02,
        debugPoly=false,
        minZ=85.94834,
        maxZ=86.67834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-dhaba:order",
                    icon = "fas fa-box",
                    label = "Take Order",
                    job = all,
                },
            },
            distance = 2.0
        }
    )
end)