function AJFW.Player.CreateFingerId()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(1) .. AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(4))
        local query = '%' .. FingerId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return FingerId
end