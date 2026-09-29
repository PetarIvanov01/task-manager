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

filetime_to_u64 :: proc(ft: win.FILETIME) -> u64 {
	return u64(ft.dwHighDateTime) << 32 | u64(ft.dwLowDateTime)
}
