local CurrentWeather = Config.StartWeather
local lastWeather = CurrentWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local blackoutVehicle = Config.BlackoutVehicle
local disable = Config.Disabled

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    disable = false
    TriggerServerEvent('aj-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('aj-weathersync:client:EnableSync', function()
    disable = false
    TriggerServerEvent('aj-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('aj-weathersync:client:DisableSync', function(a,b,c)
    disable = true
    if not a then a = 18 end
    if not b then b = 0 end
    if not c then c = 0 end
    SetRainLevel(0.0)
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
    NetworkOverrideClockTime(a, b, c)
end)

RegisterNetEvent('aj-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

RegisterNetEvent('aj-weathersync:client:SyncTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

CreateThread(function()
    while true do
        if not disable then
            sleep = 100
            if lastWeather ~= CurrentWeather then
                lastWeather = CurrentWeather
                SetWeatherTypeOverTime(CurrentWeather, 15.0)
                Wait(15000)
            end
            local plane = GetVehiclePedIsIn(PlayerPedId())
            SetArtificialLightsState(blackout)
            SetArtificialLightsStateAffectsVehicles(blackoutVehicle)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)
            if lastWeather == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
            if lastWeather == 'RAIN' then
                SetRainLevel(0.3)
                if IsThisModelAPlane(GetEntityModel(plane)) then    
                    sleep = 3
                    SetPlaneTurbulenceMultiplier(plane, 0.7)
                end
            elseif lastWeather == 'THUNDER' then
                if IsThisModelAPlane(GetEntityModel(plane)) then 
                    sleep = 3
                    SetPlaneTurbulenceMultiplier(plane, 1.0)
                end
                SetRainLevel(0.5)
            else
                SetRainLevel(0.0)
            end
            Wait(sleep) -- Wait 0 seconds to prevent crashing.
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    local hour
    local minute = 0
    local second = 0        --Add seconds for shadow smoothness
    local timeIncrement = Config.RealTimeSync and 0.25 or 1
    local tick = GetGameTimer()

    while true do
        if not disable then
            Wait(0)
            local _, _, _, hours, minutes, _ = GetLocalTime()
            local newBaseTime = baseTime
            if tick - (Config.RealTimeSync and 500 or 22) > tick then
                second = second + timeIncrement
                tick = GetGameTimer()
            end
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
                second = 0
            end
            baseTime = newBaseTime
            if Config.RealTimeSync then
                hour = hours
                minute = minutes
            else
                hour = math.floor(((baseTime+timeOffset)/60)%24)
                if minute ~= math.floor((baseTime+timeOffset)%60) then  --Reset seconds to 0 when new minute
                    minute = math.floor((baseTime+timeOffset)%60)
                    second = 0
                end
            end
            NetworkOverrideClockTime(hour, minute, second) --Send hour included seconds to network clock time
        else
            Wait(1000)
        end
    end
end)
