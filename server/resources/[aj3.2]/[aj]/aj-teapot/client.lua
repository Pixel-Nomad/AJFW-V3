local AJFW = exports['aj-base']:GetCoreObject()
local PlayerJob = {}

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    PlayerJob = AJFW.Functions.GetPlayerData().job
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    PlayerJob = {}
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('aj-tea:storage', function(data)
    TriggerEvent("inventory:client:SetCurrentStash", "The_Little_Teapot")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "The_Little_Teapot", {
        maxweight = 4000000,
        slots = 500,
    })
end)

RegisterNetEvent('aj-tea:storage2', function(data)
    if PlayerJob.grade.level == 2 or PlayerJob.grade.level == 1 then
        TriggerEvent("inventory:client:SetCurrentStash", "The_Little_Teapot_Boss")
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "The_Little_Teapot_Boss", {
            maxweight = 4000000,
            slots = 500,
        })
    end
end)

RegisterNetEvent('aj-tea:shop', function(data)
    if PlayerJob.grade.level == 2 then
        TriggerEvent('dpemote:custom:animation', {"leanbar"})
        TriggerServerEvent("inventory:server:OpenInventory", "shop", 'teapot', Config.Teapot)
        Citizen.Wait(3000)
        TriggerEvent('dpemote:custom:animation', {"c"})
    end
end)

RegisterNetEvent('aj-tea:order', function(data)
    TriggerEvent("inventory:client:SetCurrentStash", "Teapot_Tray")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "Teapot_Tray", {
        maxweight = 4000000,
        slots = 500,
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
     exports['aj-target']:RemoveZone("teastorage")
     exports['aj-target']:RemoveZone("teaorder")
     exports['aj-target']:RemoveZone("teastorage2")
     exports['aj-target']:RemoveZone("teashop")
    end
 end)
 
 CreateThread(function()
     exports['aj-target']:AddBoxZone("teastorage", vector3(-504.58, -24.01, 45.73), 0.2, 1.5, {
         name="Tea",
         heading=358.54,
         debugPoly=false,
         minZ=41.84834,
         maxZ=46.77834,
         }, {
             options = {
                 {
                     type = "client",
                     event = "aj-tea:storage",
                     icon = "fas fa-box",
                     label = "Open Storage",
                     job = 'littleteapot',
                 },
             },
             distance = 1.0
         }
     )
     exports['aj-target']:AddBoxZone("teaorder", vector3(-506.06, -26.74, 45.73), 0.5, 1.9, {
         name="Tea",
         heading=94.06,
         debugPoly=false,
         minZ=45.44834,
         maxZ=46.17834,
         }, {
             options = {
                 {
                     type = "client",
                     event = "aj-tea:order",
                     icon = "fas fa-box",
                     label = "Take Order",
                     job = all,
                 },
             },
             distance = 2.0
         }
     )
     exports['aj-target']:AddBoxZone("teastorage2", vector3(-504.00, -36.46, 45.73), 0.8, 1.55, {
        name="Tea",
        heading=271.06,
        debugPoly=false,
        minZ=44.84834,
        maxZ=46.77834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-tea:storage2",
                    icon = "fas fa-box",
                    label = "Open Storage Management",
                    job = 'littleteapot',
                },
            },
            distance = 1.0
        }
    )
    exports['aj-target']:AddBoxZone("teashop", vector3(-510.25, -35.82, 45.73), 0.4, 1.7, {
        name="Tea",
        heading=90.17,
        debugPoly=false,
        minZ=44.84834,
        maxZ=45.60834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-tea:shop",
                    icon = "fas fa-box",
                    label = "Open Storage Boss",
                    job = 'littleteapot',
                },
            },
            distance = 2.0
        }
    )
 end)