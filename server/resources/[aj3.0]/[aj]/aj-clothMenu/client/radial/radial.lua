Radial = {}

Radial.MenuID = "open_clothing_menu"

local radialOptionAdded = false

function Radial.IsOX()
    local resName = "ox_lib"
    if GetResourceState(resName) ~= "missing" and Config.UseOxRadial then
        Radial.ResourceName = resName
        return true
    end
    return false
end

function Radial.IsAJ()
    local resName = "aj-radialmenu"
    if GetResourceState(resName) ~= "missing" then
        Radial.ResourceName = resName
        return true
    end
    return false
end

function Radial.IsQBX()
    local resName = "qbx_radialmenu"
    if GetResourceState(resName) ~= "missing" then
        Radial.ResourceName = resName
        return true
    end
    return false
end

function Radial.AddOption(currentZone)
    if not Config.UseRadialMenu then return end

    if not currentZone then
        Radial.Remove()
        return
    end
    local event, title
    local zoneEvents = {
        clothingRoom = {"aj-clothMenu:client:OpenClothingRoom", _L("menu.title")},
        playerOutfitRoom = {"aj-clothMenu:client:OpenPlayerOutfitRoom", _L("menu.outfitsTitle")},
        clothing = {"aj-clothMenu:client:openClothingShopMenu", _L("menu.clothingShopTitle")},
        barber = {"aj-clothMenu:client:OpenBarberShop", _L("menu.barberShopTitle")},
        tattoo = {"aj-clothMenu:client:OpenTattooShop", _L("menu.tattooShopTitle")},
        surgeon = {"aj-clothMenu:client:OpenSurgeonShop", _L("menu.surgeonShopTitle")},
    }
    if zoneEvents[currentZone.name] then
        event, title = table.unpack(zoneEvents[currentZone.name])
    end

    Radial.Add(title, event)
    radialOptionAdded = true
end

function Radial.RemoveOption()
    if radialOptionAdded then
        Radial.Remove()
        radialOptionAdded = false
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if Config.UseOxRadial and GetResourceState("ox_lib") == "started" or GetResourceState("aj-radialmenu") == "started" then
            Radial.RemoveOption()
        end
    end
end)
