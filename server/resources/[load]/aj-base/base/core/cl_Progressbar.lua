function AJFW.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel, icon)
    if GetResourceState('progressbar') ~= 'started' then error('progressbar needs to be started in order for AJFW.Functions.Progressbar to work') end
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        icon = icon,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end
    end)
end