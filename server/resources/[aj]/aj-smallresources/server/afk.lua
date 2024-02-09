local AJFW = exports['aj-base']:GetCoreObject()

RegisterNetEvent('KickForAFK', function()
	DropPlayer(source, Lang:t("afk.kick_message"))
end)

AJFW.Functions.CreateCallback('aj-afkkick:server:GetPermissions', function(source, cb)
    cb(AJFW.Functions.GetPermission(source))
end)
