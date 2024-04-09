function AJFW.Player.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(5)):upper()
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE citizenid = ?', { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end