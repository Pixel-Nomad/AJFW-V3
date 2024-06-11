local disableHudComponents = Config.Disable.hudComponents
local disableControls = Config.Disable.controls
local displayAmmo = Config.Disable.displayAmmo

local function decorSet(Type, Value)
    if Type == 'parked' then
        Config.Density.parked = Value
    elseif Type == 'vehicle' then
        Config.Density.vehicle = Value
    elseif Type == 'multiplier' then
        Config.Density.multiplier = Value
    elseif Type == 'peds' then
        Config.Density.peds = Value
    elseif Type == 'scenario' then
        Config.Density.scenario = Value
    end
end

local density = {
    ['parked'] = 1.0,
    ['vehicle'] = 0.3,
    ['multiplier'] = 1.0,
    ['peds'] = 1.0,
    ['scenario'] = 1.0,
}
local weather = 'CLEAR'

exports('DecorSet', decorSet)

CreateThread(function()
    while true do

        for i = 1, #disableHudComponents do
            HideHudComponentThisFrame(disableHudComponents[i])
        end

        for i = 1, #disableControls do
            DisableControlAction(2, disableControls[i], true)
        end

        DisplayAmmoThisFrame(displayAmmo)

        SetParkedVehicleDensityMultiplierThisFrame(density['parked'])
		SetVehicleDensityMultiplierThisFrame(density['vehicle'])
		SetRandomVehicleDensityMultiplierThisFrame(density['multiplier'])
		SetPedDensityMultiplierThisFrame(density['peds'])
		SetScenarioPedDensityMultiplierThisFrame(density['scenario'], density['scenario']) -- Walking NPC Density
		SetPickupAmmoAmountScaler(0)
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
        Wait(0)
    end
end)

exports('addDisableHudComponents', function(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        disableHudComponents[#disableHudComponents + 1] = hudComponents
    elseif hudComponentsType == 'table' and table.type(hudComponents) == "array" then
        for i = 1, #hudComponents do
            disableHudComponents[#disableHudComponents + 1] = hudComponents[i]
        end
    end
end)

exports('removeDisableHudComponents', function(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        for i = 1, #disableHudComponents do
            if disableHudComponents[i] == hudComponents then
                table.remove(disableHudComponents, i)
                break
            end
        end
    elseif hudComponentsType == 'table' and table.type(hudComponents) == "array" then
        for i = 1, #disableHudComponents do
            for i2 = 1, #hudComponents do
                if disableHudComponents[i] == hudComponents[i2] then
                    table.remove(disableHudComponents, i)
                end
            end
        end
    end
end)

exports('getDisableHudComponents', function() return disableHudComponents end)

exports('addDisableControls', function(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        disableControls[#disableControls + 1] = controls
    elseif controlsType == 'table' and table.type(controls) == "array" then
        for i = 1, #controls do
            disableControls[#disableControls + 1] = controls[i]
        end
    end
end)

exports('removeDisableControls', function(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        for i = 1, #disableControls do
            if disableControls[i] == controls then
                table.remove(disableControls, i)
                break
            end
        end
    elseif controlsType == 'table' and table.type(controls) == "array" then
        for i = 1, #disableControls do
            for i2 = 1, #controls do
                if disableControls[i] == controls[i2] then
                    table.remove(disableControls, i)
                end
            end
        end
    end
end)

exports('getDisableControls', function() return disableControls end)

exports('setDisplayAmmo', function(bool) displayAmmo = bool end)

exports('getDisplayAmmo', function() return displayAmmo end)


CreateThread(function()
	while true do
		Wait(1000)
		local hour = GetClockHours()
		if (hour >= 00 and hour <= 04) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 1.0,
					['vehicle'] = 0.1,
					['multiplier'] = 0.1,
					['peds'] = 0.1,
					['scenario'] = 0.1,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 1.0,
					['vehicle'] = 0.1,
					['multiplier'] = 0.1,
					['peds'] = 0.0,
					['scenario'] = 0.0,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 1.0,
					['vehicle'] = 0.0,
					['multiplier'] = 0.0,
					['peds'] = 0.1,
					['scenario'] = 0.1,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 1.0,
					['vehicle'] = 0.0,
					['multiplier'] = 0.0,
					['peds'] = 0.0,
					['scenario'] = 0.0,
				}
			end
		elseif (hour >= 04 and hour <= 05) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.9,
					['vehicle'] = 0.2,
					['multiplier'] = 0.2,
					['peds'] = 0.1,
					['scenario'] = 0.1,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.9,
					['vehicle'] = 0.2,
					['multiplier'] = 0.2,
					['peds'] = 0.0,
					['scenario'] = 0.0,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 1.0,
					['vehicle'] = 0.1,
					['multiplier'] = 0.1,
					['peds'] = 0.1,
					['scenario'] = 0.1,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 1.0,
					['vehicle'] = 0.1,
					['multiplier'] = 0.1,
					['peds'] = 0.0,
					['scenario'] = 0.0,
				}
			end
		elseif (hour >= 05 and hour <= 06) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.8,
					['vehicle'] = 0.3,
					['multiplier'] = 0.3,
					['peds'] = 0.2,
					['scenario'] = 0.2,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.8,
					['vehicle'] = 0.3,
					['multiplier'] = 0.3,
					['peds'] = 0.1,
					['scenario'] = 0.1,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.95,
					['vehicle'] = 0.15,
					['multiplier'] = 0.15,
					['peds'] = 0.2,
					['scenario'] = 0.2,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.95,
					['vehicle'] = 0.15,
					['multiplier'] = 0.15,
					['peds'] = 0.1,
					['scenario'] = 0.1,
				}
			end
		elseif (hour >= 06 and hour <= 07) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.3,
					['scenario'] = 0.3,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.15,
					['scenario'] = 0.15,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.3,
					['scenario'] = 0.3,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.15,
					['scenario'] = 0.15,
				}
			end
		elseif (hour >= 07 and hour <= 10) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.1,
					['vehicle'] = 1.0,
					['multiplier'] = 1.0,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.1,
					['vehicle'] = 1.0,
					['multiplier'] = 1.0,
					['peds'] = 0.25,
					['scenario'] = 0.25,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.25,
					['scenario'] = 0.25,
				}
			end
		elseif (hour >= 10 and hour <= 12) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.25,
					['scenario'] = 0.25,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.25,
					['scenario'] = 0.25,
				}
			end
		elseif (hour >= 12 and hour <= 14) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.4,
					['vehicle'] = 0.7,
					['multiplier'] = 0.7,
					['peds'] = 0.6,
					['scenario'] = 0.6,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.4,
					['vehicle'] = 0.7,
					['multiplier'] = 0.7,
					['peds'] = 0.3,
					['scenario'] = 0.3,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.75,
					['vehicle'] = 0.35,
					['multiplier'] = 0.35,
					['peds'] = 0.6,
					['scenario'] = 0.6,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.75,
					['vehicle'] = 0.35,
					['multiplier'] = 0.35,
					['peds'] = 0.3,
					['scenario'] = 0.3,
				}
			end
		elseif (hour >= 14 and hour <= 15) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.7,
					['scenario'] = 0.7,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.35,
					['scenario'] = 0.35,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.7,
					['scenario'] = 0.7,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.35,
					['scenario'] = 0.35,
				}
			end
		elseif (hour >= 15 and hour <= 16) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.4,
					['vehicle'] = 0.7,
					['multiplier'] = 0.7,
					['peds'] = 0.8,
					['scenario'] = 0.8,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.4,
					['vehicle'] = 0.7,
					['multiplier'] = 0.7,
					['peds'] = 0.4,
					['scenario'] = 0.4,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.75,
					['vehicle'] = 0.35,
					['multiplier'] = 0.35,
					['peds'] = 0.8,
					['scenario'] = 0.8,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.75,
					['vehicle'] = 0.35,
					['multiplier'] = 0.35,
					['peds'] = 0.4,
					['scenario'] = 0.4,
				}
			end
		elseif (hour >= 16 and hour <= 19) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.1,
					['vehicle'] = 1.0,
					['multiplier'] = 1.0,
					['peds'] = 1.0,
					['scenario'] = 1.0,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.1,
					['vehicle'] = 1.0,
					['multiplier'] = 1.0,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 1.0,
					['scenario'] = 1.0,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			end
		elseif (hour >= 19 and hour <= 21) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.6,
					['vehicle'] = 0.5,
					['multiplier'] = 0.5,
					['peds'] = 0.25,
					['scenario'] = 0.25,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.5,
					['scenario'] = 0.5,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.85,
					['vehicle'] = 0.25,
					['multiplier'] = 0.25,
					['peds'] = 0.25,
					['scenario'] = 0.25,
				}
			end
		elseif (hour >= 21 and hour <= 00) then
			if weather == 'CLEAR' or weather == 'EXTRASUNNY' or weather == 'CLOUDS' or weather == 'OVERCAST' then
				density = {
					['parked'] = 0.8,
					['vehicle'] = 0.3,
					['multiplier'] = 0.3,
					['peds'] = 0.3,
					['scenario'] = 0.3,
				}
			elseif weather == 'SNOWLIGHT' or weather == 'SNOW' or weather == 'SMOG' or weather == 'CLEARING' or weather == 'RAIN' then
				density = {
					['parked'] = 0.8,
					['vehicle'] = 0.3,
					['multiplier'] = 0.3,
					['peds'] = 0.15,
					['scenario'] = 0.15,
				}
			elseif weather == 'FOGGY' then
				density = {
					['parked'] = 0.95,
					['vehicle'] = 0.15,
					['multiplier'] = 0.15,
					['peds'] = 0.3,
					['scenario'] = 0.3,
				}
			elseif weather == 'THUNDER' or weather == 'BLIZZARD' or weather == 'NEUTRAL' or weather == 'XMAS' or weather == 'HALLOWEEN' then
				density = {
					['parked'] = 0.95,
					['vehicle'] = 0.15,
					['multiplier'] = 0.15,
					['peds'] = 0.15,
					['scenario'] = 0.15,
				}
			end
		end
	end
end)

RegisterNetEvent('aj-smallresources:density:states', function(data)
	weather = data
end)

CreateThread(function()
	while true do
		sleep = 200
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		if DoesEntityExist(veh) and not IsEntityDead(veh) then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				sleep = 5
				local model = GetEntityModel(veh)
				if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and IsEntityInAir(veh) then
					DisableControlAction(0, 59)
                	DisableControlAction(0, 60)
				end
			end
		end
		Wait(sleep)
	end
end)