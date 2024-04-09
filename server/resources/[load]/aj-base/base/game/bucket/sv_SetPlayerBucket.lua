---@param source any
---@param bucket any
---@return boolean
function AJFW.Functions.SetPlayerBucket(source, bucket)
    if source and bucket then
        local plicense = AJFW.Functions.GetIdentifier(source, 'license')
        Player(source).state:set('instance', bucket, true)
        SetPlayerRoutingBucket(source, bucket)
        AJFW.Player_Buckets[plicense] = { id = source, bucket = bucket }
        return true
    else
        return false
    end
end