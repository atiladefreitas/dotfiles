# Ported Vial features + Arch/Neovim info OLED
OLED_ENABLE  = yes
WPM_ENABLE   = yes
COMBO_ENABLE = yes

# OLED rendering + last-key tracking live in this module:
SRC += oled_arch_nvim.c

# Wired Corne with OLEDs, no per-key RGB
RGB_MATRIX_ENABLE = no
RGBLIGHT_ENABLE   = no
