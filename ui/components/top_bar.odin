package components

import platform "../../platform/"
import c "../constants"
import "../input"
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

	close_hovered := input.hovered(&close_button)
	min_hovered := input.hovered(&min_button)

	top_bar := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = f32(rl.GetScreenWidth()),
		height = c.TOP_BAR_HEIGHT,
	}

	// Dragging
	if input.selected(&top_bar) && !close_hovered && !min_hovered {
		hwnd := rl.GetWindowHandle()
		platform.enable_draggable_window(hwnd)
	}

	if close_hovered {
		rl.DrawRectangleRec(close_button, c.CLOSE_BUTTON_HOVER)
	}

	if min_hovered {
		rl.DrawRectangleRec(min_button, c.BUTTON_HOVER)
	}

	close_pos := layout.align_in(
		close_button,
		rl.Vector2{f32(close_tex.width), f32(close_tex.height)},
		.Center,
	)

	min_pos := layout.align_in(
		min_button,
		rl.Vector2{f32(min_tex.width), f32(min_tex.height)},
		.Center,
	)

	rl.DrawTexture(min_tex, i32(min_pos.x), i32(min_pos.y), c.ICON_MUTED)
	rl.DrawTexture(close_tex, i32(close_pos.x), i32(close_pos.y), c.ICON_MUTED)

	if input.selected(&min_button) {
		rl.MinimizeWindow()
	}

	if input.selected(&close_button) {
		return i32(c.TOP_BAR_HEIGHT), true
	}

	return i32(c.TOP_BAR_HEIGHT), false
}
