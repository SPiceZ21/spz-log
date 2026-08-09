# spz-log

> Logging with Discord webhooks · `v1.0.1`

## Overview

`spz-log` is the shared logging sink. Other resources call its exports; it formats the
entry as a Discord embed — colour and thumbnail by category — and posts it to the matching
webhook.

## Structure

| Side | File | Purpose |
|---|---|---|
| Server | `config.lua` | Webhook URLs, colours, bot identity, thumbnails |
| Server | `server/main.lua` | Log ingestion and webhook dispatch |
| Client | `client/main.lua` | Client-side forwarding to the server |

## Configuration

| Key | Meaning |
|---|---|
| `Config.Webhooks` | Webhook URL per category (`default`, `race`, `nos`, `cheat`, `system`) |
| `Config.Colors` | Embed colour per level (`info`, `success`, `warning`, `error`, `nos`, `race`) |
| `Config.BotName` · `Config.BotIcon` | Webhook identity |
| `Config.Thumbnails` | Default thumbnail per category |

Webhook URLs ship as placeholders — fill them in before use.

## Exports

| Export | Description |
|---|---|
| `Log` | Post a log entry with an explicit category and level |
| `Info` · `Success` · `Warning` · `Error` | Level shorthands |
| `GetWebhook` | Resolve the webhook URL for a category |

```lua
exports['spz-log']:Info('race', 'Race started', { track = 'Vinewood Loop' })
```

## Commands

`/testlog` (development helper)

## Dependencies

None.

---

Part of [SPiceZ-Core](../README.md) · GPL-3.0
