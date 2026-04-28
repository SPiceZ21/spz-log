# spz-log
> Advanced logging with Discord webhook · `v1.0.1`

## Scripts

| Side   | File              | Purpose                                             |
| ------ | ----------------- | --------------------------------------------------- |
| Server | `config.lua`      | Webhook URLs, log levels, category configuration    |
| Server | `server/main.lua` | Log ingestion, Discord webhook dispatch             |
| Client | `client/main.lua` | Client-side log forwarding to server                |

## CI
Built and released via `.github/workflows/release.yml` on push to `main`.
