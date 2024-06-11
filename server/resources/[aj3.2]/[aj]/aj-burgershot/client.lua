local AJFW = exports['aj-base']:GetCoreObject()

local function open(value)
    exports['aj-menu']:openMenu(value)
end

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
     exports['aj-target']:RemoveZone("burgershot-tray1")
     exports['aj-target']:RemoveZone("burgershot-tray2")
     exports['aj-target']:RemoveZone("burgershot-tray3")
     exports['aj-target']:RemoveZone("burgershot-icecream")
     exports['aj-target']:RemoveZone("burgershot-drinks")
     exports['aj-target']:RemoveZone("burgershot-boss")
     exports['aj-target']:RemoveZone("burgershot-storage1")
     exports['aj-target']:RemoveZone("burgershot-stove")
     exports['aj-target']:RemoveZone("burgershot-oven")
     exports['aj-target']:RemoveZone("burgershot-storage2")
     exports['aj-target']:RemoveZone("burgershot-making")
   end
end)

RegisterNetEvent('aj-burgershot:client:Tray1', function()
    TriggerEvent("inventory:client:SetCurrentStash", "open_bs_tray1")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "open_bs_tray1", {
        maxweight = 100000,
        slots = 20,
    })
end)

RegisterNetEvent('aj-burgershot:client:Tray2', function()
    TriggerEvent("inventory:client:SetCurrentStash", "open_bs_tray2")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "open_bs_tray2", {
        maxweight = 100000,
        slots = 20,
    })
end)


RegisterNetEvent('aj-burgershot:client:Tray3', function()
    TriggerEvent("inventory:client:SetCurrentStash", "open_bs_tray3")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "open_bs_tray3", {
        maxweight = 100000,
        slots = 20,
    })
end)

RegisterNetEvent('aj-burgershot:client:storage1', function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", 'shopone', Config.burgershot)
end)

RegisterNetEvent('aj-burgershot:client:storage2', function()
    TriggerEvent("inventory:client:SetCurrentStash", "bs_Storage_room")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "bs_Storage_room", {
        maxweight = 10000000,
        slots = 1000,
    })
end)

local making = false

RegisterNetEvent('aj-burgershot:client:stove', function()
    local HasItem = AJFW.Functions.HasItem('potato')
    if HasItem then
        if not making then
            making = true
            AJFW.Functions.Progressbar('frying', 'Making Fries','orange', math.random(10000,20000), false, true, { -- Name | Label | Time | useWhileDead | canCancel
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                making = false
                TriggerServerEvent("AJFW:Server:RemoveItem", 'potato', 1)
                TriggerServerEvent("AJFW:Server:AddItem", 'bs_fries', 1)
            end, function()
                making = false
            end)
        end
    else
        AJFW.Functions.Notify('What Are you frying', 'error', 3000)
    end
end)

RegisterNetEvent('aj-burgershot:client:oven', function()
    local HasItem = AJFW.Functions.HasItem('chickenpatty')
    if HasItem then
        if not making then
            making = true
            AJFW.Functions.Progressbar('frying', 'Making Patty','orange', math.random(10000,20000), false, true, { -- Name | Label | Time | useWhileDead | canCancel
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                making = false
                TriggerServerEvent("AJFW:Server:RemoveItem", 'chickenpatty', 1)
                TriggerServerEvent("AJFW:Server:AddItem", 'bs_patty', 1)
            end, function()
                making = false
            end)
        end
    else
        AJFW.Functions.Notify('What Are you cooking', 'error', 3000)
    end
end)


CreateThread(function()
    exports['aj-target']:AddBoxZone("burgershot-tray1", vector3(-1195.95, -891.37, 13.98), 0.9, 0.6, {
        name="burgershot-tray1",
        heading=305.09,
        debugPoly=false,
        minZ=13.94834,
        maxZ=14.47834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-burgershot:client:Tray1",
                    icon = "fas fa-box",
                    label = "Open Tray",
                    job = all,
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-tray2", vector3(-1194.95, -892.87, 13.98), 0.9, 0.6, {
        name="burgershot-tray2",
        heading=305.09,
        debugPoly=false,
        minZ=13.94834,
        maxZ=14.47834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-burgershot:client:Tray2",
                    icon = "fas fa-box",
                    label = "Open Tray",
                    job = all,
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-tray3", vector3(-1193.95, -894.37, 13.98), 0.9, 0.6, {
        name="burgershot-tray3",
        heading=305.09,
        debugPoly=false,
        minZ=13.94834,
        maxZ=14.47834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-burgershot:client:Tray3",
                    icon = "fas fa-box",
                    label = "Open Tray",
                    job = all,
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-icecream", vector3(-1192.95, -895.87, 13.98), 0.8, 1.9, {
        name="burgershot-icecream",
        heading=305.09,
        debugPoly=false,
        minZ=13.14834,
        maxZ=14.17834,
        }, {
            options = {
                {
                    type = "client",
                    event = "crafting:bs_icecream",
                    icon = "fas fa-box",
                    label = "Open Freezer",
                    job = 'burgershot',
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-drinks", vector3(-1189.77, -904.3, 15.03), 0.95, 2.2, {
        name="burgershot-drinks",
        heading=304.09,
        debugPoly=false,
        minZ=13.94834,
        maxZ=14.77834,
        }, {
            options = {
                {
                    type = "client",
                    event = "crafting:bs_drinks",
                    icon = "fas fa-box",
                    label = "Make Drink",
                    job = 'burgershot',
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-boss", vector3(-1178.21, -896.38, 15.17), 0.3, 0.7, {
        name="burgershot-boss",
        heading=304.09,
        debugPoly=false,
        minZ=13.84834,
        maxZ=14.27834,
        }, {
            options = {
                {
                    type = "client",
                    event = "bossmenu:open",
                    icon = "fas fa-box",
                    label = "Open Bossmenu",
                    job = {
                        ["burgershot"] = 4,
                    }
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-storage1", vector3(-1196.6, -902.02, 15.01), 0.7, 1.6, {
        name="burgershot-storage1",
        heading=214.09,
        debugPoly=false,
        minZ=13.44834,
        maxZ=15.17834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-burgershot:client:storage1",
                    icon = "fas fa-box",
                    label = "Open Fridge",
                    job = 'burgershot',
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-stove", vector3(-1202.08, -898.58, 14.98), 1.0, 1.5, {
        name="burgershot-stove",
        heading=304.09,
        debugPoly=false,
        minZ=13.04834,
        maxZ=14.57834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-burgershot:client:stove",
                    icon = "fas fa-box",
                    label = "Fry Fries",
                    job = 'burgershot',
                },
            },
            distance = 1.5
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-oven", vector3(-1203.78, -896.02, 14.96), 1.4, 1.5, {
        name="burgershot-oven",
        heading=304.09,
        debugPoly=false,
        minZ=14.04834,
        maxZ=14.97834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-burgershot:client:oven",
                    icon = "fas fa-box",
                    label = "Cook Patty",
                    job = 'burgershot',
                },
            },
            distance = 1.0
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-storage2", vector3(-1204.7, -891.71, 14.96), 3.5, 3.8, {
        name="burgershot-storage2",
        heading=304.09,
        debugPoly=false,
        minZ=13.05834,
        maxZ=16.97834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-burgershot:client:storage2",
                    icon = "fas fa-box",
                    label = "Access Storage room",
                    job = 'burgershot',
                },
            },
            distance = 5.0
        }
    )
    exports['aj-target']:AddBoxZone("burgershot-making", vector3(-1199.97, -896.79, 14.98), 1.2, 4.7, {
        name="burgershot-making",
        heading=304.09,
        debugPoly=false,
        minZ=13.05834,
        maxZ=16.97834,
        }, {
            options = {
                {
                    type = "client",
                    event = "crafting:bs_maker",
                    icon = "fas fa-box",
                    label = "Make Burgers",
                    job = 'burgershot',
                },
            },
            distance = 0.8
        }
    )
end)

-- print(' o W g G ')
-- print(' « Ä ')
-- print(' ! M 5 § U ')
-- print(' , \\ £ ')
-- print(' 7 + # c π ')
-- print(' B Ü ◙ j * ¬ ')
-- print(' M a 1 ± q ')
-- print(' X x 8 ')
-- print(' c τ ƒ ')