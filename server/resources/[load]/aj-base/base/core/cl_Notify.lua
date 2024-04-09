function AJFW.Functions.Notify(text, texttype, length, position)
    if type(text) == 'table' then
        local ttext = text.text or 'Placeholder'
        local caption = text.caption or 'Placeholder'
        texttype = texttype or 'primary'
        length = length or 5000
        local Position = position or 'left'
        SendNUIMessage({
            action = 'notify',
            type = texttype,
            length = length,
            text = ttext,
            caption = caption,
            position = Position 
        })
    else
        texttype = texttype or 'primary'
        length = length or 5000
        local Position = position or 'left'
        SendNUIMessage({
            action = 'notify',
            type = texttype,
            length = length,
            text = text,
            position = Position 
        })
    end
end

RegisterNetEvent('AJFW:Notify', function(text, type, length, position)
    AJFW.Functions.Notify(text, type, length, position)
end)