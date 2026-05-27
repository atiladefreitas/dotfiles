# Proton VPN Waybar Toggle

A clickable Waybar indicator that shows current Proton VPN state and pops a
Walker-driven picker to switch servers or disconnect. Built around `wg-quick`
(WireGuard) and `systemd-resolved`.

When connected, the bar shows a lock icon plus the active server label (e.g.
` US`). When disconnected, it shows ` off`. Clicking opens the picker.

The icon lives in the Waybar module's `format` string (rendered at
`size="large"`); the script returns just the label so it stays at base text
size — matching the visual weight of the `cpu` / `memory` / `battery`
modules.

```
○ ar
● us            ← currently active (filled marker)
✕ Disconnect
```

---

## How it works

Three pieces:

| File | Role |
| --- | --- |
| `scripts/protonvpn-status.sh` | Polls every 5s. Reports the active `proton-*` interface (if any) as Waybar-formatted JSON. |
| `scripts/protonvpn-toggle.sh` | Click handler. Enumerates `/etc/wireguard/proton-*.conf`, pops a Walker menu, brings the chosen tunnel up. |
| `config.jsonc` → `custom/protonvpn` | Wires the two scripts into Waybar. Uses `signal: 8` so the bar refreshes instantly after a click instead of waiting for the next poll. |

Servers are discovered automatically: any file matching
`/etc/wireguard/proton-*.conf` appears in the picker. No script edits are
needed when adding a new region.

Styling lives in `style.css` under `#custom-protonvpn.connected` (mint) and
`#custom-protonvpn.disconnected` (grey).

---

## Prerequisites

The following packages must be installed and the listed services running:

- `wireguard-tools` — provides `wg-quick`
- `walker` — the dmenu-mode picker (`walker --dmenu`)
- `systemd-resolved` — DNS resolver this setup targets (`resolvectl`)
- A Nerd Font installed and used by Waybar (the bar uses `JetBrainsMono Nerd Font`) — the lock glyph `` will render as a missing-glyph box without it

---

## One-time system setup

These three system-level changes are done once. They live outside this repo
because they touch `/etc/`.

### 1. Loosen `/etc/wireguard` directory permissions

By default `/etc/wireguard` is `0700 root:root`, which means your user cannot
list filenames inside it — the picker would always show an empty list.

Fix: make the directory traversable but keep the `.conf` files themselves
locked to root. The filenames alone do not contain secrets; the keys inside
the files do.

```bash
sudo chmod 755 /etc/wireguard
sudo chmod 600 /etc/wireguard/*.conf
```

`wg-quick` refuses to start if a config is world-readable, so the second line
is both a safety belt and a requirement.

### 2. Passwordless sudo for `wg-quick`

The toggle script needs to run `wg-quick up` and `wg-quick down` as root, but
Waybar runs as your user and cannot prompt for a password on click. Allow
those two specific commands password-free — and **only** those — via a
sudoers drop-in.

```bash
sudo EDITOR=nvim visudo -f /etc/sudoers.d/protonvpn
```

Single line (substitute your real username — `whoami` if unsure):

```
atiladefreitas ALL=(root) NOPASSWD: /usr/bin/wg-quick up proton-*, /usr/bin/wg-quick down proton-*
```

Notes:

- Use `visudo` (not a plain editor) — it syntax-checks before saving so you
  cannot lock yourself out with a typo.
- The wildcard `proton-*` covers every region you'll ever add, but is scoped
  enough that this rule cannot be used to run anything other than those two
  exact `wg-quick` subcommands.
- If `/etc/sudoers` (or another drop-in) has `Defaults targetpw` or
  `Defaults rootpw`, those override `NOPASSWD`. Check with
  `sudo grep -rE 'targetpw|rootpw' /etc/sudoers /etc/sudoers.d/`.

Verify it works:

```bash
sudo -n /usr/bin/wg-quick down proton-us
sudo -n /usr/bin/wg-quick up proton-us
```

If neither prompts, the bar click will also work.

### 3. Set `SUDO_EDITOR` for `sudoedit`

`sudoedit` is the safe way to edit files in `/etc/wireguard/` — it copies the
file to a temp location, opens it as your user, then writes it back as root.
But it picks the editor via `SUDO_EDITOR` / `VISUAL` / `EDITOR`, all of which
sudo strips by default. Without one set, it falls back to `/usr/bin/vi`
(usually not installed) and errors out.

Add to your shell config (`~/.zshrc`):

```bash
export SUDO_EDITOR=nvim
export VISUAL=nvim
export EDITOR=nvim
```

Or set it inline for a single invocation:

```bash
SUDO_EDITOR=nvim sudoedit /etc/wireguard/proton-ar.conf
```

---

## Adding a server

Proton's downloaded configs ship a `DNS = ...` line that triggers `wg-quick`
to call `resolvconf`. On a `systemd-resolved` system, `resolvconf` is not
properly wired up and the connection fails with:

```
resolvconf: signature mismatch: /etc/resolv.conf
```

The fix is to replace the `DNS = ...` line with explicit `PostUp` / `PreDown`
hooks that call `resolvectl` directly. Every Proton config needs this
treatment, including ones downloaded after this doc was written.

### Recipe

Assume you've just downloaded `~/Downloads/wg-AR-27.conf` and want to install
it as `proton-ar`.

```bash
# 1. Install into /etc/wireguard with locked-down perms
sudo install -m 600 ~/Downloads/wg-AR-27.conf /etc/wireguard/proton-ar.conf

# 2. Open it for editing
SUDO_EDITOR=nvim sudoedit /etc/wireguard/proton-ar.conf
```

Inside the editor, find the `DNS = ...` line in the `[Interface]` block:

```ini
DNS = 10.2.0.1, 2a07:b944::2:1
```

**Delete it entirely** (do not just comment it out — `wg-quick` ignores `#`
prefixes on its own directives but still parses any uncommented `DNS =`),
and replace it with these two lines (substituting the IPv4 from the original
DNS line if it's not `10.2.0.1`):

```ini
PostUp = resolvectl dns %i 10.2.0.1; resolvectl domain %i ~.
PreDown = resolvectl revert %i
```

`%i` is a `wg-quick` placeholder that expands to the interface name
(`proton-ar` in this case).

The finished `[Interface]` block should look like:

```ini
[Interface]
PrivateKey = <redacted>
Address = 10.2.0.2/32, 2a07:b944::2:2/128
PostUp = resolvectl dns %i 10.2.0.1; resolvectl domain %i ~.
PreDown = resolvectl revert %i
```

Save, then verify:

```bash
sudo grep -c '^DNS' /etc/wireguard/proton-ar.conf   # must print 0
sudo wg-quick up proton-ar                          # must end with a resolvectl line, exit 0
sudo wg-quick down proton-ar
```

The new server now appears in the Waybar picker on next click — no Waybar
reload required.

### Naming convention

Files must be named `proton-<label>.conf`. The `<label>` part is what shows
up in the picker (uppercased) and what `wg-quick` uses as the interface
name. Keep it short and lowercase, e.g. `proton-us`, `proton-ar`,
`proton-de`. The sudoers wildcard already covers anything matching that
pattern.

---

## Daily use

- **Connect / switch server**: click the lock icon, pick a server from the
  Walker menu.
- **Disconnect**: click the lock icon, pick `✕ Disconnect`.
- **Check current state**: the bar text says it all — `  US` means
  connected to `proton-us`, `  off` means no tunnel.

Indicator updates within ~1 second after a state change because the toggle
script sends `pkill -RTMIN+8 waybar` and the module has `signal: 8`. If you
ever bring a tunnel up or down from the terminal (`sudo wg-quick up
proton-xx`), the bar will catch up on its next 5-second poll, or
immediately if you signal it manually:

```bash
pkill -RTMIN+8 waybar
```

---

## Troubleshooting

### The picker shows an empty list

`/etc/wireguard` is still `0700`. See [section 1 of one-time setup](#1-loosen-etcwireguard-directory-permissions).
Verify with `ls /etc/wireguard/` (as your normal user, not root) — it should
list the `.conf` files. If it says `Permission denied`, the chmod hasn't
been applied.

### Clicking prompts for a sudo password

The sudoers drop-in either doesn't exist, has the wrong username, or has
the wrong command path. Run `sudo cat /etc/sudoers.d/protonvpn` to check.
The username must match `whoami` exactly, and the path must be
`/usr/bin/wg-quick` (verify with `which wg-quick`).

### `wg-quick up` fails with `resolvconf: signature mismatch`

The config still has a `DNS = ...` line. See [Adding a server](#adding-a-server).
This is the single most common failure mode and applies to every freshly
downloaded Proton config.

### Bar shows wrong state (says off when actually connected, or vice versa)

Force a refresh:

```bash
pkill -RTMIN+8 waybar
```

If it's still wrong, run the status script directly to see what it's
reporting and why:

```bash
~/dotfiles/waybar/scripts/protonvpn-status.sh
ip -o link show | grep proton-
```

The script keys off `ip link show` output — anything matching
`proton-[a-zA-Z0-9-]+` counts as connected.

### Click does nothing

Likely the toggle script is silently failing. Run it from a terminal to see
the actual error:

```bash
~/dotfiles/waybar/scripts/protonvpn-toggle.sh
```

Walker should appear and any `wg-quick` errors will print to the terminal
after you pick a server.

---

## Diagnostic one-liners

Quick sanity checks for all configs at once:

```bash
# Every Proton config should report 0 — meaning no DNS= line left in any of them
sudo grep -c '^DNS' /etc/wireguard/proton-*.conf

# All configs should be -rw------- root root
sudo ls -l /etc/wireguard/proton-*.conf

# What the picker will see (run as your user, not root)
find /etc/wireguard -maxdepth 1 -name 'proton-*.conf' -printf '%f\n'

# What's currently up
ip -o link show | grep -oE 'proton-[a-zA-Z0-9-]+'
```

---

## Possible extensions

- **Hyprland keybind to open the picker** without clicking the bar — bind a
  key to `~/dotfiles/waybar/scripts/protonvpn-toggle.sh` in `hyprland.lua`.
- **Notify on failure** — the toggle script currently ignores `wg-quick`'s
  exit code. Wrapping the call and sending a `notify-send` on non-zero would
  surface failures (e.g. a forgotten `DNS =` line) immediately rather than
  leaving the user staring at a still-disconnected indicator.
- **`proton-add` helper** — wraps the "install + sed the DNS line" steps so
  adding a new server is one command instead of three. Worth doing once
  there are 3+ regions in regular rotation.
