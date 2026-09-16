package constants

import rl "vendor:raylib"

// Window
WINDOW_WIDTH :: 900
WINDOW_HEIGHT :: 600

WINDOW_WIDTH_MIN :: 640
WINDOW_HEIGHT_MIN :: 420

WINDOW_TITLE :: "Vigil"

// Typography
FONT_SIZE_TITLE :: 25

// Layout
TOP_BAR_HEIGHT :: f32(42)
TOP_BAR_BUTTON_WIDTH :: f32(42)

// Colors
BG :: rl.Color{30, 33, 40, 255}

TOP_BAR :: rl.Color{38, 43, 51, 255}

TEXT_HEADER_MUTED :: rl.Color{145, 150, 160, 255}
TEXT_INFO :: rl.Color{255, 255, 255, 255}

BUTTON_HOVER :: rl.Color{55, 61, 72, 255}
CLOSE_BUTTON_HOVER :: rl.Color{180, 50, 50, 255}

// Assets
CLOSE_ICON :: "assets/close-32.png"
MINIMIZE_ICON :: "assets/minimize-32.png"
