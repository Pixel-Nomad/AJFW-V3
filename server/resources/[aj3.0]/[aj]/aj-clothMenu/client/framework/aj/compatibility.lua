if not Framework.AJFW() then return end

local client = client

-- Backwards Compatible Events

RegisterNetEvent("aj-clothing:client:openMenu", function()
    local config = GetDefaultConfig()
    config.ped = true
    config.headBlend = true
    config.faceFeatures = true
    config.headOverlays = true
    config.components = true
    config.props = true
    config.tattoos = true
    OpenShop(config, true, "all")
end)

RegisterNetEvent("aj-clothing:client:openOutfitMenu", function()
    OpenMenu(nil, "outfit")
end)

RegisterNetEvent("aj-clothing:client:loadOutfit", LoadJobOutfit)

RegisterNetEvent("aj-multicharacter:client:chooseChar", function()
    client.setPedTattoos(cache.ped, {})
    ClearPedDecorations(cache.ped)

    TriggerServerEvent("aj-clothMenu:server:resetOutfitCache")
end)
