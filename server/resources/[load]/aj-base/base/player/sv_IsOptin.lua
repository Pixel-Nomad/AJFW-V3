local permsobject = {
    'dev',
    'owner',
    'manager',
    'h-admin',
    'admin',
    'c-admin',
    's-mod',
    'mod'
}

function AJFW.Functions.IsOptin(source)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    if license then
        for i = 1, #permsobject do
            if AJFW.Functions.HasPermission(src, permsobject[i]) then
                return true
            end
        end
        return false
    else
        return false
    end
end