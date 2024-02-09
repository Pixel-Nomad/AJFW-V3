local aaaaa = 'Callbacks/PlayerCount'


AJFW.Functions.CreateCallback("aj-framework:GetPlayerCount", function(src, cb)
    cb(GetConvarInt('sv_maxclients', 32), GetNumPlayerIndices())
end)