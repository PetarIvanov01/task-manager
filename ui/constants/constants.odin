package constants

import "../layout"
import rl "vendor:raylib"
// Window
WINDOW_WIDTH :: 900
WINDOW_HEIGHT :: 600

WINDOW_WIDTH_MIN :: 640
WINDOW_HEIGHT_MIN :: 420

WINDOW_TITLE :: "Vigil"

// Layout
TOP_BAR_HEIGHT :: f32(42)
TOP_BAR_BUTTON_WIDTH :: f32(42)
TABS_BAR_HEIGHT :: f32(TOP_BAR_HEIGHT * 1.2)
SEARCH_HEIGHT :: f32(TABS_BAR_HEIGHT * 1.3)

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
TABS_BAR_BG :: rl.Color{34, 38, 45, 255}
TABS_BAR_BG_BORDER :: rl.Color{56, 62, 73, 255}
TAB_SELECTED_BG :: rl.Color{38, 53, 79, 255}
TAB_HOVERED_BG :: rl.Color{38, 53, 79, 188}
SEARCH_BG :: rl.Color{30, 33, 40, 255}

ICON_MUTED :: rl.Color{145, 150, 160, 255} // tint for the top bar glyphs

RULE :: rl.Color{58, 65, 77, 255}
ACCENT :: rl.Color{79, 140, 255, 255}
METER_BG :: rl.Color{26, 29, 35, 255}

BUTTON_HOVER :: rl.Color{55, 61, 72, 255}
CLOSE_BUTTON_HOVER :: rl.Color{180, 50, 50, 255}

PROCESS_HEADER_BG :: rl.Color{38, 43, 51, 255}
PROCESS_ROW_EVEN :: rl.Color{34, 38, 45, 255}
PROCESS_ROW_ODD :: rl.Color{30, 33, 40, 255}
// Assets
CLOSE_ICON :: "assets/close-32.png"
MINIMIZE_ICON :: "assets/minimize-32.png"

UPDATE_INTERVAL :: f32(1.0)

GB :: 1024 * 1024 * 1024

Tabs :: enum {
	System,
	Process,
}

TAB_LABELS := [Tabs]string {
	.System  = "System",
	.Process = "Process",
}

// Process Tab
PROCESS_ROW_HEIGHT :: f32(36)

// Table of processes
Column :: enum {
	Name,
	PID,
	CPU,
	Memory,
	Threads,
}

Column_Config :: struct {
	label:     cstring,
	ratio:     f32,
	alignment: layout.Align,
}

COLUMNS := [Column]Column_Config {
	.Name = {label = "NAME", ratio = 0.44, alignment = .Left},
	.PID = {label = "PID", ratio = 0.14, alignment = .Right},
	.CPU = {label = "CPU", ratio = 0.12, alignment = .Right},
	.Memory = {label = "MEMORY", ratio = 0.16, alignment = .Center},
	.Threads = {label = "THREADS", ratio = 0.14, alignment = .Right},
}
