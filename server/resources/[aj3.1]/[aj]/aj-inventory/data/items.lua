return {
	-- ['testburger'] = {
	-- 	label = 'Test Burger',
	-- 	weight = 220,
	-- 	degrade = 60,
	-- 	client = {
	-- 		image = 'burger_chicken.png',
	-- 		status = { hunger = 200000 },
	-- 		anim = 'eating',
	-- 		prop = 'burger',
	-- 		usetime = 2500,
	-- 		export = 'ox_inventory_examples.testburger'
	-- 	},
	-- 	server = {
	-- 		export = 'ox_inventory_examples.testburger',
	-- 		test = 'what an amazingly delicious burger, amirite?'
	-- 	},
	-- 	buttons = {
	-- 		{
	-- 			label = 'Lick it',
	-- 			action = function(slot)
	-- 				print('You licked the burger')
	-- 			end
	-- 		},
	-- 		{
	-- 			label = 'Squeeze it',
	-- 			action = function(slot)
	-- 				print('You squeezed the burger :(')
	-- 			end
	-- 		},
	-- 		{
	-- 			label = 'What do you call a vegan burger?',
	-- 			group = 'Hamburger Puns',
	-- 			action = function(slot)
	-- 				print('A misteak.')
	-- 			end
	-- 		},
	-- 		{
	-- 			label = 'What do frogs like to eat with their hamburgers?',
	-- 			group = 'Hamburger Puns',
	-- 			action = function(slot)
	-- 				print('French flies.')
	-- 			end
	-- 		},
	-- 		{
	-- 			label = 'Why were the burger and fries running?',
	-- 			group = 'Hamburger Puns',
	-- 			action = function(slot)
	-- 				print('Because they\'re fast food.')
	-- 			end
	-- 		}
	-- 	},
	-- 	consume = 0.3
	-- },

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['sprunk'] = {
		label = 'Sprunk',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with a sprunk'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
		client = {
			image = 'card_id.png'
		}
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	["chair32"] = {
		label = "Luxury Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair32.png",
		}
	},

	["meat_chicken"] = {
		label = "Chicken Meat",
		weight = 700,
		stack = true,
		close = true,
		description = "Chicken meat!",
		client = {
			image = "meat_chicken.png",
		}
	},

	["internals"] = {
		label = "Internal Cosmetics",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "internals.png",
		}
	},

	["thermite"] = {
		label = "Thermite",
		weight = 1000,
		stack = true,
		close = true,
		description = "Sometimes you'd wish for everything to burn",
		client = {
			image = "thermite.png",
		}
	},

	["chair64"] = {
		label = "Striped Camping Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair64.png",
		}
	},

	["silver_ring"] = {
		label = "Silver Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "silver_ring.png",
		}
	},

	["dendrogyra_coral"] = {
		label = "Dendrogyra",
		weight = 1000,
		stack = true,
		close = true,
		description = "Its also known as pillar coral",
		client = {
			image = "dendrogyra_coral.png",
		}
	},

	["ironoxide"] = {
		label = "Iron Powder",
		weight = 100,
		stack = true,
		close = false,
		description = "Some powder to mix with.",
		client = {
			image = "ironoxide.png",
		}
	},

	["moonshine_distill"] = {
		label = "Distilled Moonshine",
		weight = 5000,
		stack = true,
		close = false,
		description = "A bucket of distilled moonshine!",
		client = {
			image = "moonshine_distill.png",
		}
	},

	["flat_muzzle_brake"] = {
		label = "Flat Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "flat_muzzle_brake.png",
		}
	},

	["chair22"] = {
		label = "Posh Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair22.png",
		}
	},

	["maize_sack"] = {
		label = "Maize Sack",
		weight = 5000,
		stack = true,
		close = false,
		description = "A sack of maize ready for selling!",
		client = {
			image = "maize_sack.png",
		}
	},

	["radioscanner"] = {
		label = "Radio Scanner",
		weight = 1000,
		stack = true,
		close = true,
		description = "With this you can get some police alerts. Not 100% effective however",
		client = {
			image = "radioscanner.png",
		}
	},

	["raw_steak"] = {
		label = "Raw Steak",
		weight = 20,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "raw_steak.png",
		}
	},

	["chair46"] = {
		label = "White Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair46.png",
		}
	},

	["potato_seed"] = {
		label = "Potato Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of seed potatoes!",
		client = {
			image = "potato_seed.png",
		}
	},

	["sparetire"] = {
		label = "Spare Tire",
		weight = 0,
		stack = false,
		close = false,
		description = "",
		client = {
			image = "sparetire.png",
		}
	},

	["tuna"] = {
		label = "Tuna",
		weight = 225,
		stack = true,
		close = true,
		description = "A breed of fish.",
		client = {
			image = "tuna.png",
		}
	},

	["chair107"] = {
		label = "Red Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair107.png",
		}
	},

	["farm_fertilizer"] = {
		label = "Fertilizer",
		weight = 1500,
		stack = true,
		close = false,
		description = "A bag of organic fertilizer!",
		client = {
			image = "farm_fertilizer.png",
		}
	},

	["livery"] = {
		label = "Livery Roll",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "livery.png",
		}
	},

	["weed_nutrition"] = {
		label = "Plant Fertilizer",
		weight = 2000,
		stack = true,
		close = true,
		description = "Plant nutrition",
		client = {
			image = "weed_nutrition.png",
		}
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 500,
		stack = true,
		close = true,
		description = "Some fine smelling buds.",
		client = {
			image = "marijuana.png",
		}
	},

	["goldbar"] = {
		label = "Gold Bar",
		weight = 7000,
		stack = true,
		close = true,
		description = "Looks pretty expensive to me",
		client = {
			image = "goldbar.png",
		}
	},

	["painkillers"] = {
		label = "Painkillers",
		weight = 0,
		stack = true,
		close = true,
		description = "For pain you can't stand anymore, take this pill that'd make you feel great again",
		client = {
			image = "painkillers.png",
		}
	},

	["newsmic"] = {
		label = "News Microphone",
		weight = 100,
		stack = false,
		close = true,
		description = "A microphone for the news",
		client = {
			image = "newsmic.png",
		}
	},

	["black_phone"] = {
		label = "Black Phone",
		weight = 700,
		stack = false,
		close = false,
		description = "Neat phone ya got there",
		client = {
			image = "phone.png",
		}
	},

	["brushcamo_attachment"] = {
		label = "Brushstroke Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A brushstroke camo for a weapon",
		client = {
			image = "brushcamo_attachment.png",
		}
	},

	["meat_chickenhawk"] = {
		label = "Chickenhawk Meat",
		weight = 400,
		stack = true,
		close = true,
		description = "Chickenhawk meat!",
		client = {
			image = "meat_chickenhawk.png",
		}
	},

	["methtray"] = {
		label = "Meth Tray",
		weight = 200,
		stack = true,
		close = false,
		description = "make some meth",
		client = {
			image = "meth_tray.png",
		}
	},

	["gatecrack"] = {
		label = "Gatecrack",
		weight = 0,
		stack = true,
		close = true,
		description = "Handy software to tear down some fences",
		client = {
			image = "usb_device.png",
		}
	},

	["bucket"] = {
		label = "Bucket",
		weight = 100,
		stack = true,
		close = false,
		description = "A empty bucket!",
		client = {
			image = "bucket.png",
		}
	},

	["chair65"] = {
		label = "Posh Lounger",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair65.png",
		}
	},

	["chair30"] = {
		label = "Light Grey Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair30.png",
		}
	},

	["cactusfruit_crate"] = {
		label = "Cactus Fruit Crate",
		weight = 3500,
		stack = true,
		close = false,
		description = "A crate of cactus fruits ready for selling!",
		client = {
			image = "cactusfruit_crate.png",
		}
	},

	["chair93"] = {
		label = "Brown Luxury Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair93.png",
		}
	},

	["car_armor"] = {
		label = "Vehicle Armor",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "armour.png",
		}
	},

	["veh_brakes"] = {
		label = "Brakes",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle brakes",
		client = {
			image = "veh_brakes.png",
		}
	},

	["uncut_emerald"] = {
		label = "Uncut Emerald",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Emerald",
		client = {
			image = "uncut_emerald.png",
		}
	},

	["horn"] = {
		label = "Custom Vehicle Horn",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "horn.png",
		}
	},

	["trout"] = {
		label = "Trout",
		weight = 85,
		stack = true,
		close = true,
		description = "A breed of fish.",
		client = {
			image = "trout.png",
		}
	},

	["chair96"] = {
		label = "Light Brown Metal Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair96.png",
		}
	},

	["goldingot"] = {
		label = "Gold Ingot",
		weight = 1000,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "goldingot.png",
		}
	},

	["moonshine"] = {
		label = "Moonshine",
		weight = 500,
		stack = true,
		close = false,
		description = "A bottle of moonshine!",
		client = {
			image = "moonshine.png",
		}
	},

	["skin_dolphin"] = {
		label = "Dolphin Skin",
		weight = 850,
		stack = true,
		close = true,
		description = "Dolphin skin. Highly illegal!",
		client = {
			image = "skin_dolphin.png",
		}
	},

	["meth_bag"] = {
		label = "Meth Bag",
		weight = 1000,
		stack = true,
		close = false,
		description = "Plastic bag with magic stuff!",
		client = {
			image = "meth_bag.png",
		}
	},

	["turbo"] = {
		label = "Supercharger Turbo",
		weight = 0,
		stack = false,
		close = true,
		description = "Who doesn't need a 65mm Turbo??",
		client = {
			image = "turbo.png",
		}
	},

	["emptycrate"] = {
		label = "Crate",
		weight = 100,
		stack = true,
		close = false,
		description = "A empty crate for storing things!",
		client = {
			image = "emptycrate.png",
		}
	},

	["poppyplant"] = {
		label = "Poppy Plant",
		weight = 30,
		stack = true,
		close = false,
		description = "Very nice plant!",
		client = {
			image = "poppyplant.png",
		}
	},

	["plant_tub"] = {
		label = "Plant Tub",
		weight = 1000,
		stack = true,
		close = false,
		description = "Pot for planting plants",
		client = {
			image = "plant_tub.png",
		}
	},

	["id_card"] = {
		label = "ID Card",
		weight = 0,
		stack = false,
		close = false,
		description = "A card containing all your information to identify yourself",
		client = {
			image = "id_card.png",
		}
	},

	["cm3"] = {
		label = "Casino Membership",
		weight = 1000,
		stack = false,
		close = true,
		description = "Casino Membership Tier 3",
		client = {
			image = "diamondmembership.png",
		}
	},

	["skin_cow"] = {
		label = "Cow Hide",
		weight = 1250,
		stack = true,
		close = true,
		description = "Cow hide.",
		client = {
			image = "skin_cow.png",
		}
	},

	["veh_wheels"] = {
		label = "Wheels",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle wheels",
		client = {
			image = "veh_wheels.png",
		}
	},

	["barrel_attachment"] = {
		label = "Barrel",
		weight = 1000,
		stack = true,
		close = true,
		description = "A barrel for a weapon",
		client = {
			image = "barrel_attachment.png",
		}
	},

	["luxuryfinish_attachment"] = {
		label = "Luxury Finish",
		weight = 1000,
		stack = true,
		close = true,
		description = "A luxury finish for a weapon",
		client = {
			image = "luxuryfinish_attachment.png",
		}
	},

	["emerald_ring_silver"] = {
		label = "Emerald Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_ring_silver.png",
		}
	},

	["drifttires"] = {
		label = "Drift Tires",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "drifttires.png",
		}
	},

	["coyote"] = {
		label = "Coyote",
		weight = 500,
		stack = false,
		close = true,
		description = "Coyote is your royal companion!",
		client = {
			image = "A_C_Coyote.png",
		}
	},

	["pencil"] = {
		label = "Pencil",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "pencil.png",
		}
	},

	["growler"] = {
		label = "Growler",
		weight = 100,
		stack = true,
		close = false,
		description = "A empty growler!",
		client = {
			image = "growler.png",
		}
	},

	["emptymilkbottle"] = {
		label = "Empty Milk Bottle",
		weight = 100,
		stack = true,
		close = false,
		description = "A empty milk bottle!",
		client = {
			image = "emptymilkbottle.png",
		}
	},

	["chair16"] = {
		label = "White Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair16.png",
		}
	},

	["chair67"] = {
		label = "White Metal Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair67.png",
		}
	},

	["chair37"] = {
		label = "Dark Brown Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair37.png",
		}
	},

	["antipatharia_coral"] = {
		label = "Antipatharia",
		weight = 1000,
		stack = true,
		close = true,
		description = "Its also known as black corals or thorn corals",
		client = {
			image = "antipatharia_coral.png",
		}
	},

	["chair12"] = {
		label = "Used Brown Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair12.png",
		}
	},

	["meth_emptysacid"] = {
		label = "Empty Canister",
		weight = 2000,
		stack = true,
		close = false,
		description = "Material: Plastic, Good for Sodium Benzoate",
		client = {
			image = "meth_emptysacid.png",
		}
	},

	["newsbmic"] = {
		label = "Boom Microphone",
		weight = 100,
		stack = false,
		close = true,
		description = "A Useable BoomMic",
		client = {
			image = "newsbmic.png",
		}
	},

	["romantic_book"] = {
		label = "Romantic book",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "romantic_book.png",
		}
	},

	["pineapple"] = {
		label = "Pineapple",
		weight = 100,
		stack = true,
		close = false,
		description = "Lemon!",
		client = {
			image = "pineapple.png",
		}
	},

	["samsungphone"] = {
		label = "Samsung S10",
		weight = 1000,
		stack = true,
		close = true,
		description = "Very expensive phone",
		client = {
			image = "samsungphone.png",
		}
	},

	["mushroom_sack"] = {
		label = "Mushroom Sack",
		weight = 5000,
		stack = true,
		close = false,
		description = "A sack of mushrooms ready for selling!",
		client = {
			image = "mushroom_sack.png",
		}
	},

	["chair36"] = {
		label = "Comfy Ergonomic Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair36.png",
		}
	},

	["chair27"] = {
		label = "Black Leather Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair27.png",
		}
	},

	["sandwich"] = {
		label = "Sandwich",
		weight = 200,
		stack = true,
		close = true,
		description = "Nice bread for your stomach",
		client = {
			image = "sandwich.png",
		}
	},

	["tires"] = {
		label = "Drift Smoke Tires",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "tires.png",
		}
	},

	["chair2"] = {
		label = "Wood Lounger",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair2.png",
		}
	},

	["house_locator"] = {
		label = "House locator",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "house_locator.png",
		}
	},

	["tactical_muzzle_brake"] = {
		label = "Tactical Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brakee for a weapon",
		client = {
			image = "tactical_muzzle_brake.png",
		}
	},

	["console"] = {
		label = "Console",
		weight = 85,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "console.png",
		}
	},

	["weaponlicense"] = {
		label = "Weapon License",
		weight = 0,
		stack = false,
		close = true,
		description = "Weapon License",
		client = {
			image = "weapon_license.png",
		}
	},

	["toiletry"] = {
		label = "Toiletry",
		weight = 10,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "toiletry.png",
		}
	},

	["chair24"] = {
		label = "Old White Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair24.png",
		}
	},

	["sapphire_ring"] = {
		label = "Sapphire Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_ring.png",
		}
	},

	["rollcage"] = {
		label = "Roll Cage",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "rollcage.png",
		}
	},

	["transmission3"] = {
		label = "Tier 3 Transmission",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "transmission3.png",
		}
	},

	["coke_figure"] = {
		label = "Action Figure",
		weight = 150,
		stack = true,
		close = false,
		description = "Action Figure of the cartoon superhero Impotent Rage",
		client = {
			image = "coke_figure.png",
		}
	},

	["meth_sharp"] = {
		label = "Tray with smashed meth",
		weight = 1000,
		stack = true,
		close = false,
		description = "Can be packed",
		client = {
			image = "meth_sharp.png",
		}
	},

	["containergreensmall"] = {
		label = "Small Green Container",
		weight = 5000,
		stack = false,
		close = true,
		description = "Small Green Container",
		client = {
			image = "container_green_small.png",
		}
	},

	["veh_neons"] = {
		label = "Neons",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle neons",
		client = {
			image = "veh_neons.png",
		}
	},

	["skin_shark"] = {
		label = "Shark Skin",
		weight = 1750,
		stack = true,
		close = true,
		description = "Shark skin. Highly illegal!",
		client = {
			image = "skin_shark.png",
		}
	},

	["chair80"] = {
		label = "Orange Louncher",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair80.png",
		}
	},

	["policegunrack"] = {
		label = "Police Gun Rack",
		weight = 15000,
		stack = true,
		close = true,
		description = "Gun rack for police vehicles",
		client = {
			image = "policegunrack.png",
		}
	},

	["hairdryer"] = {
		label = "Hairdryer",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "hairdryer.png",
		}
	},

	["filled_evidence_bag"] = {
		label = "Evidence Bag",
		weight = 200,
		stack = false,
		close = false,
		description = "A filled evidence bag to see who committed the crime >:(",
		client = {
			image = "evidence.png",
		}
	},

	["squared_muzzle_brake"] = {
		label = "Squared Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "squared_muzzle_brake.png",
		}
	},

	["hood"] = {
		label = "Vehicle Hood",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "hood.png",
		}
	},

	["retriever"] = {
		label = "Retriever",
		weight = 500,
		stack = false,
		close = true,
		description = "Retriever is your royal companion!",
		client = {
			image = "A_C_Retriever.png",
		}
	},

	["jerry_can"] = {
		label = "Jerrycan 20L",
		weight = 20000,
		stack = true,
		close = true,
		description = "A can full of Fuel",
		client = {
			image = "jerry_can.png",
		}
	},

	["peyote"] = {
		label = "Peyote",
		weight = 30,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "peyote.png",
		}
	},

	["npc_phone"] = {
		label = "Phone",
		weight = 10,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "npc_phone.png",
		}
	},

	["veh_armor"] = {
		label = "Armor",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle armor",
		client = {
			image = "veh_armor.png",
		}
	},

	["nos"] = {
		label = "NOS Bottle",
		weight = 0,
		stack = false,
		close = true,
		description = "A full bottle of NOS",
		client = {
			image = "nos.png",
		}
	},

	["heroin"] = {
		label = "Heroin",
		weight = 500,
		stack = true,
		close = false,
		description = "Really addictive depressant...",
		client = {
			image = "heroin.png",
		}
	},

	["milk"] = {
		label = "Milk",
		weight = 250,
		stack = true,
		close = false,
		description = "A bottle of fresh milk!",
		client = {
			image = "milk.png",
		}
	},

	["meat_dolphin"] = {
		label = "Dolphin Meat",
		weight = 850,
		stack = true,
		close = true,
		description = "Dolphin meat!",
		client = {
			image = "meat_dolphin.png",
		}
	},

	["ruby"] = {
		label = "Ruby",
		weight = 100,
		stack = true,
		close = false,
		description = "A Ruby that shimmers",
		client = {
			image = "ruby.png",
		}
	},

	["lsa"] = {
		label = "LSA",
		weight = 500,
		stack = true,
		close = false,
		description = "Almost ready to party...",
		client = {
			image = "lsa.png",
		}
	},

	["10kgoldchain"] = {
		label = "10k Gold Chain",
		weight = 2000,
		stack = true,
		close = true,
		description = "10 carat golden chain",
		client = {
			image = "10kgoldchain.png",
		}
	},

	["maize_seed"] = {
		label = "Maize Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of maize seeds!",
		client = {
			image = "maize_seed.png",
		}
	},

	["coke_leaf"] = {
		label = "Coca leaves",
		weight = 15,
		stack = true,
		close = false,
		description = "Leaf from amazing plant",
		client = {
			image = "coca_leaf.png",
		}
	},

	["coconut"] = {
		label = "Coconut",
		weight = 100,
		stack = true,
		close = false,
		description = "Coconut!",
		client = {
			image = "coconut.png",
		}
	},

	["egg_crate"] = {
		label = "Egg Crate",
		weight = 2500,
		stack = true,
		close = false,
		description = "A crate of eggs ready for selling!",
		client = {
			image = "egg_crate.png",
		}
	},

	["coke_figurebroken"] = {
		label = "Pieces of Action Figure",
		weight = 100,
		stack = true,
		close = false,
		description = "You can throw this away or try to repair with glue",
		client = {
			image = "coke_figurebroken.png",
		}
	},

	["skullcamo_attachment"] = {
		label = "Skull Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A skull camo for a weapon",
		client = {
			image = "skullcamo_attachment.png",
		}
	},

	["firework1"] = {
		label = "2Brothers",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework1.png",
		}
	},

	["meat_stingray"] = {
		label = "Stingray Meat",
		weight = 700,
		stack = true,
		close = true,
		description = "Stingray meat!",
		client = {
			image = "meat_stingray.png",
		}
	},

	["weed_brick"] = {
		label = "Weed Brick",
		weight = 1000,
		stack = true,
		close = true,
		description = "1KG Weed Brick to sell to large customers.",
		client = {
			image = "weed_brick.png",
		}
	},

	["chair69"] = {
		label = "Dark Material Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair69.png",
		}
	},

	["nvscope_attachment"] = {
		label = "Night Vision Scope",
		weight = 1000,
		stack = true,
		close = true,
		description = "A night vision scope for a weapon",
		client = {
			image = "nvscope_attachment.png",
		}
	},

	["poppyresin"] = {
		label = "Poppy resin",
		weight = 2000,
		stack = true,
		close = false,
		description = "It sticks to your fingers when you handle it.",
		client = {
			image = "poppyresin.png",
		}
	},

	["notepad"] = {
		label = "Notepad",
		weight = 5,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "notepad.png",
		}
	},

	["petgroomingkit"] = {
		label = "Pet Grooming Kit",
		weight = 1000,
		stack = false,
		close = true,
		description = "Pet Grooming Kit",
		client = {
			image = "petgroomingkit.png",
		}
	},

	["police_stormram"] = {
		label = "Stormram",
		weight = 18000,
		stack = true,
		close = true,
		description = "A nice tool to break into doors",
		client = {
			image = "police_stormram.png",
		}
	},

	["rolex"] = {
		label = "Golden Watch",
		weight = 1500,
		stack = true,
		close = true,
		description = "A golden watch seems like the jackpot to me!",
		client = {
			image = "rolex.png",
		}
	},

	["mechanic_tools"] = {
		label = "Mechanic tools",
		weight = 0,
		stack = false,
		close = true,
		description = "Needed for vehicle repairs",
		client = {
			image = "mechanic_tools.png",
		}
	},

	["ruby_ring_silver"] = {
		label = "Ruby Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_ring_silver.png",
		}
	},

	["laptop2"] = {
		label = "Stolen Laptop",
		weight = 4000,
		stack = true,
		close = true,
		description = "Expensive laptop",
		client = {
			image = "laptop.png",
		}
	},

	["lsd"] = {
		label = "LSD",
		weight = 500,
		stack = true,
		close = false,
		description = "Lets get this party started!",
		client = {
			image = "lsd.png",
		}
	},

	["collarpet"] = {
		label = "Pet collar",
		weight = 500,
		stack = true,
		close = true,
		description = "Rename your pets!",
		client = {
			image = "collarpet.png",
		}
	},

	["veh_plates"] = {
		label = "Plates",
		weight = 1000,
		stack = true,
		close = true,
		description = "Install vehicle plates",
		client = {
			image = "veh_plates.png",
		}
	},

	["sapphire_ring_silver"] = {
		label = "Sapphire Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_ring_silver.png",
		}
	},

	["payticket"] = {
		label = "Receipt",
		weight = 150,
		stack = true,
		close = false,
		description = "Cash these in at the bank!",
		client = {
			image = "ticket.png",
		}
	},

	["ruby_earring"] = {
		label = "Ruby Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_earring.png",
		}
	},

	["iphone2"] = {
		label = "Stolen iPhone",
		weight = 1000,
		stack = true,
		close = true,
		description = "Very expensive phone",
		client = {
			image = "iphone.png",
		}
	},

	["liquidmix"] = {
		label = "Liquid Chem Mix",
		weight = 1500,
		stack = true,
		close = false,
		description = "Chemicals, handle with care!",
		client = {
			image = "liquidmix.png",
		}
	},

	["veh_turbo"] = {
		label = "Turbo",
		weight = 1000,
		stack = true,
		close = true,
		description = "Install vehicle turbo",
		client = {
			image = "veh_turbo.png",
		}
	},

	["weed_joint"] = {
		label = "Joint",
		weight = 50,
		stack = true,
		close = false,
		description = "Enjoy your weed!",
		client = {
			image = "weed_joint.png",
		}
	},

	["chair25"] = {
		label = "Red Plastic Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair25.png",
		}
	},

	["milk_pail"] = {
		label = "Milk Pail",
		weight = 1000,
		stack = true,
		close = false,
		description = "Fresh milk, straight from the cow!",
		client = {
			image = "milk_pail.png",
		}
	},

	["grip_attachment"] = {
		label = "Grip",
		weight = 1000,
		stack = true,
		close = true,
		description = "A grip for a weapon",
		client = {
			image = "grip_attachment.png",
		}
	},

	["chair62"] = {
		label = "Green Camping Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair62.png",
		}
	},

	["lsd1"] = {
		label = "LSD",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "lsd1.png",
		}
	},

	["meat_cow"] = {
		label = "Beef Meat",
		weight = 1000,
		stack = true,
		close = true,
		description = "Cow meat!",
		client = {
			image = "meat_cow.png",
		}
	},

	["thermalscope_attachment"] = {
		label = "Thermal Scope",
		weight = 1000,
		stack = true,
		close = true,
		description = "A thermal scope for a weapon",
		client = {
			image = "thermalscope_attachment.png",
		}
	},

	["twerks_candy"] = {
		label = "Twerks",
		weight = 100,
		stack = true,
		close = true,
		description = "Some delicious candy :O",
		client = {
			image = "twerks_candy.png",
		}
	},

	["ifaks"] = {
		label = "ifaks",
		weight = 200,
		stack = true,
		close = true,
		description = "ifaks for healing and a complete stress remover.",
		client = {
			image = "ifaks.png",
		}
	},

	["iron"] = {
		label = "Iron",
		weight = 100,
		stack = true,
		close = false,
		description = "Handy piece of metal that you can probably use for something",
		client = {
			image = "iron.png",
		}
	},

	["weed_ak47"] = {
		label = "AK47 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g AK47",
		client = {
			image = "weed_baggy.png",
		}
	},

	["barley_seed"] = {
		label = "Barley Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of barley seeds!",
		client = {
			image = "barley_seed.png",
		}
	},

	["fishbait"] = {
		label = "Fishing Bait",
		weight = 5,
		stack = true,
		close = true,
		description = "With a fishing rod this can catch some fish.",
		client = {
			image = "fishbait.png",
		}
	},

	["diving_gear"] = {
		label = "Diving Gear",
		weight = 30000,
		stack = false,
		close = true,
		description = "An oxygen tank and a rebreather",
		client = {
			image = "diving_gear.png",
		}
	},

	["meth_amoniak"] = {
		label = "Ammonia",
		weight = 1000,
		stack = true,
		close = false,
		description = "Warning! Dangerous Chemicals!",
		client = {
			image = "meth_amoniak.png",
		}
	},

	["chair9"] = {
		label = "Standard Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair9.png",
		}
	},

	["bottle"] = {
		label = "Empty Bottle",
		weight = 10,
		stack = true,
		close = false,
		description = "A glass bottle",
		client = {
			image = "bottle.png",
		}
	},

	["goldchain"] = {
		label = "Golden Chain",
		weight = 1500,
		stack = true,
		close = true,
		description = "A golden chain seems like the jackpot to me!",
		client = {
			image = "goldchain.png",
		}
	},

	["chair18"] = {
		label = "Blue Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair18.png",
		}
	},

	["transmission1"] = {
		label = "Tier 1 Transmission",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "transmission1.png",
		}
	},

	["xanaxplate"] = {
		label = "Xanax Plate",
		weight = 30,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "xanaxplate.png",
		}
	},

	["blueberry"] = {
		label = "Blueberry",
		weight = 100,
		stack = true,
		close = false,
		description = "Blueberry!",
		client = {
			image = "blueberry.png",
		}
	},

	["veh_tint"] = {
		label = "Tints",
		weight = 1000,
		stack = true,
		close = true,
		description = "Install vehicle tint",
		client = {
			image = "veh_tint.png",
		}
	},

	["goldore"] = {
		label = "Gold Ore",
		weight = 1000,
		stack = true,
		close = false,
		description = "Gold Ore",
		client = {
			image = "goldore.png",
		}
	},

	["chair39"] = {
		label = "Striped Wicker Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair39.png",
		}
	},

	["chair56"] = {
		label = "Old Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair56.png",
		}
	},

	["paintcan"] = {
		label = "Vehicle Spray Can",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "spraycan.png",
		}
	},

	["mdtcitation"] = {
		label = "Citation",
		weight = 1000,
		stack = false,
		close = true,
		description = "Citation from a police officer!",
		client = {
			image = "citation.png",
		}
	},

	["poodle"] = {
		label = "Poodle",
		weight = 500,
		stack = false,
		close = true,
		description = "Poodle is your royal companion!",
		client = {
			image = "A_C_Poodle.png",
		}
	},

	["tirerepairkit"] = {
		label = "Tire Repair Kit",
		weight = 1000,
		stack = true,
		close = true,
		description = "A kit to repair your tires",
		client = {
			image = "tirerepairkit.png",
		}
	},

	["vodka_ferm"] = {
		label = "Fermented Vodka",
		weight = 5000,
		stack = true,
		close = false,
		description = "A bucket of fermented vodka!",
		client = {
			image = "vodka_ferm.png",
		}
	},

	["methkey"] = {
		label = "Key A",
		weight = 200,
		stack = true,
		close = false,
		description = "Random Key, with \"Walter\" Engraved on the Back...",
		client = {
			image = "keya.png",
		}
	},

	["lsd3"] = {
		label = "LSD",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "lsd3.png",
		}
	},

	["lsd5"] = {
		label = "LSD",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "lsd5.png",
		}
	},

	["weed_amnesia_seed"] = {
		label = "Amnesia Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of Amnesia",
		client = {
			image = "weed_seed.png",
		}
	},

	["walkstick"] = {
		label = "Walking Stick",
		weight = 1000,
		stack = true,
		close = true,
		description = "Walking stick for ya'll grannies out there.. HAHA",
		client = {
			image = "walkstick.png",
		}
	},

	["cherry"] = {
		label = "Cherry",
		weight = 100,
		stack = true,
		close = false,
		description = "Cherry!",
		client = {
			image = "cherry.png",
		}
	},

	["firework2"] = {
		label = "Poppelers",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework2.png",
		}
	},

	["chair63"] = {
		label = "Blue Camping Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair63.png",
		}
	},

	["harness"] = {
		label = "Race Harness",
		weight = 1000,
		stack = false,
		close = true,
		description = "Racing Harness so no matter what you stay in the car",
		client = {
			image = "harness.png",
		}
	},

	["barley"] = {
		label = "Barley",
		weight = 100,
		stack = true,
		close = false,
		description = "Barley!",
		client = {
			image = "barley.png",
		}
	},

	["cactusfruit"] = {
		label = "Cactus Fruit",
		weight = 100,
		stack = true,
		close = false,
		description = "Cactus Fruit!",
		client = {
			image = "cactusfruit.png",
		}
	},

	["ecstasy5"] = {
		label = "Ectasy",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "ecstasy5.png",
		}
	},

	["empty_watering_can"] = {
		label = "Empty Watering Can",
		weight = 500,
		stack = false,
		close = true,
		description = "Empty watering can",
		client = {
			image = "watering_can.png",
		}
	},

	["containerbluemid"] = {
		label = "Mid Blue Container",
		weight = 5000,
		stack = false,
		close = true,
		description = "Small Green Container",
		client = {
			image = "container_blue_mid.png",
		}
	},

	["aluminumoxide"] = {
		label = "Aluminium Powder",
		weight = 100,
		stack = true,
		close = false,
		description = "Some powder to mix with",
		client = {
			image = "aluminumoxide.png",
		}
	},

	["ruby_ring"] = {
		label = "Ruby Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_ring.png",
		}
	},

	["emerald_ring"] = {
		label = "Emerald Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_ring.png",
		}
	},

	["chair75"] = {
		label = "Oak Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair75.png",
		}
	},

	["coffemachine"] = {
		label = "Coffe machine",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "coffemachine.png",
		}
	},

	["westy"] = {
		label = "Westy",
		weight = 500,
		stack = false,
		close = true,
		description = "Westy is your royal companion!",
		client = {
			image = "A_C_Westy.png",
		}
	},

	["syphoningkit"] = {
		label = "Syphoning Kit",
		weight = 5000,
		stack = false,
		close = false,
		description = "A kit made to siphon gasoline from vehicles.",
		client = {
			image = "syphoningkit.png",
		}
	},

	["pickaxe"] = {
		label = "Pickaxe",
		weight = 1000,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "pickaxe.png",
		}
	},

	["containerwhitemid"] = {
		label = "Mid White Container",
		weight = 5000,
		stack = false,
		close = true,
		description = "Small Green Container",
		client = {
			image = "container_white_mid.png",
		}
	},

	["suspension5"] = {
		label = "Tier 5 Suspension",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "suspension5.png",
		}
	},

	["screwdriverset"] = {
		label = "Toolkit",
		weight = 1000,
		stack = true,
		close = false,
		description = "Very useful to screw... screws...",
		client = {
			image = "screwdriverset.png",
		}
	},

	["chair99"] = {
		label = "Gamer Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair99.png",
		}
	},

	["lettuce"] = {
		label = "Lettuce",
		weight = 100,
		stack = true,
		close = false,
		description = "Lettuce!",
		client = {
			image = "lettuce.png",
		}
	},

	["bellend_muzzle_brake"] = {
		label = "Bellend Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "bellend_muzzle_brake.png",
		}
	},

	["sapphire_necklace"] = {
		label = "Sapphire Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_necklace.png",
		}
	},

	["digicamo_attachment"] = {
		label = "Digital Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A digital camo for a weapon",
		client = {
			image = "digicamo_attachment.png",
		}
	},

	["chair54"] = {
		label = "Old Wooden Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair54.png",
		}
	},

	["yeast"] = {
		label = "Yeast",
		weight = 100,
		stack = true,
		close = false,
		description = "A packet of yeast!",
		client = {
			image = "yeast.png",
		}
	},

	["lsd4"] = {
		label = "LSD",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "lsd4.png",
		}
	},

	["chair29"] = {
		label = "Blue Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair29.png",
		}
	},

	["coke_pure"] = {
		label = "Pure Coke",
		weight = 70,
		stack = true,
		close = true,
		description = "Coke without any dirty particles",
		client = {
			image = "coke_pure.png",
		}
	},

	["carbon"] = {
		label = "Carbon",
		weight = 1000,
		stack = true,
		close = false,
		description = "Carbon, a base ore.",
		client = {
			image = "carbon.png",
		}
	},

	["meat_cormorant"] = {
		label = "Cormorant Meat",
		weight = 400,
		stack = true,
		close = true,
		description = "Cormorant meat!",
		client = {
			image = "meat_cormorant.png",
		}
	},

	["veh_suspension"] = {
		label = "Suspension",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle suspension",
		client = {
			image = "veh_suspension.png",
		}
	},

	["ecstasy1"] = {
		label = "Ectasy",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "ecstasy1.png",
		}
	},

	["blueprint_document"] = {
		label = "Blueprint",
		weight = 100,
		stack = false,
		close = false,
		description = "A blueprint document that help you craft.",
		client = {
			image = "blueprint_document.png",
		}
	},

	["toolbox"] = {
		label = "Toolbox",
		weight = 0,
		stack = false,
		close = true,
		description = "Needed for Performance part removal",
		client = {
			image = "toolbox.png",
		}
	},

	["walkingmansign"] = {
		label = "Pedestrian Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "Pedestrian Sign",
		client = {
			image = "walkingmansign.png",
		}
	},

	["gunrackkey"] = {
		label = "Police Gun Key",
		weight = 500,
		stack = true,
		close = true,
		description = "A key to open gun rack",
		client = {
			image = "gunrackkey.png",
		}
	},

	["chair23"] = {
		label = "Posh White Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair23.png",
		}
	},

	["snikkel_candy"] = {
		label = "Snikkel",
		weight = 100,
		stack = true,
		close = true,
		description = "Some delicious candy :O",
		client = {
			image = "snikkel_candy.png",
		}
	},

	["skin_pig"] = {
		label = "Pig Skin",
		weight = 850,
		stack = true,
		close = true,
		description = "Pig skin.",
		client = {
			image = "skin_pig.png",
		}
	},

	["weedplant_weed"] = {
		label = "Dried Weed",
		weight = 100,
		stack = true,
		close = false,
		description = "Weed ready for packaging",
		client = {
			image = "weedplant_weed.png",
		}
	},

	["kurkakola"] = {
		label = "Cola",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "cola.png",
		}
	},

	["soap"] = {
		label = "Soap",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "soap.png",
		}
	},

	["skirts"] = {
		label = "Vehicle Skirts",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "skirts.png",
		}
	},

	["grapejuice"] = {
		label = "Grape Juice",
		weight = 200,
		stack = true,
		close = false,
		description = "Grape juice is said to be healthy",
		client = {
			image = "grapejuice.png",
		}
	},

	["rottweiler"] = {
		label = "Rottweiler",
		weight = 500,
		stack = false,
		close = true,
		description = "Rottweiler is your royal companion!",
		client = {
			image = "A_Rottweiler.png",
		}
	},

	["drill"] = {
		label = "Drill",
		weight = 20000,
		stack = true,
		close = false,
		description = "The real deal...",
		client = {
			image = "drill.png",
		}
	},

	["woodcamo_attachment"] = {
		label = "Woodland Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A woodland camo for a weapon",
		client = {
			image = "woodcamo_attachment.png",
		}
	},

	["meat_coyote"] = {
		label = "Coyote Meat",
		weight = 700,
		stack = true,
		close = true,
		description = "Coyote meat!",
		client = {
			image = "meat_coyote.png",
		}
	},

	["peyote_button"] = {
		label = "Peyote Button",
		weight = 20,
		stack = true,
		close = false,
		description = "A handful of peyote buttons!",
		client = {
			image = "peyote_button.png",
		}
	},

	["firstaidforpet"] = {
		label = "First aid for pet",
		weight = 500,
		stack = true,
		close = true,
		description = "Revive your pet!",
		client = {
			image = "firstaidforpet.png",
		}
	},

	["vodka"] = {
		label = "Vodka",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "vodka.png",
		}
	},

	["chair17"] = {
		label = "Green Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair17.png",
		}
	},

	["oilbarell"] = {
		label = "Oil barell",
		weight = 15000,
		stack = false,
		close = true,
		description = "Oil Barrel",
		client = {
			image = "oilBarrel.png",
		}
	},

	["skin_deer"] = {
		label = "Deer Hide",
		weight = 950,
		stack = true,
		close = true,
		description = "Deer hide.",
		client = {
			image = "skin_deer.png",
		}
	},

	["containerboltcutter"] = {
		label = "Boltcutter",
		weight = 1000,
		stack = false,
		close = false,
		description = "a boltcutter to open containers by police",
		client = {
			image = "boltcutter.png",
		}
	},

	["scrap"] = {
		label = "Scrap Metal",
		weight = 20,
		stack = true,
		close = false,
		description = "Great for carfting",
		client = {
			image = "scrap.png",
		}
	},

	["tomato"] = {
		label = "Tomato",
		weight = 100,
		stack = true,
		close = false,
		description = "Tomato!",
		client = {
			image = "tomato.png",
		}
	},

	["moneybag"] = {
		label = "Money Bag",
		weight = 0,
		stack = false,
		close = true,
		description = "A bag with cash",
		client = {
			image = "moneybag.png",
		}
	},

	["lemon_crate"] = {
		label = "Lemon Crate",
		weight = 3500,
		stack = true,
		close = false,
		description = "A crate of lemons ready for selling!",
		client = {
			image = "lemon_crate.png",
		}
	},

	["roof"] = {
		label = "Vehicle Roof",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "roof.png",
		}
	},

	["plastic"] = {
		label = "Plastic",
		weight = 100,
		stack = true,
		close = false,
		description = "RECYCLE! - Greta Thunberg 2019",
		client = {
			image = "plastic.png",
		}
	},

	["diving_fill"] = {
		label = "Diving Tube",
		weight = 3000,
		stack = false,
		close = true,
		client = {
			image = "diving_tube.png",
		}
	},

	["meth"] = {
		label = "Meth",
		weight = 500,
		stack = true,
		close = false,
		description = "Really addictive stimulant...",
		client = {
			image = "meth.png",
		}
	},

	["iphone"] = {
		label = "iPhone",
		weight = 1000,
		stack = true,
		close = true,
		description = "Very expensive phone",
		client = {
			image = "iphone.png",
		}
	},

	["noscan"] = {
		label = "Empty NOS Bottle",
		weight = 0,
		stack = true,
		close = true,
		description = "An Empty bottle of NOS",
		client = {
			image = "noscan.png",
		}
	},

	["vodka_distill"] = {
		label = "Distilled Vodka",
		weight = 5000,
		stack = true,
		close = false,
		description = "A bucket of distilled vodka!",
		client = {
			image = "vodka_distill.png",
		}
	},

	["timingchain"] = {
		label = "Timing Chain",
		weight = 7000,
		stack = true,
		close = true,
		description = "Timing Chain",
		client = {
			image = "timing_chain.png",
		}
	},

	["weed_blunt"] = {
		label = "Blunt",
		weight = 90,
		stack = true,
		close = false,
		description = "Enjoy your weed!",
		client = {
			image = "weed_blunt.png",
		}
	},

	["tacobread"] = {
		label = "Taco Bread",
		weight = 1000,
		stack = true,
		close = true,
		description = "Taco Bread.",
		client = {
			image = "tacobread.png",
		}
	},

	["chair45"] = {
		label = "Dark Brown Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair45.png",
		}
	},

	["uncut_sapphire"] = {
		label = "Uncut Sapphire",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Sapphire",
		client = {
			image = "uncut_sapphire.png",
		}
	},

	["ecstasy4"] = {
		label = "Ectasy",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "ecstasy4.png",
		}
	},

	["weed_purplehaze"] = {
		label = "Purple Haze 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g Purple Haze",
		client = {
			image = "weed_baggy.png",
		}
	},

	["gold_bracelet"] = {
		label = "Gold bracelet",
		weight = 45,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "gold_bracelet.png",
		}
	},

	["chair10"] = {
		label = "Black Office Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair10.png",
		}
	},

	["toothpaste"] = {
		label = "Toothpaste",
		weight = 15,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "toothpaste.png",
		}
	},

	["clip_attachment"] = {
		label = "Clip",
		weight = 1000,
		stack = true,
		close = true,
		description = "A clip for a weapon",
		client = {
			image = "clip_attachment.png",
		}
	},

	["monitor"] = {
		label = "Monitor",
		weight = 50,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "monitor.png",
		}
	},

	["chair4"] = {
		label = "Old Metal Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair4.png",
		}
	},

	["10kgoldchain2"] = {
		label = "Stolen 10k Gold Chain",
		weight = 2000,
		stack = true,
		close = true,
		description = "10 carat golden chain",
		client = {
			image = "10kgoldchain.png",
		}
	},

	["chair71"] = {
		label = "Brown Lounger",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair71.png",
		}
	},

	["strawberry_seed"] = {
		label = "Strawberry Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of strawberry seeds!",
		client = {
			image = "strawberry_seed.png",
		}
	},

	["weedplant_seedf"] = {
		label = "Female Weed Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "Female Weed Seed",
		client = {
			image = "weedplant_seed.png",
		}
	},

	["diamond_earring_silver"] = {
		label = "Diamond Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_earring_silver.png",
		}
	},

	["apple_crate"] = {
		label = "Apple Crate",
		weight = 3500,
		stack = true,
		close = false,
		description = "A crate of apples ready for selling!",
		client = {
			image = "apple_crate.png",
		}
	},

	["chair35"] = {
		label = "Ergonomic Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair35.png",
		}
	},

	["spoiler"] = {
		label = "Vehicle Spoiler",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "spoiler.png",
		}
	},

	["security_card_02"] = {
		label = "Security Card B",
		weight = 0,
		stack = true,
		close = true,
		description = "A security card... I wonder what it goes to",
		client = {
			image = "security_card_02.png",
		}
	},

	["orange"] = {
		label = "Orange",
		weight = 100,
		stack = true,
		close = false,
		description = "Orange!",
		client = {
			image = "orange.png",
		}
	},

	["chair34"] = {
		label = "Red Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair34.png",
		}
	},

	["bprooftires"] = {
		label = "Bulletproof Tires",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "bprooftires.png",
		}
	},

	["water_bottle"] = {
		label = "Bottle of Water",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "water_bottle.png",
		}
	},

	["metalscrap"] = {
		label = "Metal Scrap",
		weight = 100,
		stack = true,
		close = false,
		description = "You can probably make something nice out of this",
		client = {
			image = "metalscrap.png",
		}
	},

	["chair85"] = {
		label = "Wine Red Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair85.png",
		}
	},

	["trowel"] = {
		label = "Trowel",
		weight = 250,
		stack = true,
		close = false,
		description = "Perfect for your garden or for Coca plant",
		client = {
			image = "trowel.png",
		}
	},

	["chair82"] = {
		label = "Small Black Stool",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair82.png",
		}
	},

	["meth_syringe"] = {
		label = "Syringe",
		weight = 320,
		stack = true,
		close = false,
		description = "Enjoy your new crystal clear stuff!",
		client = {
			image = "meth_syringe.png",
		}
	},

	["sapphire_necklace_silver"] = {
		label = "Sapphire Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_necklace_silver.png",
		}
	},

	["meat_rabbit"] = {
		label = "Rabbit Meat",
		weight = 700,
		stack = true,
		close = true,
		description = "Rabbit meat!",
		client = {
			image = "meat_rabbit.png",
		}
	},

	["pug"] = {
		label = "Pug",
		weight = 500,
		stack = false,
		close = true,
		description = "Pug is your royal companion!",
		client = {
			image = "A_C_Pug.png",
		}
	},

	["chair40"] = {
		label = "Grey Leather Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair40.png",
		}
	},

	["bakingsoda"] = {
		label = "Baking Soda",
		weight = 1500,
		stack = true,
		close = false,
		description = "Household Baking Soda!",
		client = {
			image = "bakingsoda.png",
		}
	},

	["slanted_muzzle_brake"] = {
		label = "Slanted Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "slanted_muzzle_brake.png",
		}
	},

	["apple"] = {
		label = "Apple",
		weight = 100,
		stack = true,
		close = false,
		description = "Apple!",
		client = {
			image = "apple.png",
		}
	},

	["chair97"] = {
		label = "Plastic Lawn Chair 2",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair97.png",
		}
	},

	["zebracamo_attachment"] = {
		label = "Zebra Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A zebra camo for a weapon",
		client = {
			image = "zebracamo_attachment.png",
		}
	},

	["firework3"] = {
		label = "WipeOut",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework3.png",
		}
	},

	["chair106"] = {
		label = "Purple Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair106.png",
		}
	},

	["steel"] = {
		label = "Steel",
		weight = 100,
		stack = true,
		close = false,
		description = "Nice piece of metal that you can probably use for something",
		client = {
			image = "steel.png",
		}
	},

	["weed_purple-haze"] = {
		label = "Purple Haze 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g Purple Haze",
		client = {
			image = "weed_baggy.png",
		}
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1000,
		stack = true,
		close = true,
		description = "A diamond seems like the jackpot to me!",
		client = {
			image = "diamond.png",
		}
	},

	["steak"] = {
		label = "Steak",
		weight = 20,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "steak.png",
		}
	},

	["weed_wrap"] = {
		label = "Blunt Wraps",
		weight = 75,
		stack = true,
		close = false,
		description = "Get Weed Bag and roll blunt!",
		client = {
			image = "weed_wrap.png",
		}
	},

	["chair91"] = {
		label = "White Leather Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair91.png",
		}
	},

	["strawberry"] = {
		label = "Strawberry",
		weight = 100,
		stack = true,
		close = false,
		description = "Straqwberry!",
		client = {
			image = "strawberry.png",
		}
	},

	["cleaningkit"] = {
		label = "Cleaning Kit",
		weight = 250,
		stack = true,
		close = true,
		description = "A microfiber cloth with some soap will let your car sparkle again!",
		client = {
			image = "cleaningkit.png",
		}
	},

	["chair77"] = {
		label = "Yellow Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair77.png",
		}
	},

	["lemon"] = {
		label = "Lemon",
		weight = 100,
		stack = true,
		close = false,
		description = "Lemon!",
		client = {
			image = "lemon.png",
		}
	},

	["diamond_ring"] = {
		label = "Diamond Ring",
		weight = 1500,
		stack = true,
		close = true,
		description = "A diamond ring seems like the jackpot to me!",
		client = {
			image = "diamond_ring.png",
		}
	},

	["goldpan"] = {
		label = "Gold Panning Tray",
		weight = 10,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "goldpan.png",
		}
	},

	["meat_deer"] = {
		label = "Venison",
		weight = 850,
		stack = true,
		close = true,
		description = "Deer meat!",
		client = {
			image = "meat_deer.png",
		}
	},

	["stone"] = {
		label = "Stone",
		weight = 2000,
		stack = true,
		close = false,
		description = "Stone woo",
		client = {
			image = "stone.png",
		}
	},

	["customplate"] = {
		label = "Customized Plates",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "plate.png",
		}
	},

	["hack_laptop"] = {
		label = "Hacking Laptop",
		weight = 20,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "hack_laptop.png",
		}
	},

	["chair3"] = {
		label = "Metal Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair3.png",
		}
	},

	["wet_weed"] = {
		label = "Moist Weed",
		weight = 3000,
		stack = true,
		close = false,
		description = "Wet weed that needs to be treated!",
		client = {
			image = "wet_weed.png",
		}
	},

	["chair57"] = {
		label = "Purple Leather Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair57.png",
		}
	},

	["orange_crate"] = {
		label = "Orange Crate",
		weight = 3500,
		stack = true,
		close = false,
		description = "A crate of oranges ready for selling!",
		client = {
			image = "orange_crate.png",
		}
	},

	["sapphire_earring_silver"] = {
		label = "Sapphire Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_earring_silver.png",
		}
	},

	["weedplant_branch"] = {
		label = "Weed Branch",
		weight = 10000,
		stack = false,
		close = false,
		description = "Weed plant",
		client = {
			image = "weedplant_branch.png",
		}
	},

	["chair19"] = {
		label = "White Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair19.png",
		}
	},

	["meat_rat"] = {
		label = "Rat Meat",
		weight = 200,
		stack = true,
		close = true,
		description = "Rat meat!",
		client = {
			image = "meat_rat.png",
		}
	},

	["watering_can_full"] = {
		label = "Full Watering Can",
		weight = 500,
		stack = true,
		close = false,
		description = "A watering can full of water!",
		client = {
			image = "watering_can_full.png",
		}
	},

	["weed_amnesia"] = {
		label = "Amnesia 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g Amnesia",
		client = {
			image = "weed_baggy.png",
		}
	},

	["chair21"] = {
		label = "Metal Lawn Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair21.png",
		}
	},

	["trimming_scissors"] = {
		label = "Trimming Scissors",
		weight = 1500,
		stack = true,
		close = false,
		description = "Very Sharp Trimming Scissors",
		client = {
			image = "trimming_scissors.png",
		}
	},

	["hydrochloric_acid"] = {
		label = "Hydrochloric Acid",
		weight = 1500,
		stack = true,
		close = true,
		description = "Chemicals, handle with care!",
		client = {
			image = "hydrochloric_acid.png",
		}
	},

	["transmission4"] = {
		label = "Tier 4 Transmission",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "transmission4.png",
		}
	},

	["chair31"] = {
		label = "Black Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair31.png",
		}
	},

	["blueberry_crate"] = {
		label = "Blueberry Crate",
		weight = 2500,
		stack = true,
		close = false,
		description = "A crate of blueberries ready for selling!",
		client = {
			image = "blueberry_crate.png",
		}
	},

	["suspension1"] = {
		label = "Tier 1 Suspension",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "suspension1.png",
		}
	},

	["smallscope_attachment"] = {
		label = "Small Scope",
		weight = 1000,
		stack = true,
		close = true,
		description = "A small scope for a weapon",
		client = {
			image = "smallscope_attachment.png",
		}
	},

	["weed_og-kush_seed"] = {
		label = "OGKush Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of OG Kush",
		client = {
			image = "weed_seed.png",
		}
	},

	["cryptostick"] = {
		label = "Crypto Stick",
		weight = 200,
		stack = false,
		close = true,
		description = "Why would someone ever buy money that doesn't exist.. How many would it contain..?",
		client = {
			image = "cryptostick.png",
		}
	},

	["husky"] = {
		label = "Husky",
		weight = 500,
		stack = false,
		close = true,
		description = "Husky is your royal companion!",
		client = {
			image = "A_C_Husky.png",
		}
	},

	["chair7"] = {
		label = "Fancy Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair7.png",
		}
	},

	["crack"] = {
		label = "Crack",
		weight = 30,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "crack.png",
		}
	},

	["powder"] = {
		label = "Bag with powder",
		weight = 50,
		stack = true,
		close = false,
		description = "Good for discovering lasers that are not visible",
		client = {
			image = "powder.png",
		}
	},

	["blueberry_seed"] = {
		label = "Blueberry Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of blueberry seeds!",
		client = {
			image = "blueberry_seed.png",
		}
	},

	["xanaxpack"] = {
		label = "Xanax Pack",
		weight = 130,
		stack = true,
		close = true,
		description = "Explore a new universe!",
		client = {
			image = "xanaxpack.png",
		}
	},

	["plastic_bag"] = {
		label = "Plastic Bag",
		weight = 8,
		stack = true,
		close = false,
		description = "You can pack a lot of stuff here!",
		client = {
			image = "plastic_bag.png",
		}
	},

	["chair88"] = {
		label = "Black Deco Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair88.png",
		}
	},

	["milking_pail"] = {
		label = "Milking Pail",
		weight = 250,
		stack = true,
		close = false,
		description = "A milking pail for collecting milk!",
		client = {
			image = "milking_pail.png",
		}
	},

	["tacomeat"] = {
		label = "Taco Meat",
		weight = 1000,
		stack = true,
		close = true,
		description = "Taco Meat",
		client = {
			image = "tacomeat.png",
		}
	},

	["underglow_controller"] = {
		label = "Neon Controller",
		weight = 0,
		stack = true,
		close = true,
		description = "RGB LED Vehicle Remote",
		client = {
			image = "underglow_controller.png",
		}
	},

	["miningdrill"] = {
		label = "Mining Drill",
		weight = 1000,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "miningdrill.png",
		}
	},

	["chair50"] = {
		label = "Plastic Lawn Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair50.png",
		}
	},

	["weed_bud"] = {
		label = "Weed Bud",
		weight = 40,
		stack = true,
		close = false,
		description = "Needs to be clean at the table",
		client = {
			image = "weed_bud.png",
		}
	},

	["flashlight_attachment"] = {
		label = "Flashlight",
		weight = 1000,
		stack = true,
		close = true,
		description = "A flashlight for a weapon",
		client = {
			image = "flashlight_attachment.png",
		}
	},

	["watch"] = {
		label = "Watch",
		weight = 35,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "watch.png",
		}
	},

	["necklace"] = {
		label = "Necklace",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "necklace.png",
		}
	},

	["sessantacamo_attachment"] = {
		label = "Sessanta Nove Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A sessanta nove camo for a weapon",
		client = {
			image = "sessantacamo_attachment.png",
		}
	},

	["chair110"] = {
		label = "Black Metal Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair110.png",
		}
	},

	["dj_deck"] = {
		label = "DJ Deck",
		weight = 95,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "dj_deck.png",
		}
	},

	["weed_og-kush"] = {
		label = "OGKush 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g OG Kush",
		client = {
			image = "weed_baggy.png",
		}
	},

	["chair95"] = {
		label = "Dark Brown Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair95.png",
		}
	},

	["weed_purple-haze_seed"] = {
		label = "Purple Haze Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of Purple Haze",
		client = {
			image = "weed_seed.png",
		}
	},

	["chair84"] = {
		label = "Orange Deco Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair84.png",
		}
	},

	["weed_access"] = {
		label = "Access Card",
		weight = 50,
		stack = true,
		close = false,
		description = "Access Card for Weed Lab",
		client = {
			image = "weed_access.png",
		}
	},

	["emerald_necklace_silver"] = {
		label = "Emerald Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_necklace_silver.png",
		}
	},

	["skin_stingray"] = {
		label = "Stingray Skin",
		weight = 850,
		stack = true,
		close = true,
		description = "Stingray skin. Highly illegal!",
		client = {
			image = "skin_stingray.png",
		}
	},

	["chair100"] = {
		label = "Blue Metal Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair100.png",
		}
	},

	["j_phone"] = {
		label = "Phone",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "j_phone.png",
		}
	},

	["skull"] = {
		label = "Skull Art with diamonds",
		weight = 95,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "skull.png",
		}
	},

	["coke_brick"] = {
		label = "Coke Brick",
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy package of cocaine, mostly used for deals and takes a lot of space",
		client = {
			image = "coke_brick.png",
		}
	},

	["weed_ak47_seed"] = {
		label = "AK47 Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of AK47",
		client = {
			image = "weed_seed.png",
		}
	},

	["taco"] = {
		label = "Taco",
		weight = 500,
		stack = true,
		close = false,
		description = "Some big taco brother",
		client = {
			image = "taco.png",
		}
	},

	["diamond_ring2"] = {
		label = "Stolen Diamond Ring",
		weight = 1500,
		stack = true,
		close = true,
		description = "A diamond ring seems like the jackpot to me!",
		client = {
			image = "diamond_ring.png",
		}
	},

	["chair33"] = {
		label = "Black Comfy Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair33.png",
		}
	},

	["noparkingsign"] = {
		label = "No Parking Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "No Parking Sign",
		client = {
			image = "noparkingsign.png",
		}
	},

	["crack_pipe"] = {
		label = "Crack Pipe",
		weight = 550,
		stack = true,
		close = false,
		description = "Enjoy your Crack!",
		client = {
			image = "crack_pipe.png",
		}
	},

	["yieldsign"] = {
		label = "Yield Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "Yield Sign",
		client = {
			image = "yieldsign.png",
		}
	},

	["engine5"] = {
		label = "Tier 5 Engine",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "engine5.png",
		}
	},

	["television"] = {
		label = "TV",
		weight = 155,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "television.png",
		}
	},

	["driveshaft"] = {
		label = "Drive Shaft",
		weight = 5000,
		stack = true,
		close = true,
		description = "Drive Shaft",
		client = {
			image = "drive_shaft.png",
		}
	},

	["printer"] = {
		label = "Printer",
		weight = 190,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "printer.png",
		}
	},

	["firework4"] = {
		label = "Weeping Willow",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework4.png",
		}
	},

	["copperore"] = {
		label = "Copper Ore",
		weight = 1000,
		stack = true,
		close = false,
		description = "Copper, a base ore.",
		client = {
			image = "copperore.png",
		}
	},

	["emerald_earring_silver"] = {
		label = "Emerald Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_earring_silver.png",
		}
	},

	["chair105"] = {
		label = "Light Material Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair105.png",
		}
	},

	["chair38"] = {
		label = "Ol Rocking Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair38.png",
		}
	},

	["chair6"] = {
		label = "Grey Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair6.png",
		}
	},

	["silverchain"] = {
		label = "Silver Chain",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "silverchain.png",
		}
	},

	["chair90"] = {
		label = "White Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair90.png",
		}
	},

	["mininglaser"] = {
		label = "Mining Laser",
		weight = 900,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "mininglaser.png",
		}
	},

	["vodka_mash"] = {
		label = "Vodka Mash",
		weight = 5000,
		stack = true,
		close = false,
		description = "A bucket of vodka mash!",
		client = {
			image = "vodka_mash.png",
		}
	},

	["chair101"] = {
		label = "Black Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair101.png",
		}
	},

	["certificate"] = {
		label = "Certificate",
		weight = 0,
		stack = true,
		close = true,
		description = "Certificate that proves you own certain stuff",
		client = {
			image = "certificate.png",
		}
	},

	["goldchain2"] = {
		label = "Stolen Golden Chain",
		weight = 1500,
		stack = true,
		close = true,
		description = "A golden chain seems like the jackpot to me!",
		client = {
			image = "goldchain.png",
		}
	},

	["rat"] = {
		label = "Rat",
		weight = 500,
		stack = false,
		close = true,
		description = "Your royal companion!",
		client = {
			image = "A_C_Rat.png",
		}
	},

	["syringe"] = {
		label = "Syringe",
		weight = 300,
		stack = true,
		close = false,
		description = "Enjoy your new crystal clear stuff!",
		client = {
			image = "syringe.png",
		}
	},

	["markedbills"] = {
		label = "Marked Money",
		weight = 1000,
		stack = false,
		close = true,
		description = "Money?",
		client = {
			image = "markedbills.png",
		}
	},

	["ugrepairkit"] = {
		label = "UG Repairkit",
		weight = 5000,
		stack = true,
		close = true,
		description = "A nice toolbox with stuff to repair your vehicle",
		client = {
			image = "advancedrepairkit.png",
		}
	},

	["xtcbaggy"] = {
		label = "Bag of XTC",
		weight = 0,
		stack = true,
		close = true,
		description = "Pop those pills baby",
		client = {
			image = "xtc_baggy.png",
		}
	},

	["oxy"] = {
		label = "Prescription Oxy",
		weight = 0,
		stack = true,
		close = true,
		description = "The Label Has Been Ripped Off",
		client = {
			image = "oxy.png",
		}
	},

	["chair86"] = {
		label = "Red Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair86.png",
		}
	},

	["meat_whale"] = {
		label = "Whale Meat",
		weight = 6000,
		stack = true,
		close = true,
		description = "Whale meat!",
		client = {
			image = "meat_whale.png",
		}
	},

	["weed_papers"] = {
		label = "Weed Papers",
		weight = 15,
		stack = true,
		close = false,
		description = "Get Weed Bag and roll joint!",
		client = {
			image = "weed_papers.png",
		}
	},

	["fat_end_muzzle_brake"] = {
		label = "Fat End Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "fat_end_muzzle_brake.png",
		}
	},

	["potato_sack"] = {
		label = "Potato Sack",
		weight = 5000,
		stack = true,
		close = false,
		description = "A sack of potatoes ready for selling!",
		client = {
			image = "potato_sack.png",
		}
	},

	["bootlegvodka"] = {
		label = "Bootleg Vodka",
		weight = 500,
		stack = true,
		close = false,
		description = "A bottle of bootleg vodka!",
		client = {
			image = "bootlegvodka.png",
		}
	},

	["skin_mtlion"] = {
		label = "Mt Lion Hide",
		weight = 1050,
		stack = true,
		close = true,
		description = "Mt. Lion hide. Highly illegal!",
		client = {
			image = "skin_mtlion.png",
		}
	},

	["veh_engine"] = {
		label = "Engine",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle engine",
		client = {
			image = "veh_engine.png",
		}
	},

	["coke_small_brick"] = {
		label = "Coke Package",
		weight = 350,
		stack = true,
		close = true,
		description = "Small package of cocaine, mostly used for deals and takes a lot of space",
		client = {
			image = "coke_small_brick.png",
		}
	},

	["skin_coyote"] = {
		label = "Coyote Hide",
		weight = 750,
		stack = true,
		close = true,
		description = "Coyote hide.",
		client = {
			image = "skin_coyote.png",
		}
	},

	["tomato_seed"] = {
		label = "Tomato Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of tomato seeds!",
		client = {
			image = "tomato_seed.png",
		}
	},

	["tosti"] = {
		label = "Grilled Cheese Sandwich",
		weight = 200,
		stack = true,
		close = true,
		description = "Nice to eat",
		client = {
			image = "tosti.png",
		}
	},

	["oilwell"] = {
		label = "Oilwell",
		weight = 50000,
		stack = true,
		close = true,
		description = "Oilwell",
		client = {
			image = "oilwell.png",
		}
	},

	["carbattery"] = {
		label = "Clutch",
		weight = 0,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "clutch.png",
		}
	},

	["chair89"] = {
		label = "Light Blue Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair89.png",
		}
	},

	["weedkey"] = {
		label = "Key C",
		weight = 200,
		stack = true,
		close = false,
		description = "Random Key, with a \"Seed\" Engraved on the Back...",
		client = {
			image = "keyc.png",
		}
	},

	["chair1"] = {
		label = "Black Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair1.png",
		}
	},

	["beer"] = {
		label = "Beer",
		weight = 500,
		stack = true,
		close = true,
		description = "Nothing like a good cold beer!",
		client = {
			image = "beer.png",
		}
	},

	["chair8"] = {
		label = "Lime Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair8.png",
		}
	},

	["pogo"] = {
		label = "Art Piece",
		weight = 155,
		stack = true,
		close = false,
		description = "Pogo Statue",
		client = {
			image = "pogo.png",
		}
	},

	["chair83"] = {
		label = "Orange Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair83.png",
		}
	},

	["diamond_earring"] = {
		label = "Diamond Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_earring.png",
		}
	},

	["engine2"] = {
		label = "Tier 2 Engine",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "engine2.png",
		}
	},

	["printerdocument"] = {
		label = "Document",
		weight = 500,
		stack = false,
		close = true,
		description = "A nice document",
		client = {
			image = "printerdocument.png",
		}
	},

	["green_phone"] = {
		label = "Green Phone",
		weight = 700,
		stack = false,
		close = false,
		description = "Neat phone ya got there",
		client = {
			image = "phone.png",
		}
	},

	["weed_ogkush"] = {
		label = "OGKush 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g OG Kush",
		client = {
			image = "weed_baggy.png",
		}
	},

	["megaphone"] = {
		label = "Megaphone",
		weight = 20000,
		stack = false,
		close = false,
		description = "A loudspeaker to yell at civilians.",
		client = {
			image = "megaphone.png",
		}
	},

	["ecstasy2"] = {
		label = "Ectasy",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "ecstasy2.png",
		}
	},

	["advancedrepairkit"] = {
		label = "Advanced Repairkit",
		weight = 4000,
		stack = true,
		close = true,
		description = "A nice toolbox with stuff to repair your vehicle",
		client = {
			image = "advancedkit.png",
		}
	},

	["grape"] = {
		label = "Grape",
		weight = 100,
		stack = true,
		close = false,
		description = "Mmmmh yummie, grapes",
		client = {
			image = "grape.png",
		}
	},

	["strawberry_crate"] = {
		label = "Strawberry Crate",
		weight = 2500,
		stack = true,
		close = false,
		description = "A crate of strawberries ready for selling!",
		client = {
			image = "strawberry_crate.png",
		}
	},

	["ruby_necklace"] = {
		label = "Ruby Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_necklace.png",
		}
	},

	["laptop"] = {
		label = "Laptop",
		weight = 4000,
		stack = true,
		close = true,
		description = "Expensive laptop",
		client = {
			image = "laptop.png",
		}
	},

	["security_card_01"] = {
		label = "Security Card A",
		weight = 0,
		stack = true,
		close = true,
		description = "A security card... I wonder what it goes to",
		client = {
			image = "security_card_01.png",
		}
	},

	["meth_glass"] = {
		label = "Tray with meth",
		weight = 1000,
		stack = true,
		close = false,
		description = "Needs to be smashed with hammer",
		client = {
			image = "meth_glass.png",
		}
	},

	["advscope_attachment"] = {
		label = "Advanced Scope",
		weight = 1000,
		stack = true,
		close = true,
		description = "An advanced scope for a weapon",
		client = {
			image = "advscope_attachment.png",
		}
	},

	["emerald_earring"] = {
		label = "Emerald Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_earring.png",
		}
	},

	["farmguide"] = {
		label = "Farming Handbook",
		weight = 100,
		stack = true,
		close = false,
		description = "Learn all about farming with this handbook!",
		client = {
			image = "farmguide.png",
		}
	},

	["firstaid"] = {
		label = "First Aid",
		weight = 2500,
		stack = true,
		close = true,
		description = "You can use this First Aid kit to get people back on their feet",
		client = {
			image = "firstaid.png",
		}
	},

	["emerald_necklace"] = {
		label = "Emerald Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "emerald_necklace.png",
		}
	},

	["loot_bag"] = {
		label = "Duffle bag",
		weight = 50,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "loot_bag.png",
		}
	},

	["magicmushroom"] = {
		label = "Magic Mushroom",
		weight = 30,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "magicmushroom.png",
		}
	},

	["meth_sacid"] = {
		label = "Sodium Benzoate Canister",
		weight = 5000,
		stack = true,
		close = false,
		description = "Warning! Dangerous Chemicals!",
		client = {
			image = "meth_sacid.png",
		}
	},

	["brakes1"] = {
		label = "Tier 1 Brakes",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "brakes1.png",
		}
	},

	["engine1"] = {
		label = "Tier 1 Engine",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "engine1.png",
		}
	},

	["rightturnsign"] = {
		label = "Right Turn Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "Right Turn Sign",
		client = {
			image = "rightturnsign.png",
		}
	},

	["chair92"] = {
		label = "Brown Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair92.png",
		}
	},

	["tunerlaptop"] = {
		label = "Tunerchip",
		weight = 2000,
		stack = false,
		close = true,
		description = "With this tunerchip you can get your car on steroids... If you know what you're doing",
		client = {
			image = "tunerchip.png",
		}
	},

	["chair28"] = {
		label = "Grey Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair28.png",
		}
	},

	["peyote_seed"] = {
		label = "Peyote Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of peyote seeds!",
		client = {
			image = "peyote_seed.png",
		}
	},

	["stopsign"] = {
		label = "Stop Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "Stop Sign",
		client = {
			image = "stopsign.png",
		}
	},

	["leftturnsign"] = {
		label = "Left Turn Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "Left Turn Sign",
		client = {
			image = "leftturnsign.png",
		}
	},

	["pineapple_crate"] = {
		label = "Pineapple Crate",
		weight = 2500,
		stack = true,
		close = false,
		description = "A crate of pineapples ready for selling!",
		client = {
			image = "pineapple_crate.png",
		}
	},

	["chair72"] = {
		label = "Grey Sun Lounger",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair72.png",
		}
	},

	["xanaxpill"] = {
		label = "Xanax Pill",
		weight = 2,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "xanaxpill.png",
		}
	},

	["weed_skunk_seed"] = {
		label = "Skunk Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of Skunk",
		client = {
			image = "weed_seed.png",
		}
	},

	["recyclablematerial"] = {
		label = "Recycle Box",
		weight = 100,
		stack = true,
		close = false,
		description = "A box of Recyclable Materials",
		client = {
			image = "recyclablematerial.png",
		}
	},

	["ruby_necklace_silver"] = {
		label = "Ruby Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_necklace_silver.png",
		}
	},

	["oilfilter"] = {
		label = "Oil Filter",
		weight = 5000,
		stack = true,
		close = true,
		description = "Oil Filter",
		client = {
			image = "oil_filter.png",
		}
	},

	["chair26"] = {
		label = "Blue Plastic Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair26.png",
		}
	},

	["engine4"] = {
		label = "Tier 4 Engine",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "engine4.png",
		}
	},

	["coke_raw"] = {
		label = "Raw Coke",
		weight = 50,
		stack = true,
		close = true,
		description = "Coke with some dirty particles",
		client = {
			image = "coke_raw.png",
		}
	},

	["veh_xenons"] = {
		label = "Xenons",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle xenons",
		client = {
			image = "veh_xenons.png",
		}
	},

	["petwaterbottleportable"] = {
		label = "Portable water bottle",
		weight = 1000,
		stack = false,
		close = true,
		description = "Flask to store water for your pets",
		client = {
			image = "petwaterbottleportable.png",
		}
	},

	["exhaust"] = {
		label = "Vehicle Exhaust",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "exhaust.png",
		}
	},

	["boombox"] = {
		label = "Boombox",
		weight = 85,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "boombox.png",
		}
	},

	["finescale"] = {
		label = "Fine Scale",
		weight = 200,
		stack = true,
		close = false,
		description = "Scale Used for Fine Powders and Materials.",
		client = {
			image = "finescale.png",
		}
	},

	["split_end_muzzle_brake"] = {
		label = "Split End Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "split_end_muzzle_brake.png",
		}
	},

	["chair59"] = {
		label = "Lime Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair59.png",
		}
	},

	["jerrycan"] = {
		label = "Jerry Can",
		weight = 15000,
		stack = false,
		close = false,
		description = "A Jerry Can made to hold gasoline.",
		client = {
			image = "jerrycan.png",
		}
	},

	["mtlion2"] = {
		label = "Panter",
		weight = 500,
		stack = false,
		close = true,
		description = "Panter is your royal companion!",
		client = {
			image = "A_C_MtLion.png",
		}
	},

	["chair51"] = {
		label = "Green Lawn Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair51.png",
		}
	},

	["visa"] = {
		label = "Visa Card",
		weight = 0,
		stack = false,
		close = false,
		description = "Visa can be used via ATM",
		client = {
			image = "visacard.png",
		}
	},

	["coke"] = {
		label = "Cocaine",
		weight = 1000,
		stack = true,
		close = false,
		description = "Processed cocaine",
		client = {
			image = "coke.png",
		}
	},

	["maize"] = {
		label = "Maize",
		weight = 100,
		stack = true,
		close = false,
		description = "Maize!",
		client = {
			image = "maize.png",
		}
	},

	["chair79"] = {
		label = "Black Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair79.png",
		}
	},

	["huntinglicense"] = {
		label = "Hunting License",
		weight = 1,
		stack = false,
		close = false,
		description = "Permit to show officals that you can legally hunt.",
		client = {
			image = "huntinglicense.png",
		}
	},

	["weed_budclean"] = {
		label = "Weed Bud",
		weight = 35,
		stack = true,
		close = false,
		description = "You can pack this at the table",
		client = {
			image = "weed_budclean.png",
		}
	},

	["trojan_usb"] = {
		label = "Trojan USB",
		weight = 0,
		stack = true,
		close = true,
		description = "Handy software to shut down some systems",
		client = {
			image = "usb_device.png",
		}
	},

	["medscope_attachment"] = {
		label = "Medium Scope",
		weight = 1000,
		stack = true,
		close = true,
		description = "A medium scope for a weapon",
		client = {
			image = "medscope_attachment.png",
		}
	},

	["chair81"] = {
		label = "Blue Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair81.png",
		}
	},

	["chair58"] = {
		label = "Zebra Print Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair58.png",
		}
	},

	["meth_access"] = {
		label = "Access Card",
		weight = 50,
		stack = true,
		close = false,
		description = "Access Card for Meth Lab",
		client = {
			image = "meth_access.png",
		}
	},

	["ironore"] = {
		label = "Iron Ore",
		weight = 1000,
		stack = true,
		close = false,
		description = "Iron, a base ore.",
		client = {
			image = "ironore.png",
		}
	},

	["driver_license"] = {
		label = "Drivers License",
		weight = 0,
		stack = false,
		close = false,
		description = "Permit to show you can drive a vehicle",
		client = {
			image = "driver_license.png",
		}
	},

	["advancedlockpick"] = {
		label = "Advanced Lockpick",
		weight = 500,
		stack = true,
		close = true,
		description = "If you lose your keys a lot this is very useful... Also useful to open your beers",
		client = {
			image = "advancedlockpick.png",
		}
	},

	["heavyarmor"] = {
		label = "Heavy Armor",
		weight = 5000,
		stack = true,
		close = true,
		description = "Some protection won't hurt... right?",
		client = {
			image = "armor.png",
		}
	},

	["crack_baggy"] = {
		label = "Bag of Crack",
		weight = 0,
		stack = true,
		close = true,
		description = "To get happy faster",
		client = {
			image = "crack_baggy.png",
		}
	},

	["fitbit"] = {
		label = "Fitbit",
		weight = 500,
		stack = false,
		close = true,
		description = "I like fitbit",
		client = {
			image = "fitbit.png",
		}
	},

	["silveringot"] = {
		label = "Silver Ingot",
		weight = 1000,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "silveringot.png",
		}
	},

	["tomato_crate"] = {
		label = "Tomato Crate",
		weight = 2500,
		stack = true,
		close = false,
		description = "A crate of tomatoes ready for selling!",
		client = {
			image = "tomato_crate.png",
		}
	},

	["chair11"] = {
		label = "Black Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair11.png",
		}
	},

	["coca_leaf"] = {
		label = "Cocaine leaves",
		weight = 1500,
		stack = true,
		close = false,
		description = "Cocaine leaves that must be processed !",
		client = {
			image = "coca_leaf.png",
		}
	},

	["tacosalad"] = {
		label = "Taco Salad",
		weight = 1000,
		stack = true,
		close = true,
		description = "Taco Salad",
		client = {
			image = "tacosalad.png",
		}
	},

	["hen"] = {
		label = "Hen",
		weight = 500,
		stack = false,
		close = true,
		description = "Hen is your royal companion!",
		client = {
			image = "A_C_Hen.png",
		}
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 2500,
		stack = true,
		close = true,
		description = "Uncured cannabis",
		client = {
			image = "cannabis.png",
		}
	},

	["meth_pipe"] = {
		label = "Meth Pipe",
		weight = 880,
		stack = true,
		close = false,
		description = "Enjoy your new crystal clear stuff!",
		client = {
			image = "meth_pipe.png",
		}
	},

	["weed_package"] = {
		label = "Weed Bag",
		weight = 500,
		stack = true,
		close = false,
		description = "Plastic bag with magic stuff!",
		client = {
			image = "weed_package.png",
		}
	},

	["chair108"] = {
		label = "White Casino Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair108.png",
		}
	},

	["earings"] = {
		label = "Earings",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "earings.png",
		}
	},

	["baking_soda"] = {
		label = "Baking Soda",
		weight = 30,
		stack = true,
		close = false,
		description = "Baking Bad!",
		client = {
			image = "baking_soda.png",
		}
	},

	["uncut_diamond"] = {
		label = "Uncut Diamond",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Diamond",
		client = {
			image = "uncut_diamond.png",
		}
	},

	["veh_exterior"] = {
		label = "Exterior",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle exterior",
		client = {
			image = "veh_exterior.png",
		}
	},

	["brakes3"] = {
		label = "Tier 3 Brakes",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "brakes3.png",
		}
	},

	["externals"] = {
		label = "Exterior Cosmetics",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "mirror.png",
		}
	},

	["skin_rat"] = {
		label = "Rat Hide",
		weight = 150,
		stack = true,
		close = true,
		description = "Rat hide.",
		client = {
			image = "skin_rat.png",
		}
	},

	["chair98"] = {
		label = "Red/Green Gamer Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair98.png",
		}
	},

	["chair14"] = {
		label = "White Leather Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair14.png",
		}
	},

	["cokebaggy"] = {
		label = "Bag of Coke",
		weight = 0,
		stack = true,
		close = true,
		description = "To get happy real quick",
		client = {
			image = "cocaine_baggy.png",
		}
	},

	["purple_phone"] = {
		label = "Purple Phone",
		weight = 700,
		stack = false,
		close = false,
		description = "Neat phone ya got there",
		client = {
			image = "phone.png",
		}
	},

	["milk_crate"] = {
		label = "Milk Crate",
		weight = 5500,
		stack = true,
		close = false,
		description = "A crate of milk bottles ready for selling!",
		client = {
			image = "milk_crate.png",
		}
	},

	["geocamo_attachment"] = {
		label = "Geometric Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A geometric camo for a weapon",
		client = {
			image = "geocamo_attachment.png",
		}
	},

	["chair94"] = {
		label = "Grey Luxury Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair94.png",
		}
	},

	["labkey"] = {
		label = "Key",
		weight = 500,
		stack = false,
		close = true,
		description = "Key for a lock...?",
		client = {
			image = "labkey.png",
		}
	},

	["diamond_necklace_silver"] = {
		label = "Diamond Necklace Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_necklace_silver.png",
		}
	},

	["gold_watch"] = {
		label = "Gold watch",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "gold_watch.png",
		}
	},

	["suspension2"] = {
		label = "Tier 2 Suspension",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "suspension2.png",
		}
	},

	["lsd2"] = {
		label = "LSD",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "lsd2.png",
		}
	},

	["rubber"] = {
		label = "Rubber",
		weight = 100,
		stack = true,
		close = false,
		description = "Rubber, I believe you can make your own rubber ducky with it :D",
		client = {
			image = "rubber.png",
		}
	},

	["mtlion"] = {
		label = "MtLion",
		weight = 500,
		stack = false,
		close = true,
		description = "MtLion is your royal companion!",
		client = {
			image = "A_C_MtLion.png",
		}
	},

	["magic_mushroom"] = {
		label = "Magic Mushroom",
		weight = 20,
		stack = true,
		close = false,
		description = "A handful of magic mushrooms!",
		client = {
			image = "magic_mushroom.png",
		}
	},

	["weed_whitewidow_seed"] = {
		label = "White Widow Seed",
		weight = 0,
		stack = true,
		close = false,
		description = "A weed seed of White Widow",
		client = {
			image = "weed_seed.png",
		}
	},

	["suppressor_attachment"] = {
		label = "Suppressor",
		weight = 1000,
		stack = true,
		close = true,
		description = "A suppressor for a weapon",
		client = {
			image = "suppressor_attachment.png",
		}
	},

	["copper"] = {
		label = "Copper",
		weight = 100,
		stack = true,
		close = false,
		description = "Nice piece of metal that you can probably use for something",
		client = {
			image = "copper.png",
		}
	},

	["keycuttingmachine"] = {
		label = "Key Cutting Machine",
		weight = 40000,
		stack = true,
		close = true,
		description = "A Machine to Cut Keys",
		client = {
			image = "keycuttingmachine.png",
		}
	},

	["drillbit"] = {
		label = "Drill Bit",
		weight = 10,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "drillbit.png",
		}
	},

	["chair52"] = {
		label = "Worn Metal Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair52.png",
		}
	},

	["ruby_earring_silver"] = {
		label = "Ruby Earrings Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "ruby_earring_silver.png",
		}
	},

	["skin_whale"] = {
		label = "Whale Skin",
		weight = 7500,
		stack = true,
		close = true,
		description = "Whale skin. Highly illegal",
		client = {
			image = "skin_whale.png",
		}
	},

	["joint"] = {
		label = "Joint",
		weight = 0,
		stack = true,
		close = true,
		description = "Sidney would be very proud at you",
		client = {
			image = "joint.png",
		}
	},

	["coke_box"] = {
		label = "Box with Coke",
		weight = 2000,
		stack = true,
		close = false,
		description = "Be careful not to spill it on the ground",
		client = {
			image = "coke_box.png",
		}
	},

	["reliefvalvestring"] = {
		label = "Relief Valve String",
		weight = 4000,
		stack = true,
		close = true,
		description = "Relief Valve String",
		client = {
			image = "relief_valve_string.png",
		}
	},

	["chair48"] = {
		label = "Brown Metal Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair48.png",
		}
	},

	["veh_transmission"] = {
		label = "Transmission",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle transmission",
		client = {
			image = "veh_transmission.png",
		}
	},

	["sparkplugs"] = {
		label = "Brake Peds",
		weight = 0,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "brake_pads.png",
		}
	},

	["cm2"] = {
		label = "Casino Membership",
		weight = 1000,
		stack = false,
		close = true,
		description = "Casino Membership Tier 2",
		client = {
			image = "goldmembership.png",
		}
	},

	["empty_evidence_bag"] = {
		label = "Empty Evidence Bag",
		weight = 0,
		stack = true,
		close = false,
		description = "Used a lot to keep DNA from blood, bullet shells and more",
		client = {
			image = "evidence.png",
		}
	},

	["casinochips"] = {
		label = "Casino Chips",
		weight = 0,
		stack = true,
		close = false,
		description = "Chips For Casino Gambling",
		client = {
			image = "casinochips.png",
		}
	},

	["cocainekey"] = {
		label = "Key B",
		weight = 200,
		stack = true,
		close = false,
		description = "Random Key, with a \"Razorblade\" Engraved on the Back...",
		client = {
			image = "keyb.png",
		}
	},

	["chair41"] = {
		label = "Grey Metal Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair41.png",
		}
	},

	["weedplant_packedweed"] = {
		label = "Packed Weed",
		weight = 100,
		stack = false,
		close = false,
		description = "Weed ready for sale",
		client = {
			image = "weedplant_weed.png",
		}
	},

	["sodium_hydroxide"] = {
		label = "Sodium Hydroxide",
		weight = 1500,
		stack = true,
		close = true,
		description = "Chemicals, handle with care!",
		client = {
			image = "sodium_hydroxide.png",
		}
	},

	["shepherd"] = {
		label = "Shepherd",
		weight = 500,
		stack = false,
		close = true,
		description = "Shepherd is your royal companion!",
		client = {
			image = "A_C_shepherd.png",
		}
	},

	["chair43"] = {
		label = "Wicker Lawn Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair43.png",
		}
	},

	["mushroom"] = {
		label = "Mushroom",
		weight = 100,
		stack = true,
		close = false,
		description = "Mushroom!",
		client = {
			image = "mushroom.png",
		}
	},

	["tablet"] = {
		label = "Tablet",
		weight = 2000,
		stack = true,
		close = true,
		description = "Expensive tablet",
		client = {
			image = "tablet.png",
		}
	},

	["lighter"] = {
		label = "Lighter",
		weight = 0,
		stack = true,
		close = true,
		description = "On new years eve a nice fire to stand next to",
		client = {
			image = "lighter.png",
		}
	},

	["shampoo"] = {
		label = "Shampoo",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "shampoo.png",
		}
	},

	["containeroldmid"] = {
		label = "Mid Old Container",
		weight = 5000,
		stack = false,
		close = true,
		description = "Small Green Container",
		client = {
			image = "container_old_mid.png",
		}
	},

	["potato"] = {
		label = "Potato",
		weight = 100,
		stack = true,
		close = false,
		description = "Potato!",
		client = {
			image = "potato.png",
		}
	},

	["full_watering_can"] = {
		label = "Full Watering Can",
		weight = 1000,
		stack = false,
		close = false,
		description = "Watering can filled with water for watering plants",
		client = {
			image = "watering_can.png",
		}
	},

	["drum_attachment"] = {
		label = "Drum",
		weight = 1000,
		stack = true,
		close = true,
		description = "A drum for a weapon",
		client = {
			image = "drum_attachment.png",
		}
	},

	["chair102"] = {
		label = "Red Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair102.png",
		}
	},

	["bank_card"] = {
		label = "Bank Card",
		weight = 0,
		stack = false,
		close = true,
		description = "Used to access ATM",
		client = {
			image = "bank_card.png",
		}
	},

	["watering_can"] = {
		label = "Watering Can",
		weight = 100,
		stack = true,
		close = false,
		description = "A empty watering can!",
		client = {
			image = "watering_can.png",
		}
	},

	["weed_purplehaze_seed"] = {
		label = "Purple Haze Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of Purple Haze",
		client = {
			image = "weed_seed.png",
		}
	},

	["chair13"] = {
		label = "Orange Leather Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair13.png",
		}
	},

	["empty_weed_bag"] = {
		label = "Empty Weed Bag",
		weight = 0,
		stack = true,
		close = true,
		description = "A small empty bag",
		client = {
			image = "weed_baggy_empty.png",
		}
	},

	["bumper"] = {
		label = "Vehicle Bumper",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "bumper.png",
		}
	},

	["meat_mtlion"] = {
		label = "Mt Lion Meat",
		weight = 1000,
		stack = true,
		close = true,
		description = "Mt Lion meat!",
		client = {
			image = "meat_mtlion.png",
		}
	},

	["pineapple_seed"] = {
		label = "Pineapple Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of pineapple seeds!",
		client = {
			image = "pineapple_seed.png",
		}
	},

	["notrespassingsign"] = {
		label = "No Trespassing Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "No Trespassing Sign",
		client = {
			image = "notrespassingsign.png",
		}
	},

	["chair61"] = {
		label = "Cream Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair61.png",
		}
	},

	["moonshine_mash"] = {
		label = "Moonshine Mash",
		weight = 5000,
		stack = true,
		close = false,
		description = "A bucket of moonshine mash!",
		client = {
			image = "moonshine_mash.png",
		}
	},

	["chair44"] = {
		label = "Old Posh Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair44.png",
		}
	},

	["mechboard"] = {
		label = "Mechanic Sheet",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "mechboard.png",
		}
	},

	["tracker"] = {
		label = "Tracker",
		weight = 2000,
		stack = false,
		close = true,
		description = "Mobile Jammer",
		client = {
			image = "radiochip.png",
		}
	},

	["perseuscamo_attachment"] = {
		label = "Perseus Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A perseus camo for a weapon",
		client = {
			image = "perseuscamo_attachment.png",
		}
	},

	["bracelet"] = {
		label = "Bracelet",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "bracelet.png",
		}
	},

	["glass"] = {
		label = "Glass",
		weight = 100,
		stack = true,
		close = false,
		description = "It is very fragile, watch out",
		client = {
			image = "glass.png",
		}
	},

	["aluminum"] = {
		label = "Aluminium",
		weight = 100,
		stack = true,
		close = false,
		description = "Nice piece of metal that you can probably use for something",
		client = {
			image = "aluminum.png",
		}
	},

	["lime_crate"] = {
		label = "Lime Crate",
		weight = 3500,
		stack = true,
		close = false,
		description = "A crate of limes ready for selling!",
		client = {
			image = "lime_crate.png",
		}
	},

	["blackkey"] = {
		label = "Black Key",
		weight = 1000,
		stack = false,
		close = true,
		description = "Black Key",
		client = {
			image = "black-key.png",
		}
	},

	["chair66"] = {
		label = "Yellow Wicker Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair66.png",
		}
	},

	["meat_boar"] = {
		label = "Boar Meat",
		weight = 700,
		stack = true,
		close = true,
		description = "Boar meat!",
		client = {
			image = "meat_boar.png",
		}
	},

	["lettuce_crate"] = {
		label = "Lettuce Crate",
		weight = 3500,
		stack = true,
		close = false,
		description = "A crate of lettuce ready for selling!",
		client = {
			image = "lettuce_crate.png",
		}
	},

	["chair49"] = {
		label = "Brown Wodd Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair49.png",
		}
	},

	["ecstasy3"] = {
		label = "Ectasy",
		weight = 10,
		stack = true,
		close = false,
		description = "Explore a new universe!",
		client = {
			image = "ecstasy3.png",
		}
	},

	["stickynote"] = {
		label = "Sticky note",
		weight = 0,
		stack = false,
		close = false,
		description = "Sometimes handy to remember something :)",
		client = {
			image = "stickynote.png",
		}
	},

	["bong"] = {
		label = "Bong",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "bong.png",
		}
	},

	["weedplant_seedm"] = {
		label = "Male Weed Seed",
		weight = 0,
		stack = true,
		close = false,
		description = "Male Weed Seed",
		client = {
			image = "weedplant_seed.png",
		}
	},

	["weedplant_package"] = {
		label = "Suspicious Package",
		weight = 10000,
		stack = false,
		close = false,
		description = "Suspicious Package",
		client = {
			image = "weedplant_package.png",
		}
	},

	["sapphire_earring"] = {
		label = "Sapphire Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sapphire_earring.png",
		}
	},

	["barley_sack"] = {
		label = "Barley Sack",
		weight = 5000,
		stack = true,
		close = false,
		description = "A sack of barley ready for selling!",
		client = {
			image = "barley_sack.png",
		}
	},

	["uncut_ruby"] = {
		label = "Uncut Ruby",
		weight = 100,
		stack = true,
		close = false,
		description = "A rough Ruby",
		client = {
			image = "uncut_ruby.png",
		}
	},

	["packedtaco2"] = {
		label = "Packed Taco",
		weight = 3500,
		stack = true,
		close = true,
		description = "Packed Taco",
		client = {
			image = "packedtaco.png",
		}
	},

	["axleparts"] = {
		label = "Axle Parts",
		weight = 0,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "axleparts.png",
		}
	},

	["weed_white-widow"] = {
		label = "White Widow 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g White Widow",
		client = {
			image = "weed_baggy.png",
		}
	},

	["keya"] = {
		label = "Labkey A",
		weight = 0,
		stack = false,
		close = false,
		description = "Labkey A..",
		client = {
			image = "keya.png",
		}
	},

	["gold_phone"] = {
		label = "Gold Phone",
		weight = 700,
		stack = false,
		close = false,
		description = "Neat phone ya got there",
		client = {
			image = "phone.png",
		}
	},

	["armor"] = {
		label = "Armor",
		weight = 5000,
		stack = true,
		close = true,
		description = "Some protection won't hurt... right?",
		client = {
			image = "armor.png",
		}
	},

	["chair5"] = {
		label = "Old Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair5.png",
		}
	},

	["headlights"] = {
		label = "Xenon Headlights",
		weight = 0,
		stack = false,
		close = true,
		description = "8k HID headlights",
		client = {
			image = "headlights.png",
		}
	},

	["chemicals"] = {
		label = "Chemicals",
		weight = 1500,
		stack = true,
		close = false,
		description = "Chemicals, handle with care...",
		client = {
			image = "chemicals.png",
		}
	},

	["chair47"] = {
		label = "Black Wicker Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair47.png",
		}
	},

	["skewgear"] = {
		label = "Skew Gear",
		weight = 6000,
		stack = true,
		close = true,
		description = "Skew Gear",
		client = {
			image = "skew_gear.png",
		}
	},

	["cat"] = {
		label = "Cat",
		weight = 500,
		stack = false,
		close = true,
		description = "Cat is your royal companion!",
		client = {
			image = "A_C_Cat_01.png",
		}
	},

	["hammer"] = {
		label = "Hammer",
		weight = 500,
		stack = true,
		close = false,
		description = "Good for smashing things!",
		client = {
			image = "hammer.png",
		}
	},

	["rolling_paper"] = {
		label = "Rolling Paper",
		weight = 0,
		stack = true,
		close = true,
		description = "Paper made specifically for encasing and smoking tobacco or cannabis.",
		client = {
			image = "rolling_paper.png",
		}
	},

	["blue_phone"] = {
		label = "Blue Phone",
		weight = 700,
		stack = false,
		close = false,
		description = "Neat phone ya got there",
		client = {
			image = "phone.png",
		}
	},

	["sulfuric_acid"] = {
		label = "Sulfuric Acid",
		weight = 1500,
		stack = true,
		close = false,
		description = "Chemicals, handle with care!",
		client = {
			image = "sulfuric_acid.png",
		}
	},

	["holoscope_attachment"] = {
		label = "Holo Scope",
		weight = 1000,
		stack = true,
		close = true,
		description = "A holo scope for a weapon",
		client = {
			image = "holoscope_attachment.png",
		}
	},

	["weed_whitewidow"] = {
		label = "White Widow 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g White Widow",
		client = {
			image = "weed_baggy.png",
		}
	},

	["skin_rabbit"] = {
		label = "Rabbit Hide",
		weight = 550,
		stack = true,
		close = true,
		description = "Rabbit hide.",
		client = {
			image = "skin_rabbit.png",
		}
	},

	["weed_white-widow_seed"] = {
		label = "White Widow Seed",
		weight = 0,
		stack = true,
		close = false,
		description = "A weed seed of White Widow",
		client = {
			image = "weed_seed.png",
		}
	},

	["weed_skunk"] = {
		label = "Skunk 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g Skunk",
		client = {
			image = "weed_baggy.png",
		}
	},

	["chair53"] = {
		label = "Fancy Garden Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair53.png",
		}
	},

	["rims"] = {
		label = "Custom Wheel Rims",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "rims.png",
		}
	},

	["lettuce_seed"] = {
		label = "Lettuce Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of lettuce seeds!",
		client = {
			image = "lettuce_seed.png",
		}
	},

	["meat_pig"] = {
		label = "Pork Meat",
		weight = 750,
		stack = true,
		close = true,
		description = "Pig meat!",
		client = {
			image = "meat_pig.png",
		}
	},

	["weed_ogkush_seed"] = {
		label = "OGKush Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of OG Kush",
		client = {
			image = "weed_seed.png",
		}
	},

	["chair15"] = {
		label = "Old Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair15.png",
		}
	},

	["patriotcamo_attachment"] = {
		label = "Patriot Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A patriot camo for a weapon",
		client = {
			image = "patriotcamo_attachment.png",
		}
	},

	["repairkit"] = {
		label = "Repairkit",
		weight = 2500,
		stack = true,
		close = true,
		description = "A nice toolbox with stuff to repair your vehicle",
		client = {
			image = "repairkit.png",
		}
	},

	["chair76"] = {
		label = "Black Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair76.png",
		}
	},

	["largescope_attachment"] = {
		label = "Large Scope",
		weight = 1000,
		stack = true,
		close = true,
		description = "A large scope for a weapon",
		client = {
			image = "largescope_attachment.png",
		}
	},

	["chair60"] = {
		label = "Brown Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair60.png",
		}
	},

	["fan"] = {
		label = "Fan",
		weight = 20,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "fan.png",
		}
	},

	["veh_interior"] = {
		label = "Interior",
		weight = 1000,
		stack = true,
		close = true,
		description = "Upgrade vehicle interior",
		client = {
			image = "veh_interior.png",
		}
	},

	["glue"] = {
		label = "Glue",
		weight = 30,
		stack = true,
		close = false,
		description = "Good for repairing things!",
		client = {
			image = "glue.png",
		}
	},

	["silverearring"] = {
		label = "Silver Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "silver_earring.png",
		}
	},

	["dslrcamera"] = {
		label = "PD Camera",
		weight = 1000,
		stack = false,
		close = true,
		description = "DSLR Camera, with cloud uplink.. cool right?",
		client = {
			image = "dslrcamera.png",
		}
	},

	["tablet2"] = {
		label = "Stolen Tablet",
		weight = 2000,
		stack = true,
		close = true,
		description = "Expensive tablet",
		client = {
			image = "tablet.png",
		}
	},

	["comp_attachment"] = {
		label = "Compensator",
		weight = 1000,
		stack = true,
		close = true,
		description = "A compensator for a weapon",
		client = {
			image = "comp_attachment.png",
		}
	},

	["sapphire"] = {
		label = "Sapphire",
		weight = 100,
		stack = true,
		close = false,
		description = "A Sapphire that shimmers",
		client = {
			image = "sapphire.png",
		}
	},

	["ducttape"] = {
		label = "Duct Tape",
		weight = 0,
		stack = false,
		close = true,
		description = "Good for quick fixes",
		client = {
			image = "bodyrepair.png",
		}
	},

	["suspension3"] = {
		label = "Tier 3 Suspension",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "suspension3.png",
		}
	},

	["mushroom_seed"] = {
		label = "Mushroom Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of mushroom seeds!",
		client = {
			image = "mushroom_seed.png",
		}
	},

	["psilocybin_seed"] = {
		label = "Psilocybin Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of psilocybin seeds!",
		client = {
			image = "psilocybin_seed.png",
		}
	},

	["skin_boar"] = {
		label = "Boar Hide",
		weight = 1250,
		stack = true,
		close = true,
		description = "Boar hide.",
		client = {
			image = "skin_boar.png",
		}
	},

	["rabbit"] = {
		label = "Rabbit",
		weight = 500,
		stack = false,
		close = true,
		description = "Rabbit is your royal companion!",
		client = {
			image = "A_C_Rabbit_01.png",
		}
	},

	["wine"] = {
		label = "Wine",
		weight = 300,
		stack = true,
		close = false,
		description = "Some good wine to drink on a fine evening",
		client = {
			image = "wine.png",
		}
	},

	["veh_toolbox"] = {
		label = "Toolbox",
		weight = 1000,
		stack = true,
		close = true,
		description = "Check vehicle status",
		client = {
			image = "veh_toolbox.png",
		}
	},

	["nitrous"] = {
		label = "Nitrous",
		weight = 1000,
		stack = true,
		close = true,
		description = "Speed up, gas pedal! :D",
		client = {
			image = "nitrous.png",
		}
	},

	["boomcamo_attachment"] = {
		label = "Boom Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A boom camo for a weapon",
		client = {
			image = "boomcamo_attachment.png",
		}
	},

	["coke_access"] = {
		label = "Access card",
		weight = 50,
		stack = true,
		close = false,
		description = "Access Card for Coke Lab",
		client = {
			image = "coke_access.png",
		}
	},

	["emerald"] = {
		label = "Emerald",
		weight = 100,
		stack = true,
		close = false,
		description = "A Emerald that shimmers",
		client = {
			image = "emerald.png",
		}
	},

	["heavy_duty_muzzle_brake"] = {
		label = "HD Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "heavy_duty_muzzle_brake.png",
		}
	},

	["flat_television"] = {
		label = "Flat TV",
		weight = 155,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "flat_television.png",
		}
	},

	["moonshine_ferm"] = {
		label = "Fermented Moonshine",
		weight = 5000,
		stack = true,
		close = false,
		description = "A bucket of fermented moonshine!",
		client = {
			image = "moonshine_ferm.png",
		}
	},

	["scissors"] = {
		label = "Scissors",
		weight = 40,
		stack = true,
		close = false,
		description = "To help you with collecting",
		client = {
			image = "scissors.png",
		}
	},

	["lawyerpass"] = {
		label = "Lawyer Pass",
		weight = 0,
		stack = false,
		close = false,
		description = "Pass exclusive to lawyers to show they can represent a suspect",
		client = {
			image = "lawyerpass.png",
		}
	},

	["meat_shark"] = {
		label = "Shark Meat",
		weight = 1200,
		stack = true,
		close = true,
		description = "Shark meat!",
		client = {
			image = "meat_shark.png",
		}
	},

	["handcuffs"] = {
		label = "Handcuffs",
		weight = 100,
		stack = true,
		close = true,
		description = "Comes in handy when people misbehave. Maybe it can be used for something else?",
		client = {
			image = "handcuffs.png",
		}
	},

	["suspension4"] = {
		label = "Tier 4 Suspension",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "suspension4.png",
		}
	},

	["chemicalvapor"] = {
		label = "Chemical Vapors",
		weight = 1500,
		stack = true,
		close = false,
		description = "High Pressure Chemical Vapors, Explosive!",
		client = {
			image = "chemicalvapor.png",
		}
	},

	["thionyl_chloride"] = {
		label = "Thionyl Chloride",
		weight = 1500,
		stack = true,
		close = false,
		description = "Chemicals, handle with care!",
		client = {
			image = "thionyl_chloride.png",
		}
	},

	["rainbow_phone"] = {
		label = "Rainbow Phone",
		weight = 700,
		stack = false,
		close = false,
		description = "Why does this even exist?",
		client = {
			image = "phone.png",
		}
	},

	["chair55"] = {
		label = "Old Metal ",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair55.png",
		}
	},

	["coffee"] = {
		label = "Coffee",
		weight = 200,
		stack = true,
		close = true,
		description = "Pump 4 Caffeine",
		client = {
			image = "coffee.png",
		}
	},

	["leopardcamo_attachment"] = {
		label = "Leopard Camo",
		weight = 1000,
		stack = true,
		close = true,
		description = "A leopard camo for a weapon",
		client = {
			image = "leopardcamo_attachment.png",
		}
	},

	["noscolour"] = {
		label = "NOS Colour Injector",
		weight = 0,
		stack = true,
		close = true,
		description = "Make that purge spray",
		client = {
			image = "noscolour.png",
		}
	},

	["wheelcoin"] = {
		label = "Casino Wheel Coin",
		weight = 500,
		stack = true,
		close = true,
		description = "casino wheelcoin.",
		client = {
			image = "wheelcoin.png",
		}
	},

	["whiskey"] = {
		label = "Whiskey",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "whiskey.png",
		}
	},

	["diamond_necklace"] = {
		label = "Diamond Necklace",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_necklace.png",
		}
	},

	["chair42"] = {
		label = "Brown Metal Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair42.png",
		}
	},

	["chair70"] = {
		label = "Dark Brown Metal Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair70.png",
		}
	},

	["chair103"] = {
		label = "Green Metal Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair103.png",
		}
	},

	["chair74"] = {
		label = "Yellow Deco Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair74.png",
		}
	},

	["heroin_syringe"] = {
		label = "Syringe",
		weight = 320,
		stack = true,
		close = false,
		description = "Enjoy your new crystal clear stuff!",
		client = {
			image = "heroin_syringe.png",
		}
	},

	["can"] = {
		label = "Empty Can",
		weight = 10,
		stack = true,
		close = false,
		description = "An empty can, good for recycling",
		client = {
			image = "can.png",
		}
	},

	["uturnsign"] = {
		label = "U Turn Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "U Turn Sign",
		client = {
			image = "uturnsign.png",
		}
	},

	["binoculars"] = {
		label = "Binoculars",
		weight = 600,
		stack = true,
		close = true,
		description = "Sneaky Breaky...",
		client = {
			image = "binoculars.png",
		}
	},

	["chair68"] = {
		label = "White Metal Dining Chair 2",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair68.png",
		}
	},

	["chair78"] = {
		label = "Wine Red Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair78.png",
		}
	},

	["dontblockintersectionsign"] = {
		label = "Intersection Sign",
		weight = 1,
		stack = true,
		close = true,
		description = "Intersection Sign",
		client = {
			image = "dontblockintersectionsign.png",
		}
	},

	["engine3"] = {
		label = "Tier 3 Engine",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "engine3.png",
		}
	},

	["salmon"] = {
		label = "Salmon",
		weight = 125,
		stack = true,
		close = true,
		description = "A breed of fish.",
		client = {
			image = "salmon.png",
		}
	},

	["petnametag"] = {
		label = "Name tag",
		weight = 500,
		stack = true,
		close = true,
		description = "Rename your pet",
		client = {
			image = "petnametag.png",
		}
	},

	["chair20"] = {
		label = "Blue Office Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair20.png",
		}
	},

	["brakes2"] = {
		label = "Tier 2 Brakes",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "brakes2.png",
		}
	},

	["seat"] = {
		label = "Seat Cosmetics",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "seat.png",
		}
	},

	["pinger"] = {
		label = "Pinger",
		weight = 1000,
		stack = true,
		close = true,
		description = "With a pinger and your phone you can send out your location",
		client = {
			image = "pinger.png",
		}
	},

	["rolex2"] = {
		label = "Stolen Golden Watch",
		weight = 1500,
		stack = true,
		close = true,
		description = "A golden watch seems like the jackpot to me!",
		client = {
			image = "rolex.png",
		}
	},

	["chair87"] = {
		label = "White Couch",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair87.png",
		}
	},

	["newscam"] = {
		label = "News Camera",
		weight = 100,
		stack = false,
		close = true,
		description = "A camera for the news",
		client = {
			image = "newscam.png",
		}
	},

	["shoebox"] = {
		label = "Shoe box",
		weight = 45,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "shoebox.png",
		}
	},

	["radio_alarm"] = {
		label = "Radio",
		weight = 30,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "radio_alarm.png",
		}
	},

	["petfood"] = {
		label = "pet food",
		weight = 500,
		stack = true,
		close = true,
		description = "food for your companion!",
		client = {
			image = "petfood.png",
		}
	},

	["chair104"] = {
		label = "Blue Metal Dining Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair104.png",
		}
	},

	["goldearring"] = {
		label = "Golden Earrings",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "gold_earring.png",
		}
	},

	["book"] = {
		label = "Book",
		weight = 25,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "book.png",
		}
	},

	["newoil"] = {
		label = "Radiator Fluid",
		weight = 0,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "caroil.png",
		}
	},

	["anchovy"] = {
		label = "Anchovy",
		weight = 35,
		stack = true,
		close = true,
		description = "A breed of fish.",
		client = {
			image = "anchovy.png",
		}
	},

	["packedtaco"] = {
		label = "Packed Taco",
		weight = 3500,
		stack = true,
		close = true,
		description = "Packed Taco",
		client = {
			image = "packedtaco.png",
		}
	},

	["precision_muzzle_brake"] = {
		label = "Precision Muzzle Brake",
		weight = 1000,
		stack = true,
		close = true,
		description = "A muzzle brake for a weapon",
		client = {
			image = "precision_muzzle_brake.png",
		}
	},

	["gold_ring"] = {
		label = "Gold Ring",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "gold_ring.png",
		}
	},

	["cactus_seed"] = {
		label = "Cactus Seed",
		weight = 1,
		stack = true,
		close = false,
		description = "A handful of cactus seeds!",
		client = {
			image = "cactus_seed.png",
		}
	},

	["transmission2"] = {
		label = "Tier 2 Transmission",
		weight = 0,
		stack = false,
		close = true,
		description = "",
		client = {
			image = "transmission2.png",
		}
	},

	["emptysack"] = {
		label = "Sack",
		weight = 100,
		stack = true,
		close = false,
		description = "A empty sack for storing crops!",
		client = {
			image = "emptysack.png",
		}
	},

	["egg"] = {
		label = "Egg",
		weight = 50,
		stack = true,
		close = false,
		description = "Fresh eggs!",
		client = {
			image = "egg.png",
		}
	},

	["chair73"] = {
		label = "Dark Brown Wood Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair73.png",
		}
	},

	["diamond_ring_silver"] = {
		label = "Diamond Ring Silver",
		weight = 200,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "diamond_ring_silver.png",
		}
	},

	["tapeplayer"] = {
		label = "Tape Player",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "tapeplayer.png",
		}
	},

	["red_phone"] = {
		label = "Red Phone",
		weight = 700,
		stack = false,
		close = false,
		description = "Neat phone ya got there",
		client = {
			image = "phone.png",
		}
	},

	["electronickit"] = {
		label = "Electronic Kit",
		weight = 100,
		stack = true,
		close = true,
		description = "If you've always wanted to build a robot you can maybe start here. Maybe you'll be the new Elon Musk?",
		client = {
			image = "electronickit.png",
		}
	},

	["coke_figureempty"] = {
		label = "Action Figure",
		weight = 150,
		stack = true,
		close = false,
		description = "Action Figure of the cartoon superhero Impotent Rage",
		client = {
			image = "coke_figureempty.png",
		}
	},

	["fishingrod"] = {
		label = "Fishing Rod",
		weight = 250,
		stack = true,
		close = true,
		description = "Use this with bait to catch fish.",
		client = {
			image = "fishingrod.png",
		}
	},

	["samsungphone2"] = {
		label = "Stolen Samsung S10",
		weight = 1000,
		stack = true,
		close = true,
		description = "Very expensive phone",
		client = {
			image = "samsungphone.png",
		}
	},

	["blueprint_carbine"] = {
		label = "Blueprint",
		weight = 50,
		stack = true,
		close = false,
		description = "Carbine Rifle Blueprint",
		client = {
			image = "blueprint_carbine.png",
		}
	},

	["silverore"] = {
		label = "Silver Ore",
		weight = 1000,
		stack = true,
		close = false,
		description = "Silver Ore",
		client = {
			image = "silverore.png",
		}
	},

	["chair109"] = {
		label = "Cream Wicker Chair",
		weight = 100,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "chair109.png",
		}
	},

	["cm1"] = {
		label = "Casino Membership",
		weight = 1000,
		stack = false,
		close = true,
		description = "Casino Membership Tier 1",
		client = {
			image = "silvermembership.png",
		}
	},

	["sculpture"] = {
		label = "Sculpture",
		weight = 55,
		stack = true,
		close = false,
		description = "",
		client = {
			image = "sculpture.png",
		}
	},
}