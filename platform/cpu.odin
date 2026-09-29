package platform

import win "core:sys/windows"

System_CPU_Sample :: struct {
	idle:   u64,
	kernel: u64,
	user:   u64,
}

Process_CPU_Sample :: struct {
	creation: u64,
	kernel:   u64,
	user:     u64,
}

get_system_cpu_sample :: proc() -> (System_CPU_Sample, bool) {
	idle_ft: win.FILETIME
	kernel_ft: win.FILETIME
	user_ft: win.FILETIME

	ok := GetSystemTimes(&idle_ft, &kernel_ft, &user_ft)

	if !bool(ok) {
		return {}, false
	}

	return System_CPU_Sample {
			idle = filetime_to_u64(idle_ft),
			kernel = filetime_to_u64(kernel_ft),
			user = filetime_to_u64(user_ft),
		},
		true
}

/*
  return the cpu usage in percent between old and new snapshot
*/
system_cpu_usage :: proc(old, new: System_CPU_Sample) -> f64 {

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

get_process_cpu_sample :: proc(pid: int) -> (Process_CPU_Sample, bool) {
	handle := win.OpenProcess(win.PROCESS_QUERY_LIMITED_INFORMATION, false, u32(pid))
	if handle == nil {
		return {}, false
	}
	defer win.CloseHandle(handle)

	creation_ft: win.FILETIME
	exit_ft: win.FILETIME
	kernel_ft: win.FILETIME
	user_ft: win.FILETIME

	ok := win.GetProcessTimes(handle, &creation_ft, &exit_ft, &kernel_ft, &user_ft)
	if !bool(ok) {
		return {}, false
	}

	return Process_CPU_Sample {
			creation = filetime_to_u64(creation_ft),
			kernel = filetime_to_u64(kernel_ft),
			user = filetime_to_u64(user_ft),
		},
		true
}

process_cpu_usage :: proc(
	old_process, new_process: Process_CPU_Sample,
	old_system, new_system: System_CPU_Sample,
) -> (
	f64,
	bool,
) {
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

filetime_to_u64 :: proc(ft: win.FILETIME) -> u64 {
	return u64(ft.dwHighDateTime) << 32 | u64(ft.dwLowDateTime)
}
