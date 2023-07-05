module main

import math

fn rotation(cx f32, cy f32, tx f32, ty f32, scale f32) f32 {
	delta_x := (cx * scale) - (tx * scale)
	delta_y := (cy * scale) - (ty * scale)
	rot := math.atan2(delta_y, delta_x)
	return f32(rot)
}

fn distance(x1 f32, y1 f32, x2 f32, y2 f32) f32 {
	dx := math.abs(x2 - x1)
	dy := math.abs(y2 - y1)
	dist := math.sqrt((dx * dx) + (dy * dy))
	return f32(dist)
}
