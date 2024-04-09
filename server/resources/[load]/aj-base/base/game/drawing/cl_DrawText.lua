function AJFW.Functions.DrawText(x, y, width, height, scale, r, g, b, a, text)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2 + 0.005)
end