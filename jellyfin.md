# Jellyfin — Context File
*For use with Claude Code. Last updated: 2026-03-26*

---

## What It Is in This Setup
Jellyfin is the media server — it serves the media that the arr stack downloads. Running on a dedicated Ace Magician CK10 mini PC (separate from Mac Mini #1) to keep media serving isolated from the arr management stack.

## Current State
- Running on Ace Magician CK10
- Active — serving media
- Not yet in Docker Compose / not yet in GitHub

## Host
- **Machine**: Ace Magician CK10 (i7-1081U, 16GB RAM)
- **IP**: Not yet assigned a static IP in the network table — needs to be documented and reserved
- **OS**: Not documented yet — likely Ubuntu or similar

## Key Config Details
- Media library points to media on the Pegasus DAS (accessed over the network from Mac Mini #1, or direct mount TBD)
- Hardware transcoding: i7-1081U has Intel Quick Sync — should be configured/verified in Jellyfin
- No GPU, but iGPU transcoding available

## Related GitHub Repo
`github.com/chaserbot/chaseworkslab-docker`

Jellyfin's `docker-compose.yml` will live here under:
```
jellyfin/
  docker-compose.yml
  .env.example
  README.md
```

## What Needs to Happen
- [ ] Assign static IP to Ace Magician CK10, add to network map
- [ ] Containerize Jellyfin with Docker Compose (if not already)
- [ ] Confirm media path — how does CK10 access Pegasus DAS media? (NFS from Mac Mini #1, or direct?)
- [ ] Verify Intel Quick Sync hardware transcoding is enabled in Jellyfin config
- [ ] Commit `docker-compose.yml` to `chaseworkslab-docker`

## Migration Consideration
If Proxmox cluster takes over compute (Track T3), Jellyfin could move to an LXC on Proxmox with iGPU passthrough from one of the Mac Minis. Mac Minis (A1347) have Intel iGPU — passthrough feasibility on Proxmox is TBD.

## Next Steps
1. Document IP and OS for Ace Magician CK10
2. Dockerize Jellyfin if not already
3. Add to `chaseworkslab-docker` repo
4. Verify hardware transcoding config
