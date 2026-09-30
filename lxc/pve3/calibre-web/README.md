# Calibre-Web — pve3 CT101

Calibre-Web runs as a native community-script installation in pve3 CT101.

| Setting | Live value |
| ------- | ---------- |
| Container | pve3 CT101 |
| Hostname | `calibre-web` |
| Address | `10.27.27.151/24` |
| Gateway | `10.27.27.1` |
| Application port | `8083` |
| Friendly login | `http://ebooks.chaseworkslab.com/login` |
| Start at boot | Yes |

## Verify

1. Confirm CT101 is running on pve3.
2. Open `http://10.27.27.151:8083` directly.
3. Open `http://ebooks.chaseworkslab.com/login` through NPM.
4. Confirm the library opens; a successful login page alone does not prove the book storage is available.

## Recovery note

Before rebuilding, identify and back up the application database, configuration, and book-library path from the live container. Those paths were not modified or fully audited during the 2026-09-29 identity scan.
