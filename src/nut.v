module main

import math
import gx

const (
	nut_radius = 10
)

enum NutStatus {
	alive
	dead
}

struct Nut {
mut:
	status NutStatus = .alive
	x      f32
	y      f32
	angle  f32
}

fn Nut.new(mut game Game) Nut {
	nut := Nut{
		x: game.player.x
		y: game.player.y
		angle: f32(math.atan2(game.gg.mouse_pos_y - game.player.y, game.gg.mouse_pos_x - game.player.x))
	}
	return nut
}

fn (mut n Nut) move(mut game Game) {
	n.x += f32(math.cos(n.angle) * 5)
	n.y += f32(math.sin(n.angle) * 5)
	if n.x < -nut_radius || n.x > game.gg.window_size().width + nut_radius || n.y < -nut_radius
		|| n.y > game.gg.window_size().height + nut_radius {
		n.status = .dead
	}
}

fn (mut n Nut) render(mut game Game) {
	game.gg.draw_circle_filled(n.x, n.y, nut_radius, gx.yellow)
}
