function AJFW.Functions.StartParticleOnEntity(dict, ptName, looped, entity, bone, offset, rot, scale, alpha, color, evolution, duration)
    AJFW.Functions.LoadParticleDictionary(dict)
    UseParticleFxAssetNextCall(dict)
    local particleHandle, boneID
    if bone and GetEntityType(entity) == 1 then
        boneID = GetPedBoneIndex(entity, bone)
    elseif bone then
        boneID = GetEntityBoneIndexByName(entity, bone)
    end
    if looped then
        if bone then
            particleHandle = StartParticleFxLoopedOnEntityBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
        else
            particleHandle = StartParticleFxLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
        end
        if evolution then
            SetParticleFxLoopedEvolution(particleHandle, evolution.name, evolution.amount, false)
        end
        if color then
            SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
        end
        SetParticleFxLoopedAlpha(particleHandle, alpha)
        if duration then
            Wait(duration)
            StopParticleFxLooped(particleHandle, 0)
        end
    else
        SetParticleFxNonLoopedAlpha(alpha or 10.0)
        if color then
            SetParticleFxNonLoopedColour(color.r, color.g, color.b)
        end
        if bone then
            StartParticleFxNonLoopedOnPedBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
        else
            StartParticleFxNonLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
        end
    end
    return particleHandle
end