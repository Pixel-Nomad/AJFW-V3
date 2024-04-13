# aj-zones
![image](https://user-images.githubusercontent.com/82112471/189185989-c33fb2c8-959d-4624-8d22-8e0cef703e93.png)


## Purpose
### The purpose of this script is to create and handle polyzones more efficiently for zone enter/leave events. Every zone is added to a overarching combozone which greatly improves perfomance looping over the normal distance checking via coords/distance of a point.

## The data passed into the exports is optional and not required.
## Each Polyzone needs to have a UNIQUE NAME otherwise it will get triggered each time there is a zone.

# Dependency: 
* [PolyZone](https://github.com/mkafrin/PolyZone)

## Events
### These events are triggered when a player enters/leaves a zone.
### Client
```
RegisterNetEvent("aj-zones:enter", function(ZoneName, ZoneData)
    -- Code here
end)

RegisterNetEvent("aj-zones:leave", function(ZoneName, ZoneData)
    -- Code here
end)
```
### Server
```
RegisterServerEvent("aj-zones:enter", function(ZoneName, ZoneData)
    -- Code here
end)

RegisterServerEvent("aj-zones:leave", function(ZoneName, ZoneData)
    -- Code here
end)
```
## Client Exports:
```
exports["aj-zones"]:CreatePolyZone(name, points, data)

exports["aj-zones"]:CreateBoxZone(name, point, length, width, data)

exports["aj-zones"]:CreateCircleZone(name, point, radius, data)

exports["aj-zones"]:CreateEntityZone(name, entity, data)

exports["aj-zones"]:DestroyZone(name)
```


## Examples:

```
-- Create Polyzone
exports["aj-zones"]:CreatePolyZone("poly-test", {
      vector2(-7.88, -1058.93),
      vector2(0.03, -1058.67),
      vector2(-3.75, -1054.05),
    }, {
        debugPoly = true,
        minZ =  38.16 - 1,
        maxZ =  38.16 + 1,
})

-- Create Box Zone
RegisterCommand("box", function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    exports["aj-zones"]:CreateBoxZone("box-test", coords, 2.0, 2.0, {
        debugPoly = true,
        heading = 0.0,
        minZ = coords.z - 1,
        maxZ = coords.z + 1,
    })
end)

-- Create Circle Zone
RegisterCommand("circle", function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    exports["aj-zones"]:CreateCircleZone("circle-test", coords, 5.0, {
        debugPoly = true,
        minZ = coords.z - 1,
        maxZ = coords.z + 1,
    })
end)

-- Create Entity Zone
RegisterCommand("entity", function()
    local ped = PlayerPedId()
    exports["aj-zones"]:CreateEntityZone("entity-test", ped, {
        debugPoly = true,
        useZ = false,
    })
end)

```
