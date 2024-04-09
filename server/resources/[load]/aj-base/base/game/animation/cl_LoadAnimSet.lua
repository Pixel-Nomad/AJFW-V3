function AJFW.Functions.LoadAnimSet(animSet)
    if HasAnimSetLoaded(animSet) then return end
    RequestAnimSet(animSet)
    while not HasAnimSetLoaded(animSet) do
        Wait(0)
    end
end