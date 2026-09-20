//Sizes, spacing, and text colors live here.
package text

import rl "vendor:raylib"

FONT_PATH :: "assets/fonts/inter-regular.ttf"

@(private)
PRIMARY :: rl.Color{230, 233, 239, 255}
@(private)
MUTED :: rl.Color{145, 150, 160, 255}

Config :: struct {
	size:    f32,
	spacing: f32,
	tint:    rl.Color,
}

Style :: enum {
	Title, // window / top bar title
	Section, // section header, e.g. "OPERATING SYSTEM"
	Label, // left hand side of a row
	Value, // right hand side of a row
	Tab,
	Tab_Selected,
	Process_Row_Label,
	Process_Row_Value,
}

// Typography settings for each text style.
@(private)
STYLES := [Style]Config {
	.Title = {size = 24, spacing = 0, tint = PRIMARY},
	.Section = {size = 15, spacing = 1, tint = MUTED},
	.Label = {size = 16, spacing = 0, tint = MUTED},
	.Value = {size = 16, spacing = 0, tint = PRIMARY},
	.Tab = {size = 20, spacing = 0, tint = rl.Color{154, 163, 178, 255}},
	.Tab_Selected = {size = 20, spacing = 0, tint = rl.WHITE},
	.Process_Row_Label = {size = 18, spacing = 0, tint = rl.WHITE},
	.Process_Row_Value = {size = 18, spacing = 0, tint = rl.WHITE},
}

get_config :: proc(style: Style) -> Config {
	return STYLES[style]
}
