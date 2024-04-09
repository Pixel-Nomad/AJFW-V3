---@param bucket number
---@return table|boolean
function AJFW.Functions.GetEntitiesInBucket(bucket)
    local curr_bucket_pool = {}
    if AJFW.Entity_Buckets and next(AJFW.Entity_Buckets) then
        for _, v in pairs(AJFW.Entity_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end