local AJFW = exports['aj-base']:GetCoreObject()

local seatsTaken = {}

RegisterNetEvent('qb-sit:takePlace', function(objectCoords)
	seatsTaken[objectCoords] = true
end)

RegisterNetEvent('qb-sit:leavePlace', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end
end)

AJFW.Functions.CreateCallback('qb-sit:getPlace', function(source, cb, objectCoords)
	cb(seatsTaken[objectCoords])
end)