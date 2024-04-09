function draw_changeText(text, position, r, g, b, aa, types, top)
    if type(position) ~= 'string' then position = 'left' end
    r = r or 0
    g = g or 94
    b = b or 255
    aa = aa or 0.7
    types = types or 5
    top = atopa or 50
    exports.ui_text:_SendNUIMessage({
        action = 'CHANGE_TEXT',
        data = {
            text = text,
            position = position
        },
        r = r,
        g = g,
        b = b,
        a = aa,
        type = types,
        top = top
    })
end

RegisterNetEvent('aj-base:client:DrawText', function(text, position, r, g, b, aa, types, top)
    draw_changeText(text, position, r, g, b, aa, types, top)
end)
