package layout

import rl "vendor:raylib"

// A horizontal line through the middle of the rect.
draw_rule :: proc(rect: rl.Rectangle, color: rl.Color) {
	y := i32(rect.y + rect.height / 2)

	rl.DrawLine(i32(rect.x), y, i32(rect.x + rect.width), y, color)
}

// A vertical line through the middle of the rect.
draw_rule_v :: proc(rect: rl.Rectangle, color: rl.Color) {
	x := i32(rect.x + rect.width / 2)

	rl.DrawLine(x, i32(rect.y), x, i32(rect.y + rect.height), color)
}

draw_bottom_border :: proc(rect: ^rl.Rectangle, tick: f32, color: rl.Color) {
	bottom_border := rl.Rectangle {
		x      = rect.x,
		y      = rect.y + rect.height - tick,
		width  = rect.width,
		height = tick,
	}
	rl.DrawRectangleRec(bottom_border, color)
}
