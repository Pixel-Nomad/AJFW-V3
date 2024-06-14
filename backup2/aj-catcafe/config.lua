
Config = {}
Config.Debug = false -- false to remove green boxes

Config.link = "aj-inventory/html/images/" --Set this to the image directory of your inventory script

Config.PatHeal = 0 			--how much you are healed by patting a cat, 2 hp seems resonable, enough not to be over powered and enough to draw people in.
							--set to 0 if you don't want to use this

Config.Items = {
	label = "Ingredients Storage",
	slots = 9,
	items = {
		[1] = { name = "nori", price = 10, amount = 50, info = {}, type = "item", slot = 1, },
		[2] = { name = "tofu", price = 10, amount = 50, info = {}, type = "item", slot = 2, },
		[3] = { name = "boba", price = 10, amount = 50, info = {}, type = "item", slot = 3, },
		[4] = { name = "mint", price = 10, amount = 50, info = {}, type = "item", slot = 4, },
		[5] = { name = "strawberry", price = 10, amount = 50, info = {}, type = "item", slot = 5, },
		[6] = { name = "blueberry", price = 10, amount = 50, info = {}, type = "item", slot = 6, },
		[7] = { name = "rice", price = 10, amount = 50, info = {}, type = "item", slot = 7, },
		[8] = { name = "sake", price = 70, amount = 50, info = {}, type = "item", slot = 8, },
		[9] = { name = "noodles", price = 10, amount = 50, info = {}, type = "item", slot = 9, },
	}
}

Config.Locations = {
    [1] = {
		zoneEnable = false,
        label = "catcafe", -- Set this to the required job
        zones = {
		  vector2(-591.15808105469, -1087.8620605469),
		  vector2(-563.33447265625, -1087.8508300781),
		  vector2(-563.26678466797, -1045.1898193359),
		  vector2(-618.20904541016, -1044.2902832031),
		  vector2(-617.80517578125, -1079.7291259766),
		  vector2(-599.44097900391, -1079.6105957031)
        },
		blip = vector3(-581.06, -1066.22, 22.34),
		blipcolor = 48,
    },
}

Crafting = {}

Crafting.ChoppingBoard = {
	[1] = { ['bmochi'] = { ['sugar'] = 1, ['flour'] = 1, ['blueberry'] = 1, }, },
	[2] = { ['gmochi'] = { ['sugar'] = 1, ['flour'] = 1, ['mint'] = 1, }, },
	[3] = { ['omochi'] = { ['sugar'] = 1, ['flour'] = 1, ['orange'] = 1, }, },
	[4] = { ['pmochi'] = { ['sugar'] = 1, ['flour'] = 1, ['strawberry'] = 1, }, },
	[5] = { ['riceball'] = { ['rice'] = 1, ['nori'] = 1, }, },
	[6] = { ['bento'] = { ['rice'] = 1, ['nori'] = 1, ['tofu'] = 1, }, },
	[7] = { ['purrito'] = { ['rice'] = 1, ['flour'] = 1, ['onion'] = 1, }, },
}

Crafting.Oven = {
	[1] = { ['nekocookie'] = { ['flour'] = 1, ['milk'] = 1, }, },
	[2] = { ['nekodonut'] = { ['flour'] = 1, ['milk'] = 1, }, },
	[3] = { ['cake'] = { ['flour'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },	
	[4] = { ['cakepop'] = { ['flour'] = 1, ['milk'] = 1, ['sugar'] = 1, }, },
	[5] = { ['pancake'] = { ['flour'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	[6] = { ['pizza'] = { ['flour'] = 1, ['milk'] = 1, }, },
}

Crafting.Coffee = {
	[1] = { ['nekolatte'] = { },  },
	[2] = { ['bobatea'] = { ['boba'] = 1, ['milk'] = 1, }, },
	[3] = { ['bbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['sugar'] = 1, }, },
	[4] = { ['gbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	[5] = { ['obobatea'] = { ['boba'] = 1, ['milk'] = 1, ['orange'] = 1, }, },
	[6] = { ['pbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	[7] = { ['mocha'] = { ['milk'] = 1, ['sugar'] = 1, }, },
}

Crafting.Mixer = {
	[1] = { ['sodiumchloride'] = { ['salt'] = 1, ['water_bottle'] = 1, }, },
}

Crafting.Hob = {
	[1] = { ['miso'] = { ['nori'] = 1, ['tofu'] = 1, ['onion'] = 1, }, },
	[2] = { ['ramen'] = { ['noodles'] = 1, ['onion'] = 1, }, },
	[3] = { ['noodlebowl'] = { ['noodles'] = 1, }, },
}
