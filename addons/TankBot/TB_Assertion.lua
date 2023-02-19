local as = {}

function as.can_use(spell)
	local player = windower.ffxi.get_player()
	if (player == nil) or (spell == nil) then return false end
	if S{'/magic','/ninjutsu','/song'}:contains(spell.prefix) then
		local learned = windower.ffxi.get_spells()[spell.id]
		if learned then
			local mj,sj = player.main_job_id,player.sub_job_id
			local mainCanCast = (spell.levels[mj] ~= nil) and (spell.levels[mj] <= player.main_job_level)
			local subCanCast = (spell.levels[sj] ~= nil) and (spell.levels[sj] <= player.sub_job_level)
			return mainCanCast or subCanCast
		end
	elseif S{'/jobability','/pet'}:contains(spell.prefix) then
		local available_jas = S(windower.ffxi.get_abilities().job_abilities)
		return available_jas:contains(spell.id)
	elseif (spell.prefix == '/weaponskill') then
		local available_wss = S(windower.ffxi.get_abilities().weapon_skills)
		return available_wss:contains(spell.id)
	else
		atc(123,'Error: Unknown spell prefix ('..tostring(spell.prefix)..') for '..tostring(spell.en))
	end
	return false
end

function as.ready_to_use(spell)
	if (spell ~= nil) and as.can_use(spell) then
		local player = windower.ffxi.get_player()
		if (player == nil) then return false end
		if S{'/magic','/ninjutsu','/song'}:contains(spell.prefix) then
			local rc = windower.ffxi.get_spell_recasts()[spell.recast_id]
			return rc == 0
		elseif S{'/jobability','/pet'}:contains(spell.prefix) then
			local rc = windower.ffxi.get_ability_recasts()[spell.recast_id]
			return rc == 0
		elseif (spell.prefix == '/weaponskill') then
			return (player.status == 1) and (player.vitals.tp > 999)
		end
	end
	return false
end

function as.target_is_valid(action, target)
	if (type(target) == 'string') then
		target = getTarget(target)	--TODO: FIX!! (in HealBot_utils.lua)
	end
	local me = windower.ffxi.get_player()
	local targetType = 'None'
	if (target.in_alliance) then
		if (target.in_party) then
			if (me.name == target.name) then
				targetType = 'Self'
			else
				targetType = 'Party'
			end
		else
			targetType = 'Ally'
		end
	end
	return S(action.targets):contains(targetType)
end

function as.in_casting_range(name)
	local target = getTarget(name)
	if (target ~= nil) then
		return math.sqrt(target.distance) < 20.9
	end
	return false
end

function as.buff_active(...)
	local args = S{...}:map(string.lower)
	local player = windower.ffxi.get_player()
	if (player ~= nil) and (player.buffs ~= nil) then
		for _,bid in pairs(player.buffs) do
			local buff = res.buffs[bid]
			if args:contains(buff.en:lower()) then
				return true
			end
		end
	end
	return false
end

return as