local AJFW = exports['aj-base']:GetCoreObject()

local WebHook = "https://discord.com/api/webhooks/1256754081574424608/LUaw8hM0f75VAoDxEaYk9jSmU3sG-Zo6aknYV5SwygKzn80jL2gZuKnTbxEiKn3Ymsi2"

AJFW.Functions.CreateUseableItem("camera", function(source, item)
    local src = source
    TriggerClientEvent("aj-camera:client:use-camera", src)
end)

AJFW.Functions.CreateUseableItem("photo", function(source, item)
    local src = source
    if item.info and item.info.photourl then
        TriggerClientEvent("aj-camera:client:use-photo", src, item.info.photourl)
    end
end)

RegisterNetEvent("aj-camera:server:add-photo-item", function(url)
    local src = source
    local ply = AJFW.Functions.GetPlayer(source)
    if ply then
        local info = {
            photourl = url
        }
        ply.Functions.AddItem("photo", 1, nil, info)
        TriggerEvent('inventory:client:ItemBox', AJFW.Shared.Items["photo"], "add")
    end
end)

AJFW.Functions.CreateCallback("aj-camera:server:webhook",function(source,cb)
	if WebHook ~= "" then
		cb(WebHook)
	else
		cb(nil)
	end
end)
