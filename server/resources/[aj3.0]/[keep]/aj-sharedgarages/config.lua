Config = Config or {}

Config.fuel_script = 'aj-fuel' --aj-fuel

Config.MagicTouch = false
Config.VehicleWhiteList = {
     ['defaultPolice'] = {
          { label = 'Sheriff', model = 'Sheriff2' },
          { label = 'Sheriff', model = 'Sheriff' },
          { label = 'Riot', model = 'Riot' },
          { label = 'Policeb', model = 'Policeb' },
          { label = 'PBus', model = 'PBus' },
          { label = 'Police', model = 'Police' },
          { label = 'Police2', model = 'Police2' },
          { label = 'Police3', model = 'Police3' },
          { label = 'Police4', model = 'Police4' },
          { label = 'npolvic', model = 'npolvic' },
     },
     ['heliPolice'] = {
          { label = 'Police Maverick', model = 'Polmav' }
     },
     ['gas_station'] = {
          { label = 'Adder', model = 'adder' },
          { label = 'Glendale', model = 'glendale' },
     },
     ['vagos_yard'] = {
          -- by using aj-base/shared/vehicles.lua
          allow_all = true,
          { label = 'Sheriff', model = 'Sheriff2' }, -- #TODO add support for additions
     },
}


Config.Garages = {
     --Job Garage:
     ['mrpd'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'lspd' }, -- accpets just one job
          job2 = 'lspd', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
     ['mrpd2'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'bcso' }, -- accpets just one job
          job2 = 'bcso', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
     ['mrpd3'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'sasp' }, -- accpets just one job
          job2 = 'sasp', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
     ['mrpd4'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'sapr' }, -- accpets just one job
          job2 = 'sapr', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
     ['mrpd5'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'doc' }, -- accpets just one job
          job2 = 'doc', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
     ['mrpd6'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'fib' }, -- accpets just one job
          job2 = 'fib', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
     ['mrpd6'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'sahp' }, -- accpets just one job
          job2 = 'sahp', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
     ['mrpd6'] = {
          label = 'Police Garage (mrpd)',
          type = 'job',
          job = { 'swat' }, -- accpets just one job
          job2 = 'swat', -- accpets just one job
          onDuty = true,
          spawnPoint = {
               vector4(434.53, -979.43, 24.62, 179.96),
               vector4(430.81, -979.74, 24.62, 181.02),
               vector4(427.44, -979.42, 24.62, 180.36),
               vector4(427.13, -991.05, 24.62, 271.67),
               vector4(426.78, -994.53, 24.62, 270.25),
          },
          zones = {
               vector2(424.04, -976.8),
               vector2(424.08, -997.66),
               vector2(436.24, -998.13),
               vector2(436.34, -976.67),
          },
          minz = 24.66,
          maxz = 28.66,
          WhiteList = Config.VehicleWhiteList['defaultPolice'],
          garage_management = {
               -- access to garage management
               ['XSK80915'] = true
          }
     },
}

function Notification(source, msg, _type)
     TriggerClientEvent('AJFW:Notify', source, msg, _type)
end

CreateThread(function()
     for garage_name, garage in pairs(Config.Garages) do
          for key, value in pairs(garage.WhiteList) do
               if key ~= 'allow_all' then
                    Config.Garages[garage_name].WhiteList[key].hash = GetHashKey(value.model:lower())
               end
          end
     end
end)
