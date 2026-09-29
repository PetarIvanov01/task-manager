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

@(private = "package")
free_processes :: proc(processes: []Process) {
	for process in processes {
		delete(process.name)
	}

	delete(processes)
}

// Do not call this in the render thread; the process loop is blocking.
@(private = "package")
collect_process_metrics :: proc(cpu_state: ^Process_CPU_State) -> ([]Process, f64, bool, bool) {
	pids, err := os.process_list(context.allocator)
	if err != nil {
		return {}, 0, false, false
	}
	defer delete(pids)

	current_system_sample, system_ok := platform.get_system_cpu_sample()

	system_cpu_usage: f64 = 0
	system_cpu_ok: bool = false

	if system_ok && cpu_state.has_previous {
		system_cpu_usage = calculate_system_cpu_usage(
			cpu_state.previous_system,
			current_system_sample,
		)
		system_cpu_ok = true
	}

	current_cpu_samples := make(map[int]platform.Process_CPU_Sample)
	keep_cpu_samples := false
	defer {
		if !keep_cpu_samples {
			delete(current_cpu_samples)
		}
	}

	processes := make([dynamic]Process, 0, context.allocator)

	for pid in pids {
		if pid == 0 {
			continue
		}

		info, _ := os.process_info_by_pid(pid, {.Executable_Path}, context.allocator)

		name: string
		if .Executable_Path in info.fields && len(info.executable_path) > 0 {
			name = strings.clone(os.base(info.executable_path), context.allocator)
		} else {
			name = strings.clone("unknown", context.allocator)
		}

		if name == "unknown" {
			os.free_process_info(info, context.allocator)
			continue
		}

		memory_bytes, memory_ok := platform.get_process_memory(pid)
		memory_mb: f32 = 0
		if memory_ok {
			memory_mb = f32(memory_bytes) / (1024 * 1024)
		}

		process_cpu_usage: f64

		if system_ok {
			process_cpu_usage = sample_process_cpu_usage(
				pid,
				cpu_state,
				&current_cpu_samples,
				current_system_sample,
			)
		}

		process := Process {
			name      = name,
			pid       = pid,
			cpu_usage = process_cpu_usage,
			memory    = memory_mb,
		}

		append(&processes, process)
		os.free_process_info(info, context.allocator)
	}

	if system_ok {
		if cpu_state.has_previous {
			delete(cpu_state.previous_processes)
		}

		cpu_state.previous_system = current_system_sample
		cpu_state.previous_processes = current_cpu_samples
		cpu_state.has_previous = true
		keep_cpu_samples = true
	}

	return processes[:], system_cpu_usage, system_cpu_ok, true
}
