# Vigil

A small Windows system monitor written in [Odin](https://odin-lang.org/) with
[raylib](https://www.raylib.com/). I made it to learn more about Odin, native
desktop applications, and the Windows APIs behind tools like Task Manager.

## Demo

https://github.com/user-attachments/assets/aee754a8-8163-47d5-98b8-5fbb5a11966b

## What it does

- shows operating system, machine, processor, uptime, CPU, and memory information
- lists running processes with their PID, CPU usage, and working-set memory
- samples system and per-process CPU time through Windows APIs
- collects system data once per second on a worker thread instead of blocking the UI
- renders separate system and process views with a custom draggable window frame

The monitor uses a small producer/consumer setup. A worker thread enumerates
processes, samples CPU times, and builds a new system snapshot. The render
thread takes the latest snapshot under a mutex and frees the previous one, so
the UI can keep drawing while the blocking operating-system work happens in the
background.

## Current limits

- the application supports Windows only
- the process view is read-only; processes cannot be started, stopped, or inspected
- the search area is visual only, and sorting is not implemented
- the threads column is reserved in the UI but thread counts are not collected yet
- process information can be unavailable when Windows denies access or a process exits during collection
- automated tests are not implemented yet

## Run it

Run the project from its repository directory:

```bat
run.bat
```

The script copies the bundled `raylib.dll` and runs
`build\task-manager.exe`. To build without running:

```bat
build.bat
```
