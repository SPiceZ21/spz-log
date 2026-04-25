-- server/main.lua

local function GetPlayerInfo(src)
    if src == 0 or src == nil then return "Server/Console" end
    local identifiers = {
        steam = "",
        license = "",
        discord = "",
        ip = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then identifiers.steam = id
        elseif string.find(id, "license") then identifiers.license = id
        elseif string.find(id, "discord") then identifiers.discord = id
        elseif string.find(id, "ip") then identifiers.ip = id
        end
    end

    return string.format("**Name:** %s\n**Steam:** %s\n**License:** %s\n**Discord:** %s\n**IP:** %s", 
        GetPlayerName(src), identifiers.steam, identifiers.license, identifiers.discord, identifiers.ip)
end

local function WriteToFile(category, title, message)
    local logFile = LoadResourceFile(GetCurrentResourceName(), "logs.txt") or ""
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local newLog = string.format("[%s] [%s] %s: %s\n", timestamp, category:upper(), title, message)
    SaveResourceFile(GetCurrentResourceName(), "logs.txt", logFile .. newLog, -1)
end

local function SendWebhook(category, title, message, color, fields, src, thumbnail)
    local webhook = Config.Webhooks[category] or Config.Webhooks['default']
    
    -- Local logging
    WriteToFile(category, title, message)

    if webhook == 'YOUR_WEBHOOK_URL_HERE' or webhook == '' then
        print("^1[spz-log] ERROR: Webhook URL for category '" .. category .. "' is not configured!^7")
        return
    end

    local finalFields = fields or {}
    if src and src > 0 then
        table.insert(finalFields, { name = "Player Information", value = GetPlayerInfo(src), inline = false })
    end

    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color or Config.Colors['info'],
            ["fields"] = finalFields,
            ["thumbnail"] = { ["url"] = thumbnail or Config.Thumbnails[category] or "" },
            ["footer"] = {
                ["text"] = "SPiceZ Race Core | " .. os.date("%Y-%m-%d %H:%M:%S"),
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = Config.BotName,
        embeds = embed,
        avatar_url = Config.BotIcon
    }), { ['Content-Type'] = 'application/json' })
end

-- Event for client-side logging bridge
RegisterNetEvent('spz-log:server:Log', function(category, title, message, type, fields, thumbnail)
    local src = source
    local color = Config.Colors[type or 'info']
    SendWebhook(category, title, message, color, fields, src, thumbnail)
end)

-- Export for other resources to use
-- Usage: exports['spz-log']:Log(category, title, message, type, fields, src, thumbnail)
exports('Log', function(category, title, message, type, fields, src, thumbnail)
    local color = Config.Colors[type or 'info']
    SendWebhook(category, title, message, color, fields, src, thumbnail)
end)

-- Convenience exports
exports('Info', function(category, title, message, fields, src, thumbnail)
    SendWebhook(category, title, message, Config.Colors['info'], fields, src, thumbnail)
end)

exports('Success', function(category, title, message, fields, src, thumbnail)
    SendWebhook(category, title, message, Config.Colors['success'], fields, src, thumbnail)
end)

exports('Warning', function(category, title, message, fields, src, thumbnail)
    SendWebhook(category, title, message, Config.Colors['warning'], fields, src, thumbnail)
end)

exports('Error', function(category, title, message, fields, src, thumbnail)
    SendWebhook(category, title, message, Config.Colors['error'], fields, src, thumbnail)
end)

-- Example test command
RegisterCommand('testlog', function(source, args, rawCommand)
    if source == 0 then -- Console only
        exports['spz-log']:Log('system', 'System Test', 'This is a test log message from the console.', 'success', {
            { name = "Test Field", value = "Working correctly!", inline = true }
        })
        print("^2[spz-log] Test log sent!^7")
    end
end, true)
