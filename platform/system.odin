package platform

import win "core:sys/windows"
import "core:unicode/utf16"

PROCESSOR_ARCHITECTURE_INTEL :: 0
PROCESSOR_ARCHITECTURE_ARM :: 5
PROCESSOR_ARCHITECTURE_IA64 :: 6
PROCESSOR_ARCHITECTURE_AMD64 :: 9
PROCESSOR_ARCHITECTURE_ARM64 :: 12

get_sys_arch :: proc() -> string {
	sys_info: win.SYSTEM_INFO
	win.GetSystemInfo(&sys_info)

	switch sys_info.wProcessorArchitecture {
	case PROCESSOR_ARCHITECTURE_AMD64:
		return "x64"

	case PROCESSOR_ARCHITECTURE_ARM:
		return "ARM"

	case PROCESSOR_ARCHITECTURE_ARM64:
		return "ARM64"

	case PROCESSOR_ARCHITECTURE_IA64:
		return "Intel Itanium"

	case PROCESSOR_ARCHITECTURE_INTEL:
		return "x86"
	}

	return "Unknown"
}

get_uptime_ms :: proc() -> u64 {
	return u64(GetTickCount64())
}

get_computer_name :: proc(name_type := COMPUTER_NAME_FORMAT.DnsHostname) -> (string, bool) {
	size: win.DWORD = 0

	// the first call will update the size needed to store the name.
	GetComputerNameExW(name_type, nil, &size)

	if size == 0 {
		return "", false
	}

	buffer := make([]u16, int(size))
	defer delete(buffer)

	// it needs raw_data to only provide the pointer of the underlying slice (the slice has, length and capacity, while Windows expects only the pointer to the first element)
	ok := GetComputerNameExW(name_type, raw_data(buffer), &size)

	if !bool(ok) {
		return "", false
	}

	// it has a nul terminator, that's why I slice it
	name := _utf16_slice_to_string(buffer[:int(size)])

	return name, true
}

get_user_name :: proc() -> (string, bool) {
	size: win.DWORD = 256

	buffer := make([]u16, int(size))
	defer delete(buffer)

	ok := GetUserNameW(raw_data(buffer), &size)

	if !bool(ok) {
		return "", false
	}

	length := int(size)

	// this time the size includes the nul terminator
	if length > 0 && buffer[length - 1] == 0 {
		length -= 1
	}

	name := _utf16_slice_to_string(buffer[:length])

	return name, true
}


_utf16_slice_to_string :: proc(src: []u16) -> string {
	if len(src) == 0 {
		return ""
	}

	utf8_buffer := make([]u8, len(src) * 4)

	n := utf16.decode_to_utf8(utf8_buffer, src)

	return string(utf8_buffer[:n])
}
