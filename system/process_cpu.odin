package system

import "../platform"

@(private = "package")
Process_CPU_State :: struct {
	previous_system:    platform.System_CPU_Sample,
	previous_processes: map[int]platform.Process_CPU_Sample,
	has_previous:       bool,
}

@(private = "package")
calculate_system_cpu_usage :: proc(
	old, new: platform.System_CPU_Sample,
) -> f64 {
	idle_delta := new.idle - old.idle
	kernel_delta := new.kernel - old.kernel
	user_delta := new.user - old.user

	total := kernel_delta + user_delta
	if total == 0 {
		return 0
	}

	busy := total - idle_delta
	return f64(busy) / f64(total) * 100.0
}

@(private = "package")
calculate_process_cpu_usage :: proc(
	old_process, new_process: platform.Process_CPU_Sample,
	old_system, new_system: platform.System_CPU_Sample,
) -> (f64, bool) {
	if old_process.creation != new_process.creation ||
	   new_process.kernel < old_process.kernel ||
	   new_process.user < old_process.user ||
	   new_system.kernel < old_system.kernel ||
	   new_system.user < old_system.user {
		return 0, false
	}

	process_delta :=
		(new_process.kernel - old_process.kernel) + (new_process.user - old_process.user)
	system_delta := (new_system.kernel - old_system.kernel) + (new_system.user - old_system.user)

	if system_delta == 0 {
		return 0, false
	}

	return f64(process_delta) / f64(system_delta) * 100.0, true
}

@(private = "package")
sample_process_cpu_usage :: proc(
	pid: int,
	cpu_state: ^Process_CPU_State,
	current_cpu_samples: ^map[int]platform.Process_CPU_Sample,
	current_system: platform.System_CPU_Sample,
) -> f64 {
	current_cpu, cpu_ok := platform.get_process_cpu_sample(pid)
	if !cpu_ok {
		return 0
	}

	current_cpu_samples^[pid] = current_cpu

	if !cpu_state.has_previous {
		return 0
	}

	previous_cpu, found := cpu_state.previous_processes[pid]
	if !found {
		return 0
	}

	usage, usage_ok := calculate_process_cpu_usage(
		previous_cpu,
		current_cpu,
		cpu_state.previous_system,
		current_system,
	)
	if !usage_ok {
		return 0
	}

	return usage
}
