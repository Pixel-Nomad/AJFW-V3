local fileName = "Base/Cache"

local inProgress = false
local cooldown = false
local scriptReady = false

local MaxClothing = 0
local DoneVehicle = 0
local DoneClothing = 0
local VehicleCache = {}

for k in pairs(AJFW.Shared.Vehicles) do
    VehicleCache[#VehicleCache+1] = k
end

local posX = 0.05
local posY = 0.6
local _scale = 0.34
local _font = 4

local clothingCategorys = {
    ["arms"]        = {type = "variation",  id = 3},
    ["t-shirt"]     = {type = "variation",  id = 8},
    ["torso2"]      = {type = "variation",  id = 11},
    ["pants"]       = {type = "variation",  id = 4},
    ["vest"]        = {type = "variation",  id = 9},
    ["shoes"]       = {type = "variation",  id = 6},
    ["bag"]         = {type = "variation",  id = 5},
    ["hair"]        = {type = "hair",       id = 2},
    ["mask"]        = {type = "mask",       id = 1},
    ["hat"]         = {type = "prop",       id = 0},
    ["glass"]       = {type = "prop",       id = 1},
    ["ear"]         = {type = "prop",       id = 2},
    ["watch"]       = {type = "prop",       id = 6},
    ["bracelet"]    = {type = "prop",       id = 7},
    ["accessory"]   = {type = "variation",  id = 7},
    ["decals"]      = {type = "variation",  id = 10},
}

local maxModelValues = {
    ["arms"]        = {type = "character", item = 0, texture = 0},
    ["t-shirt"]     = {type = "character", item = 0, texture = 0},
    ["torso2"]      = {type = "character", item = 0, texture = 0},
    ["pants"]       = {type = "character", item = 0, texture = 0},
    ["shoes"]       = {type = "character", item = 0, texture = 0},
    ["vest"]        = {type = "character", item = 0, texture = 0},
    ["accessory"]   = {type = "character", item = 0, texture = 0},
    ["decals"]      = {type = "character", item = 0, texture = 0},
    ["bag"]         = {type = "character", item = 0, texture = 0},
    ["hair"]        = {type = "hair", item = 0, texture = 0},
    ["mask"]        = {type = "accessoires", item = 0, texture = 0},
    ["hat"]         = {type = "accessoires", item = 0, texture = 0},
    ["glass"]       = {type = "accessoires", item = 0, texture = 0},
    ["ear"]         = {type = "accessoires", item = 0, texture = 0},
    ["watch"]       = {type = "accessoires", item = 0, texture = 0},
    ["bracelet"]    = {type = "accessoires", item = 0, texture = 0},
}

local clothingCategorys2 = {
    ["arms"]        = {type = "variation",  id = 3},
    ["t-shirt"]     = {type = "variation",  id = 8},
    ["torso2"]      = {type = "variation",  id = 11},
    ["pants"]       = {type = "variation",  id = 4},
    ["vest"]        = {type = "variation",  id = 9},
    ["shoes"]       = {type = "variation",  id = 6},
    ["bag"]         = {type = "variation",  id = 5},
    ["hair"]        = {type = "hair",       id = 2},
    ["mask"]        = {type = "mask",       id = 1},
    ["hat"]         = {type = "prop",       id = 0},
    ["glass"]       = {type = "prop",       id = 1},
    ["ear"]         = {type = "prop",       id = 2},
    ["watch"]       = {type = "prop",       id = 6},
    ["bracelet"]    = {type = "prop",       id = 7},
    ["accessory"]   = {type = "variation",  id = 7},
    ["decals"]      = {type = "variation",  id = 10},
}

local maxModelValues2 = {
    ["arms"]        = {type = "character", item = 0, texture = 0},
    ["t-shirt"]     = {type = "character", item = 0, texture = 0},
    ["torso2"]      = {type = "character", item = 0, texture = 0},
    ["pants"]       = {type = "character", item = 0, texture = 0},
    ["shoes"]       = {type = "character", item = 0, texture = 0},
    ["vest"]        = {type = "character", item = 0, texture = 0},
    ["accessory"]   = {type = "character", item = 0, texture = 0},
    ["decals"]      = {type = "character", item = 0, texture = 0},
    ["bag"]         = {type = "character", item = 0, texture = 0},
    ["hair"]        = {type = "hair", item = 0, texture = 0},
    ["mask"]        = {type = "accessoires", item = 0, texture = 0},
    ["hat"]         = {type = "accessoires", item = 0, texture = 0},
    ["glass"]       = {type = "accessoires", item = 0, texture = 0},
    ["ear"]         = {type = "accessoires", item = 0, texture = 0},
    ["watch"]       = {type = "accessoires", item = 0, texture = 0},
    ["bracelet"]    = {type = "accessoires", item = 0, texture = 0},
}

local function GatMaxValues()
    local CharacterPed = CreatePed(2,1885233650,-1038.94,-3573.43,1.34,0.0, false, true)
    local ped = CharacterPed

    for i = 0, 11 do
        SetPedComponentVariation(ped, i, 0, 0, 0)
    end
    for i = 0, 7 do
        ClearPedProp(ped, i)
    end

    FreezeEntityPosition(CharacterPed, false)
    SetEntityInvincible(CharacterPed, true)
    PlaceObjectOnGroundProperly(CharacterPed)
    SetBlockingOfNonTemporaryEvents(CharacterPed, true)

    for k,v in pairs(clothingCategorys) do

        local TextureData = {}

        if v.type == "variation" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = GetNumberOfPedTextureVariations(ped, componentId, i)
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues[k].texture = TextureData
        end

        if v.type == "hair" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = 45
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues[k].texture = TextureData
        end

        if v.type == "mask" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = GetNumberOfPedTextureVariations(ped, componentId, i)
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues[k].texture = TextureData
        end

        if v.type == "prop" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = GetNumberOfPedTextureVariations(ped, componentId, i)
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues[k].texture = TextureData
        end

    end

    local CharacterPed2 = CreatePed(2,-1667301416,-1038.94,-3573.43,1.34,0.0, false, true)
    ped = CharacterPed2

    for i = 0, 11 do
        SetPedComponentVariation(ped, i, 0, 0, 0)
    end

    for i = 0, 7 do
        ClearPedProp(ped, i)
    end

    FreezeEntityPosition(CharacterPed2, false)
    SetEntityInvincible(CharacterPed2, true)
    PlaceObjectOnGroundProperly(CharacterPed2)
    SetBlockingOfNonTemporaryEvents(CharacterPed2, true)

    for k,v in pairs(clothingCategorys2) do

        local TextureData = {}

        if v.type == "variation" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues2[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = GetNumberOfPedTextureVariations(ped, componentId, i)
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues2[k].texture = TextureData
        end
    
        if v.type == "hair" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues2[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = 45
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues2[k].texture = TextureData
        end
    
        if v.type == "mask" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues2[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = GetNumberOfPedTextureVariations(ped, componentId, i)
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues2[k].texture = TextureData
        end

        if v.type == "prop" then
            local Total = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues2[k].item = Total
            MaxClothing = MaxClothing + Total
            for i=0, Total do
                local Total2 = GetNumberOfPedTextureVariations(ped, componentId, i)
                TextureData[i] = Total2
                MaxClothing = MaxClothing + Total2
            end
            maxModelValues2[k].texture = TextureData
        end

    end

    DeleteEntity(CharacterPed)
    DeleteEntity(CharacterPed2)

    Wait(5000)

    -- MaxClothing = 25979
    return MaxClothing
end

local function StartCache()

    print('Getting Everything')

    GatMaxValues()

    local CharacterPed = CreatePed(2,1885233650,-1038.94,-3573.43,1.34,0.0, false, true)

    for i = 0, 11 do
        SetPedComponentVariation(CharacterPed, i, 0, 0, 0)
    end
    for i = 0, 7 do
        ClearPedProp(CharacterPed, i)
    end

    FreezeEntityPosition(CharacterPed, false)
    SetEntityInvincible(CharacterPed, true)
    PlaceObjectOnGroundProperly(CharacterPed)
    SetBlockingOfNonTemporaryEvents(CharacterPed, true)

    for k,v in pairs(maxModelValues) do
        if k == 'arms' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 3, i, 0, 2)
                DoneClothing = DoneClothing + 1
                Wait(25)
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 3, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 't-shirt' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 8, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 8, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'torso2' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 11, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 11, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'pants' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 4, i, 0, 0)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 4, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'shoes' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 6, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 6, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'vest' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 9, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 9, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'accessory' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 7, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 7, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'decals' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 10, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 10, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'bag' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 5, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 5, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'hair' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 2, i, 0, 0)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 2, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'mask' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed, 2, i, 0, 0)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed, 2, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'hat' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed, 0, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed, 0, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'glass' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed, 1, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed, 1, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'ear' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed, 2, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed, 2, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'watch' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed, 6, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed, 6, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        elseif k == 'bracelet' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed, 7, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed, 7, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProgress then
                        break
                    end
                end
                if not inProgress then
                    break
                end
            end
        end
        if not inProgress then
            break
        end
    end

    local CharacterPed2 = CreatePed(2,-1667301416,-1038.94,-3573.43,1.34,0.0, false, true)

    for i = 0, 11 do
        SetPedComponentVariation(CharacterPed2, i, 0, 0, 0)

    end
    for i = 0, 7 do
        ClearPedProp(CharacterPed2, i)
    end

    FreezeEntityPosition(CharacterPed2, false)
    SetEntityInvincible(CharacterPed2, true)
    PlaceObjectOnGroundProperly(CharacterPed2)
    SetBlockingOfNonTemporaryEvents(CharacterPed2, true)

    for k,v in pairs(maxModelValues2) do
        if k == 'arms' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 3, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 3, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 't-shirt' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 8, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 8, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'torso2' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 11, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 11, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'pants' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 4, i, 0, 0)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 4, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'shoes' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 6, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 6, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'vest' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 9, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 9, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'accessory' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 7, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 7, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'decals' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 10, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 10, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'bag' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 5, i, 0, 2)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 5, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'hair' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 2, i, 0, 0)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 2, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'mask' then
            for i = 0, v.item do
                SetPedComponentVariation(CharacterPed2, 2, i, 0, 0)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedComponentVariation(CharacterPed2, 2, i, j, 0)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'hat' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed2, 0, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed2, 0, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'glass' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed2, 1, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed2, 1, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'ear' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed2, 2, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed2, 2, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'watch' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed2, 6, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed2, 6, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        elseif k == 'bracelet' then
            for i = 0, v.item do
                SetPedPropIndex(CharacterPed2, 7, i, 0, true)
                Wait(25)
                DoneClothing = DoneClothing + 1
                for j = 0, v.texture[i] do
                    SetPedPropIndex(CharacterPed2, 7, i, j, true)
                    Wait(25)
                    DoneClothing = DoneClothing + 1
                    if not inProggress then
                        break
                    end
                end
                if not inProggress then
                    break
                end
            end
        end
        if not inProggress then
            break
        end
    end

    for i = 1, #VehicleCache do
        local vehicle = VehicleCache[i]
        if IsModelInCdimage(vehicle) then
            RequestModel(vehicle)

            repeat
                print("Loading " .. vehicle.."...")
                Citizen.Wait(500)
            until HasModelLoaded(vehicle)

            if HasModelLoaded(vehicle) then
                print(vehicle .. " is loaded.\n")
            else
                print(vehicle .. " failed to load.\n")
            end

            local veh = CreateVehicle(vehicle, -1038.94,-3573.43,1.34, false, false)

            while not DoesEntityExist(veh) do
                Wait(50)
            end

            SetModelAsNoLongerNeeded(vehicle)
            SetVehicleOnGroundProperly(veh)
            SetEntityInvincible(veh,true)
            SetEntityHeading(veh, 65.74)
            SetVehicleDoorsLocked(veh, 3)
            FreezeEntityPosition(veh, true)
            Wait(25)
            DeleteVehicle(veh)
            DoneVehicle = DoneVehicle + 1
        else
            print(vehicle .. " hasn't been found (model name isn't the same as the folder name or mispelled in \"Config.OtherVehicles\").")
        end
        if not inProggress then
            break
        end
    end

    inProgress = false

    DeleteEntity(CharacterPed)
    DeleteEntity(CharacterPed2)
end

RegisterCommand('precache', function()
    if not cooldown then
        if not inProgress then
            inProgress = true
            StartCache()
        else
            cooldown = true
            inProgress = false
            SetTimeout(60000, function()
                DoneVehicle = 0
                DoneClothing = 0
                cooldown = false
            end)
        end
        print('Command in cooldown')
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
            AddTextComponentSubstringPlayerName('Vehicle: '..DoneVehicle..'/'..#VehicleCache..'\nClothing: '..DoneClothing..'/'..MaxClothing)
            EndTextCommandDisplayText(posX, posY)
            -- print('Vehicle: '..DoneVehicle..'/'..#VehicleCache..'\nClothing: '..DoneClothing..'/'..MaxClothing)
        end
        Wait(sleep)
    end
end)