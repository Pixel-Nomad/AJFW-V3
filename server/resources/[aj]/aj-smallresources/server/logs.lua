local AJFW = exports['aj-base']:GetCoreObject()
local Webhooks = {
    ['default'] = 'https://discord.com/api/webhooks/1256754263871328379/SrbyvMZr-hXxBBjs_AvJG8GyXbLeP84lqBK9PyYyaTrbEAxjYx1-kjObNcfCVQ3xgGMG',
    ['testwebhook'] = 'https://discord.com/api/webhooks/1256754307542286416/E-vc_hVF2DfgNaBtbv9czeQ-MVAxhlc3PPJHzKd_hkzOHfZ1ikzImYZO6kbc98n0AEQz',
    ['playermoney'] = 'https://discord.com/api/webhooks/1256754347833036861/lcg19QFbuZRkiLAZGtdvrY91fLZvhki4Cj89sBDRPwVusHUQPDXcBTNhbu0AbbYbmA2R',
    ['playerinventory'] = 'https://discord.com/api/webhooks/1256754451163906079/OvHbIJjvmSWza9PTv5vY_2gSUVWlJfkzpwawoT777qH0wHM3xGDWzI-IA3GiPLCXseUq',
    ['robbing'] = 'https://discord.com/api/webhooks/1256754496248352788/WDUCnmgGBr7f9GbnFBiqZrDc2J7eEmaB-Hj4QtC7JjiQcJ2LdBFQLZzh5xTU4UHnuPVj',
    ['cuffing'] = 'https://discord.com/api/webhooks/1256754536039583878/0BZ7Xo-EyrPByh-Zwlvg1jZuzU3X-LTWcZahsWoePgKv6MjYxHnl1-MDNuNI8-a4EFMN',
    ['drop'] = 'https://discord.com/api/webhooks/1256754582261071964/cAlhimrgSP0OyxUN4GRa7UpyBljMn0Foivssgj5XpnTDRE5rRUE6DyfHsE_V8qWwyRiW',
    ['trunk'] = 'https://discord.com/api/webhooks/1256754621695787098/_0ZPdqSKDaQTaWwsCeJ2M2LNZqNjGNmIV2g6YcNVDLCWqAoaYd6qNWZcN_ozMb0TkUqz',
    ['stash'] = 'https://discord.com/api/webhooks/1256754665832452096/0BOOSVY3SeNMVKHVNmnd85HPcYwLdMOAqfsxDj2kHSxJ2GlpJnuXzDBlvtVoEHIEgfbU',
    ['glovebox'] = 'https://discord.com/api/webhooks/1256754707054198795/8h3PcPaIeEPnj-lpqI6SFj0cgQzsWoAg1j8rvSe8inrnW7pVMbbiEWLg8VRLL1Un_BwM',
    ['banking'] = 'https://discord.com/api/webhooks/1256754758828425278/MKbklR1g0HBAoBbPAh2c1qVjJDRIgZbSz3mYftQc5UTsN5p4s5Z_oeXjYNMsXZwun78S',
    ['vehicleshop'] = 'https://discord.com/api/webhooks/1256754799693660211/KL10rqtxX18kE8MN9x7sOP7YD96q8Qqlc7oYoABRpfodNsL4ja69IHSTs3wGKkTB5leu',
    ['vehicleupgrades'] = 'https://discord.com/api/webhooks/1256754833851941014/y4fUfRx_0HSERnHqP9DKgbk2XXDYdYOoCm35KbSmsZR95z2pLTt8cDrkd0HYbjZm79C2',
    ['shops'] = 'https://discord.com/api/webhooks/1256755064903827486/F708VpOWo03JK_uFFJRHKJPZFwxVYxTKRR1Zdvw1TBKn89vQqEwXXU02MmWUN7Fv51st',
    ['dealers'] = 'https://discord.com/api/webhooks/1256755105294975038/h-OogjgGqRgnBxCrjXX4MlkSjrOpkYHSzM1qL_2tb4BKqCNXnIphP_2qRei3JlNgmVu6',
    ['storerobbery'] = 'https://discord.com/api/webhooks/1256755169392070706/8zDgApC8TVnGHG_RIwqEi2IV-SqVXfsJvRj9XaPhz6UpVMeSGeRbeH3MfZGkdrm9Vvsp',
    ['bankrobbery'] = 'https://discord.com/api/webhooks/1256755217605726263/2Hpg_TPHX936zHLgkabxEzlgzXPBJjfuKFDb0cnm0YcOXbaxvq0nTNq4NJJ6FUW4_M1q',
    ['powerplants'] = 'https://discord.com/api/webhooks/1256755257652940861/HC_N487PTHEpozWgArVhcZowshbxDMOCK20JMypUUR8YEETnP5MkzT1mL2ukZhf6ry30',
    ['death'] = 'https://discord.com/api/webhooks/1256755293031759934/azfoPV8LZBwm0i-Ge6mttna8KE79mmuk1O4vx88zNCNVpufODYrqvJeAZrh2IfgLwmb4',
    ['joinleave'] = 'https://discord.com/api/webhooks/1256755348342312981/XO1wgwi3hsbdDXKOXB78GfUBGWPIP8Rk1zcs3DnSFmdDAZnWSAgLVngUvDlEJ3ONqV0S',
    ['ooc'] = 'https://discord.com/api/webhooks/1256755483243446352/flz0-Hpx9YfT0ijCfJk9hUjhl7JLi_mJnrFk8Uyi8rVBJAAizMQiSB4sOdix3hFNiCuB',
    ['report'] = 'https://discord.com/api/webhooks/1256755541091418212/IOl3G1AL1mWrCSLnOQUihxIFfPDcxayMpV0ATlUgKIZPSiKznGdeRCgI-VYuSSsoxBpw',
    ['me'] = 'https://discord.com/api/webhooks/1256755582036086805/jwKF_ToQIjdlM-LV1E89JlrM_MSsCumf_3o1WmnbDakA0_ko6_zF5rRUT7GgV2okMXlH',
    ['pmelding'] = 'https://discord.com/api/webhooks/1256755903743660193/97llm0Nfi35AGyG5M3d-BOxVa9XfutAKQBq4dCJlmCedBXBHHzioNGV-Wfgic3BBYvjC',
    ['112'] = 'https://discord.com/api/webhooks/1256755958013624330/xouxTx7FCbk788uArB_i871xqE3UlTVBRjo_ouOaRFoja-EIQ4DNTrSpmE2i1_kzmceM',
    ['bans'] = 'https://discord.com/api/webhooks/1256756012094984192/65S8ZKb2lqjao8Dj9_EI32eitP7qwnqnEuJW5vcUbgaJhfE3JW4OFaG4ecTzPjby7DFX',
    ['anticheat'] = 'https://discord.com/api/webhooks/1256756049541857310/w9NtntN7-ha3_f2dMJtJDwON7JuFKZh69nVqA22Vrjz_ugyOns59cBsPMB-VM1lFc1gq',
    ['weather'] = 'https://discord.com/api/webhooks/1256756088846553099/HTvJEwfdUb4RlZVV35R74DkVa9PNCnQaHEoyHjlMp-VBMHJfQ2qQg9BS47WlrTq0ZzuZ',
    ['moneysafes'] = 'https://discord.com/api/webhooks/1256756125827600435/OiuE-vX0elypX0anQJVURSWMSNltK-amis5hnyfFzgaP-fNUuOPmXSCKze2xBQlHAaBR',
    ['bennys'] = 'https://discord.com/api/webhooks/1256756166499893311/9pBddBt6SIM3k6VIuwLIuJ-NKTwiMOWFoKg2HZ83X59PmEroJa6XU3JjgM3V_SjY7bE_',
    ['bossmenu'] = 'https://discord.com/api/webhooks/1256756215443226666/uHwSYJJrn_M_wiDIgkYVktal4nszCrFiuR_HOBngwCRHuFP33Wx5gE9hs8aPV0RUHGMH',
    ['robbery'] = 'https://discord.com/api/webhooks/1256756248171515954/-kAJzIrFeC1e3c2pScVEafRxbMW-8A3GaXhTrZ_VG_-otyZA1x0OdY1xn4vOLPMV1P9O',
    ['casino'] = 'https://discord.com/api/webhooks/1256756290169082048/LzKbOOk0QmXH6H8xuVWYCYQdtdNQVUfI1H5BnieL0aNGmcj4Fr_tg1ZrHUbxBHWVBFgC',
    ['traphouse'] = 'https://discord.com/api/webhooks/1256756332539936768/xnVNFqJR7iSGuwcQ3zUgcvEzoKtH6dj8lSdOB5rAoJ_yYRr3vA9K3zhedvTHU2P9Klzd',
    ['911'] = 'https://discord.com/api/webhooks/1256756365385404593/3IHF1iLmQ7uQeyXzvTFAH7O5xbu1IMwHh9OXDRO2fm_t-ELfxrLgPjiko_9C920iAhFm',
    ['palert'] = 'https://discord.com/api/webhooks/1256756435455316058/5vsL-dzmzcB0vV5fsexSX4y9t8boJfeGiFlqU6Htp3wihP0GlwIQGJqB1I1HQ8fJfoS8',
    ['house'] = 'https://discord.com/api/webhooks/1256756469895008359/4OwQmR7665Zod_szEZctaXmvJsYicv3AIn2sKm7GSu09Pq6jJKf2z02MFI1-Ltd1cuES',
    ['ajjobs'] = 'https://discord.com/api/webhooks/1256756512131387392/20JJQhJsAaW-thuRR6tKbwEvuXbUCX_8x6zCc_1xW-AWwG-vDl0cSU-EWFLQWc1IuKBT',
}

local colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ['lightgreen'] = 65309,
}

local logQueue = {}

RegisterNetEvent('aj-log:server:CreateLog', function(name, title, color, message, tagEveryone)
    local postData = {}
    local tag = tagEveryone or false
    local webHook = Webhooks[name] ~= '' and Webhooks[name] or Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = colors[color] or colors['default'],
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'AJFW Logs',
                ['icon_url'] = 'https://raw.githubusercontent.com/GhzGarage/aj-media-kit/main/Display%20Pictures/Logo%20-%20Display%20Picture%20-%20Stylized%20-%20Red.png',
            },
        }
    }

    if not logQueue[name] then logQueue[name] = {} end
    logQueue[name][#logQueue[name] + 1] = {webhook = webHook, data = embedData}

    if #logQueue[name] >= 10 then
        if tag then
            postData = {username = 'AJ Logs', content = '@everyone', embeds = {}}
        else
            postData = {username = 'AJ Logs', embeds = {}}
        end
        for i = 1, #logQueue[name] do postData.embeds[#postData.embeds + 1] = logQueue[name][i].data[1] end
        PerformHttpRequest(logQueue[name][1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
        logQueue[name] = {}
    end
end)

Citizen.CreateThread(function()
    local timer = 0
    while true do
        Wait(1000)
        timer = timer + 1
        if timer >= 60 then -- If 60 seconds have passed, post the logs
            timer = 0
            for name, queue in pairs(logQueue) do
                if #queue > 0 then
                    local postData = {username = 'AJ Logs', embeds = {}}
                    for i = 1, #queue do
                        postData.embeds[#postData.embeds + 1] = queue[i].data[1]
                    end
                    PerformHttpRequest(queue[1].webhook, function() end, 'POST', json.encode(postData), {['Content-Type'] = 'application/json'})
                    logQueue[name] = {}
                end
            end
        end
    end
end)

AJFW.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function()
    TriggerEvent('aj-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')