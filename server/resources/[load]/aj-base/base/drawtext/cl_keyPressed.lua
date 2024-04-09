function draw_keyPressed()
    CreateThread(function() -- Not sure if a thread is needed but why not eh?
        exports.ui_text:_SendNUIMessage({
            action = 'KEY_PRESSED',
        })
        Wait(500)
        draw_hideText()
    end)
end

RegisterNetEvent('aj-base:client:KeyPressed', function()
    draw_keyPressed()
end)
