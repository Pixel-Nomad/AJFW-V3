local AJFW = exports['aj-base']:GetCoreObject()
local debugPoly = true

Targets['aj_target'] = {}

function Targets.aj_target.storage(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 2)

    exports['aj-target']:AddCircleZone(name, tmp_coord, 1, {
        name = name,
        debugPoly = debugPoly,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilrig:storage_menu:ShowStorage",
                icon = "fa-solid fa-arrows-spin",
                label = "View Storage",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        AJFW.Functions.Notify('You must be on duty!', "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 2.5
    })
end

function Targets.aj_target.distillation(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 1.1)

    exports['aj-target']:AddCircleZone(name, tmp_coord, 1.2, {
        name = name,
        debugPoly = debugPoly,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilrig:CDU_menu:ShowCDU",
                icon = "fa-solid fa-gear",
                label = "Open CDU panel",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        AJFW.Functions.Notify('You must be on duty!', "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 1.5
    })
end

function Targets.aj_target.toggle_job(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 1.1)

    exports['aj-target']:AddCircleZone(name, tmp_coord, 0.75, {
        name = name,
        debugPoly = debugPoly,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilrig:client:goOnDuty",
                icon = "fa-solid fa-boxes-packing",
                label = "Toggle Duty",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    return true
                end,
            },
        },
        distance = 2.5
    })
end

function Targets.aj_target.barrel_withdraw(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 1.1)

    exports['aj-target']:AddCircleZone(name, tmp_coord, 1.0, {
        name = name,
        debugPoly = debugPoly,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilrig:client_lib:withdraw_from_queue",
                icon = "fa-solid fa-boxes-packing",
                label = "Transfer withdraw to stash",
                truck = false,
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        AJFW.Functions.Notify('You must be on duty!', "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
            {
                type = "client",
                event = "aj-oilwell:client:openWithdrawStash",
                icon = "fa-solid fa-boxes-packing",
                label = "Open Withdraw Stash",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        AJFW.Functions.Notify('You must be on duty!', "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
            {
                type = "client",
                event = "aj-oilwell:client:open_purge_menu",
                icon = "fa-solid fa-trash-can",
                label = "Purge Withdraw Stash",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        AJFW.Functions.Notify('You must be on duty!', "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 2.5
    })
end

function Targets.aj_target.blender(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 2.5)

    exports['aj-target']:AddCircleZone(name, tmp_coord, 3.5, {
        name = name,
        debugPoly = debugPoly,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilrig:blender_menu:ShowBlender",
                icon = "fa-solid fa-gear",
                label = "Open blender panel",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        AJFW.Functions.Notify('You must be on duty!', "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 2.5
    })
end

function Targets.aj_target.crude_oil_transport(coords, name)
    local tmp_coord = vector3(coords.x, coords.y, coords.z + 2.5)

    exports['aj-target']:AddCircleZone(name, tmp_coord, 2, {
        name = name,
        debugPoly = debugPoly,
        useZ = true
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilwell:menu:show_transport_menu",
                icon = "fa-solid fa-boxes-packing",
                label = "Fill transport well",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then
                        AJFW.Functions.Notify('You must be on duty!', "error")
                        Wait(2000)
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 2.5
    })
end

function Targets.aj_target.oilwell(coords, name)
    local coord = vector3(coords.x, coords.y, coords.z + 2.5)

    exports['aj-target']:AddCircleZone("oil-rig-" .. name, coord, 3.5, {
        name = "oil-rig-" .. name,
        debugPoly = true,
        useZ = true,
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilrig:client:viewPumpInfo",
                icon = "fa-solid fa-info",
                label = "View Pump Info",
                canInteract = function(entity)
                    return true
                end,
            },
            {
                type = "client",
                event = "aj-oilrig:client:changeRigSpeed",
                icon = "fa-solid fa-gauge-high",
                label = "Modifiy Pump Settings",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then return false end
                    return isOwner(entity)
                end,
            },
            {
                type = "client",
                event = "aj-oilrig:client:show_oilwell_stash",
                icon = "fa-solid fa-gears",
                label = "Manange Parts",
                canInteract = function(entity)
                    if not CheckJob() then return false end
                    if not CheckOnduty() then return false end
                    return isOwner(entity)
                end,
            },
            {
                type = "client",
                event = "aj-oilwell:client:remove_oilwell",
                icon = "fa-regular fa-file-lines",
                label = "Remove Oilwell",
                canInteract = function(entity)
                    if not CheckJob() then
                        return false
                    end
                    if not (PlayerJob.grade.level == 4) then
                        return false
                    end
                    if not CheckOnduty() then
                        return false
                    end
                    return true
                end,
            },
        },
        distance = 2.5
    })
end

function Targets.aj_target.truck(plate, truck)
    exports['aj-target']:AddEntityZone("device-" .. plate, truck, {
        name = "device-" .. plate,
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "aj-oilwell:client:refund_truck",
                icon = "fa-solid fa-location-arrow",
                label = "refund Truck",
                vehiclePlate = plate
            },
        },
        distance = 2.5
    })
end
