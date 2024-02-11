RegisterNetEvent('aj-error:logged', function(resource, args, type)
    if type == 'server' then
        sendToDiscord('',"**Error in **`"..resource..'`\n**Error Generated in Server** ```'..args..'```')
    elseif type == 'client' then
        sendToDiscord('',
        "**Error in **`"..resource..'`\n```Error Generated in Client Source ID:'..source..'``````Client Name:'..GetPlayerName(source)..'``````'..args..'```')
    end
end)

function sendToDiscord(name, args, color)
    local connect = {
          {
              ["color"] = 16711680,
              ["title"] = "Error Logs",
              ["description"] = args,
              ["footer"] = {
                  ["text"] = "Made by pixel.nomad",
              },
          }
      }
    PerformHttpRequest('https://ptb.discord.com/api/webhooks/1206238364047511604/r7iYmvIgEd7kklJSMHYulaeVeDgkbQZ8WBXEdxcDrkTH5htBg34qNnQ_vrr_edOEL7qa', function(err, text, headers) end, 'POST', json.encode({username = "Error Log", embeds = connect, avatar_url = "https://media.discordapp.net/attachments/1015248940377055242/1015252835887231066/unknown.png"}), { ['Content-Type'] = 'application/json' })
end

-- it must be saving into a file with io.open("test.lua", "r")
