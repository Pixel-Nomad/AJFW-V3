function AJFW.Functions.GetVehicleLabel(vehicle)
    if vehicle == nil or vehicle == 0 then return end
    return GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
end