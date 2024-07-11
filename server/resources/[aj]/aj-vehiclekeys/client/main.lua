-----------------------
----   Variables   ----
-----------------------
 AJFW = exports['aj-base']:GetCoreObject()
local KeysList = {}
local isTakingKeys = false
local isCarjacking = false
local canCarjack = true
local AlertSend = false
local lastPickedVehicle = nil
local usingAdvanced = false
local IsHotwiring = false
local trunkclose = true
local looped = false
local itemData = nil

local function robKeyLoop()
    if looped == false then
        looped = true
        while true do
            local sleep = 1000
            if LocalPlayer.state.isLoggedIn then
                sleep = 100

                local ped = PlayerPedId()
                local entering = GetVehiclePedIsTryingToEnter(ped)
                local carIsImmune = false
                if entering ~= 0 and not isBlacklistedVehicle(entering) then
                    sleep = 2000
                    local plate = AJFW.Functions.GetPlate(entering)

                    local driver = GetPedInVehicleSeat(entering, -1)
                    for _, veh in ipairs(Config.ImmuneVehicles) do
                        if GetEntityModel(entering) == joaat(veh) then
                            carIsImmune = true
                        end
                    end
                    -- Driven vehicle logic
                    if driver ~= 0 and not IsPedAPlayer(driver) and not HasKeys(plate) and not carIsImmune then
                        if IsEntityDead(driver) then
                            if not isTakingKeys then
                                isTakingKeys = true

                                TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(entering), 1)
                                AJFW.Functions.Progressbar("steal_keys", Lang:t("progress.takekeys"), 2500, false, false, {
                                    disableMovement = false,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true
                                }, {}, {}, {}, function() -- Done
                                    TriggerServerEvent('aj-vehiclekeys:server:AcquireVehicleKeys', plate)
                                    isTakingKeys = false
                                end, function()
                                    isTakingKeys = false
                                end)
                            end
                        elseif Config.LockNPCDrivingCars then
                            TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(entering), 2)
                        else
                            TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(entering), 1)

                            --Make passengers flee
                            local pedsInVehicle = GetPedsInVehicle(entering)
                            for _, pedInVehicle in pairs(pedsInVehicle) do
                                if pedInVehicle ~= GetPedInVehicleSeat(entering, -1) then
                                    MakePedFlee(pedInVehicle)
                                end
                            end
                        end
                    -- Parked car logic
                    elseif driver == 0 and entering ~= lastPickedVehicle and not HasKeys(plate) and not isTakingKeys then
                        AJFW.Functions.TriggerCallback('aj-vehiclekeys:server:checkPlayerOwned', function(playerOwned)
                            if not playerOwned then
                                if Config.LockNPCParkedCars then
                                    TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(entering), 2)
                                else
                                    TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(entering), 1)
                                end
                            end
                        end, plate)

                    end
                end

                -- Hotwiring while in vehicle, also keeps engine off for vehicles you don't own keys to
                if IsPedInAnyVehicle(ped, false) then
                    sleep = 1000
                    local vehicle = GetVehiclePedIsIn(ped)
                    local plate = AJFW.Functions.GetPlate(vehicle)

                    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and not HasKeys(plate) and not isBlacklistedVehicle(vehicle) and not AreKeysJobShared(vehicle) then
                        sleep = 0
                        SetVehicleEngineOn(vehicle, false, false, true)

                    end
                end

                if Config.CarJackEnable and canCarjack then
                    local playerid = PlayerId()
                    local aiming, target = GetEntityPlayerIsFreeAimingAt(playerid)
                    if aiming and (target ~= nil and target ~= 0) then
                        if DoesEntityExist(target) and IsPedInAnyVehicle(target, false) and not IsEntityDead(target) and not IsPedAPlayer(target) then
                            local targetveh = GetVehiclePedIsIn(target)
                            for _, veh in ipairs(Config.ImmuneVehicles) do
                                if GetEntityModel(targetveh) == joaat(veh) then
                                    carIsImmune = true
                                end
                            end
                            if GetPedInVehicleSeat(targetveh, -1) == target and not IsBlacklistedWeapon() then
                                local pos = GetEntityCoords(ped, true)
                                local targetpos = GetEntityCoords(target, true)
                                if #(pos - targetpos) < 5.0 and not carIsImmune then
                                    CarjackVehicle(target)
                                end
                            end
                        end
                    end
                end
                if entering == 0 and not IsPedInAnyVehicle(ped, false) and GetSelectedPedWeapon(ped) == `WEAPON_UNARMED` then
                    looped = false
                    break
                end
            end
            Wait(sleep)
        end
    end
end

function isBlacklistedVehicle(vehicle)
    local isBlacklisted = false
    for _,v in ipairs(Config.NoLockVehicles) do
        if joaat(v) == GetEntityModel(vehicle) then
            isBlacklisted = true
            break;
        end
    end
    if Entity(vehicle).state.ignoreLocks or GetVehicleClass(vehicle) == 13 then isBlacklisted = true end
    return isBlacklisted
end

function addNoLockVehicles(model)
    Config.NoLockVehicles[#Config.NoLockVehicles+1] = model
end
exports('addNoLockVehicles', addNoLockVehicles)

function removeNoLockVehicles(model)
    for k,v in pairs(Config.NoLockVehicles) do
        if v == model then
            Config.NoLockVehicles[k] = nil
        end
    end
end
exports('removeNoLockVehicles', removeNoLockVehicles)



-----------------------
---- Client Events ----
-----------------------
RegisterKeyMapping('togglelocks', Lang:t("info.tlock"), 'keyboard', 'L')
RegisterCommand('togglelocks', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        ToggleVehicleLockswithoutnui(GetVehicle())
    else
        if Config.UseKeyfob then
            openmenu()
        else
            ToggleVehicleLockswithoutnui(GetVehicle())
        end
    end
end)

RegisterKeyMapping('engine', Lang:t("info.engine"), 'keyboard', 'G')
RegisterCommand('engine', function()
    local vehicle = GetVehicle()
    if vehicle and IsPedInVehicle(PlayerPedId(), vehicle) then
        ToggleEngine(vehicle)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() and AJFW.Functions.GetPlayerData() ~= {} then
        GetKeys()
    end
end)

-- Handles state right when the player selects their character and location.
RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    GetKeys()
end)

-- Resets state on logout, in case of character change.
RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    KeysList = {}
end)

RegisterNetEvent('aj-vehiclekeys:client:AddKeys', function(plate)
    KeysList[plate] = true
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped)
        local vehicleplate = AJFW.Functions.GetPlate(vehicle)
        if plate == vehicleplate then
            SetVehicleEngineOn(vehicle, false, false, false)
        end
    end
end)

RegisterNetEvent('aj-vehiclekeys:client:RemoveKeys', function(plate)
    KeysList[plate] = nil
end)

RegisterNetEvent('aj-vehiclekeys:client:ToggleEngine', function()
    local EngineOn = GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId()))
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if HasKeys(AJFW.Functions.GetPlate(vehicle)) then
        if EngineOn then
            SetVehicleEngineOn(vehicle, false, false, true)
        else
            SetVehicleEngineOn(vehicle, true, false, true)
        end
    end
end)

RegisterNetEvent('aj-vehiclekeys:client:GiveKeys', function(id)
    local targetVehicle = GetVehicle()
    if targetVehicle then
        local targetPlate = AJFW.Functions.GetPlate(targetVehicle)
        if HasKeys(targetPlate) then
            if id and type(id) == "number" then -- Give keys to specific ID
                GiveKeys(id, targetPlate)
            else
                if IsPedSittingInVehicle(PlayerPedId(), targetVehicle) then -- Give keys to everyone in vehicle
                    local otherOccupants = GetOtherPlayersInVehicle(targetVehicle)
                    for p=1,#otherOccupants do
                        TriggerServerEvent('aj-vehiclekeys:server:GiveVehicleKeys', GetPlayerServerId(NetworkGetPlayerIndexFromPed(otherOccupants[p])), targetPlate)
                    end
                else -- Give keys to closest player
                    GiveKeys(GetPlayerServerId(AJFW.Functions.GetClosestPlayer()), targetPlate)
                end
            end
        else
            AJFW.Functions.Notify(Lang:t("notify.ydhk"), 'error')
        end
    end
end)


RegisterNetEvent('AJFW:Client:EnteredVehicle', function()
    robKeyLoop()
end)

RegisterNetEvent('AJFW:Client:EnteringVehicle', function()
    robKeyLoop()
end)

RegisterNetEvent('weapons:client:DrawWeapon', function()
    Wait(2000)
    robKeyLoop()
end)


RegisterNetEvent('custom:lockpicks:UseLockpick', function(isAdvanced, item)
    itemData = item
    LocalPlayer.state:set("inv_busy", true, true)
    LockpickDoor(isAdvanced)
end)
-- Backwards Compatibility ONLY -- Remove at some point --
RegisterNetEvent('vehiclekeys:client:SetOwner', function(plate)
    TriggerServerEvent('aj-vehiclekeys:server:AcquireVehicleKeys', plate)
end)
-- Backwards Compatibility ONLY -- Remove at some point --

-----------------------
----   Functions   ----
-----------------------
function openmenu()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "key", 0.3)
    SendNUIMessage({ casemenue = 'open' })
    SetNuiFocus(true, true)
end
local NotifyCooldown = false
function ToggleEngine(veh)
    if veh then
        local EngineOn = GetIsVehicleEngineRunning(veh)
        if not isBlacklistedVehicle(veh) then
            if HasKeys(AJFW.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                if EngineOn then
                    SetVehicleEngineOn(veh, false, false, true)
                else
                    if exports['aj-fuel']:GetFuel(veh) ~= 0 then
                        SetVehicleEngineOn(veh, true, false, true)
                    else
                        if not NotifyCooldown then
                            RequestAmbientAudioBank("DLC_PILOT_ENGINE_FAILURE_SOUNDS", 0)
                            PlaySoundFromEntity(l_2613, "Landing_Tone", PlayerPedId(), "DLC_PILOT_ENGINE_FAILURE_SOUNDS", 0, 0)
                            NotifyCooldown = true
                            AJFW.Functions.Notify('No fuel..', 'error')
                            Wait(1500)
                            StopSound(l_2613)
                            Wait(3500)
                            NotifyCooldown = false
                        end
                    end                
                end
            end
        end
    end
end

function ToggleVehicleLockswithoutnui(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(AJFW.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local vehLockStatus, curVeh = GetVehicleDoorLockStatus(veh), GetVehiclePedIsIn(ped, false)
                local object = 0

                if curVeh == 0 then
                    if Config.LockToggleAnimation.Prop then
                        object = CreateObject(joaat(Config.LockToggleAnimation.Prop), 0, 0, 0, true, true, true)
                        while not DoesEntityExist(object) do Wait(1) end
                        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, Config.LockToggleAnimation.PropBone),
                            0.1, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                    end

                    loadAnimDict(Config.LockToggleAnimation.AnimDict)
                    TaskPlayAnim(ped, Config.LockToggleAnimation.AnimDict, Config.LockToggleAnimation.Anim, 8.0, -8.0, -1, 52, 0, false, false, false)
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, Config.LockAnimSound, 0.5)
                end

                Citizen.CreateThread(function()
                    if curVeh == 0 then Wait(Config.LockToggleAnimation.WaitTime) end
                    if IsEntityPlayingAnim(ped, Config.LockToggleAnimation.AnimDict, Config.LockToggleAnimation.Anim, 3) then
                        StopAnimTask(ped, Config.LockToggleAnimation.AnimDict, Config.LockToggleAnimation.Anim, 8.0)
                    end
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, Config.LockToggleSound, 0.3)

                    if object ~= 0 and DoesEntityExist(object) then
                        DeleteObject(object)
                        object = 0
                    end
                end)

                NetworkRequestControlOfEntity(veh)
                if vehLockStatus == 1 then
                    TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 2)
                    AJFW.Functions.Notify(Lang:t("notify.vlock"), "primary")
                else
                    TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
                    AJFW.Functions.Notify(Lang:t("notify.vunlock"), "success")
                end

                SetVehicleLights(veh, 2)
                Wait(250)
                SetVehicleLights(veh, 1)
                Wait(200)
                SetVehicleLights(veh, 0)
                Wait(300)
                ClearPedTasks(ped)
            else
                AJFW.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end

function GiveKeys(id, plate)
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id))))
    if distance < 1.5 and distance > 0.0 then
        TriggerServerEvent('aj-vehiclekeys:server:GiveVehicleKeys', id, plate)
    else
        AJFW.Functions.Notify(Lang:t("notify.nonear"),'error')
    end
end

function GetKeys()
    AJFW.Functions.TriggerCallback('aj-vehiclekeys:server:GetVehicleKeys', function(keysList)
        KeysList = keysList
    end)
end

function HasKeys(plate)
    return KeysList[plate]
end
exports('HasKeys', HasKeys)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end
-- If in vehicle returns that, otherwise tries 3 different raycasts to get the vehicle they are facing.
-- Raycasts picture: https://i.imgur.com/FRED0kV.png

function GetVehicle()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    while vehicle == 0 do
        vehicle = AJFW.Functions.GetClosestVehicle()
        if #(pos - GetEntityCoords(vehicle)) > Config.LockToggleDist then
            AJFW.Functions.Notify(Lang:t("notify.vehclose"), "error")
            return
        end
    end

    if not IsEntityAVehicle(vehicle) then vehicle = nil end
    return vehicle
end

function AreKeysJobShared(veh)
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    local vehPlate = AJFW.Functions.GetPlate(veh)
    local jobName = AJFW.Functions.GetPlayerData().job.name
    local onDuty = AJFW.Functions.GetPlayerData().job.onduty
    for job, v in pairs(Config.SharedKeys) do
        if job == jobName then
            if Config.SharedKeys[job].requireOnduty and not onDuty then return false end
            for _, vehicle in pairs(v.vehicles) do
                if string.upper(vehicle) == string.upper(vehName) then
                    if not HasKeys(vehPlate) then
                        TriggerServerEvent("aj-vehiclekeys:server:AcquireVehicleKeys", vehPlate)
                    end
                    return true
                end
            end
        end
    end
    return false
end

function ToggleVehicleLocks(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(AJFW.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local vehLockStatus = GetVehicleDoorLockStatus(veh)
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                NetworkRequestControlOfEntity(veh)
                while NetworkGetEntityOwner(veh) ~= 128 do
                    NetworkRequestControlOfEntity(veh)
                    Wait(0)
                end
                if vehLockStatus == 1 then
                    TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 2)
                    AJFW.Functions.Notify(Lang:t("notify.vlock"), "primary")
                end
                SetVehicleLights(veh, 2)
                Wait(250)
                SetVehicleLights(veh, 1)
                Wait(200)
                SetVehicleLights(veh, 0)
                Wait(300)
                ClearPedTasks(ped)
            else
                AJFW.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end

function ToggleVehicleunLocks(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(AJFW.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local vehLockStatus = GetVehicleDoorLockStatus(veh)
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                NetworkRequestControlOfEntity(veh)
                if vehLockStatus == 2 then
                    TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
                    AJFW.Functions.Notify(Lang:t("notify.vunlock"), "success")
                end
                SetVehicleLights(veh, 2)
                Wait(250)
                SetVehicleLights(veh, 1)
                Wait(200)
                SetVehicleLights(veh, 0)
                Wait(300)
                ClearPedTasks(ped)
            else
                AJFW.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end
function ToggleVehicleTrunk(veh)
    if veh then
        if not isBlacklistedVehicle(veh) then
            if HasKeys(AJFW.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                local ped = PlayerPedId()
                local boot = GetEntityBoneIndexByName(GetVehiclePedIsIn(PlayerPedId(), false), 'boot')
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                NetworkRequestControlOfEntity(veh)
                if boot ~= -1 or DoesEntityExist(veh) then
                    if trunkclose == true then
                        SetVehicleLights(veh, 2)
                        Wait(150)
                        SetVehicleLights(veh, 0)
                        Wait(150)
                        SetVehicleLights(veh, 2)
                        Wait(150)
                        SetVehicleLights(veh, 0)
                        Wait(150)
                        SetVehicleDoorOpen(veh, 5)
                        trunkclose = false
                        ClearPedTasks(ped)
                    else
                        SetVehicleLights(veh, 2)
                        Wait(150)
                        SetVehicleLights(veh, 0)
                        Wait(150)
                        SetVehicleLights(veh, 2)
                        Wait(150)
                        SetVehicleLights(veh, 0)
                        Wait(150)
                        SetVehicleDoorShut(veh, 5)
                        trunkclose = true
                        ClearPedTasks(ped)
                    end
			   end
            else
                AJFW.Functions.Notify(Lang:t("notify.ydhk"), 'error')
            end
        else
            TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(veh), 1)
        end
    end
end
function GetOtherPlayersInVehicle(vehicle)
    local otherPeds = {}
    for seat=-1,GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))-2 do
        local pedInSeat = GetPedInVehicleSeat(vehicle, seat)
        if IsPedAPlayer(pedInSeat) and pedInSeat ~= PlayerPedId() then
            otherPeds[#otherPeds+1] = pedInSeat
        end
    end
    return otherPeds
end

function GetPedsInVehicle(vehicle)
    local otherPeds = {}
    for seat=-1,GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))-2 do
        local pedInSeat = GetPedInVehicleSeat(vehicle, seat)
        if not IsPedAPlayer(pedInSeat) and pedInSeat ~= 0 then
            otherPeds[#otherPeds+1] = pedInSeat
        end
    end
    return otherPeds
end

function IsBlacklistedWeapon()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    if weapon ~= nil then
        for _, v in pairs(Config.NoCarjackWeapons) do
            if weapon == joaat(v) then
                return true
            end
        end
    end
    return false
end

function LockpickDoor(isAdvanced)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) and not IsHotwiring then
        local vehicle = GetVehiclePedIsIn(ped)
        local plate = AJFW.Functions.GetPlate(vehicle)
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and not HasKeys(plate) and not isBlacklistedVehicle(vehicle) and not AreKeysJobShared(vehicle) then
            usingAdvanced = isAdvanced
            TriggerEvent('dpemote:custom:animation', {"mechanic4"})
            Hotwire(vehicle, plate)
        else
            LocalPlayer.state:set("inv_busy", false, true)
        end
    else
        local pos = GetEntityCoords(ped)
        local vehicle = AJFW.Functions.GetClosestVehicle()
        if vehicle == nil or vehicle == 0 then LocalPlayer.state:set("inv_busy", false, true) return end
        if HasKeys(AJFW.Functions.GetPlate(vehicle)) then LocalPlayer.state:set("inv_busy", false, true) return end
        if #(pos - GetEntityCoords(vehicle)) > 2.5 then LocalPlayer.state:set("inv_busy", false, true) return end
        if GetVehicleDoorLockStatus(vehicle) <= 0 then LocalPlayer.state:set("inv_busy", false, true) return end
        usingAdvanced = isAdvanced
        TriggerEvent('dpemote:custom:animation', {"picklock"})
        if usingAdvanced then
            SetVehicleAlarm(vehicle, true)
            SetVehicleAlarmTimeLeft(vehicle, 60000)
            Config.LockPickDoorEventEasy()
        else
            SetVehicleAlarm(vehicle, true)
            SetVehicleAlarmTimeLeft(vehicle, 60000)
            Config.LockPickDoorEventHard()
        end
    end
end

function LockpickFinishCallback(success)
    local vehicle = AJFW.Functions.GetClosestVehicle()

    if success then
        TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
        lastPickedVehicle = vehicle

        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            TriggerServerEvent('aj-vehiclekeys:server:AcquireVehicleKeys', AJFW.Functions.GetPlate(vehicle))
        else
            AJFW.Functions.Notify(Lang:t("notify.vlockpick"), 'success')
            TriggerServerEvent('aj-vehiclekeys:server:setVehLockState', NetworkGetNetworkIdFromEntity(vehicle), 1)
        end
        SetVehicleAlarm(vehicle, false)
        LocalPlayer.state:set("inv_busy", false, true)
    else
        TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
        AttemptPoliceAlert("steal")
        local chance = math.random()
        if usingAdvanced then
            if chance <= Config.RemoveLockpickAdvanced then
                TriggerServerEvent("aj-vehiclekeys:server:breakLockpick", "advancedlockpick", itemData)
                
            end
                LocalPlayer.state:set("inv_busy", false, true)
        else
            if chance <= Config.RemoveLockpickNormal then
                TriggerServerEvent("aj-vehiclekeys:server:breakLockpick", "lockpick", itemData)
                
            end
                LocalPlayer.state:set("inv_busy", false, true)
        end
    end
    TriggerEvent('dpemote:custom:animation', {"c"})
end

function Hotwire(vehicle, plate)
    local ped = PlayerPedId()
    IsHotwiring = true

    SetVehicleAlarm(vehicle, true)
    SetVehicleAlarmTimeLeft(vehicle, 60000)
    if usingAdvanced then
        exports['aj-hacks']:Circle(function(success)
            if success then
                TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
                TriggerServerEvent('aj-vehiclekeys:server:AcquireVehicleKeys', plate)
                SetVehicleAlarm(vehicle, false)
                IsHotwiring = false
                TriggerEvent('dpemote:custom:animation', {"c"})
                LocalPlayer.state:set("inv_busy", false, true)
            else
                local chance = math.random()
                if chance <= Config.RemoveLockpickAdvanced then
                    TriggerServerEvent("aj-vehiclekeys:server:breakLockpick", "advancedlockpick", itemData)
                    
                end
                    LocalPlayer.state:set("inv_busy", false, true)
                IsHotwiring = false
                TriggerEvent('dpemote:custom:animation', {"c"})
            end
        end, math.random(5,7), 12) -- NumberOfCircles, MS
    else
        exports['aj-hacks']:Circle(function(success)
            if success then
                TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
                TriggerServerEvent('aj-vehiclekeys:server:AcquireVehicleKeys', plate)
                SetVehicleAlarm(vehicle, false)
                IsHotwiring = false
                TriggerEvent('dpemote:custom:animation', {"c"})
                LocalPlayer.state:set("inv_busy", false, true)
            else
                local chance = math.random()
                if chance <= Config.RemoveLockpickNormal then
                    TriggerServerEvent("aj-vehiclekeys:server:breakLockpick", "lockpick", itemData)
                    
                end
                    LocalPlayer.state:set("inv_busy", false, true)
                IsHotwiring = false
                TriggerEvent('dpemote:custom:animation', {"c"})
            end
        end, math.random(5,7), 8) -- NumberOfCircles, MS
    end
    SetTimeout(10000, function()
        AttemptPoliceAlert("steal")
    end)
end

function CarjackVehicle(target)
    if not Config.CarJackEnable then return end
    isCarjacking = true
    canCarjack = false
    loadAnimDict('mp_am_hold_up')
    local vehicle = GetVehiclePedIsUsing(target)
    local occupants = GetPedsInVehicle(vehicle)
    for p=1,#occupants do
        local ped = occupants[p]
        CreateThread(function()
            TaskPlayAnim(ped, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 49, 0, false, false, false)
            PlayPain(ped, 6, 0)
            FreezeEntityPosition(vehicle, true)
            SetVehicleUndriveable(vehicle, true)
        end)
        Wait(math.random(200,500))
    end
    -- Cancel progress bar if: Ped dies during robbery, car gets too far away
    CreateThread(function()
        while isCarjacking do
            local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(target))
            if IsPedDeadOrDying(target) or distance > 7.5 then
                TriggerEvent("progressbar:client:cancel")
                FreezeEntityPosition(vehicle, false)
                SetVehicleUndriveable(vehicle, false)
            end
            Wait(100)
        end
    end)
    AJFW.Functions.Progressbar("rob_keys", Lang:t("progress.acjack"), Config.CarjackingTime, false, true, {}, {}, {}, {}, function()
        local hasWeapon, weaponHash = GetCurrentPedWeapon(PlayerPedId(), true)
        if hasWeapon and isCarjacking then
            local carjackChance
            if Config.CarjackChance[tostring(GetWeapontypeGroup(weaponHash))] then
                carjackChance = Config.CarjackChance[tostring(GetWeapontypeGroup(weaponHash))]
            else
                carjackChance = 0.5
            end
            if math.random() <= carjackChance then
                local plate = AJFW.Functions.GetPlate(vehicle)
                    for p=1,#occupants do
                        local ped = occupants[p]
                        CreateThread(function()
                        FreezeEntityPosition(vehicle, false)
                        SetVehicleUndriveable(vehicle, false)
                        TaskLeaveVehicle(ped, vehicle, 0)
                        PlayPain(ped, 6, 0)
                        Wait(1250)
                        ClearPedTasksImmediately(ped)
                        PlayPain(ped, math.random(7,8), 0)
                        MakePedFlee(ped)
                    end)
                end
                TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
                TriggerServerEvent('aj-vehiclekeys:server:AcquireVehicleKeys', plate)
            else
                AJFW.Functions.Notify(Lang:t("notify.cjackfail"), "error")
                FreezeEntityPosition(vehicle, false)
                SetVehicleUndriveable(vehicle, false)
                MakePedFlee(target)
                TriggerServerEvent('hud:server:GainStress', math.random(1, 4))
            end
            isCarjacking = false
            Wait(2000)
            AttemptPoliceAlert("carjack")
            Wait(Config.DelayBetweenCarjackings)
            canCarjack = true
        end
    end, function()
        MakePedFlee(target)
        isCarjacking = false
        Wait(Config.DelayBetweenCarjackings)
        canCarjack = true
    end)
end

function AttemptPoliceAlert(t)
    print(t)
    if not AlertSend then
        local chance = Config.PoliceAlertChance
        if GetClockHours() >= 1 and GetClockHours() <= 6 then
            chance = Config.PoliceNightAlertChance
        end
        if math.random() <= chance then
           TriggerServerEvent('police:server:policeAlert', Lang:t("info.palert") .. t)
        end
        AlertSend = true
        SetTimeout(Config.AlertCooldown, function()
            AlertSend = false
        end)
    end
end

function MakePedFlee(ped)
    SetPedFleeAttributes(ped, 0, 0)
    TaskReactAndFleePed(ped, PlayerPedId())
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    if GetConvar('aj_locale', 'en') == 'en' then
        SetTextFont(4)
    else
        SetTextFont(1)
    end
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-----------------------
----   NUICallback   ----
-----------------------
RegisterNUICallback('closui', function()
	SetNuiFocus(false, false)
end)

RegisterNUICallback('unlock', function()
    ToggleVehicleunLocks(GetVehicle())
	SetNuiFocus(false, false)
end)

RegisterNUICallback('lock', function()
    ToggleVehicleLocks(GetVehicle())
	SetNuiFocus(false, false)
end)

RegisterNUICallback('trunk', function()
    ToggleVehicleTrunk(GetVehicle())
	SetNuiFocus(false, false)
end)

RegisterNUICallback('engine', function()
    ToggleEngine(GetVehicle())
	SetNuiFocus(false, false)
end)
