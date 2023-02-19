-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal',--[['SomeAcc','Acc','FullAcc','Fodder',--]] 'TH')
    state.HybridMode:options('Normal','PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Match','Normal','SomeAcc','Acc','FullAcc','Fodder')
	state.IdleMode:options('Normal', 'Sphere')
    state.PhysicalDefenseMode:options('PDT, TH')
	state.MagicalDefenseMode:options('MDT')
	state.ResistDefenseMode:options('MEVA')
	state.Weapons:options('Kill','TreasureHunter','SwordProc','StaffProc')

    state.ExtraMeleeMode = M{['description']='Extra Melee Mode','None','Suppa','DWEarrings','DWMax'}
	state.AmbushMode = M(false, 'Ambush Mode')

	gear.da_jse_back = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}}
	gear.wsd_jse_back = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind !` input /ra <t>')
	send_command('bind @` gs c cycle SkillchainMode')
	send_command('bind @f10 gs c toggle AmbushMode')
	send_command('bind ^backspace gs c weapons StaffProc;gs c update')
	send_command('bind !backspace input /ja "Hide" <me>')
    send_command('bind !r gs c weapons SwordProc;gs c update')
    send_command('bind ^r gs c weapons Kill;gs c update')
    send_command('bind !q gs c weapons TreasureHunter;gs c update')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

	sets.TreasureHunter = {
        ammo="Ginsen",
        head="Malignance Chapeau",
        body="Meg. Cuirie +2",
        hands={ name="Plun. Armlets +1", augments={'Enhances "Perfect Dodge" effect',}},
        legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
        feet="Skulk. Poulaines +1",
        neck="Loricate Torque +1",
        waist="Chaac Belt",
        left_ear="Telos Earring",
        right_ear="Sherida Earring",
        left_ring="Defending Ring",
        right_ring="Gelatinous Ring",
        back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},
}
    sets.ExtraRegen = {}
    sets.Kiting = {feet="Skadi's Jambeaux +1"}

	sets.buff.Doom = set_combine(sets.buff.Doom, {})
	sets.buff.Sleep = {head="Frenzy Sallet"}
	
    sets.buff['Sneak Attack'] = {}
    sets.buff['Trick Attack'] = {}
    sets.buff['Steal'] = sets.TreasureHunter
		
    -- Extra Melee sets.  Apply these on top of melee sets.
    sets.Knockback = {}
	sets.Suppa = {ear1="Suppanomimi", ear2="Sherida Earring"}
	sets.DWEarrings = {ear1="Dudgeon Earring",ear2="Heartseeker Earring"}
	sets.DWMax = {ear1="Dudgeon Earring",ear2="Heartseeker Earring",body="Adhemar Jacket +1",hands="Floral Gauntlets",waist="Reiki Yotai"}
	sets.Ambush = {} --body="Plunderer's Vest +1"
	
	-- Weapons sets
	sets.weapons.Kill = { main="Kaja Knife", sub={name="Taming Sari", augments={'STR+9','DEX+8','DMG:+14',}}}
	sets.weapons.TreasureHunter = { main="Plun. Knife", sub={ name="Sandung", augments={'Accuracy+50','Crit. hit rate+5%','"Triple Atk."+3',}},}
    sets.weapons.SwordProc = {main ="Tanmogayi +1"}
    sets.weapons.StaffProc = {main ="Earth Staff"}
	sets.weapons.Throwing = {main="Aeneas",sub="Taming Sari",range="Comet Tail",ammo=empty}
	
    -- Actions we want to use to tag TH.
    sets.precast.Step = {ammo="Falcon Eye",
        head="Dampening Tam",neck="Combatant's Torque",ear1="Telos Earring",ear2="Digni. Earring",
        body="Mummu Jacket +2",hands="Adhemar Wrist. +1",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back=gear.da_jse_back,waist="Olseni Belt",legs="Mummu Kecks +2",feet=gear.herculean_acc_feet}
		
    sets.precast.JA['Violent Flourish'] = {ammo="Falcon Eye",
        head="Dampening Tam",neck="Combatant's Torque",ear1="Telos Earring",ear2="Digni. Earring",
        body="Mummu Jacket +2",hands="Adhemar Wrist. +1",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back=gear.da_jse_back,waist="Olseni Belt",legs="Mummu Kecks +2",feet=gear.herculean_acc_feet}
		
	sets.precast.JA['Animated Flourish'] = sets.TreasureHunter
	sets.precast.JA.Provoke = sets.TreasureHunter

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {} --head="Skulker's Bonnet"
    sets.precast.JA['Accomplice'] = {} --head="Skulker's Bonnet"
    sets.precast.JA['Flee'] = {} --feet="Pillager's Poulaines +1"
    sets.precast.JA['Hide'] = {} --body="Pillager's Vest +1"
    sets.precast.JA['Conspirator'] = {} --body="Skulker's Vest"
    sets.precast.JA['Steal'] = {hands="Pill. Armlets +1"}
	sets.precast.JA['Mug'] = {}
    sets.precast.JA['Despoil'] = {legs="Skulker's Culottes",feet="Skulk. Poulaines +1"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = {} -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Yamarang",
        head="Mummu Bonnet +2",neck="Unmoving Collar +1",ear1="Enchntr. Earring +1",ear2="Handler's Earring +1",
        body=gear.herculean_waltz_body,hands=gear.herculean_waltz_hands,ring1="Defending Ring",ring2="Valseur's Ring",
        back="Moonlight Cape",waist="Chaac Belt",legs="Dashing Subligar",feet=gear.herculean_waltz_feet}

	sets.Self_Waltz = {head="Mummu Bonnet +2",body="Passion Jacket",ring1="Asklepian Ring"}
		
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = {ammo="Impatiens",
		head=gear.herculean_fc_head,neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Loquacious Earring",
		body="Dread Jupon",hands="Leyline Gloves",ring1="Lebeche Ring",ring2="Prolix Ring",
		legs="Rawhide Trousers"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})


    -- Ranged snapshot gear
    sets.precast.RA = {range="Comet Tail"}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Falcon Eye",
        head="Dampening Tam",neck="Caro Necklace",ear1="Brutal Earring",ear2="Sherida Earring",
        body="Adhemar Jacket +1",hands="Meg. Gloves +2",ring1="Ilabrat Ring",ring2="Regal Ring",
        back=gear.da_jse_back,waist="Grunfeld Rope",legs="Samnuha Tights",feet=gear.herculean_wsd_feet}
    sets.precast.WS.SomeAcc = set_combine(sets.precast.WS, {neck="Combatant's Torque"})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {neck="Combatant's Torque",ear1="Telos Earring",body="Meg. Cuirie +2",waist="Olseni Belt",legs="Meg. Chausses +2",feet=gear.herculean_acc_feet})
	sets.precast.WS.FullAcc = set_combine(sets.precast.WS, {neck="Combatant's Torque",ear1="Telos Earring",body="Meg. Cuirie +2",waist="Olseni Belt",legs="Meg. Chausses +2",feet=gear.herculean_acc_feet})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS["Rudra's Storm"] = {
        ammo="Jukukik Feather",
        head={ name="Herculean Helm", augments={'Attack+7','Weapon skill damage +3%','STR+14','Accuracy+11',}},
        body="Meg. Cuirie +2",
        hands="Meg. Gloves +2",
        legs={ name="Lustratio Subligar", augments={'Accuracy+15','DEX+5','Crit. hit rate+2%',}},
        feet={ name="Herculean Boots", augments={'Accuracy+16','Weapon skill damage +4%','Attack+12',}},
        neck="Fotia Gorget",
        waist="Grunfeld Rope",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Sherida Earring",
        left_ring="Karieyh Ring",
        right_ring="Ramuh Ring",
        back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},
    }


    sets.precast.WS["Mandalic Stab"] = set_combine(sets.precast.WS, {head="Lilitu Headpiece",neck="Caro Necklace",ear1="Moonshade Earring",ear2="Ishvara Earring",body="Meg. Cuirie +2",back=gear.wsd_jse_back})
    sets.precast.WS["Mandalic Stab"].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {head="Lilitu Headpiece",neck="Caro Necklace",ear1="Moonshade Earring",body="Meg. Cuirie +2",back=gear.wsd_jse_back})
    sets.precast.WS["Mandalic Stab"].Acc = set_combine(sets.precast.WS.Acc, {ear1="Moonshade Earring",body="Meg. Cuirie +2",back=gear.wsd_jse_back})
	sets.precast.WS["Mandalic Stab"].FullAcc = set_combine(sets.precast.WS.FullAcc, {back=gear.wsd_jse_back})
    sets.precast.WS["Mandalic Stab"].Fodder = set_combine(sets.precast.WS["Mandalic Stab"], {body=gear.herculean_wsd_body})
    sets.precast.WS["Mandalic Stab"].SA = set_combine(sets.precast.WS["Mandalic Stab"].Fodder, {ammo="Yetshila",head="Adhemar Bonnet +1",body="Meg. Cuirie +2",legs="Darraigner's Brais"})
    sets.precast.WS["Mandalic Stab"].TA = set_combine(sets.precast.WS["Mandalic Stab"].Fodder, {ammo="Yetshila",head="Adhemar Bonnet +1",body="Meg. Cuirie +2",legs="Darraigner's Brais"})
    sets.precast.WS["Mandalic Stab"].SATA = set_combine(sets.precast.WS["Mandalic Stab"].Fodder, {ammo="Yetshila",head="Adhemar Bonnet +1",body="Meg. Cuirie +2",legs="Darraigner's Brais"})

    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {head="Lilitu Headpiece",neck="Caro Necklace",ear1="Moonshade Earring",ear2="Ishvara Earring",body="Meg. Cuirie +2",back=gear.wsd_jse_back})
    sets.precast.WS["Shark Bite"].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {head="Lilitu Headpiece",neck="Caro Necklace",ear1="Moonshade Earring",body="Meg. Cuirie +2",back=gear.wsd_jse_back})
    sets.precast.WS["Shark Bite"].Acc = set_combine(sets.precast.WS.Acc, {ear1="Moonshade Earring",body="Meg. Cuirie +2",back=gear.wsd_jse_back})
	sets.precast.WS["Shark Bite"].FullAcc = set_combine(sets.precast.WS.FullAcc, {back=gear.wsd_jse_back})
    sets.precast.WS["Shark Bite"].Fodder = set_combine(sets.precast.WS["Shark Bite"], {body=gear.herculean_wsd_body})
    sets.precast.WS["Shark Bite"].SA = set_combine(sets.precast.WS["Shark Bite"].Fodder, {ammo="Yetshila",head="Adhemar Bonnet +1",body="Meg. Cuirie +2",legs="Darraigner's Brais"})
    sets.precast.WS["Shark Bite"].TA = set_combine(sets.precast.WS["Shark Bite"].Fodder, {ammo="Yetshila",head="Adhemar Bonnet +1",body="Meg. Cuirie +2",legs="Darraigner's Brais"})
    sets.precast.WS["Shark Bite"].SATA = set_combine(sets.precast.WS["Shark Bite"].Fodder, {ammo="Yetshila",head="Adhemar Bonnet +1",body="Meg. Cuirie +2",legs="Darraigner's Brais"})
	
    sets.precast.WS['Evisceration'] = {ammo="Jukukik Feather",
    head={ name="Adhemar Bonnet", augments={'STR+10','DEX+10','Attack+15',}},
    body="Meg. Cuirie +2",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Lustratio Subligar", augments={'Accuracy+15','DEX+5','Crit. hit rate+2%',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Brutal Earring",
    right_ear="Sherida Earring",
    left_ring="Ilabrat Ring",
    right_ring="Begrudging ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}
    -- sets.precast.WS['Evisceration'].SomeAcc = set_combine(sets.precast.WS.SomeAcc, {head="Adhemar Bonnet +1",neck="Fotia Gorget",body="Abnoba Kaftan",hands="Mummu Wrists +2",ring1="Begrudging Ring",waist="Fotia Belt",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"})
    -- sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS.Acc, {head="Mummu Bonnet +2",ring1="Begrudging Ring",neck="Fotia Gorget",body="Sayadio's Kaftan",hands="Mummu Wrists +2",waist="Fotia Belt",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"})
	-- sets.precast.WS['Evisceration'].FullAcc = set_combine(sets.precast.WS.FullAcc, {head="Mummu Bonnet +2",body="Mummu Jacket +2",hands="Mummu Wrists +2",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"})
	-- sets.precast.WS['Evisceration'].Fodder = set_combine(sets.precast.WS['Evisceration'], {})
    -- sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Fodder, {})
    -- sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Fodder, {})
    -- sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Fodder, {})

    sets.precast.WS['Last Stand'] = {
        head="Mummu Bonnet +2",neck="Fotia Gorget",ear1="Clearview Earring",ear2="Neritic Earring",
        body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Apate Ring",ring2="Regal Ring",
        back=gear.wsd_jse_back,waist="Fotia Belt",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"}

    sets.precast.WS['Aeolian Edge'] = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+7','Weapon skill damage +3%','STR+14','Accuracy+11',}},
    body={ name="Herculean Vest", augments={'Weapon skill damage +3%','DEX+10','Accuracy+8','Attack+13',}},
    hands={ name="Herculean Gloves", augments={'Accuracy+22','Weapon skill damage +3%','DEX+8','Attack+11',}},
    legs="Meg. Chausses +2",
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Ishvara Earring",
    right_ear="Friomisi Earring",
    left_ring="Karieyh Ring",
    right_ring="Acumen Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Ishvara Earring",ear2="Sherida Earring"}
	sets.AccMaxTP = {ear1="Zennaroi Earring",ear2="Sherida Earring"}

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head=gear.herculean_fc_head,neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Loquacious Earring",
        body="Dread Jupon",hands="Leyline Gloves",ring1="Defending Ring",ring2="Prolix Ring",
        back="Moonlight Cape",waist="Tempus Fugit",legs="Rawhide Trousers",feet=gear.herculean_dt_feet}

    -- Specific spells
	sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {back="Mujin Mantle"})

	sets.midcast.Dia = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast['Dia II'] = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast['Bio II'] = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)

    -- Ranged gear

    sets.midcast.RA = {
        head="Mummu Bonnet +2",neck="Combatant's Torque",ear1="Clearview Earring",ear2="Neritic Earring",
        body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Apate Ring",ring2="Regal Ring",
        back=gear.da_jse_back,waist="Chaac Belt",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"}

    sets.midcast.RA.Acc = {
        head="Mummu Bonnet +2",neck="Combatant's Torque",ear1="Clearview Earring",ear2="Neritic Earring",
        body="Mummu Jacket +2",hands="Mummu Wrists +2",ring1="Apate Ring",ring2="Regal Ring",
        back=gear.da_jse_back,waist="Chaac Belt",legs="Mummu Kecks +2",feet="Mummu Gamash. +2"}

    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {ammo="Staunch Tathlum",
        head="Dampening Tam",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Meg. Cuirie +2",hands=gear.herculean_dt_hands,ring1="Defending Ring",ring2="Sheltered Ring",
        back="Moonlight Cape",waist="Flume Belt",legs=gear.herculean_dt_legs,feet="Jute Boots +1"}
		
    sets.idle.Sphere = set_combine(sets.idle, {body="Mekosu. Harness"})

    sets.idle.Weak = set_combine(sets.idle, {})

	sets.DayIdle = {}
	sets.NightIdle = {}

    -- Defense sets

    sets.defense.PDT = {ammo="Staunch Tathlum",
        head="Dampening Tam",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Meg. Cuirie +2",hands=gear.herculean_dt_hands,ring1="Defending Ring",ring2="Dark Ring",
        back="Shadow Mantle",waist="Flume Belt",legs=gear.herculean_dt_legs,feet=gear.herculean_dt_feet}

    sets.defense.MDT = {ammo="Staunch Tathlum",
        head="Dampening Tam",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Meg. Cuirie +2",hands="Floral Gauntlets",ring1="Defending Ring",ring2="Dark Ring",
        back="Engulfer Cape +1",waist="Engraved Belt",legs=gear.herculean_dt_legs,feet="Ahosi Leggings"}
		
	sets.defense.MEVA = {ammo="Staunch Tathlum",
		head=gear.herculean_fc_head,neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Adhemar Jacket +1",hands="Leyline Gloves",ring1="Vengeful Ring",ring2="Purity Ring",
		back="Mujin Mantle",waist="Engraved Belt",legs="Mummu Kecks +2",feet="Ahosi Leggings"}


    --------------------------------------
    -- Melee sets  
    --------------------------------------

    -- Normal melee group
    sets.engaged = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}
        
    sets.engaged.TH = {
        ammo="Ginsen",
        head="Malignance Chapeau",
        body="Meg. Cuirie +2",
        hands={ name="Plun. Armlets +1", augments={'Enhances "Perfect Dodge" effect',}},
        legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
        feet="Skulk. Poulaines +1",
        neck="Loricate Torque +1",
        waist="Chaac Belt",
        left_ear="Telos Earring",
        right_ear="Sherida Earring",
        left_ring="Defending Ring",
        right_ring="Gelatinous Ring",
        back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},
    }

    sets.engaged.SomeAcc = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}
    
	sets.engaged.Acc = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}
		
    sets.engaged.FullAcc = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}

    sets.engaged.Fodder = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}

    sets.engaged.PDT = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}

    sets.engaged.SomeAcc.PDT = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}
		
    sets.engaged.Acc.PDT = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}

    sets.engaged.FullAcc.PDT = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}
		
    sets.engaged.Fodder.PDT = {ammo="Ginsen",
    head={ name="Herculean Helm", augments={'Attack+18','"Triple Atk."+3','STR+7',}},
    body={ name="Herculean Vest", augments={'Accuracy+18','"Triple Atk."+4','STR+7','Attack+12',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
    feet={ name="Herculean Boots", augments={'Attack+18','"Triple Atk."+4','DEX+7','Accuracy+7',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Sherida Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+4','"Store TP"+4',}},}
		
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(8, 5)
    elseif player.sub_job == 'WAR' then
        set_macro_page(7, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(10, 5)
    else
        set_macro_page(6, 5)
    end
end