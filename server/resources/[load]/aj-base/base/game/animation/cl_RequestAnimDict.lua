function AJFW.Functions.RequestAnimDict(animDict)
    if HasAnimDictLoaded(animDict) then return end
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
end