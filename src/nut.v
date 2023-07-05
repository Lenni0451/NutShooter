module main

import math
import gx
import sokol.sapp

const (
	nut_radius = f32(10)
	nut_speed  = f32(425)
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
	n.x += f32(math.cos(n.angle) * nut_speed * sapp.frame_duration())
	n.y += f32(math.sin(n.angle) * nut_speed * sapp.frame_duration())
	if n.x < -nut_radius || n.x > game.gg.window_size().width + nut_radius || n.y < -nut_radius
		|| n.y > game.gg.window_size().height + nut_radius {
		n.status = .dead
	}

	if n.status == .alive {
		for mut meteor in game.meteors {
			if meteor.status == .dead {
				continue
			}

			dist := distance(n.x, n.y, meteor.x, meteor.y)
			if dist < meteor.size + nut_radius {
				n.status = .dead
				meteor.status = .dead
				game.score += 1
			}
		}
	}
}

fn (mut n Nut) render(mut game Game) {
	game.gg.draw_circle_filled(n.x, n.y, nut_radius, gx.yellow)
}
