local aaaaa = 'Shared/Garbage'


PlayerData      = {}
PlayerJob       = {}
PlayerMeta      = {}
PlayerGang      = {}
PlayerCharinfo  = {}
PlayerMoney     = {}
isDead          = false
isLastStand     = false
isCuffed        = false
MaxPlayers      = 0
TotalPlayers    = 0
showText        = false
showText2       = false
showText3       = false
showText4       = false
showText5       = false
showText6       = false
showText7       = false
showText8       = false
showText9       = false
showText10      = false

GlobalPlayerPedID = nil

CreateThread(function()
    while true do
        GlobalPlayerPedID = PlayerPedId()
        Wait(3000)
    end
end)

CreateThread(function()
    while true do
        AJFW.Functions.TriggerCallback("aj-framework:GetPlayerCount", function(max, current)
            MaxPlayers = max
            TotalPlayers = current
        end)
        Wait(30000)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('Custom:resourceStarter')
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('Custom:resourceStoper')
    end
end)