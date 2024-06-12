local AJFW = exports['aj-base']:GetCoreObject()

local seatsTaken = {}

RegisterNetEvent('aj-sit:takePlace', function(objectCoords)
	seatsTaken[objectCoords] = true
end)

RegisterNetEvent('aj-sit:leavePlace', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end
end)

AJFW.Functions.CreateCallback('aj-sit:getPlace', function(source, cb, objectCoords)
	cb(seatsTaken[objectCoords])
end)