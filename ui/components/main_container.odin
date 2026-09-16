package components

import sys "../../system"
import c "../constants/"

import "core:fmt"
import rl "vendor:raylib"

draw_main_container :: proc(
	font: rl.Font,
	info: sys.System_Info,
	stats: sys.Stats,
	container_start_y: i32 = 0,
) {
	y: i32 = container_start_y + 24
	row_gap: i32 = 28

	draw_info_row(font, "OS", fmt.ctprint(info.os_full), y)
	y += row_gap

	draw_info_row(font, "CPU", fmt.ctprint(info.cpu_name), y)
	y += row_gap

	draw_info_row(
		font,
		"Cores",
		fmt.ctprintf("%d physical / %d logical cores", info.phys_cores, info.log_cores),
		y,
	)
	y += row_gap

	draw_info_row(font, "Architecture", fmt.ctprint(info.arch), y)
	y += row_gap

	draw_info_row(font, "Computer", fmt.ctprint(info.cp_name), y)
	y += row_gap

	draw_info_row(font, "User", fmt.ctprint(info.user_name), y)
	y += row_gap

	// Separate live stats
	y += row_gap


	// live rows
	total_sec := stats.uptime_ms / 1000

	days := total_sec / 86_400
	hours := (total_sec / 3600) % 24
	min := (total_sec / 60) % 60
	sec := total_sec % 60

	draw_info_row(font, "Uptime", fmt.ctprintf("%dd %02d:%02d:%02d", days, hours, min, sec), y)
	y += row_gap

	total_ram_gb := f64(stats.total_ram) / c.GB
	used_ram := stats.total_ram - stats.free_ram

	free_ram_gb := f64(stats.free_ram) / c.GB
	used_ram_gb := f64(used_ram) / c.GB

	draw_info_row(
		font,
		"Memory",
		fmt.ctprintf(
			"%.2f GB total / %.2f GB free / %.2f GB used",
			total_ram_gb,
			free_ram_gb,
			used_ram_gb,
		),
		y,
	)
	y += row_gap

	draw_info_row(font, "CPU usage", fmt.ctprintf("%.1f%%", stats.cpu_usage), y)
	y += row_gap
}
