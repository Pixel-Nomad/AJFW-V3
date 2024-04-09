
local playertables = { -- Add tables as needed
    { table = 'players' },
    { table = 'apartments' },
    { table = 'bank_accounts' },
    { table = 'crypto_transactions' },
    { table = 'phone_invoices' },
    { table = 'phone_messages' },
    { table = 'playerskins' },
    { table = 'player_contacts' },
    { table = 'player_houses' },
    { table = 'player_mails' },
    { table = 'player_outfits' },
    { table = 'player_vehicles' }
}

function AJFW.Player.ForceDeleteCharacter(citizenid)
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)
        local Player = AJFW.Functions.GetPlayerByCitizenId(citizenid)

        if Player then
            DropPlayer(Player.PlayerData.source, 'An admin deleted the character which you are currently using')
        end
        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('aj-log:server:CreateLog', 'joinleave', 'Character Force Deleted', 'red', 'Character **' .. citizenid .. '** got deleted')
            end
        end)
    end
end