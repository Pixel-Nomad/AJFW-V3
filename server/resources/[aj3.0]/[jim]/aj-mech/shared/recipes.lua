Crafting = {
	Tools = {
		{ ["mechanic_tools"] = { ["screwdriverset"] = 1, ["iron"] = 5, ["plastic"] = 5, } },
		{ ["toolbox"] = { ["mechanic_tools"] = 1, ["iron"] = 10, ["plastic"] = 10, ["screwdriverset"] = 2, } },
		{ ["ducttape"] = { ["plastic"] = 2, } },
		{ ["paintcan"] = { ["aluminum"] = 1 } },
		{ ["tint_supplies"] = { ["plastic"] = 1, } },
		-- { ["underglow_controller"] = { ["iron"] = 5, ["glass"] = 5, ["plastic"] = 5, } },
		{ ["cleaningkit"] = { ["rubber"] = 10, ["plastic"] = 5, } },
		{ ["newoil"] = { ["plastic"] = 4, ["rubber"] = 4, } },
		{ ["sparkplugs"] = { ["iron"] = 4, ["rubber"] = 4, } },
		{ ["carbattery"] = { ["metalscrap"] = 4, ["plastic"] = 4, ["copper"] = 4, } },
		{ ["axleparts"] = { ["steel"] = 4, ["iron"] = 4, } },
		{ ["sparetire"] = { ["rubber"] = 4, } },

				-- Example : Delete me --
		-- Support for multiple items in recipes --
		-- Support for multiple resulting items --
		-- Support to limit items to certain job roles --
		-- { ["cleaningkit"] = { ["rubber"] = 5, ["engine2"] = 1, ["plastic"] = 2 },
		-- 		["amount"] = 2, ["job"] = { ["mechanic"] = 4, ["tuner"] = 4, } },
				-- Example : Delete me --

	},
	Perform = {
		{ ["turbo"] = { ["steel"] = 10, ["iron"] = 10, } },
		{ ["car_armor"] = { ["plastic"] = 25, } },
		{ ["engine1"] = { ["steel"] = 10, ["iron"] = 10, ["plastic"] = 5, } },
		{ ["engine2"] = { ["steel"] = 20, ["iron"] = 20, ["plastic"] = 10, } },
		{ ["engine3"] = { ["steel"] = 30, ["iron"] = 30, ["plastic"] = 20, } },
		{ ["engine4"] = { ["steel"] = 50, ["iron"] = 50, ["plastic"] = 25, } },
		{ ["engine5"] = { ["steel"] = 100, ["iron"] = 100, ["plastic"] = 50, } },
		{ ["transmission1"] = { ["steel"] = 10, ["iron"] = 10, } },
		{ ["transmission2"] = { ["steel"] = 20, ["iron"] = 20,  } },
		{ ["transmission3"] = { ["steel"] = 30, ["iron"] = 30,  } },
		{ ["transmission4"] = { ["steel"] = 50, ["iron"] = 50,  } },
		{ ["brakes1"] = { ["steel"] = 10, ["copper"] = 5, } },
		{ ["brakes2"] = { ["steel"] = 20, ["copper"] = 10, } },
		{ ["brakes3"] = { ["steel"] = 40, ["copper"] = 20, } },
		{ ["suspension1"] = { ["iron"] = 10, ["rubber"] = 5, } },
		{ ["suspension2"] = { ["iron"] = 20, ["rubber"] = 10, } },
		{ ["suspension3"] = { ["iron"] = 30, ["rubber"] = 15, } },
		{ ["suspension4"] = { ["iron"] = 40, ["rubber"] = 20, } },
		{ ["suspension5"] = { ["iron"] = 50, ["rubber"] = 25, } },
		-- { ["bprooftires"] = { ["rubber"] = 1, } },
		-- { ["drifttires"] = { ["rubber"] = 1, } },
		-- { ["nos"] = { ["noscan"] = 1, } },
		-- { ["noscan"] = { ["steel"] = 1, } },
	},
	Cosmetic = {
		{ ["hood"] = { ["plastic"] = 10, ["aluminum"] = 5, } },
		{ ["roof"] = { ["plastic"] = 10, ["aluminum"] = 5, } },
		{ ["spoiler"] = { ["plastic"] = 10, ["aluminum"] = 5, } },
		{ ["bumper"] = { ["plastic"] = 10, ["aluminum"] = 5, } },
		{ ["skirts"] = { ["plastic"] = 10, ["aluminum"] = 5, } },
		{ ["exhaust"] = { ["iron"] = 10, ["steel"] = 5, } },
		{ ["seat"] = { ["plastic"] = 5, ["rubber"] = 5, } },
		{ ["livery"] = { ["plastic"] = 5, }, },
		{ ["tires"] = { ["rubber"] = 5, ["plastic"] = 5, } },
		{ ["horn"] = { ["metalscrap"] = 5, ["plastic"] = 10, } },
		{ ["internals"] = { ["plastic"] = 10, } },
		{ ["externals"] = { ["plastic"] = 10, } },
		{ ["customplate"] = { ["steel"] = 25, } },
		{ ["headlights"] = { ["plastic"] = 15, ["glass"] = 20, ["copper"] = 5, } },
		{ ["rims"] = { ["iron"] = 10, ["steel"] = 5, } },
		{ ["rollcage"] = { ["steel"] = 10, ["aluminum"] = 10, } },
		-- { ["noscolour"] = { ["plastic"] = 1, } },
	},
}

Stores = {
	ToolItems = {
		label = Loc[Config.Lan]["stores"].tools,
		items = {
			{ name = "mechanic_tools", price = 0, amount = 10, info = {}, type = "item", },
			{ name = "toolbox", price = 0, amount = 10, info = {}, type = "item", },
			{ name = "ducttape", price = 0, amount = 100, info = {}, type = "item", },
			{ name = "paintcan", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "tint_supplies", price = 0, amount = 50, info = {}, type = "item", },
			-- { name = "underglow_controller", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "cleaningkit", price = 0, amount = 100, info = {}, type = "item", },
			{ name = "sparetire", price = 0, amount = 100, info = {}, type = "item", },
			{ name = "axleparts", price = 0, amount = 1000, info = {}, type = "item", },
			{ name = "carbattery", price = 0, amount = 1000, info = {}, type = "item", },
			{ name = "sparkplugs", price = 0, amount = 1000, info = {}, type = "item", },
			{ name = "newoil", price = 0, amount = 1000, info = {}, type = "item", },
		},
	},
	PerformItems = {
		label = Loc[Config.Lan]["stores"].perform,
		items = {
			{ name = "turbo", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "engine1", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "engine2", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "engine3", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "engine4", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "engine5", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "transmission1", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "transmission2", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "transmission3", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "transmission4", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "brakes1", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "brakes2", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "brakes3", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "car_armor", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "suspension1", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "suspension2", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "suspension3", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "suspension4", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "suspension5", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "bprooftires", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "drifttires", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "nos", price = 0, amount = 50, info = {}, type = "item", },
		},
	},
	StoreItems = {
		label = Loc[Config.Lan]["stores"].cosmetic,
		items = {
			{ name = "hood", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "roof", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "spoiler", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "bumper", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "skirts", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "exhaust", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "seat", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "livery", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "tires", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "horn", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "internals", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "externals", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "customplate", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "headlights", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "rims", price = 0, amount = 100, info = {}, type = "item", },
			{ name = "rollcage", price = 0, amount = 50, info = {}, type = "item", },
			{ name = "noscolour", price = 0, amount = 50, info = {}, type = "item", },
		},
	},
}

-- No Touch
	-- This is corrective code to help simplify the stores for people removing the slot info
	-- Jim shops doesn"t use it but other inventories do
	-- Most people don"t even edit the slots, these lines generate the slot info autoamtically
Stores.StoreItems.slots = #Stores.StoreItems.items
for k in pairs(Stores.StoreItems.items) do Stores.StoreItems.items[k].slot = k end
Stores.PerformItems.slots = #Stores.PerformItems.items
for k in pairs(Stores.PerformItems.items) do Stores.PerformItems.items[k].slot = k end
Stores.ToolItems.slots = #Stores.ToolItems.items
for k in pairs(Stores.ToolItems.items) do Stores.ToolItems.items[k].slot = k end