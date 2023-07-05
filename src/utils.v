module main

import gg
import math

fn rotation(ctx gg.Context, cx f32, cy f32) f32 {
	delta_x := (cx * ctx.scale) - (ctx.mouse_pos_x * ctx.scale)
	delta_y := (cy * ctx.scale) - (ctx.mouse_pos_y * ctx.scale)
	rot := math.atan2(delta_y, delta_x)
	return f32(rot)
}
