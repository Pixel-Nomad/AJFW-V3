local AJFW = exports['aj-base']:GetCoreObject()

local function showCDU(data)
     if not data then return end
     local state = ''
     if data.metadata.state == true then
          state = 'Active'
     else
          state = 'inactive'
     end
     local header = "Crude oil distillation unit (" .. state .. ')'
     -- header
     local CDU_Temperature = data.metadata.temp
     local CDU_Gal = data.metadata.oil_storage
     local openMenu = {
          {
               header = header,
               isMenuHeader = true,
               icon = 'fa-solid fa-gear'
          }, {
               header = 'Temperature',
               icon = 'fa-solid fa-temperature-high',
               txt = "" .. CDU_Temperature .. " °C",
          },
          {
               header = 'Curde Oil inside CDU',
               icon = 'fa-solid fa-oil-can',
               txt = CDU_Gal .. " Gallons",
          },
          {
               header = 'Pump Curde Oil to CDU',
               icon = 'fa-solid fa-arrows-spin',
               params = {
                    event = "aj-oilrig:CDU_menu:pumpCrudeOil_to_CDU"
               }
          },
          {
               header = 'Change Temperature',
               icon = 'fa-solid fa-temperature-arrow-up',
               params = {
                    event = "aj-oilrig:CDU_menu:set_CDU_temp"
               }
          },
          {
               header = 'Toggle CDU',
               icon = 'fa-solid fa-sliders',
               params = {
                    event = "aj-oilrig:CDU_menu:switchPower_of_CDU"
               }
          },
          {
               header = 'leave',
               icon = 'fa-solid fa-circle-xmark',
               params = {
                    event = "aj-menu:closeMenu"
               }
          }
     }
     exports['aj-menu']:openMenu(openMenu)
end

AddEventHandler('aj-oilrig:CDU_menu:ShowCDU', function()
     AJFW.Functions.TriggerCallback('aj-oilrig:server:get_CDU_Data', function(result)
          showCDU(result)
     end)
end)

AddEventHandler('aj-oilrig:CDU_menu:switchPower_of_CDU', function()
     AJFW.Functions.TriggerCallback('aj-oilrig:server:switchPower_of_CDU', function(result)
          showCDU(result)
     end)
end)

AddEventHandler('aj-oilrig:CDU_menu:set_CDU_temp', function()
     local inputData = exports['aj-input']:ShowInput({
          header = "CDU Temperature",
          submitText = "Assign new temperature",
          inputs = { {
               type = 'number',
               isRequired = true,
               name = 'temp',
               text = "Enter new temperature"
          },
          }
     })
     if inputData then
          if not inputData.temp then
               return
          end
          AJFW.Functions.TriggerCallback('aj-oilrig:server:set_CDU_temp', function(result)
               showCDU(result)
          end, inputData)
     end
end)

AddEventHandler('aj-oilrig:CDU_menu:pumpCrudeOil_to_CDU', function()
     local inputData = exports['aj-input']:ShowInput({
          header = "Pump crude oil to CDU",
          submitText = "Enter",
          inputs = { {
               type = 'number',
               isRequired = true,
               name = 'amount',
               text = "Enter Value"
          },
          }
     })
     if inputData then
          inputData.amount = tonumber(inputData.amount)
          if not inputData.amount then
               return
          end

          if inputData.amount <= 0 then
               AJFW.Functions.Notify('Amount must be more than 0', "error")
               return
          end
          AJFW.Functions.TriggerCallback('aj-oilrig:server:pumpCrudeOil_to_CDU', function(result)
               showCDU(result)
          end, inputData)
     end
end)
