package system

import "core:sync"
import "core:thread"
import "core:time"

System_Snapshot :: struct {
	stats:     Stats,
	processes: []Process,
}

free_system_snapshot :: proc(snapshot: ^System_Snapshot) {
	free_processes(snapshot.processes)
	snapshot^ = {}
}

Monitor_Worker :: struct {
	mutex:      sync.Mutex,
	latest:     System_Snapshot,
	has_update: bool,
	running:    bool,
}

monitor_worker_proc :: proc(t: ^thread.Thread) {
	worker := cast(^Monitor_Worker)t.data
	cpu_state := Process_CPU_State{}
	system_cpu_usage: f64

	defer {
		if cpu_state.has_previous {
			delete(cpu_state.previous_processes)
		}
	}

	for {
		sync.mutex_lock(&worker.mutex)
		running := worker.running
		sync.mutex_unlock(&worker.mutex)

		if !running {
			break
		}

		processes, current_system_cpu, system_cpu_ok, ok := collect_process_metrics(&cpu_state)
		if !ok {
			time.sleep(time.Second)
			continue
		}

		if system_cpu_ok {
			system_cpu_usage = current_system_cpu
		}

		new_snapshot := System_Snapshot {
			stats     = get_stats(system_cpu_usage),
			processes = processes,
		}

		stale_snapshot: System_Snapshot

		sync.mutex_lock(&worker.mutex)

		stale_snapshot = worker.latest
		worker.latest = new_snapshot
		worker.has_update = true

		sync.mutex_unlock(&worker.mutex)

		free_system_snapshot(&stale_snapshot)

		time.sleep(time.Second)
	}
}

consume_monitor_update :: proc(worker: ^Monitor_Worker, snapshot: ^System_Snapshot) {
	new_snapshot: System_Snapshot
	has_update := false

	sync.mutex_lock(&worker.mutex)

	if worker.has_update {
		new_snapshot = worker.latest
		worker.latest = {}
		worker.has_update = false
		has_update = true
	}

	sync.mutex_unlock(&worker.mutex)

	if has_update {
		free_system_snapshot(snapshot)
		snapshot^ = new_snapshot
	}
}

monitor_worker_clean_up :: proc(worker: ^Monitor_Worker) {
	sync.mutex_lock(&worker.mutex)
	worker.running = false
	sync.mutex_unlock(&worker.mutex)
}
