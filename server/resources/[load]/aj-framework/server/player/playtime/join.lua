local aaaaa = 'Player/playtime/join'

local function playerJoin(citizenid)
	local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
	if result[1] ~= nil then
		MySQL.query.await('UPDATE player_playtime SET lastJoin = ?, lastLeave = 0 WHERE citizenid = ?', {os.time(os.date("!*t")), citizenid})
	else
		MySQL.query.await('INSERT INTO player_playtime (citizenid, playTime, lastJoin, lastLeave) VALUES (?, 0, ?, 0);', {citizenid, os.time(os.date("!*t"))})
	end
end

RegisterNetEvent('AJFW:Server:playtime:join', function(citizenid)
    playerJoin(citizenid)
end)