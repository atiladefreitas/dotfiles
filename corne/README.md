# Corne (crkbd/rev1) — QMK keymap

Wired Corne v0.2 rev1 with **Pro Micro RP2040** controllers and dual OLEDs.

## Files
- `keymap.c`   — layout (base/lower/raise/adjust), tri-layer, combos
- `oled_luna.c`— vertical OLED: Luna pet + layer/WPM/mods panel
- `config.h`   — tapping term, combo term, OLED + split settings
- `rules.mk`   — feature flags (OLED, WPM, COMBO) + `SRC += oled_luna.c`

## Build & flash
Copy these files into `qmk_firmware/keyboards/crkbd/keymaps/atiladefreitas/`, then:

```sh
qmk compile -kb crkbd/rev1 -km atiladefreitas
```

The promicro_rp2040 converter is baked into the keymap's `keymap.json`.

Flash each half: double-tap reset to expose the RPI-RP2 drive, then:

```sh
udisksctl mount -b /dev/sda1
cp ~/qmk_firmware/crkbd_rev1_atiladefreitas.uf2 /run/media/$USER/RPI-RP2/
```

## Layout notes
- Thumbs (physical R): inner = LOWER (MO 1), outer = RAISE (MO 2)
- Hold both thumbs → ADJUST layer (tri-layer), holds QK_BOOT for reflashing
- Combos: Ctrl+Alt → Enter, Shift+Alt → Space
