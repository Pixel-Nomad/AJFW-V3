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

function AJFW.Player.DeleteCharacter(source, citizenid)
    local license = AJFW.Functions.GetIdentifier(source, 'license')
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if license == result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)

        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('aj-log:server:CreateLog', 'joinleave', 'Character Deleted', 'red', '**' .. GetPlayerName(source) .. '** ' .. license .. ' deleted **' .. citizenid .. '**..')
            end
        end)
    else
        DropPlayer(source, Lang:t('info.exploit_dropped'))
        TriggerEvent('aj-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Deletion Exploit', true)
    end
end