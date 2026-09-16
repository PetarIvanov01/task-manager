package ui

// import "core:fmt"
// import si "core:sys/info"
import platform "../platform"
import rl "vendor:raylib"
import components "components"
import c "constants"

System_Info :: struct {
	os_full:    string,
	cpu_name:   string,
	phys_cores: int,
	log_cores:  int,
	arch:       string,
	cp_name:    string,
	user_name:  string,
}

Stats :: struct {
	total_ram: i64,
	free_ram:  i64,
	uptime_ms: u64,
	cpu_usage: f64,
}

main :: proc() {

	rl.SetConfigFlags(rl.ConfigFlags{.WINDOW_UNDECORATED})
	rl.InitWindow(c.WINDOW_WIDTH, c.WINDOW_HEIGHT, c.WINDOW_TITLE)
	rl.SetWindowMinSize(c.WINDOW_WIDTH_MIN, c.WINDOW_HEIGHT_MIN)
	rl.SetTargetFPS(60)

	hndl := rl.GetWindowHandle()
	platform.enable_rounded_corners(hndl)

	close_tex := rl.LoadTexture(c.CLOSE_ICON)
	min_tex := rl.LoadTexture(c.MINIMIZE_ICON)

	defer {
		rl.UnloadTexture(close_tex)
		rl.UnloadTexture(min_tex)
		rl.CloseWindow()
	}

	for !rl.WindowShouldClose() {

		rl.BeginDrawing()

		rl.ClearBackground(c.BG)

		should_close := components.draw_top_bar(close_tex, min_tex)

		rl.EndDrawing()

		if should_close {
			break
		}
	}

}


