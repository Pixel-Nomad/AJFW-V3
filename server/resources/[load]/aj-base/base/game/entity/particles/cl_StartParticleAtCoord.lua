function AJFW.Functions.StartParticleAtCoord(dict, ptName, looped, coords, rot, scale, alpha, color, duration)
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    AJFW.Functions.LoadParticleDictionary(dict)
    UseParticleFxAssetNextCall(dict)
    SetPtfxAssetNextCall(dict)
    local particleHandle
    if looped then
        particleHandle = StartParticleFxLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
        if color then
            SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
        end
        SetParticleFxLoopedAlpha(particleHandle, alpha or 10.0)
        if duration then
            Wait(duration)
            StopParticleFxLooped(particleHandle, 0)
        end
    else
        SetParticleFxNonLoopedAlpha(alpha or 10.0)
        if color then
            SetParticleFxNonLoopedColour(color.r, color.g, color.b)
        end
        StartParticleFxNonLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
    end
    return particleHandle
end