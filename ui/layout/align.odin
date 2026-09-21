package layout

import rl "vendor:raylib"

Align :: enum {
	Left,
	Center,
	Right,
}

// y axes is alwayas centered
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
