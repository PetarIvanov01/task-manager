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
	snapshot := sys.System_Snapshot{}

	current_tab := c.Tabs.System

	// Process Tab State
	process_view_state := components.Process_View_State{}

	monitor_worker := sys.Monitor_Worker {
		running = true,
	}

	worker_thread := thread.create(sys.monitor_worker_proc)
	worker_thread.data = &monitor_worker

	thread.start(worker_thread)

	defer {
		sys.monitor_worker_clean_up(&monitor_worker)
		thread.join(worker_thread)

		if monitor_worker.has_update {
			sys.free_system_snapshot(&monitor_worker.latest)
		}
	}

	defer sys.free_system_snapshot(&snapshot)

	for !rl.WindowShouldClose() {
		sys.consume_monitor_update(&monitor_worker, &snapshot)

		// the ctprint* calls made while drawing live in the temp allocator
		defer free_all(context.temp_allocator)

		rl.BeginDrawing()
		rl.ClearBackground(c.BG)

		container_start_y, should_close := components.draw_top_bar(close_tex, min_tex)

		current_tab = components.draw_tabs(&container_start_y, current_tab)

		switch current_tab {
		case .System:
			components.draw_system_tab_container(sys_inf, snapshot.stats, 0, container_start_y)

		case .Process:
			components.draw_processes_tab_container(
				snapshot.processes,
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
