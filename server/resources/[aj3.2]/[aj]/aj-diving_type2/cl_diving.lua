local AJFW = exports['aj-base']:GetCoreObject()

local locations = {
    vector3(3144.94,-280.54,-10.31),
    vector3(3151.75,-286.02,-27.16),
    vector3(3127.14,-341.26,-23.14),
    vector3(3162.18,-357.39,-27.6),
    vector3(3195.47,-388.18,-32.16),
    vector3(3188.67,-395.82,-27.51),
    vector3(3221.45,-405.6,-48.48),
    vector3(3192.30,-385.23,-16.81)
}

local normal = {
    'steel',
    'iron',
    'plastic'   
}

local rare = {
    'goldbar'
}

local pickup = math.random(1, #locations)
local lastpick = 0

local function CreateBlip()
    local divingblip = AddBlipForCoord(3146.24, -280.84, -8.44)
    SetBlipSprite(divingblip, 465)
    SetBlipDisplay(diving, 4)
    SetBlipScale(divingblip, 0.9)
    SetBlipColour(divingblip, 3)
    SetBlipAsShortRange(divingblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Sunken Ship')
    EndTextCommandSetBlipName(divingblip)
end

local function DrawText3D(x, y, z, text)
    -- Use local function instead
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CreateThread(function()
    Wait(1000)
    CreateBlip()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - locations[pickup])
            if dist < 250 then
                sleep = 5
                if dist < 3 then
                    lastpick = pickup
                    pickup = math.random(1, #locations)
                    local random = math.random(1, 100)
                    if random > 0 and random < 60 then
                        TriggerServerEvent("jacob-diving:collected", "normal", normal[math.random(1,#normal)], math.random(1, 4))                
                    elseif random > 95 and random < 100 then
                        TriggerServerEvent("jacob-diving:collected", "rare", rare[math.random(1,#rare)], 1)
                    else
                        TriggerServerEvent("jacob-diving:collected", "none")
                    end
                else
                    DrawText3D(locations[pickup].x, locations[pickup].y, locations[pickup].z, "Distance: "..(math.floor(dist*10)/10).."m")
                end
            end
        end
        Wait(sleep)
    end
end)
