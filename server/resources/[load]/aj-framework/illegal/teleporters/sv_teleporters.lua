local aaaaa = 'Illegal/Teleporters'
local illegel_teleports = {
    [1] = { -- Coke
        [1] = {
            coords = vector4(2461.21, 1574.9, 33.11, 94.52),
            ["AllowVehicle"] = false, 
            drawText = '[E]',
            show = false,
            anim = false
        },
        [2] = {
            coords = vector4(-408.93, 6372.75, -39.56, 205.37),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = true,
            anim = true
        },
    },
    [2] = { -- Weed Process
        [1] = {
            coords = vector4(1066.4, -3183.42, -39.16, 97.77),
            ["AllowVehicle"] = false, 
            drawText = '[E]',
            show = true,
            anim = true
        },
        [2] = {
            coords = vector4(580.63, -421.98, 24.73, 79.3),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = false,
            anim = false
        },
    },
    [3] = { -- Weapon Repair
        [1] = {
            coords = vector4(904.7, -1686.49, 47.35, 3.31),
            ["AllowVehicle"] = false, 
            drawText = '[E]',
            show = false,
            anim = true
        },
        [2] = {
            coords = vector4(207.21, -1018.33, -99.0, 269.99),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = true,
            anim = true
        },
    },
    [4] = { -- Attachment Crafting
        [1] = {
            coords = vector4(3525.28, 3682.16, 20.99, 269.62),
            ["AllowVehicle"] = false, 
            drawText = '[E] To enter',
            show = false,
            anim = true
        },
        [2] = {
            coords = vector4(-182.24, 6539.38, 2.99, 330.87),
            ["AllowVehicle"] = false,
            drawText = '[E]',
            show = true,
            anim = true
        },
    },
}

local crafting = vector3(906.8, -1932.82, 30.62)

AJFW.Functions.CreateCallback('jacob:get:it', function(source, cb)
    -- print(illegel_teleports)
    cb(illegel_teleports)
end)

AJFW.Functions.CreateCallback('jacob:get:c', function(source, cb)
    -- print(illegel_teleports)
    cb(crafting)
end)

AJFW.Functions.CreateUseableItem('labkey2' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(2461.21, 1574.9, 33.11)
    local tp = vector4(-408.93, 6372.75, -39.56, 205.37)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive2")
    if dist <= 1 then
        if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        else
            TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        end
    end
end)

AJFW.Functions.CreateUseableItem('labkey3' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(580.63, -422.02, 24.73)
    local tp = vector4(1066.4, -3183.42, -39.16, 97.77)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive3")
    if dist <= 1 then
        if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        else
            TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        end
    end
end)

AJFW.Functions.CreateUseableItem('labkey5' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(904.7, -1686.49, 47.35)
    local tp = vector4(207.21, -1018.33, -99.0, 269.99)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive4")
    if dist <= 1 then
        if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        else
            TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        end
    end
end)

AJFW.Functions.CreateUseableItem('labkey6' , function(source, item)
    local src = source
    local Player  = AJFW.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local pCoords  = GetEntityCoords(ped)
    local tCoords  = vector3(3525.28, 3682.16, 20.99)
    local tp = vector4(-182.24, 6539.38, 2.99, 330.87)
    local dist = #(pCoords - tCoords)
    local HasDrive = Player.Functions.GetItemByName("secretdrive5")
    if dist <= 1 then
        if HasDrive then
            TriggerClientEvent('Custom:Teleport:me', src, tp)
        else
            TriggerClientEvent('AJFW:Notify', src, 'You are missing something', 'error')
        end
    end
end)

AJFW.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    if item.info.uses > 0 then
        TriggerClientEvent("lockpicks:UseLockpick", source, false, item)
    else
        TriggerClientEvent("AJFW:Notify", source, "Broken Lockpick", "error", 3000)
    end
end)

AJFW.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    if item.info.uses > 0 then
        TriggerClientEvent("lockpicks:UseLockpick", source, true, item)
    else
        TriggerClientEvent("AJFW:Notify", source, "Broken Lockpick", "error", 3000)
    end
end)