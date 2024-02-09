local aaaaa = 'Global/core'


AJFW = exports['aj-base']:GetCoreObject()

Modular = exports['aj-framework']
Modular_UI  = exports['aj-menu']
Modular_Input = exports['aj-input']


AddEventHandler('onResourceStart', function(resource)
   if resource == 'aj-base' then
      AJFW = exports['aj-base']:GetCoreObject()
   end
end)