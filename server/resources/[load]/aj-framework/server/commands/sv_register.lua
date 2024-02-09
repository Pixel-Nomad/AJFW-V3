AJFW.Commands.Add("reloadqueue", "Give queue priority", {}, false, function(source, args)
	TriggerEvent('load:queue:db')
	TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "REFRESH")	
end, "manager")

AJFW.Commands.Add('addpriority', 'Give queue priority', {{name="id", help="ID of the player"}, {name="priority", help="Priority level"}, {name="expire", help="true or false"}, {name="days", help="how many days to expire"}}, false, function(source, args)
    local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
    local level  = tonumber(args[2])
    local expire = args[3]
    local days   = tonumber(args[4])
    if Player then
        if level then
            if level > 0 and level <= 9 then
                if expire == 'true' then
                    if days ~= nil then
                        Modular:AddPriority(Player.PlayerData.source, level, true, days)
                        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Success")
                    else
                        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Invalid days type")
                    end
                elseif expire == 'false' then
                    Modular:AddPriority(Player.PlayerData.source, level, false)
                    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Success")
                else
                    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Invalid expire type")
                end
            else
                TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "1-9 only")
            end
        else
		    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Invalid Level")
        end	
    else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online!")	
    end
end,'manager')

AJFW.Commands.Add("removepriority", "Take priority away from someone", {{name="id", help="ID of the player"}}, true, function(source, args)
	local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
	if Player then
        Modular:RemovePriority(Player.PlayerData.source)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "You removed priority from " .. GetPlayerName(Player.PlayerData.source))	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online!")	
	end
end, "manager")

AJFW.Commands.Add("gpadmin", "Get Player Playtime", {{name="id", help="ID of the player"}}, true, function(source, args)
	local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
        if result[1] ~= nil then
            local storedTime = result[1].playTime
            local joinTime = result[1].lastJoin
            local timeNow = os.time(os.date("!*t"))
    
            TriggerClientEvent('chat:addMessage', source, { args = {"Playtime", Player.PlayerData.name.."'s playtime: "..Modular:SecondsToClock((timeNow - joinTime) + storedTime)} })
        end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online!")	
	end
end, "h-admin")

AJFW.Commands.Add("getplaytime", "Get playTime of your character", {}, true, function(source, args)
	local Player = AJFW.Functions.GetPlayer(source)
	if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
        if result[1] ~= nil then
            local storedTime = result[1].playTime
            local joinTime = result[1].lastJoin
            local timeNow = os.time(os.date("!*t"))
            TriggerClientEvent('chat:addMessage', source, { args = {"playtime: ", Modular:SecondsToClock((timeNow - joinTime) + storedTime)} })
        end
	end
end)

AJFW.Commands.Add('tp', Lang:t('command.tp.help'), { { name = Lang:t('command.tp.params.x.name'), help = Lang:t('command.tp.params.x.help') }, { name = Lang:t('command.tp.params.y.name'), help = Lang:t('command.tp.params.y.help') }, { name = Lang:t('command.tp.params.z.name'), help = Lang:t('command.tp.params.z.help') } }, false, function(source, args)
    if args[1] and not args[2] and not args[3] then
        if tonumber(args[1]) then
            local target = GetPlayerPed(tonumber(args[1]))
            if target ~= 0 then
                local coords = GetEntityCoords(target)
                TriggerClientEvent('AJFW:Command:TeleportToPlayer', source, coords)
            else
                TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
            end
        else
            local location = AJShared.Locations[args[1]]
            if location then
                TriggerClientEvent('AJFW:Command:TeleportToCoords', source, location.x, location.y, location.z, location.w)
            else
                TriggerClientEvent('AJFW:Notify', source, Lang:t('error.location_not_exist'), 'error')
            end
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber((args[1]:gsub(',', ''))) + .0
            local y = tonumber((args[2]:gsub(',', ''))) + .0
            local z = tonumber((args[3]:gsub(',', ''))) + .0
            if x ~= 0 and y ~= 0 and z ~= 0 then
                TriggerClientEvent('AJFW:Command:TeleportToCoords', source, x, y, z)
            else
                TriggerClientEvent('AJFW:Notify', source, Lang:t('error.wrong_format'), 'error')
            end
        else
            TriggerClientEvent('AJFW:Notify', source, Lang:t('error.missing_args'), 'error')
        end
    end
end, 'admin')

AJFW.Commands.Add('tpm', Lang:t('command.tpm.help'), {}, false, function(source)
    TriggerClientEvent('AJFW:Command:GoToMarker', source)
end, 'admin')

AJFW.Commands.Add('togglepvp', Lang:t('command.togglepvp.help'), {}, false, function()
    AJFW.Config.Server.PVP = not AJFW.Config.Server.PVP
    TriggerClientEvent('AJFW:Client:PvpHasToggled', -1, AJFW.Config.Server.PVP)
end, 'admin')

-- Permissions

AJFW.Commands.Add('addpermission', Lang:t('command.addpermission.help'), { { name = Lang:t('command.addpermission.params.id.name'), help = Lang:t('command.addpermission.params.id.help') }, { name = Lang:t('command.addpermission.params.permission.name'), help = Lang:t('command.addpermission.params.permission.help') } }, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        AJFW.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'god')

AJFW.Commands.Add('removepermission', Lang:t('command.removepermission.help'), { { name = Lang:t('command.removepermission.params.id.name'), help = Lang:t('command.removepermission.params.id.help') }, { name = Lang:t('command.removepermission.params.permission.name'), help = Lang:t('command.removepermission.params.permission.help') } }, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        AJFW.Functions.RemovePermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'god')

-- Open & Close Server

AJFW.Commands.Add('openserver', Lang:t('command.openserver.help'), {}, false, function(source)
    if not AJFW.Config.Server.Closed then
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.server_already_open'), 'error')
        return
    end
    if AJFW.Functions.HasPermission(source, 'admin') then
        AJFW.Config.Server.Closed = false
        TriggerClientEvent('AJFW:Notify', source, Lang:t('success.server_opened'), 'success')
    else
        AJFW.Functions.Kick(source, Lang:t('error.no_permission'), nil, nil)
    end
end, 'admin')

AJFW.Commands.Add('closeserver', Lang:t('command.closeserver.help'), { { name = Lang:t('command.closeserver.params.reason.name'), help = Lang:t('command.closeserver.params.reason.help') } }, false, function(source, args)
    if AJFW.Config.Server.Closed then
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.server_already_closed'), 'error')
        return
    end
    if AJFW.Functions.HasPermission(source, 'admin') then
        local reason = args[1] or 'No reason specified'
        AJFW.Config.Server.Closed = true
        AJFW.Config.Server.ClosedReason = reason
        for k in pairs(AJFW.Players) do
            if not AJFW.Functions.HasPermission(k, AJFW.Config.Server.WhitelistPermission) then
                AJFW.Functions.Kick(k, reason, nil, nil)
            end
        end
        TriggerClientEvent('AJFW:Notify', source, Lang:t('success.server_closed'), 'success')
    else
        AJFW.Functions.Kick(source, Lang:t('error.no_permission'), nil, nil)
    end
end, 'admin')

-- Vehicle

AJFW.Commands.Add('car', Lang:t('command.car.help'), { { name = Lang:t('command.car.params.model.name'), help = Lang:t('command.car.params.model.help') } }, true, function(source, args)
    TriggerClientEvent('AJFW:Command:SpawnVehicle', source, args[1])
end, 'admin')

AJFW.Commands.Add('dv', Lang:t('command.dv.help'), {}, false, function(source)
    TriggerClientEvent('AJFW:Command:DeleteVehicle', source)
end, 'admin')

AJFW.Commands.Add('dvall', Lang:t('command.dvall.help'), {}, false, function()
    local vehicles = GetAllVehicles()
    for _, vehicle in ipairs(vehicles) do
        DeleteEntity(vehicle)
    end
end, 'admin')

-- Peds

AJFW.Commands.Add('dvp', Lang:t('command.dvp.help'), {}, false, function()
    local peds = GetAllPeds()
    for _, ped in ipairs(peds) do
        DeleteEntity(ped)
    end
end, 'admin')

-- Objects

AJFW.Commands.Add('dvo', Lang:t('command.dvo.help'), {}, false, function()
    local objects = GetAllObjects()
    for _, object in ipairs(objects) do
        DeleteEntity(object)
    end
end, 'admin')

-- Money

AJFW.Commands.Add('givemoney', Lang:t('command.givemoney.help'), { { name = Lang:t('command.givemoney.params.id.name'), help = Lang:t('command.givemoney.params.id.help') }, { name = Lang:t('command.givemoney.params.moneytype.name'), help = Lang:t('command.givemoney.params.moneytype.help') }, { name = Lang:t('command.givemoney.params.amount.name'), help = Lang:t('command.givemoney.params.amount.help') } }, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]), 'Admin give money')
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

AJFW.Commands.Add('setmoney', Lang:t('command.setmoney.help'), { { name = Lang:t('command.setmoney.params.id.name'), help = Lang:t('command.setmoney.params.id.help') }, { name = Lang:t('command.setmoney.params.moneytype.name'), help = Lang:t('command.setmoney.params.moneytype.help') }, { name = Lang:t('command.setmoney.params.amount.name'), help = Lang:t('command.setmoney.params.amount.help') } }, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Job

AJFW.Commands.Add('job', Lang:t('command.job.help'), {}, false, function(source)
    local PlayerJob = AJFW.Functions.GetPlayer(source).PlayerData.job
    TriggerClientEvent('AJFW:Notify', source, Lang:t('info.job_info', { value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty }))
end, 'user')

AJFW.Commands.Add('setjob', Lang:t('command.setjob.help'), { { name = Lang:t('command.setjob.params.id.name'), help = Lang:t('command.setjob.params.id.help') }, { name = Lang:t('command.setjob.params.job.name'), help = Lang:t('command.setjob.params.job.help') }, { name = Lang:t('command.setjob.params.grade.name'), help = Lang:t('command.setjob.params.grade.help') } }, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Gang

AJFW.Commands.Add('gang', Lang:t('command.gang.help'), {}, false, function(source)
    local PlayerGang = AJFW.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('AJFW:Notify', source, Lang:t('info.gang_info', { value = PlayerGang.label, value2 = PlayerGang.grade.name }))
end, 'user')

AJFW.Commands.Add('setgang', Lang:t('command.setgang.help'), { { name = Lang:t('command.setgang.params.id.name'), help = Lang:t('command.setgang.params.id.help') }, { name = Lang:t('command.setgang.params.gang.name'), help = Lang:t('command.setgang.params.gang.help') }, { name = Lang:t('command.setgang.params.grade.name'), help = Lang:t('command.setgang.params.grade.help') } }, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Out of Character Chat
AJFW.Commands.Add('ooc', Lang:t('command.ooc.help'), {}, false, function(source, args)
    local message = table.concat(args, ' ')
    local Players = AJFW.Functions.GetPlayers()
    local Player = AJFW.Functions.GetPlayer(source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Players) do
        if v == source then
            TriggerClientEvent('chat:addMessage', v, {
                color = AJFW.Config.Commands.OOCColor,
                multiline = true,
                args = { 'OOC | ' .. GetPlayerName(source), message }
            })
        elseif #(playerCoords - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
            TriggerClientEvent('chat:addMessage', v, {
                color = AJFW.Config.Commands.OOCColor,
                multiline = true,
                args = { 'OOC | ' .. GetPlayerName(source), message }
            })
        elseif AJFW.Functions.HasPermission(v, 'admin') then
            if AJFW.Functions.IsOptin(v) then
                TriggerClientEvent('chat:addMessage', v, {
                    color = AJFW.Config.Commands.OOCColor,
                    multiline = true,
                    args = { 'Proximity OOC | ' .. GetPlayerName(source), message }
                })
                TriggerEvent('aj-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(source) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') **Message:** ' .. message, false)
            end
        end
    end
end, 'user')

-- Me command

AJFW.Commands.Add('me', Lang:t('command.me.help'), { { name = Lang:t('command.me.params.message.name'), help = Lang:t('command.me.params.message.help') } }, false, function(source, args)
    if #args < 1 then
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.missing_args2'), 'error')
        return
    end
    local ped = GetPlayerPed(source)
    local pCoords = GetEntityCoords(ped)
    local msg = table.concat(args, ' '):gsub('[~<].-[>~]', '')
    local Players = AJFW.Functions.GetPlayers()
    for i = 1, #Players do
        local Player = Players[i]
        local target = GetPlayerPed(Player)
        local tCoords = GetEntityCoords(target)
        if target == ped or #(pCoords - tCoords) < 20 then
            TriggerClientEvent('AJFW:Command:ShowMe3D', Player, source, msg)
        end
    end
end, 'user')