local fileName = "Base/Cache"
local inProgress = false
local cooldown = false
local posX = 0.05
local posY = 0.5
local _scale = 0.5
local _font = 4


local constants = {
    PED_COMPONENTS_IDS = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
    PED_PROPS_IDS = {0, 1, 2, 6, 7},
}

local CharacterPed2 = nil

local cachecoords = vector3(-1038.94, -3573.43, 1.34)

local CACHE = {}

local MaxClothing = 0
local DoneClothing = 0
local DoneVehicle = 0
local VehicleCache = GetAllVehicleModels()
local Objects = #Config.Secure.Cache.OBJECTS
local DoneObjects = 0

local function GetValues(i, CharacterPed)
    for j = 1, #constants.PED_COMPONENTS_IDS do
        local e = constants.PED_COMPONENTS_IDS[j]
        CACHE = CACHE or {}
        CACHE[i] = CACHE[i] or {}
        CACHE[i]['component'] = CACHE[i]['component'] or {}
        CACHE[i]['component'][j] = CACHE[i]['component'][j] or {}
        CACHE[i]['component'][j].drawables = GetNumberOfPedDrawableVariations(CharacterPed, e)
        MaxClothing = MaxClothing + CACHE[i]['component'][j].drawables
        CACHE[i]['component'][j].Textures = {}
        for l = 0, CACHE[i]['component'][j].drawables do
            CACHE[i]['component'][j].Textures[l] =  GetNumberOfPedTextureVariations(CharacterPed, e, l)
            MaxClothing = MaxClothing + CACHE[i]['component'][j].Textures[l]
            Wait(10)
            if not inProgress then
                break
            end
        end
        Wait(10)
        if not inProgress then
            break
        end
    end
    for j = 1, #constants.PED_PROPS_IDS do
        local e = constants.PED_PROPS_IDS[j]
        CACHE = CACHE or {}
        CACHE[i] = CACHE[i] or {}
        CACHE[i]['props'] = CACHE[i]['props'] or {}
        CACHE[i]['props'][j] = CACHE[i]['props'][j] or {}
        CACHE[i]['props'][j].drawables = GetNumberOfPedDrawableVariations(CharacterPed, e)
        MaxClothing = MaxClothing + CACHE[i]['props'][j].drawables
        CACHE[i]['props'][j].Textures = {}
        for l = 0, CACHE[i]['props'][j].drawables do
            if l == 2 then
                CACHE[i]['props'][j].Textures[l] = 45
                MaxClothing = MaxClothing + CACHE[i]['props'][j].Textures[l]
                Wait(10)
                if not inProgress then
                    break
                end
            else
                CACHE[i]['props'][j].Textures[l] = GetNumberOfPedTextureVariations(CharacterPed, e, l)
                MaxClothing = MaxClothing + CACHE[i]['props'][j].Textures[l]
                Wait(10)
                if not inProgress then
                    break
                end
            end
            if not inProgress then
                break
            end
        end
        Wait(10)
        if not inProgress then
            break
        end
    end
end

local function DoCacheClothes(i, CharacterPed)
    for j = 1, #constants.PED_COMPONENTS_IDS do
        for m = 1, #constants.PED_COMPONENTS_IDS do
            SetPedComponentVariation(CharacterPed, constants.PED_COMPONENTS_IDS[m], 0, 0, 0)
            Wait(10)
        end
        for m = 1, #constants.PED_PROPS_IDS do
            ClearPedProp(CharacterPed, constants.PED_PROPS_IDS[m])
            Wait(10)
        end
        for l = 0, CACHE[i]['component'][j].drawables do
            SetPedComponentVariation(CharacterPed, j, l, 0, 0)
            DoneClothing = DoneClothing + 1
            Wait(25)
            for k = 1, CACHE[i]['component'][j].Textures[l] do
                SetPedComponentVariation(CharacterPed, j, l, k, 0)
                DoneClothing = DoneClothing + 1
                Wait(25)
                if not inProgress then
                    break
                end
            end
            if not inProgress then
                break
            end
        end
        if not inProgress then
            break
        end
    end
    for j = 1, #constants.PED_PROPS_IDS do
        for m = 1, #constants.PED_COMPONENTS_IDS do
            SetPedComponentVariation(CharacterPed, constants.PED_COMPONENTS_IDS[m], 0, 0, 0)
            Wait(10)
        end
        for m = 1, #constants.PED_PROPS_IDS do
            ClearPedProp(CharacterPed, constants.PED_PROPS_IDS[m])
            Wait(10)
        end
        for l = 0, CACHE[i]['props'][j].drawables do
            SetPedPropIndex(CharacterPed, j, l, 0, true)
            DoneClothing = DoneClothing + 1
            Wait(25)
            for k = 1, CACHE[i]['props'][j].Textures[l] do
                SetPedPropIndex(CharacterPed, j, l, k, true)
                DoneClothing = DoneClothing + 1
                Wait(25)
                if not inProgress then
                    break
                end
            end
            if not inProgress then
                break
            end
        end
        if not inProgress then
            break
        end
    end
end

local function CacheGetClothe()
    for i = 1, #Config.Secure.Cache.PEDS do
        local CharacterPed = CreatePed(2, Config.Secure.Cache.PEDS[i], cachecoords, 0.0, false, true)
        Wait(100)
        for j = 1, #constants.PED_COMPONENTS_IDS do
            SetPedComponentVariation(CharacterPed, constants.PED_COMPONENTS_IDS[j], 0, 0, 0)
            Wait(10)
        end
        for j = 1, #constants.PED_PROPS_IDS do
            ClearPedProp(CharacterPed, constants.PED_PROPS_IDS[j])
            Wait(10)
        end
        Wait(100)
        FreezeEntityPosition(CharacterPed, true)
        SetEntityInvincible(CharacterPed, true)
        PlaceObjectOnGroundProperly(CharacterPed)
        SetBlockingOfNonTemporaryEvents(CharacterPed, true)
        Wait(100)
        GetValues(i, CharacterPed)
        DeleteEntity(CharacterPed)
        Wait(1000)
        if not inProgress then
            break
        end
    end
end

local function CacheCreateClothe()
    for i = 1, #Config.Secure.Cache.PEDS do
        CharacterPed2 = CreatePed(2, Config.Secure.Cache.PEDS[i], cachecoords, 0.0, false, true)
        SetEntityCompletelyDisableCollision(CharacterPed2, false, false)
        Wait(100)
        for j = 1, #constants.PED_COMPONENTS_IDS do
            SetPedComponentVariation(CharacterPed2, constants.PED_COMPONENTS_IDS[j], 0, 0, 0)
            Wait(10)
        end
        for j = 1, #constants.PED_PROPS_IDS do
            ClearPedProp(CharacterPed2, constants.PED_PROPS_IDS[j])
            Wait(10)
        end
        Wait(100)
        FreezeEntityPosition(CharacterPed2, true)
        SetEntityInvincible(CharacterPed2, true)
        PlaceObjectOnGroundProperly(CharacterPed2)
        SetBlockingOfNonTemporaryEvents(CharacterPed2, true)
        SetEntityVisible(CharacterPed2, false, 0)
        Wait(100)
        DoCacheClothes(i, CharacterPed2)
        local a = CharacterPed2
        CharacterPed2 = nil
        DeleteEntity(a)
        Wait(1000)
        if not inProgress then
            break
        end
    end
end

local function CacheCreateVeh()
    for i = 1, #VehicleCache do
        local vehicle = VehicleCache[i]
        if IsModelInCdimage(vehicle) then
            if not Config.Secure.Cache.ignoreVehicles[vehicle] then
                RequestModel(vehicle)

                while not HasModelLoaded(vehicle) do
                    print("Loading " .. vehicle.."...")
                    Wait(1000)
                    if not inProgress then
                        break
                    end
                end

                if HasModelLoaded(vehicle) then
                    print(vehicle .. " is loaded.\n")
                end
                DoneVehicle = DoneVehicle + 1
                if not inProgress then
                    break
                end
            else
                DoneVehicle = DoneVehicle + 1
            end
        else
            print(vehicle .. " hasn't been found (model name isn't the same as the folder name or mispelled in \"Config.OtherVehicles\").")
        end
    end
end

local function CacheCreateObjects()
    for i = 1, #Config.Secure.Cache.OBJECTS do
        local object = Config.Secure.Cache.OBJECTS[i]
        if not ignoreObject[object] then
            RequestModel(object)

            while not HasModelLoaded(object) do
                print("Loading " .. object.."...")
                Wait(1000)
                if not inProgress then
                    break
                end
            end

            if HasModelLoaded(object) then
                print(object .. " is loaded.\n")
            end
            DoneObjects = DoneObjects + 1
            if not inProgress then
                break
            end
        else
            DoneObjects = DoneObjects + 1
        end
    end
end

local function INITCLOTHE()
    Wait(500)
    MaxClothing = 0
    CacheGetClothe()
    Wait(2000)
    CacheCreateClothe()
end

local function INIT()
    Wait(500)
    MaxClothing = 0
    CacheGetClothe()
    Wait(2000)
    CacheCreateClothe()
    Wait(2000)
    CacheCreateVeh()
    Wait(2000)
    CacheCreateObjects()
end

local clothing = false
local vehicles = false
local objects  = false
local all = false

RegisterCommand('preclothing', function()
    if not cooldown and not vehicles and not objects and not all then
        if not inProgress then
            clothing = true
            inProgress = true
            INITCLOTHE()
        else
            cooldown = true
            clothing = false
            inProgress = false
            SetTimeout(1000, function()
                DoneVehicle = 0
                DoneClothing = 0
                cooldown = false
            end)
        end
    else
        TriggerEvent('QBCore:Notify', 'The Command is in CoolDown or Other Command is Running', 'error', 3000)
    end
end)

RegisterCommand('prevehicles', function()
    if not cooldown and not clothing and not objects and not all then
        if not inProgress then
            vehicles = true
            inProgress = true
            Wait(2000)
            CacheCreateVeh()
        else
            cooldown = true
            vehicles = false
            inProgress = false
            SetTimeout(1000, function()
                DoneVehicle = 0
                DoneClothing = 0
                cooldown = false
            end)
        end
    else
        TriggerEvent('QBCore:Notify', 'The Command is in CoolDown or Other Command is Running', 'error', 3000)
    end
end)

RegisterCommand('preobjects', function()
    if not cooldown and not clothing and not vehicles and not all then
        if not inProgress then
            objects = true
            inProgress = true
            Wait(2000)
            CacheCreateObjects()
        else
            cooldown = true
            objects = false
            inProgress = false
            SetTimeout(1000, function()
                DoneVehicle = 0
                DoneClothing = 0
                cooldown = false
            end)
        end
    else
        TriggerEvent('QBCore:Notify', 'The Command is in CoolDown or Other Command is Running', 'error', 3000)
    end
end)

RegisterCommand('precache', function()
    if not cooldown and not clothing and not vehicles and not objects then
        if not inProgress then
            all = true
            inProgress = true
            Wait(2000)
            INIT()
        else
            cooldown = true
            all = false
            inProgress = false
            SetTimeout(1000, function()
                DoneVehicle = 0
                DoneClothing = 0
                cooldown = false
            end)
        end
    else
        TriggerEvent('QBCore:Notify', 'The Command is in CoolDown or Other Command is Running', 'error', 3000)
    end
end)

CreateThread(function()
    while true do
        sleep = 1500
        if CharacterPed2 then
            sleep = 3
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            SetEntityCoords(CharacterPed2, pos)
            SetEntityHeading(CharacterPed2, heading)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    local _string = "STRING"
    while true do
        
        sleep = 1000
        if inProgress then
            sleep = 5
            SetTextScale(_scale, _scale)
            SetTextFont(_font)
            SetTextOutline()
            BeginTextCommandDisplayText(_string)
            if clothing then
                AddTextComponentSubstringPlayerName('~r~Clothings: ~b~'..DoneClothing..'~y~ / ~b~'..MaxClothing)
            elseif vehicles then
                AddTextComponentSubstringPlayerName('~r~Vehicles: ~b~'..DoneVehicle..'~y~ / ~b~'..VehicleCache)
            elseif objects then
                AddTextComponentSubstringPlayerName('~r~Objects: ~b~'..DoneObjects..'~y~ / ~b~'..Objects)
            elseif all then
                AddTextComponentSubstringPlayerName('~r~Objects: ~b~'..DoneObjects..'~y~ / ~b~'..Objects..'\n~r~Veh: ~b~'..DoneVehicle..'~y~ / ~b~'..#VehicleCache..'\n~r~Clothe: ~b~'..DoneClothing..'~y~ / ~b~'..MaxClothing)
            else 
                AddTextComponentSubstringPlayerName('Cache Error')
            end
            EndTextCommandDisplayText(posX, posY)
        end
        Wait(sleep)
    end
end)
