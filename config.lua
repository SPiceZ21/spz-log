Config = {}

-- ── Delivery ─────────────────────────────────────────────────────────────────
-- Post logs through the Discord BOT (token: `set spz_discord_token "..."`, same
-- one spz-discord uses) into channel IDs below. Set false to force legacy
-- webhook mode. When a category has no channel id, it falls back to a webhook.
Config.UseBot = true

-- category -> Discord channel ID (bot needs Send Messages + Embed Links there).
-- Point several categories at the same id to merge them into one channel, or
-- leave "" to fall back to that category's webhook (below).
Config.Channels = {
    ['default']  = '',
    ['race']     = '',
    ['nos']      = '',
    ['cheat']    = '',
    ['system']   = '',
    ['betting']  = '',
    ['minigame'] = '',
    ['duel']     = '',
}

-- Legacy webhooks. Still used (a) as a fallback when a category has no channel
-- id, and (b) by GetWebhook() for image uploads (screenshot-basic can only POST
-- to a webhook URL, not a bot channel endpoint). Leave "" to disable.
Config.Webhooks = {
    ['default'] = '',
    ['race']    = '',
    ['nos']     = '',
    ['cheat']   = '',
    ['system']  = '',
}

-- Colors keyed by log TYPE (info/success/warning/error) + a couple of accents.
Config.Colors = {
    ['info']    = 16719360, -- SPiceZ orange
    ['success'] = 3066993,  -- Green
    ['warning'] = 15105570, -- Amber
    ['error']   = 15158332, -- Red
    ['nos']     = 10181046, -- Purple
    ['race']    = 1752220,  -- Aqua
}

-- Branding (bot channel posts ignore username/avatar, so the footer carries it).
Config.BotName = "SPiceZ Logs"
Config.BotIcon = "https://raw.githubusercontent.com/SPiceZ21/spz-txrecipe/main/Logo.png"

-- Optional per-category thumbnail image URLs (leave empty for none).
Config.Thumbnails = {}
