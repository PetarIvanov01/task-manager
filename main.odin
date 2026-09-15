package main

import "core:fmt"
import si "core:sys/info"
import "core:time"
import platform "platform"
import "ui"

GB :: 1024 * 1024 * 1024

main :: proc() {
	os_v, _ := si.os_version(context.allocator)
	cpu_name := si.cpu_name()
	physical_cores, logical_cores, _ := si.cpu_core_count()

	total_ram, free_ram, _, _, _ := si.ram_stats()
	used_ram := total_ram - free_ram

	total_ram_gb := f64(total_ram) / GB
	free_ram_gb := f64(free_ram) / GB
	used_ram_gb := f64(used_ram) / GB

	arch := platform.get_sys_arch()
	uptime_ms := platform.get_uptime_ms()

	computer_name, computer_name_ok := platform.get_computer_name()
	user_name, user_name_ok := platform.get_user_name()

	first_cpu, first_ok := platform.get_cpu_sample()

	if first_ok {
		time.sleep(time.Second)
	}

	second_cpu, second_ok := platform.get_cpu_sample()

	total_sec := uptime_ms / 1000

	days := total_sec / 86_400
	hours := (total_sec / 3600) % 24
	min := (total_sec / 60) % 60
	sec := total_sec % 60

	usage := platform.cpu_usage(first_cpu, second_cpu)

	ui.main()

}
