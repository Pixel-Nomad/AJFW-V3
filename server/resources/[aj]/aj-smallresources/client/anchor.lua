
RegisterCommand("anchor", function()
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    if IsPedInAnyBoat(plyPed) then
        local boat = GetVehiclePedIsIn(plyPed, false)

        if GetEntitySpeed(boat) >= 5 then
            AJFW.Functions.Notify('you are going way to fast!', 'error')
            return
        end

        if IsBoatAnchoredAndFrozen(boat) then
            SetBoatAnchor(boat, false)
            SetBoatFrozenWhenAnchored(boat, false)

            AJFW.Functions.Notify('anchor detached!', 'success')  
        else
            SetBoatAnchor(boat, true)
            SetBoatFrozenWhenAnchored(boat, true)

            AJFW.Functions.Notify('anchor attached!', 'success')        
        end
    else
        AJFW.Functions.Notify('you are not in a boat!', 'error') 
    end
end, false)