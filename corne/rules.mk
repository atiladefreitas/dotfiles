# Ported Vial features + banger OLED (Luna module)
OLED_ENABLE  = yes
WPM_ENABLE   = yes
COMBO_ENABLE = yes

# Authentic Luna frames + custom info panel live in this module:
SRC += oled_luna.c

# Wired Corne with OLEDs, no per-key RGB
RGB_MATRIX_ENABLE = no
RGBLIGHT_ENABLE   = no
