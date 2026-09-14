package main

import "core:fmt"
import si "core:sys/info"
import "core:time"
import platform "platform"

main :: proc() {
	os_v, _ := si.os_version(context.allocator)
	cpu_name := si.cpu_name()
	physical_cores, logical_cores, _ := si.cpu_core_count()

	total_ram, free_ram, _, _, _ := si.ram_stats()
	used_ram := total_ram - free_ram

	total_ram_gb := f64(total_ram) / 1_000_000_000
	free_ram_gb := f64(free_ram) / 1_000_000_000
	used_ram_gb := f64(used_ram) / 1_000_000_000

	arch := platform.get_sys_arch()
	uptime_ms := platform.get_uptime_ms()

	computer_name, computer_name_ok := platform.get_computer_name()
	user_name, user_name_ok := platform.get_user_name()

	first_cpu, first_ok := platform.get_cpu_sample()

	if first_ok {
		time.sleep(time.Second)
	}

	second_cpu, second_ok := platform.get_cpu_sample()

	// Just pringing for now

	fmt.println("--- System ---")
	fmt.println(os_v.full)
	fmt.println(cpu_name)

	fmt.printfln("%d physical / %d logical cores", physical_cores, logical_cores)

	fmt.printfln(
		"%.2f GB total / %.2f GB free / %.2f GB used",
		total_ram_gb,
		free_ram_gb,
		used_ram_gb,
	)

	fmt.printfln("Architecture: %s", arch)

	fmt.printfln("Uptime: %d ms", uptime_ms)

	if computer_name_ok {
		fmt.printfln("Computer name: %s", computer_name)
	}

	if user_name_ok {
		fmt.printfln("User name: %s", user_name)
	}

	if first_ok && second_ok {
		usage := platform.cpu_usage(first_cpu, second_cpu)

		fmt.printfln("CPU usage: %.2f%%", usage)
	}
}
