function draw_hideText(types)
    types = types or 5
    exports.ui_text:_SendNUIMessage({
        action = 'HIDE_TEXT',
        type = types
    })
end

RegisterNetEvent('aj-base:client:HideText', function(types)
    draw_hideText(types)
end)
