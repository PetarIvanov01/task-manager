package layout

import rl "vendor:raylib"

Align :: enum {
	Left,
	Center,
	Right,
}

align_in :: proc(rect: rl.Rectangle, size: rl.Vector2, align: Align = .Left) -> rl.Vector2 {
	x := rect.x

	switch align {
	case .Left:
		x = rect.x
	case .Center:
		x = rect.x + (rect.width - size.x) / 2
	case .Right:
		x = rect.x + rect.width - size.x
	}

	return rl.Vector2{x, rect.y + (rect.height - size.y) / 2}
}

get_center_x :: proc(item_width, container_width: i32) -> i32 {
	return (container_width - item_width) / 2
}

get_center_y :: proc(item_height, container_height: i32) -> i32 {
	return (container_height - item_height) / 2
}
