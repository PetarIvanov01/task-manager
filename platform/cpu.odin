package platform

import win "core:sys/windows"

CPU_Sample :: struct {
	idle:   u64,
	kernel: u64,
	user:   u64,
}

get_cpu_sample :: proc() -> (CPU_Sample, bool) {
	idle_ft: win.FILETIME
	kernel_ft: win.FILETIME
	user_ft: win.FILETIME

	ok := GetSystemTimes(&idle_ft, &kernel_ft, &user_ft)

	if !bool(ok) {
		return {}, false
	}

	return CPU_Sample {
			idle = filetime_to_u64(idle_ft),
			kernel = filetime_to_u64(kernel_ft),
			user = filetime_to_u64(user_ft),
		},
		true
}

/*
  return the cpu usage in percent between old and new snapshot
*/
cpu_usage :: proc(old, new: CPU_Sample) -> f64 {

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

filetime_to_u64 :: proc(ft: win.FILETIME) -> u64 {
	return u64(ft.dwHighDateTime) << 32 | u64(ft.dwLowDateTime)
}
