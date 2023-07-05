module main

import sokol.sgl
import gx

struct Player {
mut:
	x f32 [required]
	y f32 [required]
}

fn (p Player) render(mut game Game) {
	ctx := game.gg

	sgl.push_matrix()
	sgl.translate(p.x * ctx.scale, p.y * ctx.scale, 0)
	sgl.rotate(rotation(ctx, p.x, p.y), 0, 0, 1)
	ctx.draw_rect_filled(-50, -12, 50, 24, gx.green)
	sgl.pop_matrix()
	ctx.draw_circle_filled(p.x, p.y, 25, gx.blue)
}
