package system

import "../platform"
import "core:os"
import "core:strings"

Process :: struct {
	name:      string,
	pid:       int,
	cpu_usage: f64,
	memory:    f32,
	threads:   Maybe(int),
}

free_processes :: proc(processes: []Process) {
	for process in processes {
		delete(process.name)
	}

	delete(processes)
}

get_processes :: proc() -> ([]Process, bool) {
	pids, err := os.process_list(context.allocator)
	if err != nil {
		return {}, false
	}

	defer delete(pids)

	processes := make([dynamic]Process, 0, context.allocator)

	for pid in pids {
		if pid == 0 {
			continue
		}

		info, err := os.process_info_by_pid(pid, {.Executable_Path}, context.allocator)

		name: string

		if .Executable_Path in info.fields && len(info.executable_path) > 0 {
			name = strings.clone(os.base(info.executable_path), context.allocator)
		} else {
			name = strings.clone("unknown", context.allocator)
		}

		memory_bytes, memory_ok := platform.get_process_memory(pid)
		memory_mb: f32 = 0

		if name == "unknown" && !memory_ok {
			os.free_process_info(info, context.allocator)
			continue
		}

		if memory_ok {
			memory_mb = f32(memory_bytes) / (1024 * 1024)
		}

		process := Process {
			name   = name,
			pid    = pid,
			memory = memory_mb,
		}

		append(&processes, process)

		os.free_process_info(info, context.allocator)
	}

	return processes[:], true
}
