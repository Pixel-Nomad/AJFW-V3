function AJFW.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
    if AJFW.Commands[name] then
        permission = AJFW.Commands[name]
    else
        if type(permission) == 'string' then
            permission = permission:lower()
        else
            permission = 'user'
        end
    end

    AJFW.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end