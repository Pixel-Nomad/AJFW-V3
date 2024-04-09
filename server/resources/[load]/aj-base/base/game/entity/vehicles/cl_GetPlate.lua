function AJFW.Functions.GetPlate(vehicle)
    if vehicle == 0 then return end
    return AJFW.Shared.Trim(GetVehicleNumberPlateText(vehicle))
end