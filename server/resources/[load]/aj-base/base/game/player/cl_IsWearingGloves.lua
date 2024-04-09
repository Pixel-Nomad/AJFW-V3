function AJFW.Functions.IsWearingGloves()
    local ped = PlayerPedId()
    local armIndex = GetPedDrawableVariation(ped, 3)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        if AJFW.Shared.MaleNoGloves[armIndex] then
            return false
        end
    else
        if AJFW.Shared.FemaleNoGloves[armIndex] then
            return false
        end
    end
    return true
end