-----------------------
----   Variables   ----
-----------------------
local AJFW = exports['aj-base']:GetCoreObject()
local VehicleList = {}

-----------------------
----   Threads     ----
-----------------------

-----------------------
---- Server Events ----
-----------------------

-- Event to give keys. receiver can either be a single id, or a table of ids.
-- Must already have keys to the vehicle, trigger the event from the server, or pass forcegive paramter as true.
RegisterNetEvent('aj-vehiclekeys:server:GiveVehicleKeys', function(receiver, plate)
    local giver = source

    if HasKeys(giver, plate) then
        TriggerClientEvent('AJFW:Notify', giver, Lang:t("notify.vgkeys"), 'success')
        if type(receiver) == 'table' then
            for _,r in ipairs(receiver) do
                GiveKeys(receiver[r], plate)
            end
        else
            GiveKeys(receiver, plate)
        end
    else
        TriggerClientEvent('AJFW:Notify', giver, Lang:t("notify.ydhk"), "error")
    end
end)

local function UseLockpick(source, isAdvanced, item)
    local src = source
    if isAdvanced then
        local bool = exports['aj-inventory']:CheckDecay(item, 10)
        if bool then
            TriggerClientEvent('custom:lockpicks:UseLockpick',src, isAdvanced, item)
        else
            TriggerClientEvent('AJFW:Notify', src, 'Item Broken or not useable', 'error', 3000)
        end
    else
        local bool = exports['aj-inventory']:CheckDecay(item, 25)
        if bool then
            TriggerClientEvent('custom:lockpicks:UseLockpick',src, isAdvanced, item)
        else
            TriggerClientEvent('AJFW:Notify', src, 'Item Broken or not useable', 'error', 3000)
        end
    end
end exports('UseLockpick', UseLockpick)

RegisterNetEvent('aj-vehiclekeys:server:AcquireVehicleKeys', function(plate)
    local src = source
    GiveKeys(src, plate)
end)

RegisterNetEvent('aj-vehiclekeys:server:breakLockpick', function(itemName, itemData)
    local src = source
    if itemName == 'advancedlockpick' then
        exports['aj-inventory']:PerformDecay(src, itemData, 10, true)
    elseif itemName == 'lockpick' then
        exports['aj-inventory']:PerformDecay(src, itemData, 25, true)
    end
end)

RegisterNetEvent('aj-vehiclekeys:server:setVehLockState', function(vehNetId, state)
    SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(vehNetId), state)
end)

AJFW.Functions.CreateCallback('aj-vehiclekeys:server:GetVehicleKeys', function(source, cb)
    local Player = AJFW.Functions.GetPlayer(source)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local keysList = {}
    for plate, citizenids in pairs (VehicleList) do
        if citizenids[citizenid] then
            keysList[plate] = true
        end
    end
    cb(keysList)
end)

AJFW.Functions.CreateCallback('aj-vehiclekeys:server:checkPlayerOwned', function(_, cb, plate)
    local playerOwned = false
    if VehicleList[plate] then
        playerOwned = true
    end
    cb(playerOwned)
end)

-----------------------
----   Functions   ----
-----------------------

function GiveKeys(id, plate)
    local Player = AJFW.Functions.GetPlayer(id)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    if not plate then
        if GetVehiclePedIsIn(GetPlayerPed(id), false) ~= 0 then
            plate = AJFW.Shared.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(id), false)))
        else
            return
        end
    end
    if not VehicleList[plate] then VehicleList[plate] = {} end
    VehicleList[plate][citizenid] = true
    TriggerClientEvent('AJFW:Notify', id, Lang:t("notify.vgetkeys"))
    TriggerClientEvent('aj-vehiclekeys:client:AddKeys', id, plate)
end
exports('GiveKeys', GiveKeys)

function RemoveKeys(id, plate)
    local citizenid = AJFW.Functions.GetPlayer(id).PlayerData.citizenid

    if VehicleList[plate] and VehicleList[plate][citizenid] then
        VehicleList[plate][citizenid] = nil
    end

    TriggerClientEvent('aj-vehiclekeys:client:RemoveKeys', id, plate)
end
exports('RemoveKeys', RemoveKeys)

function RemoveKeysForcefully(plate)
    if VehicleList[plate] then
        VehicleList[plate] = nil
    end
end exports('RemoveKeysForcefully', RemoveKeysForcefully)

function HasKeys(id, plate)
    local citizenid = AJFW.Functions.GetPlayer(id).PlayerData.citizenid
    if VehicleList[plate] and VehicleList[plate][citizenid] then
        return true
    end
    return false
end
exports('HasKeys', HasKeys)

AJFW.Commands.Add("givekeys", Lang:t("addcom.givekeys"), {{name = Lang:t("addcom.givekeys_id"), help = Lang:t("addcom.givekeys_id_help")}}, false, function(source, args)
	local src = source
    TriggerClientEvent('aj-vehiclekeys:client:GiveKeys', src, tonumber(args[1]))
end)

AJFW.Commands.Add("addkeys", Lang:t("addcom.addkeys"), {{name = Lang:t("addcom.addkeys_id"), help = Lang:t("addcom.addkeys_id_help")}, {name = Lang:t("addcom.addkeys_plate"), help = Lang:t("addcom.addkeys_plate_help")}}, true, function(source, args)
	local src = source
    if not args[1] or not args[2] then
        TriggerClientEvent('AJFW:Notify', src, Lang:t("notify.fpid"))
        return
    end
    GiveKeys(tonumber(args[1]), args[2])
end, 'admin')

AJFW.Commands.Add("removekeys", Lang:t("addcom.rkeys"), {{name = Lang:t("addcom.rkeys_id"), help = Lang:t("addcom.rkeys_id_help")}, {name = Lang:t("addcom.rkeys_plate"), help = Lang:t("addcom.rkeys_plate_help")}}, true, function(source, args)
	local src = source
    if not args[1] or not args[2] then
        TriggerClientEvent('AJFW:Notify', src, Lang:t("notify.fpid"))
        return
    end
    RemoveKeys(tonumber(args[1]), args[2])
end, 'admin')
