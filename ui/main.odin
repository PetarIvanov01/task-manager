package ui

import platform "../platform"
import sys "../system"
import components "components"
import c "constants"
import "core:thread"
import "text"
import rl "vendor:raylib"

main :: proc() {
	rl.SetConfigFlags(rl.ConfigFlags{.WINDOW_UNDECORATED})
	rl.InitWindow(c.WINDOW_WIDTH, c.WINDOW_HEIGHT, c.WINDOW_TITLE)
	rl.SetWindowMinSize(c.WINDOW_WIDTH_MIN, c.WINDOW_HEIGHT_MIN)
	rl.SetTargetFPS(60)

	hndl := rl.GetWindowHandle()
	platform.enable_rounded_corners(hndl)

	text.load_fonts()
	close_tex := rl.LoadTexture(c.CLOSE_ICON)
	min_tex := rl.LoadTexture(c.MINIMIZE_ICON)

	defer {
		text.unload_fonts()
		rl.UnloadTexture(close_tex)
		rl.UnloadTexture(min_tex)
		rl.CloseWindow()
	}

	sys_inf, _ := sys.get_system_info()

	update_timer: f32 = 0

	prev_cpu, cpu_ok := platform.get_cpu_sample()
	stats := sys.Stats{}

	// init ram/uptime so the first second of the window is not empty
	if cpu_ok {
		if first_stats, current_cpu, ok := sys.get_stats(prev_cpu); ok {
			stats = first_stats
			prev_cpu = current_cpu
		}
	}

	current_tab := c.Tabs.System

	// Process Tab State
	process_view_state := components.Process_View_State{}

	process_worker := sys.Process_Worker {
		running = true,
	}

	worker_thread := thread.create(sys.process_worker_proc)
	worker_thread.data = &process_worker

	thread.start(worker_thread)

	defer {
		sys.process_worker_clean_up(&process_worker)
		thread.join(worker_thread)

		if process_worker.has_update {
			sys.free_processes(process_worker.latest)
		}
	}

	defer sys.free_processes(process_view_state.processes)

	for !rl.WindowShouldClose() {
		// check whether the another thread has published the processes
		sys.consume_process_update(&process_worker, &process_view_state.processes)

		// the ctprint* calls made while drawing live in the temp allocator
		defer free_all(context.temp_allocator)

		update_timer += rl.GetFrameTime()
		if update_timer >= c.UPDATE_INTERVAL {
			update_cpu_usage_each_second(&prev_cpu, &stats, cpu_ok)

			update_timer -= c.UPDATE_INTERVAL
		}

		rl.BeginDrawing()
		rl.ClearBackground(c.BG)

		container_start_y, should_close := components.draw_top_bar(close_tex, min_tex)

		current_tab = components.draw_tabs(&container_start_y, current_tab)

		switch current_tab {
		case .System:
			components.draw_system_tab_container(sys_inf, stats, 0, container_start_y)

		case .Process:
			components.draw_processes_tab_container(
				sys_inf,
				stats,
				0,
				container_start_y,
				&process_view_state,
			)
		}

		rl.EndDrawing()

		if should_close {
			break
		}
	}

}

update_cpu_usage_each_second :: proc(
	prev_cpu: ^platform.CPU_Sample,
	stats: ^sys.Stats,
	cpu_ok: bool,
) {
	if cpu_ok {
		new_stats, current_cpu, stats_ok := sys.get_stats(prev_cpu^)

		if stats_ok {
			stats^ = new_stats
			prev_cpu^ = current_cpu
		}
	}
}
