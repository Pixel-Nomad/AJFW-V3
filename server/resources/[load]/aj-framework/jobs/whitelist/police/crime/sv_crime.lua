local aaaaa = 'Jobs/Police'
local cooldown = 0
local inprogress = false
local activeUser = nil
local resetpcd = false
local inprogressStatus = nil

function Jobs_police_crime_d(source,reason)
    if tonumber(activeUser) == tonumber(source) then
        if inprogress and not resetpcd then
            activeUser = nil
            cooldown = Config.CrimeActivity.CooldownTime
            inprogress = false
            Citizen.CreateThread(function()
                if Config.CrimeActivity.DisplaySeconds then
                    cooldown = cooldown * 60
                end
                while cooldown > 0 and not resetpcd do
                    if Config.CrimeActivity.DisplaySeconds then
                        local seconds = cooldown
                        local mins = string.format("%02.f", math.floor(seconds/60));
                        local secs = string.format("%02.f", math.floor(seconds - mins *60));
                        local timer = mins..":"..secs
                        TriggerClientEvent("Priority:updateStatus", -1,'cooldown', "~b~Cooldown "..Config.CrimeActivity.Color.."(~w~"..timer..""..Config.CrimeActivity.Color..")")
                        cooldown = cooldown - 1
                        Citizen.Wait(1000)
                    else
                        TriggerClientEvent("Priority:updateStatus", -1, 'cooldown', "~b~Cooldown "..Config.CrimeActivity.Color.."(~w~"..cooldown..""..Config.CrimeActivity.Color..")")
                        cooldown = cooldown - 1
                        Citizen.Wait(1000 * 60)
                    end
                end
                if cooldown == 0 then
                    TriggerClientEvent("Priority:updateStatus",'inactive', -1, "~g~Inactive")
                end
            end)
        end
    end
end
AJFW.Commands.Add('resetpcd', 'Crime Status InActive', {}, false, function(source, args)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player ~= nil then
        if Player.PlayerData.job.type == 'leo' then
            if Player.PlayerData.job.onduty then
                if inprogress or cooldown ~= 0 then
                    resetpcd = true
                    inprogress = false
                    cooldown = 0
                    activeUser = nil
                    inprogressStatus = nil
                    newStatus = "~g~Inactive"
                    TriggerClientEvent("Priority:updateStatus", -1, 'inactive', newStatus)
                    TriggerClientEvent('chatMessage', -1, 'Alert:The Priority got reset by Police')
                else
                    TriggerClientEvent('chatMessage', source, 'Alert:nNo priority active.')
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Not Authorized", "error", 4000)
            end
        else
            TriggerClientEvent("AJFW:Notify", src, "Not Authorized", "error", 4000)
        end
    end
end, 'leo')
AJFW.Commands.Add('inprogress', 'Crime Status Active', {}, false, function(source, args)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player ~= nil then
        if Player.PlayerData.job.type == 'leo' then
            if Player.PlayerData.job.onduty then
                if inprogress ~= nil and cooldown == 0 then
                    if not inprogress then
                        inprogress = true
                        activeUser = source
                        resetpcd = false
                        newStatus = "~r~Active ~m~"
                        inprogressStatus = newStatus
                        Citizen.CreateThread(function()
                            while inprogress do
                                TriggerClientEvent("Priority:updateStatus", -1,'active', newStatus)
                                Citizen.Wait(1000)
                            end
                        end)
                        TriggerClientEvent('chatMessage', -1, 'Alert:The Priority got reset by Police')
                    else
                        TriggerClientEvent('chatMessage', source, 'Alert:A Priority is already in progress!')
                    end
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Not Authorized", "error", 4000)
            end
        else
            TriggerClientEvent("AJFW:Notify", src, "Not Authorized", "error", 4000)
        end
    end
end, 'leo')
AJFW.Commands.Add('cooldown', 'Crime Status Cooldown', {}, false, function(source, args)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player ~= nil then
        if Player.PlayerData.job.type == 'leo' then
            if Player.PlayerData.job.onduty then
                if activeUser == source then
                    if (inprogress and not resetpcd) then
                        activeUser = nil
                        cooldown = Config.CrimeActivity.CooldownTime
                        if args[1] ~= nil then
                            cooldown = tonumber(args[1])
                        end
                        inprogress = false
                        newStatus = "~g~Inactive"
                        inprogressStatus = nil
                        Citizen.CreateThread(function()
                            if Config.CrimeActivity.DisplaySeconds then
                                cooldown = cooldown * 60
                            end
                            while cooldown > 0 and not resetpcd do
                                if Config.CrimeActivity.DisplaySeconds then
                                    local seconds = cooldown
                                    local mins = string.format("%02.f", math.floor(seconds/60));
                                    local secs = string.format("%02.f", math.floor(seconds - mins *60));
                                    local timer = mins..":"..secs
                                    TriggerClientEvent("Priority:updateStatus", -1,'cooldown', "~b~Cooldown "..Config.CrimeActivity.Color.."(~w~"..timer..""..Config.CrimeActivity.Color..")")
                                    cooldown = cooldown - 1
                                    Citizen.Wait(1000)
                                else
                                    TriggerClientEvent("Priority:updateStatus", -1,'cooldown', "~b~Cooldown "..Config.CrimeActivity.Color.."(~w~"..cooldown..""..Config.CrimeActivity.Color..")")
                                    cooldown = cooldown - 1
                                    Citizen.Wait(1000 * 60)
                                end
                            end
                            if cooldown == 0 then
                                TriggerClientEvent("Priority:updateStatus", -1,'inactive', newStatus)
                                resetpcd = true
                            end
                        end)
                        TriggerClientEvent('chatMessage', -1, 'Alert:The Priority got reset by Police')
                    else
                        TriggerClientEvent('chatMessage', source, 'Alert:You can not trigger a cooldown.Only the person who activates the priority can start the cooldown.')
                    end
                else
                    TriggerClientEvent('chatMessage', source, 'Alert:You don\'t have a priority in progress.')
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Not Authorized", "error", 4000)
            end
        else
            TriggerClientEvent("AJFW:Notify", src, "Not Authorized", "error", 4000)
        end
    end
end, 'leo')

function Jobs_police_crime_c(source)
    if cooldown ~= 0 then
        while cooldown > 0 do
            local seconds = cooldown
            local mins = string.format("%02.f", math.floor(seconds/60));
            local secs = string.format("%02.f", math.floor(seconds - mins *60));
            local timer = mins..":"..secs
            TriggerClientEvent("Priority:updateStatus", -1,'cooldown', "~b~Cooldown "..Config.CrimeActivity.Color.."(~w~"..timer..""..Config.CrimeActivity.Color..")")
            cooldown = cooldown - 1
            Citizen.Wait(1000 * 60)
        end
    end
    if inprogressStatus ~= nil then
        TriggerClientEvent("Priority:updateStatus",'active', source, inprogressStatus)
    end
    if inprogressStatus == nil and cooldown == 0 then
        newStatus = "~g~Inactive"
        TriggerClientEvent("Priority:updateStatus",'inactive', source, newStatus)
    end
end