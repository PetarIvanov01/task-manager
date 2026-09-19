package components

import c "../constants"
import "../layout"
import "../text"
import "core:fmt"
import rl "vendor:raylib"

draw_tabs :: proc(start_y: ^i32, current_tab: c.Tabs) -> c.Tabs {

	tabs_rect := rl.Rectangle {
		x      = 0,
		y      = f32(start_y^),
		height = c.TABS_BAR_HEIGHT,
		width  = f32(rl.GetScreenWidth()),
	}

	rl.DrawRectangleRec(tabs_rect, c.TABS_BAR_BG)
	rl.DrawRectangleLinesEx(tabs_rect, 1, c.TABS_BAR_BG_BORDER)

	tabs_bounds := layout.inset_xy(tabs_rect, f32(24), f32(2))

	mouse := rl.GetMousePosition()
	selected := current_tab

	for tab in c.Tabs {
		label := c.TAB_LABELS[tab]

		label_rect := layout.cut_left(&tabs_bounds, f32(160))

		hovered := rl.CheckCollisionPointRec(mouse, label_rect)

		if hovered && rl.IsMouseButtonPressed(.LEFT) {
			selected = tab
		}

		if selected == tab {
			rl.DrawRectangleRec(label_rect, c.TAB_SELECTED_BG)
			text.draw_in(label_rect, fmt.ctprint(label), .Tab_Selected, .Center)
		} else if hovered {
			text.draw_in(label_rect, fmt.ctprint(label), .Tab_Selected, .Center)
		} else {
			rl.DrawRectangleRec(label_rect, c.TABS_BAR_BG)
			text.draw_in(label_rect, fmt.ctprint(label), .Tab, .Center)
		}
	}

	// Update start_y for the main_contaienr where the tabs will be rendered
	start_y^ = i32(tabs_rect.y + c.TABS_BAR_HEIGHT)

	return selected
}
