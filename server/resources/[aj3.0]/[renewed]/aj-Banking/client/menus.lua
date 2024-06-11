RegisterNetEvent("aj-Banking:client:accountManagmentMenu", function()
    lib.registerContext({
        id = 'aj_banking_account_management',
        title = locale("bank_name"),
        position = 'top-right',
        options = {
            {
                title = locale("create_account"),
                icon = 'file-invoice-dollar',
                metadata = {locale("create_account_txt")},
                event = "aj-Banking:client:createAccountMenu"
            },
            {
                title = locale("manage_account"),
                icon = 'users-gear',
                metadata = {locale("manage_account_txt")},
                event = 'aj-Banking:client:viewAccountsMenu'
            }
        }
    })
    lib.showContext("aj_banking_account_management")
end)

RegisterNetEvent("aj-Banking:client:createAccountMenu", function()
    local input = lib.inputDialog(locale("bank_name"), {{
        type = "input",
        label = locale("account_id"),
        placeholder = "a_test_account"
    }})
    if input and input[1] then
        input[1] = input[1]:lower():gsub("%s+", "")
        TriggerServerEvent("aj-Banking:server:createNewAccount", input[1])
    end
end)

RegisterNetEvent("aj-Banking:client:accountsMenu", function(data)
    local menuOpts = {}
    if #data >= 1 then
        for k=1, #data do
            menuOpts[#menuOpts+1] = {
                title = data[k],
                icon = 'users-gear',
                metadata = {locale("view_members")},
                event = "aj-Banking:client:accountsMenuView",
                args = {
                    account = data[k],
                }
            }
        end
    else
        menuOpts[#menuOpts+1] = {
            title = locale("no_account"),
            metadata = {locale("no_account_txt")},
        }
    end
    lib.registerContext({
        id = 'aj_banking_account_list',
        title = locale("bank_name"),
        position = 'top-right',
        menu = "aj_banking_account_management",
        options = menuOpts
    })
    lib.showContext("aj_banking_account_list")
end)

RegisterNetEvent("aj-Banking:client:accountsMenuView", function(data)
    lib.registerContext({
        id = 'aj_banking_account_view',
        title = locale("bank_name"),
        position = 'top-right',
        menu = "aj_banking_account_list",
        options = {
            {
                title = locale("manage_members"),
                icon = 'users-gear',
                metadata = {locale("manage_members_txt")},
                serverEvent = "aj-Banking:server:viewMemberManagement",
                args = data
            },
            {
                title = locale("edit_acc_name"),
                icon = 'users-gear',
                metadata = {locale("edit_acc_name_txt")},
                event = "aj-Banking:client:changeAccountName",
                args = data
            },
            {
                title = locale("delete_account"),
                icon = 'users-gear',
                metadata = {locale("delete_account_txt")},
                serverEvent = "aj-Banking:server:deleteAccount",
                args = data
            }
        }
    })
    lib.showContext("aj_banking_account_view")
end)

RegisterNetEvent("aj-Banking:client:viewMemberManagement", function(data)
    local menuOpts = {}
    local account = data.account
    for k,v in pairs(data.members) do
        menuOpts[#menuOpts+1] = {
            title = v,
            metadata = {locale("remove_member_txt")},
            event = 'aj-Banking:client:removeMemberConfirmation',
            args = {
                account = account,
                cid = k,
            }
        }
    end
    menuOpts[#menuOpts+1] = {
        title = locale("add_member"),
        metadata = {locale("add_member_txt")},
        event = 'aj-Banking:client:addAccountMember',
        args = {
            account = account
        }
    }
    lib.registerContext({
        id = 'wed_banking_member_manage',
        title = locale("bank_name"),
        position = 'top-right',
        menu = 'aj_banking_account_view',
        options = menuOpts
    })
    lib.showContext("aj_banking_member_manage")
end)

RegisterNetEvent('aj-Banking:client:removeMemberConfirmation', function(data)
    lib.registerContext({
        id = 'aj_banking_member_remove',
        title = locale('bank_name'),
        position = 'top-right',
        menu = 'aj_banking_account_view',
        options = {
            {
                title = locale('remove_member'),
                metadata = {locale('remove_member_txt2', data.cid)},
                serverEvent = 'aj-Banking:server:removeAccountMember',
                args = data
            }
        }
    })
    lib.showContext('aj_banking_member_remove')
end)

RegisterNetEvent('aj-Banking:client:addAccountMember', function(data)
    local input = lib.inputDialog(locale('add_account_member'), {{
        type = 'input',
        label = locale('citizen_id'),
        placeholder = '1001'
    }})
    if input and input[1] then
        input[1] = input[1]:upper():gsub("%s+", "")
        TriggerServerEvent('aj-Banking:server:addAccountMember', data.account, input[1])
    end
end)

RegisterNetEvent('aj-Banking:client:changeAccountName', function(data)
    local input = lib.inputDialog(locale('change_account_name'), {{
        type = 'input',
        label = locale('account_id'),
        placeholder = 'savings-1001'
    }})
    if input and input[1] then
        input[1] = input[1]:lower():gsub("%s+", "")
        TriggerServerEvent('aj-Banking:server:changeAccountName', data.account, input[1])
    end
end)