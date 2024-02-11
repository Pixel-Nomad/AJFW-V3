local AJFW = exports['aj-base']:GetCoreObject()
local zones = {}

-- Functions

local function OpenBank()
    AJFW.Functions.TriggerCallback('aj-banking:server:openBank', function(accounts, statements, playerData)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openBank',
            accounts = accounts,
            statements = statements,
            playerData = playerData
        })
    end)
end

local function OpenATM()
    AJFW.Functions.Progressbar('accessing_atm', Lang:t('progress.atm'), 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    }, {
        animDict = 'amb@prop_human_atm@male@enter',
        anim = 'enter',
    }, {
        model = 'prop_cs_credit_card',
        bone = 28422,
        coords = vector3(0.1, 0.03, -0.05),
        rotation = vector3(0.0, 0.0, 180.0),
    }, {}, function()
        AJFW.Functions.TriggerCallback('aj-banking:server:openATM', function(accounts, playerData, acceptablePins)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'openATM',
                accounts = accounts,
                pinNumbers = acceptablePins,
                playerData = playerData
            })
        end)
    end)
end

local function NearATM()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, v in pairs(Config.atmModels) do
        local hash = joaat(v)
        local atm = IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 1.5)
        if atm then
            return true
        end
    end
end

-- NUI Callback

RegisterNUICallback('closeApp', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:withdraw', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('deposit', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:deposit', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('internalTransfer', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:internalTransfer', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('externalTransfer', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:externalTransfer', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('orderCard', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:orderCard', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('openAccount', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:openAccount', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('renameAccount', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:renameAccount', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('deleteAccount', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:deleteAccount', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('addUser', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:addUser', function(status)
        cb(status)
    end, data)
end)

RegisterNUICallback('removeUser', function(data, cb)
    AJFW.Functions.TriggerCallback('aj-banking:server:removeUser', function(status)
        cb(status)
    end, data)
end)

-- Events

RegisterNetEvent('aj-banking:client:useCard', function()
    if NearATM() then OpenATM() end
end)

-- Threads

CreateThread(function()
    for i = 1, #Config.locations do
        local blip = AddBlipForCoord(Config.locations[i])
        SetBlipSprite(blip, Config.blipInfo.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.blipInfo.scale)
        SetBlipColour(blip, Config.blipInfo.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(tostring(Config.blipInfo.name))
        EndTextCommandSetBlipName(blip)
    end
end)

if Config.useTarget then
    CreateThread(function()
        for i = 1, #Config.locations do
            exports['aj-target']:AddCircleZone('bank_' .. i, Config.locations[i], 1.0, {
                name = 'bank_' .. i,
                useZ = true,
                debugPoly = false,
            }, {
                options = {
                    {
                        icon = 'fas fa-university',
                        label = 'Open Bank',
                        action = function()
                            OpenBank()
                        end,
                    }
                },
                distance = 1.5
            })
        end
    end)

    CreateThread(function()
        for i = 1, #Config.atmModels do
            local atmModel = Config.atmModels[i]
            exports['aj-target']:AddTargetModel(atmModel, {
                options = {
                    {
                        icon = 'fas fa-university',
                        label = 'Open ATM',
                        item = 'bank_card',
                        action = function()
                            OpenATM()
                        end,
                    }
                },
                distance = 1.5
            })
        end
    end)
end

if not Config.useTarget then
    CreateThread(function()
        for i = 1, #Config.locations do
            local zone = CircleZone:Create(Config.locations[i], 3.0, {
                name = 'bank_' .. i,
                debugPoly = false,
            })
            zones[#zones + 1] = zone
        end

        local combo = ComboZone:Create(zones, {
            name = 'bank_combo',
            debugPoly = false,
        })

        combo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                exports['aj-base']:DrawText('Open Bank')
                CreateThread(function()
                    while isPointInside do
                        Wait(0)
                        if IsControlJustPressed(0, 38) then
                            OpenBank()
                            break
                        end
                    end
                end)
            else
                exports['aj-base']:HideText()
            end
        end)
    end)
end
