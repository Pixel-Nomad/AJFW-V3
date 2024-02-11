local client = client
local reloadSkinTimer = GetGameTimer()

local function LoadPlayerUniform(reset)
    if reset then
        TriggerServerEvent("aj-clothMenu:server:syncUniform", nil)
        return
    end
    lib.callback("aj-clothMenu:server:getUniform", false, function(uniformData)
        if not uniformData then
            return
        end
        if Config.BossManagedOutfits then
            local result = lib.callback.await("aj-clothMenu:server:getManagementOutfits", false, uniformData.type, Framework.GetGender())
            local uniform = nil
            for i = 1, #result, 1 do
                if result[i].name == uniformData.name then
                    uniform = {
                        type = uniformData.type,
                        name = result[i].name,
                        model = result[i].model,
                        components = result[i].components,
                        props = result[i].props,
                        disableSave = true,
                    }
                    break
                end
            end

            if not uniform then
                TriggerServerEvent("aj-clothMenu:server:syncUniform", nil) -- Uniform doesn't exist anymore
                return
            end

            TriggerEvent("aj-clothMenu:client:changeOutfit", uniform)
        else
            local outfits = Config.Outfits[uniformData.jobName][uniformData.gender]
            local uniform = nil
            for i = 1, #outfits, 1 do
                if outfits[i].name == uniformData.label then
                    uniform = outfits[i]
                    break
                end
            end

            if not uniform then
                TriggerServerEvent("aj-clothMenu:server:syncUniform", nil) -- Uniform doesn't exist anymore
                return
            end

            uniform.jobName = uniformData.jobName
            uniform.gender = uniformData.gender

            TriggerEvent("aj-clothMenu:client:loadJobOutfit", uniform)
        end
    end)
end

function InitAppearance()
    Framework.UpdatePlayerData()
    lib.callback("aj-clothMenu:server:getAppearance", false, function(appearance)
        if not appearance then
            return
        end

        client.setPlayerAppearance(appearance)
        if Config.PersistUniforms then
            LoadPlayerUniform()
        end
    end)
    ResetBlips()
    if Config.BossManagedOutfits then
        Management.AddItems()
    end
    RestorePlayerStats()
end

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        InitAppearance()
    end
end)

local function getNewCharacterConfig()
    local config = GetDefaultConfig()
    config.enableExit   = false

    config.ped          = Config.NewCharacterSections.Ped
    config.headBlend    = Config.NewCharacterSections.HeadBlend
    config.faceFeatures = Config.NewCharacterSections.FaceFeatures
    config.headOverlays = Config.NewCharacterSections.HeadOverlays
    config.components   = Config.NewCharacterSections.Components
    config.props        = Config.NewCharacterSections.Props
    config.tattoos      = not Config.RCoreTattoosCompatibility and Config.NewCharacterSections.Tattoos

    return config
end

function SetInitialClothes(initial)
    client.setPlayerModel(initial.Model)
    -- Fix for tattoo's appearing when creating a new character
    local ped = cache.ped
    client.setPedTattoos(ped, {})
    client.setPedComponents(ped, initial.Components)
    client.setPedProps(ped, initial.Props)
    client.setPedHair(ped, initial.Hair, {})
    ClearPedDecorations(ped)
end

function InitializeCharacter(gender, onSubmit, onCancel)
    SetInitialClothes(Config.InitialPlayerClothes[gender])
    local config = getNewCharacterConfig()
    TriggerServerEvent("aj-clothMenu:server:ChangeRoutingBucket")
    client.startPlayerCustomization(function(appearance)
        if (appearance) then
            TriggerServerEvent("aj-clothMenu:server:saveAppearance", appearance)
            if onSubmit then
                onSubmit()
            end
        elseif onCancel then
            onCancel()
        end
        Framework.CachePed()
        TriggerServerEvent("aj-clothMenu:server:ResetRoutingBucket")
    end, config)
end

function OpenShop(config, isPedMenu, shopType)
    lib.callback("aj-clothMenu:server:hasMoney", false, function(hasMoney, money)
        if not hasMoney and not isPedMenu then
            lib.notify({
                title = "Cannot Enter Shop",
                description = "Not enough cash. Need $" .. money,
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end

        client.startPlayerCustomization(function(appearance)
            if appearance then
                if not isPedMenu then
                    TriggerServerEvent("aj-clothMenu:server:chargeCustomer", shopType)
                end
                TriggerServerEvent("aj-clothMenu:server:saveAppearance", appearance)
            else
                lib.notify({
                    title = _L("cancelled.title"),
                    description = _L("cancelled.description"),
                    type = "inform",
                    position = Config.NotifyOptions.position
                })
            end
            Framework.CachePed()
        end, config)
    end, shopType)
end

local function OpenClothingShop(isPedMenu)
    local config = GetDefaultConfig()
    config.components = true
    config.props = true

    if isPedMenu then
        config.ped = true
        config.headBlend = true
        config.faceFeatures = true
        config.headOverlays = true
        config.tattoos = not Config.RCoreTattoosCompatibility and true
    end
    OpenShop(config, isPedMenu, "clothing")
end

RegisterNetEvent("aj-clothMenu:client:openClothingShop", OpenClothingShop)

RegisterNetEvent("aj-clothMenu:client:importOutfitCode", function()
    local response = lib.inputDialog(_L("outfits.import.title"), {
        {
            type = "input",
            label = _L("outfits.import.name.label"),
            placeholder = _L("outfits.import.name.placeholder"),
            default = _L("outfits.import.name.default"),
            required = true
        },
        {
            type = "input",
            label = _L("outfits.import.code.label"),
            placeholder = "XXXXXXXXXXXX",
            required = true
        }
    })

    if not response then
        return
    end

    local outfitName = response[1]
    local outfitCode = response[2]
    if outfitCode ~= nil then
        Wait(500)
        lib.callback("aj-clothMenu:server:importOutfitCode", false, function(success)
            if success then
                lib.notify({
                    title = _L("outfits.import.success.title"),
                    description = _L("outfits.import.success.description"),
                    type = "success",
                    position = Config.NotifyOptions.position
                })
            else
                lib.notify({
                    title = _L("outfits.import.failure.title"),
                    description = _L("outfits.import.failure.description"),
                    type = "error",
                    position = Config.NotifyOptions.position
                })
            end
        end, outfitName, outfitCode)
    end
end)

RegisterNetEvent("aj-clothMenu:client:generateOutfitCode", function(id)
    lib.callback("aj-clothMenu:server:generateOutfitCode", false, function(code)
        if not code then
            lib.notify({
                title = _L("outfits.generate.failure.title"),
                description = _L("outfits.generate.failure.description"),
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end
        lib.setClipboard(code)
        lib.inputDialog(_L("outfits.generate.success.title"), {
            {
                type = "input",
                label = _L("outfits.generate.success.description"),
                default = code,
                disabled = true
            }
        })
    end, id)
end)

RegisterNetEvent("aj-clothMenu:client:saveOutfit", function()
    local response = lib.inputDialog(_L("outfits.save.title"), {
        {
            type = "input",
            label = _L("outfits.save.name.label"),
            placeholder = _L("outfits.save.name.placeholder"),
            required = true
        }
    })

    if not response then
        return
    end

    local outfitName = response[1]
    if outfitName then
        Wait(500)
        lib.callback("aj-clothMenu:server:getOutfits", false, function(outfits)
            local outfitExists = false
            for i = 1, #outfits, 1 do
                if outfits[i].name:lower() == outfitName:lower() then
                    outfitExists = true
                    break
                end
            end

            if outfitExists then
                lib.notify({
                    title = _L("outfits.save.failure.title"),
                    description = _L("outfits.save.failure.description"),
                    type = "error",
                    position = Config.NotifyOptions.position
                })
                return
            end

            local pedModel = client.getPedModel(cache.ped)
            local pedComponents = client.getPedComponents(cache.ped)
            local pedProps = client.getPedProps(cache.ped)

            TriggerServerEvent("aj-clothMenu:server:saveOutfit", outfitName, pedModel, pedComponents, pedProps)
        end)
    end
end)

RegisterNetEvent('aj-clothMenu:client:updateOutfit', function(outfitID)
    if not outfitID then return end

    lib.callback("aj-clothMenu:server:getOutfits", false, function(outfits)
        local outfitExists = false
        for i = 1, #outfits, 1 do
            if outfits[i].id == outfitID then
                outfitExists = true
                break
            end
        end

        if not outfitExists then
            lib.notify({
                title = _L("outfits.update.failure.title"),
                description = _L("outfits.update.failure.description"),
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end

        local pedModel = client.getPedModel(cache.ped)
        local pedComponents = client.getPedComponents(cache.ped)
        local pedProps = client.getPedProps(cache.ped)

        TriggerServerEvent("aj-clothMenu:server:updateOutfit", outfitID, pedModel, pedComponents, pedProps)
    end)
end)

local function RegisterChangeOutfitMenu(id, parent, outfits, mType)
    local changeOutfitMenu = {
        id = id,
        title = _L("outfits.change.title"),
        menu = parent,
        options = {}
    }
    for i = 1, #outfits, 1 do
        changeOutfitMenu.options[#changeOutfitMenu.options + 1] = {
            title = outfits[i].name,
            description = outfits[i].model,
            event = "aj-clothMenu:client:changeOutfit",
            args = {
                type = mType,
                name = outfits[i].name,
                model = outfits[i].model,
                components = outfits[i].components,
                props = outfits[i].props,
                disableSave = mType and true or false
            }
        }
    end

    table.sort(changeOutfitMenu.options, function(a, b)
        return a.title < b.title
    end)

    lib.registerContext(changeOutfitMenu)
end

local function RegisterUpdateOutfitMenu(id, parent, outfits)
    local updateOutfitMenu = {
        id = id,
        title = _L("outfits.update.title"),
        menu = parent,
        options = {}
    }
    for i = 1, #outfits, 1 do
        updateOutfitMenu.options[#updateOutfitMenu.options + 1] = {
            title = outfits[i].name,
            description = outfits[i].model,
            event = "aj-clothMenu:client:updateOutfit",
            args = outfits[i].id
        }
    end

    table.sort(updateOutfitMenu.options, function(a, b)
        return a.title < b.title
    end)

    lib.registerContext(updateOutfitMenu)
end

local function RegisterGenerateOutfitCodeMenu(id, parent, outfits)
    local generateOutfitCodeMenu = {
        id = id,
        title = _L("outfits.generate.title"),
        menu = parent,
        options = {}
    }
    for i = 1, #outfits, 1 do
        generateOutfitCodeMenu.options[#generateOutfitCodeMenu.options + 1] = {
            title = outfits[i].name,
            description = outfits[i].model,
            event = "aj-clothMenu:client:generateOutfitCode",
            args = outfits[i].id
        }
    end

    lib.registerContext(generateOutfitCodeMenu)
end

local function RegisterDeleteOutfitMenu(id, parent, outfits, deleteEvent)
    local deleteOutfitMenu = {
        id = id,
        title = _L("outfits.delete.title"),
        menu = parent,
        options = {}
    }

    table.sort(outfits, function(a, b)
        return a.name < b.name
    end)

    for i = 1, #outfits, 1 do
        deleteOutfitMenu.options[#deleteOutfitMenu.options + 1] = {
            title = string.format(_L("outfits.delete.item.title"), outfits[i].name),
            description = string.format(_L("outfits.delete.item.description"), outfits[i].model, (outfits[i].gender and (" - Gender: " .. outfits[i].gender) or "")),
            event = deleteEvent,
            args = outfits[i].id
        }
    end

    lib.registerContext(deleteOutfitMenu)
end

RegisterNetEvent("aj-clothMenu:client:OutfitManagementMenu", function(args)
    local outfits = lib.callback.await("aj-clothMenu:server:getManagementOutfits", false, args.type, Framework.GetGender())
    local managementMenuID = "aj_clothMenu_outfit_management_menu"
    local changeManagementOutfitMenuID = "aj_clothMenu_change_management_outfit_menu"
    local deleteManagementOutfitMenuID = "aj_clothMenu_delete_management_outfit_menu"

    RegisterChangeOutfitMenu(changeManagementOutfitMenuID, managementMenuID, outfits, args.type)
    RegisterDeleteOutfitMenu(deleteManagementOutfitMenuID, managementMenuID, outfits, "aj-clothMenu:client:DeleteManagementOutfit")
    local managementMenu = {
        id = managementMenuID,
        title = string.format(_L("outfits.manage.title"), args.type),
        options = {
            {
                title = _L("outfits.change.title"),
                description = string.format(_L("outfits.change.description"), args.type),
                menu = changeManagementOutfitMenuID,
            },
            {
                title = _L("outfits.save.menuTitle"),
                description = string.format(_L("outfits.save.menuDescription"), args.type),
                event = "aj-clothMenu:client:SaveManagementOutfit",
                args = args.type
            },
            {
                title = _L("outfits.delete.title"),
                description = string.format(_L("outfits.delete.description"), args.type),
                menu = deleteManagementOutfitMenuID,
            }
        }
    }

    Management.AddBackMenuItem(managementMenu, args)

    lib.registerContext(managementMenu)
    lib.showContext(managementMenuID)
end)

RegisterNetEvent("aj-clothMenu:client:SaveManagementOutfit", function(mType)
    local outfitData = {
        Type = mType,
        Model = client.getPedModel(cache.ped),
        Components = client.getPedComponents(cache.ped),
        Props = client.getPedProps(cache.ped)
    }

    local rankValues

    if mType == "Job" then
        outfitData.JobName = client.job.name
        rankValues = Framework.GetRankInputValues("job")

    else
        outfitData.JobName = client.gang.name
        rankValues = Framework.GetRankInputValues("gang")
    end

    local dialogResponse = lib.inputDialog(_L("outfits.save.managementTitle"), {
            {
                label = _L("outfits.save.name.label"),
                type = "input",
                required = true
            },
            {
                label = _L("outfits.save.gender.label"),
                type = "select",
                options = {
                    {
                        label = _L("outfits.save.gender.male"), value = "male"
                    },
                    {
                        label = _L("outfits.save.gender.female"), value = "female"
                    }
                },
                default = "male",
            },
            {
                label = _L("outfits.save.rank.label"),
                type = "select",
                options = rankValues,
                default = "0"
            }
        })

    if not dialogResponse then
        return
    end


    outfitData.Name = dialogResponse[1]
    outfitData.Gender = dialogResponse[2]
    outfitData.MinRank = tonumber(dialogResponse[3])

    TriggerServerEvent("aj-clothMenu:server:saveManagementOutfit", outfitData)

end)

local function RegisterWorkOutfitsListMenu(id, parent, menuData)
    local menu = {
        id = id,
        menu = parent,
        title = _L("jobOutfits.title"),
        options = {}
    }
    local event = "aj-clothMenu:client:loadJobOutfit"
    if Config.BossManagedOutfits then
        event = "aj-clothMenu:client:changeOutfit"
    end
    if menuData then
        for _, v in pairs(menuData) do
            menu.options[#menu.options + 1] = {
                title = v.name,
                event = event,
                args = v
            }
        end
    end
    lib.registerContext(menu)
end

function OpenMenu(isPedMenu, menuType, menuData)
    local mainMenuID = "aj_clothMenu_main_menu"
    local mainMenu = {
        id = mainMenuID
    }
    local menuItems = {}

    local outfits = lib.callback.await("aj-clothMenu:server:getOutfits", false)
    local changeOutfitMenuID = "aj_clothMenu_change_outfit_menu"
    local updateOutfitMenuID = "aj_clothMenu_update_outfit_menu"
    local deleteOutfitMenuID = "aj_clothMenu_delete_outfit_menu"
    local generateOutfitCodeMenuID = "aj_clothMenu_generate_outfit_code_menu"

    RegisterChangeOutfitMenu(changeOutfitMenuID, mainMenuID, outfits)
    RegisterUpdateOutfitMenu(updateOutfitMenuID, mainMenuID, outfits)
    RegisterDeleteOutfitMenu(deleteOutfitMenuID, mainMenuID, outfits, "aj-clothMenu:client:deleteOutfit")
    RegisterGenerateOutfitCodeMenu(generateOutfitCodeMenuID, mainMenuID, outfits)
    local outfitMenuItems = {
        {
            title = _L("outfits.change.title"),
            description = _L("outfits.change.pDescription"),
            menu = changeOutfitMenuID
        },
        {
            title = _L("outfits.update.title"),
            description = _L("outfits.update.description"),
            menu = updateOutfitMenuID
        },
        {
            title = _L("outfits.save.menuTitle"),
            description = _L("outfits.save.description"),
            event = "aj-clothMenu:client:saveOutfit"
        },
        {
            title = _L("outfits.generate.title"),
            description = _L("outfits.generate.description"),
            menu = generateOutfitCodeMenuID
        },
        {
            title = _L("outfits.delete.title"),
            description = _L("outfits.delete.mDescription"),
            menu = deleteOutfitMenuID
        },
        {
            title = _L("outfits.import.menuTitle"),
            description = _L("outfits.import.description"),
            event = "aj-clothMenu:client:importOutfitCode"
        }
    }
    if menuType == "default" then
        local header = string.format(_L("clothing.title"), Config.ClothingCost)
        if isPedMenu then
            header = _L("clothing.titleNoPrice")
        end
        mainMenu.title = _L("clothing.options.title")
        menuItems[#menuItems + 1] = {
            title = header,
            description = _L("clothing.options.description"),
            event = "aj-clothMenu:client:openClothingShop",
            args = isPedMenu
        }
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "outfit" then
        mainMenu.title = _L("clothing.outfits.title")
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "job-outfit" then
        mainMenu.title = _L("clothing.outfits.title")
        menuItems[#menuItems + 1] = {
            title = _L("clothing.outfits.civilian.title"),
            description = _L("clothing.outfits.civilian.description"),
            event = "aj-clothMenu:client:reloadSkin",
            args = true
        }

        local workOutfitsMenuID = "aj_clothMenu_work_outfits_menu"
        RegisterWorkOutfitsListMenu(workOutfitsMenuID, mainMenuID, menuData)

        menuItems[#menuItems + 1] = {
            title = _L("jobOutfits.title"),
            description = _L("jobOutfits.description"),
            menu = workOutfitsMenuID
        }
    end
    mainMenu.options = menuItems

    lib.registerContext(mainMenu)
    lib.showContext(mainMenuID)
end

RegisterNetEvent("aj-clothMenu:client:openClothingShopMenu", function(isPedMenu)
    if type(isPedMenu) == "table" then
        isPedMenu = false
    end
    OpenMenu(isPedMenu, "default")
end)

RegisterNetEvent("aj-clothMenu:client:OpenBarberShop", OpenBarberShop)

RegisterNetEvent("aj-clothMenu:client:OpenTattooShop", OpenTattooShop)

RegisterNetEvent("aj-clothMenu:client:OpenSurgeonShop", OpenSurgeonShop)

RegisterNetEvent("aj-clothMenu:client:changeOutfit", function(data)
    local pedModel = client.getPedModel(cache.ped)
    local appearanceDB
    if pedModel ~= data.model then
        local p = promise.new()
        lib.callback("aj-clothMenu:server:getAppearance", false, function(appearance)
            BackupPlayerStats()
            if appearance then
                client.setPlayerAppearance(appearance)
                RestorePlayerStats()
            else
                lib.notify({
                    title = _L("outfits.change.failure.title"),
                    description = _L("outfits.change.failure.description"),
                    type = "error",
                    position = Config.NotifyOptions.position
                })
            end
            p:resolve(appearance)
        end, data.model)
        appearanceDB = Citizen.Await(p)
    else
        appearanceDB = client.getPedAppearance(cache.ped)
    end
    if appearanceDB then
        client.setPedComponents(cache.ped, data.components)
        client.setPedProps(cache.ped, data.props)
        client.setPedHair(cache.ped, appearanceDB.hair, appearanceDB.tattoos)

        if data.disableSave then
            TriggerServerEvent("aj-clothMenu:server:syncUniform", {
                type = data.type,
                name = data.name
            }) -- Is a uniform
        else
            local appearance = client.getPedAppearance(cache.ped)
            TriggerServerEvent("aj-clothMenu:server:saveAppearance", appearance)
        end
        Framework.CachePed()
    end
end)

RegisterNetEvent("aj-clothMenu:client:DeleteManagementOutfit", function(id)
    TriggerServerEvent("aj-clothMenu:server:deleteManagementOutfit", id)
    lib.notify({
        title = _L("outfits.delete.management.success.title"),
        description = _L("outfits.delete.management.success.description"),
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

RegisterNetEvent("aj-clothMenu:client:deleteOutfit", function(id)
    TriggerServerEvent("aj-clothMenu:server:deleteOutfit", id)
    lib.notify({
        title = _L("outfits.delete.success.title"),
        description = _L("outfits.delete.success.description"),
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

RegisterNetEvent("aj-clothMenu:client:openJobOutfitsMenu", function(outfitsToShow)
    OpenMenu(nil, "job-outfit", outfitsToShow)
end)

local function InCooldown()
    return (GetGameTimer() - reloadSkinTimer) < Config.ReloadSkinCooldown
end

RegisterNetEvent("aj-clothMenu:client:reloadSkin", function(bypassChecks)
    if not bypassChecks and InCooldown() or Framework.CheckPlayerMeta() or cache.vehicle or IsPedFalling(cache.ped) then
        lib.notify({
            title = _L("commands.reloadskin.failure.title"),
            description = _L("commands.reloadskin.failure.description"),
            type = "error",
            position = Config.NotifyOptions.position
        })
        return
    end

    reloadSkinTimer = GetGameTimer()
    BackupPlayerStats()

    lib.callback("aj-clothMenu:server:getAppearance", false, function(appearance)
        if not appearance then
            return
        end
        client.setPlayerAppearance(appearance)
        if Config.PersistUniforms then
            LoadPlayerUniform(bypassChecks)
        end
        RestorePlayerStats()
    end)
end)

RegisterNetEvent("aj-clothMenu:client:ClearStuckProps", function()
    if InCooldown() or Framework.CheckPlayerMeta() then
        lib.notify({
            title = _L("commands.clearstuckprops.failure.title"),
            description = _L("commands.clearstuckprops.failure.description"),
            type = "error",
            position = Config.NotifyOptions.position
        })
        return
    end

    reloadSkinTimer = GetGameTimer()

    for _, v in pairs(GetGamePool("CObject")) do
      if IsEntityAttachedToEntity(cache.ped, v) then
        SetEntityAsMissionEntity(v, true, true)
        DeleteObject(v)
        DeleteEntity(v)
      end
    end
end)
