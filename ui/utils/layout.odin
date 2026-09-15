package utils

get_center_x :: proc(item_width, container_width: i32) -> i32 {
	return (container_width - item_width) / 2
}

get_center_y :: proc(item_height, container_height: i32) -> i32 {
	return (container_height - item_height) / 2
}
