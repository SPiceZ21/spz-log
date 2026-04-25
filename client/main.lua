-- client/main.lua

-- Export for client-side scripts to use
-- Usage: exports['spz-log']:Log(category, title, message, type, fields)
exports('Log', function(category, title, message, type, fields)
    TriggerServerEvent('spz-log:server:Log', category, title, message, type, fields)
end)

-- Convenience exports
exports('Info', function(category, title, message, fields)
    TriggerServerEvent('spz-log:server:Log', category, title, message, 'info', fields)
end)

exports('Success', function(category, title, message, fields)
    TriggerServerEvent('spz-log:server:Log', category, title, message, 'success', fields)
end)

exports('Warning', function(category, title, message, fields)
    TriggerServerEvent('spz-log:server:Log', category, title, message, 'warning', fields)
end)

exports('Error', function(category, title, message, fields)
    TriggerServerEvent('spz-log:server:Log', category, title, message, 'error', fields)
end)
