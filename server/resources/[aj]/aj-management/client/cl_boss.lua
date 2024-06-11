local AJFW = exports['aj-base']:GetCoreObject()
local PlayerJob = AJFW.Functions.GetPlayerData().job
local shownBossMenu = false
local DynamicMenuItems = {}

-- UTIL
local function CloseMenuFull()
    exports['aj-menu']:closeMenu()
    exports['aj-base']:HideText()
    shownBossMenu = false
end

local function AddBossMenuItem(data, id)
    local menuID = id or (#DynamicMenuItems + 1)
    DynamicMenuItems[menuID] = deepcopy(data)
    return menuID
end

exports('AddBossMenuItem', AddBossMenuItem)

local function RemoveBossMenuItem(id)
    DynamicMenuItems[id] = nil
end

exports('RemoveBossMenuItem', RemoveBossMenuItem)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = AJFW.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    PlayerJob = AJFW.Functions.GetPlayerData().job
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('aj-bossmenu:client:OpenMenu', function()
    if not PlayerJob.name or not PlayerJob.isboss then return end

    local bossMenu = {
        {
            header = Lang:t('headers.bsm') .. string.upper(PlayerJob.label),
            icon = 'fa-solid fa-circle-info',
            isMenuHeader = true,
        },
        {
            header = Lang:t('body.manage'),
            txt = Lang:t('body.managed'),
            icon = 'fa-solid fa-list',
            params = {
                event = 'aj-bossmenu:client:employeelist',
            }
        },
        {
            header = Lang:t('body.hire'),
            txt = Lang:t('body.hired'),
            icon = 'fa-solid fa-hand-holding',
            params = {
                event = 'aj-bossmenu:client:HireMenu',
            }
        },
        {
            header = Lang:t('body.storage'),
            txt = Lang:t('body.storaged'),
            icon = 'fa-solid fa-box-open',
            params = {
                event = 'aj-bossmenu:client:Stash',
            }
        },
        {
            header = Lang:t('body.outfits'),
            txt = Lang:t('body.outfitsd'),
            icon = 'fa-solid fa-shirt',
            params = {
                event = 'aj-bossmenu:client:Wardrobe',
            }
        }
    }

    for _, v in pairs(DynamicMenuItems) do
        bossMenu[#bossMenu + 1] = v
    end

    bossMenu[#bossMenu + 1] = {
        header = Lang:t('body.exit'),
        icon = 'fa-solid fa-angle-left',
        params = {
            event = 'aj-menu:closeMenu',
        }
    }

    exports['aj-menu']:openMenu(bossMenu)
end)

RegisterNetEvent('aj-bossmenu:client:employeelist', function()
    local EmployeesMenu = {
        {
            header = Lang:t('body.mempl') .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
        },
    }
    AJFW.Functions.TriggerCallback('aj-bossmenu:server:GetEmployees', function(cb)
        for _, v in pairs(cb) do
            EmployeesMenu[#EmployeesMenu + 1] = {
                header = v.name,
                txt = v.grade.name,
                icon = 'fa-solid fa-circle-user',
                params = {
                    event = 'aj-bossmenu:client:ManageEmployee',
                    args = {
                        player = v,
                        work = PlayerJob
                    }
                }
            }
        end
        EmployeesMenu[#EmployeesMenu + 1] = {
            header = Lang:t('body.return'),
            icon = 'fa-solid fa-angle-left',
            params = {
                event = 'aj-bossmenu:client:OpenMenu',
            }
        }
        exports['aj-menu']:openMenu(EmployeesMenu)
    end, PlayerJob.name)
end)

RegisterNetEvent('aj-bossmenu:client:ManageEmployee', function(data)
    local EmployeeMenu = {
        {
            header = Lang:t('body.mngpl') .. data.player.name .. ' - ' .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info'
        },
    }
    for k, v in pairs(AJFW.Shared.Jobs[data.work.name].grades) do
        EmployeeMenu[#EmployeeMenu + 1] = {
            header = v.name,
            txt = Lang:t('body.grade') .. k,
            params = {
                isServer = true,
                event = 'aj-bossmenu:server:GradeUpdate',
                icon = 'fa-solid fa-file-pen',
                args = {
                    cid = data.player.empSource,
                    grade = tonumber(k),
                    gradename = v.name
                }
            }
        }
    end
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t('body.fireemp'),
        icon = 'fa-solid fa-user-large-slash',
        params = {
            isServer = true,
            event = 'aj-bossmenu:server:FireEmployee',
            args = data.player.empSource
        }
    }
    EmployeeMenu[#EmployeeMenu + 1] = {
        header = Lang:t('body.return'),
        icon = 'fa-solid fa-angle-left',
        params = {
            event = 'aj-bossmenu:client:OpenMenu',
        }
    }
    exports['aj-menu']:openMenu(EmployeeMenu)
end)

RegisterNetEvent('aj-bossmenu:client:Stash', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'boss_' .. PlayerJob.name, {
        maxweight = 4000000,
        slots = 25,
    })
    TriggerEvent('inventory:client:SetCurrentStash', 'boss_' .. PlayerJob.name)
end)

RegisterNetEvent('aj-bossmenu:client:Wardrobe', function()
    TriggerEvent('aj-clothing:client:openOutfitMenu')
end)

RegisterNetEvent('aj-bossmenu:client:HireMenu', function()
    local HireMenu = {
        {
            header = Lang:t('body.hireemp') .. string.upper(PlayerJob.label),
            isMenuHeader = true,
            icon = 'fa-solid fa-circle-info',
        },
    }
    AJFW.Functions.TriggerCallback('aj-bossmenu:getplayers', function(players)
        for _, v in pairs(players) do
            if v and v ~= PlayerId() then
                HireMenu[#HireMenu + 1] = {
                    header = v.name,
                    txt = Lang:t('body.cid') .. v.citizenid .. ' - ID: ' .. v.sourceplayer,
                    icon = 'fa-solid fa-user-check',
                    params = {
                        isServer = true,
                        event = 'aj-bossmenu:server:HireEmployee',
                        args = v.sourceplayer
                    }
                }
            end
        end
        HireMenu[#HireMenu + 1] = {
            header = Lang:t('body.return'),
            icon = 'fa-solid fa-angle-left',
            params = {
                event = 'aj-bossmenu:client:OpenMenu',
            }
        }
        exports['aj-menu']:openMenu(HireMenu)
    end)
end)

-- MAIN THREAD
CreateThread(function()
    if Config.UseTarget then
        for job, zones in pairs(Config.BossMenus) do
            for index, coords in ipairs(zones) do
                local zoneName = job .. '_bossmenu_' .. index
                exports['aj-target']:AddCircleZone(zoneName, coords, 0.5, {
                    name = zoneName,
                    debugPoly = false,
                    useZ = true
                }, {
                    options = {
                        {
                            type = 'client',
                            event = 'aj-bossmenu:client:OpenMenu',
                            icon = 'fas fa-sign-in-alt',
                            label = Lang:t('target.label'),
                            canInteract = function() return job == PlayerJob.name and PlayerJob.isboss end,
                        },
                    },
                    distance = 2.5
                })
            end
        end
    else
        while true do
            local wait = 2500
            local pos = GetEntityCoords(PlayerPedId())
            local inRangeBoss = false
            local nearBossmenu = false
            if PlayerJob then
                wait = 0
                for k, menus in pairs(Config.BossMenus) do
                    for _, coords in ipairs(menus) do
                        if k == PlayerJob.name and PlayerJob.isboss then
                            if #(pos - coords) < 5.0 then
                                inRangeBoss = true
                                if #(pos - coords) <= 1.5 then
                                    nearBossmenu = true
                                    if not shownBossMenu then
                                        exports['aj-base']:DrawText(Lang:t('drawtext.label'), 'left')
                                        shownBossMenu = true
                                    end
                                    if IsControlJustReleased(0, 38) then
                                        exports['aj-base']:HideText()
                                        TriggerEvent('aj-bossmenu:client:OpenMenu')
                                    end
                                end

                                if not nearBossmenu and shownBossMenu then
                                    CloseMenuFull()
                                    shownBossMenu = false
                                end
                            end
                        end
                    end
                end
                if not inRangeBoss then
                    Wait(1500)
                    if shownBossMenu then
                        CloseMenuFull()
                        shownBossMenu = false
                    end
                end
            end
            Wait(wait)
        end
    end
end)
