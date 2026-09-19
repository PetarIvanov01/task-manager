package layout

import rl "vendor:raylib"

inset :: proc(rect: rl.Rectangle, padding: f32) -> rl.Rectangle {
	return inset_xy(rect, padding, padding)
}

inset_xy :: proc(rect: rl.Rectangle, pad_x, pad_y: f32) -> rl.Rectangle {
	return rl.Rectangle {
		x = rect.x + pad_x,
		y = rect.y + pad_y,
		width = rect.width - pad_x * 2,
		height = rect.height - pad_y * 2,
	}
}

cut_top :: proc(rect: ^rl.Rectangle, amount: f32) -> rl.Rectangle {
	amount := min(amount, rect.height)

	slice := rl.Rectangle{rect.x, rect.y, rect.width, amount}

	rect.y += amount
	rect.height -= amount

	return slice
}

cut_bottom :: proc(rect: ^rl.Rectangle, amount: f32) -> rl.Rectangle {
	amount := min(amount, rect.height)

	rect.height -= amount

	return rl.Rectangle{rect.x, rect.y + rect.height, rect.width, amount}
}

cut_left :: proc(rect: ^rl.Rectangle, amount: f32) -> rl.Rectangle {
	amount := min(amount, rect.width)

	slice := rl.Rectangle{rect.x, rect.y, amount, rect.height}

	rect.x += amount
	rect.width -= amount

	return slice
}

cut_right :: proc(rect: ^rl.Rectangle, amount: f32) -> rl.Rectangle {
	amount := min(amount, rect.width)

	rect.width -= amount

	return rl.Rectangle{rect.x + rect.width, rect.y, amount, rect.height}
}

space :: proc(rect: ^rl.Rectangle, amount: f32) {
	cut_top(rect, amount)
}

split_v :: proc(rect: rl.Rectangle, gap: f32) -> (left, right: rl.Rectangle) {
	half_width := (rect.width - gap) / 2

	left = rl.Rectangle{rect.x, rect.y, half_width, rect.height}
	right = rl.Rectangle{rect.x + half_width + gap, rect.y, half_width, rect.height}

	return
}

split_h :: proc(rect: rl.Rectangle, gap: f32) -> (top, bottom: rl.Rectangle) {
	half_height := (rect.height - gap) / 2

	top = rl.Rectangle{rect.x, rect.y, rect.width, half_height}
	bottom = rl.Rectangle{rect.x, rect.y + half_height + gap, rect.width, half_height}

	return
}
