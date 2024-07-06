config = {}
config.wardrobe = 'aj-clothMenu' -- choose your skin menu
config.target = true -- false = markers zones type. true = ox_target, aj-target
config.business = true -- allowed players to purchase the motel
config.autokickIfExpire = true -- auto kick occupants if rent is due. if false owner of motel must kick the occupants
config.breakinJobs = { -- jobs can break in to door using gunfire in doors
	['lspd'] = true,
	['swat'] = true,
}
config.wardrobes = { -- skin menus
	['aj_clothes'] = function()
		exports.aj_clothes:OpenClotheInventory()
	end,
	['fivem-appearance'] = function()
		return exports['fivem-appearance']:startPlayerCustomization() -- you could replace this with outfits events
	end,
	['aj-clothMenu'] = function()
		return TriggerEvent('aj-clothMenu:client:openOutfitMenu')
	end,
	['aj-clothing'] = function()
		return TriggerEvent('aj-clothing:client:openOutfitMenu')
	end,
	['esx_skin'] = function()
		TriggerEvent('esx_skin:openSaveableMenu')
	end,
}

-- Shells Offsets and model name
config.shells = {
	['standard'] = {
		shell = `standardmotel_shell`, -- kambi shell
		offsets = {
			exit = vec3(-0.43,-2.51,1.16),
			stash = vec3(1.368164, -3.134506, 1.16),
			wardrobe = vec3(1.643646, 2.551102, 1.16),
		}
	},
	['modern'] = {
		shell = `modernhotel_shell`, -- kambi shell
		offsets = {
			exit = vec3(5.410095, 4.299301, 0.9),
			stash = vec3(-4.068207, 4.046188, 0.9),
			wardrobe = vec3(2.811829, -3.619385, 0.9),
		}
	},
}

config.messageApi = function(data) -- {title,message,motel}
	local motel = GlobalState.Motels[data.motel]
	local identifier = motel.owned -- owner identifier
	-- add your custom message here. ex. SMS phone 

	-- basic notification (remove this if using your own message system)
	local success = lib.callback.await('aj_motels:MessageOwner',false,{identifier = identifier, message = data.message, title = data.title, motel = data.motel})
	if success then
		Notify('message has been sent', 'success')
	else
		Notify('message fail  \n  owner is not available yet', 'error')
	end
end

-- @shell string (shell type)
-- @Mlo string ( toggle MLO or shell type)
-- @hour_rate int ( per hour rates)
-- @motel string (Motel Index Name)
-- @rentcoord vec3 (coordinates of Rental Menu)
-- @radius float ( total size radius of motel )
-- @maxoccupants int (total player can rent in each Rooms)
-- @uniquestash bool ( Toggle Non Sharable / Stealable Stash Storage )
-- @doors table ( lists of doors feature coordinates. ex. stash, wardrobe) wardrobe,stash coords are only applicable in Mlo. using shells has offsets for stash and wardrobes.
-- @manual boolean ( accept walk in occupants only )
-- @businessprice int ( value of motel)
-- @door int (door hash or doormodel `model`) for MLO type

config.motels = {
	[1] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Pink Cage Motel',
		rental_period = 'month',-- hour, day, month
		rate = 15000, -- cost per period
		businessprice = 2351250,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vec3(313.38,-225.20,54.212),
		coord = vec3(326.04,-210.47,54.086), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(312.84, -218.84, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
				-- stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				-- wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				-- fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(310.87, -218.01, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[3] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(307.33, -216.59, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[4] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(307.55, -213.3, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[5] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(309.49, -208.05, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[6] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(311.3, -203.44, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[7] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(313.25, -198.21, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[8] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(315.7, -194.88, 54.23), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[9] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(319.25, -196.16, 54.23), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[10] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(321.26, -196.92, 54.23), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[11] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(312.91, -218.92, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[12] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(310.85, -218.05, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[13] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(307.23, -216.74, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[14] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(307.49, -213.26, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[15] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(309.5, -208.0, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[16] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(311.21, -203.52, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[17] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(313.26, -198.15, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[18] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(315.71, -194.82, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[19] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(319.31, -196.21, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[20] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(321.42, -196.91, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[21] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(329.51, -225.21, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[22] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(331.34, -226.02, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[23] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(334.99, -227.31, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[24] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(337.17, -224.8, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[25] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(339.17, -219.47, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[26] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(340.93, -214.78, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[27] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(342.96, -209.63, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[28] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(344.76, -205.07, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[29] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(346.76, -199.7, 54.22), -- exact coordinates of door
						minZ = 54.22 - 0.6,
						maxZ = 54.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[30] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(329.36, -225.18, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[31] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(331.39, -225.96, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[32] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(335.07, -227.27, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[33] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(337.15, -224.71, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[34] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(339.2, -219.52, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[35] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(340.87, -214.93, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[36] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(342.98, -209.65, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[37] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(344.75, -205.06, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[38] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(346.83, -199.61, 58.02), -- exact coordinates of door
						minZ = 58.22 - 0.6,
						maxZ = 58.22 + 1.2,
						rotation = 160.0,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			
		},
	},
	[2] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Perrera Beach Motel',
		rental_period = 'month',-- hour, day, month
		rate = 15000, -- cost per period
		businessprice = 2351250,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vector3(-1477.05, -674.38, 29.04),
		coord = vector3(-1475.39, -659.5, 28.94)	, -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1493.78, -668.34, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[2] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1498.07, -664.79, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[3] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1495.36, -661.65, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[4] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1490.7, -658.29, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[5] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1486.8, -655.39, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[6] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1482.15, -651.99, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[7] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1478.24, -649.15, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[8] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1473.7, -645.85, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[9] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1469.66, -642.91, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[10] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1465.1, -639.62, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[11] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1461.24, -640.86, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[12] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1452.36, -653.19, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[13] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1454.36, -655.86, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[14] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1458.88, -659.21, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[15] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1462.98, -662.19, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[16] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1467.51, -665.54, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[17] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1471.45, -668.4, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[18] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1461.26, -640.85, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[19] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1457.95, -645.49, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[20] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1455.61, -648.61, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[21] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1452.35, -653.23, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[22] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1454.4, -655.89, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[23] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1459.02, -659.25, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[24] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1462.98, -662.12, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[25] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1467.62, -665.58, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[26] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1471.53, -668.34, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[27] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1476.13, -671.68, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[28] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1465.02, -639.62, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[29] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1469.65, -642.9, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[30] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1473.6, -645.77, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[31] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1478.15, -649.17, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[32] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1482.27, -652.06, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[33] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1486.64, -655.3, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[34] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1490.73, -658.3, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[35] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1495.37, -661.6, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[36] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1497.95, -664.66, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[37] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1493.78, -668.19, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[38] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1489.87, -671.36, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
		},
	},
	[2] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Perrera Beach Motel',
		rental_period = 'month',-- hour, day, month
		rate = 15000, -- cost per period
		businessprice = 2351250,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vector3(-1477.05, -674.38, 29.04),
		coord = vector3(-1475.39, -659.5, 28.94)	, -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1493.78, -668.34, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[2] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1498.07, -664.79, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[3] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1495.36, -661.65, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[4] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1490.7, -658.29, 29.03), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[5] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1486.8, -655.39, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[6] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1482.15, -651.99, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[7] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1478.24, -649.15, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[8] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1473.7, -645.85, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[9] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1469.66, -642.91, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[10] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1465.1, -639.62, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[11] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1461.24, -640.86, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[12] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1452.36, -653.19, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[13] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1454.36, -655.86, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[14] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1458.88, -659.21, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[15] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1462.98, -662.19, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[16] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1467.51, -665.54, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[17] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1471.45, -668.4, 29.58), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[18] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1461.26, -640.85, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[19] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1457.95, -645.49, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[20] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1455.61, -648.61, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[21] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1452.35, -653.23, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[22] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1454.4, -655.89, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[23] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1459.02, -659.25, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[24] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1462.98, -662.12, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[25] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1467.62, -665.58, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[26] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1471.53, -668.34, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[27] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1476.13, -671.68, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[28] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1465.02, -639.62, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[29] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1469.65, -642.9, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[30] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1473.6, -645.77, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[31] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1478.15, -649.17, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[32] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1482.27, -652.06, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[33] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1486.64, -655.3, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[34] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1490.73, -658.3, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[35] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1495.37, -661.6, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[36] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1497.95, -664.66, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[37] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1493.78, -668.19, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[38] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1489.87, -671.36, 33.38), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 145.98,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
		},
	},
	[3] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Crown Jewels Motel',
		rental_period = 'day',-- hour, day, month
		rate = 500, -- cost per period
		businessprice = 990000,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vector3(-1317.81, -939.36, 9.73),
		coord = vector3(-1327.19, -932.03, 11.35)	, -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1339.22, -941.36, 12.35), -- exact coordinates of door
						minZ = 12.22 - 0.6,
						maxZ = 12.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[2] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1338.22, -941.78, 12.35), -- exact coordinates of door
						minZ = 12.22 - 0.6,
						maxZ = 12.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[3] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1331.14, -939.28, 12.36), -- exact coordinates of door
						minZ = 12.22 - 0.6,
						maxZ = 12.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[4] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1329.34, -938.54, 12.36), -- exact coordinates of door
						minZ = 12.22 - 0.6,
						maxZ = 12.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[5] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1319.87, -935.1, 13.36), -- exact coordinates of door
						minZ = 13.22 - 0.6,
						maxZ = 13.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[6] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1317.92, -934.42, 13.36), -- exact coordinates of door
						minZ = 13.22 - 0.6,
						maxZ = 13.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[7] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1310.91, -931.89, 13.36), -- exact coordinates of door
						minZ = 13.22 - 0.6,
						maxZ = 13.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[8] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1308.97, -931.19, 13.36), -- exact coordinates of door
						minZ = 13.22 - 0.6,
						maxZ = 13.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[9] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1339.22, -941.38, 15.36), -- exact coordinates of door
						minZ = 15.22 - 0.6,
						maxZ = 15.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[10] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1338.24, -941.79, 15.36), -- exact coordinates of door
						minZ = 15.22 - 0.6,
						maxZ = 15.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[11] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1331.12, -939.3, 15.36), -- exact coordinates of door
						minZ = 15.22 - 0.6,
						maxZ = 15.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[12] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1329.31, -938.58, 15.36), -- exact coordinates of door
						minZ = 15.22 - 0.6,
						maxZ = 15.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[13] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1319.8, -935.12, 16.36), -- exact coordinates of door
						minZ = 16.22 - 0.6,
						maxZ = 16.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[14] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1317.95, -934.46, 16.36), -- exact coordinates of door
						minZ = 16.22 - 0.6,
						maxZ = 16.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[15] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1310.93, -931.86, 16.36), -- exact coordinates of door
						minZ = 16.22 - 0.6,
						maxZ = 16.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[16] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(-1308.98, -931.21, 16.36), -- exact coordinates of door
						minZ = 16.22 - 0.6,
						maxZ = 16.22 + 1.2,
						rotation = 203.15,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
		},
	},
	[4] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Bilingsgate Motel',
		rental_period = 'day',-- hour, day, month
		rate = 500, -- cost per period
		businessprice = 990000,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vector3(569.81, -1746.5, 29.21),
		coord = vector3(563.29, -1760.04, 29.17)	, -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(566.22, -1778.17, 29.35), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[2] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(550.31, -1775.51, 29.31), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[3] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(552.24, -1771.44, 29.31), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[4] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(554.65, -1766.3, 29.31), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[5] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(557.74, -1759.75, 29.31), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[6] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(561.38, -1751.89, 29.28), -- exact coordinates of door
						minZ = 29.22 - 0.6,
						maxZ = 29.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[7] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(560.26, -1776.73, 33.44), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[8] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(558.68, -1777.14, 33.44), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[9] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(550.1, -1770.43, 33.44), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[10] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(552.64, -1765.0, 33.44), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[11] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(555.75, -1758.42, 33.44), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[12] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(559.44, -1750.64, 33.44), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
			[13] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vector3(561.95, -1747.37, 33.44), -- exact coordinates of door
						minZ = 33.22 - 0.6,
						maxZ = 33.22 + 1.2,
						rotation = 154.43,
						length = 0.90,
						width = 0.80,
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
				},
			},
		},
	},
}
config.extrafunction = {
	['bed'] = function(data,identifier)
		TriggerEvent('luckyme')
	end,
	['fridge'] = function(data,identifier)
		TriggerServerEvent("inventory:server:OpenInventory", "stash", 'fridge_'..data.motel..'_'..identifier..'_'..data.index, {
			maxweight = 20000,
			slots = 30,
		})
     	TriggerEvent("inventory:client:SetCurrentStash", 'fridge_'..data.motel..'_'..identifier..'_'..data.index)
	end,
	['exit'] = function(data)
		local coord = LocalPlayer.state.lastloc or vec3(data.coord.x,data.coord.y,data.coord.z)
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		SendNUIMessage({
			type = 'door'
		})
		return Teleport(coord.x,coord.y,coord.z,0.0,true)
	end,
}

config.Text = {
	['stash'] = 'Stash',
	['fridge'] = 'My Fridge',
	['wardrobe'] = 'Wardrobe',
	['bed'] = 'Sleep',
	['door'] = 'Door',
	['exit'] = 'Exit',
}

config.icons = {
	['door'] = 'fas fa-door-open',
	['stash'] = 'fas fa-box',
	['wardrobe'] = 'fas fa-tshirt',
	['fridge'] = 'fas fa-ice-cream',
	['bed'] = 'fas fa-bed',
	['exit'] = 'fas fa-door-open',
}

config.stashblacklist = {
	['stash'] = { -- type of inventory
		blacklist = { -- list of blacklists items
			water = true,
		},
	},
	['fridge'] = { -- type of inventory
		blacklist = { -- list of blacklists items
			WEAPON_PISTOL = true,
		},
	},
}

PlayerData,ESX,AJFW,zones,shelzones,blips = {},nil,nil,{},{},{}

function import(file)
	local name = ('%s.lua'):format(file)
	local content = LoadResourceFile(GetCurrentResourceName(),name)
	local f, err = load(content)
	return f()
end

if GetResourceState('es_extended') == 'started' then
	ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('aj-base') == 'started' then
	AJFW = exports['aj-base']:GetCoreObject()
end