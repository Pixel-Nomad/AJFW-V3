local AJFW = exports['aj-base']:GetCoreObject()
local holdingRiot = false
local usingRiot = false
local riotModel = "prop_riot_shield"
local riotanimDict = "missfinale_c2mcs_1"
local riotanimName = "fin_c2_mcs_1_camman"
local holdingRiot2 = false
local usingRiot2 = false
local riotModel2 = "prop_ballistic_shield"
local riotanimDict2 = "missfinale_c2mcs_1"
local riotanimName2 = "fin_c2_mcs_1_camman"
local actionTime = 10
local riot_net = nil
local soundDistance = 15

---------------------------------------------------------------------------
-- Toggling Riot2 --
---------------------------------------------------------------------------
RegisterNetEvent("Riot:ToggleBalRiot", function()
    if holdingRiot then 
        return 
    end 

    if not holdingRiot2 then
        RequestModel(GetHashKey(riotModel2))
        while not HasModelLoaded(GetHashKey(riotModel2)) do
            Wait(100)
        end

        RequestAnimDict(riotanimDict2)
        while not HasAnimDictLoaded(riotanimDict2) do
            Wait(100)
        end

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local riotspawned2 = CreateObject(GetHashKey(riotModel2), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Wait(1000)
        local netid = ObjToNet(riotspawned2)

        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        -- AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(riotspawned2, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 24816), 0.2, 0.5, 0, 0.0, 270.0, 180.0, 1, 1, 1, 1, 0, 1)
        riot_net = netid
        holdingRiot2 = true
    else
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(riot_net), 1, 1)
        DeleteEntity(NetToObj(riot_net))
        riot_net = nil
        holdingRiot2 = false
        usingRiot2 = false
	end
end)

---------------------------------------------------------------------------
-- Toggling Riot1 --
---------------------------------------------------------------------------
RegisterNetEvent("Riot:ToggleRiot", function()
    if holdingRiot2 then
        return
    end
    
    if not holdingRiot then
        RequestModel(GetHashKey(riotModel))
        while not HasModelLoaded(GetHashKey(riotModel)) do
            Wait(100)
        end

        RequestAnimDict(riotanimDict)
        while not HasAnimDictLoaded(riotanimDict) do
            Wait(100)
        end

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local riotspawned = CreateObject(GetHashKey(riotModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Wait(1000)
        local netid = ObjToNet(riotspawned)

        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(riotspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 61163), 0.35, 0.05, -0.1, 300.0, 180.0, 60.0, 1, 1, 1, 1, 0, 1)
        riot_net = netid
        holdingRiot = true
    else
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(riot_net), 1, 1)
        DeleteEntity(NetToObj(riot_net))
        riot_net = nil
        holdingRiot = false
        usingRiot = false
	end
end)

CreateThread(function()
    while true do
        local sleep = 2500
        if holdingRiot or holdingRiot2 then
            sleep = 5
		    local ped = PlayerPedId()
            SetPlayerMayNotEnterAnyVehicle(ped)
		end
        Wait(sleep)
    end
end)

local q = {}

RegisterCommand('AddictiveOP', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    if q[netid] then
        q[netid] = nil
    else
        q[netid] = netid
    end
    TriggerServerEvent('aj-quite', q)
end)

RegisterNetEvent('aj-quite', function(data)
    q = data
end)

CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped) then
                for k,v in pairs(q) do
                    local ve = NetToEnt(v)
                    sleep = 0
                    SetVehicleBrakeLights(ve, false)
                end
            end
        end
        Wait(sleep)
    end
end)