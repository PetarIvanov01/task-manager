package components

import c "../constants"
import "../layout"
import "../text"

import "core:fmt"
import rl "vendor:raylib"

Row :: struct {
	label: cstring,
	value: cstring,
}

draw_section :: proc(area: ^rl.Rectangle, title: cstring, rows: []Row) {
	draw_section_header(area, title)
	draw_rows(area, rows)
}

draw_section_header :: proc(area: ^rl.Rectangle, title: cstring) {
	text.draw_in(layout.cut_top(area, c.SECTION_HEADER_HEIGHT), title, .Section)
	layout.draw_rule(layout.cut_top(area, c.SECTION_RULE_HEIGHT), c.RULE)
}

draw_rows :: proc(area: ^rl.Rectangle, rows: []Row) {
	for row in rows {
		draw_row(layout.cut_top(area, c.ROW_HEIGHT), row)
	}
}

draw_row :: proc(bounds: rl.Rectangle, row: Row) {
	bounds := bounds

	label := layout.cut_left(&bounds, c.LABEL_COLUMN)
	value := bounds

	text.draw_in(label, row.label, .Label)
	text.draw_in(value, row.value, .Value)
}

// A label plus a progress bar with the percentage printed inside it.
draw_meter :: proc(bounds: rl.Rectangle, label: cstring, fraction: f32) {
	bounds := bounds
	fraction := clamp(fraction, 0, 1)

	text.draw_in(layout.cut_left(&bounds, c.LABEL_COLUMN), label, .Label)

	track := layout.inset_xy(bounds, 0, (bounds.height - c.METER_HEIGHT) / 2)

	rl.DrawRectangleRounded(track, 0.3, 6, c.METER_BG)

	fill := track
	fill.width = track.width * fraction

	if fill.width >= 2 {
		rl.DrawRectangleRounded(fill, 0.3, 6, c.ACCENT)
	}

	rl.DrawRectangleRoundedLines(track, 0.3, 6, c.RULE)

	text.draw_in(track, fmt.ctprintf("%.0f%%", fraction * 100), .Value, .Center)
}
