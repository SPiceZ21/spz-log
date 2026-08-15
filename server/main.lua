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

local DISCORD_API = 'https://discord.com/api/v10'

local function botToken()
    return GetConvar('spz_discord_token', '')
end

-- Post an embed array to a channel via the bot token (Authorization: Bot ...).
local function PostViaBot(channel, embed)
    PerformHttpRequest(DISCORD_API .. '/channels/' .. channel .. '/messages',
        function(status)
            if status ~= 200 then
                print(("^3[spz-log] bot post failed ch=%s HTTP %s^7"):format(channel, tostring(status)))
            end
        end, 'POST', json.encode({ embeds = embed }), {
            ['Authorization'] = 'Bot ' .. botToken(),
            ['Content-Type']  = 'application/json',
        })
end

-- Post via a legacy webhook URL (also carries username/avatar).
local function PostViaWebhook(url, embed)
    PerformHttpRequest(url, function() end, 'POST', json.encode({
        username = Config.BotName, avatar_url = Config.BotIcon, embeds = embed,
    }), { ['Content-Type'] = 'application/json' })
end

local function SendWebhook(category, title, message, color, fields, src, thumbnail)
    -- Local logging (always).
    WriteToFile(category, title, message)

    local finalFields = fields or {}
    if src and src > 0 then
        table.insert(finalFields, { name = "Player Information", value = GetPlayerInfo(src), inline = false })
    end

    local embed = {
        {
            ["title"]       = title,
            ["description"] = message,
            ["type"]        = "rich",
            ["color"]       = color or Config.Colors['info'],
            ["fields"]      = finalFields,
            ["thumbnail"]   = { ["url"] = thumbnail or Config.Thumbnails[category] or "" },
            ["footer"]      = { ["text"] = "SPiceZ Race Core | " .. os.date("%Y-%m-%d %H:%M:%S") },
        }
    }

    -- Prefer the bot + channel id; fall back to a webhook if no channel is set.
    local channel = Config.Channels[category] or Config.Channels['default']
    if Config.UseBot and botToken() ~= '' and channel and channel ~= '' then
        PostViaBot(channel, embed)
        return
    end

    local webhook = Config.Webhooks[category] or Config.Webhooks['default']
    if webhook and webhook ~= '' and webhook ~= 'YOUR_WEBHOOK_URL_HERE' then
        PostViaWebhook(webhook, embed)
        return
    end

    print(("^1[spz-log] No destination for category '%s' (set a channel id or webhook).^7"):format(category))
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

-- Expose a category's raw webhook URL (used by spz-races overtake clips to
-- upload a screenshot straight to Discord via screenshot-basic).
exports('GetWebhook', function(category)
    return Config.Webhooks[category] or Config.Webhooks['default']
end)
