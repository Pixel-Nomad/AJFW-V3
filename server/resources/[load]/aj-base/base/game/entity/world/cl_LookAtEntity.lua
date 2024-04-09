---@param entity number - The entity to look at
---@param timeout number - The time in milliseconds before the function times out
---@param speed number - The speed at which the entity should turn
---@return number - The time at which the entity was looked at
function AJFW.Functions.LookAtEntity(entity, timeout, speed)
    local involved = GetInvokingResource()
    if not DoesEntityExist(entity) then turnPromise:reject(involved..' :^1  Entity does not exist')         return turnPromise.value end
    if not type(entity) == 'number' then turnPromise:reject(involved..' :^1  Entity must be a number')     return turnPromise.value end
    if not type(speed) == 'number' then turnPromise:reject(involved..' :^1  Speed must be a number')       return turnPromise.value end
    if speed > 5.0 then speed = 5.0 end
    if timeout > 5000 then timeout = 5000 end

    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)

    local targetPos = GetEntityCoords(entity)
    local dx = targetPos.x - playerPos.x
    local dy = targetPos.y - playerPos.y
    local targetHeading = GetHeadingFromVector_2d(dx, dy)

    local turnSpeed = speed
    local startTimeout = GetGameTimer()
    while true do
        local currentHeading = GetEntityHeading(ped)
        local diff = targetHeading - currentHeading
        if math.abs(diff) < 2 then
            break
        end

        if diff < -180 then
            diff = diff + 360
        elseif diff > 180 then
            diff = diff - 360
        end

        turnSpeed = speed + (2.5 - speed) * (1 - math.abs(diff) / 180)

        if diff > 0 then
            currentHeading = currentHeading + turnSpeed
        else
            currentHeading = currentHeading - turnSpeed
        end
        SetEntityHeading(ped, currentHeading)
        Wait(0)
        if (startTimeout + timeout) < GetGameTimer() then break end
    end
    SetEntityHeading(ped, targetHeading)
end