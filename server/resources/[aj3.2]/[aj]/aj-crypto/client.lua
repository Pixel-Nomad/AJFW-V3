local AJFW = exports['aj-base']:GetCoreObject()

local doing = false

local function OnHackDone(success, timeremaining)
	if success then
        TriggerEvent('dpemote:custom:animation', {"c"})
        TriggerServerEvent('aj-crypto:hackingCompleted')
        doing = false
	else
        AJFW.Functions.Notify('Dycryption Failed', 'error', 3000)
        doing = false
	end
	TriggerEvent('mhacking:hide')
end

local function minigame()
    TriggerEvent('dpemote:custom:animation', {"phone"})
    TriggerEvent("mhacking:show")
    TriggerEvent("mhacking:start", math.random(4, 7), math.random(10, 15), OnHackDone)
end

RegisterNetEvent('crypto:client:UseCrypto', function()
    if not doing then
        doing = true
        minigame()
    end
end)