function AJFW.Functions.GetClosestBone(entity, list)
    local playerCoords, bone, coords, distance = GetEntityCoords(PlayerPedId())
    for _, element in pairs(list) do
        local boneCoords = GetWorldPositionOfEntityBone(entity, element.id or element)
        local boneDistance = #(playerCoords - boneCoords)
        if not coords then
            bone, coords, distance = element, boneCoords, boneDistance
        elseif distance > boneDistance then
            bone, coords, distance = element, boneCoords, boneDistance
        end
    end
    if not bone then
        bone = { id = GetEntityBoneIndexByName(entity, 'bodyshell'), type = 'remains', name = 'bodyshell' }
        coords = GetWorldPositionOfEntityBone(entity, bone.id)
        distance = #(coords - playerCoords)
    end
    return bone, coords, distance
end