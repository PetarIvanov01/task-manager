package components

import sys "../../system"
import c "../constants/"
import "../layout"

import "core:fmt"
import rl "vendor:raylib"

draw_processes_tab_container :: proc(
	info: sys.System_Info,
	stats: sys.Stats,
	container_start_x: i32 = 0,
	container_start_y: i32 = 0,
) {
	main_rect := rl.Rectangle {
		x      = f32(container_start_x),
		y      = f32(container_start_y),
		width  = f32(rl.GetScreenWidth() - container_start_x),
		height = f32(rl.GetScreenHeight() - container_start_y),
	}

	content := layout.inset(main_rect, c.CONTENT_PADDING)
	left, right := layout.split_v(content, c.COLUMN_GAP)

}
