package ui

import platform "../platform"
import sys "../system"
import components "components"
import c "constants"
import rl "vendor:raylib"

main :: proc() {

	rl.SetConfigFlags(rl.ConfigFlags{.WINDOW_UNDECORATED})
	rl.InitWindow(c.WINDOW_WIDTH, c.WINDOW_HEIGHT, c.WINDOW_TITLE)
	rl.SetWindowMinSize(c.WINDOW_WIDTH_MIN, c.WINDOW_HEIGHT_MIN)
	rl.SetTargetFPS(60)

	hndl := rl.GetWindowHandle()
	platform.enable_rounded_corners(hndl)

	font_regular := rl.LoadFontEx(c.FONT_PATH, c.FONT_SIZE_INFO, nil, 0)
	font_big := rl.LoadFontEx(c.FONT_PATH, c.FONT_SIZE_TITLE, nil, 0)
	close_tex := rl.LoadTexture(c.CLOSE_ICON)
	min_tex := rl.LoadTexture(c.MINIMIZE_ICON)

	defer {
		rl.UnloadFont(font_regular)
		rl.UnloadFont(font_big)
		rl.UnloadTexture(close_tex)
		rl.UnloadTexture(min_tex)
		rl.CloseWindow()
	}

	sys_inf, _ := sys.get_system_info()

	update_timer: f32 = 0

	prev_cpu, cpu_ok := platform.get_cpu_sample()
	stats := sys.Stats{}

	for !rl.WindowShouldClose() {

		// calc the cpu usage every sec
		update_timer += rl.GetFrameTime()

		if update_timer >= c.UPDATE_INTERVAL {
			if cpu_ok {
				new_stats, current_cpu, stats_ok := sys.get_stats(prev_cpu)

				if stats_ok {
					stats = new_stats
					prev_cpu = current_cpu
				}
			}

			update_timer -= c.UPDATE_INTERVAL
		}

		rl.BeginDrawing()

		rl.ClearBackground(c.BG)

		container_start_y, should_close := components.draw_top_bar(font_big, close_tex, min_tex)

		components.draw_main_container(font_regular, sys_inf, stats, container_start_y)

		rl.EndDrawing()

		if should_close {
			break
		}
	}

}
