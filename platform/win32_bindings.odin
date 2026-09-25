package platform

import win "core:sys/windows"

foreign import kernel32 "system:Kernel32.lib"
foreign import advapi32 "system:Advapi32.lib"
foreign import psapi "system:psapi.lib"

COMPUTER_NAME_FORMAT :: enum i32 {
	NetBIOS                   = 0,
	DnsHostname               = 1,
	DnsDomain                 = 2,
	DnsFullyQualified         = 3,
	PhysicalNetBIOS           = 4,
	PhysicalDnsHostname       = 5,
	PhysicalDnsDomain         = 6,
	PhysicalDnsFullyQualified = 7,
	Max                       = 8,
}

PROCESS_MEMORY_COUNTERS :: struct {
	cb:                         u32,
	PageFaultCount:             u32,
	PeakWorkingSetSize:         uintptr,
	WorkingSetSize:             uintptr,
	QuotaPeakPagedPoolUsage:    uintptr,
	QuotaPagedPoolUsage:        uintptr,
	QuotaPeakNonPagedPoolUsage: uintptr,
	QuotaNonPagedPoolUsage:     uintptr,
	PagefileUsage:              uintptr,
	PeakPagefileUsage:          uintptr,
}

@(default_calling_convention = "system")
foreign kernel32 {
	GetComputerNameExW :: proc(NameType: COMPUTER_NAME_FORMAT, lpBuffer: win.LPWSTR, nSize: ^win.DWORD) -> win.BOOL ---

	GetTickCount64 :: proc() -> win.ULONGLONG ---

	GetSystemTimes :: proc(lpIdleTime: ^win.FILETIME, lpKernelTime: ^win.FILETIME, lpUserTime: ^win.FILETIME) -> win.BOOL ---
}

@(default_calling_convention = "system")
foreign advapi32 {
	GetUserNameW :: proc(lpBuffer: win.LPWSTR, pcbBuffer: ^win.DWORD) -> win.BOOL ---
}

@(default_calling_convention = "system")
foreign psapi {

	// https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-getprocessmemoryinfo
	GetProcessMemoryInfo :: proc(process: win.HANDLE, counters: ^PROCESS_MEMORY_COUNTERS, cb: u32) -> win.BOOL ---
}
