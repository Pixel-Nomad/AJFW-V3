Cores = {
    {
        Name = "ESX",
        ResourceName = "es_extended",
        GetFramework = function() return exports["es_extended"]:getSharedObject() end
    },
    {
        Name = "ajCore",
        ResourceName = "aj-base",
        GetFramework = function() return exports["aj-base"]:GetCoreObject() end
    },
    {
        Name = "ajXCore",
        ResourceName = "ajx_core",
        GetFramework = function() return exports["ajx_core"]:GetCoreObject() end
    }
}