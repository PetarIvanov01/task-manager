package components

import platform "../../platform/"
import c "../constants"
import "../layout"
import "../text"
import rl "vendor:raylib"

draw_top_bar :: proc(close_tex, min_tex: rl.Texture2D) -> (i32, bool) {
	rl.DrawRectangle(0, 0, rl.GetScreenWidth(), i32(c.TOP_BAR_HEIGHT), c.TOP_BAR)

	title_area := rl.Rectangle{0, 0, f32(rl.GetScreenWidth()), c.TOP_BAR_HEIGHT}
	layout.cut_left(&title_area, c.CONTENT_PADDING)

	text.draw_in(title_area, c.WINDOW_TITLE, .Title)

	screen_width := f32(rl.GetScreenWidth())

	close_button := rl.Rectangle {
		x      = screen_width - c.TOP_BAR_BUTTON_WIDTH,
		y      = 0,
		width  = c.TOP_BAR_BUTTON_WIDTH,
		height = c.TOP_BAR_HEIGHT,
	}

	min_button := rl.Rectangle {
		x      = screen_width - c.TOP_BAR_BUTTON_WIDTH * 2,
		y      = 0,
		width  = c.TOP_BAR_BUTTON_WIDTH,
		height = c.TOP_BAR_HEIGHT,
	}

	/*
		The idea is to get the mouse Vector2 (position of the mouse) and check on each frame
		whether the mouse is over the button in order to apply the hover
	*/
	mouse := rl.GetMousePosition()

	close_hovered := rl.CheckCollisionPointRec(mouse, close_button)
	min_hovered := rl.CheckCollisionPointRec(mouse, min_button)

	top_bar := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = f32(rl.GetScreenWidth()),
		height = c.TOP_BAR_HEIGHT,
	}

	if rl.CheckCollisionPointRec(mouse, top_bar) &&
	   rl.IsMouseButtonPressed(.LEFT) &&
	   !close_hovered &&
	   !min_hovered {

		hwnd := rl.GetWindowHandle()
		platform.enable_draggable_window(hwnd)
	}

	if close_hovered {
		rl.DrawRectangleRec(close_button, c.CLOSE_BUTTON_HOVER)
	}

	if min_hovered {
		rl.DrawRectangleRec(min_button, c.BUTTON_HOVER)
	}

	// Center icons inside their buttons
	close_x := i32(close_button.x) + layout.get_center_x(close_tex.width, i32(close_button.width))
	close_y :=
		i32(close_button.y) + layout.get_center_y(close_tex.height, i32(close_button.height))

	min_x := i32(min_button.x) + layout.get_center_x(min_tex.width, i32(min_button.width))
	min_y := i32(min_button.y) + layout.get_center_y(min_tex.height, i32(min_button.height))

	rl.DrawTexture(min_tex, min_x, min_y, c.ICON_MUTED)
	rl.DrawTexture(close_tex, close_x, close_y, c.ICON_MUTED)

	if min_hovered && rl.IsMouseButtonReleased(.LEFT) {
		rl.MinimizeWindow()
	}

	if close_hovered && rl.IsMouseButtonReleased(.LEFT) {
		return i32(c.TOP_BAR_HEIGHT), true
	}

	return i32(c.TOP_BAR_HEIGHT), false
}
