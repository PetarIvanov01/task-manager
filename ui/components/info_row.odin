package components

import sys "../../system/"
import c "../constants"
import rl "vendor:raylib"

draw_info_row :: proc(font: rl.Font, label: cstring, value: cstring, y: i32) {
	label_pos := rl.Vector2{24, f32(y)}
	rl.DrawTextEx(font, label, label_pos, c.FONT_SIZE_LABEL, 0, c.TEXT_HEADER_MUTED)

	value_pos := rl.Vector2{200, f32(y)}
	rl.DrawTextEx(font, value, value_pos, c.FONT_SIZE_LABEL, 0, c.TEXT_INFO)
}
