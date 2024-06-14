AJFW.Functions.CreateUseableItem('gift' , function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, item.amount, item.slot) then
        Player.Functions.AddMoney('bank', math.random(25000, 150000), 'Gift')
        local chance = math.random(1, 100)
        if chance > 75 then
            Player.Functions.AddItem('car4', 1)
        elseif chance > 50 then
            Player.Functions.AddItem('car5', 1)
        elseif chance > 25 then
            Player.Functions.AddItem('car2', 1)
        elseif chance > 10 then
            Player.Functions.AddItem('car3', 1)
        else
            Player.Functions.AddItem('car1', 1)
        end
    end
end)