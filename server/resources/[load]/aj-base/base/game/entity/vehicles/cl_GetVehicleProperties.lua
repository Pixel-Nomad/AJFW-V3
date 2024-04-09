function AJFW.Functions.GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)

        if GetVehicleXenonLightsCustomColor(vehicle) == 1 then
            local _, r, g, b = GetVehicleXenonLightsCustomColor(vehicle)
            headlightColor = { r, g, b }
        else
            headlightColor = GetVehicleHeadlightsColour(vehicle)
        end
        if GetIsVehiclePrimaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            colorPrimary = { r, g, b, colorPrimary }
        end
        if GetIsVehicleSecondaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
            colorSecondary = { r, g, b, colorSecondary }
        end
        local extras = {}
        for extraId = 0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end
        local modLivery = GetVehicleMod(vehicle, 48)
        if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= 0 then modLivery = GetVehicleLivery(vehicle) end
        local tireHealth = {}
        local tireBurstState = {}
        local tireBurstCompletely = {}
        for _, id in pairs({0, 1, 2, 3, 4, 5, 45, 47}) do
            tireHealth[id] = GetVehicleWheelHealth(vehicle, id, false)
            tireBurstState[id] = IsVehicleTyreBurst(vehicle, id, false)
            tireBurstCompletely[id] = IsVehicleTyreBurst(vehicle, id, true)
        end
        local windowStatus = {}
        for i = 0, 7 do windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1 end
        local doorStatus = {}
        for i = 0, 5 do doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1 end
        return {
            model = GetEntityModel(vehicle),
            plate = AJFW.Functions.GetPlate(vehicle),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth = AJFW.Shared.Round(GetVehicleBodyHealth(vehicle), 0.1),
            engineHealth = AJFW.Shared.Round(GetVehicleEngineHealth(vehicle), 0.1),
            tankHealth = AJFW.Shared.Round(GetVehiclePetrolTankHealth(vehicle), 0.1),
            fuelLevel = AJFW.Shared.Round(GetVehicleFuelLevel(vehicle), 0.1),
            dirtLevel = AJFW.Shared.Round(GetVehicleDirtLevel(vehicle), 0.1),
            oilLevel = AJFW.Shared.Round(GetVehicleOilLevel(vehicle), 0.1),
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheels = GetVehicleWheelType(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheelWidth = GetVehicleWheelWidth(vehicle),
            tireHealth = tireHealth,
            tireBurstState = tireBurstState,
            tireBurstCompletely = tireBurstCompletely,
            windowTint = GetVehicleWindowTint(vehicle),
            windowStatus = windowStatus,
            doorStatus = doorStatus,
            headlightColor = headlightColor,
            neonEnabled = {
                IsVehicleNeonLightEnabled(vehicle, 0),
                IsVehicleNeonLightEnabled(vehicle, 1),
                IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            interiorColor = GetVehicleInteriorColour(vehicle),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modKit17 = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modKit19 = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modKit21 = GetVehicleMod(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modKit47 = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modKit49 = GetVehicleMod(vehicle, 49),
            liveryRoof = GetVehicleRoofLivery(vehicle),
			modDrift = GetDriftTyresEnabled(vehicle),
			modBProofTires = not GetVehicleTyresCanBurst(vehicle),
        }
    else
        return
    end
end