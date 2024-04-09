---@param bucket number
---@return table|boolean
function AJFW.Functions.GetPlayersInBucket(bucket)
    local curr_bucket_pool = {}
    if AJFW.Player_Buckets and next(AJFW.Player_Buckets) then
        for _, v in pairs(AJFW.Player_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end