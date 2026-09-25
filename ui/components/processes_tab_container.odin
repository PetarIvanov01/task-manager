package components

import sys "../../system"
import c "../constants/"
import "../layout"
import "../text"

import "core:fmt"
import rl "vendor:raylib"

Process_View_State :: struct {
	scroll_y:     f32,
	selected_pid: Maybe(int),
	processes:    []sys.Process,
	// sorting state
}

draw_processes_tab_container :: proc(
	info: sys.System_Info,
	stats: sys.Stats,
	container_start_x: i32 = 0,
	container_start_y: i32 = 0,
	state: ^Process_View_State,
) {
	main_rect := rl.Rectangle {
		x      = f32(container_start_x),
		y      = f32(container_start_y),
		width  = f32(rl.GetScreenWidth() - container_start_x),
		height = f32(rl.GetScreenHeight() - container_start_y),
	}

	search := layout.cut_top(&main_rect, c.SEARCH_HEIGHT)
	rl.DrawRectangleRec(search, c.SEARCH_BG)
	layout.draw_bottom_border(&search, 1, c.TABS_BAR_BG_BORDER)

	draw_table(&main_rect, state)
}

@(private)
draw_table :: proc(table_rect: ^rl.Rectangle, state: ^Process_View_State) {
	data := state.processes

	table_area := table_rect^
	rl.DrawRectangleRec(table_area, c.TABS_BAR_BG) // Sets the bg color for the whole table

	row_height := c.PROCESS_ROW_HEIGHT

	header_rect := layout.cut_top(&table_area, row_height)
	draw_process_header(&header_rect)

	body_viewport := table_area
	total_rows_h := f32(len(data)) * row_height

	update_scroll_y(state, body_viewport.height, total_rows_h, row_height)

	rl.BeginScissorMode(
		i32(body_viewport.x),
		i32(body_viewport.y),
		i32(body_viewport.width),
		i32(body_viewport.height),
	)

	for process, i in data {
		row_rect := rl.Rectangle {
			x      = body_viewport.x,
			y      = body_viewport.y + f32(i) * row_height - state.scroll_y,
			width  = body_viewport.width,
			height = row_height,
		}

		if i % 2 == 0 {
			rl.DrawRectangleRec(row_rect, c.PROCESS_ROW_EVEN)
		} else {
			rl.DrawRectangleRec(row_rect, c.PROCESS_ROW_ODD)
		}

		row_content := layout.inset_xy(row_rect, 18, 0)
		content_width := row_content.width

		for column in c.Column {
			config := c.COLUMNS[column]

			cell_width := content_width * config.ratio
			cell := layout.cut_left(&row_content, cell_width)

			switch column {
			case .Name:
				text.draw_in(cell, fmt.ctprint(process.name), .Process_Row_Value, config.alignment)
			case .PID:
				text.draw_in(cell, fmt.ctprint(process.pid), .Process_Row_Value, config.alignment)
			case .CPU:
				text.draw_in(
					cell,
					fmt.ctprintf("%.1f%%", process.cpu_usage),
					.Process_Row_Value,
					config.alignment,
				)

			case .Memory:
				text.draw_in(
					cell,
					fmt.ctprintf("%.1f MB", process.memory),
					.Process_Row_Value,
					config.alignment,
				)
			case .Threads:
				if threads, ok := process.threads.?; ok {
					text.draw_in(cell, fmt.ctprint(threads), .Process_Row_Value, config.alignment)
				}
			}
		}
	}

	rl.EndScissorMode()
}

@(private)
draw_process_header :: proc(rect: ^rl.Rectangle) {
	table_rect := rect^
	rl.DrawRectangleRec(table_rect, c.PROCESS_HEADER_BG)
	layout.draw_bottom_border(&table_rect, 1, c.TABS_BAR_BG_BORDER)

	row := layout.inset_xy(table_rect, 18, 1)
	row_width := row.width

	for column in c.Column {
		config := c.COLUMNS[column]
		cell_width := row_width * config.ratio
		cell := layout.cut_left(&row, cell_width)
		text.draw_in(cell, config.label, .Process_Row_Label, config.alignment)
	}
}

@(private)
draw_scrollbar :: proc(body_rect: ^rl.Rectangle, scroll_y: f32, row_height: f32) {

}

@(private)
update_scroll_y :: proc(
	state: ^Process_View_State,
	viewport_h: f32,
	content_h: f32,
	scroll_step: f32,
) {
	max_scroll := max(content_h - viewport_h, 0)

	state.scroll_y -= rl.GetMouseWheelMove() * scroll_step
	state.scroll_y = clamp(state.scroll_y, 0, max_scroll)
}
