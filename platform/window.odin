package platform

import win "core:sys/windows"

/*
	tell desktop window manager to round the window corners
  hwnd: the native handle, from rl.GetWindowHandle()
  returns false if the corners could not be rounded
*/
enable_rounded_corners :: proc(hwnd: rawptr) -> bool {
	if hwnd == nil {
		return false
	}

	pref := win.DWM_WINDOW_CORNER_PREFERENCE.ROUND

	hr := win.DwmSetWindowAttribute(
		win.HWND(hwnd),
		win.DWORD(win.DWMWINDOWATTRIBUTE.DWMWA_WINDOW_CORNER_PREFERENCE),
		&pref,
		win.DWORD(size_of(pref)),
	)

	return hr >= 0
}

enable_draggable_window :: proc(hwnd: rawptr) {
	if hwnd == nil {
		return
	}

	win.ReleaseCapture()

	win.SendMessageA(win.HWND(hwnd), win.WM_NCLBUTTONDOWN, win.WPARAM(win.HTCAPTION), 0)
}
