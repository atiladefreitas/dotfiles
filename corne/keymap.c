/* Copyright 2024 atiladefreitas
 * Corne (crkbd/rev1) + Pro Micro RP2040
 * Faithfully ported from Vial (keeb.vil).
 * Thumbs (physical): L = Tab Gui Alt | R = LOWER Space RAISE
 *   inner-right LOWER = MO(1), outer-right RAISE = MO(2)
 *   holding both -> tri-layer -> layer 3 (ADJUST)
 * OLED lives in oled_luna.c (pulled in via rules.mk SRC +=).
 */
#include QMK_KEYBOARD_H

enum layers {
    _BASE = 0,
    _LOWER,
    _RAISE,
    _ADJUST,
};

#define LOWER MO(_LOWER)
#define RAISE MO(_RAISE)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    /* _BASE
     * ,----------------------------------.   ,----------------------------------.
     * | Esc|  Q |  W |  E |  R |  T |        |  Y |  U |  I |  O |  P |Bspc|
     * |Ctrl|  A |  S |  D |  F |  G |        |  H |  J |  K |  L |  ' | Ent|
     * |Shft| Del|  Z |  X |  C |  V |        |  B |  N |  M |  , |  . |  / |
     * `--------------+ Tab| Gui| Alt|        |LOWR| Spc|RAIS+--------------'
     */
    [_BASE] = LAYOUT_split_3x6_3(
        KC_ESC,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC,
        KC_LCTL, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L,    KC_QUOT, KC_ENT,
        KC_LSFT, KC_DEL,  KC_Z,    KC_X,    KC_C,    KC_V,                         KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,
                                   KC_TAB,  KC_LGUI, KC_LALT,    LOWER,   KC_SPC,  RAISE
    ),

    /* _LOWER  (hold inner-right thumb)
     * ,----------------------------------.   ,----------------------------------.
     * | Esc|  1 |  2 |  3 |  [ |  ] |        |  - |  = |    |    |Vol+| Ent|
     * |    |  4 |  5 |  6 |  ; |  ' |        |Left|Down| Up |Rght|Vol-|    |
     * |Shft|  7 |  8 |  9 |  0 |    |        |  - |    |    |    |    |  \ |
     */
    [_LOWER] = LAYOUT_split_3x6_3(
        KC_ESC,  KC_1,    KC_2,    KC_3,    KC_LBRC, KC_RBRC,                      KC_MINS, KC_EQL,  _______, _______, KC_VOLU, KC_ENT,
        XXXXXXX, KC_4,    KC_5,    KC_6,    KC_SCLN, KC_QUOT,                      KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_VOLD, _______,
        KC_LSFT, KC_7,    KC_8,    KC_9,    KC_0,    _______,                      KC_MINS, _______, _______, _______, _______, KC_BSLS,
                                   _______, _______, _______,    _______, _______, _______
    ),

    /* _RAISE  (hold outer-right thumb)
     * ,----------------------------------.   ,----------------------------------.
     * |    |    |    |    |    |    |        |    |    |    |  ( |  ) |    |
     * |    |    |    |  | |    |    |        |  ` |  ^ |    |  [ |  ] |    |
     * |Shft|    |    |    |    |    |        |    |    |    |  { |  } |  \ |
     */
    [_RAISE] = LAYOUT_split_3x6_3(
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,    XXXXXXX, _______,                   XXXXXXX, XXXXXXX, XXXXXXX, S(KC_9),    S(KC_0),    XXXXXXX,
        _______, _______, XXXXXXX, S(KC_BSLS), XXXXXXX, _______,                   KC_GRV,  S(KC_6), XXXXXXX, KC_LBRC,    KC_RBRC,    XXXXXXX,
        KC_LSFT, XXXXXXX, XXXXXXX, XXXXXXX,    XXXXXXX, XXXXXXX,                    XXXXXXX, XXXXXXX, XXXXXXX, S(KC_LBRC), S(KC_RBRC), KC_BSLS,
                                   XXXXXXX, XXXXXXX, XXXXXXX,    _______, XXXXXXX, _______
    ),

    /* _ADJUST  (both thumbs)  -- empty in Vial; QK_BOOT added for easy flashing */
    [_ADJUST] = LAYOUT_split_3x6_3(
        QK_BOOT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, QK_BOOT,
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
                                   XXXXXXX, XXXXXXX, XXXXXXX,    XXXXXXX, XXXXXXX, XXXXXXX
    ),
};

/* Tri-layer: LOWER + RAISE held together -> _ADJUST */
layer_state_t layer_state_set_user(layer_state_t state) {
    return update_tri_layer_state(state, _LOWER, _RAISE, _ADJUST);
}

/* Combos (from Vial): Ctrl+Alt -> Enter, Shift+Alt -> Space */
const uint16_t PROGMEM combo_ctrlalt[] = {KC_LCTL, KC_LALT, COMBO_END};
const uint16_t PROGMEM combo_shiftalt[] = {KC_LSFT, KC_LALT, COMBO_END};
combo_t key_combos[] = {
    COMBO(combo_ctrlalt, KC_ENT),
    COMBO(combo_shiftalt, KC_SPC),
};

