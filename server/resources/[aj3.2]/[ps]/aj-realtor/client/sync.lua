local AJHousing = exports['aj-housing']

function InitialiseData()
	-- Get properties
	local properties = AJHousing:GetProperties()

	PropertiesTable = {}
	for _, property in pairs(properties) do
		PropertiesTable[#PropertiesTable+1] = property.propertyData
	end

	local apartments = AJHousing:GetApartments()

	local ApartmentsTable = {}

	for _, apartment in pairs(apartments) do
		ApartmentsTable[#ApartmentsTable+1] = apartment
	end

	SendNUIMessage({
		action = "setShells",
		data = exports['aj-housing']:GetShells()
	})

	SendNUIMessage({
		action = "setProperties",
		data = PropertiesTable
	})

	SendNUIMessage({
		action = "setApartments",
		data = ApartmentsTable
	})
end

AddEventHandler('aj-housing:client:initialisedProperties', function()
	InitialiseData()
end)

AddEventHandler('aj-housing:client:updatedProperty', function(property_id)
	local property = exports['aj-housing']:GetProperty(property_id)

	for i = 1, #PropertiesTable do
		if PropertiesTable[i].property_id == property_id then
			PropertiesTable[i] = property.propertyData
			break
		end
	end

	SendNUIMessage({
		action = "updateProperty",
		data = property.propertyData
	})
end)

--old is the old player apartment location, new is the new location
-- both have to be updated
AddEventHandler("aj-housing:client:updateApartment", function(old, new)

	local oldApt = AJHousing:GetApartment(old)

	SendNUIMessage({
		action = "updateApartment",
		data = oldApt
	})

	local newApt = AJHousing:GetApartment(new)

	SendNUIMessage({
		action = "updateApartment",
		data = newApt
	})
end)

RegisterNetEvent('aj-housing:client:addProperty', function(propertyData)
	PropertiesTable[#PropertiesTable+1] = propertyData

	SendNUIMessage({
		action = "updateProperty", -- if it cant find the property it will add it
		data = propertyData
	})
end)