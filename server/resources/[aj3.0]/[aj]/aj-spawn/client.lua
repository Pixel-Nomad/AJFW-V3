local AJFW = exports['aj-base']:GetCoreObject()
local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000
local choosingSpawn = false
local Houses = {}
local cam, cam2 = nil, nil

-- Functions

local function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

-- Events

RegisterNetEvent('aj-spawn:client:openUI', function(value)
    SetEntityVisible(PlayerPedId(), false)
    DoScreenFadeOut(1000)
    Wait(1000)
    AJFW.Functions.GetPlayerData(function(PlayerData)
        -- cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + camZPlus1, -85.00, 0.00, 0.00, 100.00, false, 0)
        -- SetCamActive(cam, true)
        -- RenderScriptCams(true, false, 1, true, true)
    end)
    Wait(500)
    SetDisplay(value)
    Wait(500)
    DoScreenFadeIn(250)
end)

-- RegisterNetEvent('aj-houses:client:setHouseConfig', function(houseConfig)
--     Houses = houseConfig
-- end)

RegisterNetEvent('aj-spawn:client:setupSpawns', function(cData, new, apps)
    if not new then
        AJFW.Functions.TriggerCallback('aj-spawn:server:getOwnedHouses', function(houses)
            local myHouses = {}
            if houses ~= nil then
                for i = 1, (#houses), 1 do
                    myHouses[#myHouses+1] = {
                        house = houses[i].house,
                        label = houses[i].house,
                    }
                end
            end
            Wait(500)
            local Apartment = nil
            local ApartmentName = nil
            AJFW.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
                if result then
                    Apartment = Apartments.Locations[result.type]
                    ApartmentName = result.name
                else
                    Apartment = 'none'
                    ApartmentName = 'none'
                end
            end)
            while Apartment == nil and ApartmentName == nil do
                Wait(0)
            end
            if cData.job.type == 'leo' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsPolice,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'ambulance' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsDoctor,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'government' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsGovernment,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'doj' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsDOJ,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'mechanic' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsMechanic,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'pdm' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsPDM,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'edm' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsEDM,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'catcafe' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsCatcafe,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'burgershot' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsBurgershot,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            elseif cData.job.name == 'realestate' then
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsRealestate,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            else
                SendNUIMessage({
                    action = "setupLocations",
                    locations = AJ.SpawnsPlayers,
                    houses = myHouses,
                    Apartment = Apartment,
                    ApartmentNames = ApartmentName,
                    Access = AJ.SpawnAccess,
                })
            end
        end, cData.citizenid)
    elseif new then
        SendNUIMessage({
            action = "setupAppartements",
            locations = apps,
        })
    end
end)

-- NUI Callbacks

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    choosingSpawn = false
end)

local cam = nil
local cam2 = nil

local function SetCam(campos)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), campos.x, campos.y, campos.z)
end

RegisterNUICallback('setCam', function(data)
    local location = tostring(data.posname)
    local type = tostring(data.type)

    DoScreenFadeOut(200)
    Wait(500)
    DoScreenFadeIn(200)

    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end

    if DoesCamExist(cam2) then
        DestroyCam(cam2, true)
    end

    if type == "current" then
        AJFW.Functions.GetPlayerData(function(PlayerData)
            -- SetCam(PlayerData.position)
        end)
    elseif type == "house" then
        -- SetCam(Houses[location].coords.enter)
    elseif type == "normal" then
        -- SetCam(AJ.Spawns[location].coords)
    elseif type == "appartment" then
        -- SetCam(Apartments.Locations[location].coords.enter)
    end
end)

RegisterNUICallback('chooseAppa', function(data)
    local ped = PlayerPedId()
    local appaYeet = data.appType
    SetDisplay(false)
    DoScreenFadeOut(500)
    Wait(5000)
    TriggerServerEvent("apartments:server:CreateApartment", appaYeet, Apartments.Locations[appaYeet].label)
    TriggerServerEvent('AJFW:Server:OnPlayerLoaded')
    TriggerEvent('AJFW:Client:OnPlayerLoaded')
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(ped, true)
end)

local function PreSpawnPlayer()
    SetDisplay(false)
    DoScreenFadeOut(500)
    Wait(2000)
end

local function PostSpawnPlayer(ped)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(1000)
end

RegisterNUICallback('spawnplayerappartment2', function(data, cb)
    PreSpawnPlayer()
    local Data = data.spawnloc
    local Data2 = data.apartName
    TriggerServerEvent('AJFW:Server:OnPlayerLoaded')
    TriggerEvent('AJFW:Client:OnPlayerLoaded')
    TriggerServerEvent('aj-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('aj-apartments:server:SetInsideMeta', 0, 0, false)
    TriggerEvent('aj-apartments:client:LastLocationHouse', Data, Data2)
    PostSpawnPlayer()
    cb('ok')
end)

RegisterNUICallback('spawnplayer', function(data)
    local location = tostring(data.spawnloc)
    local type = tostring(data.typeLoc)
    local ped = PlayerPedId()
    local PlayerData = AJFW.Functions.GetPlayerData()
    local insideMeta = PlayerData.metadata["inside"]

    if type == "current" then
        PreSpawnPlayer()
        AJFW.Functions.GetPlayerData(function(PlayerData)
            SetEntityCoords(PlayerPedId(), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityHeading(PlayerPedId(), PlayerData.position.a)
            FreezeEntityPosition(PlayerPedId(), false)
        end)

        if insideMeta.house ~= nil then
            local houseId = insideMeta.house
            -- TriggerEvent('aj-houses:client:LastLocationHouse', houseId)
            TriggerEvent('housing:client:lastLocationHouse', houseId)
        elseif insideMeta.apartment.apartmentType ~= nil or insideMeta.apartment.apartmentId ~= nil then
            local apartmentType = insideMeta.apartment.apartmentType
            local apartmentId = insideMeta.apartment.apartmentId
            TriggerEvent('aj-apartments:client:LastLocationHouse', apartmentType, apartmentId)
        elseif insideMeta.motel ~= nil and insideMeta.motel.motel ~= nil and insideMeta.motel.room ~= nil then
            local motel = insideMeta.motel.motel
            local room = insideMeta.motel.room
            TriggerEvent('jl-motel:client:spawnLastLocation', motel, room)
        end
        TriggerServerEvent('AJFW:Server:OnPlayerLoaded')
        TriggerEvent('AJFW:Client:OnPlayerLoaded')
        PostSpawnPlayer()
    elseif type == "house" then
        PreSpawnPlayer()
        TriggerEvent('housing:client:enterOwnedHouse', location)
        TriggerServerEvent('AJFW:Server:OnPlayerLoaded')
        TriggerEvent('AJFW:Client:OnPlayerLoaded')
        TriggerServerEvent('aj-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('aj-apartments:server:SetInsideMeta', 0, 0, false)
        PostSpawnPlayer()
    elseif type == "normal" then
        local pos = AJ.Spawns[location].coords
        PreSpawnPlayer()
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        TriggerServerEvent('AJFW:Server:OnPlayerLoaded')
        TriggerEvent('AJFW:Client:OnPlayerLoaded')
        TriggerServerEvent('aj-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('aj-apartments:server:SetInsideMeta', 0, 0, false)
        Wait(500)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.w)
        PostSpawnPlayer()
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(5)
        if choosingSpawn then
            DisableAllControlActions(0)
        else
            Wait(1000)
        end
    end
end)

RegisterNetEvent('aj-spawn:client:OpenUIForSelectCoord', function()
    local PlayerCoord = GetEntityCoords(PlayerPedId(), 1)
    local PlayerHeading = GetEntityHeading(PlayerPedId())
    SendNUIMessage({
        action = "AddCoord",
        Coord = {x = PlayerCoord[1], y = PlayerCoord[2], z = PlayerCoord[3], h = PlayerHeading},
            
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('CloseAddCoord', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)