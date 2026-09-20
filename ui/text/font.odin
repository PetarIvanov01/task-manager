package text

import rl "vendor:raylib"

@(private)
fonts: map[i32]rl.Font

// Must be called after InitWindow.
load_fonts :: proc() {
	reserve(&fonts, len(Style))

	for style in Style {
		size := i32(STYLES[style].size)

		if size in fonts {
			continue
		}

		font := rl.LoadFontEx(FONT_PATH, size, nil, 0)

		rl.SetTextureFilter(font.texture, .POINT)

		fonts[size] = font
	}
}

unload_fonts :: proc() {
	for _, font in fonts {
		rl.UnloadFont(font)
	}

	delete(fonts)
}

get_font :: proc(style: Style) -> rl.Font {
	return fonts[i32(STYLES[style].size)]
}
