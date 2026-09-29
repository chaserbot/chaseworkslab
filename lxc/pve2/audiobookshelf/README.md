# Audiobookshelf — pve2 CT211

Audiobookshelf runs as a native community-script installation in pve2 CT211.

| Setting | Value |
| ------- | ----- |
| Container | pve2 CT211 |
| Address | `10.27.27.121/24` |
| Gateway | `10.27.27.1` |
| Port | `13378` |
| Friendly URL | `http://audiobooks.chaseworkslab.com/audiobookshelf/login` |
| Library mount | `/mnt/audiobooks` from BigPeggy |

## Service checks

Run these from the pve2 shell:

```bash
pct status 211
pct exec 211 -- systemctl status audiobookshelf --no-pager
pct exec 211 -- ss -lntp
pct exec 211 -- findmnt /mnt/audiobooks
```

Audiobookshelf runs as the `audiobookshelf` system user. The packaged Node application requires a writable cache at `/home/audiobookshelf/.cache`. If an update produces an `EACCES` error for that path, restore it without changing application or library data:

```bash
pct exec 211 -- install -d -o audiobookshelf -g audiobookshelf -m 0755 /home/audiobookshelf /home/audiobookshelf/.cache /home/audiobookshelf/.cache/pkg
pct exec 211 -- systemctl restart audiobookshelf
```

## Rollback

Stop the service before removing only the regenerated cache directory. Never remove `/usr/share/audiobookshelf`, `/mnt/audiobooks`, or the BigPeggy data as part of a cache repair.
