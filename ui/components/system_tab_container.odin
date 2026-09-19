package components

import sys "../../system"
import c "../constants/"
import "../layout"

import "core:fmt"
import rl "vendor:raylib"

draw_system_tab_container :: proc(
	info: sys.System_Info,
	stats: sys.Stats,
	container_start_x: i32 = 0,
	container_start_y: i32 = 0,
) {
	main_rect := rl.Rectangle {
		x      = f32(container_start_x),
		y      = f32(container_start_y),
		width  = f32(rl.GetScreenWidth() - container_start_x),
		height = f32(rl.GetScreenHeight() - container_start_y),
	}

	content := layout.inset(main_rect, c.CONTENT_PADDING)
	left, right := layout.split_v(content, c.COLUMN_GAP)

	// divider sitting in the gap between the two columns
	divider := rl.Rectangle{left.x + left.width, content.y, c.COLUMN_GAP, content.height}
	layout.draw_rule_v(divider, c.RULE)

	draw_system_column(&left, info, stats)
	draw_resources_column(&right, stats)
}

// Left column.
draw_system_column :: proc(area: ^rl.Rectangle, info: sys.System_Info, stats: sys.Stats) {
	draw_section(
		area,
		"OPERATING SYSTEM",
		[]Row {
			{"Edition", fmt.ctprint(info.os_edition)},
			{"Version", fmt.ctprint(info.os_release)},
			{"Build", fmt.ctprintf("%d.%d", info.os_build, info.os_revision)},
			{"Architecture", fmt.ctprint(info.arch)},
		},
	)
	layout.space(area, c.SECTION_GAP)

	draw_section(
		area,
		"MACHINE",
		[]Row {
			{"Computer name", fmt.ctprint(info.cp_name)},
			{"Signed in as", fmt.ctprint(info.user_name)},
			{"Uptime", format_uptime(stats.uptime_ms)},
		},
	)
	layout.space(area, c.SECTION_GAP)

	draw_section(
		area,
		"PROCESSOR",
		[]Row {
			{"Model", fmt.ctprint(info.cpu_name)},
			{"Cores", fmt.ctprintf("%d physical / %d logical", info.phys_cores, info.log_cores)},
		},
	)
}

// Right column.
draw_resources_column :: proc(area: ^rl.Rectangle, stats: sys.Stats) {
	used_ram := stats.total_ram - stats.free_ram

	memory_fraction: f32 = 0
	if stats.total_ram > 0 {
		memory_fraction = f32(f64(used_ram) / f64(stats.total_ram))
	}

	draw_section_header(area, "CPU & MEMORY")

	draw_meter(layout.cut_top(area, c.METER_ROW_HEIGHT), "CPU", f32(stats.cpu_usage / 100))
	draw_meter(layout.cut_top(area, c.METER_ROW_HEIGHT), "Memory", memory_fraction)

	layout.space(area, 8)

	draw_rows(
		area,
		[]Row {
			{"Total", fmt.ctprintf("%.2f GB", f64(stats.total_ram) / c.GB)},
			{"Used", fmt.ctprintf("%.2f GB", f64(used_ram) / c.GB)},
			{"Available", fmt.ctprintf("%.2f GB", f64(stats.free_ram) / c.GB)},
		},
	)
}

format_uptime :: proc(uptime_ms: u64) -> cstring {
	total_sec := uptime_ms / 1000

	days := total_sec / 86_400
	hours := (total_sec / 3600) % 24
	min := (total_sec / 60) % 60
	sec := total_sec % 60

	return fmt.ctprintf("%dd %02d:%02d:%02d", days, hours, min, sec)
}
