local aaaaa = 'Player/playtime/leave'

local function playerDrop(citizenid)
	local timeNow = os.time(os.date("!*t"))
	local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})

	local result = MySQL.query.await('SELECT * FROM player_playtime WHERE citizenid = ?', {citizenid})
	if result[1] ~= nil then
		local playTime = timeNow - result[1].lastJoin
		-- print(playTime)
		MySQL.query.await('UPDATE player_playtime SET playTime = ?, lastLeave = ? WHERE citizenid = ?', {(playTime + result[1].playTime), timeNow, citizenid})
	end
end

RegisterNetEvent('AJFW:Server:playtime:leave', function(citizenid)
    playerDrop(citizenid)
end)