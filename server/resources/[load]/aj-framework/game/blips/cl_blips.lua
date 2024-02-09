local Blips = {}

local Table = {
    ID          = 'unique',
    Type        = 'Area || Coords || Entity || Radius',
    Coords      = 'Table || Vector3 ||',    -- not required for entity
    Width       = 50,                       -- 'Required if using Area'
    Height      = 50,                       -- 'Required if using Area'
    Radius      = 50,                       -- 'Required if using Radius'
    Entity      = nil,                      -- 'Required if using Entity'
    Sprite      = nil,                      -- 'SetBlipIcon'
    Display     = nil,                      -- see https://docs.fivem.net/natives/?_0x9029B2F3DA924928
    Scale       = nil,                      -- Size of blip
    Color       = nil,                      -- Change Color of Blip
    ShortRange  = nil,                      -- if true show blip on minimap from short range
    Title       = nil,                      -- Label of a blip
    Alpha       = nil,                      -- Adjust Visibility of Blip
    Category    = nil,                      -- Merge All Blips Together Name will get from sprite
    Rotation    = nil,                      -- Adjust the rotaion of blip
    Cone        = nil,                      -- Add Cone in Blip
    ShowNumber  = nil                       -- Show Number on map
}

local Table2 = {
    ID          = 'unique',
    Type        = 'Area || Coords || Entity || Radius',
    Coords      = 'Table || Vector3 ||',
    Width       = 50,
    Height      = 50,
    Radius      = 50,
    Entity      = nil,
    Sprite      = nil,
    Display     = nil,
    Scale       = nil,
    Color       = nil,
    ShortRange  = nil,
    Title       = nil,
    Alpha       = nil,
    Category    = nil,
    Rotation    = nil,
    Cone        = nil,
    ShowNumber  = nil 
}

local function CreateBlip(Data)
    if Data.Type ~= 'Area' and Data.Type ~= 'Coords' and Data.Type ~= 'Entity' and Data.Type ~= 'Radius' then print('INCORRECT BLIP TYPE') return nil end
    local UniqueID = 0
    if Data.ID then
        if not Blips[Data.ID] then
            UniqueID = Data.ID
            Blips[UniqueID] = {}
        else
            print('Got Duplicate BLIP ID CREATING IT WITH RANDOM ID (ID: '..Data.ID..' )')
            UniqueID = #Blips+1
            Blips[UniqueID] = {}
        end
    else
        UniqueID = #Blips+1
        Blips[UniqueID] = {}
    end
    if Data.Type == 'Area' then
        if Data.Coords and ( type( Data.Coords ) ~= 'table' and type( Data.Coords ) ~= 'vector3' ) then
            Data.Coords = type( Data.Coords ) == 'table' and vec3( Data.Coords.x, Data.Coords.y, Data.Coords.z ) or Data.Coords
            Blips[UniqueID] = AddBlipForArea( Data.Coords, Data.Width or 50, Data.Height or 50 )
        else
            print('SKIPPING 1 BLIP CAUSE COORDS NOT FOUND METHOD WILL BE (AREA)')
            return nil
        end
    elseif Data.Type == 'Coords' then
        print(Data.Coords.x)
        if Data.Coords and ( type( Data.Coords ) ~= 'table' or type( Data.Coords ) ~= 'vector3' ) then
            Data.Coords = type( Data.Coords ) == 'table' and vec3( Data.Coords.x, Data.Coords.y, Data.Coords.z ) or Data.Coords
            Blips[UniqueID] = AddBlipForCoord( Data.Coords )
        else
            print('SKIPPING 1 BLIP CAUSE COORDS NOT FOUND METHOD WILL BE (COORDS)')
            return nil
        end
    elseif Data.Type == 'Entity' then
        if Data.Entity then
            Blips[UniqueID] = AddBlipForEntity( Data.Entity )
        else
            print('SKIPPING 1 BLIP CAUSE ENTITY NOT FOUND METHOD WILL BE (ENTITY)')
            return nil
        end
    elseif Data.Type == 'Radius' then
        if Data.Coords and ( type( Data.Coords ) ~= 'table' and type( Data.Coords ) ~= 'vector3' ) then
            Data.Coords = type( Data.Coords ) == 'table' and vec3( Data.Coords.x, Data.Coords.y, Data.Coords.z ) or Data.Coords
            Blips[UniqueID] = AddBlipForArea( Data.Coords, Data.Radius or 50 )
        else
            print('SKIPPING 1 BLIP CAUSE COORDS NOT FOUND METHOD WILL BE (RADIUS)')
            return nil
        end
    end
    if Data.Sprite then 
        SetBlipSprite(Blips[UniqueID], Data.Sprite) 
    end
    if Data.Display then 
        SetBlipDisplay(Blips[UniqueID], Data.Display) 
    end
    if Data.Scale then 
        SetBlipScale(Blips[UniqueID], Data.Scale) 
    end
    if Data.Color then 
        SetBlipColour(Blips[UniqueID], Data.Color) 
    end
    if Data.ShortRange ~= nil then 
        SetBlipAsShortRange(Blips[UniqueID], Data.ShortRange) 
    end
    if Data.Title then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Data.Title)
        EndTextCommandSetBlipName(Blips[UniqueID])
    end
    if Data.Alpha then 
        SetBlipAlpha(Blips[UniqueID], Data.Alpha) 
    end
    if Data.Category then 
        SetBlipCategory(Blips[UniqueID], Data.Category) -- categories can be found here: https://docs.fivem.net/natives/?_0x234CDD44D996FD9A
    end 
    if Data.Rotation then 
        SetBlipRotation(Blips[UniqueID], Data.Rotation) 
    end
    if Data.Cone ~= nil then 
        SetBlipShowCone(Blips[UniqueID], Data.Cone) 
    end
    if Data.ShowNumber then 
        ShowNumberOnBlip(Blips[UniqueID], Data.ShowNumber) 
    end
    return { Blip = Blips[UniqueID], ID = UniqueID }
end

exports('CreateBlip',CreateBlip)

local function GetBlip(id)
    if Blips[id] then
        return Blips[id]
    else
        return nil
    end
end

exports('GetBlip',GetBlip)

local function Removeblip(id)
    if Blips[id] then
        RemoveBlip(Blips[id])
        Blips[id] = nil
    end
end

exports('RemoveBlip', Removeblip)
