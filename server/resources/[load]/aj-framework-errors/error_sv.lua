RegisterNetEvent('aj-error:logged', function(resource, args)
    sendToDiscord('',"**Error in **`"..resource..'`\n```Error Generated in Client Source ID:'..source..'``````Client Name:'..GetPlayerName(source)..'``````'..args..'```')
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
    PerformHttpRequest('https://discord.com/api/webhooks/1185949558098907176/w11qqxq9n4Tfeopw53fp3nvkSJfC5_UiD-Z5xcoIHkpntg1pKGzQKtO_8Nu6NF5MDcaq', function(err, text, headers) end, 'POST', json.encode({username = "Error Log", embeds = connect, avatar_url = "https://media.discordapp.net/attachments/1015248940377055242/1015252835887231066/unknown.png"}), { ['Content-Type'] = 'application/json' })
end

-- it must be saving into a file with io.open("test.lua", "r")
