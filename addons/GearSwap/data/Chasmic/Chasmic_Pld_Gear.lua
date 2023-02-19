function user_setup()

    -- Options: Override default values	
	state.OffenseMode:options('Normal','Acc')
    state.HybridMode:options('Tank','DDTank','BreathTank','Dawn','NoShellTank','Normal')
    state.WeaponskillMode:options('Match','Normal', 'Acc')
    state.CastingMode:options('Normal','SIRD')
	state.Passive:options('None','AbsorbMP')
    state.PhysicalDefenseMode:options('PDT','PDT_HP','Tank')
    state.MagicalDefenseMode:options('BDT','MDT_HP','AegisMDT','AegisNoShellMDT','OchainMDT','OchainNoShellMDT','MDT_Reraise')
	state.ResistDefenseMode:options('MEVA','MEVA_HP','Death','Charm')
	state.IdleMode:options('Normal','Tank','KiteTank','PDT','MDT','Refresh','Reraise')
	state.Weapons:options('None', 'SequenceOchain', 'SakpataAegis','SakpataOchain', 'SequenceAegis','SequenceBlurred', 'NaeglingBlurred', 'SakpataSrivatsa')
	
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode','None','MP','Twilight'}
	
	gear.fastcast_jse_back = {name="Rudianos's Mantle",augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10',}}
	gear.enmity_jse_back = {name="Rudianos's Mantle",augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10',}}

	-- Additional local binds
	send_command('bind !` gs c SubJobEnmity')
	send_command('bind ^backspace input /ja "Shield Bash" <t>')
	send_command('bind @backspace input /ja "Cover" <stpt>')
	send_command('bind !backspace input /ja "Sentinel" <me>')
	send_command('bind @= input /ja "Chivalry" <me>')
	send_command('bind != input /ja "Palisade" <me>')
	send_command('bind ^delete input /ja "Provoke" <stnpc>')
	send_command('bind !delete input /ma "Cure IV" <stal>')
	send_command('bind @delete input /ma "Flash" <stnpc>')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
	send_command('bind @` gs c cycle RuneElement')
	send_command('bind ^pause gs c toggle AutoRuneMode')
	send_command('bind @f8 gs c toggle AutoTankMode')
	send_command('bind @f10 gs c toggle TankAutoDefense')
	send_command('bind ^@!` gs c cycle SkillchainMode')
	send_command('bind !r gs c weapons SakpataAegis;c update')
	send_command('bind ^r gs c weapons SequenceAegis;gs c update')
    send_command('bind ^q gs c weapons SakpataOchain;gs c update')
    send_command('bind !q gs c weapons SequenceOchain;gs c update')
	
    select_default_macro_book()
    update_defense_mode()
end

function init_gear_sets()
	
	--------------------------------------
	-- Precast sets
	--------------------------------------
	
    sets.Enmity = {
		ammo="Sapience Orb",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Eschite Greaves", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		neck="Moonlight Necklace",
		waist="Flume Belt",
		left_ear="Friomisi Earring",
		right_ear="Loquac. Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back="Solemnity Cape",
	}
		
    sets.Enmity.SIRD = {
		ammo="Sapience Orb",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Eschite Greaves", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		neck="Moonlight Necklace",
		waist="Flume Belt",
		left_ear="Friomisi Earring",
		right_ear="Loquac. Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back="Solemnity Cape",
	}
		
    sets.Enmity.DT = {
		ammo="Sapience Orb",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Eschite Greaves", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		neck="Moonlight Necklace",
		waist="Flume Belt",
		left_ear="Friomisi Earring",
		right_ear="Loquac. Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back="Solemnity Cape",
	}
		
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = set_combine(sets.Enmity,{legs="Cab. Breeches +1"})
    sets.precast.JA['Holy Circle'] = set_combine(sets.Enmity,{feet="Rev. Leggings +3"})
    sets.precast.JA['Sentinel'] = set_combine(sets.Enmity,{feet="Cab. Leggings +1"})
    sets.precast.JA['Rampart'] = set_combine(sets.Enmity,{}) --head="Valor Coronet" (Also Vit?)
    sets.precast.JA['Fealty'] = set_combine(sets.Enmity,{body="Cab. Surcoat +1"})
    sets.precast.JA['Divine Emblem'] = set_combine(sets.Enmity,{feet="Chev. Sabatons +1"})
    sets.precast.JA['Cover'] = set_combine(sets.Enmity, {body="Cab. Surcoat +1"}) --head="Rev. Coronet +1",
	
    sets.precast.JA['Invincible'].DT = set_combine(sets.Enmity.DT,{legs="Cab. Breeches +1"})
    sets.precast.JA['Holy Circle'].DT = set_combine(sets.Enmity.DT,{feet="Rev. Leggings +3"})
    sets.precast.JA['Sentinel'].DT = set_combine(sets.Enmity.DT,{feet="Cab. Leggings +1"})
    sets.precast.JA['Rampart'].DT = set_combine(sets.Enmity.DT,{}) --head="Valor Coronet" (Also Vit?)
    sets.precast.JA['Fealty'].DT = set_combine(sets.Enmity.DT,{body="Cab. Surcoat +1"})
    sets.precast.JA['Divine Emblem'].DT = set_combine(sets.Enmity.DT,{feet="Chev. Sabatons +1"})
    sets.precast.JA['Cover'].DT = set_combine(sets.Enmity.DT, {body="Cab. Surcoat +1"}) --head="Rev. Coronet +1",
	
    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
		head="Sulevia's Mask +2",neck="Phalaina Locket",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
		body="Rev. Surcoat +3",hands="Cab. Gauntlets +1",ring1="Stikini Ring",ring2="Rufescent Ring",
		back=gear.enmity_jse_back,waist="Luminary Sash",legs="Carmine Cuisses +1",feet="Carmine Greaves +1"}

	sets.precast.JA['Shield Bash'] = set_combine(sets.Enmity, {hands="Cab. Gauntlets +1"})		
    sets.precast.JA['Provoke'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Warcry'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Palisade'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Intervene'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Defender'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Berserk'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Aggressor'] = set_combine(sets.Enmity, {})
	
	sets.precast.JA['Shield Bash'].DT = set_combine(sets.Enmity.DT, {hands="Cab. Gauntlets +1"})		
    sets.precast.JA['Provoke'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Warcry'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Palisade'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Intervene'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Defender'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Berserk'].DT = set_combine(sets.Enmity.DT, {})
	sets.precast.JA['Aggressor'].DT = set_combine(sets.Enmity.DT, {})

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		head="Carmine Mask +1",
		body="Rev. Surcoat +3",ring1="Asklepian Ring",ring2="Valseur's Ring",
		waist="Chaac Belt",legs="Sulev. Cuisses +2"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {ammo="Ginsen",
        head="Founder's Corona",neck="Combatant's Torque",ear1="Zennaroi Earring",ear2="Telos Earring",
        body="Tartarus Platemail",hands="Leyline Gloves",ring1="Ramuh Ring +1",ring2="Patricius Ring",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Founder's Greaves"}
		
	sets.precast.JA['Violent Flourish'] = {ammo="Ginsen",
        head="Founder's Corona",neck="Erra Pendant",ear1="Gwati Earring",ear2="Digni. Earring",
        body="Found. Breastplate",hands="Leyline Gloves",ring1="Defending Ring",ring2="Stikini Ring",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Founder's Greaves"}
		
	sets.precast.JA['Animated Flourish'] = set_combine(sets.Enmity, {})

    -- Fast cast sets for spells
    
    sets.precast.FC = {
		main="Sakpata's Sword",
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Sapience Orb",
		head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
		body="Sacro Breastplate",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+5','MND+3','Accuracy+6','Attack+5',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Creed Baudrier",
		left_ear="Thureous Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
		
    sets.precast.FC.DT = {ammo="Staunch Tathlum",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Odnowa Earring",
        body="Rev. Surcoat +3",hands="Souv. Handsch. +1",ring1="Moonbeam Ring",ring2="Moonbeam Ring",
        back="Moonlight Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Souveran Schuhs +1"}
		
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {neck="Diemer Gorget",ear1="Nourish. Earring",ear2="Nourish. Earring +1",body="Jumalik Mail"})
  
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear="Ishvara Earring",
		left_ring="Karieyh Ring",
		right_ring="Ifrit Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
		
    sets.precast.WS.DT = {ammo="Staunch Tathlum",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Odnowa Earring",
        body="Rev. Surcoat +3",hands="Souv. Handsch. +1",ring1="Moonbeam Ring",ring2="Moonbeam Ring",
        back="Moonlight Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Souveran Schuhs +1"}

    sets.precast.WS.Acc = {ammo="Hasty Pinion +1",
        head="Ynglinga Sallet",neck="Combatant's Torque",ear1="Zennaroi Earring",ear2="Telos Earring",
        body=gear.valorous_wsd_body,hands="Sulev. Gauntlets +2",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Sulev. Leggings +2"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring"})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",ear1="Zennaroi Earring",ear2="Moonshade Earring"})

	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",ear1="Brutal Earring",ear2="Moonshade Earring"})
    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",ear1="Zennaroi Earring",ear2="Moonshade Earring"})

	sets.precast.WS['Savage Blade'] = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear="Ishvara Earring",
		left_ring="Karieyh Ring",
		right_ring="Ifrit Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
    sets.precast.WS['Savage Blade'].Acc = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear="Ishvara Earring",
		left_ring="Karieyh Ring",
		right_ring="Ifrit Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
	
	sets.precast.WS['Flat Blade'] = {ammo="Ginsen",
        head="Founder's Corona",neck="Voltsurge Torque",ear1="Gwati Earring",ear2="Digni. Earring",
        body="Flamma Korazin +2",hands="Leyline Gloves",ring1="Defending Ring",ring2="Stikini Ring",
        back="Ground. Mantle +1",waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Founder's Greaves"}

	sets.precast.WS['Flat Blade'].Acc = {ammo="Ginsen",
        head="Flam. Zucchetto +2",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Digni. Earring",
        body="Flamma Korazin +2",hands="Flam. Manopolas +2",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back="Ground. Mantle +1",waist="Eschan Stone",legs="Flamma Dirs +2",feet="Flam. Gambieras +2"}

    sets.precast.WS['Sanguine Blade'] = {ammo="Dosis Tathlum",
        head="Jumalik Helm",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Crematio Earring",
        body="Jumalik Mail",hands="Founder's Gauntlets",ring1="Shiva Ring +1",ring2="Archon Ring",
        back="Toro Cape",waist="Fotia Belt",legs="Flamma Dirs +2",feet="Founder's Greaves"}

	sets.precast.WS['Sanguine Blade'].Acc = sets.precast.WS['Sanguine Blade']

    sets.precast.WS['Atonement'] = {ammo="Paeapua",
		head="Loess Barbuta +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Ishvara Earring",
		body=gear.valorous_wsd_body,hands=gear.odyssean_wsd_hands,ring1="Defending Ring",ring2="Moonbeam Ring",
		back=gear.enmity_jse_back,waist="Fotia Belt",legs="Flamma Dirs +2",feet="Eschite Greaves"}

    sets.precast.WS['Atonement'].Acc = sets.precast.WS['Atonement']
    sets.precast.WS['Spirits Within'] = sets.precast.WS['Atonement']
    sets.precast.WS['Spirits Within'].Acc = sets.precast.WS['Atonement']

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Cessance Earring",ear2="Brutal Earring",}
	sets.AccMaxTP = {ear1="Zennaroi Earring",ear2="Telos Earring"}


	--------------------------------------
	-- Midcast sets
	--------------------------------------

    sets.midcast.FastRecast = {main="Vampirism",ammo="Paeapua",
        head="Chev. Armet +1",neck="Voltsurge Torque",ear1="Enchntr. Earring +1",ear2="Loquacious Earring",
        body="Rev. Surcoat +3",hands="Leyline Gloves",ring1="Defending Ring",ring2="Kishar Ring",
        waist="Tempus Fugit",legs=gear.odyssean_fc_legs,feet="Odyssean Greaves"}
		
	sets.midcast.FastRecast.DT = {main="Vampirism",ammo="Staunch Tathlum",
        head="Souv. Schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Odnowa Earring",
        body="Rev. Surcoat +3",hands="Souv. Handsch. +1",ring1="Moonbeam Ring",ring2="Moonbeam Ring",
        back="Moonlight Cape",waist="Creed Baudrier",legs="Souv. Diechlings +1",feet="Souveran Schuhs +1"}

    sets.midcast.Flash = {
		main="Sequence",
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Sapience Orb",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Thureous Earring",
		right_ear="Friomisi Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back="Solemnity Cape",
	}
	sets.midcast.Flash.SIRD = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Yorium Cuirass", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+5','MND+3','Accuracy+6','Attack+5',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Knightly Earring",
		right_ear="Friomisi Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
    sets.midcast.Stun = set_combine(sets.Enmity, {})
	sets.midcast.Stun.SIRD = set_combine(sets.Enmity.SIRD, {})
	sets.midcast['Blue Magic'] = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Yorium Cuirass", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+5','MND+3','Accuracy+6','Attack+5',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Knightly Earring",
		right_ear="Friomisi Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
	sets.midcast['Blue Magic'].SIRD = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Yorium Cuirass", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+5','MND+3','Accuracy+6','Attack+5',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Knightly Earring",
		right_ear="Friomisi Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
	sets.midcast.Cocoon = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Yorium Cuirass", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+5','MND+3','Accuracy+6','Attack+5',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Knightly Earring",
		right_ear="Friomisi Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}

    sets.midcast.Cure = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+6','Mag. Acc.+10','Attack+7','Breath dmg. taken -2%',}},
		feet={ name="Odyssean Greaves", augments={'Mag. Acc.+22','"Cure" potency +4%','MND+1','"Mag.Atk.Bns."+15',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Nourish. Earring",
		right_ear="Loquac. Earring",
		left_ring="Moonlight Ring",
		right_ring="Gelatinous Ring",
		back="Moonlight Cape",
	}
		
    sets.midcast.Cure.SIRD = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+6','Mag. Acc.+10','Attack+7','Breath dmg. taken -2%',}},
		feet={ name="Odyssean Greaves", augments={'Mag. Acc.+22','"Cure" potency +4%','MND+1','"Mag.Atk.Bns."+15',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Nourish. Earring",
		right_ear="Loquac. Earring",
		left_ring="Moonlight Ring",
		right_ring="Gelatinous Ring",
		back="Moonlight Cape",
	}
		
    sets.midcast.Cure.DT = {
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+6','Mag. Acc.+10','Attack+7','Breath dmg. taken -2%',}},
		feet={ name="Odyssean Greaves", augments={'Mag. Acc.+22','"Cure" potency +4%','MND+1','"Mag.Atk.Bns."+15',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Nourish. Earring",
		right_ear="Loquac. Earring",
		left_ring="Moonlight Ring",
		right_ring="Gelatinous Ring",
		back="Moonlight Cape",
	}
	
    sets.midcast.Reprisal = {
		main="Sakpata's Sword",
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Sapience Orb",
		head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
		body="Shabti Cuirass",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Odyssean Greaves", augments={'"Fast Cast"+5','MND+3','Accuracy+6','Attack+5',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Thureous Earring",
		right_ear="Loquac. Earring",
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}

	sets.Self_Healing = {ammo="Staunch Tathlum",
	head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	legs={ name="Founder's Hose", augments={'MND+6','Mag. Acc.+10','Attack+7','Breath dmg. taken -2%',}},
	feet={ name="Odyssean Greaves", augments={'Mag. Acc.+22','"Cure" potency +4%','MND+1','"Mag.Atk.Bns."+15',}},
	neck="Moonlight Necklace",
	waist="Audumbla Sash",
	left_ear="Nourish. Earring",
	right_ear="Loquac. Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back="Moonlight Cape",}
		
	sets.Self_Healing.SIRD = {ammo="Staunch Tathlum",
	head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	legs={ name="Founder's Hose", augments={'MND+6','Mag. Acc.+10','Attack+7','Breath dmg. taken -2%',}},
	feet={ name="Odyssean Greaves", augments={'Mag. Acc.+22','"Cure" potency +4%','MND+1','"Mag.Atk.Bns."+15',}},
	neck="Moonlight Necklace",
	waist="Audumbla Sash",
	left_ear="Nourish. Earring",
	right_ear="Loquac. Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back="Moonlight Cape",}
		
	sets.Self_Healing.DT = {ammo="Staunch Tathlum",
	head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	legs={ name="Founder's Hose", augments={'MND+6','Mag. Acc.+10','Attack+7','Breath dmg. taken -2%',}},
	feet={ name="Odyssean Greaves", augments={'Mag. Acc.+22','"Cure" potency +4%','MND+1','"Mag.Atk.Bns."+15',}},
	neck="Moonlight Necklace",
	waist="Audumbla Sash",
	left_ear="Nourish. Earring",
	right_ear="Loquac. Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back="Moonlight Cape",}

	sets.Cure_Received = {hands="Souv. Handsch. +1",feet="Souveran Schuhs +1"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}

    sets.midcast['Enhancing Magic'] = {main="Sakpata's Sword",
	sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
	ammo="Sapience Orb",
	head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
	body="Shabti Cuirass",
	hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
	feet={ name="Odyssean Greaves", augments={'"Fast Cast"+5','MND+3','Accuracy+6','Attack+5',}},
	neck="Moonlight Necklace",
	waist="Creed Baudrier",
	left_ear="Thureous Earring",
	right_ear="Loquac. Earring",
	left_ring="Moonlight Ring",
	right_ring="Eihwaz Ring",
	back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},}
		
    sets.midcast['Enhancing Magic'].SIRD = {main="Colada",ammo="Staunch Tathlum",
		head="Souv. Schaller +1",neck="Incanter's Torque",ear1="Andoaa Earring",ear2="Odnowa Earring",
		body="Shab. Cuirass +1",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Moonbeam Ring",
		back="Merciful Cape",waist="Olympus Sash",legs="Carmine Cuisses +1",feet="Odyssean Greaves"}

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
    sets.midcast.Shell = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
	
	sets.midcast.Phalanx = {
		main="Sakpata's Sword",
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Staunch Tathlum",
		head={ name="Yorium Barbuta", augments={'Spell interruption rate down -9%','Phalanx +3',}},
		body={ name="Yorium Cuirass", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Yorium Cuisses", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Moonlight Necklace",
		waist="Olympus Sash",
		left_ear="Thureous Earring",
		right_ear="Loquac. Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
	sets.midcast.Phalanx.SIRD = {
		main="Sequence",
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Staunch Tathlum",
		head={ name="Yorium Barbuta", augments={'Spell interruption rate down -9%','Phalanx +3',}},
		body={ name="Yorium Cuirass", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Yorium Cuisses", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Moonlight Necklace",
		waist="Olympus Sash",
		left_ear="Thureous Earring",
		right_ear="Loquac. Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

    sets.resting = {ammo="Homiliary",
		head="Jumalik Helm",neck="Coatl Gorget +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Jumalik Mail",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Dark Ring",
		back="Moonlight Cape",waist="Fucho-no-obi",legs="Sulev. Cuisses +2",feet="Cab. Leggings +1"}

    -- Idle sets
    sets.idle = {
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Gelatinous Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},
	}
		
    sets.idle.PDT = {
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Gelatinous Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},
	}
		
    sets.idle.MDT = {
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Gelatinous Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},
	}
		
	sets.idle.Refresh = {main="Mafic Cudgel",sub="Ochain",ammo="Homiliary",
		head="Jumalik Helm",neck="Coatl Gorget +1",ear1="Etiolation Earring",ear2="Ethereal Earring",
		body="Jumalik Mail",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Dark Ring",
		back="Moonlight Cape",waist="Flume Belt",legs="Souv. Diechlings +1",feet="Cab. Leggings +1"}

	sets.idle.Tank = {main="Mafic Cudgel",sub="Ochain",ammo="Staunch Tathlum",
		head="Chev. Armet +1",neck="Loricate Torque +1",ear1="Creed Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Shadow Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Chev. Cuisses +1",feet="Souveran Schuhs +1"}
		
	sets.idle.KiteTank = {main="Mafic Cudgel",sub="Ochain",ammo="Staunch Tathlum",
		head="Loess Barbuta +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Thureous Earring",
		body="Tartarus Platemail",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Shadow Ring",
		back="Shadow Mantle",waist="Flume Belt",legs="Carmine Cuisses +1",feet="Hippo. Socks +1"}
		
    sets.idle.Reraise = {main="Mafic Cudgel",sub="Ochain",ammo="Staunch Tathlum",
		head="Twilight Helm",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Thureous Earring",
		body="Twilight Mail",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Dark Ring",
		back="Moonlight Cape",waist="Flume Belt",legs="Carmine Cuisses +1",feet="Cab. Leggings +1"}
		
    sets.idle.Weak = {main="Mafic Cudgel",sub="Ochain",ammo="Staunch Tathlum",
		head="Twilight Helm",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Thureous Earring",
		body="Twilight Mail",hands="Souv. Handsch. +1",ring1="Defending Ring",ring2="Moonbeam Ring",
		back="Moonlight Cape",waist="Flume Belt",legs="Carmine Cuisses +1",feet="Cab. Leggings +1"}
		
	sets.Kiting = {right_ring = "Shneddick ring"}

	sets.latent_refresh = {waist="Fucho-no-obi"}
	sets.latent_regen = {ring1="Apeile Ring +1",ring2="Apeile Ring"}
	sets.DayIdle = {}
	sets.NightIdle = {}

	--------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
	sets.Knockback = {}
    sets.MP = {head="Chev. Armet +1",neck="Coatl Gorget +1",ear2="Ethereal Earring",waist="Flume Belt",feet="Rev. Leggings +3"}
	sets.passive.AbsorbMP = {head="Chev. Armet +1",neck="Coatl Gorget +1",ear2="Ethereal Earring",waist="Flume Belt",feet="Rev. Leggings +3"}
    sets.MP_Knockback = {}
    sets.Twilight = {head="Twilight Helm", body="Twilight Mail"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {})
	
	-- Weapons sets
	sets.weapons.SakpataAegis = {main="Sakpata's Sword",sub="Aegis", waist="Carrier's Sash"}
	sets.weapons.SequenceBlurred = {main="Naegling",sub="Blurred Shield +1"}
	sets.weapons.SequenceAegis = {main="Sequence",sub="Aegis", waist="Carrier's Sash"}
	sets.weapons.SequenceOchain = {main="Sequence",sub="Ochain"}
	sets.weapons.SakpataOchain = {main="Sakpata's Sword",sub="Ochain"}
	sets.weapons.SakpataSrivatsa = {main = "Sakpata's Sword", sub ="Srivatsa", waist = "Carrier's Sash"}
	sets.weapons.NagelingBlurred = {main="Naegling", sub="Blurred Shield +1"}
    
    sets.defense.PDT = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
    sets.defense.PDT_HP = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
    sets.defense.MDT_HP = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
    sets.defense.MEVA_HP = {
		ammo="Staunch Tathlum",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Gelatinous Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},
	}

    sets.defense.PDT_Reraise = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
    sets.defense.MDT_Reraise = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}

	sets.defense.BDT = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
	sets.defense.Tank = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
	sets.defense.MEVA = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
	sets.defense.Death = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
	sets.defense.Charm = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
		-- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.OchainMDT = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
    sets.defense.OchainNoShellMDT = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
    sets.defense.AegisMDT = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}
		
    sets.defense.AegisNoShellMDT = {ammo="Staunch Tathlum",
	head="Sakpata's Helm",
	body="Sakpata's Plate",
	hands="Sakpata's Gauntlets",
	legs="Sakpata's Cuisses",
	feet="Sakpata's Leggings",
	neck={ name="Unmoving Collar +1", augments={'Path: A',}},
	waist="Olympus Sash",
	left_ear="Odnowa Earring +1",
	right_ear="Eabani Earring",
	left_ring="Moonlight Ring",
	right_ring="Gelatinous Ring",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Mag. Evasion+15',}},}		

	--------------------------------------
	-- Engaged sets
	--------------------------------------
    
	sets.engaged = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}

    sets.engaged.Acc = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}

    sets.engaged.DW = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}

    -- sets.engaged.DW.Acc = {ammo="Ginsen",
	-- 	head="Flam. Zucchetto +2",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
	-- 	body=gear.valorous_wsd_body,hands="Sulev. Gauntlets +2",ring1="Flamma Ring",ring2="Ramuh Ring +1",
	-- 	back="Letalis Mantle",waist="Olseni Belt",legs="Sulev. Cuisses +2",feet="Founder's Greaves"}

	sets.engaged.Tank = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
		
	sets.engaged.Dawn = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
		
	sets.engaged.BreathTank = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
		
	sets.engaged.DDTank = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}
		
	sets.engaged.Acc.DDTank = {
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Thureous Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
	}

	sets.engaged.NoShellTank = {
    ammo="Coiste Bodhar",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Telos Earring",
    right_ear="Thureous Earring",
    left_ring="Moonlight Ring",
    right_ring="Chirich Ring +1",
    back={ name="Weard Mantle", augments={'VIT+2','DEX+2','Enmity+2','Phalanx +3',}},
}
		
    -- sets.engaged.Reraise = set_combine(sets.engaged.Tank, sets.Reraise)
    -- sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc.Tank, sets.Reraise)
		
	--------------------------------------
	-- Custom buff sets
	--------------------------------------
	sets.buff.Doom = set_combine(sets.buff.Doom, {})
	sets.buff.Sleep = {neck="Vim Torque +1"}
    sets.buff.Cover = {body="Cab. Surcoat +1"}
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'NIN' then
        set_macro_page(2, 4)
    elseif player.sub_job == 'RUN' then
        set_macro_page(9, 4)
    elseif player.sub_job == 'RDM' then
        set_macro_page(6, 4)
    elseif player.sub_job == 'BLU' then
        set_macro_page(8, 4)
    elseif player.sub_job == 'DNC' then
        set_macro_page(4, 4)
    else
        set_macro_page(1, 4) --War/Etc
    end
end