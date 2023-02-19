--[[
Copyright © 2016, Sammeh of Quetzalcoatl
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Skillup nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Sammeh BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]



_addon.name = 'skillup'
_addon.author = 'Sammeh'
_addon.version = '1.0'
_addon.command = 'skillup'


require('chat')

delay_for_stone = 10
delay = 3  -- how much delay in between spells
spell_list = T{
	[1] = 'Stun',
	[2] = 'Bio',
	[3] = 'Bio II',
	[4] = 'Drain',
	[5] = 'Aspir',
	[6] = 'Drain II',
	[7] = 'Aspir II',
	[8] = 'Drain III'
	
}


continue=0

windower.register_event('addon command', function(...)
	local args = T{...}
    local cmd = args[1]
	if cmd then 
		if cmd:lower() == 'stop' then
			continue = 0
		end
	else
		continue = 1
	end
	skill_up()
end)

function skill_up()
	while continue == 1 do
		for i,v in pairs(spell_list) do
			windower.send_command('input /ma ' ..v.. ' <t>')
			coroutine.sleep(delay)
		end
		
	end
end

-- while continue == 1 do
-- 	for i,v in pairs(spell_list) do
-- 		if v == 'Cure' or v == 'Cure II' then
-- 			windower.send_command('input /ma "'..v..'" Chasmic')
-- 		else
-- 			windower.send_command('input /ma "'..v..'" <me>')
-- 		end
-- 	coroutine.sleep(delay)
-- 	end
-- end
