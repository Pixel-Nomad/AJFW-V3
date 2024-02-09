local windowState = {}

local function EngineControl()
    local vehicle = GetVehiclePedIsIn(GlobalPlayerPedID, false)
    if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
    end
end

local function InteriorLightControl()
	local playerPed = GlobalPlayerPedID
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if IsVehicleInteriorLightOn(vehicle) then
			SetVehicleInteriorlight(vehicle, false)
		else
			SetVehicleInteriorlight(vehicle, true)
		end
	end
end

local function DoorControl(door)
	local playerPed = GlobalPlayerPedID
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
			SetVehicleDoorShut(vehicle, door, false)
		else
			SetVehicleDoorOpen(vehicle, door, false)
		end
	end
end

local function SeatControl(seat)
	local playerPed = GlobalPlayerPedID
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if IsVehicleSeatFree(vehicle, seat) then
			SetPedIntoVehicle(PlayerPedId(), vehicle, seat)
		end
	end
end

local function WindowControl(window, door)
	local playerPed = GlobalPlayerPedID
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if window == 0 then
			if windowState[1] and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState[1] = false
			else
				RollUpWindow(vehicle, window)
				windowState[1] = true
			end
		elseif window == 1 then
			if windowState[2] and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState[2] = false
			else
				RollUpWindow(vehicle, window)
				windowState[2] = true
			end
		elseif window == 2 then
			if windowState[3] and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState[3] = false
			else
				RollUpWindow(vehicle, window)
				windowState[3] = true
			end
		elseif window == 3 then
			if windowState[4] and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState[4] = false
			else
				RollUpWindow(vehicle, window)
				windowState[4] = true
			end
		end
	end
end

local function FrontWindowControl()
	local playerPed = GlobalPlayerPedID
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState[1] or windowState[2] then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			windowState[1] = false
			windowState[2] = false
		else
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			windowState[1] = true
			windowState[2] = true
		end
	end
end

local function BackWindowControl()
	local playerPed = GlobalPlayerPedID
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState[3] or windowState[4] then
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			windowState[3] = false
			windowState[4] = false
		else
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			windowState[3] = true
			windowState[4] = true
		end
	end
end

local function AllWindowControl()
	local playerPed = GlobalPlayerPedID
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState[1] or windowState[2] or windowState[3] or windowState[4] then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			windowState[1] = false
			windowState[2] = false
			windowState[3] = false
			windowState[4] = false
		else
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			windowState[1] = true
			windowState[2] = true
			windowState[3] = true
			windowState[4] = true
		end
	end
end

TriggerEvent('chat:addSuggestion', '/door', 'Open/Close Vehicle Door', {
    { name="ID", help="1) Driver, 2) Passenger, 3) Driver Side Rear, 4) Passenger Side Rear" }
})

TriggerEvent('chat:addSuggestion', '/seat', 'Move to a seat', {
    { name="ID", help="1) Driver, 2) Passenger, 3) Driver Side Rear, 4) Passenger Side Rear" }
})

TriggerEvent('chat:addSuggestion', '/window', 'Roll Up/Down Window', {
    { name="ID", help="1) Driver, 2) Passenger, 3) Driver Side Rear, 4) Passenger Side Rear" }
})

TriggerEvent('chat:addSuggestion', '/hood', 'Open/Close Hood')
TriggerEvent('chat:addSuggestion', '/trunk', 'Open/Close Trunk')
TriggerEvent('chat:addSuggestion', '/windowfront', 'Roll Up/Down Front Windows')
TriggerEvent('chat:addSuggestion', '/windowback', 'Roll Up/Down Back Windows')
TriggerEvent('chat:addSuggestion', '/windowall', 'Roll Up/Down All Windows')

RegisterCommand("door", function(source, args, rawCommand)
    local doorID = tonumber(args[1])
    if doorID then
        if doorID == 1 then
            DoorControl(0)
        elseif doorID == 2 then
            DoorControl(1)
        elseif doorID == 3 then
            DoorControl(2)
        elseif doorID == 4 then
            DoorControl(3)
        end
    else
        TriggerEvent("chatMessage", "Usage: ", {255, 0, 0}, "/door [door id]")
    end
end, false)

RegisterCommand("seat", function(source, args, rawCommand)
    local seatID = tonumber(args[1])
    if seatID then
        if seatID == 1 then
            SeatControl(-1)
        elseif seatID == 2 then
            SeatControl(0)
        elseif seatID == 3 then
            SeatControl(1)
        elseif seatID == 4 then
            SeatControl(2)
        end
    else
        TriggerEvent("chatMessage", "Usage: ", {255, 0, 0}, "/seat [seat id]")
    end
end, false)

RegisterCommand("window", function(source, args, rawCommand)
    local windowID = tonumber(args[1])
    
    if windowID then
        if windowID == 1 then
            WindowControl(0, 0)
        elseif windowID == 2 then
            WindowControl(1, 1)
        elseif windowID == 3 then
            WindowControl(2, 2)
        elseif windowID == 4 then
            WindowControl(3, 3)
        end
    else
        TriggerEvent("chatMessage", "Usage: ", {255, 0, 0}, "/window [door id]")
    end
end, false)

RegisterCommand("hood", function(source, args, rawCommand)
    DoorControl(4)
end, false)

RegisterCommand("trunk", function(source, args, rawCommand)
    DoorControl(5)
end, false)

RegisterCommand("windowfront", function(source, args, rawCommand)
    FrontWindowControl()
end, false)

RegisterCommand("windowback", function(source, args, rawCommand)
    BackWindowControl()
end, false)

RegisterCommand("windowall", function(source, args, rawCommand)
    AllWindowControl()
end, false)