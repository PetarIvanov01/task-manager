package stats

import platform "../platform"
import si "core:sys/info"

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

get_system_info :: proc() -> (System_Info, bool) {
	os_v, _ := si.os_version(context.allocator)
	cpu_name := si.cpu_name()
	physical_cores, logical_cores, _ := si.cpu_core_count()
	arch := platform.get_sys_arch()
	user_name, _ := platform.get_user_name()
	cp_name, _ := platform.get_computer_name()

	sys_info := System_Info {
		os_full    = os_v.full,
		cpu_name   = cpu_name,
		phys_cores = physical_cores,
		log_cores  = logical_cores,
		arch       = arch,
		cp_name    = cp_name,
		user_name  = user_name,
	}

	return sys_info, true
}

get_stats :: proc(prev_cpu: platform.CPU_Sample) -> (Stats, platform.CPU_Sample, bool) {
	current_cpu, ok := platform.get_cpu_sample()
	if !ok {
		return {}, prev_cpu, false
	}

	total_ram, free_ram, _, _, _ := si.ram_stats()

	stats := Stats {
		total_ram = total_ram,
		free_ram  = free_ram,
		uptime_ms = platform.get_uptime_ms(),
		cpu_usage = platform.cpu_usage(prev_cpu, current_cpu),
	}

	return stats, current_cpu, true
}
