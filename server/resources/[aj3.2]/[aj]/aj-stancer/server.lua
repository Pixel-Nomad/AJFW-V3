local AJFW = exports['aj-base']:GetCoreObject()
local stancer = {}


AJFW.Commands.Add('stancerset', 'Open Stancer Set', {}, false, function(source, args)
    local veh = GetVehiclePedIsIn(GetPlayerPed(source),false)
    if veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        if stancer[plate] then
            TriggerClientEvent("aj-stancer:openstancer", source, true)
        end
    end
end, 'harmony')

local function RemoveStancer(plate)
    local plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')
    MySQL.query.await('DELETE FROM stancers WHERE TRIM(plate) = ?',{plate})
end

AJFW.Commands.Add('stancerremove', 'Remove Stancer From Vehicle', {}, false, function(source, args)
    local veh = GetVehiclePedIsIn(GetPlayerPed(source), false)
    if veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        if stancer[plate] then
            stancer[plate] = nil
            RemoveStancer(plate)
        end
    end
end, 'harmony')

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function SaveStancer(ob)
    local plate = string.gsub(ob.plate, '^%s*(.-)%s*$', '%1')
    local result = MySQL.query.await('SELECT * FROM stancers WHERE TRIM(plate) = ?', {plate})
    if result[1] == nil then
        MySQL.insert.await('INSERT INTO stancers (plate, setting) VALUES (?, ?)', {ob.plate, '[]'})
    elseif result[1] then
        MySQL.query.await('UPDATE stancers SET setting = ? WHERE TRIM(plate) = ?',{json.encode(ob.setting),plate})
    end
end

local function AddStancerKit(veh)
    local veh = veh
    local plate = GetVehicleNumberPlateText(veh)
    if not stancer[plate] then
        stancer[plate] = {}
        local ent = Entity(veh).state
        if not ent.stancer then
            stancer[plate].stancer = {}
            stancer[plate].plate = plate
            stancer[plate].online = true
            ent.stancer = stancer[plate]
            SaveStancer({plate = plate, setting = {}})
        end
    end
end

RegisterNetEvent("aj-stancer:airsuspension", function(entity, val, coords)
	TriggerClientEvent("aj-stancer:airsuspension", -1, entity, val,coords)
end)

AddEventHandler('entityCreated', function(entity)
    local entity = entity
    Wait(4000)
    if DoesEntityExist(entity) and GetEntityPopulationType(entity) == 7 and GetEntityType(entity) == 2 then
        local plate = GetVehicleNumberPlateText(entity)
        if stancer[plate] and stancer[plate].stancer then
            local ent = Entity(entity).state
            ent.stancer = stancer[plate].stancer
            stancer[plate].online = true
        end
    end
end)
  
AddEventHandler('entityRemoved', function(entity)
    local entity = entity
    if DoesEntityExist(entity) and GetEntityPopulationType(entity) == 7 and GetEntityType(entity) == 2 then
        local ent = Entity(entity).state
        if ent.stancer then
            local plate = GetVehicleNumberPlateText(entity)
            stancer[plate].online = false
            stancer[plate].stancer = ent.stancer
            SaveStancer({plate = plate, setting = stancer[plate].stancer})
        end
    end
end)

CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM stancers', {})
    for _,v in pairs(result) do
        if stancer[v.plate] == nil then 
            stancer[v.plate] = {} 
        end
        stancer[v.plate].plate = v.plate
        stancer[v.plate].stancer = json.decode(v.setting)
        stancer[v.plate].online = false
    end
    for _,vehicle in pairs(GetAllVehicles()) do
        local plate = GetVehicleNumberPlateText(vehicle)
        if stancer[plate] and plate == stancer[plate].plate then
            if stancer[plate].stancer then
                local ent = Entity(vehicle).state
                ent.stancer = stancer[plate].stancer
                ent.online = true
            end
        end
    end
    for _,v in pairs(Config.items) do
        local stanceritem = string.lower(v)
        -- print(stanceritem)
        AJFW.Functions.CreateUseableItem(stanceritem, function(source, item)
            -- print(1)
            local Player = AJFW.Functions.GetPlayer(source)
            local veh = GetVehiclePedIsIn(GetPlayerPed(source),false)
            if veh ~= 0 then
                if Player.Functions.RemoveItem(item.name, 1, item.slot) then
                    AddStancerKit(veh)
                end
            end
        end)
    end
end)