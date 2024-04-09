--- @param animDic string: The name of the animation dictionary
--- @param animName string - The name of the animation within the dictionary
--- @param duration number - The duration of the animation in milliseconds. -1 will play the animation indefinitely
--- @param upperbodyOnly boolean - If true, the animation will only affect the upper body of the ped
--- @return number - The timestamp indicating when the animation concluded. For animations set to loop indefinitely, this will still return the maximum duration of the animation.
function AJFW.Functions.PlayAnim(animDict, animName, upperbodyOnly, duration)
    local invoked = GetInvokingResource()
    local animPromise = promise.new()
    if type(animDict) ~= 'string' or type(animName) ~= 'string' then
        animPromise:reject(invoked .. ' :^1  Wrong type for animDict or animName')
        return animPromise.value
    end
    if not DoesAnimDictExist(animDict) then
        animPromise:reject(invoked .. ' :^1  Animation dictionary does not exist')
        return animPromise.value
    end

    local flags = upperbodyOnly and 16 or 0
    local runTime = duration or -1
    if runTime == -1 then flags = 49 end
    local ped = PlayerPedId()
    local start = GetGameTimer()
    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        if (GetGameTimer() - start) > 5000 then
            animPromise:reject(invoked .. ' :^1  Animation dictionary failed to load')
            return animPromise.value
        end
        Wait(1)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, runTime, flags, 0, true, true, true)
    Wait(10) -- Wait a bit for the animation to start, then check if it exists
    local currentTime = GetAnimDuration(animDict, animName)
    if currentTime == 0 then
        animPromise:reject(invoked .. ' :^1  Animation does not exist')
        return animPromise.value
    end

    local fullDuration = currentTime * 1000
    -- If duration is provided and is less than the full duration, use it instead
    local waitTime = duration and math.min(duration, fullDuration) or fullDuration

    Wait(waitTime)
    RemoveAnimDict(animDict)
    animPromise:resolve(currentTime)
    return animPromise.value
end