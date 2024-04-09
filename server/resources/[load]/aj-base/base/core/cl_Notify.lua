local positions = {
    ['top-left'] = true,
    ['top-right'] = true,
    ['bottom-left'] = true,
    ['bottom-right'] = true,
    ['top'] = true,
    ['bottom'] = true,
    ['left'] = true,
    ['right'] = true,
    ['center'] = true,
}

function AJFW.Functions.Notify(text, texttype, length, icon, position)
    local message = {
        action = 'notify',
        type = texttype or 'primary',
        length = length or 5000,
    }

    if type(text) == 'table' then
        message.text = text.text or 'Placeholder'
        message.caption = text.caption or 'Placeholder'
    else
        message.text = text
    end

    if icon then
        message.icon = icon
    end

    if positions[position] or positions[icon] then
        message.icon = icon
    end

    SendNUIMessage(message)
end

RegisterNetEvent('AJFW:Notify', function(text, type, length, position)
    AJFW.Functions.Notify(text, type, length, position)
end)