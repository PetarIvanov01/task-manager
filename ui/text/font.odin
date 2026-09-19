package text

import "../layout"

import "core:math"
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

measure :: proc(str: cstring, style: Style) -> rl.Vector2 {
	cfg := STYLES[style]

	return rl.MeasureTextEx(get_font(style), str, cfg.size, cfg.spacing)
}

draw :: proc(str: cstring, pos: rl.Vector2, style: Style, tint: Maybe(rl.Color) = nil) {
	cfg := STYLES[style]

	color := cfg.tint
	if override, ok := tint.?; ok {
		color = override
	}

	rl.DrawTextEx(get_font(style), str, snap(pos), cfg.size, cfg.spacing, color)
}

// Measure text, align and draw in one step.
draw_in :: proc(
	rect: rl.Rectangle,
	str: cstring,
	style: Style,
	align: layout.Align = .Left,
	tint: Maybe(rl.Color) = nil,
) {
	draw(str, layout.align_in(rect, measure(str, style), align), style, tint)
}

// Round in case of fractions
@(private)
snap :: proc(pos: rl.Vector2) -> rl.Vector2 {
	return rl.Vector2{math.round(pos.x), math.round(pos.y)}
}
