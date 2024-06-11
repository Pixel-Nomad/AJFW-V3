AJFW = exports['aj-base']:GetCoreObject()
PlayerData = {}

local function createProperty(property)
	PropertiesTable[property.property_id] = Property:new(property)
end
RegisterNetEvent('aj-housing:client:addProperty', createProperty)

RegisterNetEvent('aj-housing:client:removeProperty', function (property_id)
	local property = Property.Get(property_id)

	if property then
		property:RemoveProperty()
	end

	PropertiesTable[property_id] = nil
end)

function InitialiseProperties(properties)
    Debug("Initialising properties")
    PlayerData = AJFW.Functions.GetPlayerData()

    for k, v in pairs(Config.Apartments) do
        ApartmentsTable[k] = Apartment:new(v)
    end

	if not properties then
    	properties = lib.callback.await('aj-housing:server:requestProperties')
	end
	
    for k, v in pairs(properties) do
        createProperty(v.propertyData)
    end

    TriggerEvent("aj-housing:client:initialisedProperties")

    Debug("Initialised properties")
end
AddEventHandler("AJFW:Client:OnPlayerLoaded", InitialiseProperties)
RegisterNetEvent('aj-housing:client:initialiseProperties', InitialiseProperties)

AddEventHandler("onResourceStart", function(resourceName) -- Used for when the resource is restarted while in game
	if (GetCurrentResourceName() == resourceName) then
        InitialiseProperties()
	end
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('aj-housing:client:setupSpawnUI', function(cData)
    DoScreenFadeOut(1000)
    local result = lib.callback.await('aj-housing:cb:GetOwnedApartment', source, cData.citizenid)
    if result then
        TriggerEvent('aj-spawn:client:setupSpawns', cData, false, nil)
        TriggerEvent('aj-spawn:client:openUI', true)
        -- TriggerEvent("apartments:client:SetHomeBlip", result.type)
    else
        if Config.StartingApartment then
            TriggerEvent('aj-spawn:client:setupSpawns', cData, true, Config.Apartments)
            TriggerEvent('aj-spawn:client:openUI', true)
        else
            TriggerEvent('aj-spawn:client:setupSpawns', cData, false, nil)
            TriggerEvent('aj-spawn:client:openUI', true)
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		if Modeler.IsMenuActive then
			Modeler:CloseMenu()
		end

		for k, v in pairs(PropertiesTable) do
			v:RemoveProperty()
		end

        for k, v in pairs(ApartmentsTable) do
            v:RemoveApartment()
        end
	end
end)

exports('GetProperties', function()
    return PropertiesTable
end)

exports('GetProperty', function(property_id)
    return Property.Get(property_id)
end)

exports('GetApartments', function()
    return ApartmentsTable
end)

exports('GetApartment', function(apartment)
    return Apartment.Get(apartment)
end)

exports('GetShells', function()
    return Config.Shells
end)


lib.callback.register('aj-housing:cb:confirmPurchase', function(amount, street, id)
    return lib.alertDialog({
        header = 'Purchase Confirmation',
        content = 'Are you sure you want to purchase '..street..' ' .. id .. ' for $' .. amount .. '?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Purchase",
            cancel = "Cancel"
        }
    })
end)

lib.callback.register('aj-housing:cb:confirmRaid', function(street, id)
    return lib.alertDialog({
        header = 'Raid',
        content = 'Do you want to raid '..street..' ' .. id .. '?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Raid",
            cancel = "Cancel"
        }
    })
end)

lib.callback.register('aj-housing:cb:ringDoorbell', function()
    return lib.alertDialog({
        header = 'Ring Doorbell',
        content = 'You dont have a key for this property, would you like to ring the doorbell?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Ring",
            cancel = "Cancel"
        }
    })
end)

lib.callback.register('aj-housing:cb:showcase', function()
    return lib.alertDialog({
        header = 'Showcase Property',
        content = 'Do you want to showcase this property?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Yes",
            cancel = "Cancel"
        }
    })
end)
