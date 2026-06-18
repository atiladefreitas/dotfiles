/* OLED for atiladefreitas Corne (crkbd/rev1, RP2040)
 * LEFT  (master): Arch logo + "Atila de Freitas" + last key pressed
 * RIGHT (slave) : Neovim logo + active layer + modifier state
 * Vertical orientation (OLED_ROTATION_270): ~5 chars wide, 16 lines tall.
 */
#include QMK_KEYBOARD_H
#include <stdio.h>

// arch_logo: 32x32, 128 bytes
static const char PROGMEM arch_logo[] = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xc0, 0xf0, 0xfc, 0xf0, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xe0, 0xf8, 0xff, 0x3f, 0x07,
    0x01, 0x07, 0x3f, 0xff, 0xf8, 0xe0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0,
    0xf0, 0xfc, 0xff, 0x7f, 0x0f, 0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x01,
    0x0f, 0x7f, 0xff, 0xfc, 0xf0, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x60, 0x38, 0x3e, 0x1f, 0x1f, 0x0f, 0x03, 0x00,
    0x04, 0x02, 0x02, 0x01, 0x01, 0x01, 0x02, 0x02, 0x04, 0x00, 0x03, 0x0f,
    0x1f, 0x1f, 0x3e, 0x38, 0x60, 0x00, 0x00, 0x00,
};

// nvim_logo: 32x32, 128 bytes
static const char PROGMEM nvim_logo[] = {
    0x00, 0x00, 0x00, 0x00, 0xf0, 0xf0, 0xf0, 0xf0, 0xf0, 0xf0, 0xf0, 0xf0,
    0xe0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0xf0, 0xf0,
    0xf0, 0xf0, 0xf0, 0xf0, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe,
    0xf8, 0xf0, 0xc0, 0x80, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3f, 0x7f, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0x01, 0x03, 0x07, 0x1f, 0x3f, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x0f, 0x1f, 0x1f, 0x1f,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x0f, 0x1f, 0x1f, 0x1f,
    0x1f, 0x1f, 0x1f, 0x1f, 0x1f, 0x00, 0x00, 0x00,
};

/* ---- Track last key pressed (set in process_record_user) ---- */
static char last_key_str[6] = "---  ";

static void set_last_key(uint16_t keycode) {
    // Map common keycodes to short labels. Letters/digits handled generically.
    if (keycode >= KC_A && keycode <= KC_Z) {
        last_key_str[0] = 'A' + (keycode - KC_A);
        last_key_str[1] = ' '; last_key_str[2] = ' ';
        last_key_str[3] = ' '; last_key_str[4] = ' '; last_key_str[5] = 0;
        return;
    }
    if (keycode >= KC_1 && keycode <= KC_0) {
        // KC_1..KC_9 then KC_0
        char c = (keycode == KC_0) ? '0' : ('1' + (keycode - KC_1));
        last_key_str[0] = c;
        last_key_str[1] = ' '; last_key_str[2] = ' ';
        last_key_str[3] = ' '; last_key_str[4] = ' '; last_key_str[5] = 0;
        return;
    }
    const char *s;
    switch (keycode) {
        case KC_ESC:  s = "ESC  "; break;
        case KC_TAB:  s = "TAB  "; break;
        case KC_SPC:  s = "SPC  "; break;
        case KC_ENT:  s = "ENT  "; break;
        case KC_BSPC: s = "BSPC "; break;
        case KC_DEL:  s = "DEL  "; break;
        case KC_LSFT: s = "LSFT "; break;
        case KC_LCTL: s = "LCTL "; break;
        case KC_LALT: s = "LALT "; break;
        case KC_LGUI: s = "LGUI "; break;
        case KC_QUOT: s = "QUOT "; break;
        case KC_COMM: s = ",    "; break;
        case KC_DOT:  s = ".    "; break;
        case KC_SLSH: s = "/    "; break;
        case KC_BSLS: s = "BSLS "; break;
        case KC_MINS: s = "-    "; break;
        case KC_EQL:  s = "=    "; break;
        case KC_LBRC: s = "[    "; break;
        case KC_RBRC: s = "]    "; break;
        case KC_GRV:  s = "`    "; break;
        case KC_SCLN: s = ";    "; break;
        case KC_LEFT: s = "LEFT "; break;
        case KC_RGHT: s = "RGHT "; break;
        case KC_UP:   s = "UP   "; break;
        case KC_DOWN: s = "DOWN "; break;
        case KC_VOLU: s = "VOL+ "; break;
        case KC_VOLD: s = "VOL- "; break;
        default:      s = "KEY  "; break;
    }
    strncpy(last_key_str, s, 5);
    last_key_str[5] = 0;
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (record->event.pressed) {
        // unwrap mod-tap / layer-tap to the base keycode for display
        uint16_t kc = keycode;
        if (kc > 0xFF) {
            // for MO()/MT() etc just label generically
            set_last_key(0xFFFF);
        } else {
            set_last_key(kc);
        }
    }
    return true; // don't swallow the key
}

/* ---------------- rendering ---------------- */
oled_rotation_t oled_init_user(oled_rotation_t rotation) {
    return OLED_ROTATION_270;
}

static void render_master(void) {
    // Arch logo at top (32x32 -> 4 lines tall in the font grid)
    oled_set_cursor(0, 0);
    oled_write_raw_P(arch_logo, sizeof(arch_logo));

    // Identity, wrapped to the ~5-char-wide strip
    oled_set_cursor(0, 5);
    oled_write_P(PSTR("Atila"), false);
    oled_set_cursor(0, 6);
    oled_write_P(PSTR("de   "), false);
    oled_set_cursor(0, 7);
    oled_write_P(PSTR("Freit"), false);

    // Last key pressed, near the bottom
    oled_set_cursor(0, 13);
    oled_write_P(PSTR("KEY  "), false);
    oled_set_cursor(0, 14);
    oled_write_P(PSTR("-----"), false);
    oled_set_cursor(0, 15);
    oled_write(last_key_str, false);
}

static void render_slave(void) {
    // Neovim logo at top
    oled_set_cursor(0, 0);
    oled_write_raw_P(nvim_logo, sizeof(nvim_logo));

    // Active layer
    oled_set_cursor(0, 5);
    oled_write_P(PSTR("LYR  "), false);
    oled_set_cursor(0, 6);
    switch (get_highest_layer(layer_state)) {
        case 0:  oled_write_P(PSTR("base "), false); break;
        case 1:  oled_write_P(PSTR("lower"), false); break;
        case 2:  oled_write_P(PSTR("raise"), false); break;
        case 3:  oled_write_P(PSTR("adj  "), false); break;
        default: oled_write_P(PSTR("?    "), false);
    }

    // Modifier state
    uint8_t mods = get_mods() | get_oneshot_mods();
    oled_set_cursor(0, 9);
    oled_write_P(PSTR("MOD  "), false);
    oled_set_cursor(0, 10);
    oled_write_P((mods & MOD_MASK_CTRL)  ? PSTR("CTRL ") : PSTR(".    "), false);
    oled_set_cursor(0, 11);
    oled_write_P((mods & MOD_MASK_SHIFT) ? PSTR("SHFT ") : PSTR(".    "), false);
    oled_set_cursor(0, 12);
    oled_write_P((mods & MOD_MASK_ALT)   ? PSTR("ALT  ") : PSTR(".    "), false);
    oled_set_cursor(0, 13);
    oled_write_P((mods & MOD_MASK_GUI)   ? PSTR("GUI  ") : PSTR(".    "), false);

    // Caps lock
    oled_set_cursor(0, 15);
    oled_write_P(host_keyboard_led_state().caps_lock ? PSTR("CAPS ") : PSTR("     "), false);
}

bool oled_task_user(void) {
    if (is_keyboard_master()) {
        render_master();
    } else {
        render_slave();
    }
    return false;
}
