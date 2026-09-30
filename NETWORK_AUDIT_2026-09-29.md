# Network audit — 2026-09-29

Read-only review of the `10.27.27.0/24` LAN and the UniFi Express 7 controller. No live settings were changed.

## Healthy findings

- 42 clients were online: 15 wired and 27 wireless.
- All five UniFi devices were online: UX7 `.1`, core switch `.2`, server switch `.4`, U7 Pro `.5`, and desktop switch `.157`.
- Both UniFi access points reported excellent experience. Their 2.4 GHz and 5 GHz channels do not overlap.
- UPnP is disabled and UniFi contains no port-forwarding policies.
- The default WAN firewall allows established traffic and blocks invalid and unsolicited inbound traffic.
- Rogue DHCP detection, RSTP, ping conflict detection, WPA2/WPA3, band steering, and BSS transition are enabled.

## Improvements in priority order

1. **Protect internal DNS.** DHCP advertises AdGuard `.110` and public resolver `1.1.1.1`. Some clients can bypass AdGuard and private names. Deploy a second internal resolver, then advertise only the two internal addresses.
2. **Clean up address management.** DHCP leases `.150-.254`; Calibre-Web uses `.151`. Confirm reservations for infrastructure inside the pool and give `.119`, `.121`, and `.151` useful UniFi names.
3. **Update and enable intrusion prevention.** The detection engine has an update available and intrusion prevention is currently off.
4. **Separate untrusted devices gradually.** Smart lights, plugs, appliances, cameras, speakers, and vacuums currently share full LAN access with Proxmox and storage. Build an IoT VLAN/SSID and move a few devices at a time.
5. **Add guest Wi-Fi.** Guests should have internet without server or management access.
6. **Review LAN management access.** SSH is open on the UX7 and several infrastructure devices; Glances is reachable on every Proxmox node. Limit these to trusted admin devices or a future management VLAN.
7. **Retire stale identities.** `.193` now belongs to a Tuya device, not Pi-hole. Remove the former Pi-hole address from recovery references.

## Notes

- Wi-Fi uses one SSID across 2.4, 5, and 6 GHz with WPA2/WPA3 and optional PMF. This is compatible and working; a separate WPA2 IoT SSID will make later segmentation easier.
- The WAN and UniFi devices were current in Site Manager. Only the intrusion-prevention detection engine showed a pending update.
- Use `HOMELAB_PUNCH_LIST.md` for estimated hands-on time and the recommended work order.
