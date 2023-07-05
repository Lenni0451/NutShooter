module main

import gg
import math

fn rotation(ctx gg.Context, cx f32, cy f32, tx f32, ty f32) f32 {
	delta_x := (cx * ctx.scale) - (tx * ctx.scale)
	delta_y := (cy * ctx.scale) - (ty * ctx.scale)
	rot := math.atan2(delta_y, delta_x)
	return f32(rot)
}
