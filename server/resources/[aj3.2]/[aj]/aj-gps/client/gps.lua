local AJFW = exports['aj-base']:GetCoreObject()
local Menu
local Options

local function open(value)
    exports['aj-menu']:openMenu(value)
end

RegisterNetEvent('aj-gps:OpenMenu', function()
    Menu = {
        {
            isMenuHeader = true,
            header = 'GPS'
        },
    }
    for i = 1 , #Config.Locations do
        Menu[#Menu + 1] = {
            header = Config.Locations[i].label,
            params = {
                event = 'aj-gps:ShowOptions',
                args = {
                    options = Config.Locations[i].locations
                }
            }
        }
    end
    open(Menu)
end)

RegisterNetEvent('aj-gps:ShowOptions', function(data)
    Options = {
        {
            header = '< GO BACK',
            params = {
                event = 'aj-gps:OpenMenu'
            }
        }
    }
    for i = 1, #data.options do
        Options[#Options + 1] = {
            header = data.options[i].label,
            params = {
                event = 'aj-gps:SetWaypoint',
                args = {
                    coords = data.options[i].coords,
                    label  = data.options[i].label
                }
            }
        }
    end
    open(Options)
end)

RegisterNetEvent('aj-gps:SetWaypoint',function(data)
    SetNewWaypoint(data.coords.x, data.coords.y)
    AJFW.Functions.Notify('GPS set to '..data.label, "success")
end)

exports['aj-framework']:CreateBind("+gps", nil, "Interact: Open GPS", "f11", function()
    TriggerEvent('aj-gps:OpenMenu')
end)