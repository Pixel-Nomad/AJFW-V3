local aaaaa = 'Commands/Functions'


local function AddPriority(src, level, expire, days)
	local Player = AJFW.Functions.GetPlayer(src)
    local identifiers, steamIdentifier = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            steamIdentifier = v
            break
        end
    end

    Wait(500)
	if Player ~= nil then 
        local result = MySQL.prepare.await('SELECT * FROM queue WHERE license = ?', {steamIdentifier})
        if result then
            if expire then
                MySQL.prepare.await('UPDATE queue SET priority = ?, expiredd = ?, days = ? WHERE license = ?', {level, 1, days, steamIdentifier})
            else
                MySQL.prepare.await('UPDATE queue SET priority = ?, expiredd = ?, days = ? WHERE license = ?', {level, 0, 1, steamIdentifier})
            end
        else
            if expire then
                MySQL.insert.await('INSERT INTO queue (name, license, priority, expiredd, days) VALUES (?, ?, ?, ?, ?)', {GetPlayerName(src), steamIdentifier, level, 1, days})
            else
                MySQL.insert.await('INSERT INTO queue (name, license, priority, expiredd, days) VALUES (?, ?, ?, ?, ?)', {GetPlayerName(src), steamIdentifier, level, 0, 1})
            end
        end
		Player.Functions.UpdatePlayerData()
        TriggerEvent('load:queue:db')
	end
end


local function RemovePriority(src)
	local Player = AJFW.Functions.GetPlayer(src)
    local identifiers, steamIdentifier = GetPlayerIdentifiers(src)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            steamIdentifier = v
            break
        end
    end
    Citizen.Wait(500)
	if Player ~= nil then 
        MySQL.query('DELETE FROM queue WHERE license = ?', {steamIdentifier})
        TriggerEvent('load:queue:db')
	end
end

local function SecondsToClock(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600 )
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	if days == 0 and hours == 0 and minutes == 0 then
		return string.format("%d seconds.", seconds)
	elseif days == 0 and hours == 0 then
		return string.format("%d minutes, %d seconds.", minutes, seconds)
	elseif days == 0 then
		return string.format("%d hours, %d minutes, %d seconds.", hours, minutes, seconds)
	else
		return string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
	end
	return string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
end

exports('AddPriority',AddPriority)
exports('RemovePriority',RemovePriority)
exports('SecondsToClock',SecondsToClock)
