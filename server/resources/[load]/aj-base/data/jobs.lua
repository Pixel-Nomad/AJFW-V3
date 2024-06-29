AJShared = AJShared or {}
AJShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
AJShared.Jobs = {
	unemployed = { label = 'Civilian', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Freelancer', payment = 10 } } },
	bus = { label = 'Bus', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	judge = { label = 'Honorary', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Judge', payment = 100 } } },
	lawyer = { label = 'Law Firm', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Associate', payment = 50 } } },
	reporter = { label = 'Reporter', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Journalist', payment = 50 } } },
	trucker = { label = 'Trucker', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	tow = { label = 'Towing', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	garbage = { label = 'Garbage', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Collector', payment = 50 } } },
	vineyard = { label = 'Vineyard', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Picker', payment = 50 } } },
	hotdog = { label = 'Hotdog', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Sales', payment = 50 } } },
	
	oilwell = {
        label = 'Oil Company',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Oilwell Operator', payment = 50 }, 
            ['1'] = { name = 'Oilwell Operator tier 2', payment = 75 }, 
            ['2'] = { name = 'Event Driver tier 2', payment = 100 }, 
            ['3'] = { name = 'Sales', payment = 125 }, 
            ['4'] = { name = 'CEO', isboss = true, payment = 150 }, 
		},
	},
	lspd = {
		label = 'Los Santos Police Department',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Cadet', payment = 75 },
			['2'] = { name = 'Officer', payment = 100 },
			['3'] = { name = 'Senior Officer', payment = 125 },
			['4'] = { name = 'Corporal', payment = 125 },
			['5'] = { name = 'Sergeant', payment = 125 },
			['6'] = { name = 'Lieutenant', payment = 125 },
			['7'] = { name = 'Captain', payment = 125 },
			['8'] = { name = 'Deputy Chief', payment = 125 },
			['9'] = { name = 'Assistant Chief', payment = 125 },
			['10'] = { name = 'Chief', payment = 125 },
			['11'] = { name = 'Commissioner', isboss = true, payment = 150 },
		},
	},
	bcso = {
		label = 'Blaine County Sheriff\'s Office',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Cadet', payment = 75 },
			['1'] = { name = 'Solo Cadet', payment = 75 },
			['2'] = { name = 'Deputy', payment = 100 },
			['3'] = { name = 'Senior Deputy', payment = 100 },
			['4'] = { name = 'Corporal', payment = 125 },
			['5'] = { name = 'Sergeant', payment = 125 },
			['6'] = { name = 'Lieutenant', payment = 125 },
			['7'] = { name = 'Undersheriff', payment = 125 },
			['8'] = { name = 'Sheriff', isboss = true, payment = 150 },
		},
	},
	sapr = {
		label = 'San Andreas Park Rangers',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Cadet', payment = 75 },
			['1'] = { name = 'Ranger', payment = 75 },
			['2'] = { name = 'Ranger 1st Class', payment = 100 },
			['3'] = { name = 'Senior Ranger', payment = 100 },
			['4'] = { name = 'Corporal', payment = 125 },
			['5'] = { name = 'Sergeant', payment = 125 },
			['6'] = { name = 'Lieutenant', payment = 125 },
			['7'] = { name = 'Deputy Game Warden', payment = 125 },
			['8'] = { name = 'Game Warden', isboss = true, payment = 150 },
		},
	},
	sahp = {
		label = 'San Andreas Highway Patrols',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Trooper', payment = 75 },
			['1'] = { name = 'Trooper First Class', payment = 100 },
			['2'] = { name = 'Senior Trooper', payment = 100 },
		},
	},
	doc = {
		label = 'Department Of Correction',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Cadet', payment = 75 },
			['1'] = { name = 'Solo Cadet', payment = 75 },
			['2'] = { name = 'Officer', payment = 75 },
			['3'] = { name = 'Senior Officer', payment = 75 },
			['4'] = { name = 'Corporal', payment = 125 },
			['5'] = { name = 'Sergeant', payment = 125 },
			['6'] = { name = 'Lieutenant', payment = 125 },
			['7'] = { name = 'Captian', payment = 125 },
			['8'] = { name = 'Deputy Warden', payment = 125 },
			['9'] = { name = 'Warden', isboss = true, payment = 150 },
		},
	},
	sapr = {
		label = 'San Andreas Park Rangers',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Cadet', payment = 75 },
			['1'] = { name = 'Ranger', payment = 75 },
			['2'] = { name = 'Ranger 1st Class', payment = 100 },
			['3'] = { name = 'Senior Ranger', payment = 100 },
			['4'] = { name = 'Corporal', payment = 125 },
			['5'] = { name = 'Sergeant', payment = 125 },
			['6'] = { name = 'Lieutenant', payment = 125 },
			['7'] = { name = 'Deputy Warden', payment = 125 },
			['8'] = { name = 'Warden', isboss = true, payment = 150 },
		},
	},
	swat = {
		label = 'Special Weapon and tactics',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Officer I', payment = 75 },
			['1'] = { name = 'Officer II', payment = 75 },
			['2'] = { name = 'Officer III', payment = 100 },
			['3'] = { name = 'Officer III+1', payment = 100 },
			['4'] = { name = 'Sergeant I', payment = 125 },
			['5'] = { name = 'Sergeant II', payment = 125 },
			['6'] = { name = 'Captain', payment = 125 },
			['7'] = { name = 'Commander', payment = 125 },
		},
	},
	sasp = {
		label = 'San Andreas State Police ',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'State Officer', payment = 75 },
			['1'] = { name = 'Sergeant', payment = 75 },
			['2'] = { name = 'Senior Sergeant', payment = 100 },
			['3'] = { name = 'Lieutenant', payment = 100 },
			['4'] = { name = 'Captain', payment = 125 },
			['5'] = { name = 'Deputy Commissioner', payment = 125 },
			['6'] = { name = 'Commissioner', payment = 125 },
		},
	},
	fib = {
		label = 'Federal Investigation Bureau',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Agent', payment = 100 },
			['1'] = { name = 'Senior Agent', payment = 100 },
			['2'] = { name = 'Supervisory Agent', payment = 125 },
			['3'] = { name = 'Deputy Director', payment = 125 },
			['4'] = { name = 'Director', payment = 125 },
		},
	},
	ambulance = {
		label = 'EMS',
		type = 'ems',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Paramedic', payment = 75 },
			['2'] = { name = 'Doctor', payment = 100 },
			['3'] = { name = 'Surgeon', payment = 125 },
			['4'] = { name = 'Chief', isboss = true, payment = 150 },
		},
	},
	["realestate"] = {
		label = "Realestate",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Company Owner",
				payment = 300
			},
			['1'] = {
				name = "Builder",
				payment = 600
			},
			['2'] = {
                name = 'Manager',
				isboss = true,
				bankAuth = true,
                payment = 150
            },
		}
	},
	taxi = {
		label = 'Taxi',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Driver', payment = 75 },
			['2'] = { name = 'Event Driver', payment = 100 },
			['3'] = { name = 'Sales', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
		},
	},
	cardealer = {
		label = 'Vehicle Dealer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Showroom Sales', payment = 75 },
			['2'] = { name = 'Business Sales', payment = 100 },
			['3'] = { name = 'Finance', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
		},
	},
	mechanic = {
		label = 'LS Customs',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
		},
	},
	mechanic2 = {
		label = 'LS Customs',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
		},
	},
	mechanic3 = {
		label = 'LS Customs',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
		},
	},
	beeker = {
		label = 'Beeker\'s Garage',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
		},
	},
	bennys = {
		label = 'Benny\'s Original Motor Works',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true, payment = 150 },
		},
	},
	["government"] = {
		label = "Government",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "State Security",
				payment = 600
			},
			['1'] = {
				name = "Employee",
				payment = 800
			},
			['2'] = {
				name = "State Accountant",
				payment = 1000
			},
			['3'] = {
				name = "State Treasure",
				payment = 1000
			},
			['4'] = {
				name = "Security Chief",
				payment = 1200
			},
			['5'] = {
				name = "Secretery",
				isboss = true,
				payment = 1400
			},
			['6'] = {
				name = "Mayor",
				isboss = true,
				payment = 2000
			},
			['7'] = {
				name = "Governor",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
		},
	},

	['merryweather'] = {
		label = 'Merry Weather',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = 'Intern',
                payment = 200
            },
			['1'] = {
                name = 'Employee',
                payment = 400
            },
			['2'] = {
                name = 'Manager',
                payment = 600
            },
			['3'] = {
                name = 'CEO',
                payment = 800
            },
			['4'] = {
                name = 'Owner',
                payment = 1000
            },
        },
	},
	['uwu'] = {
		label = 'UwU Cafe',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Trainee',
                payment = 50
            },
			['1'] = {
                name = 'Server',
                payment = 75
            },
			['2'] = {
                name = 'Chef',
                payment = 100
            },
			['3'] = {
                name = 'Head Chef',
                payment = 125
            },
			['4'] = {
                name = 'Assistant Manager',
                payment = 175
            },
			['5'] = {
                name = 'Manager',
				isboss = true,
                payment = 200
            },
			['6'] = {
                name = 'Owner',
				isboss = true,
                payment = 225
            },
        },
	},
	['doctor'] = {
		label = 'EMS',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Trainee",
                payment = 400
            },
            ['1'] = {
                name = "EMT",
                payment = 500
            },
            ['2'] = {
                name = "EMT ADVANCE",
                payment = 600
            },
            ['3'] = {
                name = "PARAMEDIC",
                payment = 800
            },
            ['4'] = {
                name = "SERGEANT",
                payment = 900
            },
            ['5'] = {
                name = "Specialist Doctor",
                payment = 1000
            },
            ['6'] = {
                name = "Lieutenant",
                payment = 1100
            },
            ['7'] = {
                name = "Captain",
				isboss = true,
                payment = 1200
            },
            ['8'] = {
                name = "Deputy EMS Chief",
				isboss = true,
                payment = 1300
            },
            ['9'] = {
                name = "EMS Chief",
				isboss = true,
				bankAuth = true,
                payment = 1400
			},
        },
	},

	--PDM 

	["pdm"] = {
		label = "PDM",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Salesman",
				payment = 200
			},
			['1'] = {
				name = "Senior Salesman",
				payment = 400
			},
			['2'] = {
				name = "Executive",
				payment = 600
			},
			['3'] = {
				name = "Manager",
				payment = 800
			},
			['4'] = {
				name = "CEO",
				isboss = true,
				payment = 1000
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
		},
	},


	--EDM 

	["edm"] = {
		label = "EDM",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Salesman",
				payment = 200
			},
			['1'] = {
				name = "Senior Salesman",
				payment = 400
			},
			['2'] = {
				name = "Executive",
				payment = 600
			},
			['3'] = {
				name = "Manager",
				payment = 800
			},
			['4'] = {
				name = "CEO",
				isboss = true,
				payment = 1000
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
		},
	},

	["tunner"] = {
		label = "Tunner",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Mechanic",
				payment = 200
			},
			['1'] = {
				name = "Salesman",
				payment = 400
			},
			['2'] = {
				name = "Experienced",
				payment = 600
			},
			['3'] = {
				name = "Manager",
				payment = 800
			},
			['4'] = {
				name = "CEO",
				isboss = true,
				payment = 1000
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
		},
	},

	['catcafe'] = {
		label = 'Cat Cafe',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit Chef', payment = 200 },
			['1'] = { name = 'Expert Chef', payment = 300 },
			['2'] = { name = 'Master Chef', payment = 400 },
			['3'] = { name = 'Manager',isboss = true, payment = 500 },
			['4'] = { name = 'Owner', isboss = true,bankAuth = true, payment = 600 },
        },
	},


	['mechanic'] = {
		label = 'Mechanic',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				isboss = true,
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
        },
	},

	['bennys'] = {
		label = 'Bennys',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				isboss = true,
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
        },
	},

	['hayes'] = {
		label = 'Hayes',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				isboss = true,
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
        },
	},

	['ottos'] = {
		label = 'Ottos',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				isboss = true,
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
        },
	},

	['importgarage'] = {
		label = 'Import Garage',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				isboss = true,
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
        },
	},

	['harmony'] = {
		label = 'Harmony',
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 250
			},
            ['1'] = {
				name = "Recuit",
				payment = 300
			},
			['2'] = {
				name = "Veteran",
				payment = 400
			},
			['3'] = {
				name = "Expert",
				payment = 600
			},
			['4'] = {
				name = "MANAGER",
				isboss = true,
				payment = 800
			},
			['5'] = {
				name = "Boss",
				isboss = true,
				bankAuth = true,
				payment = 50
			},
        },
	},

	["doj"] = {
		label = "DOJ",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Attorney",
				payment = 600
			},
			['1'] = {
				name = "State Attorney",
				payment = 800
			},
			['2'] = {
				name = "Attorney General",
				payment = 1000
			},
			['3'] = {
				name = "Judge",
				isboss = true,
				payment = 1200
			},
			['4'] = {
				name = "Chief Justice",
				isboss = true,
				bankAuth = true,
				payment = 1400
			},
		}
	},

	['reporter'] = {
		label = 'Weazel News',
		defaultDuty = true,
		grades = {
            ['0'] = {
				name = "RJ",
				payment = 400
			},
			['1'] = {
				name = "Reporter",
				payment = 600
			},
			['2'] = {
				name = "Senior Reporter",
				payment = 800
			},
			['3'] = {
				name = "Editor",
				payment = 1000
			},
			['4'] = {
				name = "CEO",
				isboss = true,
				payment = 1250
			},
			['5'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 1400
			},
        },
	},

	--Business 	

	-- Bahamas
	["bahamas"] = {
		label = "Bahamas",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 700
			},
		},
	},

	
	-- Comedy Club
	["comclub"] = {
		label = "Comedy Club",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 700
			},
		},
	},


	-- MCD
	["mcd"] = {
		label = "MCD",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 700
			},
		},
	},

	['beanmachine'] = {
		label = 'Bean Machine',
		defaultDuty = true,
		grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
			['1'] = { name = 'Novice', payment = 75 },
			['2'] = { name = 'Experienced', payment = 100 },
			['3'] = { name = 'Advanced', payment = 125 },
			['4'] = { name = 'Manager', isboss = true,bankAuth = true, payment = 150 },
        },
	},


	-- Recycle
	["recycle"] = {
		label = "Recycle",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 700
			},
		},
	},


	-- Dhaba
	["dhaba"] = {
		label = "Dhaba",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Ramu Kaka",
				payment = 150
			},
			['1'] = {
				name = "Kriya Karta",
				payment = 300
			},
			['2'] = {
				name = "Bawarchi",
				payment = 300
			},
			['3'] = {
				name = "Munshi ji",
				payment = 500
			},
			['4'] = {
				name = "Malik",
				isboss = true,
				bankAuth = true,
				payment = 700
			},
		},
	},

	["burgershot"] = {
		label = "Burgershot Employee",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Trainee",
				payment = 150
			},
			['1'] = {
				name = "Employee",
				payment = 300
			},
			['2'] = {
				name = "Burger Flipper",
				payment = 300
			},
			['3'] = {
				name = "Manager",
				payment = 500
			},
			['4'] = {
				name = "CEO",
				isboss = true,
				bankAuth = true,
				payment = 700
			},
		},
	},

	-- Taquilla
	["taq"] = {
		label = "Taquilla",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 450
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 700
			},
		},
	},

	--- Shop One
	["shopone"] = {
		label = "Shop One",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "CEO",
				payment = 500
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 1000
			},
		},
	},

	["littleteapot"] = {
		label = "The Little Teapot",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
			['1'] = {
				name = "Manager",
				payment = 500
			},
			['2'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 1000
			},
		},
	},

	["casino"] = {
		label = "Casino",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Staff",
				payment = 250
			},
			['1'] = {
				name = "Manager",
				payment = 500
			},
			['2'] = {
				name = "Ceo",
				payment = 750
			},
			['3'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 1000
			},
		},
	},

	["banker"] = {
		label = "Banker",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Staff",
				payment = 200
			},
			['1'] = {
				name = "Manager",
				payment = 400
			},
			['2'] = {
				name = "Ceo",
				payment = 600
			},
			['3'] = {
				name = "Owner",
				isboss = true,
				bankAuth = true,
				payment = 800
			},
		},
	},

	--BL JOBS

	['taxi'] = {
		label = 'Taxi',
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Driver',
                payment = 75
            },
			['2'] = {
                name = 'Event Driver',
                payment = 100
            },
			['3'] = {
                name = 'Sales',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
				bankAuth = true,
                payment = 150
            },
        },
	},

	["trucker"] = {
		label = "Amazon Delivery Job",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Driver",
				payment = 100
			},
		},
	},

	["tow"] = {
		label = "Tow",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Tow Worker",
				payment = 200
			},
		},
	},

	["postal"] = {
		label = "Postal OP",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Delivery",
				payment = 150
			},
		},
	},


	["garbage"] = {
		label = "Garbage Man",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Garbage Man",
				payment = 80
			},
		},
	},

	["hotdog"] = {
		label = "Hotdog",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Vendor",
				payment = 80
			},
		},
	},

	["financer"] = {
		label = "Financer",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 250
			},
		},
	},

	["bigboss"] = {
		label = "Overwatch",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Employee",
				payment = 1000
			},
		},
	},

	["contractor"] = {
		label = "Contractor",
		defaultDuty = true,
		grades = {
			['0'] = {
				name = "Boss",
				payment = 250
			},
		},
	},
}
