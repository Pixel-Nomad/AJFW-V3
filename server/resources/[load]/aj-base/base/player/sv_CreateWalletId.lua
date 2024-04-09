function AJFW.Player.CreateWalletId()
    local UniqueFound = false
    local WalletId = nil
    while not UniqueFound do
        WalletId = 'AJ-' .. math.random(11111111, 99999999)
        local query = '%' .. WalletId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return WalletId
end