local Scanned = false

local function CheckWeapons()
    local Found = false
    local Promise = promise.new()
    for i = 1, #Config.MetalDetectors['Detect'] do
        AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
            if result then
                if not Found then
                    Found = true
                end
                Promise.resolve(true)
            end
            Promise.resolve(false)
        end, Config.MetalDetectors['Detect'][i])
        local Waiting = Citizen.Await(Promise)
    end
    return Found
end

CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(GlobalPlayerPedID)
            if PlayerJob.type ~= 'leo' then
                sleep = 100
                for i = 1, #Config.MetalDetectors['Locations'] do
                    local target = Config.MetalDetectors['Locations'][i]
                    local dist = #(pos-target)
                    if dist <= 15 then
                        sleep = 25
                        if dist <= 7 then
                            sleep = 10
                            if dist <= 1.5 then
                                sleep = 5
                                if not Scanned then
                                    Scanned = true
                                    if CheckWeapons() then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15, "detector", 0.1)
                                        Wait(2000)
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15, "detector", 0.0)
                                    end
                                end
                            end
                        end
                    else
                        Scanned = false
                    end
                end
            end
        end
        Wait(sleep)
    end
end)


RegisterNetEvent('police:outsidestash', function()
    TriggerEvent("inventory:client:SetCurrentStash", "Secstash_"..AJFW.Functions.GetPlayerData().citizenid)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "Secstash_"..AJFW.Functions.GetPlayerData().citizenid, {
    maxweight = 4000000,
    slots = 15,
    })   
end)