package constants

import rl "vendor:raylib"

// Window
WINDOW_WIDTH :: 900
WINDOW_HEIGHT :: 600

WINDOW_WIDTH_MIN :: 640
WINDOW_HEIGHT_MIN :: 420

WINDOW_TITLE :: "Vigil"

// Typography
FONT_PATH :: "assets/fonts/inter-regular.ttf"
FONT_SIZE_TITLE :: 24
FONT_SIZE_SECTION :: 15
FONT_SIZE_LABEL :: 16
FONT_SIZE_INFO :: 16

// Layout
TOP_BAR_HEIGHT :: f32(42)
TOP_BAR_BUTTON_WIDTH :: f32(42)

CONTENT_PADDING :: f32(24)
COLUMN_GAP :: f32(28)

SECTION_HEADER_HEIGHT :: f32(22)
SECTION_RULE_HEIGHT :: f32(14) // band under a header, holds the rule
SECTION_GAP :: f32(26) // space between two sections of a column

ROW_HEIGHT :: f32(26)
LABEL_COLUMN :: f32(150) // where the value half of a row starts

METER_ROW_HEIGHT :: f32(34)
METER_HEIGHT :: f32(22)

// Colors
BG :: rl.Color{30, 33, 40, 255}

TOP_BAR :: rl.Color{38, 43, 51, 255}

TEXT_HEADER_MUTED :: rl.Color{145, 150, 160, 255}
TEXT_INFO :: rl.Color{230, 233, 239, 255}

RULE :: rl.Color{58, 65, 77, 255}
ACCENT :: rl.Color{79, 140, 255, 255}
METER_BG :: rl.Color{26, 29, 35, 255}

BUTTON_HOVER :: rl.Color{55, 61, 72, 255}
CLOSE_BUTTON_HOVER :: rl.Color{180, 50, 50, 255}

// Assets
CLOSE_ICON :: "assets/close-32.png"
MINIMIZE_ICON :: "assets/minimize-32.png"

UPDATE_INTERVAL :: f32(1.0)

GB :: 1024 * 1024 * 1024
