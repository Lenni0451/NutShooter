module main

import sokol.sgl
import sokol.sapp
import gx

const (
	player_radius = f32(25)
	player_speed  = f32(250)
)

struct Player {
mut:
	x f32 [required]
	y f32 [required]
}

fn (mut p Player) move(mut game Game) {
	width := game.gg.window_size().width
	height := game.gg.window_size().height

	move_speed := f32(player_speed * sapp.frame_duration())
	if game.input.w_down {
		p.y -= move_speed
	}
	if game.input.a_down {
		p.x -= move_speed
	}
	if game.input.s_down {
		p.y += move_speed
	}
	if game.input.d_down {
		p.x += move_speed
	}

	if p.x < 0 {
		p.x = width
	}
	if p.x > width {
		p.x = 0
	}
	if p.y < 0 {
		p.y = height
	}
	if p.y > height {
		p.y = 0
	}
}

fn (mut p Player) render(mut game Game) {
	ctx := game.gg
	width := ctx.window_size().width
	height := ctx.window_size().height

	if p.x <= player_radius {
		p.render_sprite(mut game, p.x + width, p.y, ctx.mouse_pos_x + width, ctx.mouse_pos_y)
	}
	if p.x >= width - player_radius {
		p.render_sprite(mut game, p.x - width, p.y, ctx.mouse_pos_x - width, ctx.mouse_pos_y)
	}
	if p.y <= player_radius {
		p.render_sprite(mut game, p.x, p.y + height, ctx.mouse_pos_x, ctx.mouse_pos_y + height)
	}
	if p.y >= height - player_radius {
		p.render_sprite(mut game, p.x, p.y - height, ctx.mouse_pos_x, ctx.mouse_pos_y - height)
	}
	p.render_sprite(mut game, p.x, p.y, ctx.mouse_pos_x, ctx.mouse_pos_y)
}

fn (mut p Player) render_sprite(mut game Game, x f32, y f32, mx f32, my f32) {
	ctx := game.gg

	sgl.push_matrix()
	sgl.translate(x * ctx.scale, y * ctx.scale, 0)
	sgl.rotate(rotation(ctx, x, y, mx, my), 0, 0, 1)
	ctx.draw_rect_filled(-50, -12, 50, 24, gx.green)
	sgl.pop_matrix()
	ctx.draw_circle_filled(x, y, player_radius, gx.blue)
}
