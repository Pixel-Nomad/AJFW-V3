--#region Variables

local AJFW = exports['aj-base']:GetCoreObject()
local PlayerData = AJFW.Functions.GetPlayerData()
local inInventory = false
local currentWeapon = nil
local currentOtherInventory = nil
local Drops = {}
local CurrentDrop = nil
local DropsNear = {}
local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false
local isHotbar = false

--#endregion Variables

--#region Functions

---Checks if you have an item or not
---@param items string | string[] | table<string, number> The items to check, either a string, array of strings or a key-value table of a string and number with the string representing the name of the item and the number representing the amount
---@param amount? number The amount of the item to check for, this will only have effect when items is a string or an array of strings
---@return boolean success Returns true if the player has the item
local function HasItem(items, amount)
    local isTable = type(items) == 'table'
    local isArray = isTable and table.type(items) == 'array' or false
    local totalItems = #items
    local count = 0
    local kvIndex = 2
	if isTable and not isArray then
        totalItems = 0
        for _ in pairs(items) do totalItems += 1 end
        kvIndex = 1
    end
    for _, itemData in pairs(PlayerData.items) do
        if isTable then
            for k, v in pairs(items) do
                local itemKV = {k, v}
                if itemData and itemData.name == itemKV[kvIndex] and ((amount and itemData.amount >= amount) or (not isArray and itemData.amount >= v) or (not amount and isArray)) then
                    count += 1
                end
            end
            if count == totalItems then
                return true
            end
        else -- Single item as string
            if itemData and itemData.name == items and (not amount or (itemData and amount and itemData.amount >= amount)) then
                return true
            end
        end
    end
    return false
end

exports("HasItem", HasItem)

---Gets the closest vending machine object to the client
---@return integer closestVendingMachine
local function GetClosestVending()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.VendingObjects) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, joaat(machine), false, false, false)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

---Opens the vending machine shop
local function OpenVending()
    local ShopItems = {}
    ShopItems.label = "Vending Machine"
    ShopItems.items = Config.VendingItem
    ShopItems.slots = #Config.VendingItem
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
end

---Draws 3d text in the world on the given position
---@param x number The x coord of the text to draw
---@param y number The y coord of the text to draw
---@param z number The z coord of the text to draw
---@param text string The text to display
local function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

---Load an animation dictionary before playing an animation from it
---@param dict string Animation dictionary to load
local function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

---Returns a formatted attachments table from item data
---@param itemdata table Data of an item
---@return table attachments
local function FormatWeaponAttachments(itemdata)
    if not itemdata.info or not itemdata.info.attachments or #itemdata.info.attachments == 0 then
        return {}
    end
    local attachments = {}
    local weaponName = itemdata.name
    local WeaponAttachments = exports['aj-weapons']:getConfigWeaponAttachments()
    for attachmentType, weapons in pairs(WeaponAttachments) do
        local componentHash = weapons[weaponName]
        if componentHash then
            for _, attachmentData in pairs(itemdata.info.attachments) do
                if attachmentData.component == componentHash then
                    local label = AJFW.Shared.Items[attachmentType] and AJFW.Shared.Items[attachmentType].label or 'Unknown'
                    attachments[#attachments + 1] = {
                        attachment = attachmentType,
                        label = label
                    }
                end
            end
        end
    end
    return attachments
end

---Checks if the vehicle's engine is at the back or not
---@param vehModel integer The model hash of the vehicle
---@return boolean isBackEngine
local function IsBackEngine(vehModel)
    return BackEngineVehicles[vehModel]
end

---Opens the trunk of the closest vehicle
local function OpenTrunk()
    local vehicle = AJFW.Functions.GetClosestVehicle()
    LoadAnimDict("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if IsBackEngine(GetEntityModel(vehicle)) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

---Closes the trunk of the closest vehicle
local function CloseTrunk()
    local vehicle = AJFW.Functions.GetClosestVehicle()
    LoadAnimDict("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if IsBackEngine(GetEntityModel(vehicle)) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

local ClosedForcefully = false

---Closes the inventory NUI
local function closeInventory(bool)
    if bool and not ClosedForcefully then
        ClosedForcefully = true
        SetTimeout(2000, function()
            ClosedForcefully = false
        end)
    end
    SendNUIMessage({
        action = "close",
    })
end

---Toggles the hotbar of the inventory
---@param toggle boolean If this is true, the hotbar will open
local function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = PlayerData.items[1],
        [2] = PlayerData.items[2],
        [3] = PlayerData.items[3],
        [4] = PlayerData.items[4],
        [5] = PlayerData.items[5],
        [41] = PlayerData.items[41],
    }

    SendNUIMessage({
        action = "toggleHotbar",
        open = toggle,
        items = HotbarItems
    })
end

---Plays the opening animation of the inventory
local function openAnim()
    LoadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
end

---Setup item info for items from Config.CraftingItems
local function ItemsToItemInfo()
	local itemInfos = {
		[1] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 22x, " ..AJFW.Shared.Items["plastic"]["label"] .. ": 32x."},
		[2] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..AJFW.Shared.Items["plastic"]["label"] .. ": 42x."},
		[3] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..AJFW.Shared.Items["plastic"]["label"] .. ": 45x, "..AJFW.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[4] = {costs = AJFW.Shared.Items["electronickit"]["label"] .. ": 2x, " ..AJFW.Shared.Items["plastic"]["label"] .. ": 52x, "..AJFW.Shared.Items["steel"]["label"] .. ": 40x."},
		[5] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 10x, " ..AJFW.Shared.Items["plastic"]["label"] .. ": 50x, "..AJFW.Shared.Items["aluminum"]["label"] .. ": 30x, "..AJFW.Shared.Items["iron"]["label"] .. ": 17x, "..AJFW.Shared.Items["electronickit"]["label"] .. ": 1x."},
		[6] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..AJFW.Shared.Items["steel"]["label"] .. ": 24x, "..AJFW.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[7] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 32x, " ..AJFW.Shared.Items["steel"]["label"] .. ": 43x, "..AJFW.Shared.Items["plastic"]["label"] .. ": 61x."},
		[8] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..AJFW.Shared.Items["steel"]["label"] .. ": 37x, "..AJFW.Shared.Items["copper"]["label"] .. ": 26x."},
		[9] = {costs = AJFW.Shared.Items["iron"]["label"] .. ": 60x, " ..AJFW.Shared.Items["glass"]["label"] .. ": 30x."},
		[10] = {costs = AJFW.Shared.Items["aluminum"]["label"] .. ": 60x, " ..AJFW.Shared.Items["glass"]["label"] .. ": 30x."},
		[11] = {costs = AJFW.Shared.Items["iron"]["label"] .. ": 33x, " ..AJFW.Shared.Items["steel"]["label"] .. ": 44x, "..AJFW.Shared.Items["plastic"]["label"] .. ": 55x, "..AJFW.Shared.Items["aluminum"]["label"] .. ": 22x."},
		[12] = {costs = AJFW.Shared.Items["iron"]["label"] .. ": 50x, " ..AJFW.Shared.Items["steel"]["label"] .. ": 50x, "..AJFW.Shared.Items["screwdriverset"]["label"] .. ": 3x, "..AJFW.Shared.Items["advancedlockpick"]["label"] .. ": 2x."},
	}

	local items = {}
	for _, item in pairs(Config.CraftingItems) do
		local itemInfo = AJFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end

---Setup item info for items from Config.AttachmentCrafting["items"]
local function SetupAttachmentItemsInfo()
	local itemInfos = {
		[1] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 140x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 250x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 60x"},
		[2] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 165x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 285x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 75x"},
		[3] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 190x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 305x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 85x, " .. AJFW.Shared.Items["smg_extendedclip"]["label"] .. ": 1x"},
		[4] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 205x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 340x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 110x, " .. AJFW.Shared.Items["smg_extendedclip"]["label"] .. ": 2x"},
		[5] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 230x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 365x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 130x"},
		[6] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 255x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 390x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 145x"},
		[7] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 270x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 435x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 155x"},
		[8] = {costs = AJFW.Shared.Items["metalscrap"]["label"] .. ": 300x, " .. AJFW.Shared.Items["steel"]["label"] .. ": 469x, " .. AJFW.Shared.Items["rubber"]["label"] .. ": 170x"},
	}

	local items = {}
	for _, item in pairs(Config.AttachmentCrafting["items"]) do
		local itemInfo = AJFW.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.AttachmentCrafting["items"] = items
end

---Runs ItemsToItemInfo() and checks if the client has enough reputation to support the threshold, otherwise the items is not available to craft for the client
---@return table items
local function GetThresholdItems()
	ItemsToItemInfo()
	local items = {}
	for k in pairs(Config.CraftingItems) do
		if PlayerData.metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

---Runs SetupAttachmentItemsInfo() and checks if the client has enough reputation to support the threshold, otherwise the items is not available to craft for the client
---@return table items
local function GetAttachmentThresholdItems()
	SetupAttachmentItemsInfo()
	local items = {}
	for k in pairs(Config.AttachmentCrafting["items"]) do
		if PlayerData.metadata["attachmentcraftingrep"] >= Config.AttachmentCrafting["items"][k].threshold then
			items[k] = Config.AttachmentCrafting["items"][k]
		end
	end
	return items
end

---Removes drops in the area of the client
---@param index integer The drop id to remove
local function RemoveNearbyDrop(index)
    if not DropsNear[index] then return end

    local dropItem = DropsNear[index].object
    if DoesEntityExist(dropItem) then
        DeleteEntity(dropItem)
    end

    DropsNear[index] = nil

    if not Drops[index] then return end

    Drops[index].object = nil
    Drops[index].isDropShowing = nil
end

---Removes all drops in the area of the client
local function RemoveAllNearbyDrops()
    for k in pairs(DropsNear) do
        RemoveNearbyDrop(k)
    end
end

---Creates a new item drop object on the ground
---@param index integer The drop id to save the object in
local function CreateItemDrop(index)
    local dropItem = CreateObject(Config.ItemDropObject, DropsNear[index].coords.x, DropsNear[index].coords.y, DropsNear[index].coords.z, false, false, false)
    DropsNear[index].object = dropItem
    DropsNear[index].isDropShowing = true
    PlaceObjectOnGroundProperly(dropItem)
    FreezeEntityPosition(dropItem, true)
	if Config.UseTarget then
		exports['aj-target']:AddTargetEntity(dropItem, {
			options = {
				{
					icon = 'fas fa-backpack',
					label = Lang:t("menu.o_bag"),
					action = function()
						TriggerServerEvent("inventory:server:OpenInventory", "drop", index)
					end,
				}
			},
			distance = 2.5,
		})
	end
end

--#endregion Functions

--#region Events

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set("inv_busy", false, true)
    PlayerData = AJFW.Functions.GetPlayerData()
    AJFW.Functions.TriggerCallback("inventory:server:GetCurrentDrops", function(theDrops)
		Drops = theDrops
    end)
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    LocalPlayer.state:set("inv_busy", true, true)
    PlayerData = {}
    RemoveAllNearbyDrops()
end)

RegisterNetEvent('AJFW:Client:UpdateObject', function()
    AJFW = exports['aj-base']:GetCoreObject()
end)

RegisterNetEvent('AJFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)

AddEventHandler('onResourceStop', function(name)
    if name ~= GetCurrentResourceName() then return end
    if Config.UseItemDrop then RemoveAllNearbyDrops() end
end)

RegisterNetEvent("aj-inventory:client:closeinv", function()
    closeInventory(true)
end)

RegisterNetEvent('inventory:client:CheckOpenState', function(type, id, label)
    local name = AJFW.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "drop" then
        if name ~= CurrentDrop or CurrentDrop == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k in pairs(items) do
            itemTable[#itemTable+1] = {
                item = items[k].name,
                label = AJFW.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            }
        end
    end

    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNetEvent('inventory:client:OpenInventory', function(PlayerAmmo, inventory, other)
    if not IsEntityDead(PlayerPedId()) then
        ToggleHotbar(false)
        SetNuiFocus(true, true)
        if other then
            currentOtherInventory = other.name
        end
        AJFW.Functions.TriggerCallback('inventory:server:ConvertQuality', function(data)
            inventory = data.inventory
            other = data.other
            SendNUIMessage({
                action = "open",
                inventory = inventory,
                slots = Config.MaxInventorySlots,
                other = other,
                PlayerName = PlayerData.charinfo.firstname.." "..PlayerData.charinfo.lastname,
                CitizenID  = PlayerData.citizenid,
                ServerID   = PlayerData.source,
                maxweight = Config.MaxInventoryWeight,
                Ammo = PlayerAmmo,
                maxammo = Config.MaximumAmmoValues,
            })
            inInventory = true
        end,inventory,other)
    end
end)

RegisterNetEvent('inventory:client:UpdateOtherInventory', function(items, isError)
    SendNUIMessage({
        action = "update",
        inventory = items,
        maxweight = Config.MaxInventoryWeight,
        slots = Config.MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent('inventory:client:UpdateOtherInventory2', function(items)
    print('On:OtherInventoryUpdate')
    SendNUIMessage({
        action = "updateother",
        inventory = items,
    })
end)

RegisterNetEvent('inventory:client:UpdatePlayerInventory', function(isError, itemsData)
    print('On:PlayerInventoryUpdate')
    if itemsData then
        SendNUIMessage({
            action = "update",
            inventory = itemsData,
            maxweight = Config.MaxInventoryWeight,
            slots = Config.MaxInventorySlots,
            error = isError,
            forced = true
        })
    else
        SendNUIMessage({
            action = "update",
            inventory = PlayerData.items,
            maxweight = Config.MaxInventoryWeight,
            slots = Config.MaxInventorySlots,
            error = isError,
        })
    end
end)

RegisterNetEvent('inventory:client:UpdatePlayerInventory', function(isError)
    SendNUIMessage({
        action = "update",
        inventory = PlayerData.items,
        maxweight = Config.MaxInventoryWeight,
        slots = Config.MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent('inventory:client:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    AJFW.Functions.Progressbar("repair_vehicle", Lang:t("progress.crafting"), (math.random(2000, 5000) * amount), false, true, {
	    disableMovement = true,
	    disableCarMovement = true,
	    disableMouse = false,
	    disableCombat = true,
	}, {
	    animDict = "mini@repair",
	    anim = "fixing_a_player",
	    flags = 16,
	}, {}, {}, function() -- Done
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
            TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
            TriggerEvent('inventory:client:ItemBox', AJFW.Shared.Items[itemName], 'add')
            isCrafting = false
	end, function() -- Cancel
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
            AJFW.Functions.Notify(Lang:t("notify.failed"), "error")
            isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    AJFW.Functions.Progressbar("repair_vehicle", Lang:t("progress.crafting"), (math.random(2000, 5000) * amount), false, true, {
	    disableMovement = true,
	    disableCarMovement = true,
	    disableMouse = false,
	    disableCombat = true,
	}, {
	    animDict = "mini@repair",
	    anim = "fixing_a_player",
	    flags = 16,
	}, {}, {}, function() -- Done
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
            TriggerServerEvent("inventory:server:CraftAttachment", itemName, itemCosts, amount, toSlot, points)
            TriggerEvent('inventory:client:ItemBox', AJFW.Shared.Items[itemName], 'add')
            isCrafting = false
	end, function() -- Cancel
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
            AJFW.Functions.Notify(Lang:t("notify.failed"), "error")
            isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:PickupSnowballs', function()
    local ped = PlayerPedId()
    LoadAnimDict('anim@mp_snowball')
    TaskPlayAnim(ped, 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    AJFW.Functions.Progressbar("pickupsnowball", Lang:t("progress.snowballs"), 1500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
	TriggerServerEvent('inventory:server:snowball', 'add')
        TriggerEvent('inventory:client:ItemBox', AJFW.Shared.Items["snowball"], "add")
    end, function() -- Cancel
        ClearPedTasks(ped)
        AJFW.Functions.Notify(Lang:t("notify.canceled"), "error")
    end)
end)

RegisterNetEvent('inventory:client:UseWeapon', function(weaponData, shootbool)
    local ped = PlayerPedId()
    local weaponName = tostring(weaponData.name)
    local weaponHash = joaat(weaponData.name)
    if currentWeapon == weaponName then
        TriggerEvent('weapons:client:DrawWeapon', nil)
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(ped, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" or weaponName == "weapon_pipebomb" or weaponName == "weapon_smokegrenade" or weaponName == "weapon_flare" or weaponName == "weapon_proxmine" or weaponName == "weapon_ball"  or weaponName == "weapon_molotov" or weaponName == "weapon_grenade" or weaponName == "weapon_bzgas" then
        TriggerEvent('weapons:client:DrawWeapon', weaponName)
        GiveWeaponToPed(ped, weaponHash, 1, false, false)
        SetPedAmmo(ped, weaponHash, 1)
        SetCurrentPedWeapon(ped, weaponHash, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        TriggerEvent('weapons:client:DrawWeapon', weaponName)
        GiveWeaponToPed(ped, weaponHash, 10, false, false)
        SetPedAmmo(ped, weaponHash, 10)
        SetCurrentPedWeapon(ped, weaponHash, true)
        TriggerServerEvent('inventory:server:snowball', 'remove')
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:DrawWeapon', weaponName)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        local ammo = tonumber(weaponData.info.ammo) or 0

        if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then
            ammo = 4000
        end

        GiveWeaponToPed(ped, weaponHash, ammo, false, false)
        SetPedAmmo(ped, weaponHash, ammo)
        SetCurrentPedWeapon(ped, weaponHash, true)

        if weaponData.info.attachments then
            for _, attachment in pairs(weaponData.info.attachments) do
                GiveWeaponComponentToPed(ped, weaponHash, joaat(attachment.component))
            end
        end

        if weaponData.info.tint then
            SetPedWeaponTintIndex(ped, weaponHash, weaponData.info.tint)
        end

        currentWeapon = weaponName
    end
end)

RegisterNetEvent('inventory:client:CheckWeapon', function(weaponName)
    if currentWeapon ~= weaponName:lower() then return end
    local ped = PlayerPedId()
    TriggerEvent('weapons:ResetHolster')
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    RemoveAllPedWeapons(ped, true)
    currentWeapon = nil
end)

-- This needs to be changed to do a raycast so items arent placed in walls
RegisterNetEvent('inventory:client:AddDropItem', function(dropId, player, coords)
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
    local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('inventory:client:RemoveDropItem', function(dropId)
    Drops[dropId] = nil
    if Config.UseItemDrop then
        RemoveNearbyDrop(dropId)
    else
        DropsNear[dropId] = nil
    end
end)

RegisterNetEvent('inventory:client:DropItemAnim', function()
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    LoadAnimDict("pickup_object")
    TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
end)

RegisterNetEvent('inventory:client:SetCurrentStash', function(stash)
    CurrentStash = stash
end)

RegisterNetEvent('aj-inventory:client:giveAnim', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        return
    else
        LoadAnimDict('mp_common')
        TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_b', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    end
end)

RegisterNetEvent('inventory:client:craftTarget',function()
    local crafting = {}
    crafting.label = Lang:t("label.craft")
    crafting.items = GetThresholdItems()
    TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
end)

--#endregion Events

--#region Commands

RegisterCommand('closeinv', function()
    closeInventory()
end, false)

RegisterCommand('inventory', function()
    if IsNuiFocused() then return end
    if not isCrafting and not inInventory and not LocalPlayer.state.inv_busy and not ClosedForcefully then
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
            local ped = PlayerPedId()
            local curVeh = nil
            local VendingMachine = nil
            if not Config.UseTarget then VendingMachine = GetClosestVending() end

            if IsPedInAnyVehicle(ped, false) then -- Is Player In Vehicle
                local vehicle = GetVehiclePedIsIn(ped, false)
                CurrentGlovebox = AJFW.Functions.GetPlate(vehicle)
                curVeh = vehicle
                CurrentVehicle = nil
            else
                local vehicle = AJFW.Functions.GetClosestVehicle()
                if vehicle ~= 0 and vehicle ~= nil then
                    local pos = GetEntityCoords(ped)
                    local dimensionMin, dimensionMax = GetModelDimensions(GetEntityModel(vehicle))
		    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMin.y), 0.0)
                    if (IsBackEngine(GetEntityModel(vehicle))) then
                        trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMax.y), 0.0)
                    end
                    if #(pos - trunkpos) < 1.5 and not IsPedInAnyVehicle(ped) then
                        if GetVehicleDoorLockStatus(vehicle) < 2 then
                            CurrentVehicle = AJFW.Functions.GetPlate(vehicle)
                            curVeh = vehicle
                            CurrentGlovebox = nil
                        else
                            AJFW.Functions.Notify(Lang:t("notify.vlocked"), "error")
                            return
                        end
                    else
                        CurrentVehicle = nil
                    end
                else
                    CurrentVehicle = nil
                end
            end

            if CurrentVehicle then -- Trunk
                local vehicleClass = GetVehicleClass(curVeh)
                local maxweight
                local slots
                local model = GetEntityModel(curVeh)
                local vehname = GetDisplayNameFromVehicleModel(model):lower()
                if AJFW.Shared.Vehicles[vehname] then
                    if AJFW.Shared.Vehicles[vehname]['weight'] then
                        if AJFW.Shared.Vehicles[vehname]['slot'] then
                            maxweight = AJFW.Shared.Vehicles[vehname]['weight']
                            slots = AJFW.Shared.Vehicles[vehname]['slot']
                        else
                            AJFW.Functions.Notify('Hmm. this is wierd contact developer and give them this vehicle name | '..vehname, 'error')
                        end
                    else
                        AJFW.Functions.Notify('Hmm. this is wierd contact developer and give them this vehicle name | '..vehname, 'error')
                    end
                else
                    if vehicleClass == 0 then
                        maxweight = 800000
                        slots = 80
                    elseif vehicleClass == 1 then
                        maxweight = 800000
                        slots = 100
                    elseif vehicleClass == 2 then
                        maxweight = 800000
                        slots = 90
                    elseif vehicleClass == 3 then
                        maxweight = 600000
                        slots = 70
                    elseif vehicleClass == 4 then
                        maxweight = 500000
                        slots = 80
                    elseif vehicleClass == 5 then
                        maxweight = 500000
                        slots = 70
                    elseif vehicleClass == 6 then
                        maxweight = 600000
                        slots = 70
                    elseif vehicleClass == 7 then
                        maxweight = 400000
                        slots = 60
                    elseif vehicleClass == 8 then
                        maxweight = 100000
                        slots = 10
                    elseif vehicleClass == 9 then
                        maxweight = 600000
                        slots = 50
                    elseif vehicleClass == 12 then
                        maxweight = 1600000
                        slots = 100
                    elseif vehicleClass == 13 then
                        maxweight = 0
                        slots = 0
                    elseif vehicleClass == 14 then
                        maxweight = 300000
                        slots = 50
                    elseif vehicleClass == 15 then
                        maxweight = 300000
                        slots = 50
                    elseif vehicleClass == 16 then
                        maxweight = 300000
                        slots = 50
                    else
                        maxweight = 60000
                        slots = 35
                    end
                end
                local other = {
                    maxweight = maxweight,
                    slots = slots,
                }
                TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                OpenTrunk()
            elseif CurrentGlovebox then
                TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
            elseif CurrentDrop ~= 0 then
                TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
            elseif VendingMachine then
                local ShopItems = {}
                ShopItems.label = "Vending Machine"
                ShopItems.items = Config.VendingItem
                ShopItems.slots = #Config.VendingItem
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
            else
                openAnim()
                TriggerServerEvent("inventory:server:OpenInventory")
            end
        end
    end
end, false)

RegisterKeyMapping('inventory', Lang:t("inf_mapping.opn_inv"), 'keyboard', 'TAB')

RegisterCommand('hotbar', function()
    isHotbar = not isHotbar
    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() and not LocalPlayer.state.inv_busy then
        ToggleHotbar(isHotbar)
    end
end, false)

RegisterKeyMapping('hotbar', Lang:t("inf_mapping.tog_slots"), 'keyboard', 'z')

for i = 1, 6 do
    RegisterCommand('slot' .. i,function()
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() and not LocalPlayer.state.inv_busy then
            if i == 6 then
                i = Config.MaxInventorySlots
            end
            TriggerServerEvent("inventory:server:UseItemSlot", i)
        end
    end, false)
    RegisterKeyMapping('slot' .. i, Lang:t("inf_mapping.use_item") .. i, 'keyboard', i)
end

--#endregion Commands

--#region NUI

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
    cb('ok')
end)

RegisterNUICallback('Notify', function(data, cb)
    AJFW.Functions.Notify(data.message, data.type)
    cb('ok')
end)

RegisterNUICallback('GetWeaponData', function(cData, cb)
    local data = {
        WeaponData = AJFW.Shared.Items[cData.weapon],
        AttachmentData = FormatWeaponAttachments(cData.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local ped = PlayerPedId()
    local WeaponData = data.WeaponData
    local allAttachments = exports['aj-weapons']:getConfigWeaponAttachments()
    local Attachment = allAttachments[data.AttachmentData.attachment][WeaponData.name]

    AJFW.Functions.TriggerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(ped, joaat(WeaponData.name), joaat(Attachment))

            for _, v in pairs(NewAttachments) do
                for attachmentType, weapons in pairs(allAttachments) do
                    local componentHash = weapons[WeaponData.name]
                    if componentHash and v.component == componentHash then
                        local label = AJFW.Shared.Items[attachmentType] and AJFW.Shared.Items[attachmentType].label or 'Unknown'
                        Attachies[#Attachies+1] = {
                            attachment = attachmentType,
                            label = label,
                        }
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(ped, joaat(WeaponData.name), joaat(Attachment))
            cb({})
        end
    end, data.AttachmentData, WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(AJFW.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(_, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = nil
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = nil
    end
    SetNuiFocus(false, false)
    inInventory = false
    cb('ok')
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
    cb('ok')
end)

RegisterNUICallback("combineItem", function(data, cb)
    Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
    cb('ok')
end)

RegisterNUICallback('combineWithAnim', function(data, cb)
    local ped = PlayerPedId()
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut
    AJFW.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
    end, function() -- Cancel
        StopAnimTask(ped, aDict, aLib, 1.0)
        AJFW.Functions.Notify(Lang:t("notify.failed"), "error")
    end)
    cb('ok')
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    if data.toInventory == '0' then if exports['aj-apartments']:InAppartment() then AJFW.Functions.Notify("Not Possible to Drop item in apartments", "error", 7500)  cb('ok') return end end
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
    cb('ok')
end)

RegisterNUICallback("PlayDropSound", function(_, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    cb('ok')
end)

RegisterNUICallback("PlayDropFail", function(_, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    cb('ok')
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local player, distance = AJFW.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
    if player ~= -1 and distance < 3 then
        if data.inventory == 'player' then
            local playerId = GetPlayerServerId(player)
            SetCurrentPedWeapon(PlayerPedId(),'WEAPON_UNARMED',true)
            TriggerServerEvent("inventory:server:GiveItem", playerId, data.item.name, data.amount, data.item.slot)
        else
            AJFW.Functions.Notify(Lang:t("notify.notowned"), "error")
        end
    else
        AJFW.Functions.Notify(Lang:t("notify.nonb"), "error")
    end
    cb('ok')
end)

--#endregion NUI

--#region Threads

CreateThread(function()
    while true do
        local sleep = 100
        if DropsNear ~= nil then
			local ped = PlayerPedId()
			local closestDrop = nil
			local closestDistance = nil
            for k, v in pairs(DropsNear) do

                if DropsNear[k] ~= nil then
                    if Config.UseItemDrop then
                        if not v.isDropShowing then
                            CreateItemDrop(k)
                        end
                    else
                        sleep = 5
                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 114, 137, 218, 155, false, false, false, 1, false, false, false)
                    end

					local coords = (v.object ~= nil and GetEntityCoords(v.object)) or vector3(v.coords.x, v.coords.y, v.coords.z)
					local distance = #(GetEntityCoords(ped) - coords)
					if distance < 1 and (not closestDistance or distance < closestDistance) then
						closestDrop = k
						closestDistance = distance
					end
                end
            end


			if not closestDrop then
				CurrentDrop = 0
			else
				CurrentDrop = closestDrop
			end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < Config.MaxDropViewDistance then
                        DropsNear[k] = v
                    else
                        if Config.UseItemDrop and DropsNear[k] then
                            RemoveNearbyDrop(k)
                        else
                            DropsNear[k] = nil
                        end
                    end
                end
            end
        else
            DropsNear = {}
        end
        Wait(500)
    end
end)

CreateThread(function()
    if Config.UseTarget then
        exports['aj-target']:AddTargetModel(Config.VendingObjects, {
            options = {
                {
                    icon = "fa-solid fa-cash-register",
                    label = Lang:t("menu.vending"),
                    action = function()
                        OpenVending()
                    end
                },
            },
            distance = 2.5
        })
    end
end)

-- CreateThread(function()
--     if Config.UseTarget then
--         exports['aj-target']:AddTargetModel(Config.CraftingObject, {
--             options = {
--                 {
--                     event = "inventory:client:craftTarget",
--                     icon = "fas fa-tools",
--                     label = Lang:t("menu.craft"),
--                 },
--             },
--             distance = 2.5,
--         })
--     else
--         while true do
--             local sleep = 1000
--             if LocalPlayer.state['isLoggedIn'] then
--                 local pos = GetEntityCoords(PlayerPedId())
--                 local craftObject = GetClosestObjectOfType(pos, 2.0, Config.CraftingObject, false, false, false)
--                 if craftObject ~= 0 then
--                     local objectPos = GetEntityCoords(craftObject)
--                     if #(pos - objectPos) < 1.5 then
--                         sleep = 5
--                         DrawText3Ds(objectPos.x, objectPos.y, objectPos.z + 1.0, Lang:t("interaction.craft"))
--                         if IsControlJustReleased(0, 38) then
--                             local crafting = {}
--                             crafting.label = Lang:t("label.craft")
--                             crafting.items = GetThresholdItems()
--                             TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
--                             sleep = 100
--                         end
--                     end
--                 end
--             end
--             Wait(sleep)
--         end
--     end
-- end)

-- CreateThread(function()
--     while true do
--         local sleep = 1000
--         if LocalPlayer.state['isLoggedIn'] then
--             local pos = GetEntityCoords(PlayerPedId())
--             local distance = #(pos - Config.AttachmentCraftingLocation)
--             if distance < 10 then
--                 if distance < 1.5 then
--                     sleep = 5
--                     DrawText3Ds(Config.AttachmentCraftingLocation.x, Config.AttachmentCraftingLocation.y, Config.AttachmentCraftingLocation.z, Lang:t("interaction.craft"))
--                     if IsControlJustPressed(0, 38) then
--                         local crafting = {}
--                         crafting.label = Lang:t("label.a_craft")
--                         crafting.items = GetAttachmentThresholdItems()
--                         TriggerServerEvent("inventory:server:OpenInventory", "attachment_crafting", math.random(1, 99), crafting)
--                         sleep = 100
--                     end
--                 end
--             end
--         end
--         Wait(sleep)
--     end
-- end)

-- --#endregion Threads
