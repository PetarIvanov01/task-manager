package input

import rl "vendor:raylib"

hovered :: proc(rect: ^rl.Rectangle) -> bool {
	mouse := rl.GetMousePosition()
	return rl.CheckCollisionPointRec(mouse, rect^)
}

selected :: proc(rect: ^rl.Rectangle) -> bool {
	return hovered(rect) && rl.IsMouseButtonPressed(.LEFT)
}
