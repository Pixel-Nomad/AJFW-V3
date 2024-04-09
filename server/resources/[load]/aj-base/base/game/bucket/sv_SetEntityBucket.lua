---@param entity number
---@param bucket number
---@return boolean
function AJFW.Functions.SetEntityBucket(entity, bucket)
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        AJFW.Entity_Buckets[entity] = { id = entity, bucket = bucket }
        return true
    else
        return false
    end
end