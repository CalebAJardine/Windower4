_addon.version = '1.0'
_addon.name = 'SingerReset'
_addon.command = 'sr'
_addon.author = 'Chasmic'

require('tables')
require('luau')
packets = require('packets')
local counter = 0

windower.register_event('prerender', function(text)
    counter = counter +1
    if counter == 1  then
        windower.send_command('input //lua unload singer')
    end
    if counter == 61 then
        windower.send_command('input //lua load singer')
    end
    if counter == 121 then
        windower.send_command('input //sing') 
    end
    if counter == 12601 then counter = 0 end
end)