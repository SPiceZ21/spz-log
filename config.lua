Config = {}

-- Discord Webhook URLs
-- Replace these with your actual webhook URLs
Config.Webhooks = {
    ['default'] = 'YOUR_WEBHOOK_URL_HERE',
    ['race']    = 'YOUR_WEBHOOK_URL_HERE',
    ['nos']     = 'YOUR_WEBHOOK_URL_HERE',
    ['cheat']   = 'YOUR_WEBHOOK_URL_HERE',
    ['system']  = 'YOUR_WEBHOOK_URL_HERE',
}

-- Colors for different log types (Decimal values)
Config.Colors = {
    ['info']    = 3447003,  -- Blue
    ['success'] = 3066993,  -- Green
    ['warning'] = 15105570, -- Orange
    ['error']   = 15158332, -- Red
    ['nos']     = 10181046, -- Purple
    ['race']    = 1752220,  -- Aqua
}

-- Bot Name and Icon
Config.BotName = "SPiceZ Logs"
Config.BotIcon = "https://i.imgur.com/your_icon_here.png"

-- Default Thumbnails for categories
Config.Thumbnails = {
    ['race']   = "https://i.imgur.com/race_thumb.png",
    ['nos']    = "https://i.imgur.com/nos_thumb.png",
    ['cheat']  = "https://i.imgur.com/cheat_thumb.png",
    ['system'] = "https://i.imgur.com/system_thumb.png",
}
