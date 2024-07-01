if GetResourceState('ox_target') == 'started' 
or GetResourceState('ox_target') ~= 'started' and GetResourceState('aj-target') ~= 'started' or not config.target then return end

MotelFunction = function(data)
	if not data.Mlo and data.type ~= 'door' then return end
	local options = {}
	if data.type == 'door' then
		local doorIndex = data.doorindex + (joaat(data.motel))
		AddDoorToSystem(doorIndex, data.door, data.coord)
		SetDoorState(data)
	
		if not data.Mlo then
			table.insert(options,{
				name = data.index .. '_' .. data.type..'_lockpick',
				action = function() 
					return EnterShell(data)
				end,
				icon = 'fas fa-person-booth',
				label = 'Enter'
			})
		end
	end
	table.insert(options,{
		name = data.index .. '_' .. data.type,
		action = function() 
			return RoomFunction(data)
		end,
		icon = config.icons[data.type],
		label = data.label
	})
	local target = {
		coords = data.coord,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = drawZones,
		options = options
	}
	local targetid = data.index .. '_' .. data.type
	exports['aj-target']:AddBoxZone(targetid,data.coord,data.length,data.width,{
		name = targetid,
		debugPoly = false,
        heading = data.rotation,
		minZ = data.minZ,
		maxZ = data.maxZ
	},target)
	table.insert(zones,targetid)
end

removeTargetZone = function(id)
	return exports['aj-target']:RemoveZone(id)
end

ShellTargets = function(data,offsets,loc,house)
	Wait(2000)
	for k,v in pairs(offsets) do
		local options = {}
		table.insert(options,{
			name = data.motel .. '_' .. k..'_'..data.index,
			action = function() 
				data.type = k
				return RoomFunction(data)
			end,
			icon = config.icons[k],
			label = config.Text[k]
		})
		if k == 'exit' then
			table.insert(options,{
				name = data.motel .. '_' .. k..'_'..data.index..'_door',
				action = function() 
					data.type = 'door'
					return Door(data)
				end,
				icon = config.icons[k],
				label = 'Toggle Door'
			})
		end

		if k == 'stash' then
			local motels = GlobalState.Motels[data.motel]
			local room = motels?.rooms[data.index] or {}
			local keys = GetPlayerKeys(data,room)
			for identifier,name in pairs(keys) do
				table.insert(options,{
					name = data.motel .. '_' .. k..'_'..data.index..'_'..identifier,
					action = function() 
						data.type = k
						return RoomFunction(data,identifier)
					end,
					icon = config.icons[k],
					label = config.Text[k]..' - ['..name..']'
				})
			end
		end

		local targetid = data.motel .. '_' .. k..'_'..data.index
		exports['aj-target']:AddBoxZone(targetid, loc+v, 0.75, 0.75, {
			name = targetid,
			debugPoly = false,
			minZ = (loc+v).z-0.45,
			maxZ = (loc+v).z+0.45,
		}, {
			options = options,
			distance = 5.5
		})
		table.insert(shelzones,targetid)
	end
end