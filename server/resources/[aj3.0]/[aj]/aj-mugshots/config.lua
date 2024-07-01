Config = {}

Config.Debug = false

Config.Webhook = "https://discord.com/api/webhooks/1256752889922326707/dLGavIBDGxVxElFMrYhpk_LkjA72qGwm5Y4L6T1SMiwhUxXnv8WfdN_1tHldbIdrCUfb"

Config.MLO = true

Config.Mugshots = {} 

Config.data = {
    {
        location = vector3(484.04, -999.99, 24.47),
        heading = 3.42,

        camera = {
            x = 483.76,
            y = -997.14,
            z = 25.47,
            r = { x = 0.0, y = 0.0, z = 180.0 }
        },

        BoardHeader = "Los Santos Police Department",

        Wait = 2000,

        side = 1,

        target = {
            location = vector3(473.0060, -1012.57, 26.91628),

            length = 0.15,
            width = 0.15,

            options = {
                name = "1235", 
                heading = 92.0, 
                debugPoly = Config.Debug, 
                minZ = 26.90, 
                maxZ = 27.00, 
            },

            targetoptions = {
                
                options = { 
                    {
                        icon = 'fas fa-camera',
                        label = 'Take Suspects Mugshots',

                        job = {
                            ['lspd'] = 0,
                        },
                    }
                },

                distance = 2.5,

            }

        }
    },
    {
        location = vector3(1813.16, 3664.25, 33.19),
        heading = 295.22,

        camera = {
            x = 1814.32,
            y = 3664.95,
            z = 34.69,
            r = {x = 0.0, y = 0.0, z = 120.0}
        },

        BoardHeader = "Blaine County Sheriff Office",

        Wait = 2000,

        side = 1,

        target = {
            location = vector3(1817.8, 3665.39, 35.18),

            length = 0.35,
            width = 0.20,

            options = {
                name = "12356", 
                heading = 239.2,
                debugPoly = Config.Debug, 
                minZ = 34.00, 
                maxZ = 34.20, 
            },

            targetoptions = {
                
                options = { 
                    {
                        icon = 'fas fa-camera',
                        label = 'Take Suspects Mugshots',

                        job = {
                            ['bcso'] = 0,
                        },
                    }
                },

                distance = 2.5,

            }

        }
    },
    {
        location = vector3(382.39, -1599.58, 24.45),
        heading = 137.37,

        camera = {
            x = 381.39,
            y = -1600.67,
            z = 26.05,
            r = {x = 0.0, y = 0.0, z = 320.0}
        },

        BoardHeader = "San Andreas State Police",

        Wait = 2000,

        side = 1,

        target = {
            location = vector3(380.65, -1602.8, 26.52),

            length = 0.35,
            width = 0.20,

            options = {
                name = "12357", 
                heading = 119.84,
                debugPoly = Config.Debug, 
                minZ = 25.40, 
                maxZ = 25.60,
            },

            targetoptions = {
                
                options = { 
                    {
                        icon = 'fas fa-camera',
                        label = 'Take Suspects Mugshots',

                        job = {
                            ['sasp'] = 0,
                        },
                    }
                },

                distance = 2.5,

            }

        }
    },
    {
        location = vector3(382.39, -1599.58, 24.45),
        heading = 137.37,

        camera = {
            x = 381.39,
            y = -1600.67,
            z = 26.05,
            r = {x = 0.0, y = 0.0, z = 320.0}
        },

        BoardHeader = "San Andreas State Park Ranger",

        Wait = 2000,

        side = 1,

        target = {
            location = vector3(380.65, -1602.8, 26.52),

            length = 0.35,
            width = 0.20,

            options = {
                name = "12358", 
                heading = 119.84,
                debugPoly = Config.Debug, 
                minZ = 25.40, 
                maxZ = 25.60,
            },

            targetoptions = {
                
                options = { 
                    {
                        icon = 'fas fa-camera',
                        label = 'Take Suspects Mugshots',

                        job = {
                            ['sapr'] = 0,
                        },
                    }
                },

                distance = 2.5,

            }

        }
    }
}