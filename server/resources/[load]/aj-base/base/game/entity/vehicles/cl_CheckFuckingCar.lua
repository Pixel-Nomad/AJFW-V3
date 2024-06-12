function AJFW.Functions.CheckFuckingCar(coords)
    local veh = 1000
    local retval, out = FindFirstVehicle()
    local check
    repeat
        local dist = GetDistanceBetweenCoords(GetEntityCoords(out), coords.x, coords.y, coords.z)
        if dist < veh then
            veh = dist
        end
        check, out = FindNextVehicle(retval, out)
    until not check
    EndFindVehicle(retval)
    return veh
end